# Estabilidad de mecanismos existentes

El mecanismo de anti-copia ya existía con anterioridad. El trabajo recogido en estas notas se concentró en solucionar bugs durante el traslado de su control al backend y en estabilizar su integración con el flujo de evaluación.

## Alcance del mantenimiento

Se documentaron correcciones de consistencia entre cliente y servidor, reanudación de intentos, conservación de calificaciones y tratamiento de errores de conectividad. También se corrigió una condición de carrera entre distintas vías de finalización que podía descontar más de un intento por una sola entrega.

La finalidad de estos cambios es mantener un estado coherente de la evaluación y evitar descuentos duplicados. Esta nota resume el mantenimiento sin detallar las reglas internas del mecanismo existente.

## Evidencia y límites

Los registros de septiembre incluyen una suite del servicio existente, identificada como preexistente y sin cambios. El diagnóstico de octubre documenta por separado el problema de concurrencia y su corrección; no atribuye ese fallo a la creación del mecanismo.

Los resultados corresponden a las versiones y fechas indicadas en cada registro. Las pruebas de emulador del 14 de octubre se realizaron contra una versión anterior al arreglo de consumo doble, por lo que no constituyen una validación de ese arreglo desplegado.

## Referencias

- [[2026-10-14 - Consumo doble de intentos entre el job y finalizar (estudiante)]]
- [[Pruebas finales en emulador (2026-10-14)]]
- [[FINAL-08 - Suite Maestra Automatizada Frontend y Backend ✅]]
