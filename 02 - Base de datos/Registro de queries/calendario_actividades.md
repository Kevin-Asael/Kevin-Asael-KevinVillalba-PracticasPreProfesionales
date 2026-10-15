
# Módulo: portafolio-estudiante/calendario_actividades

*Fecha de auditoría: 2026-09-09T14:35:27.105Z*

## Archivo: /src/modules/calendario_actividades/repository/consultas/calendario_actividades_consulta.ts
- **Línea aprox:** 12
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     DISTINCT CASE
         WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 5 THEN 'P'
         WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 2 THEN 'X'
         ELSE 'A'
     END AS TIPO,
     ACT_ALUMNO.ID_ACTIVIDAD_ALU...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 159
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     MIN(ACTIVIDAD.FECHA_INICIO) AS FECHA_MINIMA,
     MAX(ACTIVIDAD.FECHA_FIN) AS FECHA_MAXIMA
 FROM
     LMS_TAB_ACTIVIDAD_ACADEMICA ACTIVIDAD
     INNER JOIN LMS_TAB_AULAS_VIRTUALES AULA O...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

