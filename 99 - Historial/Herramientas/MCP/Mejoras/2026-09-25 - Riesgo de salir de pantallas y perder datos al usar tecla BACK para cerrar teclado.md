# Riesgo de salir de pantallas y perder datos al usar tecla BACK para cerrar teclado

## Tipo
Usabilidad / Robustez en automatización ADB

## Qué pasó
Durante el llenado de formularios extensos (como el de creación de preguntas y emparejamiento), se requería cerrar el teclado en pantalla para visualizar los campos inferiores. 
Al enviar el evento de tecla de sistema `movil_tecla(tecla: "BACK")`:
1. Si el teclado en pantalla estaba efectivamente abierto, el evento lo cerraba correctamente.
2. Sin embargo, en situaciones donde el teclado ya se había cerrado automáticamente (por ejemplo, debido a una navegación por foco `TAB` en Flutter, o una pérdida transitoria de foco), el evento `BACK` fue recibido directamente por la pila de navegación de la aplicación (`Navigator.pop()`).
3. Esto provocó la salida abrupta de la pantalla `CrearPreguntaPage` perdiendo de inmediato todo el contenido que se había ingresado en el formulario sin confirmación previa.

## Propuesta
1. Agregar una herramienta o flag específica `movil_cerrar_teclado` en el MCP que consulte el estado real del teclado en Android antes de emitir cualquier acción (`adb shell dumpsys input_method | grep mInputShown`).
2. En caso de que el teclado esté visible, usar `adb shell input keyevent 111` (Escape) o un toque fuera de foco en vez de `BACK` (Keyevent 4), evitando así cualquier efecto secundario de navegación que cierre la pantalla activa.

## Prioridad
Media
