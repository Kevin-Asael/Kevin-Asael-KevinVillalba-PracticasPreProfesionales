# Fix aplicado — Idempotencia en respuestas de opción múltiple (estudiante)

**Fecha:** 2026-09-07
**Repo:** `utn-movil-portafolio-estudiante`
**Rama:** `practicas-preprofesionales`
**Commit:** `26db164`

---

## 1. El problema

`toggleRespuestaMultiple` (preguntas de opción múltiple, `tipoPregunta=2` en evaluación online)
hacía un `INSERT` directo al marcar una alternativa **sin desactivar la fila anterior**. Si el
cliente reintentaba el mismo envío (porque nunca recibió el 204 de confirmación, aunque el
servidor sí hubiera guardado la respuesta), el segundo intento **duplicaba la fila** con
`ESTADO='A'` en `LMS_TAB_RESPUESTAS_ESTUDIANTE`.

Esto ocurría especialmente con el buffer offline (que reintenta automáticamente), pero también
podía pasar con doble-tap del usuario o latencia de red.

---

## 2. El fix

**Archivo:** `src/modules/evaluacion_online/repository/evaluacion_online.repository.ts`
**Rama:** `marcado=true` de `toggleRespuestaMultiple`

Ahora corre dentro de una **transacción** que:
1. Desactiva la fila previa: `UPDATE ... SET ESTADO='I'`
2. Inserta la nueva fila con `ESTADO='A'`

Mismo patrón que ya usaba `guardarRespuestaEmparejar`.

---

## 3. Verificación end-to-end

2. Dos `POST` idénticos al mismo `/responder` → ambos devolvieron 204
3. Consulta directa a Oracle: `SELECT COUNT(*) WHERE ESTADO='A'` → **1**, no 2

Confirmado que el fix funciona de verdad, no solo que no da error.

---

## 4. Estado

