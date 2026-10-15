
# Módulo: portafolio-docentes/aula-virtual

*Fecha de auditoría: 2026-09-09T14:35:26.932Z*

## Archivo: /src/modules/aula-virtual/repository/queries/actividades.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
     TAB.ID_ACTIVIDAD,
     CON.DESCRIPCION AS TEMA, 
     TAB.FECHA_FIN AS FECHA,
     TEVAL.DESCRIPCION AS TIPO,
     TAB.TIPO_ACTIVIDAD,
     TAB.EVAL_AUTO AS ES_EVALUACION_AUTOMA...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/calendario-materia/calendario-detalle.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
        ACTIVIDAD.ID_ACTIVIDAD,
        ACTIVIDAD.NOMBRE_CORTO,
        ACTIVIDAD.FECHA_FIN,
        MATERIA.DESCRIPCION AS MATERIA,
        AULA.ID_CURSO,
        CASE
          WHE...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/calificaciones/actualizar-calificacion-quey.ts
- **Línea aprox:** 1
- **Tipo de operación:** UPDATE
- **Fragmento:** `
 UPDATE LMS_TAB_ACTIVIDADES_ALUMNOS 
 SET 
     INTENTOS_DISPONIBLES = :intentos_disponibles,
     CALIFICACION = :calificacion,
     OBSERVACION = NVL(:observacion, OBSERVACION)    
 WHERE 
     ID_...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/calificaciones/decripcion-calificacion-actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     NOMBRE_CORTO AS TEMA,
     DESCRIPCION,
     TO_CHAR(FECHA_INICIO, 'YYYY-MM-DD HH24:MI:SS') AS FECHA_INICIO,
     TO_CHAR(FECHA_FIN, 'YYYY-MM-DD HH24:MI:SS') AS FECHA_FIN,
     ID_CURSO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/calificaciones/lista-estudiantes-actividad-supletorio.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
        -- 1) Actividad y alumno
        ACTIV_ALUMNOS.ID_ACTIVIDAD_ALUMNO,
        ACTIV_ALUMNOS.ID_ACTIVIDAD,
        ACTIV_ALUMNOS.ID_CURSO,
        ACTIV_ALUMNOS.CEDULA_INTEGRANTE,
 
    ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/calificaciones/lista-estudiantes-actividad.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     /* 1) Campos principales (similares a tu consulta nueva) */
     ACTIV_ALUMNOS.ID_ACTIVIDAD_ALUMNO,
     ACTIV_ALUMNOS.ID_ACTIVIDAD,
     ACTIV_ALUMNOS.ID_CURSO,
     ACTIV_ALUMNOS.CEDUL...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/calificaciones/validar-calificacion-regular.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
 ID_ACTIVIDAD
 FROM UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA
 WHERE CODIGO_TIPO_EVAL = 27
 AND ID_ACTIVIDAD = :P119_ID_ACTIVIDAD
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/calificaciones/validar-guardar-calificacion-qury.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT A.ID_ACTIVIDAD FROM LMS_TAB_ACTIVIDAD_ACADEMICA A WHERE A.ID_ACTIVIDAD = :P120_ID_ACTIVIDAD AND :P120_ID_ACTIVIDAD_ALUMNO IS NOT NULL AND UTNDB.LMS_FUN_PARCIAL_ACTIVA (A.ID_CURSO,A.CODIGO_PAR...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/contenidos-materia.query.ts
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

## Archivo: /src/modules/aula-virtual/repository/queries/detalles_notas_estudiante.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 WITH calificaciones AS (
     SELECT 
         AA2.CODIGO_TIPO_EVAL,
         SUM(ALU2.CALIFICACION) AS SUMA_CALIFICACIONES,
         COUNT(ALU2.ID_ACTIVIDAD_ALUMNO) AS TOTAL_ACTIVIDADES
     FROM 
...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/documento-silabo.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT 
     (SELECT SUBSTR(valor, 1, LENGTH(valor) - 1) || '?' 
      FROM INS_TAB_PARAMETROS 
      WHERE CODIGO = '00002') 
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/notas/habilitar-notas-query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 WITH materia AS (
     SELECT DISTINCT AV.CODIGO_MATERIA
       FROM LMS_TAB_AULAS_VIRTUALES AV
      WHERE AV.ID_CURSO        = :idCurso
        AND AV.CEDULA_DOCENTE  = :cedulaDocente
 ),
 notas A...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/notas/notas-aula-virtual.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT LMS_TAB_INTEGRANTES.ID_CURSO,
        LMS_TAB_INTEGRANTES.CEDULA_INTEGRANTE,
        -- Aquí reemplazamos la función FUN_NOMBRES_PERSONA por columnas directas:
     (P.PRIMER_APELLIDO || ' ' ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/obtener-recurso-por-id.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     R.ID_RECURSO,
     R.ID_CURSO,
     R.CONTENIDO_CODIGO,
     R.ID_TRECURSO,
     TR.DESCRIPCION AS TIPO,
     R.DESCRIPCION,
     R.URL,
     R.ESTADO,
     D.NOMBRE_ARCHIVO AS ADJUNTO_...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/parcial-activo-query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   CASE
     WHEN UTNDB.LMS_FUN_PARCIAL_ACTIVA_NOTAS(:P_CURSO_ID, 'N1') = 'S' THEN 'N1'
     WHEN UTNDB.LMS_FUN_PARCIAL_ACTIVA_NOTAS(:P_CURSO_ID, 'N2') = 'S' THEN 'N2'
     WHEN UTNDB.LMS_FU...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/parciales-materia.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 'Primera Parcial' D,'N1' R FROM DUAL
 UNION
 SELECT 'Segunda Parcial' D,'N2' FROM ACA_TAB_REGLAS_NOTAS REG
 INNER JOIN LMS_TAB_AULAS_VIRTUALES AV ON (AV.CODIGO_DEPENDENCIA=REG.DEPEN_CODIGO AN...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/PL-SQL/eliminar-recurso.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** UPDATE
- **Fragmento:** `
 BEGIN
     UPDATE LMS_TAB_RECURSOS 
     SET ESTADO = 'I', 
         ID_RECURSO_ANTERIOR = NULL,
         FECHA_ACTUALIZACION = SYSDATE
     WHERE ID_RECURSO = :pIdRecurso;
     COMMIT;
 END;
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/recursos-ver-query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT    
     R.ID_RECURSO,
     NVL(C.DESCRIPCION, 'SIN TEMA') AS TEMA,
     TR.DESCRIPCION AS TIPO,
     R.DESCRIPCION,
     D.NOMBRE_ARCHIVO AS ADJUNTO,
     R.ID_DOCUMENTO_DIRECTORIO,
     R.U...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/tipos-recurso.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     DESCRIPCION, 
     ID_TRECURSO 
 FROM UTNDB.LMS_TAB_TIPO_RECURSO
 ORDER BY ID_TRECURSO
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula-virtual/repository/queries/validar-habilitar-recurso.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 'T' AS RES FROM DUAL 
 WHERE :habilitarNota1 IN ('T', 'TX')
 UNION
 SELECT 'T' AS RES FROM DUAL 
 WHERE :habilitarNota2 IN ('T', 'TX')
 UNION
 SELECT 'T' AS RES FROM DUAL 
 WHERE :habilitarNo...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

