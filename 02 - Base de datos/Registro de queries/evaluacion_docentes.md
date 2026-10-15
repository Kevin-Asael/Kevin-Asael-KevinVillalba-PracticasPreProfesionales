
# Módulo: portafolio-estudiante/evaluacion_docentes

*Fecha de auditoría: 2026-09-09T14:35:27.126Z*

## Archivo: /src/modules/evaluacion_docentes/repository/consultas/evaluacion_docentes.queries.ts
- **Línea aprox:** 27
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         TE.DOCENTE_CEDULA,
         UTNDB.INS_PCK_GENERAL.FUN_NOMBRES_PERSONA(TE.DOCENTE_CEDULA) AS "NOMBRES",
         TM.DESCRIPCION AS "MATERIA",
         TD.DESCRIPCION AS "CARRERA",...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 81
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT DISTINCT
         TE.CODIGO           AS "CODIGO_EVALUACION",
         TE.DESCRIPCION      AS "TITULO",
         TE.OBSERVACION      AS "DESCRIPCION"
     FROM
         UTNDB.EVA_TAB_EVAL...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 100
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT
     -- Informacion de la Pregunta
     P.CODIGO           AS "CODIGO_PREGUNTA",
     P.ETIQUETA,
     P.CODIGO_TIPO_PREG AS "TIPO_PREGUNTA",
     TTC.DESCRIPCION    AS "TIPO_COMPONENTE",
   ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 179
- **Tipo de operación:** INSERT
- **Fragmento:** `
     MERGE INTO UTNDB.EVA_TAB_RESPUESTAS R
     USING (
         SELECT
             :1 AS DOCENTE_CEDULA, :2 AS INST_CODIGO, :3 AS MODA_ESTUD_CODIGO,
             :4 AS SIST_ESTUD_CODIGO, :5 AS TCIC...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 249
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT ESTADO FROM UTNDB.EVA_TAB_RESPUESTAS
     WHERE DOCENTE_CEDULA = :1 AND INST_CODIGO = :2 AND MODA_ESTUD_CODIGO = :3
       AND SIST_ESTUD_CODIGO = :4 AND TCICLOACAD_CODIGO = :5 AND TFINAN...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 292
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COUNT(DISTINCT P.CODIGO) AS "TOTAL"
 FROM UTNDB.EVA_TAB_PREGUNTAS P
 WHERE P.CODIGO_EVALUACION = :1
   AND EXISTS (
       SELECT 1
       FROM UTNDB.EVA_TAB_PREGUNTAS_ACTIVIDADES PAC
       ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 317
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COUNT(DISTINCT R.CODIGO_PREGUNTA) AS "RESPONDIDAS"
 FROM UTNDB.EVA_TAB_RESPUESTAS R
 INNER JOIN UTNDB.EVA_TAB_PREGUNTAS P ON P.CODIGO = R.CODIGO_PREGUNTA
 WHERE R.ESTADO = 'A' 
   AND R.DOCEN...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

