
# Módulo: portafolio-estudiante/horario_estudiante

*Fecha de auditoría: 2026-09-09T14:35:27.154Z*

## Archivo: /src/modules/horario_estudiante/repository/consultas/horario_activo_estudiante_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   FECHA_INICIO, 
   FECHA_FIN, 
   CASE WHEN LENGTH (INICIO_HORA) = 4 THEN '0' || INICIO_HORA ELSE INICIO_HORA END AS INICIO_HORA, 
   CASE WHEN LENGTH (FIN_HORA) = 4 THEN '0' || FIN_HORA E...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/horario_estudiante/repository/consultas/horario_estudiante_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   FECHA_INICIO, 
   FECHA_FIN, 
   CASE WHEN LENGTH (INICIO_HORA) = 4 THEN '0' || INICIO_HORA ELSE INICIO_HORA END AS INICIO_HORA, 
   CASE WHEN LENGTH (FIN_HORA) = 4 THEN '0' || FIN_HORA E...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

