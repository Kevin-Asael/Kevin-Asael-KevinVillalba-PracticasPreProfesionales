# Fix aplicado — Batching de consultas en revisión de respuestas (Docentes) — 2026-09-17

**Módulo:** `src/modules/revision-respuestas`  
**Commits:** `046b420` (en `fix/calificaciones-docente` y mergeado en `practicas-preprofesionales`)  
**Repositorio:** `utn-movil-portafolio-docentes`  
**Hubs:** [[00_Indice_Docentes]] ·  ·  · 

---

## 1. Contexto y Problema Detectado

Al consultar el cuestionario de un estudiante para revisión y calificación desde la aplicación móvil o cliente HTTP, la petición tardaba **~7.55 segundos** en responder (`Status 200 OK`).

```text
I/flutter (24644): 🟦 ║ Status Code: 200 OK
I/flutter (24644): 🟦 ║ ⚡ DURACIÓN TOTAL: 7554ms (7s 554ms)
```

La auditoría de logs del servidor confirmó que **7,418 ms** ocurrían dentro del backend en Node.js (no era latencia de red hacia el dispositivo móvil).

### Causa Raíz: Antipatrón 3N + 1 sobre el Connection Pool
1. Una consulta inicial a `LMS_TAB_PREGUNTAS_CUESTIONARIO` para obtener las preguntas ($N$).
2. Un bucle `cuestionario.map()` que para **cada pregunta** disparaba 3 consultas independientes a Oracle:
   - `getPreguntaByCodigo(item.preguntaCodigo)` sobre `LMS_TAB_PREGUNTAS`.
   - `getAlternativasRespuestaByPregunta(item.preguntaCodigo)` sobre `LMS_TAB_RESPUESTAS`.
   - `getRespuestasEstudianteByPregunta(item.preguntaCodigo, ...)` sobre `LMS_TAB_RESPUESTAS_ESTUDIANTE`.

Para una actividad con solo 5 preguntas:
$$1 + (5 \times 3) = \mathbf{16 \text{ consultas individuales a Oracle}}$$

En la réplica de desarrollo, cada round-trip individual de red hacia Oracle toma entre **~280ms y ~1.8s**. Al saturar el pool de conexiones de TypeORM (`poolMax`), las consultas se encolaron secuencialmente, sumando más de 7.4 segundos.

---

## 2. Solución Aplicada: Batching Relacional con `IN (...)`

Se sustituyeron las consultas unitarias por consultas por lote agrupadas, reduciendo el flujo a **4 consultas fijas** sin importar el número de preguntas:

1. **Consulta 1:** Obtiene los códigos únicos de las preguntas del cuestionario:
   ```typescript
   const codigosPregunta = [...new Set(cuestionario.map(item => item.preguntaCodigo))];
   ```
2. **Consultas 2, 3 y 4 (Disparadas simultáneamente en un único `Promise.all`):**
   - Una consulta para traer todas las preguntas: `WHERE PRE.CODIGO IN (:codigo0, :codigo1, ...)`
   - Una consulta para traer todas las alternativas: `WHERE RES.CODIGO_PREGUNTA IN (:codigo0, ...)`
   - Una consulta para traer todas las respuestas del alumno: `WHERE REST.CODIGO_PREGUNTA IN (:codigo0, ...) AND REST.CEDULA_ESTUDIANTE = :cedula`
   Al llegar todas las alternativas y respuestas en bloques, se indexan mediante `Map` en la memoria del servidor en menos de 1 ms, mapeando el DTO final de forma sincrónica.

---

## 3. Archivos Modificados en el Repositorio

  Sustituido por `buildPreguntasQuery(cantidad: number)` generando placeholders dinámicos `:codigo0, :codigo1...`.
  Generador `buildAlternativasRespuestaQuery(cantidad: number)` proyectando la clave foránea `RES.CODIGO_PREGUNTA`.
  Generador `buildRespuestasEstudianteQuery(cantidad: number)` proyectando `REST.CODIGO_PREGUNTA`.
  Añadido campo `@Expose({ name: 'CODIGO_PREGUNTA' }) preguntaCodigo: number`.
  Añadido campo `@Expose({ name: 'CODIGO_PREGUNTA' }) preguntaCodigo: number`.
  Reemplazados métodos unitarios por `getPreguntasByCodigos`, `getAlternativasRespuestaByPreguntas` y `getRespuestasEstudianteByPreguntas`.
  Eliminación del bucle async; ejecución con `Promise.all` plano y agrupación con `Map`.

---

## 4. Estado y Validación

| Validación | Resultado | Detalle |
|---|:---:|---|
| **Compilación TypeScript** | ✅ PASÓ | `pnpm run build` / `tsc --noEmit` sin errores |
| **Prueba contra Oracle DEV** | ✅ PASÓ | Validado contra actividad real `627021` (5 preguntas); datos idénticos |
| **Git / Ramas** | ✅ PUSHEADO | Commit `046b420` en `fix/calificaciones-docente` y en `practicas-preprofesionales` |
