# Fallo en semilla agregar_preguntas por falta de scroll y conteo estricto

## Tipo
Bug en semilla de automatización / Flujo de interacción

## Qué pasó
Al invocar `movil_semilla(nombre: "agregar_preguntas", cantidad: 10)` desde la pantalla «Agregar Preguntas», la acción falló tras alcanzar el timeout de 20 segundos con el mensaje:
`FALLA agregar_preguntas (20.0 s): botón «Agregar (10)» no encontrado`.

Al inspeccionar el árbol de la interfaz de usuario, se constató que:
1. La pantalla «Agregar Preguntas» tiene dos paneles: «Preguntas Agregadas» (arriba) y «Preguntas Disponibles» (abajo).
2. Cuando «Preguntas Disponibles» se despliega, únicamente 1 a 3 preguntas resultan visibles simultáneamente en pantalla antes de cortarse con el borde inferior.
3. La implementación de la semilla `agregar_preguntas` solo marca los checkboxes que están visibles en ese momento en el viewport. Al haber solo 1 a 3 ítems visibles, marca esos pocos ítems (creando por ejemplo el botón `Agregar (1)` o `Agregar (3)`), y posteriormente espera en bucle a que aparezca un botón con el texto exacto `Agregar (10)`. Como nunca realiza un scroll vertical (`swipe`) para descubrir los siguientes ítems, la condición jamás se cumple y la herramienta termina en error.

## Propuesta
Modificar la lógica de la semilla `agregar_preguntas` en el MCP para:
1. Iterar marcando preguntas y, si el número de preguntas seleccionadas es inferior a `cantidad`, ejecutar un deslizamiento (`swipe`) hacia arriba en el listado para revelar y marcar preguntas adicionales.
2. Añadir soporte para tocar el botón `Seleccionar todo` o filtrar por prefijo/tema si se quiere una selección masiva.
3. Si tras recorrer la lista no hay suficientes preguntas disponibles, pulsar el botón con la cantidad máxima encontrada (`Agregar (N)`) en lugar de fallar por no alcanzar el número exacto.

## Prioridad
Alta
