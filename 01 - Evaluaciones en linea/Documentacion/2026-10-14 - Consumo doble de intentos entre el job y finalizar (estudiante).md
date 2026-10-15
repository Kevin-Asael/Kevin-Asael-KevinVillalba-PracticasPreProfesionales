# Corrección del consumo doble de intentos

Fecha del registro: 2026-10-14. Servicio: `utn-movil-portafolio-estudiante`, módulo `evaluacion_online`.

## Problema

Una condición de carrera preexistente en el backend permitía que dos vías de finalización calificaran el mismo intento. Ambas podían leer `ENTREGADO='NO'` antes de que la otra terminara y llamar al procedimiento de calificación, que descontaba un intento en cada ejecución.

La reproducción registrada en desarrollo el 13 de octubre mostró una sola nota y un cambio de intentos **3 → 1** cuando el job y `/finalizar` coincidieron con 53 ms de diferencia. El problema estaba en la coordinación de las vías de cierre existentes.

## Corrección documentada

`src/modules/evaluacion_online/finalizacion_unica.ts` incorpora `finalizarSiNoEntregada`:

1. Serializa las finalizaciones por `idActividadAlumno`.
2. Una vez obtenido el turno, vuelve a leer el estado de entrega.
3. Si ya está entregado, no vuelve a calificar. En caso contrario, califica y comunica si realizó la entrega.

La entrega manual, los cierres automáticos y el job utilizan la misma coordinación. Si una vía falla, la siguiente puede volver a comprobar el estado e intentar completar la entrega. La cancelación del job depende de que la llamada haya entregado efectivamente.

## Pruebas registradas

- Módulo `evaluacion_online`: **124/124** pruebas.
- Siete casos de concurrencia y seis pruebas unitarias del helper. Al retirar la corrección del servicio, fallaron seis de los siete casos de concurrencia.
- Los dos casos existentes de auditoría de concurrencia pasaron sin modificaciones.

Estas cifras son resultados del registro original; no se ejecutaron de nuevo para editar esta documentación.

## Límites y validación pendiente

La coordinación descrita es local al proceso. Este registro no demuestra exclusión entre varias instancias del servicio.

Se propuso una guarda adicional en el `UPDATE` de Oracle: `AND NVL(ENTREGADO,'NO') <> 'SI'`. No se documenta aquí como aplicada.

Las [[Pruebas finales en emulador (2026-10-14)]] se realizaron con una versión anterior del servidor. Quedaba pendiente desplegar el arreglo y repetir la carrera entre el job y `/finalizar`, comprobando que una entrega descuente exactamente un intento.
