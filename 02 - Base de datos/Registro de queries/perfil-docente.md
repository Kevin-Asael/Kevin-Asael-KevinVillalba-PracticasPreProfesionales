
# Módulo: portafolio-docentes/perfil-docente

*Fecha de auditoría: 2026-09-09T14:35:27.016Z*

## Archivo: /src/modules/perfil-docente/repository/queries/carnet-docente.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 DECLARE
   -- 1) Lee la cédula desde el bind de entrada
   v_cedula  VARCHAR2(15) := :G_CEDULA_USUARIO;
   htpServer VARCHAR2(200);
   v_url     VARCHAR2(4000);
 BEGIN
   -- 2) Obtén la URL base
   ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/perfil-docente/repository/queries/cedenciales-docente.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     CORREO_INSTITUCIONAL,
     PASSWORD_INICIO AS "CLAVE_TEMPORAL_CORREO",
     'http://edu...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/perfil-docente/repository/queries/cedula-digital.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   ID_DOCUMENTO,
   CEDULA,
   NOMBRE_ARCHIVO,
   'CEDULA DIGITAL' AS TIPO_DOCUMENTO,
   DOC_FUN_URL_DOCUMENTO(ID_DOCUMENTO) AS URL
 FROM DOC_TAB_DOCUMENTOS
 WHERE 
   ID_TIPO_DOCUMENTO = 1
...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/perfil-docente/repository/queries/foto-docente.query.ts
- **Línea aprox:** 7
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT CASE WHEN TAB_PERSONAS.FOTO IS NOT NULL
               AND DBMS_LOB.GETLENGTH(TAB_PERSONAS.FOTO) > 0
             THEN 1 ELSE 0 END AS "TIENE_FOTO"
   FROM UTNDB.RHU_TAB_PERSONAS TAB_PERSONAS...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/perfil-docente/repository/queries/hoja-de-vida.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     SUBSTR(ip2.valor, 1, LENGTH(ip2.valor) - 1) || '?' ||
     'INSCRIPCION/[REDACTED]@' || 'servidor' ||
 ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/perfil-docente/repository/queries/perfil-docente.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
     TAB_PERSONAS.PRIMER_NOMBRE || ' ' || TAB_PERSONAS.SEGUNDO_NOMBRE AS "NOMBRES",
     TAB_PERSONAS.PRIMER_APELLIDO || ' ' || TAB_PERSONAS.SEGUNDO_APELLIDO AS "APELLIDOS",
     TAB...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

