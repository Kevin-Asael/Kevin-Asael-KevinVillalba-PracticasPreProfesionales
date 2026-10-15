
# Módulo: portafolio-docentes/foro_online

*Fecha de auditoría: 2026-09-09T14:35:27.000Z*

## Archivo: /src/modules/foro_online/repository/consultas/autores_foro.query.ts
- **Línea aprox:** 3
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         p.CEDULA                                          AS "CEDULA",
         p.PRIMER_NOMBRE || ' ' || p.PRIMER_APELLIDO       AS "NOMBRE",
         p.GENERO                          ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/crear_respuesta_actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** INSERT
- **Fragmento:** `
     INSERT INTO UTNDB.LMS_TAB_FOROS (
         ID_CURSO, CODIGO, INST_CODIGO, MODA_ESTUD_CODIGO, SIST_ESTUD_CODIGO,
         TFINANCIA_CODIGO, TCICLOACAD_CODIGO, CICLO_ACAD_CODIGO, DEPEN_CODIGO,
   ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/crear_respuesta_general.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** INSERT
- **Fragmento:** `
     INSERT INTO UTNDB.LMS_TAB_FOROS (
         ID_CURSO, CODIGO, INST_CODIGO, MODA_ESTUD_CODIGO, SIST_ESTUD_CODIGO,
         TFINANCIA_CODIGO, TCICLOACAD_CODIGO, CICLO_ACAD_CODIGO, DEPEN_CODIGO,
   ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/estado_actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT 
         ESTADO 
     FROM 
         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA 
     WHERE 
         ID_ACTIVIDAD = :idActividad
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/fecha_fin_actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT 
         FECHA_FIN
     FROM 
         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA 
     WHERE 
         ID_ACTIVIDAD = :idActividad
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/foro_actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         f.ID_FORO                                         AS "ID",
         f.ID_FORO_PADRE                                   AS "ID_PADRE",
         f.DESCRIPCION                       ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/foro_general.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         f.ID_FORO                                       AS "ID",
         f.ID_FORO_PADRE                                   AS "ID_PADRE",
         f.DESCRIPCION                         ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/get_instrucciones_actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         ACT.ID_ACTIVIDAD    AS "ID_ACTIVIDAD",
         ACT.NOMBRE_CORTO    AS "NOMBRE",
         ACT.FECHA_INICIO    AS "FECHA_INICIO",
         ACT.FECHA_FIN       AS "FECHA_FIN",
    ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/tipo_foro.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
   SELECT 
     TIPO,
     ID_ACTIVIDAD
   FROM 
     UTNDB.LMS_TAB_FOROS 
   WHERE 
     ID_FORO = :idForo
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/validar_actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         ESTADO  AS "ESTADO",
         FECHA_FIN AS "FECHA_FIN"
     FROM
         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA
     WHERE
         ID_ACTIVIDAD = :idActividad
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.



---

## Actualización (Repositorio portafolio-estudiante)


# Módulo: portafolio-estudiante/foro_online

*Fecha de auditoría: 2026-09-09T14:35:27.145Z*

## Archivo: /src/modules/foro_online/repository/consultas/autores_foro.query.ts
- **Línea aprox:** 3
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         p.CEDULA                                          AS "CEDULA",
         p.PRIMER_NOMBRE || ' ' || p.PRIMER_APELLIDO       AS "NOMBRE",
         p.GENERO                          ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/crear_respuesta_actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** INSERT
- **Fragmento:** `
     INSERT INTO UTNDB.LMS_TAB_FOROS (
         ID_CURSO, CODIGO, INST_CODIGO, MODA_ESTUD_CODIGO, SIST_ESTUD_CODIGO,
         TFINANCIA_CODIGO, TCICLOACAD_CODIGO, CICLO_ACAD_CODIGO, DEPEN_CODIGO,
   ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/crear_respuesta_general.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** INSERT
- **Fragmento:** `
     INSERT INTO UTNDB.LMS_TAB_FOROS (
         ID_CURSO, CODIGO, INST_CODIGO, MODA_ESTUD_CODIGO, SIST_ESTUD_CODIGO,
         TFINANCIA_CODIGO, TCICLOACAD_CODIGO, CICLO_ACAD_CODIGO, DEPEN_CODIGO,
   ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/estado_actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT 
         ESTADO 
     FROM 
         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA 
     WHERE 
         ID_ACTIVIDAD = :idActividad
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/fecha_fin_actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT 
         FECHA_FIN
     FROM 
         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA 
     WHERE 
         ID_ACTIVIDAD = :idActividad
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/foro_actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         f.ID_FORO                                         AS "ID",
         f.ID_FORO_PADRE                                   AS "ID_PADRE",
         f.DESCRIPCION                       ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/foro_general.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         f.ID_FORO                                       AS "ID",
         f.ID_FORO_PADRE                                   AS "ID_PADRE",
         f.DESCRIPCION                         ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/get_instrucciones_actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         ACT.ID_ACTIVIDAD    AS "ID_ACTIVIDAD",
         ACT.NOMBRE_CORTO    AS "NOMBRE",
         ACT.FECHA_INICIO    AS "FECHA_INICIO",
         ACT.FECHA_FIN       AS "FECHA_FIN",
    ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/marcar_actividad_entregada.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS 
     SET ENTREGADO = 'SI' 
     WHERE ID_ACTIVIDAD = :idActividad 
       AND ID_CURSO = (SELECT ID_CURSO FROM UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA WHERE I...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/tipo_foro.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
   SELECT 
     TIPO,
     ID_ACTIVIDAD
   FROM 
     UTNDB.LMS_TAB_FOROS 
   WHERE 
     ID_FORO = :idForo
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/foro_online/repository/consultas/validar_actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         ESTADO  AS "ESTADO",
         FECHA_FIN AS "FECHA_FIN"
     FROM
         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA
     WHERE
         ID_ACTIVIDAD = :idActividad
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

