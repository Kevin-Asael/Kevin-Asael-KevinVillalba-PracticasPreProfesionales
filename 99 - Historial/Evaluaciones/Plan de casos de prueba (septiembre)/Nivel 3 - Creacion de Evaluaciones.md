# Nivel 3: Creacion y Configuracion de Evaluaciones

Configuracion de parametros de actividad docente para examenes en linea.

Hub: [[Tests]]

---

### [ACT-00] Listar Actividades en Curso Vacio (Sin actividades previas)
- **Tipo:** Funcional / Estado Vacio
- **Severidad:** Alta
- **Pasos:**
- **Resultado Esperado (App):** Cargar la pantalla limpiamente mostrando *"No hay actividades registradas"* con opcion para crear una nueva actividad.
- **Resultado Esperado (Backend):** Devolver HTTP 200 con lista vacia `[]`.
- **Estado:**
  - [x] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**

---

### [ACT-01] Crear Evaluacion en Modo Automatico (Sorteo)
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Ir a Crear Actividad Docente.
  2. Tipo de Actividad = `Evaluacion online`.
  3. Configurar: Parcial, Politica de Evaluacion, Fechas inicio/fin, 1 intento, 60 minutos.
  4. Modo de Evaluacion = `Sorteo Automatico` (`evalAuto = 'S'`).
  5. Guardar.
- **Resultado Esperado (App):** Actividad creada con exito; al seleccionarla dirige al panel de Sorteo Automatico.
- **Resultado Esperado (Backend):** Registro en tabla de actividades con `eval_auto = 'S'`.
- **Estado:**
  - [ ] Pendiente
  - [x] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > No entra al panel de sorteo pero ese es el comportamiento esperado.

---

### [ACT-02] Crear Evaluacion en Modo Manual
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Crear actividad con Tipo = `Evaluacion online` y `evalAuto = 'N'`.
- **Resultado Esperado (App):** Al ingresar a la evaluacion muestra la pantalla de Asignacion Manual (Preguntas Disponibles vs Ya Agregadas).
- **Estado:**
  - [ ] Pendiente
  - [x] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > No entra a la pantalla de asignacion pero ese es el comportamiento esperado.

---

### [ACT-03] Edicion de Parametros de Evaluacion
- **Tipo:** Funcional
- **Severidad:** Media
- **Pasos:**
  1. Editar evaluacion sin intentos realizados: ampliar fecha de fin y aumentar tiempo de 45 a 60 min.
- **Resultado Esperado (App/Backend):** Cambios guardados correctamente sin afectar estructura.
- **Estado:**
  - [ ] Pendiente
  - [x] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [ACT-04] Validacion de Rango de Fechas Invalido
- **Tipo:** Validacion
- **Severidad:** Alta
- **Pasos:**
  1. Configurar Fecha Fin anterior a la Fecha Inicio (ej. Inicio: 10:00, Fin: 09:00 del mismo dia).
- **Resultado Esperado (App):** Alerta de error impidiendo guardar.
- **Estado:**
  - [ ] Pendiente
  - [x] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [ACT-05] Validacion de Intentos = 0
- **Tipo:** Validacion
- **Severidad:** Media
- **Pasos:**
  1. Ingresar 0 en el campo de intentos permitidos.
- **Resultado Esperado (App):** El validador exige un valor minimo de 1 intento.
- **Estado:**
  - [ ] Pendiente
  - [x] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [ACT-06] Validacion de Limite de Tiempo = 0
- **Tipo:** Validacion
- **Severidad:** Media
- **Pasos:**
  1. Ingresar 0 minutos en el tiempo de duracion.
- **Resultado Esperado (App):** Rechazo por validacion de formulario.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [x] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > Deja ingresar 0 minutos 0 horas

---

### [ACT-07] Validacion de Parcial y Politica Obligatorios
- **Tipo:** Validacion
- **Severidad:** Alta
- **Pasos:**
  1. Intentar guardar sin seleccionar Parcial o Politica de Calificacion.
- **Resultado Esperado (App):** Resaltado en rojo de los selectores obligatorios.
- **Estado:**
  - [ ] Pendiente
  - [x] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [ACT-08] Bloqueo de Cambio de Modo (Auto/Manual) con Intentos Iniciados
- **Tipo:** Regla de Negocio
- **Severidad:** Critica
- **Pasos:**
  1. Editar una evaluacion donde ya existen estudiantes con intentos registrados.
  2. Intentar cambiar de Manual a Automatico o viceversa.
- **Resultado Esperado (App/Backend):** El selector de modo debe estar deshabilitado para preservar la integridad de notas ya generadas.
- **Estado:**
  - [x] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [ACT-09] Formato Enriquecido en Instrucciones (Quill)
- **Tipo:** UI
- **Severidad:** Baja
- **Pasos:**
  1. Redactar instrucciones con negritas, listas numeradas y enlaces web.
  2. Guardar y verificar la vista previa.
- **Resultado Esperado (App):** Renderizado fiel del formato HTML de las instrucciones.
- **Estado:**
  - [ ] Pendiente
  - [x] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [ACT-10] Adjunto que Excede el Tamano Maximo (30 MB)
- **Tipo:** Validacion
- **Severidad:** Media
- **Pasos:**
  1. Adjuntar un archivo mayor a 30 MB (31 457 280 bytes exactos es el limite en codigo, `formulario_crear_actividad_docente_provider.dart:164`) al crear la actividad.
- **Resultado Esperado (App):** Debe rechazar antes de intentar subir el archivo, sin llegar a llamar al backend.
- **Estado:**
  - [ ] Pendiente
  - [x] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [ACT-11] Nombre de Adjunto que Excede el Maximo de Caracteres
- **Tipo:** Validacion
- **Severidad:** Baja
- **Pasos:**
  1. Adjuntar un archivo cuyo nombre supere 100 caracteres (incluye la extension en el conteo).
- **Resultado Esperado (App):** **No rechaza** — trunca el nombre automaticamente para que quepa en 100 caracteres preservando la extension, y sigue adelante con el archivo renombrado (`formulario_crear_actividad_docente_provider.dart:173-186`). Confirmar que el nombre final mostrado en pantalla ya viene truncado, sin ningun aviso al docente de que se recorto.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [ACT-12] Edicion Bloqueada por Ciclo/Parcial No Editable (Corregido — No es "Todo o Nada")
- **Tipo:** Regla de Negocio
- **Severidad:** Alta
- **Pasos:**
  1. Abrir para editar una evaluacion cuyo `actividadDetalle.editable == false` (parcial/ciclo ya cerrado).
- **Resultado Esperado (App):** El boton "Actualizar" no se dibuja (`editar_actividad_docente_page.dart:136-138`) — eso es correcto y confirmado. Pero el bloqueo de los CAMPOS es un mosaico, no "todo bloqueado" como se penso al principio (releido en `formulario_editar_actividad_widget.dart`):
  - Seleccion de Preguntas (radio Manual/Automatico, `:117-122`), Tiempo Limite horas/minutos (`:124-129`) y URL (`:133-136`) **no reciben ningun flag de bloqueo** — quedan interactivos aunque `editable == false` (aunque no haya boton para guardar el cambio).
  - Ver [ACT-14] para el caso del dropdown de Parcial, que tiene la logica invertida.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [ACT-13] Edicion de Fecha/Intentos/Tiempo con Estudiantes Ya Respondiendo (Sin Bloqueo del Backend)
- **Tipo:** Regla de Negocio / Caso Borde
- **Severidad:** Critica
- **Pasos:**
  1. Con una evaluacion que ya tiene estudiantes respondiendo o que ya entregaron, editar `fechaFin`, `intentosPermitidos` o `limiteTiempo`.
- **Resultado Esperado (App/Backend):** A diferencia de [ACT-08] (que sí bloquea cambiar Manual/Automatico), el backend **no** valida si ya hay respuestas antes de permitir este cambio (`actividad.service.ts:240-371` `actualizarActividad`, confirmado releyendo el metodo completo: solo valida parcial activo, fechas, campos de tipo 2 e intentos — nada sobre respuestas existentes). Nota: segun [ACT-12], el campo Fechas/Intentos esta SIEMPRE bloqueado en el cliente (`isEditable:false` fijo), asi que este caso puede no ser ejecutable desde la app tal como esta hoy — probarlo igual para confirmar si de verdad no hay forma de cambiar esos campos, o si hay otra via (edicion directa, otro rol, etc.).
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [ACT-14] Dropdown de Parcial con Logica de Bloqueo Invertida (Bug de Codigo Encontrado en Auditoria)
- **Tipo:** Bug de UI / Regla de Negocio
- **Severidad:** Alta
- **Pasos:**
  1. Editar una evaluacion **editable** (`actividadDetalle.editable == true`, parcial/ciclo activo) y tocar el dropdown de Parcial.
  2. Editar una evaluacion **no editable** (`editable == false`) y tocar el mismo dropdown.
- **Resultado Esperado (App):** `ParcialesActividadDropdownWidget` recibe `isLocker: provider.actividadDetalle!.editable` (`formulario_editar_actividad_widget.dart:87`) — **sin negar**, a diferencia de Politica/Tipo de Actividad que sí niegan (`isLocked: !editable`). Dentro del widget, `isLocker == true` significa bloqueado (comentario propio: *"Solo permite cambiar si no está bloqueado (isLocker false)"*, `parciales_actividad_widget.dart:92-93`). Por la falta de negacion, el resultado esperado es el **inverso** de lo correcto: el dropdown de Parcial deberia aparecer **bloqueado** cuando la evaluacion NO es editable, y **desbloqueado** cuando sí lo es — pero con este codigo pasa al reves. Confirmar en la app: con `editable == true` (caso normal), ¿el Parcial se puede cambiar o aparece bloqueado sin razon? Con `editable == false`, ¿se puede cambiar el Parcial pese a que todo lo demas esta bloqueado?
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 
