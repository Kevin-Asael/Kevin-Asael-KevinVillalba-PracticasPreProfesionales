# Falta de semilla para creación automatizada de preguntas en el Banco de Preguntas

## Tipo
Funcionalidad faltante / Nueva semilla MCP

## Qué pasó
El MCP actual no cuenta con ninguna herramienta ni semilla automatizada para la creación de preguntas en el Portafolio Docente (p. ej. `movil_crear_pregunta_banco` o `movil_semilla(nombre: "crear_pregunta")`).
Para crear las 10 preguntas requeridas en esta tarea, fue necesario operar la interfaz gráfica paso a paso a través de ADB:
1. Abrir menú desplegable de tipos de pregunta y seleccionar la opción (Respuesta Única, Ensayo, Emparejamiento).
2. Abrir selector de contenido y elegir unidad.
3. Enfocar el editor enriquecido Quill (`EditorPreguntaQuillWidget`) e ingresar el enunciado mediante inyecciones de texto ADB.
4. Navegar a la sección de alternativas o pares de emparejamiento, identificar coordenadas dinámicas de campos de texto y radios/checkboxes.
5. Llenar cada alternativa/columna y marcar la respuesta correcta.
6. Guardar y esperar confirmación.

Este procedimiento elemento por elemento consumió una gran cantidad de llamadas MCP y tiempo de ejecución (aproximadamente 20-25 minutos en total), además de ser propenso a desajustes por el movimiento del scroll y el teclado.

## Propuesta
1. Una herramienta de alto nivel `movil_crear_pregunta_banco` que reciba:
   - `materia`: string (ej. "MATERIA DE PRUEBA")
   - `tipo`: "unica" | "multiple" | "ensayo" | "emparejamiento"
   - `contenido`: string / código
   - `enunciado`: string
   - `alternativas`: array de strings con flag `correcta` (o pares `{ columnaA, columnaB }` para emparejamiento)
2. La herramienta debe ejecutar el llenado en lote o comunicarse directamente con el provider/servicio de backend correspondiente, reduciendo la operación de decenas de minutos a menos de 5 segundos por pregunta.

## Prioridad
Alta
