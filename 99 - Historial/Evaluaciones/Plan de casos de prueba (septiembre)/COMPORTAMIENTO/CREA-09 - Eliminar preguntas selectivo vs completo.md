# CREA-09 — Eliminar preguntas: selectivo vs. borrado completo

**Fecha:** 2026-09-08 · **Tipo:** Regla de negocio / Contraste de guardas · **Severidad:** Alta
**Dónde:** Portafolio Docente (`utn-movil-portafolio-docentes`)

## Precondiciones

- Una evaluación en línea con cuestionario asignado (varias preguntas).
- Al menos un estudiante que ya haya respondido (finalizado o no).

## Pasos

1. Con respuestas de estudiantes ya registradas, intentar **eliminar una sola pregunta** del
   cuestionario (endpoint de eliminación selectiva, `eliminar-preguntas`). Observar si se acepta
   o se rechaza.
2. Sobre la misma actividad, intentar **borrar el cuestionario entero** (endpoint `DELETE
   /actividad/evaluacion/:idActividad`). Observar si se acepta o se rechaza.
3. Comparar los dos resultados.

## Resultado según el código

**Comportamiento asimétrico, verificado en el propio código:**

- **Eliminación selectiva** — `eliminarPreguntasEvaluacion` (`actividad.service.ts:1161-1203`):
  sólo cuenta preguntas antes/después (igual patrón que
  [[CREA-08 - Agregar preguntas despues de rendido]]), **sin ninguna comprobación de respuestas
  existentes**. Se acepta sin error aunque haya estudiantes que ya respondieron esa pregunta
  específica.
- **Borrado completo del cuestionario** — `eliminarPreguntasCuestionario`
  (`:938-943`): **sí** llama a `validarEvaluacionTieneRespuestas` y **rechaza** con
  *"No se pueden eliminar las preguntas del cuestionario porque tiene respuestas de
  estudiantes."*.

La guarda existe, pero sólo protege el camino de "borrar todo" — el camino más granular (quitar
preguntas una por una) la evita por completo. El resultado práctico: un docente puede lograr el
mismo efecto destructivo (dejar a un estudiante ya respondido con una pregunta menos, o esa
pregunta desaparecida del cuestionario) por la puerta que **no** tiene guarda, simplemente
eliminando las preguntas de una en una en vez de borrar todo el cuestionario de un golpe.

Consecuencia sobre la calificación: si se elimina una pregunta que un estudiante ya respondió, sus
respuestas guardadas en `LMS_TAB_RESPUESTAS_ESTUDIANTE` para esa pregunta quedan huérfanas —
apuntando a una fila que ya no está en `LMS_TAB_PREGUNTAS_CUESTIONARIO` — y el denominador de la
fórmula de nota (`numPreguntas`, ver CREA-08) cambia hacia abajo en vez de hacia arriba.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con el código
- [ ] No coincide

## Relacionado

[[CREA-08 - Agregar preguntas despues de rendido]]
