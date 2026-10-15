# Conectividad durante el examen

Módulo `evaluacion_online` · app `utn_movil_app` · backend `utn-movil-portafolio-estudiante`

## Qué ve el estudiante con cada respuesta

- **Opción, múltiple y emparejamiento:** se envían al tocarlas. La pregunta muestra «Respuesta guardada» o «Sin conexión, respuesta no guardada».
- **Texto:** se reintenta solo (2, 4, 8… hasta 30 s) y al volver la red; antes de entregar se intenta subir lo pendiente.
- **Lo que llega después de la hora de fin no se acepta:** el servidor rechaza respuestas de un intento vencido, así que el minuto de margen del job sirve para que llegue la **entrega**, no respuestas nuevas.

## Reintentos seguros en el servidor

- **Opción múltiple** (`26db164`): marcar la misma alternativa dos veces deja una sola fila activa. Comprobado con dos envíos iguales: 204 y 204, y 1 fila en Oracle. Detalle en [[2026-09-07 - Fix aplicado - Idempotencia en respuestas de opcion multiple (estudiante)]].
- **`/finalizar`** (`f251262`): sobre un intento ya entregado responde 204 sin volver a calificar.
- **Una sola calificación por intento** cuando coinciden el job, `/finalizar` y el control de evaluación: [[2026-10-14 - Consumo doble de intentos entre el job y finalizar (estudiante)]].

## Comprobado en el emulador (2026-10-13 y 14)

| Caso | Resultado |
|---|---|
| Sin red al vencer el tiempo, vuelve antes del job y pulsa «Reintentar» | una entrega, un intento |
| Sin red al vencer, el job califica y luego vuelve y pulsa «Reintentar» | el reintento no vuelve a calificar; un intento |
| Respuestas marcadas sin red | la pregunta lo indica y la nota no las incluye |

## Mejoras posibles

- Tras una interrupción, la finalización automática puede mostrar un error antes de que otra vía complete la entrega. Queda pendiente evaluar un reintento controlado y mejorar el mensaje.
- Un resumen cerca del cronómetro con cuántas respuestas siguen sin guardar.
