
# Módulo: portafolio-docentes/revision-respuestas

*Fecha de auditoría: 2026-09-09T14:35:27.056Z*

## Archivo: /src/modules/revision-respuestas/repository/queries/alternativas-respuesta.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         RES.CODIGO,
         RES.NOMBRE AS ENUNCIADO,
         RES.ESTADO,
         RES.RETROALIMENTACION,
         RES.COLUMNA_EMPAREJAMIENTO
     FROM UTNDB.LMS_TAB_RESPUESTAS RES
    ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/revision-respuestas/repository/queries/calificar-respuesta.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         CODIGO,
         CODIGO_PREGUNTA,
         CEDULA_ESTUDIANTE,
         ID_ACTIVIDAD,
         CALIFICACION_ESTUDIANTE
     FROM UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE
     WHERE COD...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 12
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         PREGUNTA_CODIGO,
         CUESTIONARIO_CODIGO,
         ESTUDIANTE_CEDULA,
         NOTA
     FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO
     WHERE PREGUNTA_CODIGO = :pregunta_cod...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 49
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT COUNT(*) AS TOTAL
     FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO
     WHERE CUESTIONARIO_CODIGO = :cuestionario_codigo
     AND ESTUDIANTE_CEDULA = :estudiante_cedula
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 56
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         ID_ACTIVIDAD,
         CEDULA_INTEGRANTE,
         CALIFICACION,
         ENTREGADO,
         FECHA_FIN_EA,
         INTENTOS_DISPONIBLES
     FROM UTNDB.LMS_TAB_ACTIVIDADES_ALUM...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 76
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT 1
     FROM DUAL
     WHERE EXISTS (
         SELECT 1
         FROM 
             UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA
         WHERE 
             ID_ACTIVIDAD = :idActividad
         AND ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/revision-respuestas/repository/queries/cuestionario.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         CUE.SUB_ID AS NRO_PREGUNTA,
         CUE.PREGUNTA_CODIGO,
         CUE.NOTA
     FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO CUE
     WHERE CUE.CUESTIONARIO_CODIGO = :cod_actividad...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/revision-respuestas/repository/queries/pregunta.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         PRE.CODIGO,
         PRE.PREGUNTA_HTML AS ENUNCIADO_HTML,
         PRE.COD_TIPO_PREGUNTA,
         TPR.NOMBRE AS TIPO_PREGUNTA
     FROM UTNDB.LMS_TAB_PREGUNTAS PRE
     INNER JO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/revision-respuestas/repository/queries/respuestas-estudiante.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         REST.CODIGO,
         REST.CODIGO_RESPUESTA,
         REST.RESPUESTA AS RESPUESTA_EMPAREJ_O_TEXT,
         REST.CALIFICACION_ESTUDIANTE
     FROM UTNDB.LMS_TAB_RESPUESTAS_ESTUDIA...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

