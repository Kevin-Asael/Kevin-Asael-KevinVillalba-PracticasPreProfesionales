# 📋 Checklist de Pruebas Post-Migración — Portafolio Estudiante

> **App Flutter ➡️ Backend NestJS ➡️ Objetos Oracle `MOVIL_UTN` (Q1–Q53)**.

Documento detallado paso a paso: [[2026-09-17 - Guia Paso a Paso de Pruebas Post-Migracion (Estudiante)|Guía Detallada Paso a Paso]]  
Hubs relacionados: [[00_Indice_Resumen]] ·  · [[2026-09-14 - Como trabajamos la migracion de queries a vistas (continuidad)|Continuidad Estudiante]]

---

## 🚦 Tabla de Control Rápido

| # | Flujo Crítico | Acción Principal en App | Objetos Clave Validados | Estado | Notas / Resultado |
|:---:|---|---|---|:---:|---|
| **2** | **Modales Informativos** | Visualizar modal de bienvenida/aviso y presionar "Aceptar/Cerrar" | `MVL_PRC_MODAL_MARCAR_VISTO` (Q53) | ⬜ Pendiente | |
| **3** | **Materias y Notas** | Abrir materia activa, revisar notas Parcial 1, 2 y 3 | `MVL_FUN_DETALLES_NOTAS_PARCIAL` (Q37), Vistas de notas | ⬜ Pendiente | |
| **4** | **Asistencia y Avance** | Verificar porcentaje de asistencia y árbol de contenidos | Vistas de asistencia y avance curricular | ⬜ Pendiente | |
| **5** | **Foros de Discusión** | Entrar a un foro y publicar un comentario/respuesta | `MVL_VIEW_FORO_*`, `MVL_FUN_FORO_*`, `MVL_PRC_CREAR_MENSAJE_FORO` | ⬜ Pendiente | |
| **6** | **Entrega de Actividad** | Subir o entregar una tarea pendiente | `MVL_VIEW_INFO_TAREA`, `MVL_PRC_ACTIVIDADES_ENTREGAR_*` | ⬜ Pendiente | *(Punto donde ocurrió el error 500)* |
| **7** | **Evaluación Online** *(Opcional)* | Abrir cuestionario y marcar una alternativa | `MVL_PRC_EVAL_TOGGLE_RESPUESTA_MULTIPLE`, Vistas de examen | ⬜ Pendiente | |

---

## 🧭 Criterios de Éxito Generales
- [ ] La app no muestra pantallas rojas de error de deserialización Dart.
- [ ] Ninguna petición HTTP responde con código `500 Internal Server Error`.
- [ ] Los datos visualizados (notas, comentarios, entregas) persisten tras refrescar la pantalla (pull-to-refresh).
