
# Módulo: portafolio-docentes/proyectos-investigacion

*Fecha de auditoría: 2026-09-09T14:35:27.034Z*

## Archivo: /src/modules/proyectos-investigacion/repository/queries/acciones-divulgacion.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         ACCIONES AS ACCION,
         DESCRIPCION,
         MEDIO_VERIFICACION
     FROM UTNDB.MGI_TAB_ACCIONES_DIVULGACION
     WHERE PROY_MGI_CODIGO = :codigo
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/areas-investigacion.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         P.AREA_INV_CODIGO AS CODIGO,
         AINV.DESCRIPCION,
         P.OBSERVACION
     FROM
         UTNDB.MGI_TAB_AREA_INVE_PROYECTO P
     INNER JOIN
         UTNDB.MGI_TAB_AREA_I...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/beneficiarios.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     NUMERO AS NUM_BENEFICIARIOS,
     INV_PCK_GENERAL.DESCBENEFICIARIOS(SEXO) AS SEXO,
     INV_PCK_GENERAL.DESCBENEFICIARIOS(TIPO_BENEFICIARIO) AS TIPO_BENEFICIARIO,
     INV_PCK_GENERAL.DE...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/convocatorias.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     conv.ESTADO,
     conv.CODIGO,
     conv.TEMA,
     conv.DESCRIPCION,
     conv.FECHA_INICIAL,
     conv.FECHA_FINAL,
     conv.RESPONSABLE,
     conv.LUGAR
 FROM
     UTNDB.MGI_TAB_CONV...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 28
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COUNT(*) AS TOTAL
 FROM UTNDB.MGI_TAB_CONVOCATORIA conv
 WHERE conv.ESTADO != 'P'
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/datos-proyecto.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
    P.CODIGO,
    CONV.TEMA AS CONVOCATORIA,
    P.TITULO_COMPLETO,
    TP.DESCRIPCION AS TIPO_PROYECTO,
    TL.DESCRIPCION AS COBERTURA,
    P.PAISES,
    P.PROVINCIAS,
    P.CIUDADES,
    F...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/detalle-convocatoria.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
    SELECT
       conv.ESTADO,
       conv.CODIGO,
       conv.TEMA,
       conv.DESCRIPCION,
       conv.FECHA_INICIAL,
       conv.FECHA_FINAL,
       conv.RESPONSABLE,
       conv.LUGAR,
       co...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/doc-presupuesto.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         ANEXO_3 AS PRESUPUESTO,
         ANEXO3_MYME AS MIME_TYPE,
         ANEXO3_NOMBRE AS FILE_NAME
     FROM
         UTNDB.MGI_TAB_DOCUMENTOS_RESPALDO
     WHERE
         CODIGO = :...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/doc-proyecto.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         PROYECTO_COMPLETO,
         MIME_TYPE,
         FILE_NAME
     FROM
         UTNDB.MGI_TAB_DOCUMENTOS_RESPALDO
     WHERE
         CODIGO = :codigoDoc
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/doc-resolucion.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         RESOLUCION,
         RESOLUCION_MYME AS MIME_TYPE,
         RESOLUCION_NOMBRE AS FILE_NAME
     FROM
         UTNDB.MGI_TAB_DOCUMENTOS_RESPALDO
     WHERE
         CODIGO = :codi...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/documentos-urls.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         CODIGO,
         DESCRIPCION AS OBSERVACION_DOCUMENTO,
         CASE
             WHEN PROYECTO_COMPLETO IS NOT NULL THEN 1
             ELSE 0
         END AS TIENE_PROYECTO_COM...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/ejes-integradores.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT
         AREA_INV_CODIGO,
         --(
         --    SELECT DESCRIPCION
         --    FROM UTNDB.MGI_TAB_AREA_INVESTIGACION
         --    WHERE codigo = AREA_INV_CODIGO
         --) AS...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/equipo-trabajo.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         UTNDB.INV_PCK_GENERAL.participacion(TIPO_PART_CODIGO) AS PARTICIPACION,
         UTNDB.NOMBRES(DOCENTE_CEDULA)||UTNDB.NOMBRES(EMPLEADO_CEDULA)||UTNDB.NOMBRES(ESTUDIANTE_CEDULA)||...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/equipos-utn.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         NOMBRE,
         RESPONSABLE AS CUSTODIO,
         DESCRIPCION
     FROM UTNDB.MGI_TAB_INFRAESTRUCTURA
     WHERE CODIGO_PROYECTO = :codigo
         AND CODIGO_TIPO_INF = '2'
   ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/estrategias-produccion.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT
         (SELECT DESCRIPCION
          FROM UTNDB.MGI_TAB_OPCIONES_EST
          WHERE IDCAMPO = OPCION) AS OPCION,
         (SELECT DESCRIPCION
          FROM UTNDB.MGI_TAB_OPCIONES_EST
...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/estrategias-resultados.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         ESTRATEGIA,
         DESCRIPCION,
         EVIDENCIA_TEX AS MEDIO_VERIFICACION
     FROM UTNDB.MGI_TAB_ESTRAT_TRANS_RESULT
     WHERE PROY_MGI_CODIGO = :codigo
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/instituciones-asociadas.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         INV_PCK_GENERAL.institucion(CODIGO_INS) AS INSTITUCION_ASOCIADA
     FROM
         UTNDB.MGI_TAB_INSTITUCIONES_ASOC
     WHERE
         CODIGO_PROY= :codigo
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/laboratorios.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         NOMBRE,
         RESPONSABLE AS UNIDAD_RESPONSABLE,
         UTNDB.NOMBRES(PERSONA_RESPONSABLE) AS PERSONA_RESPONSABLE,
         OBSERVACION
     FROM UTNDB.MGI_TAB_INFRAESTRUCTU...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/linea-investigacion.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         LINV.DESCRIPCION
     FROM
         UTNDB.MGI_TAB_LINEA_INVE_PROYECTO P
     INNER JOIN UTNDB.MGI_TAB_LINEA_INVESTIGACION LINV
         ON P.LINEA_INV_CODIGO = LINV.CODIGO
     W...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/objetivos-especificos.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     DESCRIPCION,
     MEDIO_VERIFICACION
 FROM UTNDB.MGI_TAB_OBJ_ESPECIFICOS
 WHERE COD_PROY = :codigo
 ORDER BY CODIGO
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/proyectos.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 WITH usuario_cedula AS (
    SELECT PERSONA_CEDULA FROM UTNDB.INS_TAB_USUARIOS WHERE CUENTA = :cuenta
 )
 SELECT  DISTINCT
    P.CODIGO,
    P.CONVOCATORIA_CODIGO,
    P.TITULO_COMPLETO,
    P.INSTI...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 24
- **Tipo de operación:** SELECT
- **Fragmento:** `
 AND (
    E.DOCENTE_CEDULA IN (SELECT PERSONA_CEDULA FROM usuario_cedula)
    OR E.INVESTIGADOR_CEDULA IN (SELECT PERSONA_CEDULA FROM usuario_cedula)
    OR E.EMPLEADO_CEDULA IN (SELECT PERSONA_CEDU...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 50
- **Tipo de operación:** SELECT
- **Fragmento:** `
 WITH usuario_cedula AS (
    SELECT PERSONA_CEDULA FROM UTNDB.INS_TAB_USUARIOS WHERE CUENTA = :cuenta
 )
 SELECT COUNT(DISTINCT P.CODIGO) AS TOTAL
 FROM
    UTNDB.MGI_TAB_PROYECTOS P
    LEFT OUTER ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/sectores-impacto.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         SEC.DESCRIPCION AS SECTOR,
         P.OBSERVACION
     FROM
         UTNDB.MGI_TAB_SECT_IMPA_PROYECTOS P
     INNER JOIN
         UTNDB.MGI_TAB_SECTOR_IMPACTO SEC
         ON P.S...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/proyectos-investigacion/repository/queries/software.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         NOMBRE,
         CASE
             WHEN PROPIEDAD = 'S' THEN 1
             ELSE 0
         END PROPIEDAD_UTN,
         OBSERVACION
     FROM UTNDB.MGI_TAB_INFRAESTRUCTURA
     W...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

