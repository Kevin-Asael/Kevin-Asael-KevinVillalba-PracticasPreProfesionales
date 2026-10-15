# FINAL-02 — Pasan los 5 minutos y autofinaliza por tiempo

**Fecha:** 2026-09-10 · **Tipo:** Cronómetro / Ciclo de vida · **Severidad:** Crítica
**Dónde:** app Flutter (`utn_movil_app`) + backend NestJS (`utn-movil-portafolio-estudiante`)

Verifica que cuando el cronómetro llega naturalmente a cero (`00:00:00`), la app finalice automáticamente la evaluación y navegue a la pantalla de resultados sin intervención del estudiante.

> ⚠️ **Corrección 2026-09-11:** la versión anterior de esta nota describía un paso de "vaciar
> el buffer local de respuestas pendientes" con `_sincronizadorRespuestas.vaciar()` y un
> `_finalizarConBackoff()`. Ninguno de los dos existe en el código — no hay cola/buffer offline
> de respuestas en este módulo, nunca se llegó a implementar de verdad. Cada respuesta se envía
> reflejar el flujo real, verificado leyendo `evaluacion_online_provider.dart` completo.

## Precondiciones

- El estudiante ha respondido al menos 1 o 2 preguntas.
- Teléfono con conexión activa a internet.

## Pasos

1. Iniciar el examen y marcar 2 respuestas.
2. No tocar el botón "Finalizar Evaluación".
4. Observar la pantalla cuando el reloj toque cero.

## Resultado según el código

1. En Flutter (`evaluacion_online_provider.dart:134-159`), el timer de 1s detecta que el tiempo
   restante (calculado con el reloj dual — ver [[FINAL-03 - Atrasar el reloj del celular durante el examen ✅]] /
   [[FINAL-04 - Adelantar el reloj del celular durante el examen ✅]]) llegó a cero:
   ```dart
   final nuevoTiempoRestante = _tiempoRestanteActual ?? Duration.zero;
   if (nuevoTiempoRestante <= Duration.zero) {
     _tiempoRestante = Duration.zero;
     timer.cancel();
     if (!_autoFinalizando) {
       _autoFinalizando = true;
       finalizarEvaluacion(currentContext, idActividad, esAutoFinalizar: true);
     }
   }
   ```
2. `finalizarEvaluacion(...)` llama a `_evaluacionOnlineService.finalizarEvaluacion(idActividadAlumno)`
   (no hay respuestas pendientes que "vaciar" — cada respuesta ya se envió en tiempo real cuando
   el estudiante la marcó).
3. El servidor ejecuta el procedimiento Oracle `LMS_PRC_CALIFICAR_EVALUACION` — protegido desde
   llamada coincide con otra finalización en curso para el mismo intento.
4. Se limpia el marcador local del intento (`EvaluacionSalidaLocalStorage`, no un buffer de
   respuestas) para esa actividad.
5. La app redirige a la ruta `/estudiante/evaluacion-online/resultado` y muestra un `AppSnackBar`
   de aviso ("El tiempo se ha agotado...").
6. El estudiante ve su nota final; el detalle por pregunta solo se ve completo si el plazo
   general de la actividad ya cerró (ver [[FINAL-08 - Suite Maestra Automatizada Frontend y Backend ✅]]).

**Puntos clave a comprobar:**
- [x] La app se cierra sola al llegar a 00:00:00 (no se queda colgada esperando clic).
- [x] Redirige limpiamente a la pantalla de resultados.
- [x] Las respuestas marcadas se calificaron correctamente.

## Observación — qué pasó de verdad

> Paso exactamnete lo del codigo.

## Estado

✅ Coincide con el código (validado).


## Relacionado

[[FINAL-04 - Adelantar el reloj del celular durante el examen ✅]]
