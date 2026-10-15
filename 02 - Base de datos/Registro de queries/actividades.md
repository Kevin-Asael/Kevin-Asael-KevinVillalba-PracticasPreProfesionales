
# Módulo: portafolio-estudiante/actividades

*Fecha de auditoría: 2026-09-09T14:35:27.077Z*

## Archivo: /src/modules/actividades/respository/consultas/get_info_tarea_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT
    ACT_ALUM.ID_ACTIVIDAD_ALUMNO,
    ACT_ALUM.INTENTOS_DISPONIBLES,
    MATERIA.DESCRIPCION "MATERIA",
    ACT_ALUM.DESCRIPCION AS DESCRIPCION_ACTIVIDAD_ALUMNO,
    ACT_ALUM.URL AS URL_ACTIV...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

