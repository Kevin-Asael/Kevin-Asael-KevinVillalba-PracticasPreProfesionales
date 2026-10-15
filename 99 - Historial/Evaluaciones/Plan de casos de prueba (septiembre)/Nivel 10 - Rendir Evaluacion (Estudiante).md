# Nivel 10: Rendir Evaluacion (Estudiante)

Pruebas del flujo del estudiante rindiendo un examen configurado por el docente: cargar el
formulario, responder cada tipo de pregunta y finalizar. Contraparte de los Niveles 3-6 (esos son
la gestion del lado docente; este es la experiencia del estudiante que rinde). Repos:
`utn-movil-portafolio-estudiante` (rama `practicas-preprofesionales`) +
`utn_movil_app/lib/apps/portafolio_estudiante/evaluacion_online`.

Hub: [[Tests]]

---

### [REN-01] Cargar Formulario Dentro del Tiempo Permitido
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Entrar a una evaluacion por primera vez, dentro del tiempo permitido.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [REN-02] Recuperar Respuestas Guardadas al Reabrir (Con Conexion)
- **Tipo:** Funcional / Integridad
- **Severidad:** Alta
- **Pasos:**
  1. Responder algunas preguntas, cerrar la app por completo.
  2. Reabrir y volver a entrar al mismo examen.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [REN-03] Entrar a Evaluacion Ya Finalizada
- **Tipo:** Validacion
- **Severidad:** Media
- **Pasos:**
  1. Intentar entrar a un examen que ya se finalizo.
- **Resultado Esperado (App):** Pantalla de error con icono de check y mensaje "ya ha sido finalizada" (`evaluacion_online_error_widget.dart:38-40`), sin permitir reingresar a responder.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [REN-04] Entrar a Evaluacion que Aun No Inicia / Ya Expirada Sin Intentos
- **Tipo:** Validacion
- **Severidad:** Media
- **Pasos:**
  1. Entrar antes de la fecha de inicio.
  2. Entrar despues de expirado el tiempo, sin intentos disponibles.
- **Resultado Esperado (App):** El icono/mensaje depende del texto exacto del backend: "expirado" y "intentos disponibles" siempre matchean bien. Para "aun no inicia" **ojo**: el icono de calendario solo aparece si el mensaje contiene el substring exacto **"inicia el"** (`evaluacion_online_error_widget.dart:26-27`), que es lo que manda el backend cuando conoce la fecha (`"La actividad inicia el {fecha}"`, `evaluacion_online.service.ts:702-704`). Si el backend cae en el mensaje de respaldo sin fecha ("La actividad aún no inicia.", sin fecha conocida) **no** contiene "inicia el" y el icono queda en el generico de error, no en el de calendario — caso borde a confirmar si se puede reproducir.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [REN-05] Responder Seleccion Unica
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Tocar una alternativa de una pregunta de seleccion unica.
- **Resultado Esperado (App/Backend):** Se envia `POST .../responder` de inmediato (no se acumula para el final); confirmar guardado.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [REN-06] Opcion Multiple: Marcar la Misma Alternativa Varias Veces Rapido
- **Tipo:** Caso Borde / Consistencia
- **Severidad:** Media
- **Pasos:**
  1. En una pregunta de opcion multiple, tocar la misma alternativa (marcar) varias veces seguidas muy rapido.
- **Resultado Esperado (Backend):** `toggleRespuestaMultiple`/`INSERTAR_RESPUESTA_MULTIPLE` es un INSERT simple **sin** desactivar duplicados previos ni transaccion (a diferencia de seleccion unica/ensayo/emparejamiento, que sí desactivan+insertan). Es posible que se generen filas activas duplicadas para el mismo par pregunta/alternativa. Confirmar si se nota alguna inconsistencia visual o en la nota final.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [REN-07] Emparejamiento: Cambiar de Opcion Varias Veces
- **Tipo:** Funcional
- **Severidad:** Media
- **Pasos:**
  1. Emparejar un item, luego cambiarlo por otro varias veces.
- **Resultado Esperado (Backend):** Solo debe quedar activa la ultima combinacion (desactiva+inserta por item especifico).
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [REN-08] Ensayo: Guardado por Debounce de 2 Segundos
- **Tipo:** Funcional
- **Severidad:** Media
- **Pasos:**
  1. Escribir una respuesta de ensayo y esperar 2 segundos sin salir del campo.
- **Resultado Esperado (App):** Se guarda solo tras el debounce (`pregunta_comentario_online_widget.dart:33`).
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [REN-09] Ensayo: Guardado Forzado al Perder el Foco Antes del Debounce
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Escribir una respuesta de ensayo y cambiar de pregunta/pantalla **inmediatamente** (antes de los 2s).
- **Resultado Esperado (App):** `_onFocusChange` fuerza el guardado (`flushDebounce: true`, `pregunta_comentario_online_widget.dart:95-101`) — no debe perderse el texto.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [REN-10] Persistencia Visual al Hacer Scroll
- **Tipo:** UI
- **Severidad:** Baja
- **Pasos:**
  1. Responder una pregunta, hacer scroll lejos de ella y volver.
- **Resultado Esperado (App):** La seleccion visual no se pierde (`AutomaticKeepAliveClientMixin` en los widgets de pregunta).
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [REN-11] Finalizar: Confirmacion y Bloqueo de Doble Tap
- **Tipo:** Funcional
- **Severidad:** Alta
- **Pasos:**
  1. Tocar "Finalizar", confirmar el dialogo ("No podra modificar sus respuestas despues").
  2. Intentar tocar "Finalizar" de nuevo mientras procesa.
- **Resultado Esperado (App):** Boton deshabilitado con spinner mientras `finalizando == true` (`evaluacion_online_provider.dart:151`); no se disparan dos finalizaciones concurrentes desde el cliente.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [REN-12] Finalizar con Respuesta Pendiente del Debounce de Ensayo
- **Tipo:** Caso Borde
- **Severidad:** Alta
- **Pasos:**
  1. Escribir una respuesta de ensayo y tocar "Finalizar" antes de que pasen los 2s de debounce.
- **Resultado Esperado (App):** Confirmar si esa ultima respuesta se guarda (por el flush al perder foco) o se pierde.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

- **Tipo:** Seguridad / Regla de Negocio
- **Severidad:** Media
- **Pasos:**
  1. Finalizar con exito y luego intentar volver a la pantalla del examen (navegacion directa o recargar).
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [REN-14] Doble Finalizar en Evaluacion con Mas de 1 Intento Configurado
- **Tipo:** Regla de Negocio / Caso Borde
- **Severidad:** Critica
- **Pasos:**
  1. En una evaluacion con `intentosDisponibles` inicial > 1, finalizar y de inmediato volver a llamar finalizar (doble tap muy rapido, o reintento de red duplicado).
- **Resultado Esperado (Backend):** Tras el primer finalizar, `entregado='SI'` pero `intentosDisponibles` puede seguir >= 1 → `validarEntrega` **no bloquea** un segundo finalizar inmediato (`evaluacion_online.service.ts:658-664`). No hay proteccion explicita contra ejecutar el procedimiento de calificacion dos veces seguidas. Confirmar si esto genera algun efecto visible (nota duplicada, intento consumido de mas, error).
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [REN-15] Resultado con Pregunta de Ensayo Sin Calificar
- **Tipo:** Funcional
- **Severidad:** Media
- **Pasos:**
  1. Finalizar un examen que tiene al menos una pregunta de ensayo.
  2. Ver la pantalla de Resultado antes de que el docente la califique.
- **Resultado Esperado (App):** La nota deberia figurar como pendiente/incompleta hasta que el docente califique manualmente (cruce con [CAL-08] en Nivel 6). Ver nota de incertidumbre en [NEG-06] (Nivel 9): el procedimiento de autocalificacion es PL/SQL, no verificable desde el codigo.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > 

---

### [REN-16] Fuga de Contenido de Examen de Otro Estudiante (IDOR)
- **Tipo:** Seguridad
- **Severidad:** Critica
- **Pasos:**
- **Resultado Esperado (Backend):** Deberia rechazar por no pertenecer al estudiante autenticado.
- **Estado:**
  - [ ] Pendiente
  - [ ] Pasa
  - [ ] Falla
  - [ ] Bloqueado
- **Comentarios / Evidencia:**
  > ⚠ **Predicción según código, a confirmar:** las queries `GET_REGLAS_EVALUACION`,
  > `GET_REGLAS_EVALUACION_RESPONDER` y `GET_FORMULARIO_BASE` filtran **solo** por `idActividadAlumno`,
  > del recurso. Es probable que el contenido del examen (preguntas, y quizas reglas) de otro
  > asi que la **nota final** de otro estudiante no deberia filtrarse por esta via — solo el
  > contenido/formulario. Es un buen caso para correr con dos cuentas de estudiante reales.
