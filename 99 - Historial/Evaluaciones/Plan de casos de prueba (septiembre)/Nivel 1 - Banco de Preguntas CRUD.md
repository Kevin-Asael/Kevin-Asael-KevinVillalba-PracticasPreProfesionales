	# Nivel 1: Banco de Preguntas - CRUD y Validaciones

Modulo base para la creacion, modificacion, visualizacion y borrado de preguntas en el banco docente.

Hub: [[Tests]]

---

### [BP-01] Crear Pregunta de Respuesta Unica con Imagen
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Ir a Banco de Preguntas > Crear Pregunta.
  2. Escribir enunciado con texto enriquecido en Quill.
  3. Seleccionar Tipo: `Respuesta Unica` (codigo 1).
  4. Seleccionar Contenido/Tema y Dificultad = 5.
  5. Adjuntar una imagen valida (JPG/PNG).
  6. Crear 4 opciones de respuesta y marcar solo 1 como correcta.
  7. Guardar.
- **Resultado Esperado (App):** Pregunta creada con exito, imagen cargada y redireccion al listado.
- **Resultado Esperado (Backend/Oracle):** Registro en tabla de preguntas con `cod_tipo_pregunta = 1`, 4 registros de alternativas asociadas y archivo de imagen almacenado.
- **Estado:**
  - [ ] Pendiente
  - [x] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [BP-02] Crear Pregunta de Opcion Multiple
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Ir a Crear Pregunta.
  2. Seleccionar Tipo: `Opcion Multiple` (codigo 2).
  3. Agregar 5 opciones con retroalimentacion en cada una.
  4. Marcar 2 opciones como correctas con checkboxes.
  5. Guardar.
- **Resultado Esperado (App):** Permite multiples checkboxes marcados simultaneamente y guarda sin error.
- **Resultado Esperado (Backend):** Alternativas registradas con `es_correcta = 1` en las dos seleccionadas.
- **Estado:**
  - [ ] Pendiente
  - [x] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [BP-03] Crear Pregunta tipo Ensayo (Respuesta Abierta)
- **Tipo:** Funcional
- **Severidad:** Media
- **Pasos:**
  1. Seleccionar Tipo: `Ensayo` (codigo 4).
  2. Ingresar enunciado, contenido y dificultad.
- **Resultado Esperado (App):** El formulario oculta las tarjetas de opciones de respuesta (no aplican para ensayo).
- **Resultado Esperado (Backend):** Pregunta creada sin registros hijos en tabla de alternativas.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [BP-04] Crear Pregunta de Emparejamiento
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Seleccionar Tipo: `Emparejamiento` (codigo 6).
  2. Crear 4 pares: Enunciado (columna A) + Respuesta Correcta (columna B).
  3. Guardar.
- **Resultado Esperado (App):** Cada fila exige ambos campos completos antes de permitir guardar.
- **Resultado Esperado (Backend):** Registros guardados con sus pares de relacion correctos.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [BP-05] Editar Pregunta Existente
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Abrir una pregunta existente desde el listado.
  2. Modificar texto del enunciado en Quill.
  3. Reemplazar la imagen adjunta por una nueva.
  4. Agregar una opcion de respuesta adicional.
  5. Guardar cambios.
- **Resultado Esperado (App):** Los datos precargados se actualizan y reflejan inmediatamente en el listado y detalle.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [BP-06] Eliminar Pregunta Sin Uso en Examenes
- **Tipo:** Funcional
- **Severidad:** Media
- **Pasos:**
  1. Seleccionar una pregunta que no pertenezca a ninguna evaluacion activa.
  2. Presionar Eliminar y confirmar en el dialogo modal.
- **Resultado Esperado (App):** La pregunta desaparece del listado con mensaje de confirmacion.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [BP-07] Bloqueo de Eliminacion / Edicion por Parcial Activo
- **Tipo:** Validacion de Seguridad
- **Severidad:** Critica
- **Pasos:**
  1. Intentar editar o eliminar una pregunta asignada a un examen de un parcial en curso (`validarParcialesActivas`).
- **Resultado Esperado (App):** Muestra alerta bloqueante impidiendo la modificacion para no alterar examenes activos.
- **Resultado Esperado (Backend):** Rechazo con codigo 400/409 y mensaje de restriccion.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [BP-08] Filtros Combinados de Busqueda
- **Tipo:** UI / Funcional
- **Severidad:** Media
- **Pasos:**
  1. Filtrar por Tema especifico.
  2. Filtrar por Tipo de Pregunta = `Respuesta Unica`.
  3. Ajustar slider de Dificultad (ej. 4 a 8).
- **Resultado Esperado (App):** El listado muestra unicamente las preguntas que cumplen simultaneamente todos los criterios.
- **Resultado Esperado (Backend):** Query con parametros `codContenido`, `tipo`, `difMinima`, `difMaxima`.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [BP-09] Paginacion Infinita en Dashboard
- **Tipo:** Rendimiento / UI
- **Severidad:** Media
- **Pasos:**
  1. Realizar scroll continuo hacia abajo en un banco con >100 preguntas.
- **Resultado Esperado (App):** Carga paquetes de 25 en 25 con spinner sutil sin parpadeos ni duplicados de elementos.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [BP-10] Visualizacion de Detalle con HTML e Imagen
- **Tipo:** UI
- **Severidad:** Baja
- **Pasos:**
  1. Abrir detalle de una pregunta con formulas, negritas y listas en HTML.
  2. Tocar la imagen adjunta.
- **Resultado Esperado (App):** Renderizado HTML correcto sin etiquetas crudas. La imagen abre en modal/zoom completo.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [BP-11] Comportamiento Exclusivo en Respuesta Unica
- **Tipo:** UI / Validacion
- **Severidad:** Media
- **Pasos:**
  1. En una pregunta de Respuesta Unica con opcion A marcada como correcta, hacer clic en la opcion C.
- **Resultado Esperado (App):** La opcion A se desmarca automaticamente y solo queda marcada la opcion C.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [BP-12] Validacion de Campos Obligatorios al Crear
- **Tipo:** Validacion
- **Severidad:** Alta
- **Pasos:**
  1. Intentar guardar una pregunta con el enunciado vacio, sin tema seleccionado o sin marcar respuesta correcta.
- **Resultado Esperado (App):** Mensajes de error en rojo bajo cada campo invalido; no se envia peticion HTTP al backend.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 
