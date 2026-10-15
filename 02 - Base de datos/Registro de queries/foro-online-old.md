
# Módulo: portafolio-docentes/foro-online-old

*Fecha de auditoría: 2026-09-09T14:35:26.993Z*

## Archivo: /src/modules/foro-online-old/repository/queries/crear-respuesta-foro-actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** INSERT
- **Fragmento:** `
 INSERT INTO UTNDB.LMS_TAB_FOROS (
     ID_CURSO,
     CODIGO,
     INST_CODIGO,
     MODA_ESTUD_CODIGO,
     SIST_ESTUD_CODIGO,
     TFINANCIA_CODIGO,
     TCICLOACAD_CODIGO,
     CICLO_ACAD_CODIGO,...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro-online-old/repository/queries/crear-respuesta-foro-general.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** INSERT
- **Fragmento:** `
     INSERT INTO UTNDB.LMS_TAB_FOROS (
         ID_CURSO,
         CODIGO,
         INST_CODIGO,
         MODA_ESTUD_CODIGO,
         SIST_ESTUD_CODIGO,
         TFINANCIA_CODIGO,
         TCICLOACAD...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro-online-old/repository/queries/eliminar-respuesta-foro.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** DELETE
- **Fragmento:** `
 DELETE FROM UTNDB.LMS_TAB_FOROS F
 WHERE F.ID_FORO = :idForo
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro-online-old/repository/queries/estado-actividad.dto.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT ESTADO 
 FROM LMS_TAB_ACTIVIDAD_ACADEMICA 
 WHERE ID_ACTIVIDAD = :idActividad
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro-online-old/repository/queries/fecha-fin-actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT FECHA_FIN
 FROM UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA
 WHERE ID_ACTIVIDAD = :idActividad
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro-online-old/repository/queries/foro-actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     F.ID_FORO                                         AS "ID",
     F.ID_FORO_PADRE                                   AS "ID_PADRE",
     F.DESCRIPCION,
     F.FECHA_CREACION                ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro-online-old/repository/queries/foro-general.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     F.ID_FORO                                       AS "ID",
     F.ID_FORO_PADRE                                 AS "ID_PADRE",
     F.DESCRIPCION,
     F.FECHA_CREACION                    ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro-online-old/repository/queries/foto-autor.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT P.FOTO
 FROM UTNDB.LMS_TAB_FOROS F
 INNER JOIN UTNDB.RHU_TAB_PERSONAS P ON P.CEDULA = F.PERSONA_CEDULA
 WHERE F.ID_FORO = :idForo
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro-online-old/repository/queries/instrucciones-foro-actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     ID_ACTIVIDAD    AS "ID_ACTIVIDAD",
     NOMBRE_CORTO    AS "NOMBRE",
     FECHA_INICIO    AS "FECHA_INICIO",
     FECHA_FIN       AS "FECHA_FIN",
     DESCRIPCION     AS "DESCRIPCION"
 F...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro-online-old/repository/queries/usuario-autor-foro.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT F.USUARIO_CREACION
 FROM UTNDB.LMS_TAB_FOROS F
 WHERE F.ID_FORO = :idForo
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

