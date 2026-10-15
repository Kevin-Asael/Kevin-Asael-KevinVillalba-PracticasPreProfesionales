# CREA-04 — Pregunta de respuesta única con varias alternativas correctas

**Fecha:** 2026-09-08 · **Tipo:** Creación / Validación · **Severidad:** Alta
**Dónde:** Portafolio Docente, módulo Banco de Preguntas → app estudiante

## Precondiciones

- Acceso al banco de preguntas del curso.

## Pasos

1. Crear una pregunta nueva de tipo **Respuesta Única** (tipo 1).
2. Agregar 4 alternativas y marcar **dos o más como correctas** (`estado = 'S'` en más de una).
3. Guardar. Observar si se acepta.
4. Añadirla a un cuestionario y, como estudiante (que sólo puede marcar **una** alternativa en
   una pregunta de tipo "única"), responder cualquiera de las correctas.
5. Revisar cómo se califica esa respuesta en la revisión del docente.

## Resultado según el código

**Se acepta sin ningún error** — mismo mecanismo que
[[CREA-03 - Pregunta de respuesta unica con cero correctas]]: `validarRespuestaUnica`
(`tipo_pregunta_validation_pipe_creacion.ts:40-60`) sólo exige que cada `estado` sea `'S'`/`'N'`;
la regla comentada (`:57-59`) es la misma que impediría esto — *"debe haber exactamente una"*
cubre tanto cero como más de una.

El resultado interesante está en el lado del estudiante, porque la UI de "respuesta única" fuerza
a elegir sólo una alternativa aunque el banco tenga varias marcadas como correctas. La pregunta
sigue siendo respondible y con más de una forma de acertarla — es menos grave en la práctica que
CREA-03 (imposible de acertar), pero confirma el mismo hueco de validación desde el otro extremo.

**Punto a verificar:** cómo se califica exactamente del lado del procedimiento
`LMS_PRC_CALIFICAR_EVALUACION` (código PL/SQL no disponible en ningún repo) — si compara la
alternativa marcada por el estudiante contra *cualquier* fila `estado='S'` de esa pregunta, la
respuesta debería salir correcta sin importar cuál de las "correctas" haya elegido el alumno.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con el código
- [ ] No coincide

## Relacionado

[[CREA-03 - Pregunta de respuesta unica con cero correctas]]
