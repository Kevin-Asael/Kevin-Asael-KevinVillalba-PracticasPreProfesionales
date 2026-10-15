# Nivel 9: Flujos de Negocio, Casos Borde y Reglas Especiales

Pruebas complejas de ciclo de vida academico, concurrencia y reglas institucionales.

Hub: [[Tests]]

---

### [NEG-01] Edicion de Preguntas Durante Examen en Progreso
- **Tipo:** Regla de Negocio
- **Severidad:** Critica
- **Pasos:**
  1. Examen en curso con estudiantes respondiendo.
  2. El docente intenta editar una pregunta desde el banco.
- **Resultado Esperado (App/Backend):** El sistema bloquea la modificacion para no alterar las preguntas cargadas en los cuestionarios de los alumnos.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [NEG-02] Sorteo con Cantidad Exacta (N preguntas para N estudiantes)
- **Tipo:** Logica de Sorteo
- **Severidad:** Media
- **Pasos:**
  1. El banco tiene 10 preguntas y se piden 10 con cuestionario diferente (`esCuestionarioDiferente = 'S'`).
- **Resultado Esperado (Backend):** Asigna las 10 preguntas a todos pero en diferente orden aleatorio de aparicion.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [NEG-03] Aumento de Intentos Permitidos Post-Examen
- **Tipo:** Regla de Negocio
- **Severidad:** Alta
- **Pasos:**
  1. Alumno agota su unico intento (1/1).
  2. Docente edita la actividad aumentando a 2 intentos.
- **Resultado Esperado (App Estudiante):** El estudiante ve habilitado el boton para rendir su segundo intento.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [NEG-04] Cierre Anticipado de Fecha Fin por el Docente
- **Tipo:** Regla de Negocio
- **Severidad:** Alta
- **Pasos:**
  1. Docente adelanta la fecha/hora de fin a la hora actual mientras hay alumnos dando la prueba.
- **Resultado Esperado (Backend):** Las evaluaciones activas se cierran automaticamente registrando las respuestas guardadas hasta ese segundo.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [NEG-05] Fallback ante Falla de Cola BullMQ (Autocalificacion)
- **Tipo:** Arquitectura / Resiliencia
- **Severidad:** Critica
- **Pasos:**
  1. Simular caida temporal del procesador de cola BullMQ al finalizar una prueba.
- **Resultado Esperado (Docente):** El docente puede abrir revision de respuestas y calificar/recalcular manualmente como respaldo — **pero solo si el estudiante llega a tocar "Finalizar" el manualmente**; si nunca lo hace (por ejemplo porque confia en que el tiempo lo cerrara solo), nada calificara ese intento.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [NEG-06] Examen Mixto (Objetivas + Ensayo)
- **Tipo:** Logica de Calificacion
- **Severidad:** Alta
- **Pasos:**
  1. Examen con 4 preguntas de opcion multiple y 1 de ensayo.
  2. El alumno finaliza.
- **Resultado Esperado (Docente):** Las 4 objetivas se autocalifican inmediatamente y el examen queda marcado con estado "Pendiente de calificacion" hasta que el docente califique el ensayo.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > ⚠ El procedimiento real `UTNDB.LMS_PRC_CALIFICAR_EVALUACION` que hace la autocalificacion es
  > PL/SQL, no esta en ninguno de los dos repos de codigo — el resultado esperado aqui es una
  > inferencia razonable a partir del campo `calificada` del modelo de resultado, no una confirmacion
  > de codigo. Este caso es el que realmente lo verifica de forma empirica.

---

### [NEG-07] Importacion Masiva (>500 Preguntas)
- **Tipo:** Rendimiento
- **Severidad:** Media
- **Pasos:**
  1. Importar un banco completo con mas de 500 preguntas.
- **Resultado Esperado (App):** La paginacion y filtros del banco responden de forma fluida sin congelar la UI.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [NEG-08] Caracteres Especiales y Emojis en Respuestas de Ensayo
- **Tipo:** Integridad / Codificacion
- **Severidad:** Media
- **Pasos:**
  1. Revisar respuesta de ensayo que contiene tildes, comillas dobles, saltos de linea y emojis.
- **Resultado Esperado (App):** Se renderiza exactamente el texto escrito sin caracteres corruptos (``).
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [NEG-09] Edicion Simultanea de Pregunta por Dos Docentes
- **Tipo:** Concurrencia
- **Severidad:** Media
- **Pasos:**
  1. Dos docentes de la misma catedra abren y guardan cambios en la misma pregunta al mismo tiempo.
- **Resultado Esperado (Backend):** La base de datos aplica bloqueo optimista/pesimista sin corromper alternativas.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [NEG-10] Zona Horaria y Sincronizacion de Reloj
- **Tipo:** Integridad
- **Severidad:** Alta
- **Pasos:**
  1. Crear evaluacion para las 15:00 en zona horaria del servidor.
- **Resultado Esperado (App/Backend):** Las validaciones de inicio y fin se calculan estrictamente con la hora UTC/servidor y no con la hora manipulable del dispositivo movil.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 
