# CREA-08 — Agregar preguntas después de que alguien ya rindió

**Fecha:** 2026-09-08 · **Tipo:** Regla de negocio · **Severidad:** Alta
**Dónde:** Portafolio Docente (`utn-movil-portafolio-docentes`)

## Precondiciones

- Una evaluación en línea con cuestionario ya sorteado o asignado (por ejemplo 5 preguntas).
- Al menos un estudiante que **ya haya finalizado y tenga nota**.

## Pasos

1. Con un estudiante ya calificado, anotar su nota final.
2. Como docente, usar **"Asignar Preguntas Manualmente"** (`agregar-preguntas`) para añadir **una
   pregunta más** al cuestionario de esa misma actividad.
3. Guardar. Observar si se acepta sin error.
4. Revisar la nota del estudiante que ya había sido calificado: ¿cambió, quedó igual, o se
   descuadra respecto al nuevo total de preguntas?
5. Si es posible, que otro estudiante rinda el examen **después** de agregada la pregunta nueva y
   comparar su cálculo de nota contra el del primero.

## Resultado según el código

**Se acepta sin ninguna comprobación de respuestas existentes.** `agregarPreguntasEvaluacion`
(`actividad.service.ts:1111-1158`) sólo cuenta preguntas antes/después de insertar
(`:1120`, `:1131`) para informar cuántas se agregaron — no valida en ningún momento si la
evaluación ya tiene respuestas de estudiantes.

Eso contrasta con la única guarda real que sí existe en el módulo, pero que protege un endpoint
distinto: `eliminarPreguntasCuestionario` (borrado **completo** del cuestionario,
`actividad.service.ts:938-943`) sí llama a `validarEvaluacionTieneRespuestas` y bloquea con
*"No se pueden eliminar las preguntas del cuestionario porque tiene respuestas de
estudiantes."* — pero esa guarda **no se replica** en `agregarPreguntasEvaluacion`.

**Por qué esto descuadra la nota:** el cálculo incremental de calificación
(`revision-respuestas.service.ts:212-223`, verificado en el lote de copia) usa
`numPreguntas` — el conteo de filas en `LMS_TAB_PREGUNTAS_CUESTIONARIO` — como denominador de la
fórmula `correctas/total*10`. Ese conteo se saca **en el momento de calificar**, así que:

- Si la pregunta nueva se agrega **después** de que el primer estudiante ya fue calificado, su
  nota ya calculada **no se recalcula sola** — sigue siendo la misma, calculada sobre el total
  viejo.
- Un estudiante que rinda **después** de agregada la pregunta la verá en su formulario y su nota
  se calculará sobre el nuevo total (una pregunta más).
- Resultado esperado: dos estudiantes del mismo curso, mismo examen, pueden terminar con notas
  calculadas sobre denominadores distintos (4 preguntas vs. 5), sin que nada en la UI lo indique.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con el código
- [ ] No coincide

## Relacionado

[[CREA-09 - Eliminar preguntas selectivo vs completo]]
