# Nivel 2: Importacion de Preguntas - Wizard de 5 Pasos

Pruebas para el asistente de importacion de bancos de preguntas entre ciclos, materias y temas.

Hub: [[Tests]]

---

### [IMP-01] Flujo Completo del Wizard de 5 Pasos
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Paso 1: Seleccionar Ciclo Academico origen.
  2. Paso 2: Seleccionar Materia origen.
  3. Paso 3: Seleccionar Tema origen.
  4. Paso 4: Seleccionar Tema destino.
  5. Paso 5: Seleccionar 3 preguntas individuales del listado paginado.
  6. Confirmar importacion.
- **Resultado Esperado (App):** Mensaje de exito indicando cantidad de preguntas importadas y actualizacion del banco actual.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [IMP-02] Importacion por Lote de Tema Completo
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. En el paso 5 del wizard, seleccionar la opcion de importar todo el tema/contenido.
- **Resultado Esperado (App):** Importa todas las preguntas del tema sin necesidad de marcar una por una.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [IMP-03] Importacion por Materia Completa
- **Tipo:** Funcional
- **Severidad:** Media
- **Pasos:**
  1. Ejecutar importacion a nivel de materia completa entre aulas del docente.
- **Resultado Esperado (App):** Copia la estructura de temas y preguntas completas.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [IMP-04] Manejo de Preguntas Duplicadas
- **Tipo:** Validacion
- **Severidad:** Media
- **Pasos:**
  1. Importar una pregunta que ya habia sido importada previamente al mismo tema.
- **Resultado Esperado (App/Backend):** El sistema omite duplicados o renombra/genera nuevo identificador sin corromper registros existentes.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [IMP-05] Importacion con Imagenes y Adjuntos
- **Tipo:** Funcional / Integridad
- **Severidad:** Alta
- **Pasos:**
  1. Importar preguntas que contengan imagenes adjuntas desde un ciclo previo.
  2. Abrir el detalle de la pregunta importada en el aula actual.
- **Resultado Esperado (App):** La imagen se visualiza correctamente en la nueva ubicacion sin enlaces rotos.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [IMP-06] Cancelacion y Reseteo de Estado
- **Tipo:** UI / State Management
- **Severidad:** Baja
- **Pasos:**
  1. Avanzar hasta el paso 3 o 4 del wizard.
  2. Presionar cancelar o boton atras hasta salir.
  3. Reabrir el wizard de importacion.
- **Resultado Esperado (App):** El estado inicia limpio desde el Paso 1 sin selecciones residuales.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [IMP-07] Validacion de Seleccion Vacia
- **Tipo:** Validacion
- **Severidad:** Baja
- **Pasos:**
  1. En el paso 5, desmarcar todas las preguntas e intentar presionar Importar.
- **Resultado Esperado (App):** El boton permanece deshabilitado o muestra advertencia solicitando al menos 1 pregunta.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [IMP-08] Navegacion Hacia Atras en Pasos Previos
- **Tipo:** UI / Provider
- **Severidad:** Media
- **Pasos:**
  1. Llegar al paso 4 (tema destino) y regresar al paso 2 (materia).
  2. Cambiar la materia seleccionada y avanzar nuevamente.
- **Resultado Esperado (App):** Los temas de origen y destino se actualizan reactivamente segun la nueva materia seleccionada.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 
