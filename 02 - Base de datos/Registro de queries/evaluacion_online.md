
# Módulo: portafolio-estudiante/evaluacion_online

*Fecha de auditoría: 2026-09-09T14:35:27.133Z*

## Archivo: /src/modules/evaluacion_online/repository/consultas/evaluacion_online.queries.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         act.NOMBRE_CORTO AS "TITULO",
         act.DESCRIPCION AS "DESCRIPCION",
         pc.CUESTIONARIO_CODIGO AS "IDACTIVIDAD",
         p.CODIGO AS "PREGUNTAID",
         p.PREGUNTA_...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 37
- **Tipo de operación:** SELECT
- **Fragmento:** `
     WITH PREGUNTAS_ACTIVIDAD AS (
         SELECT 
             pc.PREGUNTA_CODIGO,
             p.COD_TIPO_PREGUNTA,
             al.ID_ACTIVIDAD
         FROM 
             UTNDB.LMS_TAB_PREGUNTAS...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 148
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         act.FECHA_INICIO AS "FECHAINICIO",
         act.FECHA_FIN AS "FECHAFIN",
         alu.INTENTOS_DISPONIBLES AS "INTENTOSDISPONIBLES",
         alu.ENTREGADO AS "ENTREGADO",
      ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 172
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         act.FECHA_INICIO AS "FECHAINICIO",
         act.FECHA_FIN AS "FECHAFIN",
         alu.INTENTOS_DISPONIBLES AS "INTENTOSDISPONIBLES",
         alu.ENTREGADO AS "ENTREGADO",
      ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 199
- **Tipo de operación:** SELECT
- **Fragmento:** `
     UPDATE UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE re
     SET ESTADO = 'I', USUARIO_ACTUALIZACION = :1
     WHERE re.ID_ACTIVIDAD = (
         SELECT al.ID_ACTIVIDAD
         FROM UTNDB.LMS_TAB_ACTIVID...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 211
- **Tipo de operación:** SELECT
- **Fragmento:** `
 INSERT INTO UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE
 (ID_ACTIVIDAD, CEDULA_ESTUDIANTE, CODIGO_PREGUNTA, CODIGO_RESPUESTA, ESTADO, 
 RESPUESTA, USUARIO_CREACION, USUARIO_ACTUALIZACION)
 VALUES
 (
     (S...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 230
- **Tipo de operación:** SELECT
- **Fragmento:** `
 INSERT INTO UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE
 (ID_ACTIVIDAD, CEDULA_ESTUDIANTE, CODIGO_PREGUNTA, CODIGO_RESPUESTA, ESTADO, USUARIO_CREACION, USUARIO_ACTUALIZACION)
 VALUES
 (
     (SELECT ID_ACTI...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 247
- **Tipo de operación:** SELECT
- **Fragmento:** `
     UPDATE UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE re
     SET ESTADO = 'I', USUARIO_ACTUALIZACION = :1
     WHERE re.ID_ACTIVIDAD = (
         SELECT al.ID_ACTIVIDAD
         FROM UTNDB.LMS_TAB_ACTIVID...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 260
- **Tipo de operación:** SELECT
- **Fragmento:** `
 DECLARE
     v_id_actividad UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS.ID_ACTIVIDAD%TYPE;
 BEGIN
     SELECT ID_ACTIVIDAD
     INTO v_id_actividad
     FROM UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
     WHERE ID_AC...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 277
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         CALIFICACION AS "notaFinal"
     FROM
         UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
     WHERE
         ID_ACTIVIDAD_ALUMNO = :1
         AND CEDULA_INTEGRANTE = :2
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 287
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         P.CODIGO,
         P.PREGUNTA_HTML AS "PREGUNTA",
         C.NOTA,
         T.NOMBRE AS "TIPO DE PREGUNTA",
         COUNT(*) OVER () AS "TOTAL_PREGUNTAS"
     FROM
         UTND...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 309
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT
         COUNT(DISTINCT re.CODIGO_PREGUNTA) AS "total"
     FROM
         UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE re
     WHERE
         re.ID_ACTIVIDAD = (
             SELECT al.ID_ACTIVIDA...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 324
- **Tipo de operación:** SELECT
- **Fragmento:** `
     UPDATE UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE re
     SET ESTADO = 'I', USUARIO_ACTUALIZACION = :1
     WHERE EXISTS (
         SELECT 1
         FROM UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS al
         ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 338
- **Tipo de operación:** SELECT
- **Fragmento:** `
     INSERT INTO UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE
         (ID_ACTIVIDAD, CEDULA_ESTUDIANTE, CODIGO_PREGUNTA, CODIGO_RESPUESTA, RESPUESTA, ESTADO, USUARIO_CREACION, USUARIO_ACTUALIZACION)
     VAL...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 356
- **Tipo de operación:** SELECT
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

