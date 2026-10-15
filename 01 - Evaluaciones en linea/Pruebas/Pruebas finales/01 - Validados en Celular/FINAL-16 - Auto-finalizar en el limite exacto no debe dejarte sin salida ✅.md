# FINAL-16 — Auto-finalizar en el límite exacto no debe dejarte sin salida

**Fecha:** 2026-09-11 · **Tipo:** Cronómetro / Backend + Frontend · **Severidad:** Crítica
**Dónde:** backend NestJS (`utn-movil-portafolio-estudiante`) + app Flutter (`utn_movil_app`)

Documenta un fallo al coincidir el vencimiento del cronómetro y el plazo general: el servidor rechazaba la finalización y la pantalla permanecía cargando sin una acción de recuperación.

## Precondiciones

- Una actividad configurada para que el cronómetro llegue a 0 **justo cuando** vence el plazo
  general de la actividad (`fechaFin`) para reproducir la coincidencia de ambos límites.

## Pasos — parte A (caso real: el fix de fondo)

1. Iniciar el examen y dejar que corra hasta que el cronómetro llegue a 0 sin tocar "Finalizar".
2. Observar qué pasa en el instante exacto en que llega a cero.
3. **Esperado:** finaliza automáticamente sin error, navega a resultados con el aviso "El tiempo
   se ha agotado. La evaluación se ha finalizado automáticamente." — **no** debe aparecer "No se
   pudo finalizar automáticamente la evaluación".

## Pasos — parte B (red de seguridad: si falla por otra razón)

4. Si por cualquier otro motivo el auto-finalizar sí falla (cortar la conexión justo en ese
   instante, por ejemplo), observar la pantalla del overlay "Tiempo agotado".
5. **Esperado:** ya NO debe quedarse girando para siempre. Debe cambiar a un ícono de error +
   botón **"Reintentar"** + botón **"Volver"** — sin necesidad de minimizar la app para escapar.
6. Tocar "Volver": debe regresar a la pantalla anterior sin cerrar ni minimizar la app (conservando el flujo de navegación).
7. Tocar "Reintentar" (con la red ya restaurada): debe volver a intentar `finalizarEvaluacion` y,
   si tiene éxito, navegar a resultados igual que en la parte A.

## Resultado según el código

1. Backend (`evaluacion_online.service.ts`, `validarAcceso`): antes, `permitirTiempoExpirado`
   sólo perdonaba `estadoActividad === 'NLT'` (intento vencido). Si el plazo general vencía en el
   mismo instante, Oracle devolvía `'NFF'` y el backend rechazaba `/finalizar` con 403 — la
   paradoja de bloquear la acción correcta cuando se acaba el tiempo. Ahora perdona ambos códigos.
2. Frontend (`evaluacion_online_provider.dart`): nuevo campo `autoFinalizarFallo`. Si el
   auto-finalizar falla, ya no se limita a mostrar un `AppSnackBar` y dejar la pantalla congelada
   — marca esta bandera para que la UI ofrezca una salida.
3. Frontend (`formulario_evaluacion_online_page.dart`): el overlay de "Tiempo agotado" ahora
   revisa `autoFinalizarFallo`. Si es `true`, reemplaza el spinner infinito por botones de
   reintentar (acción manual, no un loop automático) y volver (`Navigator.pop`, sin minimizar la
   app).

**Puntos clave a comprobar:**
- [x] Parte A: finaliza sin error en el límite exacto.
- [x] Parte B (si se logra provocar el fallo): aparecen los botones, no el spinner infinito.
- [x] "Volver" permite regresar a la pantalla anterior dentro del flujo de evaluación.

## Observación — qué pasó de verdad

> Validado en dispositivo Android de prueba: Se deshabilitó WiFi justo al expirar el temporizador (00:00:00). La UI reemplazó el loader por el overlay de error "No se pudo finalizar automáticamente la evaluación" junto con los botones "Reintentar" y "Volver", sin quedarse en spinner infinito. Al reactivar WiFi y pulsar "Reintentar", la entrega se completó exitosamente navegando a la pantalla de resultados con nota 2.0 y retroalimentación censurada.

## Estado

✅ Coincide con el código (validado).


## Relacionado

[[FINAL-02 - Pasan los 5 minutos y autofinaliza por tiempo ✅]] ·
 ·
[[FINAL-14 - Intento zombi con y sin intentos de sobra ✅]]
