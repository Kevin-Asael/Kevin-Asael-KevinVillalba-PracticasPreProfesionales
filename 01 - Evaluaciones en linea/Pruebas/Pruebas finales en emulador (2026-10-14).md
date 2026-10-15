# Pruebas finales de la evaluación en línea (2026-10-14)


| Caso | Resultado | Evidencia |
|---|---|---|
| Entrega manual con respuestas | PASA | 1 `/finalizar` 204, job cancelado, nota 3.0, intentos 3 → 2 |
| Se agota el tiempo con app abierta y con red | PASA | finaliza solo ~1,7 s después del fin; 1 intento (2 → 1); resultado a los ~3 s |
| Sin red al vencer, vuelve **antes** del job y pulsa «Reintentar» | PASA | 1 `/finalizar` 204, job cancelado, una nota |
| Sin red al vencer, el **job califica** y luego vuelve y pulsa «Reintentar» | PASA | job 19:58:47; reintento 204 en 96 ms (no-op); intentos 3 → 2 |
| Continuidad al vencer el tiempo | PASA | Una finalización observada, intentos 3 → 2 |
| Integración de las vías de cierre (13/10) | PASA | Una calificación registrada y cancelación del job |
| Texto escrito **con** red | PASA | 4 `responder` 204 (2 texto, 2 opción); «Respondió 4» |
| Respuestas escritas **sin** red y vence el tiempo | Comportamiento esperado | la pantalla dice «Sin conexión, respuesta no guardada»; no se reenvían; se pierden |
| Respuestas entre intentos | Por diseño | se conservan las del intento anterior; la nota del nuevo reemplaza a la anterior |

## Resultado

- La nota siempre fue la de las respuestas guardadas; un `0.0` solo apareció con 0 respuestas.
- En los escenarios observados no se registraron descuentos duplicados. La carrera del arreglo posterior seguía pendiente de validación.
- No hubo errores `5xx` ni `ORA-` en los logs del servidor durante las pruebas.
- Las alternativas cambian de orden en cada carga de la pregunta (comportamiento del sorteo).

## Siguientes pasos

- **Desplegar el arreglo del consumo doble** (rama `fix/evaluacion-consumo-doble-intentos`, `2d0c04c`, 124 pruebas del módulo en verde) y repetir en dev la entrega coincidiendo con el job. Estas pruebas corrieron contra la versión anterior del servidor. Detalle en [[2026-10-14 - Consumo doble de intentos entre el job y finalizar (estudiante)]].
- **Pruebas por API** con la colección `Estudiante - Evaluaciones - Pruebas finales` (Postman) y el script de `curl`: ráfagas de `/finalizar` y la entrega a distintos milisegundos del job.
- **Casos de ventana:** la ventana de la actividad cerrando antes que el cronómetro, y los dos venciendo en el mismo segundo.
- **Mejoras de experiencia:** las descritas en [[Conectividad durante el examen]].
