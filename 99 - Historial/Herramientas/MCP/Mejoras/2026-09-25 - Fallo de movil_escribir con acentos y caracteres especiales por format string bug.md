# Fallo de movil_escribir con acentos y caracteres especiales por format string bug

## Tipo
Bug de ejecución / Confiabilidad ADB

## Qué pasó
Al intentar escribir textos con tildes o caracteres especiales en español (como `¿`, `á`, `é`, `í`, `ó`, `ú`) mediante `movil_escribir` o dentro de los parámetros de `movil_crear_actividad_docente` (por ejemplo en el campo `instrucciones: "Evaluación de prueba MCP"` o en preguntas como `"¿Cuál es el océano..."`), el comando falló arrojando una excepción de Android:
```text
Command failed: adb shell input text Evaluación%!s(MISSING)de%!s(MISSING)prueba%!s(MISSING)MCP
Exception occurred while executing 'text':
java.lang.NullPointerException: Attempt to get length of null array
    at com.android.server.input.InputShellCommand.runText
```
El fallo presenta dos causas críticas acopladas:
1. **Format string bug en el servidor MCP:** La sustitución de espacios por `%s` generó una cadena con `%!s(MISSING)` debido a que la plantilla de comandos de Go/Node interpretó el `%s` como un especificador de formato no suministrado.
2. **Incompatibilidad nativa de `adb shell input text`:** El comando binario `input text` de Android en versiones modernas no soporta de forma transparente caracteres UTF-8 extendidos (como signos de apertura de interrogación o vocales tildadas) sin codificación especial o teclado virtual ADB.

Esto obligó a retirar todos los acentos y signos de apertura en las preguntas e instrucciones para que las llamadas pudieran ejecutarse.

## Propuesta
1. Corregir la rutina de formateo en el servidor MCP para escapar los símbolos de porcentaje (`%%s`) o evitar la interpolación por `printf` al construir el comando shell.
2. Para el soporte de texto internacional completo con acentos y caracteres en español:
   - Instalar y activar `ADBKeyBoard` en el dispositivo de pruebas e inyectar el texto vía broadcast intent: `adb shell am broadcast -a ADB_INPUT_TEXT --es msg 'Texto con tildes y símbolos'`
   - Alternativamente, usar Base64 con el comando `adb shell input text` o inyectar eventos de portapapeles (`clipboard paste`).

## Prioridad
Alta
