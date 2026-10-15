# CREA-03 — Pregunta de respuesta única con cero alternativas correctas

**Fecha:** 2026-09-08 · **Tipo:** Creación / Validación · **Severidad:** Alta
**Dónde:** Portafolio Docente, módulo Banco de Preguntas

## Precondiciones

- Acceso al banco de preguntas del curso.

## Pasos

1. Crear una pregunta nueva de tipo **Respuesta Única** (tipo 1).
2. Agregar 3-4 alternativas, marcando **todas como incorrectas** (`estado = 'N'` en todas, ninguna
   `'S'`).
3. Guardar. Observar si se acepta.
4. Añadir esa pregunta a un cuestionario de evaluación en línea y, como estudiante, intentar
   responderla — observar qué pasa si no hay ninguna alternativa "correcta" contra la que
   comparar.

## Resultado según el código

**Se acepta sin ningún error.** `TipoPreguntaValidationCreacionPipe.validarRespuestaUnica`
(`tipo_pregunta_validation_pipe_creacion.ts:40-60`) sólo valida que cada `estado` sea `'S'` o
`'N'` (`:46-50`). La regla que debería exigir *exactamente una* correcta está literalmente
comentada en el código:

```ts
// if (respuestasCorrectas !== 1) {
//     throw new BadRequestException('Debe haber exactamente una respuesta correcta');
// }
```

Con cero alternativas marcadas `'S'`, ningún estudiante puede acertar esa pregunta — queda
imposible de responder correctamente por diseño, sin que nadie lo haya decidido a propósito.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con el código
- [ ] No coincide

## Relacionado

[[CREA-04 - Pregunta de respuesta unica con varias correctas]]
