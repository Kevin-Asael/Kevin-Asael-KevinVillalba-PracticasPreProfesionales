
# Módulo: portafolio-estudiante/comunicados

*Fecha de auditoría: 2026-09-09T14:35:27.109Z*

## Archivo: /src/modules/comunicados/repository/consultas/comunicados_pendientes_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 WITH 
     -- 1. Facultad del Estudiante
     info_estudiante AS (
         SELECT CODIGO_FACULTAD FROM (
             SELECT TAB_FAC.CODIGO AS CODIGO_FACULTAD
             FROM UTNDB.ACA_TAB_DEPEND...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/comunicados/repository/consultas/guardar_respuesta_encuesta_consulta.ts
- **Línea aprox:** 7
- **Tipo de operación:** DELETE
- **Fragmento:** `
 DELETE FROM MOVIL_UTN.MVL_TAB_ENC_RESPUESTAS
 WHERE ID_PREGUNTA = :idPregunta
 AND ID_VISUALIZACION = :idVisualizacion
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 20
- **Tipo de operación:** INSERT
- **Fragmento:** `
 INSERT INTO MOVIL_UTN.MVL_TAB_ENC_RESPUESTAS (
   ID_PREGUNTA,
   ID_VISUALIZACION,
   VALOR_RESPUESTA,
   FECHA_RESPUESTA
 ) VALUES (
   :idPregunta,
   :idVisualizacion,
   :valorRespuesta,
   SYS...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/comunicados/repository/consultas/obtener_comunicado_por_id_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     c.ID_COMUNICADO,
     c.CODIGO,
     c.TITULO,
     c.MENSAJE,
     c.TIPO_ID,
     c.PRIORIDAD,
     c.FECHA_INICIO,
     c.FECHA_FIN,
     c.ACCION_TIPO,
     c.ACCION_URL,
     c.ACC...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/comunicados/repository/consultas/obtener_id_visualizacion_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT ID
 FROM (
     SELECT ID
     FROM MOVIL_UTN.MVL_TAB_COMUNICADOS_VISUALIZACIONES
     WHERE ID_COMUNICADO = :idComunicado
       AND USUARIO_CEDULA = :cedula
     ORDER BY FECHA_VIS DESC, ID...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/comunicados/repository/consultas/obtener_preguntas_encuesta_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
   p.ID_PREGUNTA,
   p.ID_COMUNICADO,
   p.TEXTO_PREGUNTA,
   p.CODIGO_REF,
   p.TIPO_WIDGET,
   p.OPCIONES_CONFIG,
   p.ES_OBLIGATORIO,
   p.ORDEN
 FROM MOVIL_UTN.MVL_TAB_ENC_PREGUNTAS p
 WH...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/comunicados/repository/consultas/registrar_visualizacion_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 DECLARE
     v_num_visualizacion NUMBER;
     v_max_visualizaciones NUMBER;
     v_existe NUMBER;
     v_nombre_completo VARCHAR2(300);
     v_genero VARCHAR2(20);
     v_facultad VARCHAR2(200);
   ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/comunicados/repository/consultas/verificar_pregunta_pertenece_comunicado_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 1
 FROM MOVIL_UTN.MVL_TAB_ENC_PREGUNTAS p
 WHERE p.ID_PREGUNTA = :idPregunta
   AND p.ID_COMUNICADO = :idComunicado
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

