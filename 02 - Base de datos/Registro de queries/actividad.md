
# Módulo: portafolio-docentes/actividad

*Fecha de auditoría: 2026-09-09T14:35:26.899Z*

## Archivo: /src/modules/actividad/repository/queries/actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     A.ID_ACTIVIDAD,
     A.ID_CURSO,
     A.CODIGO_CONTENIDO,
     A.INST_CODIGO,
     A.MODA_ESTUD_CODIGO,
     A.SIST_ESTUD_CODIGO,
     A.TCICLOACAD_CODIGO,
     A.TFINANCIA_CODIGO,
     ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/actualizar_actividad_sinadjunto.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** UPDATE
- **Fragmento:** `
 UPDATE LMS_TAB_ACTIVIDAD_ACADEMICA
    SET CODIGO_CONTENIDO      = :pCodigoContenido,
        CODIGO_TIPO_EVAL      = :pCodigoTipoEval,
        NOMBRE_CORTO          = :pNombreCorto,
        FECHA_I...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/contenidos.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     T.DESCRIPCION || ' ' || C.ITEM || ' ' || C.DESCRIPCION AS DESCRIPCION,
     C.CODIGO
 FROM ACA_TAB_CONTENIDOS_MATERIAS C
 INNER JOIN ACA_TAB_TIPOS_CONTENIDOS T
     ON C.TCONTENIDO_CODI...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/crear-actividad-sin-adjunto.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** INSERT
- **Fragmento:** `
 INSERT INTO LMS_TAB_ACTIVIDAD_ACADEMICA (
     ID_CURSO,
     CODIGO_CONTENIDO,
     INST_CODIGO,
     MODA_ESTUD_CODIGO,
     SIST_ESTUD_CODIGO,
     TCICLOACAD_CODIGO,
     TFINANCIA_CODIGO,
     ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/evaluacion/curso-actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         ID_CURSO
     FROM UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA
     WHERE ID_ACTIVIDAD = :idActividad
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/evaluacion/eliminar-cuestionario.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     DELETE
         FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO
     WHERE
         CUESTIONARIO_CODIGO = :idActividad
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/evaluacion/eliminar-preguntas-evaluacion.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** DELETE
- **Fragmento:** `
     DELETE FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO
     WHERE PREGUNTA_CODIGO IN (${codigosPreguntas.join(', ')})
     AND CUESTIONARIO_CODIGO = :idActividad
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/evaluacion/estudiantes-evaluacion.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT
         p.CEDULA,
         NOMBRES(p.CEDULA) AS NOMBRES,
         p.GENERO
     FROM UTNDB.RHU_TAB_PERSONAS p
     WHERE EXISTS (
         SELECT 1
         FROM UTNDB.LMS_TAB_PREGUNTAS_...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 18
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT COUNT(*) AS TOTAL
     FROM UTNDB.RHU_TAB_PERSONAS p
     WHERE EXISTS (
         SELECT 1
         FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
         WHERE pc.ESTUDIANTE_CEDULA = p.CE...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 30
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT
     p.CEDULA,
     NOMBRES(p.CEDULA) AS NOMBRES,
     p.GENERO
 FROM UTNDB.RHU_TAB_PERSONAS p
 WHERE EXISTS (
     SELECT 1
     FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
     INNER JOIN ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 84
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COUNT(*) AS TOTAL
 FROM UTNDB.RHU_TAB_PERSONAS p
 WHERE EXISTS (
     SELECT 1
     FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
     INNER JOIN UTNDB.LMS_TAB_PREGUNTAS pre
         ON pc.PRE...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/evaluacion/num-preguntas-evaluacion.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         0 AS MINIMO,
         COUNT(*) AS MAXIMO
     FROM UTNDB.LMS_VIEW_PREGUNTAS_CONTENIDO
     WHERE CODIGO_AULA = :idCurso
     AND TEMA_CODIGO = :codContenido
     AND NIVEL_DIFICU...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/evaluacion/PL-SQL/agregar-preguntas-evaluacion.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     DECLARE
         v_existe NUMBER;
     BEGIN
         FOR pregunta_codigo IN (
             SELECT COLUMN_VALUE AS CODIGO
             FROM TABLE(SYS.ODCINUMBERLIST(${codigosPreguntas.join(', ')...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/evaluacion/preguntas-a-agregar.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT
         PRE.CODIGO,
         PRE.PREGUNTA_HTML AS ENUNCIADO_HTML,
         TPR.NOMBRE AS TIPO_PREGUNTA,
         PRE.NIVEL_DIFICULTAD,
         CASE 
             WHEN CON.DESCRIPCION IS...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 62
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT COUNT(*) AS TOTAL
     FROM UTNDB.LMS_TAB_PREGUNTAS PRE
     INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES AV
         ON PRE.CODIGO_AULA = AV.ID_CURSO
     INNER JOIN UTNDB.LMS_VIEW_PREGUNTAS...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 72
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT COUNT(DISTINCT PREGUNTA_CODIGO) AS COUNT_PREGUNTAS_AGREGADAS
     FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO
     WHERE CUESTIONARIO_CODIGO = :idActividad
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 81
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT
         PRE.CODIGO,
         PRE.PREGUNTA_HTML AS ENUNCIADO_HTML,
         TPR.NOMBRE AS TIPO_PREGUNTA,
         PRE.NIVEL_DIFICULTAD,
         CASE
             WHEN CON.DESCRIPCION IS ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 112
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT
         PRE.CODIGO,
         PRE.PREGUNTA_HTML AS ENUNCIADO_HTML,
         TPR.NOMBRE AS TIPO_PREGUNTA,
         PRE.NIVEL_DIFICULTAD,
         CASE
             WHEN CON.DESCRIPCION IS ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 144
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT COUNT(*) AS TOTAL
     FROM UTNDB.LMS_TAB_PREGUNTAS PRE
     INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES AV
         ON PRE.CODIGO_AULA = AV.ID_CURSO
     INNER JOIN UTNDB.LMS_VIEW_PREGUNTAS...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 170
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT COUNT(DISTINCT PRE.CODIGO) AS TOTAL
     FROM UTNDB.LMS_TAB_PREGUNTAS PRE
     INNER JOIN UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO PCU
         ON PCU.PREGUNTA_CODIGO = PRE.CODIGO
         AN...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 180
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT DISTINCT
         PRE.CODIGO,
         PRE.PREGUNTA_HTML AS ENUNCIADO_HTML,
         TPR.NOMBRE AS TIPO_PREGUNTA,
         PRE.NIVEL_DIFICULTAD,
         CASE
             WHEN CON.DESCRI...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/evaluacion/preguntas-evaluacion.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         pc.SUB_ID AS NRO_PREGUNTA,
         pre.CODIGO AS CODIGO_PREGUNTA,
         pre.PREGUNTA_HTML AS ENUNCIADO_HTML,
         pre.NIVEL_DIFICULTAD,
         tp.NOMBRE AS TIPO_PREGUNT...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 18
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         pc.ESTUDIANTE_CEDULA AS CEDULA,
         pc.SUB_ID AS NRO_PREGUNTA,
         pre.CODIGO AS CODIGO_PREGUNTA,
         pre.PREGUNTA_HTML AS ENUNCIADO_HTML,
         pre.NIVEL_DIFIC...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 36
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         NUM_PREG_EA AS COUNT_PREGUNTAS
     FROM
         LMS_TAB_ACTIVIDAD_ACADEMICA
     WHERE
         ID_ACTIVIDAD = :idActividad
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/evaluacion/validar-cuestionario-respuestas-estudiante.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT CASE 
          WHEN EXISTS (
            SELECT 1 
            FROM UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE 
            WHERE ID_ACTIVIDAD = :idActividad
          ) THEN 1 
          ELSE 0 
 ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/evaluacion/validar-evaluacion-ya-sorteada.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT CASE
             WHEN EXISTS (
             SELECT 1
             FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO
             WHERE CUESTIONARIO_CODIGO = :idActividad
             ) THEN 1
  ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/fecha_de_creacion_actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     A.FECHA_CREACION
 FROM LMS_TAB_ACTIVIDAD_ACADEMICA A
 WHERE A.ID_ACTIVIDAD = :idActividad
         `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/parcial-activo-query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   CASE
     WHEN UTNDB.LMS_FUN_PARCIAL_ACTIVA(:P_CURSO_ID, 'N1') = 'T' THEN 'N1'
     WHEN UTNDB.LMS_FUN_PARCIAL_ACTIVA(:P_CURSO_ID, 'N2') = 'T' THEN 'N2'
     WHEN UTNDB.LMS_FUN_PARCIAL_AC...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/parciales.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 'Primera Parcial' D,'N1' R FROM DUAL
 UNION
 SELECT 'Segunda Parcial' D,'N2' FROM ACA_TAB_REGLAS_NOTAS REG
 INNER JOIN LMS_TAB_AULAS_VIRTUALES AV ON (AV.CODIGO_DEPENDENCIA=REG.DEPEN_CODIGO AN...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/politicas-evaluacion.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT
   CASE :CODIGO_PARCIAL
     WHEN 'N1' THEN TE.DESCRIPCION || ' (' || PE.PORCENTAJE_N1 || '%)'
     WHEN 'N2' THEN TE.DESCRIPCION || ' (' || PE.PORCENTAJE_N2 || '%)'
     WHEN 'N3' THEN TE.DE...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/tipos-actividad-query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DESCRIPCION, CODIGO
 FROM UTNDB.LMS_TAB_TIPO_ACTIVIDAD
 WHERE ESTADO = 'A'
 AND (POLITICA_EVAL_CODIGO IS NULL)
 AND (CODIGO <> 7 AND :P316_CODIGO_TIPO_EVAL <> 35)
 OR (CODIGO = 7 AND :P316_CO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/validar-actividad-activa.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT CASE 
          WHEN EXISTS (
            SELECT 1 
            FROM UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA 
            WHERE ID_ACTIVIDAD = :idActividad 
              AND UTNDB.LMS_FUN_PARCIAL_...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/validar-crear-actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 'T' AS RES
       FROM DUAL
       WHERE (UTNDB.LMS_FUN_PARCIAL_ACTIVA(:idCurso, :codigoParcial) = 'T' AND :idActividad IS NULL)
       UNION
       SELECT 'T' AS RES
       FROM DUAL
       ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/validar-editar-actividad-query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 'T' AS RES FROM DUAL WHERE UTNDB.LMS_FUN_PARCIAL_ACTIVA (:P316_ID_CURSO,:P316_CODIGO_PARCIAL) ='T' AND :P316_ID_ACTIVIDAD IS NOT NULL
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/validar-parcial-activo-query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 select 'T' FROM DUAL where UTNDB.LMS_FUN_PARCIAL_ACTIVA (:P316_ID_CURSO,:P316_CODIGO_PARCIAL) ='T'
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/actividad/repository/queries/validar_fecha_fin_clase_sincrona.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT NOMBRES (AA.CEDULA_INTEGRANTE) CONT
   FROM LMS_TAB_ACTIVIDADES_ALUMNOS AA, LMS_TAB_ACTIVIDAD_ACADEMICA A
  WHERE     AA.ID_ACTIVIDAD = A.ID_ACTIVIDAD
        AND A.ID_ACTIVIDAD != :...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

