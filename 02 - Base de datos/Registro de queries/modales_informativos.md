
# Módulo: portafolio-estudiante/modales_informativos

*Fecha de auditoría: 2026-09-09T14:35:27.158Z*

## Archivo: /src/modules/modales_informativos/repository/consultas/marcar_modal.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 INSERT INTO UTNDB.ENC_TAB_ENCUESTA_USUARIO (
     ENCUESTA_USUARIO_ID,
     ENCUESTA_CODIGO,
     CEDULA_USUARIO,
     ESTADO,
     FECHA,
     OBSERVACION
 ) VALUES (
     (SELECT NVL(MAX(ENCUESTA_...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/modales_informativos/repository/consultas/modales_informativos.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 WITH
     InfoEstudiante AS (
         SELECT SIGLAS FROM (
             SELECT TAB_FAC.SIGLAS
             FROM UTNDB.ACA_TAB_DEPENDENCIAS TAB_FAC
             INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/modales_informativos/repository/modales_informativos.repository.ts
- **Línea aprox:** 30
- **Tipo de operación:** SELECT
- **Fragmento:** `
       SELECT 1 FROM UTNDB.ENC_TAB_ENCUESTA_USUARIO
       WHERE ENCUESTA_CODIGO = :codigoEncuesta AND CEDULA_USUARIO = :cedula
     `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

