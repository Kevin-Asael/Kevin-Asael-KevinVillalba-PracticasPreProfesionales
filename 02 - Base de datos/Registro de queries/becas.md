
# Módulo: portafolio-estudiante/becas

*Fecha de auditoría: 2026-09-09T14:35:27.094Z*

## Archivo: /src/modules/becas/repository/consultas/actualizar_cuenta_bancaria.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 UPDATE UTNDB.BSE_TAB_SOLICTUDES_BECAS 
 SET 
   BANCO = :banco,
   NRO_CUENTA = :nroCuenta,
   TIPO_CUENTA = :tipoCuenta
 WHERE SOLICITANTE = :cedula
   AND CONVOCATORIA = (
     SELECT NUMERO FROM ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 14
- **Tipo de operación:** SELECT
- **Fragmento:** `
 UPDATE UTNDB.BSE_TAB_SOLICTUDES_BECAS 
 SET 
   BANCO = :banco,
   NRO_CUENTA = :nroCuenta,
   TIPO_CUENTA = :tipoCuenta,
   DOCUMENTO = :documento,
   DOCUMENTO_FILENAME = :documentoFilename,
   DO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/becas/repository/consultas/obtener_archivo.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   DOC_CEDULA AS ARCHIVO,
   DOC_CEDULA_FILENAME AS FILENAME,
   'application/pdf' AS MIMETYPE
 FROM UTNDB.BSE_TAB_SOLICTUDES_BECAS
 WHERE SOLICITANTE = :cedula
   AND CONVOCATORIA IN (
    ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 61
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   DOCUMENTO AS ARCHIVO,
   DOCUMENTO_FILENAME AS FILENAME,
   DOCUMENTO_MIMETYPE AS MIMETYPE
 FROM UTNDB.BSE_TAB_SOLICTUDES_BECAS
 WHERE SOLICITANTE = :cedula
   AND CONVOCATORIA IN (
     ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/becas/repository/consultas/obtener_bancos.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   NOMBRE_BANCO AS NOMBRE, 
   ID_BANCO AS ID
 FROM UTNDB.CON_TAB_BANCOS 
 ORDER BY NOMBRE_BANCO ASC
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/becas/repository/consultas/obtener_datos_bancarios.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   BANCO,
   NRO_CUENTA,
   TIPO_CUENTA,
   DOCUMENTO_FILENAME
 FROM UTNDB.BSE_TAB_SOLICTUDES_BECAS
 WHERE SOLICITANTE = :cedula
   AND CONVOCATORIA = (SELECT NUMERO FROM UTNDB.BSE_TAB_CONVO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/becas/repository/consultas/obtener_datos_contrato.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   SOLICITANTE,
   NRO_SOLICITUD AS NRO_SOLICITUD,
   TIPO,
   ESTADO,
   FECHA,
   CICLO_ACAD_CODIGO,
   COD_MATRICULA,
   NRO_CONTRATO_ELECT,
   CONVOCATORIA,
   ENVIADO_CONTRATO AS CONTRA...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/becas/repository/consultas/obtener_datos_matricula.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     m.ESTUDIANTE_CEDULA AS "CEDULA",
     UTNDB.NOMBRES(m.ESTUDIANTE_CEDULA) AS "SOLICITANTE",
     m.CODIGO AS "COD_MATRICULA",
     v.SIGLAS_FAC AS "FACULTAD",
     v.CARRERA AS "CARRERA",...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/becas/repository/consultas/obtener_solicitud_resumen.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
   SOLICITANTE AS CEDULA,
   UTNDB.INS_PCK_GENERAL.FUN_NOMBRES_PERSONA(SOLICITANTE) AS ESTUDIANTE,
   TIPO,
   (SELECT DESCRIPCION FROM UTNDB.BSE_TAB_TIPO_SOLICITUD_BECA WHERE CODIGO = TIPO)...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/becas/repository/consultas/obtener_tipos_beca.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
   SELECT 
     CODIGO,
     DESCRIPCION
   FROM UTNDB.BSE_TAB_TIPO_SOLICITUD_BECA 
   WHERE ESTADO = 'A'
   AND CODIGO IN ('004','005','006','007','009','010','011')
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/becas/repository/consultas/solicitudes.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
   SELECT NUMERO, DESCRIPCION 
   FROM UTNDB.BSE_TAB_CONVOCATORIAS_BECAS 
   WHERE ESTADO = 'A' ORDER BY NUMERO DESC FETCH FIRST 1 ROW ONLY
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 8
- **Tipo de operación:** INSERT
- **Fragmento:** `
   INSERT INTO UTNDB.BSE_TAB_SOLICTUDES_BECAS (
     SOLICITANTE, 
     TIPO, 
     CICLO_ACAD_CODIGO, 
     COD_MATRICULA, 
     ESTADO, 
     FECHA, 
     CONVOCATORIA,
     USUARIO_CREACION
   ) V...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/becas/repository/consultas/validaciones_solicitud.consulta.ts
- **Línea aprox:** 2
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT CEDULA
     FROM UTNDB.RHU_TAB_PERSONAS
     WHERE CEDULA = :cedula
     AND UTNDB.BSE_FUN_INGRESOS_MAT_BECA(:cedula, 
         (SELECT VALOR_PARAM * 1.5 
          FROM JRODRIGUEZ.NOM_TA...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 12
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT CEDULA
     FROM UTNDB.RHU_TAB_PERSONAS
     WHERE CEDULA = :cedula
     AND UTNDB.BSE_FUN_COMPR_MAT_BECA_GRAL(:codMatricula) = 0
     AND UTNDB.BSE_FUN_EXISTE_MAT_ACT_BECA(:cedula, 
    ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 24
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT CEDULA
     FROM UTNDB.RHU_TAB_PERSONAS
     WHERE CEDULA = :cedula
     AND UTNDB.BSE_FUN_PROMEDIO_MAT_BECA(:cedula, :codMatricula, 
       (SELECT CICLO_ANTERIOR FROM UTNDB.BSE_TAB_CICL...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 33
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT CEDULA
     FROM UTNDB.RHU_TAB_PERSONAS
     WHERE CEDULA = :cedula
       AND ID_SUBGRUPO_DISCAPACIDAD IN (1,2,3,4,5,6,7,8,9,10)
       AND UTNDB.BSE_FUN_COMPR_MAT_BECA_DISCAP(:codMatric...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 50
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT CEDULA
     FROM UTNDB.RHU_TAB_PERSONAS
     WHERE CEDULA = :cedula
     AND COD_ETNIA IN ('IN','AF','NE','MO')
   `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 57
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT CEDULA
     FROM
     UTNDB.BSE_TAB_CLUBES_ESTUDIANTES
     WHERE  CEDULA = :cedula
     AND TIPO_CLUB = 'Club Académico'
     AND CONVOCATORIA = (SELECT TO_CHAR(NUMERO) FROM UTNDB.BSE_TA...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 67
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT CEDULA
     FROM UTNDB.BSE_TAB_CLUBES_ESTUDIANTES
     WHERE CEDULA = :cedula
     AND TIPO_CLUB = 'GRUPOS ARTÍSTICOS Y CULTURALES'
     AND CONVOCATORIA = (SELECT TO_CHAR(NUMERO) FROM UT...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 76
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT CEDULA
     FROM UTNDB.BSE_TAB_CLUBES_ESTUDIANTES
     WHERE CEDULA = :cedula
     AND TIPO_CLUB = 'GRUPOS DEPORTIVOS'
     AND CONVOCATORIA = (SELECT TO_CHAR(NUMERO) FROM UTNDB.BSE_TAB_C...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/becas/repository/consultas/verificar_acceso_cuentas_bancarias.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT FECHA_INICIO
 FROM UTNDB.INS_TAB_CALENDARIOS_GENERALES
 WHERE
   ACTIVGNRAL_MODULO_CODIGO = 'BEC' 
   AND ACTIVGNRAL_CODIGO = '00045'            
   AND FECHA_INICIO <= SYSDATE
   AND FECHA_F...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/becas/repository/consultas/verificar_convocatoria_activa.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT FECHA_INICIO
 FROM UTNDB.INS_TAB_CALENDARIOS_GENERALES
 WHERE ACTIVGNRAL_MODULO_CODIGO = 'BEC'
   AND ACTIVGNRAL_CODIGO = '00043'
   AND FECHA_INICIO <= SYSDATE
   AND FECHA_FINAL >= SYSDATE
...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/becas/repository/consultas/verificar_solicitud_existente.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT NRO_SOLICITUD
 FROM UTNDB.BSE_TAB_SOLICTUDES_BECAS
 WHERE SOLICITANTE = :cedula
   AND CONVOCATORIA IN (
     SELECT NUMERO 
     FROM UTNDB.BSE_TAB_CONVOCATORIAS_BECAS 
     WHERE ESTADO = '...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

