# Evaluaciones en línea

Trabajo en el módulo de evaluación en línea de UTN Móvil: el estudiante rinde el examen en la app (`utn_movil_app`), el servicio `utn-movil-portafolio-estudiante` lo controla y califica, y el docente lo crea desde `utn-movil-portafolio-docentes`.

## Qué se hizo

| Tema | Resultado | Nota |
|---|---|---|
| Investigación Android vs iOS | por qué no hay la misma protección en las dos plataformas y el permiso especial de Apple (AAC) |  |
| Tiempo del examen | cronómetro contra la hora del servidor, inmune a cambios de hora del teléfono | [[Reloj de Oracle y tiempos del examen]] |
| Conexión inestable | respuestas que se reintentan, reintentos seguros en el servidor y estado visible por pregunta | [[Conectividad durante el examen]] |
| Intentos | ninguna vía descuenta un intento sin entrega; abrir la pantalla no borra la nota | [[Intentos fantasma - diagnostico y correccion]] |
| Intentos (carrera con el job) | una sola calificación aunque coincidan el job, `/finalizar` y el anti-copia | [[2026-10-14 - Consumo doble de intentos entre el job y finalizar (estudiante)]] |
| Respuestas de opción múltiple | marcar dos veces no duplica la respuesta | [[2026-09-07 - Fix aplicado - Idempotencia en respuestas de opcion multiple (estudiante)]] |
| Web o móvil | al crear la evaluación, el docente elige dónde se rinde; la app respeta la elección | [[04 - Docentes - PLATAFORMA_EVAL]] |
| Base de datos | los 5 procedimientos de la evaluación (`MVL_PRC_EVAL_*`) migrados y probados | [[01 - Estudiante - migracion de queries a MOVIL_UTN]] |

## Pruebas

- [[Pruebas finales en emulador (2026-10-14)]]: cada intento descuenta exactamente uno, la nota es la de lo guardado y el anti-copia no cobra dos veces.
- `Pruebas/Pruebas finales/`: casos validados en celular (`FINAL-01` a `FINAL-18`) y las baterías de pruebas automatizadas.
- `Pruebas/Casos por nivel y comportamiento/`: el catálogo de casos del lado docente y estudiante.

## Mejoras posibles

- **Guarda en Oracle:** que `LMS_PRC_CALIFICAR_EVALUACION` no descuente un intento ya entregado (cambio para el DBA; el servicio ya lo evita).
- **Mensaje de cierre según el motivo** (tiempo o actividad sospechosa) y reintento automático de la entrega al volver de mucho tiempo fuera de la app.
