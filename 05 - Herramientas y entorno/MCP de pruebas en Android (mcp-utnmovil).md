# MCP de pruebas en Android (`mcp-utnmovil`)


## Qué permite

| Herramienta | Uso |
|---|---|
| `movil_tocar`, `movil_tocar_texto`, `movil_deslizar`, `movil_tecla`, `movil_escribir` | interactuar como el usuario |
| `movil_ejecutar_secuencia`, `movil_guion` | varios pasos en una sola llamada, con esperas exactas |
| `movil_controlar_red` | cortar y devolver wifi y datos (se restauran solos a los 120 s) |
| `movil_semilla` | escenarios repetibles: salir de la app N segundos (con o sin cierre forzado), abrir, iniciar, responder y finalizar una evaluación |
| `movil_crear_actividad_docente`, `movil_crear_pregunta_banco` | preparar datos como docente |
| `movil_aprendizajes` | resumen de fallos y lentitud registrados (ver abajo) |

## Registro de fallos y aprendizajes (2026-10-14)


## Cómo se usó

- Pruebas de la evaluación en línea en el emulador: salidas de la app, cortes de red, cierre forzado y la entrega pegada al job del servidor. Detalle en [[Pruebas finales en emulador (2026-10-14)]].
- Las capturas de la pantalla segura se toman de la ventana del emulador desde el PC (`PrintWindow`), porque la captura por ADB sale negra.
