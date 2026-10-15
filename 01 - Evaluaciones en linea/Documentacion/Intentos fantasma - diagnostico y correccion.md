# Intentos fantasma — diagnóstico y corrección

Módulo `evaluacion_online` · backend `utn-movil-portafolio-estudiante` (`f251262`, 2026-09-18) · app `utn_movil_app` (`dfaf7002b`)

## El problema

Al perder internet cerca del fin y volver, el estudiante a veces perdía 2 o más intentos por una sola entrega, y en algún caso la nota ya registrada desaparecía.

## Cuándo se descuenta un intento


## Los tres fallos (reproducidos en dev con los logs del servidor)

| Fallo | Qué pasaba | Evidencia |
|---|---|---|
| Abrir una evaluación entregada reanudaba sola | borraba la nota y abría un intento que luego vencía y se descontaba | actividad 627133: `/resultado` 200 y, tras abrir el formulario, 404 |
| Cierre del intento vencido y reanudación en la misma petición | un solo toque descontaba el intento viejo y abría otro | actividad 627134: 2 intentos por una entrega |
| `403` al reintentar `/finalizar` | si el servidor ya había entregado y la respuesta se perdía, «Reintentar» mostraba error | — |

## Corrección

- **Reanudar solo a pedido:** el formulario recibe `?reanudar=true` únicamente desde el botón de iniciar evaluación. Sin el parámetro, una evaluación entregada responde 403 y la nota no se toca.
- **Cierre del vencido sin encadenar:** cierra el intento vencido y termina la petición con un 403 que explica que ya fue calificado; el estudiante decide si abre otro.
- **`/finalizar` idempotente:** sobre un intento entregado responde 204 sin volver a calificar.
- **Pruebas:** nueva suite `evaluacion_online.conectividad.spec.ts` con un Oracle simulado que cuenta intentos; 103 pruebas del módulo en verde al cerrar el cambio.

## Comprobado

