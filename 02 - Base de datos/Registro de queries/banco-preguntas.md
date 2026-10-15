
# Módulo: portafolio-docentes/banco-preguntas

*Fecha de auditoría: 2026-09-09T14:35:26.959Z*

## Archivo: /src/modules/banco-preguntas/repository/queries/aula-pregunta.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         CODIGO_AULA
     FROM UTNDB.LMS_TAB_PREGUNTAS
     WHERE CODIGO = :codPregunta
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/ciclos-academicos.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT DESCRIPCION, CODIGO FROM (
         SELECT DISTINCT
             C.DESCRIPCION,
             C.CODIGO,
             C.FECHA_FIN
         FROM UTNDB.ACA_TAB_CICLOS_ACADEMICOS C
         IN...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/codigos-preguntas-a-importar.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT PRE.CODIGO
 FROM UTNDB.LMS_TAB_PREGUNTAS PRE
 INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES AV
      ON AV.ID_CURSO = PRE.CODIGO_AULA
 INNER JOIN UTNDB.LMS_TAB_TIPO_PREGUNTA TPR
      ON ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/contenidos-aula.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT DISTINCT
       C.CODIGO,
       C.ITEM,
       C.DESCRIPCION,
       C.FUNCION, -- G o M
       C.CONTE_MATE_CODIGO, -- Código del padre
       T.DESCRIPCION AS TIPO_CONTENIDO,
       TO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/contenidos-destino.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT CODIGO, ITEM, DESCRIPCION, FUNCION, CONTE_MATE_CODIGO, TIPO_CONTENIDO, ORDEN_PRINCIPAL, ORDEN_SECUNDARIO
 FROM (
     SELECT DISTINCT
         C.CODIGO,
         C.ITEM,
         C.DESCRIPCIO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/contenidos-origen.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
     NVL(CON.ITEM, '-') AS ITEM,
     NVL(CON.DESCRIPCION, 'MATERIA') AS DESCRIPCION,
     NVL(CON.CODIGO, AV.CODIGO_MATERIA) AS CODIGO,
     NVL(CON.FUNCION, 'M') AS FUNCION,
     C...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/count-preguntas-a-importar.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COUNT(DISTINCT PRE.CODIGO) AS TOTAL
 FROM UTNDB.LMS_TAB_PREGUNTAS PRE
 INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES AV
      ON AV.ID_CURSO = PRE.CODIGO_AULA
 INNER JOIN UTNDB.LMS_TAB_TIPO_PREGUN...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/crear-multiples-respuestas.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 INSERT ALL
     {{INSERT_VALUES}}
 SELECT * FROM DUAL
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/eliminar-respuesta.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** DELETE
- **Fragmento:** `
     DELETE FROM UTNDB.LMS_TAB_RESPUESTAS
     WHERE CODIGO = :codigo
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/imagen-pregunta.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     ADJUNTO,
     ADJUNTO_MIME,
     ADJUNTO_FILENAME
 FROM UTNDB.LMS_TAB_PREGUNTAS
 WHERE CODIGO = :codigoPregunta
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/listado-preguntas-a-importar.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
     PRE.CODIGO,
     TPR.NOMBRE AS TIPO_PREGUNTA,
     PRE.PREGUNTA_HTML,
     PRE.NIVEL_DIFICULTAD,
     PRE.USUARIO_CREACION,
     PRE.FECHA_CREACION,
     CASE
         WHEN UTND...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/listado-preguntas.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
   SELECT DISTINCT
       PRE.CODIGO,
       PRE.PREGUNTA_HTML,
       TPR.NOMBRE AS TIPO,
       PRE.NIVEL_DIFICULTAD,
       CASE
           WHEN PRE.ADJUNTO IS NOT NULL THEN 1
           ELSE 0
  ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 23
- **Tipo de operación:** SELECT
- **Fragmento:** `
   SELECT COUNT(DISTINCT PRE.CODIGO) AS TOTAL
   FROM UTNDB.LMS_TAB_PREGUNTAS PRE
   INNER JOIN UTNDB.LMS_TAB_TIPO_PREGUNTA TPR
       ON TPR.CODIGO = PRE.COD_TIPO_PREGUNTA
   INNER JOIN UTNDB.LMS_VI...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/listado-respuestas.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     RES.CODIGO,
     RES.NOMBRE,
     RES.CALIFICACION,
     RES.ESTADO,
     RES.RETROALIMENTACION,
     RES.COLUMNA_EMPAREJAMIENTO,
     TPR.NOMBRE AS TIPO_PREGUNTA
 FROM UTNDB.LMS_TAB_RES...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/listado-tipo-preguntas.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT CODIGO, NOMBRE
   FROM UTNDB.LMS_TAB_TIPO_PREGUNTA
   WHERE ESTADO = 'A'
  ORDER BY CODIGO
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/materias.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT 
     MAT.DESCRIPCION || ' ' || AV.CODIGO_PARALELO || '(' || DEP.DESCRIPCION || ')' AS MATERIA, 
     AV.ID_CURSO
 FROM UTNDB.LMS_TAB_AULAS_VIRTUALES AV
 INNER JOIN UTNDB.ACA_TAB_MAT...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/PL-SQL/crear-pregunta.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** INSERT
- **Fragmento:** `
 DECLARE
     v_cod_tipo_preg     NUMBER(38)   := :1;
     v_nivel_dificultad  NUMBER(38)   := :2;
     v_codigo_aula       NUMBER(38)   := :3;
     v_cod_contenido     VARCHAR2(40)   := :4;
     v_c...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/PL-SQL/crear-respuesta.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** INSERT
- **Fragmento:** `
 DECLARE
     v_usuario             VARCHAR2(50)    := :cuenta;
     v_cod_pregunta        NUMBER(38)      := :codPregunta;
     v_nombre              VARCHAR2(2000)  := :nombre;
     v_retroalimenta...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/PL-SQL/eliminar-varias-respuestas.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** DELETE
- **Fragmento:** `
 BEGIN
     DELETE FROM UTNDB.LMS_TAB_RESPUESTAS
     WHERE CODIGO IN ({{PLACEHOLDERS}})
     RETURNING CODIGO BULK COLLECT INTO :out_codigos;
 END;
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/PL-SQL/importar-preguntas-contenido.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 DECLARE
     v_usuario              VARCHAR2(50) := :cuenta;
     v_cod_aula_origen      NUMBER      := :codAulaOrigen;
     v_cod_aula_destino     NUMBER      := :codAulaDestino;
     v_cod_conteni...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/PL-SQL/importar-preguntas-materia.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 DECLARE
     v_usuario              VARCHAR2(50) := :cuenta;
     v_cod_aula_origen      NUMBER      := :codAulaOrigen;
     v_cod_aula_destino     NUMBER      := :codAulaDestino;
     v_cod_conteni...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/pregunta.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
   SELECT
       PRE.CODIGO,
       PRE.PREGUNTA_HTML,
       TPR.NOMBRE AS TIPO,
       PRE.NIVEL_DIFICULTAD,
       CASE
           WHEN PRE.ADJUNTO IS NOT NULL THEN 1
           ELSE 0
       END ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/tipo-de-pregunta.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         TPR.NOMBRE
       FROM UTNDB.LMS_TAB_TIPO_PREGUNTA TPR
      INNER JOIN UTNDB.LMS_TAB_PREGUNTAS PRE
         ON PRE.COD_TIPO_PREGUNTA = TPR.CODIGO
      WHERE PRE.CODIGO = :codig...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/tipo-pregunta.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COD_TIPO_PREGUNTA FROM UTNDB.LMS_TAB_PREGUNTAS WHERE CODIGO = :codigo_pregunta
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/validar-aula.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT ID_CURSO FROM UTNDB.LMS_TAB_AULAS_VIRTUALES WHERE ID_CURSO = :codAula AND ESTADO = 'A'
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/validar-parciales-activas.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 'T' FROM DUAL 
     WHERE UTNDB.LMS_FUN_PARCIAL_ACTIVA(:idCurso,'N1') = 'T'
     OR UTNDB.LMS_FUN_PARCIAL_ACTIVA(:idCurso,'N2') = 'T'
     OR UTNDB.LMS_FUN_PARCIAL_ACTIVA(:idCurso,'N3') = 'T'...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/validar-pregunta-en-cuestionario.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT PREGUNTA_CODIGO
     FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO
     WHERE PREGUNTA_CODIGO = :codigoPregunta
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/validar-pregunta-inactiva.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 1 as EXISTS_CHECK FROM DUAL
 WHERE NOT EXISTS (
     SELECT 1 FROM UTNDB.LMS_TAB_PREGUNTAS
     WHERE CODIGO = :codigo
     AND ESTADO = 'A'
 )
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/banco-preguntas/repository/queries/validar-usuario-pregunta.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT USUARIO_CREACION FROM UTNDB.LMS_TAB_PREGUNTAS WHERE CODIGO = :codigo
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

