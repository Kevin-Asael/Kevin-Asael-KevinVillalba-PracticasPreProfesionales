# Cambios de BD aplicados

Solo lo que está hecho y probado. Cada nota trae el porqué, los scripts (antes y después) y la prueba de cada objeto.

Comprobado el 2026-10-14: todos los objetos de abajo **existen en `MOVIL_UTN` de desarrollo** (MCP de estructura) y sus scripts están en la rama `practicas-preprofesionales` de su repo. Producción no se puede ver desde aquí: en ninguna fila está verificada.

| Cambio | Repo | Objetos | Prueba | Nota |
|---|---|---|---|---|
| Migración de queries a objetos `MOVIL_UTN` | estudiante | 26 vistas · 13 funciones · 14 procedimientos | los 53 con prueba registrada: MINUS 0/0 (vistas), fila a fila (funciones), de punta a punta (procedimientos) | [[01 - Estudiante - migracion de queries a MOVIL_UTN]] |
| Fase 1: queries a vistas, funciones y procedimientos | docentes | 26 vistas · 2 funciones · 4 procedimientos | 28 con prueba registrada; 4 vistas de evaluación sin prueba por objeto | [[02 - Docentes - fase 1 - queries a vistas y procedimientos]] |
| Fase 2: SELECT a vistas | docentes | 22 vistas | 30 MINUS, 0 diferencias | [[03 - Docentes - fase 2 - SELECT a vistas]] |
| Columna `PLATAFORMA_EVAL` y procedimiento de guardado | docentes | 1 columna en `UTNDB` · 1 procedimiento | procedimiento de dev con el parámetro; columna leída en las pruebas de evaluaciones | [[04 - Docentes - PLATAFORMA_EVAL]] |

## Pendiente común

- [ ] Crear todos estos objetos en producción antes de que el código llegue a `main` (lo hace el DBA).
- [ ] Correr el MINUS de las 4 vistas de evaluación de la fase 1 de docentes que no tienen prueba registrada.

## No aplicado (no es un cambio hecho)

- **Sesión única por intento** (`UTNDB.LMS_PRC_EVAL_TOMAR_SESION` y columnas `SESION_EA_*`): el script está en el historial, pero el procedimiento **no existe** en la base de desarrollo (2026-10-14) y el código no está en `practicas-preprofesionales`.
- **Guarda en `LMS_PRC_CALIFICAR_EVALUACION`** para no descontar un intento ya entregado: propuesta para el DBA, ver [[2026-10-14 - Consumo doble de intentos entre el job y finalizar (estudiante)]].

## Historial de trabajo

Cómo se fue haciendo, con decisiones que luego cambiaron: `99 - Historial/Base de datos/` (notas de continuidad, planes, scripts sueltos y descubrimientos). Para saber qué está aplicado, mandan las notas de arriba.

El registro de cada prueba (Q1–Q53 en estudiante, D1–D19 en docentes) está en `Registro de queries/` (`00_Indice_Resumen` y `00_Indice_Docentes`).
