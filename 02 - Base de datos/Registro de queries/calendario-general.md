
# Módulo: portafolio-docentes/calendario-general

*Fecha de auditoría: 2026-09-09T14:35:26.976Z*

## Archivo: /src/modules/calendario-general/repository/queries/calendario-general.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
            ACTIVIDAD.ID_ACTIVIDAD,
            AULA.ID_CURSO,
            ACTIVIDAD.NOMBRE_CORTO AS ACTIVIDAD_NOMBRE,
            ACTIVIDAD.FECHA_FIN,
            ACTIVIDAD.TIPO_ACT...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/calendario-general/repository/queries/materia-id-curso.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
        TAB_AULAS.ID_CURSO,
        TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
        TAB_DISTRIBUTIVOS.INST_CODIGO,
        TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
        TAB_DISTRIBUTIVOS.SI...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

