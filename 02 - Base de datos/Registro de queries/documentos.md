
# Módulo: portafolio-estudiante/documentos

*Fecha de auditoría: 2026-09-09T14:35:27.116Z*

## Archivo: /src/modules/documentos/repository/consultas/carreras_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     d1.NOMBRE AS NOMBRE,
     EC.DEPEN_CARRERA AS DEPENDENCIA
 FROM ACA_TAB_ESTUDIANTE_CARRERAS ec 
     INNER JOIN ACA_TAB_DEPENDENCIAS d1 ON  d1.CODIGO = ec.DEPEN_CARRERA
     INNER JOIN ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/certificados_eventos_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 select ID_EVENTO,
        TITULO_CERTIFICADO,
        NOMBRE_EVENTO,
        REALIZADO_EN,
        LUGAR_EVENTO,
        FECHA_INICIO,
        FECHA_FIN,
        NOMBRE_ORGANIZADOR,
        CODIGO_Q...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/certificado_adeudar_biblioteca_procedure.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 --Certificado de no adeudar a la biblioteca
 DECLARE
     v_cedula VARCHAR2(10) := :G_CEDULA_USUARIO;
     v_dependencia VARCHAR(10) := :P704_CARRERA;
     v_resultado NUMBER; 
     v_emision NUMBER...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/certificado_almacen_bodega_procedure.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 --Certificado de No adeudar al almacen Bodega
 DECLARE
     v_cedula VARCHAR2(10) := :G_CEDULA_USUARIO;
     v_dependencia VARCHAR(10) := :P704_CARRERA;
     v_resultado NUMBER; 
     v_emision NUMB...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/certificado_asistencia_clases_procedure.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 --Certificado de asistencia a clases:
 DECLARE
     v_cedula VARCHAR2(10) := :G_CEDULA_USUARIO;
     v_dependencia VARCHAR(10) := :P704_CARRERA;
     v_resultado NUMBER; 
     v_emision NUMBER;
    ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/certificado_cultura_fisica_procedure.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 --Certificado de Aprobación de Educación Física
 DECLARE
     v_cedula VARCHAR2(10) := :G_CEDULA_USUARIO;
     v_cedula_con_E VARCHAR2(11);
     v_Dependencias VARCHAR2(10) := '00238';
     v_InsCod...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/certificado_grupos_culturales_procedure.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 --Certificado de pertenecer a grupo cultural
 DECLARE
     v_cedula VARCHAR2(10) := :G_CEDULA_USUARIO;
     v_dependencia VARCHAR(10) := :P704_CARRERA;
     v_resultado NUMBER; 
     v_emision NUMBE...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/certificado_historial_academico_becas_procedure.ts
- **Línea aprox:** 5
- **Tipo de operación:** SELECT
- **Fragmento:** `
 DECLARE
     v_cedula        VARCHAR2(10) := :G_CEDULA_USUARIO;
     v_Dependencias  VARCHAR2(50) := :P704_CARRERA;
     v_resultado     NUMBER;
     resultado       VARCHAR2(255);
 BEGIN
     BEGIN...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/certificado_historial_academico_procedure.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 DECLARE
     v_cedula VARCHAR2(10) := :G_CEDULA_USUARIO; 
     v_cedula_con_E VARCHAR2(11);
     v_Dependencias VARCHAR2(50):= :P704_CARRERA;
     v_InsCodigo VARCHAR2(50):='001';
     v_parametros ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/certificado_matricula_procedure.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 --Certificado de Matrícula
 DECLARE
     v_cedula VARCHAR2(10) := :G_CEDULA_USUARIO;
      v_dependencia VARCHAR(10) := :P704_CARRERA;
     v_resultado NUMBER; 
     v_emision NUMBER;
     resultado...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/certificado_notas_beca_procedure.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 DECLARE
     v_cod_matricula VARCHAR2(50) := :COD_MATRICULA;
     v_cedula        VARCHAR2(10) := :G_CEDULA_USUARIO;
     v_carrera       VARCHAR2(50) := :P704_CARRERA;
     v_ciclo_acad    VARCHAR2...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/certificado_record_academico_procedure.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 --Certificado de Récord Academico
 
 DECLARE
     v_cedula VARCHAR2(10) := :G_CEDULA_USUARIO; 
     v_cedula_con_E VARCHAR2(11);
     v_Dependencias VARCHAR2(50):= :P704_CARRERA;
     v_InsCodigo VA...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/certificado_sancion_procedure.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 --Certificado de Sanción
 DECLARE
     v_cedula VARCHAR2(10) := :G_CEDULA_USUARIO;
     v_dependencia VARCHAR(10) := :P704_CARRERA;
     v_resultado NUMBER; 
     v_emision NUMBER;
     resultado VA...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/certificado_segunda_tercera_matricula_procedure.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 --Certificado de segunda y tercera matricula
 DECLARE
     v_cedula VARCHAR2(10) := :G_CEDULA_USUARIO;
      v_dependencia VARCHAR(10) := :P704_CARRERA;
     v_resultado NUMBER; 
     v_emision NUMB...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/documentos_electronicos_personales_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   TIP.ID_TIPO_DOCUMENTO, 
   TRANSLATE(TIP.DESCRIPCION, '_', ' ') DOCUMENTO, 
   DESCARGAR 
 FROM 
   DOC_TAB_TIPOS_DOCUMENTOS TIP 
   LEFT JOIN (
     SELECT 
       DOC.ID_TIPO_DOCUMENTO,...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/documentos_posgrado_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   TIP.ID_TIPO_DOCUMENTO, 
   TRANSLATE(TIP.DESCRIPCION, '_', ' ') DOCUMENTO, 
   DESCARGAR 
 FROM 
   DOC_TAB_TIPOS_DOCUMENTOS TIP 
   LEFT JOIN (
     SELECT 
       DOC.ID_TIPO_DOCUMENTO,...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/es_estudiante_posgrado_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 select 
   1 
 FROM 
   DUAL 
 WHERE 
   :G_CEDULA_USUARIO IN(
     SELECT 
       ESTUDIANTE_CEDULA 
     FROM 
       ACA_TAB_MATRICULAS 
     WHERE 
       CICLO_ACAD_CODIGO IN(
         SELECT 
...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/formatos_vinculacion_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
   SELECT
     ID_DOCUMENTO_DIRECTORIO,
     NOMBRE_ARCHIVO,
     MIME_TYPE
   FROM
     UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO
   WHERE
     DIRECTORIO = :P272_DIRECTORIO
     AND ESTADO = 'A'
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/historial_certificados_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 Select CE.ID_CERTIFICADO, 
   CE.CEDULA ,          
   CE.NOMBRE ,          
   CE.FECHA_EMISION ,   
   CS.NOMBRE_SERVICIO,   
   CE.CARRERA,      
   CASE WHEN CE.URL_CERTIFICADO IS NOT NULL THEN ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/validar_asistencia_clases_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 Select 
     1
 from RHU_TAB_PERSONAS p                
     INNER JOIN ACA_TAB_MATRICULAS am ON p.CEDULA = am.ESTUDIANTE_CEDULA
     INNER JOIN ACA_TAB_CICLOS_ACADEMICOS ca ON am.CICLO_ACAD_CODIGO ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos/repository/consultas/validar_cultura_fisica_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 select 1 from dual where UTNDB.CSE_FUN_APROBACION_CF(:G_CEDULA_USUARIO) =1
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

