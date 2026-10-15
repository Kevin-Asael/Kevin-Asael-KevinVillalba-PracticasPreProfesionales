# Nivel 5: Asignacion Manual de Preguntas

Pruebas para la seleccion y ensamble manual de cuestionarios desde el banco docente.

Hub: [[Tests]]

---

### [MAN-01] Agregar Preguntas en Lote (Batch Add)
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. En la seccion "Preguntas Disponibles", marcar 5 preguntas mediante checkboxes.
  2. Presionar "Agregar seleccionadas".
- **Resultado Esperado (Backend):** `POST .../agregar-preguntas` con array de IDs `{ codigosPreguntas: [...] }`.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [MAN-02] Quitar Preguntas en Lote (Batch Remove)
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. En "Preguntas ya agregadas", seleccionar 2 preguntas y presionar "Quitar".
- **Resultado Esperado (App):** Se remueven de la lista del examen y reaparecen en disponibles.
- **Resultado Esperado (Backend):** `DELETE .../eliminar-preguntas`.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [MAN-03] Filtros en Preguntas Disponibles
- **Tipo:** UI
- **Severidad:** Media
- **Pasos:**
  1. Filtrar las preguntas disponibles por tema y tipo antes de agregarlas.
- **Resultado Esperado (App):** La busqueda filtra unicamente sobre las preguntas no asignadas.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [MAN-04] Idempotencia en Asignacion Manual
- **Tipo:** Consistencia
- **Severidad:** Media
- **Pasos:**
  1. Reenviar accidentalmente una peticion de agregar con un ID que ya estaba asignado.
- **Resultado Esperado (Backend):** No genera registros duplicados en base de datos.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [MAN-05] Mezcla de Todos los Tipos de Pregunta
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Agregar al examen: 1 Respuesta Unica + 1 Opcion Multiple + 1 Ensayo + 1 Emparejamiento.
- **Resultado Esperado (App):** Todas se visualizan y ordenan correctamente en la lista de asignadas.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [MAN-06] Validacion de Examen Vacio
- **Tipo:** Regla de Negocio
- **Severidad:** Alta
- **Pasos:**
  1. Quitar todas las preguntas del examen (0 preguntas).
  2. Intentar habilitar la evaluacion.
- **Resultado Esperado (App/Backend):** Advertencia indicando que el examen debe tener al menos 1 pregunta antes de que los estudiantes puedan rendirlo.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [MAN-07] Preguntas con Imagenes en la Asignacion
- **Tipo:** UI
- **Severidad:** Baja
- **Pasos:**
  1. Verificar tarjetas de preguntas con miniatura de imagen adjunta en la vista de seleccion.
- **Resultado Esperado (App):** Muestra el icono/preview de adjunto correctamente.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [MAN-08] Quitar Pregunta Puntual Ya Respondida por un Estudiante (Sin Validacion)
- **Tipo:** Regla de Negocio / Caso Borde
- **Severidad:** Critica
- **Pasos:**
  1. Con un estudiante que ya respondio una pregunta especifica del examen, usar "Quitar" (eliminacion **selectiva**, no "Eliminar Todo") sobre esa pregunta puntual.
- **Resultado Esperado (Backend):** A diferencia de "Eliminar Todo" (ver [MAN-09]), el endpoint `eliminar-preguntas` selectivo **no llama** a la validacion de respuestas existentes (`actividad.controller.ts:289-299`) — borra directamente aunque el estudiante ya haya respondido esa pregunta. Confirmar si la respuesta/nota de ese estudiante se pierde en silencio, sin ningun aviso al docente.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [MAN-09] "Eliminar Todo" Sí Bloquea si Hay Respuestas (Contraste con MAN-08)
- **Tipo:** Regla de Negocio
- **Severidad:** Alta
- **Pasos:**
  1. Con al menos un estudiante que ya respondio alguna pregunta del examen, presionar "Eliminar Todo".
- **Resultado Esperado (Backend):** A diferencia del borrado selectivo ([MAN-08]), este SÍ valida (`validarEvaluacionTieneRespuestas`, `actividad.service.ts:938-956`) y debe **rechazar** con un mensaje claro, sin borrar nada. Documentar la inconsistencia si [MAN-08] efectivamente no protege igual.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 
