# Evaluaciones en línea

El mecanismo de anti-copia ya existía con anterioridad. El trabajo documentado se centró en corregir bugs durante el traslado de su control al backend y en mejorar la estabilidad del módulo de evaluaciones. Véase [[Estabilidad de mecanismos existentes]].

El módulo comprende la app Flutter, el servicio del estudiante y el servicio del docente.

## Cambios documentados

| Tema | Alcance | Nota |
|---|---|---|
| Tiempo del examen | Sincronización con el servidor y tratamiento de cambios del reloj del dispositivo | [[Reloj de Oracle y tiempos del examen]] |
| Conexión inestable | Tratamiento de errores de envío y reintentos seguros | [[Conectividad durante el examen]] |
| Intentos | Reanudación explícita y conservación de la nota al abrir una evaluación entregada | [[Intentos fantasma - diagnostico y correccion]] |
| Finalización concurrente | Corrección del descuento duplicado cuando coinciden distintas vías de cierre | [[2026-10-14 - Consumo doble de intentos entre el job y finalizar (estudiante)]] |
| Opción múltiple | Idempotencia al registrar respuestas | [[2026-09-07 - Fix aplicado - Idempotencia en respuestas de opcion multiple (estudiante)]] |
| Plataforma | Selección de web o móvil desde la configuración docente | [[04 - Docentes - PLATAFORMA_EVAL]] |
| Base de datos | Migración de los procedimientos de evaluación | [[01 - Estudiante - migracion de queries a MOVIL_UTN]] |

## Validación y pendientes

- [[Pruebas finales en emulador (2026-10-14)]] distingue los resultados observados de las verificaciones pendientes del arreglo de concurrencia.
- `Pruebas/Pruebas finales/` contiene registros de validación manual y automatizada de sus respectivas fechas.
- Queda documentada una guarda adicional en Oracle para impedir el descuento de un intento ya entregado. Su aplicación corresponde al DBA.
- Las pruebas históricas no sustituyen la validación de la versión desplegada antes de producción.
