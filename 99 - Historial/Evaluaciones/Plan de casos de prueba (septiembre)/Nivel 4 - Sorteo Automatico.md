# Nivel 4: Sorteo Automatico de Preguntas

Pruebas sobre el motor de generacion aleatoria y asignacion automatica de cuestionarios a estudiantes.

Hub: [[Tests]]

---

### [SRT-01] Sorteo con Cuestionarios Diferentes por Estudiante
- **Tipo:** Funcional
- **Severidad:** Critica
- **Pasos:**
  1. En Sortear Preguntas, seleccionar Tema y Rango Dificultad (3 a 8).
  2. Cantidad = 10 preguntas.
  3. Activar toggle `esCuestionarioDiferente = 'S'`.
  4. Ejecutar "Sortear Preguntas".
- **Resultado Esperado (App):** Mensaje de exito y visualizacion en `SortearEstudiantesView`.
- **Resultado Esperado (Backend/Oracle):** Cada estudiante tiene asignado un set aleatorio de preguntas distinto que cumple los filtros.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SRT-02] Sorteo con Mismo Cuestionario para Todos
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Configurar sorteo con toggle `esCuestionarioDiferente = 'N'`.
- **Resultado Esperado (Backend):** Todos los estudiantes reciben exactamente los mismos codigos de preguntas seleccionados por el sorteo.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SRT-03] Validacion de Cantidad Solicitada > Disponible
- **Tipo:** Validacion
- **Severidad:** Alta
- **Pasos:**
- **Resultado Esperado (App):** El boton "Sortear" se bloquea y muestra advertencia indicando que no hay suficientes preguntas en el banco.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SRT-04] Debounce en Consulta de Conteo Disponible (500ms)
- **Tipo:** Rendimiento / Red
- **Severidad:** Media
- **Pasos:**
  1. Mover repetidamente y muy rapido el slider de dificultad.
- **Resultado Esperado (App/Logs):** Solo se envia 1 peticion a `GET .../num-preguntas` una vez que el usuario detiene el movimiento por 500ms (no satura la red).
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SRT-05] Eliminar Sorteo y Limpieza Total
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Con un sorteo ya generado, presionar "Eliminar Sorteo" y confirmar.
- **Resultado Esperado (App):** La vista vuelve al estado inicial de configuracion.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SRT-06] Resetear Tiempo de un Estudiante
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. En la lista de estudiantes del sorteo, seleccionar un alumno y presionar "Resetear Tiempo".
- **Resultado Esperado (App):** Confirmacion en pantalla.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SRT-07] Validacion de Rango de Dificultad Invertido
- **Tipo:** Validacion
- **Severidad:** Baja
- **Pasos:**
  1. Intentar fijar dificultad minima (8) mayor a la maxima (3).
- **Resultado Esperado (App):** El slider bloquea el cruce de valores manteniendo `min <= max`.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SRT-08] Sorteo con Banco Vacio (0 preguntas)
- **Tipo:** Caso Borde
- **Severidad:** Media
- **Pasos:**
  1. Aplicar filtros donde no exista ninguna pregunta registrada.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SRT-09] Re-sortear Sin Eliminar Previo
- **Tipo:** Validacion
- **Severidad:** Media
- **Pasos:**
  1. Intentar lanzar un nuevo sorteo cuando ya existe uno activo sin haberlo eliminado.
- **Resultado Esperado (App):** Alerta solicitando eliminar el sorteo previo antes de generar uno nuevo.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SRT-10] Endpoint Validar Sorteo
- **Tipo:** Consistencia
- **Severidad:** Media
- **Pasos:**
  1. Abrir la pantalla de evaluacion sorteada.
- **Resultado Esperado (App):** `GET .../validar-sorteo` detecta automaticamente que ya fue sorteada y muestra la lista de alumnos en vez del formulario de sorteo.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SRT-11] "Ya Sorteada" Disparada por Asignacion Manual Previa (Cruce con Nivel 5)
- **Tipo:** Caso Borde / Consistencia
- **Severidad:** Alta
- **Pasos:**
  1. En una evaluacion nueva (nunca sorteada), agregar preguntas a mano primero (ver [MAN-01] en Nivel 5).
  2. Sin haber usado nunca "Sortear", ir a la pantalla de Sorteo Automatico.
- **Resultado Esperado (Backend):** El chequeo de "ya sorteada" (`validarSiEvaluacionYaSorteada`, invocado en `actividad.service.ts:884` dentro de `sortearPreguntasEvaluacionAuto`) consulta `UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO` (`repository/queries/evaluacion/validar-evaluacion-ya-sorteada.query.ts:5`) — la misma tabla en la que inserta el agregado manual (`PL-SQL/agregar-preguntas-evaluacion.query.ts:17-23`, confirmado: mismo INSERT/SELECT). Se espera que la pantalla muestre "ya sorteada" y bloquee el sorteo automatico, **aunque nunca se ejecuto un sorteo real**. Confirmar si esto es intencional o confunde al docente.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [SRT-12] Resetear Tiempo a un Estudiante que Ya Entrego
- **Tipo:** Regla de Negocio
- **Severidad:** Alta
- **Pasos:**
  1. Con al menos un estudiante que ya entrego su evaluacion (`ENTREGADO='SI'`), presionar "Resetear Tiempo" para el grupo/estudiante.
- **Resultado Esperado (Backend):** El endpoint `resetear-tiempo` no tiene ninguna validacion de negocio (ni parcial activo, ni respuestas existentes, ni si ya entrego) — pone `FECHA_INICIO_EA = NULL` para **todos** los estudiantes de la actividad sin excepcion (`actividad.service.ts:959-971`). Confirmar si esto reabre efectivamente el examen a quien ya entrego sin que el docente lo pretenda.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 
