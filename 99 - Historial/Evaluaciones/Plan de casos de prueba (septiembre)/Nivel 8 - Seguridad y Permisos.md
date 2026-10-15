# Nivel 8: Seguridad, Permisos y Casos Maliciosos

Pruebas de autorizacion, control de acceso, sanitizacion y validacion de limites.

Hub: [[Tests]]

---

### [SEG-01] Acceso a Banco de Preguntas de Otro Curso
- **Tipo:** Seguridad / Autorizacion
- **Severidad:** Critica
- **Pasos:**
  1. Intentar consultar preguntas pasando en la URL un `codAula` que no pertenece al docente autenticado.
- **Resultado Esperado (Backend):** Respuesta HTTP 403 Forbidden.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SEG-02] Manipulacion de Payload en Sorteo
- **Tipo:** Seguridad
- **Severidad:** Critica
- **Pasos:**
  1. Modificar en el body de `sortear-preguntas` el `codContenido` para apuntar a un tema de otra carrera/materia.
- **Resultado Esperado (Backend):** Rechazo de la peticion por validacion de permisos en el Guard.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > ⚠ **Predicción según código, a confirmar:** `actividad.controller.ts:29-30` solo aplica `@UseGuards(AuthGuard)`
  > (siempre `return true`). Ademas `user.cuenta` solo se usa como campo de auditoria al insertar,
  > nunca como filtro de autorizacion, en ningun endpoint del bloque de evaluaciones. Es probable que
  > esta peticion **no** sea rechazada. Prioriza confirmar este caso.

---

### [SEG-03] Calificar Estudiante de Otro Curso
- **Tipo:** Seguridad
- **Severidad:** Critica
- **Pasos:**
  1. Enviar calificacion para una cedula de estudiante que no pertenece al `idCurso` activo.
- **Resultado Esperado (Backend):** HTTP 403 / 400 impidiendo asentar notas no autorizadas.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SEG-04] Eliminacion de Preguntas Ajenas via Endpoint Directo
- **Tipo:** Seguridad
- **Severidad:** Critica
- **Pasos:**
- **Resultado Esperado (Backend):** HTTP 403 / 404 sin borrar el registro.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SEG-05] Sanitizacion de HTML / XSS en Editor Quill
- **Tipo:** Seguridad
- **Severidad:** Alta
- **Pasos:**
  1. Pegar scripts maliciosos en el enunciado (`<script>alert(1)</script>`, `<img onerror=...>`).
- **Resultado Esperado (App):** El renderer HTML escapa o sanitiza el script sin ejecutar codigo arbitrario.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SEG-06] Subida de Imagenes con Peso Extremo (>50MB)
- **Tipo:** Seguridad / Carga
- **Severidad:** Media
- **Pasos:**
  1. Intentar adjuntar una imagen de gran tamaño a una pregunta.
- **Resultado Esperado (App/Backend):** Validacion en cliente limitando tamaño maximo o HTTP 413 Payload Too Large en backend.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SEG-07] Texto de Enunciado Masivo (>100KB)
- **Tipo:** Validacion
- **Severidad:** Baja
- **Pasos:**
  1. Enviar un enunciado de miles de caracteres.
- **Resultado Esperado (App/Backend):** Limite de caracteres controlado sin desbordar base de datos.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SEG-08] Importar Preguntas de Materia No Asignada
- **Tipo:** Autorizacion
- **Severidad:** Alta
- **Pasos:**
  1. Intentar consumir endpoints de importacion para materias donde el docente no es titular.
- **Resultado Esperado (Backend):** Lista vacia o HTTP 403.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SEG-09] Replay Attack en Sorteo
- **Tipo:** Seguridad
- **Severidad:** Media
- **Pasos:**
  1. Reenviar la misma peticion autenticada de sorteo 50 veces seguidas.
- **Resultado Esperado (Backend):** Control de concurrencia y bloqueo de duplicidad.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SEG-10] Resetear Tiempo de Alumno No Inscrito
- **Tipo:** Seguridad
- **Severidad:** Alta
- **Pasos:**
  1. Enviar peticion de resetear tiempo con ID de alumno ajeno.
- **Resultado Esperado (Backend):** Rechazo por no coincidir inscripcion con el curso.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > ⚠ **Predicción según código, a confirmar — alta confianza de que esto FALLA:** el endpoint
  > `resetear-tiempo` (`actividad.service.ts:959-971`) no tiene absolutamente ninguna validacion de
  > negocio (ni parcial activo, ni inscripcion, ni respuestas existentes) — ejecuta directo
  > `UPDATE LMS_TAB_ACTIVIDADES_ALUMNOS SET FECHA_INICIO_EA = NULL WHERE ID_ACTIVIDAD = :idActividad`,
  > afectando a **todos** los estudiantes de esa actividad sin ningun filtro de propiedad. Este es
  > probablemente el caso de seguridad de mayor prioridad de todo este Nivel.

---

### [SEG-11] Agregar/Eliminar Preguntas o Calificar en Evaluacion de Otro Docente
- **Tipo:** Seguridad
- **Severidad:** Critica
- **Pasos:**
  1. Autenticado como Docente A, ejecutar `agregar-preguntas`, `eliminar-preguntas`, `sortear-preguntas` o `calificar` sobre un `idActividad`/`idRespuesta` que pertenece a un curso del Docente B.
- **Resultado Esperado (Backend):** Deberia rechazar por no ser el propietario del curso/actividad.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > ⚠ Mismo hallazgo que [SEG-02]/[SEG-10]: ningun endpoint del bloque de evaluaciones (crear, editar,
  > sortear, agregar/eliminar preguntas, resetear tiempo, calificar, recalcular) valida que el
  > cuenta (`actividad.controller.ts:29-30`, unico guard: `@UseGuards(AuthGuard)`). Es el hallazgo de
  > seguridad mas amplio de toda la exploracion del backend docente.
