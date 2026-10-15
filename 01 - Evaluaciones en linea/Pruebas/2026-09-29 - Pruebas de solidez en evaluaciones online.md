# Pruebas de solidez en evaluaciones online — 2026-09-29

Entorno: emulador `emulator-5554` (1080x2424), app `utn_movil_app` como estudiante `<cuenta-de-prueba>`, curso 54443 (MATERIA DE PRUEBA), actividades MCP-E01..E09 (ids 627182..627190), backend estudiante en dev, verificación en Oracle (`UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE`). Las cuatro pruebas pasaron.

## Resultados

| # | Prueba | Resultado | Veredicto |
|---|--------|-----------|-----------|
| 1 | Evaluación completa (MCP-E01, 12 preg.) y verificación en Oracle | 12/12 preguntas con respuesta guardada; nota mostrada 3.1 | OK |
| 2 | Cortar red 20 s tras responder todo, restaurar y finalizar (MCP-E09, 5 preg.) | Las 5 preguntas seguían en Oracle antes de finalizar; nota 3.5, 5/5 | OK |
| 3 | Salir de la app (HOME 5 s + force-stop) a mitad de una evaluación y volver (MCP-E02, 3 preg.) | El cronómetro continuó (13:49, no se reinició); la anticopia finalizó la evaluación («Se detectaron múltiples salidas de la app»); calificó lo guardado: nota 1.7, 3/3 | OK (anticopia funciona y califica) |
| 4 | Cortar red en el mismo instante de confirmar «Finalizar» (MCP-E03, 5 preg.) | El cliente mostró «Sin conexión / Reintentar», siguió en el formulario con el cronómetro corriendo; en Oracle 5 respuestas guardadas y **0 calificadas** (no se finalizó). Con la red de vuelta, Finalizar funcionó: nota 3.5, 5/5 | OK (no pierde respuestas y se puede reintentar) |
