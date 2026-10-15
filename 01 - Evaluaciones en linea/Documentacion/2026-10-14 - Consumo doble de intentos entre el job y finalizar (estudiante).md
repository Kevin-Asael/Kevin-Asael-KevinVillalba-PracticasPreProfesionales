# Consumo doble de intentos entre el job de auto-calificación y `/finalizar` (estudiante)

Fecha: 2026-10-14
Repo: `utn-movil-portafolio-estudiante`, módulo `evaluacion_online`

## Qué pasaba

Una sola entrega podía descontar **dos intentos** con una única nota. Pasa cuando dos vías califican el mismo intento a la vez:

- el job de BullMQ, que corre en `fechaFin + 1 min` (`DELAY_AUTO_CALIFICAR_MINUTOS`);

Las dos leían `ENTREGADO='NO'` y las dos llamaban a `UTNDB.LMS_PRC_CALIFICAR_EVALUACION`, que hace `INTENTOS_DISPONIBLES - 1` en su `UPDATE` sin mirar `ENTREGADO` (verificado con `obtener_ddl`, línea 55 del procedimiento). Lo mismo valía para el anti-copia (`finalizarPorAntiCopia`) y para el cierre del intento vencido al reabrir el formulario.

## Dónde estaba

- `evaluacion_online.service.ts`: `finalizarEvaluacion` leía las reglas **antes** de tomar `finalizacionesEnCurso`, y ese `Set` es del servicio.
- `processor/evaluacion-auto-calificar.processor.ts`: el worker lee las reglas y llama al repositorio sin pasar por el servicio, así que ni veía el candado.

## Evidencia (dev, 2026-10-13)

Actividad 627204, `idActividadAlumno` 18518240, estudiante de prueba <cuenta-de-prueba>, evaluación de 1 minuto con la red cortada hasta que vence.

| Hora UTC | Evento |
|---|---|
| 20:52:48.014 | el job inicia la auto-calificación |
| 20:52:48.067 | entra `/finalizar` (53 ms después) |
| 20:52:48.395 | el job termina «auto-calificada exitosamente» |
| 20:52:48.453 | `/finalizar` responde 204 |

Resultado: una nota, intentos **3 → 1**. Antes, Codex había reproducido 2 → 0 con el job y `/finalizar` a 57 ms.

La ventana es de ~0,3 s: de cuatro pruebas manuales, solo una cayó dentro. Fuera de ella el descuento fue exactamente uno.

No lo causó el anti-copia ni la cola de salidas sin red de la app: es una carrera propia del backend que ya existía.

## Corrección

Nuevo `finalizacion_unica.ts` con `finalizarSiNoEntregada(repositorio, idActividadAlumno, cedula)`:

2. con el turno tomado, **vuelve a leer** `ENTREGADO`;
3. si ya estaba entregado devuelve `false` y no califica; si no, califica y devuelve `true`.

Lo usan `finalizarEvaluacion`, `finalizarPorAntiCopia` y el processor. Quien llega segundo **espera** en vez de fallar: si la primera vía falla en Oracle, la que esperaba sí califica, así que el job sigue siendo la red de seguridad. `cancelarAutoCalificacion` solo corre cuando esa llamada entregó de verdad.

El 403 «ya existe una finalización en curso» (doble toque) no cambia.

## Tests

- Módulo `evaluacion_online`: 124 de 124 (antes 111, con 2 en rojo).
- Los dos del spec de Codex (`evaluacion_online.auditoria-concurrencia.spec.ts`) pasan sin modificarlos.
- 7 casos de carrera en `evaluacion_online.conectividad.spec.ts` y 6 unitarios en `finalizacion_unica.spec.ts`. Probado revirtiendo el servicio: 6 de los 7 de carrera fallan sin el arreglo.
- Un test existente de `evaluacion_online.service.spec.ts` pasó de esperar 2 lecturas de reglas a 3 (la recomprobación con el turno).
- Suite completa del repo: 403 de 403 antes de añadir los últimos 6; `tsc` limpio.

## Límites y pendientes

- **Cambio de Oracle (DBA):** que el `UPDATE` que descuenta lleve `AND NVL(ENTREGADO,'NO') <> 'SI'`. No se aplicó ni se ejecutó nada contra Oracle.

## Cómo probar


## Relacionado

- [[2026-09-18 - Intentos fantasma en evaluacion online - diagnostico verificado y plan de correccion]]
