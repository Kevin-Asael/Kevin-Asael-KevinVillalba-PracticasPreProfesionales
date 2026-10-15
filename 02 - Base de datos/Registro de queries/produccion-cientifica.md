
# Módulo: portafolio-docentes/produccion-cientifica

*Fecha de auditoría: 2026-09-09T14:35:27.021Z*

## Archivo: /src/modules/produccion-cientifica/repository/queries/articulos.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT DISTINCT
         OP.CODIGO,
         OP.TITULO_OBRA,
         OP.FECHA_REGISTRO,
         OP.FECHA_PUBLICACION,
         OP.ESTADO,
         BDATOS.SIGLA AS BD_INDEXADA,
         OP.TIPO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 27
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT COUNT(DISTINCT OP.CODIGO) AS TOTAL
     FROM UTNDB.RHU_TAB_OBRAS_PUBLICADAS OP
     LEFT JOIN UTNDB.MGI_TAB_ESTADO_PROYECTO EST_P
         ON OP.OBRA_VALIDADA_CUICYT = EST_P.CODIGO
     I...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/autores-obra.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     CASE
         WHEN RC.PART_EXTERNO IS NULL THEN NOMBRES(PER.CEDULA)
         ELSE PART_EXTERNO
     END AS NOMBRES,
     PER.IDENTIFICACION AS CEDULA,
     CASE
         WHEN RC.PART_EXT...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/capitulos-libro.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
     OP.CODIGO,
     OP.TITULO_OBRA,
     OP.TIPO_PUBLICACION,
     OP.TITULO_CAP_PUBLICACION,
     OP.ESTADO,
     OP.FILIACION_UTN,
     OP.FECHA_REGISTRO,
     OP.FECHA_PUBLICACIO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 25
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COUNT(DISTINCT OP.CODIGO) AS TOTAL
 FROM UTNDB.RHU_TAB_OBRAS_PUBLICADAS OP
 INNER JOIN UTNDB.RHU_TAB_OBRA_PARTICIPACION OPT
     ON OP.CODIGO = OPT.CODIGO_OBRA
 INNER JOIN UTNDB.INS_TAB_USUAR...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/conteo-bd-indexada.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     BD.CODIGO,
     BD.SIGLA,
     NVL(CONTEO.CANTIDAD, 0) AS CANTIDAD
 FROM UTNDB.MGI_TAB_BD BD
 LEFT JOIN (
     SELECT
         OP.BD AS CODIGO_BD,
         COUNT(DISTINCT OP.CODIGO) AS C...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/conteo-tipos-obra.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT
     TIPOS.TIPO_PUBLICACION,
     NVL(CONTEO.CANTIDAD, 0) AS CANTIDAD
 FROM (
     SELECT 'Artículo' AS TIPO_PUBLICACION FROM DUAL
     UNION ALL SELECT 'Libro' FROM DUAL
     UNION ALL SELEC...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/detalle-articulo.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     OP.CODIGO,
     OP.TIPO_PUBLICACION,
     OP.TIPO AS TIPO_ARTICULO,
     OP.TITULO_OBRA,
     OP.FILIACION_UTN,
     OP.ACCESO_ABIERTO,
     EDI.NOMBRE AS EDITORIAL,
     OP.DEPEN_ASO_EX...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/detalle-cap-libro.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     OP.CODIGO,
     OP.TIPO_PUBLICACION,
     OP.FILIACION_UTN,
     OP.TITULO_OBRA AS TITULO_LIBRO,
     OP.TOTAL_CAP_LIBRO AS NUM_TOTAL_CAPS_LIBRO,
     OP.TITULO_CAP_PUBLICACION AS TITULO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/detalle-libro.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     OP.CODIGO,
     OP.TIPO_PUBLICACION,
     OP.TITULO_OBRA,
     OP.FILIACION_UTN,
     OP.DEPEN_ASO_EXTERNA,
     OP.REVISION_PARES,
     OP.NOM_REVISORES AS NOMBRE_REVISORES,
     OP.NOM...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/detalle-obra-artistica.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     OP.CODIGO,
     OP.TIPO_PUBLICACION,
     OP.ART_TIPO_OBRA AS TIPO_PRODUCCION,
     OP.FILIACION_UTN,
     OP.TITULO_OBRA AS CEDULA_OBRA,
     OP.REGISTRO_SENADI,
     OP.ART_FORMAL_CONC...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/detalle-ponencia.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     OP.CODIGO,
     OP.TIPO_PUBLICACION,
     OP.TITULO_OBRA AS TITULO_EVENTO,
     OP.TITULO_CAP_PUBLICACION AS TITULO_PONENCIA,
     OP.FILIACION_UTN,
     OP.EDICION AS NUM_EDICION_EVENTO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/doc-evidencia.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         EVIDENCIA AS ARCHIVO,
         O_EVIDENCIAS_NAME AS EVIDENCIA_NAME,
         O_EVIDENCIAS_MIMETYPE AS EVIDENCIA_MIMETYPE
     FROM
         UTNDB.RHU_TAB_OBRAS_PUBLICADAS
     WH...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/doc-imagen.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         IMAGEN AS ARCHIVO,
         IMAGEN_NAME AS EVIDENCIA_NAME,
         IMAGEN_MIMETYPE AS EVIDENCIA_MIMETYPE
     FROM
         UTNDB.RHU_TAB_OBRAS_PUBLICADAS
     WHERE
         CO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/doc-informe1-pares.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         INF_REVISION_PARES AS ARCHIVO,
         REVISION_PARES_NAME AS EVIDENCIA_NAME,
         REVISION_PARES_MIMETYPE AS EVIDENCIA_MIMETYPE
     FROM
         UTNDB.RHU_TAB_OBRAS_PUBLI...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/doc-informe2-pares.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         INF_PAR_DOS AS ARCHIVO,
         INF_PAR_DOS_NOMBRE AS EVIDENCIA_NAME,
         INF_PAR_DOS_MIMETYPE AS EVIDENCIA_MIMETYPE
     FROM
         UTNDB.RHU_TAB_OBRAS_PUBLICADAS
     ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/doc-publicacion.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         PDF AS ARCHIVO,
         EVIDENCIA_NAME,
         EVIDENCIA_MIMETYPE
     FROM
         UTNDB.RHU_TAB_OBRAS_PUBLICADAS
     WHERE
         CODIGO = :codigo
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/doc-publicaciones.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         ART_PUBLICACIONES AS ARCHIVO,
         ART_PUBLICACIONES_NAME AS EVIDENCIA_NAME,
         ART_PUBLICACIONES_MIMETYPE AS EVIDENCIA_MIMETYPE
     FROM
         UTNDB.RHU_TAB_OBRAS_...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/doc-senadi.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         SENADI AS ARCHIVO,
         SENADI_FILENAME AS EVIDENCIA_NAME,
         SENADI_MIMETYPE AS EVIDENCIA_MIMETYPE
     FROM
         UTNDB.RHU_TAB_OBRAS_PUBLICADAS
     WHERE
       ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/libros.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
     OP.CODIGO,
     OP.TITULO_OBRA,
     OP.FECHA_REGISTRO,
     OP.FECHA_PUBLICACION,
     OP.ESTADO,
     OP.TIPO_PUBLICACION,
     OP.FILIACION_UTN,
     OP.IDIOMA,
     EST_P.DE...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 25
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COUNT(DISTINCT OP.CODIGO) AS TOTAL
 FROM UTNDB.RHU_TAB_OBRAS_PUBLICADAS OP
 LEFT JOIN UTNDB.RHU_TAB_OBRA_PARTICIPACION OPT
     ON OP.CODIGO = OPT.CODIGO_OBRA
 INNER JOIN UTNDB.INS_TAB_USUARI...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/obras-artisticas.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
     OP.CODIGO,
     OP.TITULO_OBRA,
     OP.TIPO_PUBLICACION,
     OP.ESTADO,
     OP.ART_TIPO_OBRA,
     OP.FECHA_REGISTRO,
     OP.FECHA_PUBLICACION,
     OP.FILIACION_UTN,
     E...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 24
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COUNT(DISTINCT OP.CODIGO) AS TOTAL
 FROM UTNDB.RHU_TAB_OBRAS_PUBLICADAS OP
 INNER JOIN UTNDB.RHU_TAB_OBRA_PARTICIPACION OPT
     ON OP.CODIGO = OPT.CODIGO_OBRA
 INNER JOIN UTNDB.INS_TAB_USUAR...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/ponencias.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
     OP.CODIGO,
     OP.TITULO_OBRA,
     OP.TIPO_PUBLICACION,
     OP.TITULO_CAP_PUBLICACION,
     OP.ESTADO,
     OP.PAIS_EVENTO,
     OP.CIUDAD_EVENTO,
     OP.FECHA_REGISTRO,
   ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 27
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COUNT(DISTINCT OP.CODIGO) AS TOTAL
 FROM UTNDB.RHU_TAB_OBRAS_PUBLICADAS OP
 INNER JOIN UTNDB.RHU_TAB_OBRA_PARTICIPACION OPT
     ON OP.CODIGO = OPT.CODIGO_OBRA
 INNER JOIN UTNDB.INS_TAB_USUAR...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/proceedings.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
     OP.CODIGO,
     OP.TITULO_OBRA,
     OP.TIPO_PUBLICACION,
     OP.TITULO_CAP_PUBLICACION,
     OP.ANIO,
     OP.ESTADO,
     OP.FILIACION_UTN,
     OP.FECHA_REGISTRO,
     OP.FE...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 25
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COUNT(DISTINCT OP.CODIGO) AS TOTAL
 FROM UTNDB.RHU_TAB_OBRAS_PUBLICADAS OP
 INNER JOIN UTNDB.RHU_TAB_OBRA_PARTICIPACION OPT
     ON OP.CODIGO = OPT.CODIGO_OBRA
 INNER JOIN UTNDB.INS_TAB_USUAR...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/produccion-cientifica/repository/queries/tipos-obra-artistica.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     OP.ART_TIPO_OBRA,
     COUNT(*) AS CANTIDAD
 FROM UTNDB.RHU_TAB_OBRAS_PUBLICADAS OP
 WHERE OP.ART_TIPO_OBRA IS NOT NULL
 GROUP BY OP.ART_TIPO_OBRA
 ORDER BY CANTIDAD DESC
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

