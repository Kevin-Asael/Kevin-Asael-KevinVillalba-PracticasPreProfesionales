
# Módulo: portafolio-estudiante/notas_estudiante

*Fecha de auditoría: 2026-09-09T14:35:27.162Z*

## Archivo: /src/modules/notas_estudiante/repository/consultas/arbol_de_materias_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     CASE
         WHEN CONNECT_BY_ISLEAF = 1 THEN 0
         WHEN LEVEL = 1 THEN 1
         ELSE -1
         END AS status,
     LEVEL,
     CASE
         WHEN "CODIGO_NODO" = '00199' THEN ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/notas_estudiante/repository/consultas/carrera_estudiante_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   CASE WHEN CONNECT_BY_ISLEAF = 1 THEN 0 WHEN LEVEL = 1 THEN 1 ELSE -1 END AS status, 
   LEVEL, 
   "NOMBRE" AS title, 
   "CO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/notas_estudiante/repository/consultas/notas_ciclo_actual_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         TAB_MATERIAS.codigo,
         VIEW_DEPENDENCIAS.FACULTAD AS FACULTAD,
         UPPER (VIEW_DEPENDENCIAS.CARRERA) AS CARRERA,
         TAB_MATERIAS.DESCRIPCION AS MATERIA,
       ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/notas_estudiante/repository/consultas/notas_por_ciclo_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   MATERIA AS MATERIA, 
   NIVEL AS NIVEL, 
   PARALELO AS PARALELO, 
   MATRICULA AS "N_MATRICULA", 
   DOCENTE AS DOCENTE, 
 ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/notas_estudiante/repository/consultas/notas_por_nivel_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     MATERIA AS MATERIA,
     NIVEL AS NIVEL,
     PARALELO AS PARALELO,
     MATRICULA AS "N_MATRICULA",
     DOCENTE AS DOCENTE,
     NOTA_1 AS "NOTA_1",
     NOTA_2 AS "NOTA_2",
     NOTA_...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

