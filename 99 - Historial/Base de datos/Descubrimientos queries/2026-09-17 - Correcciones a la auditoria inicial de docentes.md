# Correcciones y Refinamientos a la Auditoría Inicial de Docentes — 2026-09-17

**Repositorio:** `utn-movil-portafolio-docentes`  
**Hubs:** [[00_Indice_Docentes]] · [[2026-09-17 - Como trabajamos la migracion de queries (continuidad-docentes)|Continuidad Docentes]] ·  · [[2026-09-16 - Plan completo migracion queries a vistas y procedimientos (portafolio-docentes)|Plan Maestro Docentes]]

---

## 1. Contexto y Propósito

Antes de comenzar la migración de queries a objetos de base de datos en `utn-movil-portafolio-docentes`, se contrastó el plan maestro preliminar (generado en la auditoría inicial de Gemini) contra la inspección minuciosa del árbol de código fuente y repositorios TypeScript (Claude Code).

El plan inicial de Gemini se preserva como mapa general de planificación y referencia macro, pero se establecen formalmente **5 correcciones y refinamientos técnicos** que deben gobernar la ejecución de la migración.

---

## 2. Las 5 Correcciones Principales

### Corrección 1: Mapa de Módulos Reales (21 módulos de negocio en `src/modules`)
- **Auditoría inicial:** Contabilizaba 22 módulos, incluyendo `config / health` en la tabla de módulos funcionales.
- **Realidad en código:** 
  - Dentro de `src/modules/` existen exactamente **21 módulos de negocio**.
  - `config/` y `health/` se encuentran en la raíz de `src/`. No contienen lógica de negocio ni tablas académicas; únicamente alojan configuración de entorno (`entorno.ts`) y el healthcheck de TypeORM (`SELECT 1 FROM DUAL`), que clasifica como técnico y trivial.

---

### Corrección 2: Conteo de Archivos vs. Sentencias SQL Reales (>242 sentencias)
- **Auditoría inicial:** Registró 242 consultas asumiendo una relación casi 1:1 entre archivos `.query.ts` / `.procedure.ts` y sentencias SQL.
- **Realidad en código:**
  - El repositorio cuenta con ~242 archivos relacionados con persistencia SQL, pero **el volumen de sentencias SQL reales supera las 242**.
  - Un ejemplo claro es el módulo `actividad`: posee 30 archivos en su repositorio de queries, pero contiene **~50 constantes y sentencias SQL independientes** (múltiples variantes de filtros, subconsultas de validación y consultas auxiliares agrupadas en el mismo archivo).
  - La migración debe validar cada constante SQL individual y no dar por completado un archivo si quedan sentencias internas sin migrar.

---

### Corrección 3: Nomenclatura Exacta de Archivos en el Filesystem
- **Auditoría inicial:** Mapeó nombres conjeturales o estandarizados en snake_case para ciertos archivos.
- **Realidad en código:**
  - El proyecto utiliza convenciones kebab-case en varias rutas. Por ejemplo, en `perfil-docente`:
    - El archivo real es `src/modules/perfil-docente/repository/queries/hoja-de-vida.query.ts` (con guiones medios, no `hoja_de_vida.ts`).
    - El archivo real es `src/modules/perfil-docente/repository/queries/carnet-docente.query.ts` (con extensión `.query.ts`, no `.procedure.ts`).
  - Disponer de las rutas exactas archivo por archivo evita fallos en herramientas de búsqueda, scripts de verificación y comandos git.

---

- **Auditoría inicial:** Identificó 5 puntos vulnerables analizando únicamente archivos SQL dentro de carpetas `queries/`.
- **Realidad en código:**
    1. `perfil-docente/repository/queries/hoja-de-vida.query.ts:4-5`
    2. `perfil-docente/repository/queries/carnet-docente.query.ts:17`
    3. `registro-academico/repository/queries/documento-notas-estudiantes.query.ts:7-8`
    4. `aula-virtual/repository/queries/documento-silabo.query.ts:7-8`
    5. `parametros-servidor-reportes/repository/queries/parametros-servidor.query.ts:17,21`
    6. `control_de_bienes/control_de_bienes.service.ts:110`
    7. `pagos/pagos.service.ts:100`
  - Estos 7 puntos se encuentran formalmente congelados bajo (nota interna, no publicada).

---

### Corrección 5: Cardinalidad y Filtros en `foro_online` (Docente vs. Estudiante)
- **Auditoría inicial:** Asumió reutilización directa de todos los objetos creados para `foro_online` en estudiantes.
- **Realidad en código:**
  - En `utn-movil-portafolio-estudiante`, la query `get_instrucciones_actividad.query.ts` se migró a la vista `MVL_VIEW_FORO_INSTRUC_ACT`, que opera vinculada a `ID_ACTIVIDAD_ALUMNO` y a la `CEDULA` del estudiante matriculado.
  - En `utn-movil-portafolio-docentes`, la query `get_instrucciones_actividad.query.ts` filtra exclusivamente por `ID_ACTIVIDAD`, ya que el profesor gestiona la actividad académica a nivel general del curso sin requerir un registro de entrega de alumno.
  - **Acción requerida:** No se puede apuntar el backend docente ciegamente a `MVL_VIEW_FORO_INSTRUC_ACT` sin generar un objeto adecuado o desacoplar el filtro de estudiante.

---

## 3. Criterio Operativo para la Migración

Con estas 5 precisiones documentadas:
1. El **Plan Maestro de Gemini** (`2026-09-16 - Plan completo migracion queries a vistas y procedimientos (portafolio-docentes).md`) se mantiene como **brújula general** para estimar pesos y alcances de cada módulo.
2. Cada módulo se audita en detalle directamente sobre el código TypeScript justo antes de abrir su tanda de migración.
3. El registro de objetos creados en Oracle se mantiene exclusivamente en [[00_Indice_Docentes]] con la serie `D1, D2, D3...`.
