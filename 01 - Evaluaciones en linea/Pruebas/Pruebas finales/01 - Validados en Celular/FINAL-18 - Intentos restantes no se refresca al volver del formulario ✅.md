# FINAL-18 — "Intentos restantes" no se refresca al volver del formulario

**Fecha:** 2026-09-11 · **Tipo:** UI / Estado obsoleto · **Severidad:** Media
**Dónde:** app Flutter (`utn_movil_app`) — no es un bug de datos, solo de pantalla.

Hallazgo real: tras que un intento se consumiera dentro del formulario (por el auto-cierre de
[[FINAL-14 - Intento zombi con y sin intentos de sobra ✅]]), al volver a la pantalla de detalle de la
actividad seguía mostrando "Intentos restantes: 1" y el botón "Iniciar Evaluación" — aunque el
servidor ya no tenía intentos. Tocar el botón de nuevo correctamente rechazaba con "No tienes más
intentos disponibles", pero la pantalla de detalle nunca se actualizaba para reflejarlo, dando la
impresión de un loop confuso.

**Importante: no hay pérdida de datos.** El botón "Iniciar Evaluación" siempre revalida contra el
servidor (`getFormulario` fresco) — el problema es puramente visual: el texto "Intentos restantes"
se queda con el valor de antes de entrar.

## El mecanismo (verificado leyendo el código)

`DetallesActividadPage` (`detalles_actividad_page.dart`) es un `StatelessWidget` que crea su
`ChangeNotifierProvider` con `create: (_) => sl<DetallesActividadProvider>()..init(idActividadAlumno)`.
Ese `create` solo corre **una vez**, cuando el `Provider` se inserta por primera vez en el árbol.

`BotonesEvaluacionWidget._confirmarEIniciarEvaluacion` (`botones_evaluacion_widget.dart`) navegaba
con `context.push('/estudiante/evaluacion-online/formulario', ...)` — un `push`, no un `go`: la
`DetallesActividadPage` de abajo **nunca se destruye**, solo queda tapada. Al volver (por el botón
"Volver" nuevo de [[FINAL-16 - Auto-finalizar en el limite exacto no debe dejarte sin salida ✅]], por
el botón atrás, o por cualquier otra salida), es la **misma instancia** de siempre — su `create` no
vuelve a correr, así que `DetallesActividadProvider.init()` nunca se vuelve a llamar y el
`ActividadEntity` (con `intentosDisponibles`) nunca se refresca.

Confirmé además que el endpoint (`GET .../detalle`) **no está cacheado** por el sistema de caché
HTTP global (`api_cache_policy_service.dart:101-103` — sin una regla que haga match, `enabled`
cae a `false` por defecto), así que no era un problema de caché: era simplemente que nadie volvía
a pedir el dato.

## El fix aplicado (y el que faltó la primera vez)

`botones_evaluacion_widget.dart`: se captura `DetallesActividadProvider` antes del `push`, se
espera (`await`) a que la ruta del formulario se cierre (por cualquier motivo), y al volver se
llama `detallesProvider.init(idActividadAlumno)` de nuevo para refrescar "Intentos restantes" y la
nota con el estado real.

**Corrección sobre el primer fix (mismo día):** el botón "Evaluación" de la propia
`DetallesActividadPage` (`_buildActionBar`, cuando `esEvaluacionOnline` es `true`) **no** usa
`BotonesEvaluacionWidget` — tiene su propia copia duplicada de `_confirmarEIniciarEvaluacion`
(`detalles_actividad_page.dart:257-308`) con el mismo `context.push` sin refresco. El primer fix
solo tocó `botones_evaluacion_widget.dart` y dejó este segundo punto de entrada sin arreglar, por
por lo que la corrección inicial no se reflejaba al probarla en el dispositivo. Se aplicó el mismo
patrón (`read` antes del `push`, `await`, `init()` al volver) en ambos archivos. Confirmado por
grep que `BotonesEvaluacionWidget` sí se usa en otro lado
(`seccion_formulario_entregar_actividad_widget.dart`) — no es código muerto, son dos entradas
reales al mismo flujo que había que arreglar por separado.

## Pasos para repetirlo

1. Actividad con intentos limitados donde puedas agotar el último (p. ej. vía
   [[FINAL-14 - Intento zombi con y sin intentos de sobra ✅]]).
2. Desde el detalle de la actividad, tocar "Iniciar Evaluación", dejar que se consuma el último
   intento dentro del formulario (zombi, control de evaluación, o entrega normal), y volver a la pantalla de
   detalle.
3. **Esperado (con el fix):** "Intentos restantes" ya debe mostrar el número real (0), no el
   valor de antes de entrar.

**Puntos clave a comprobar:**
- [x] Al volver, "Intentos restantes" refleja el valor real, no el de antes de entrar.
- [x] Si aún quedan intentos, el número también se actualiza correctamente (no solo en el caso 0).

## Observación — qué pasó de verdad

> Validado en un dispositivo Android de prueba: el contador se actualizó al regresar al detalle tras distintos flujos de cierre, sin recarga manual. Al agotarse los intentos, la pantalla mostró la acción de cierre correspondiente.

## Estado

✅ Coincide con el código (validado).


## Relacionado

[[FINAL-14 - Intento zombi con y sin intentos de sobra ✅]] ·
[[FINAL-16 - Auto-finalizar en el limite exacto no debe dejarte sin salida ✅]] ·

