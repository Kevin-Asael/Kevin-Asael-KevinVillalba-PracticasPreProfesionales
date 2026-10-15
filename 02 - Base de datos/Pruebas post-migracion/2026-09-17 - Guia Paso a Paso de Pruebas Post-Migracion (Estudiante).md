# Guía Paso a Paso de Pruebas Post-Migración (Portafolio Estudiante) — 2026-09-17

**Módulo:** Pruebas integrales de validación en app móvil (Smoke Test)  
**Repositorio backend:** `utn-movil-portafolio-estudiante` (Rama `practicas-preprofesionales`)  
**Base de datos:** Oracle réplica dev — Esquema `MOVIL_UTN` (Objetos Q1 a Q53 creados)  
**Checklist de seguimiento:** [[00_Checklist_Smoke_Test_Estudiante]]

---

## 1. Propósito y Alcance

Durante la fase de migración de queries de estudiante se encapsularon **39 sentencias SELECT en vistas/funciones** y **14 operaciones de escritura en procedimientos almacenados** (`MOVIL_UTN`).

Aunque cada objeto fue validado matemáticamente mediante `MINUS` y probado individualmente con `curl` en local, este **Smoke Test (10 a 15 minutos en el celular)** tiene como objetivo verificar la **integración vertical completa**:
```
[ App Móvil Flutter ] 
       ⬇️ (TypeORM / oracledb Pool)
[ Base de Datos Oracle DEV (Esquema MOVIL_UTN) ]
```

---

## 2. Prerrequisitos de Prueba

3. **Cuenta de prueba recomendada:**
   - Cuenta de pruebas `<cuenta-de-prueba>` (cédula `<cedula>`), o la cuenta de un estudiante activo en dev.

---

## 3. Flujos Críticos a Probar Paso a Paso

---

### Flujo 1: Inicio de Sesión, Ficha y Modales Informativos
*Valida: Vistas de datos personales y `MVL_PRC_MODAL_MARCAR_VISTO` (Q53).*

1. **Abrir la app** en el dispositivo móvil e iniciar sesión.
2. **Verificar pantalla de inicio (Home):**
   - Confirmar que aparezcan el nombre del estudiante, carrera y período académico actual.
3. **Prueba del Modal Informativo (Q53):**
   - Si se despliega un aviso emergente o comunicado institucional, presionar el botón **"Entendido"**, **"Aceptar"** o **"Cerrar"**.
   - Cerrar completamente la app (quitarla de aplicaciones recientes) y volver a abrirla.
   - **Criterio de éxito:** El modal informativo no debe volver a mostrarse (indica que el procedimiento `MVL_PRC_MODAL_MARCAR_VISTO` insertó el registro de visualización con código `204` en base de datos).

---

### Flujo 2: Aula Virtual — Materias y Calificaciones
*Valida: `MVL_FUN_DETALLES_NOTAS_PARCIAL` (Q37 reescrita con funciones analíticas) y vistas de calificaciones.*

1. En el menú inferior o lateral, navegar a **"Aula Virtual"** o **"Mis Materias"**.
2. Seleccionar cualquier materia en la que el estudiante tenga matrícula activa.
3. Ingresar a la pestaña **"Calificaciones"** o **"Notas"**.
4. Alternar entre **Parcial 1**, **Parcial 2** y **Parcial 3**.
5. **Criterio de éxito:**
   - Las notas parciales, subtotales y promedios deben renderizarse en pantalla sin cierres inesperados ni pantallas rojas de error en Flutter.
   - Verificar que los decimales cuadren y que la petición HTTP a `/aula-virtual/detalles-notas-parcial` responda con código `200 OK`.

---

### Flujo 3: Aula Virtual — Asistencia y Avance Curricular
*Valida: Vistas de registro de asistencias y árbol de sílabo.*

1. Dentro de la misma materia, acceder a la sección de **"Asistencias"**.
2. Verificar que se muestre el resumen general:
   - Total de horas, asistencias y porcentaje de inasistencias.
3. Acceder a la sección de **"Avance de la Materia"** o **"Contenidos"**.
4. **Criterio de éxito:**
   - La lista de fechas y temas del sílabo se despliega correctamente.

---

### Flujo 4: Foros de Discusión (Lectura y Publicación)
*Valida: Objetos Q1 a Q6 (`MVL_VIEW_FORO_*`, `MVL_FUN_FORO_*`) y procedimiento `MVL_PRC_CREAR_MENSAJE_FORO`.*

1. En la materia seleccionada, entrar a la pestaña **"Foros"**.
2. Abrir un foro general o foro de actividad académica existente.
3. Comprobar que se cargue el árbol de mensajes previos con los nombres de autor y roles (docente / alumno).
4. Redactar una respuesta o comentario de prueba:
   ```text
   Prueba de integración post-migración - 17 de Septiembre
   ```
5. Presionar el botón **"Publicar"** o **"Enviar"**.
6. **Criterio de éxito:**
   - El mensaje se envía de inmediato sin error `500`.
   - El nuevo comentario aparece publicado al final de la lista del foro.

---

### Flujo 5: Entrega de Tareas / Actividades (Punto crítico del Error 500)
*Valida: `MVL_VIEW_INFO_TAREA` y `MVL_PRC_ACTIVIDADES_ENTREGAR_REUTILIZAR_ADJUNTO`.*

> [!IMPORTANT]
> Este es el flujo donde la app registró el error `500 No se pudo entregar la actividad` cuando la base de datos no tenía sincronizados los objetos de escritura.

1. Navegar a **"Actividades"** o **"Tareas"**.
2. Seleccionar una actividad que esté activa y tenga intentos disponibles de entrega.
3. Observar que cargue correctamente la información del docente:
   - Fecha límite, ponderación, instrucciones y documento adjunto del docente (si aplica).
4. Realizar una entrega:
   - Adjuntar un archivo liviano (PDF o imagen de prueba) o escribir una observación en el campo de texto.
   - Presionar **"Entregar Tarea"**.
5. **Criterio de éxito:**
   - La app muestra la notificación emergente de confirmación exitosa.
   - El estado de la tarea cambia visiblemente a **"Entregado"**.
   - En el log de Flutter / terminal ya **NO aparece el error 500**, sino una respuesta exitosa `200` o `201`.

---

### Flujo 6: Evaluación Online (Si hay una evaluación habilitada)
*Valida: Procedimientos Q48 a Q52 (`MVL_PRC_EVAL_*`).*

1. Si existe una prueba/cuestionario habilitado en dev, ingresar a la evaluación.
2. Contestar una pregunta de opción múltiple (marcar y desmarcar opciones).
3. **Criterio de éxito:**
   - El estado de la respuesta se sincroniza sin latencia bloqueante ni excepciones en pantalla.

---

## 4. Guía de Diagnóstico Rápido (Si algo falla)

| Síntoma en App | Causa más probable | Cómo verificar y solucionar |
|---|---|---|
| **Pantalla roja / gris en Flutter (TypeError)** | Incompatibilidad de tipos al deserializar en Dart (ej. `int` en vez de `double`, o un campo `null`). | Contrastar el JSON que devuelve el endpoint contra el DTO esperado en Flutter. |
