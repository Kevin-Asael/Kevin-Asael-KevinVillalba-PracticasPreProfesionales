
# Módulo: portafolio-estudiante/ficha_estudiante

*Fecha de auditoría: 2026-09-09T14:35:27.139Z*

- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   CORREO_INSTITUCIONAL, 
   PASSWORD_INICIO AS CLAVE_TEMPORAL_CORREO, 
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/ficha_estudiante/repository/consultas/ficha_estudiante_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   tab_personas.primer_apellido || ' ' || tab_personas.segundo_apellido || ' ' || tab_personas.primer_nombre || ' ' || tab_personas.segundo_nombre AS "APELLIDOS Y NOMBRES", 
   tab_personas....`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

