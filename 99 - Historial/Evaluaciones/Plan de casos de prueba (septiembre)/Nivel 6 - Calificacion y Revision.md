# Nivel 6: Calificacion, Revision de Respuestas y Notas

Pruebas del libro de calificaciones, calificacion manual de ensayos y revision de cuestionarios.

Hub: [[Tests]]

---

### [CAL-00] Cargar Notas de Estudiantes en Curso Vacio
- **Tipo:** Funcional / Estado Vacio
- **Severidad:** Alta
- **Pasos:**
- **Resultado Esperado (App):** Cargar la pantalla sin errores mostrando mensaje *"No hay notas registradas para este curso"*.
- **Resultado Esperado (Backend):** Responder HTTP 200 con array vacio `[]`.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [x] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**

---

### [CAL-01] Carga de Calificaciones Regulares
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Abrir Calificaciones Regulares de una actividad de evaluacion.
- **Resultado Esperado (App):** Lista de estudiantes con Cedula, Nombre, Estado (Rendido/No rendido), Intentos usados y Nota obtenida.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [CAL-02] Edicion Inline de Nota Individual
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Modificar la nota de un estudiante directamente en el campo de texto de la fila.
  2. Guardar individualmente.
- **Resultado Esperado (App):** `POST .../actualizar-calificacion` guarda la nota sin recargar toda la pagina (ValueNotifier granular).
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [CAL-03] Guardado en Lote (Batch Save)
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Modificar notas de 5 estudiantes.
  2. Presionar el boton general "Guardar Calificaciones".
  3. Confirmar en el dialogo modal.
- **Resultado Esperado (App):** `POST .../guardar-calificaciones` envia todas las modificaciones juntas.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [CAL-04] Validacion de Nota > Maximo Permitido
- **Tipo:** Validacion
- **Severidad:** Alta
- **Pasos:**
  1. Si la politica califica sobre 10 puntos, ingresar 10.5 o 15.
- **Resultado Esperado (App):** El campo resalta en error y no permite guardar.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [CAL-05] Validacion de Nota Negativa
- **Tipo:** Validacion
- **Severidad:** Media
- **Pasos:**
  1. Ingresar un valor negativo (-2.0).
- **Resultado Esperado (App):** Campo bloquea signos negativos o muestra error de validacion.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [CAL-06] Control de Estado Dirty (`tieneCambiosPendientes`)
- **Tipo:** UI / State
- **Severidad:** Baja
- **Pasos:**
  1. Abrir la pantalla de calificaciones sin hacer ningun cambio.
- **Resultado Esperado (App):** El boton "Guardar Calificaciones" se encuentra deshabilitado. Se habilita unicamente al editar al menos un valor.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [CAL-07] Abrir Revision de Respuestas de Estudiante
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Hacer clic en el icono de revision en la fila de un estudiante que rindio la prueba.
- **Resultado Esperado (App):** Abre `RevisionRespuestasPage` mostrando cada pregunta, lo que respondio el alumno vs la respuesta correcta y el puntaje obtenido.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

> ⚠ **Discrepancia a confirmar antes de correr CAL-08/09/10:** el codigo actual de
> `ensayo_revision_widget.dart:120-169` solo tiene **dos botones binarios** ("Incorrecto"/"Correcto"),
> sin ningun campo ni slider de puntaje parcial — pese a que la UI superior sí contempla visualmente
> el estado "Respuesta Parcial" (`pregunta_revision_card.dart:205-234`). Ademas el backend normaliza
> `calificacion` a binario: cualquier valor `> 0` se guarda como `1`, cualquier valor `<= 0` como `0`
> (`revision-respuestas.service.ts:150`), aunque el DTO acepta decimales entre 0 y 1
> (`CalificarRespuestaDto`, `@Min(0)@Max(1)`). Si estos 3 casos fueron escritos pensando en un widget
> de nota numerica que ya no existe (o que corresponde a otra pantalla), ajustarlos: probar en su
> lugar que **nunca** se puede dar una nota parcial real a una pregunta de ensayo desde la app.

### [CAL-08] Calificar Pregunta de Ensayo con Recalculo Instantaneo
- **Tipo:** Funcional
- **Severidad:** Critica
- **Pasos:**
  1. En la revision, ubicar una pregunta tipo Ensayo.
  2. Asignar puntaje (ej. 2.5 / 3.0) en el widget interactivo de calificacion.
  3. Guardar calificacion de la pregunta.
- **Resultado Esperado (App):** La nota final total del estudiante en la cabecera se recalcula instantaneamente en pantalla.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [CAL-09] Calificar Ensayo con Nota 0
- **Tipo:** Funcional
- **Severidad:** Media
- **Pasos:**
  1. Asignar nota 0.0 a una respuesta de ensayo no valida.
- **Resultado Esperado (App/Backend):** Guarda 0 sin interpretar el campo como vacio o nulo.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [CAL-10] Calificar Ensayo con Nota Maxima
- **Tipo:** Funcional
- **Severidad:** Media
- **Pasos:**
  1. Asignar el 100% del puntaje asignado a esa pregunta.
- **Resultado Esperado (App):** Suma el puntaje completo a la nota global.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [CAL-11] Persistencia Post-Calificacion
- **Tipo:** Integridad
- **Severidad:** Alta
- **Pasos:**
  1. Calificar una pregunta de ensayo.
  2. Salir de la revision y volver a entrar.
- **Resultado Esperado (App):** La calificacion ingresada se mantiene exactamente como se guardo.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [CAL-12] Comparacion Visual en Pregunta de Emparejamiento
- **Tipo:** UI
- **Severidad:** Media
- **Pasos:**
  1. Revisar un intento con pregunta de emparejamiento con 2 pares correctos y 2 incorrectos.
- **Resultado Esperado (App):** Colores diferenciados (verde para aciertos, rojo para fallos) mostrando claramente la correspondencia del alumno vs la real.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [CAL-13] Revision de Estudiante que Abandono (0 respuestas)
- **Tipo:** Caso Borde
- **Severidad:** Media
- **Pasos:**
  1. Abrir revision de un alumno que inicio el examen pero no marco ninguna opcion.
- **Resultado Esperado (App):** Todas las preguntas se muestran como no contestadas con puntaje 0.0 sin romper la pantalla.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [CAL-14] Reflejo en Reporte Consolidado
- **Tipo:** Consistencia
- **Severidad:** Alta
- **Pasos:**
  1. Verificar que la nota asentada se refleja en la vista de Notas por Parcial y en el Reporte Consolidado del curso.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [CAL-15] Condicion de Carrera al Calificar Dos Preguntas Casi Simultaneas
- **Tipo:** Concurrencia
- **Severidad:** Alta
- **Pasos:**
  1. Con dos pestañas/sesiones (o dos personas), calificar dos preguntas de ensayo **distintas** del **mismo** estudiante casi al mismo tiempo.
- **Resultado Esperado (Backend):** El recalculo incremental de la nota final (`revision-respuestas.service.ts:198-231`, lee `notaActual` en la linea 210 y escribe en la 226-231) lee la calificacion actual y la actualiza dentro de una transaccion, pero **sin** `SELECT ... FOR UPDATE` ni locking explicito — en aislamiento por defecto de Oracle (read committed) es posible que una de las dos calificaciones "se pierda" (lost update) en `LMS_TAB_ACTIVIDADES_ALUMNOS.CALIFICACION`. Confirmar si la nota final refleja ambas calificaciones o solo la ultima en escribir.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 
