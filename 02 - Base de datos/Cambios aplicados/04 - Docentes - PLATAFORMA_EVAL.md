# Docentes — columna PLATAFORMA_EVAL y guardado de actividades

- **Repo:** `utn-movil-portafolio-docentes`, rama `practicas-preprofesionales`
- **Commits:** `12acb64` (2026-09-25, scripts) · merge `9cd3017` · `cff82ce` (el código que la usa)
- **Scripts:** `db/cambios/002_alter_lms_tab_actividad_academica.sql` y `db/cambios/003_mvl_prc_guardar_actividad_docente.sql`
- **En la base de desarrollo:** `MOVIL_UTN.MVL_PRC_GUARDAR_ACTIVIDAD_DOCENTE` tiene el parámetro `pPlataformaEval`, declarado con el tipo de la columna `LMS_TAB_ACTIVIDAD_ACADEMICA.PLATAFORMA_EVAL` (comprobado leyendo el procedimiento con el MCP el 2026-10-14; si la columna no existiera, el procedimiento no compilaría).
- **Producción:** no verificado.

## Por qué

El docente elige si una evaluación en línea se rinde en el portafolio web o en la app. La elección se guarda en `UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA.PLATAFORMA_EVAL` (`'WEB'` o `'MOVIL'`; vacía: la app no la bloquea). El backend de estudiante bloquea abrir y responder en la app cuando vale `'WEB'` (`bloquearSiSoloWeb`, en `evaluacion_online.service.ts`); finalizar y ver el resultado siguen abiertos para cerrar un intento empezado antes del cambio.

## Qué cambió en la base

| Script | Objeto | Cambio |
|---|---|---|
| `002` | `UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA` | nueva columna `PLATAFORMA_EVAL VARCHAR2(10)` con `CHECK IN ('WEB','MOVIL')` |
| `003` | `MOVIL_UTN.MVL_PRC_GUARDAR_ACTIVIDAD_DOCENTE` | recibe `pPlataformaEval` (opcional) y lo guarda en la columna |

`001_mvl_prc_guardar_actividad_docente.sql` (commit `df677fc`, 2026-09-20) es la versión anterior del mismo procedimiento; `003` la reemplaza.

## Cómo se comprobó

- El procedimiento de desarrollo es el de `003` (parámetro `pPlataformaEval` presente).
- La columna se lee en el flujo de estudiante: `GET_REGLAS_EVALUACION` selecciona `act.PLATAFORMA_EVAL`, y abrir evaluaciones en dev respondió 200 en las pruebas del 2026-10-14.
- La vista `MVL_VIEW_ACTIVIDAD_DOCENTE` de la fase 2 incluye la columna (ver [[03 - Docentes - fase 2 - SELECT a vistas]]).

## Pendiente

- [ ] Aplicar `002` y `003` en producción antes de que el código llegue a `main`.

## Scripts

> [!example]- `002_alter_lms_tab_actividad_academica.sql`
> ```sql
> --------------------------------------------------------------------------------
> -- 002 · UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA (Columna PLATAFORMA_EVAL)
> --
> -- Agrega la columna PLATAFORMA_EVAL con restriccion CHECK ('WEB', 'MOVIL')
> -- para definir en que plataforma se rinde una evaluacion online.
> --------------------------------------------------------------------------------
> ALTER TABLE UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA ADD (PLATAFORMA_EVAL VARCHAR2(10) CONSTRAINT LMS_CK_ACT_PLATAFORMA_EVAL CHECK (PLATAFORMA_EVAL IN ('WEB','MOVIL')));
> ```

> [!example]- `003_mvl_prc_guardar_actividad_docente.sql`
> ```sql
> --------------------------------------------------------------------------------
> -- 003 · MOVIL_UTN.MVL_PRC_GUARDAR_ACTIVIDAD_DOCENTE
> --
> -- Actualiza el procedimiento de guardado de actividades docentes para recibir
> -- y almacenar el parametro pPlataformaEval en LMS_TAB_ACTIVIDAD_ACADEMICA.
> --------------------------------------------------------------------------------
> CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_GUARDAR_ACTIVIDAD_DOCENTE (
>     pIdActividad          IN OUT LMS_TAB_ACTIVIDAD_ACADEMICA.ID_ACTIVIDAD%TYPE,
>     pIdCurso              IN     LMS_TAB_ACTIVIDAD_ACADEMICA.ID_CURSO%TYPE,
>     pCodigoContenido      IN     LMS_TAB_ACTIVIDAD_ACADEMICA.CODIGO_CONTENIDO%TYPE,
>     pInstCodigo           IN     LMS_TAB_ACTIVIDAD_ACADEMICA.INST_CODIGO%TYPE,
>     pModaEstudCodigo      IN     LMS_TAB_ACTIVIDAD_ACADEMICA.MODA_ESTUD_CODIGO%TYPE,
>     pSistEstudCodigo      IN     LMS_TAB_ACTIVIDAD_ACADEMICA.SIST_ESTUD_CODIGO%TYPE,
>     pTcicloacadCodigo     IN     LMS_TAB_ACTIVIDAD_ACADEMICA.TCICLOACAD_CODIGO%TYPE,
>     pTfinanciaCodigo      IN     LMS_TAB_ACTIVIDAD_ACADEMICA.TFINANCIA_CODIGO%TYPE,
>     pDepenCodigo          IN     LMS_TAB_ACTIVIDAD_ACADEMICA.DEPEN_CODIGO%TYPE,
>     pCicloAcadCodigo      IN     LMS_TAB_ACTIVIDAD_ACADEMICA.CICLO_ACAD_CODIGO%TYPE,
>     pMateriaCodigo        IN     LMS_TAB_ACTIVIDAD_ACADEMICA.MATERIA_CODIGO%TYPE,
>     pNivelCodigo          IN     LMS_TAB_ACTIVIDAD_ACADEMICA.NIVEL_CODIGO%TYPE,
>     pCodigoTipoEval       IN     LMS_TAB_ACTIVIDAD_ACADEMICA.CODIGO_TIPO_EVAL%TYPE,
>     pNombreCorto          IN     LMS_TAB_ACTIVIDAD_ACADEMICA.NOMBRE_CORTO%TYPE,
>     pFechaCreacion        IN     DATE,
>     pFechaInicio          IN     DATE,
>     pFechaFin             IN     DATE,
>     pEstado               IN     LMS_TAB_ACTIVIDAD_ACADEMICA.ESTADO%TYPE,
>     pCodigoParcial        IN     LMS_TAB_ACTIVIDAD_ACADEMICA.CODIGO_PARCIAL%TYPE,
>     pUrl                  IN     LMS_TAB_ACTIVIDAD_ACADEMICA.URL%TYPE,
>     pLimiteTiempo         IN     LMS_TAB_ACTIVIDAD_ACADEMICA.LIMITE_TIEMPO%TYPE,
>     pIntentosPermitidos   IN     LMS_TAB_ACTIVIDAD_ACADEMICA.INTENTOS_PERMITIDOS%TYPE,
>     pUsuarioOperador      IN     LMS_TAB_ACTIVIDAD_ACADEMICA.USUARIO_CREACION%TYPE,
>     pEvalAuto             IN     LMS_TAB_ACTIVIDAD_ACADEMICA.EVAL_AUTO%TYPE,
>     pLimTiempoHoras       IN     LMS_TAB_ACTIVIDAD_ACADEMICA.LIM_TIEMPO_HORAS%TYPE,
>     pDescripcion          IN     CLOB,
>     pTipoActividad        IN     LMS_TAB_ACTIVIDAD_ACADEMICA.TIPO_ACTIVIDAD%TYPE,
>     pBlob                 IN     BLOB,
>     pFileName             IN     UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO.NOMBRE_ARCHIVO%TYPE := NULL,
>     pMimeType             IN     UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO.MIME_TYPE%TYPE := NULL,
>     pQuitarAdjunto        IN     NUMBER := 0,
>     pPlataformaEval       IN     LMS_TAB_ACTIVIDAD_ACADEMICA.PLATAFORMA_EVAL%TYPE := NULL,
>     pOutError             OUT    VARCHAR2,
>     pOutIdActividad       OUT    NUMBER
> ) AS
>     vCedula      VARCHAR2(20);
>     vDirectorio  VARCHAR2(100);
>     vOutDocId    NUMBER;
> BEGIN
>     SAVEPOINT sp_guardar_actividad;
>
>     IF pIdActividad IS NULL THEN
>         INSERT INTO LMS_TAB_ACTIVIDAD_ACADEMICA (
>             ID_CURSO, CODIGO_CONTENIDO, INST_CODIGO, MODA_ESTUD_CODIGO,
>             SIST_ESTUD_CODIGO, TCICLOACAD_CODIGO, TFINANCIA_CODIGO, DEPEN_CODIGO,
>             CICLO_ACAD_CODIGO, MATERIA_CODIGO, NIVEL_CODIGO, CODIGO_TIPO_EVAL,
>             NOMBRE_CORTO, FECHA_CREACION, FECHA_INICIO, FECHA_FIN, ESTADO,
>             CODIGO_PARCIAL, URL, LIMITE_TIEMPO, INTENTOS_PERMITIDOS,
>             USUARIO_CREACION, EVAL_AUTO, LIM_TIEMPO_HORAS, DESCRIPCION,
>             TIPO_ACTIVIDAD, PLATAFORMA_EVAL
>         ) VALUES (
>             pIdCurso, pCodigoContenido, pInstCodigo, pModaEstudCodigo,
>             pSistEstudCodigo, pTcicloacadCodigo, pTfinanciaCodigo, pDepenCodigo,
>             pCicloAcadCodigo, pMateriaCodigo, pNivelCodigo, pCodigoTipoEval,
>             pNombreCorto, pFechaCreacion, pFechaInicio, pFechaFin, pEstado,
>             pCodigoParcial, pUrl, pLimiteTiempo, pIntentosPermitidos,
>             pUsuarioOperador, pEvalAuto, pLimTiempoHoras, pDescripcion,
>             pTipoActividad, pPlataformaEval
>         ) RETURNING ID_ACTIVIDAD INTO pIdActividad;
>     ELSE
>         UPDATE LMS_TAB_ACTIVIDAD_ACADEMICA
>            SET CODIGO_CONTENIDO       = pCodigoContenido,
>                CODIGO_TIPO_EVAL       = pCodigoTipoEval,
>                NOMBRE_CORTO           = pNombreCorto,
>                FECHA_INICIO           = pFechaInicio,
>                FECHA_FIN              = pFechaFin,
>                ESTADO                 = pEstado,
>                CODIGO_PARCIAL         = pCodigoParcial,
>                URL                    = pUrl,
>                LIMITE_TIEMPO          = pLimiteTiempo,
>                INTENTOS_PERMITIDOS    = pIntentosPermitidos,
>                EVAL_AUTO              = pEvalAuto,
>                LIM_TIEMPO_HORAS       = pLimTiempoHoras,
>                DESCRIPCION            = pDescripcion,
>                TIPO_ACTIVIDAD         = pTipoActividad,
>                PLATAFORMA_EVAL        = pPlataformaEval,
>                USUARIO_ACTUALIZACION  = pUsuarioOperador,
>                FECHA_ACTUALIZACION    = SYSDATE
>          WHERE ID_ACTIVIDAD = pIdActividad;
>
>         IF SQL%ROWCOUNT = 0 THEN
>             RAISE_APPLICATION_ERROR(-20010,
>                 'Actividad no encontrada: ' || pIdActividad);
>         END IF;
>     END IF;
>
>     pOutIdActividad := pIdActividad;
>
>     IF pBlob IS NOT NULL THEN
>         SELECT UTNDB.LMS_PCK_AULAS_VIRTUALES.LMS_FUN_CEDULA_USUARIO(pUsuarioOperador)
>           INTO vCedula
>           FROM DUAL;
>
>         SELECT 'CARGAR_ACTIVIDADES_' || TO_CHAR(SYSDATE, 'YYYY')
>           INTO vDirectorio
>           FROM DUAL;
>
>         MOVIL_UTN.MVL_PRC_GUARDAR_DOC_DIR(
>             pBlob, pFileName, pMimeType, vCedula,
>             35,
>             vDirectorio, pUsuarioOperador, vOutDocId
>         );
>
>         IF vOutDocId > 0 THEN
>             UPDATE LMS_TAB_ACTIVIDAD_ACADEMICA
>                SET ID_DOCUMENTO_DIRECTORIO = vOutDocId
>              WHERE ID_ACTIVIDAD = pIdActividad;
>         ELSE
>             RAISE_APPLICATION_ERROR(-20011,
>                 'No se pudo guardar el adjunto de la actividad');
>         END IF;
>
>     ELSIF NVL(pQuitarAdjunto, 0) = 1 THEN
>         UPDATE LMS_TAB_ACTIVIDAD_ACADEMICA
>            SET ID_DOCUMENTO_DIRECTORIO = NULL
>          WHERE ID_ACTIVIDAD = pIdActividad;
>     END IF;
>
>     pOutError := NULL;
>
> EXCEPTION
>     WHEN OTHERS THEN
>         ROLLBACK TO sp_guardar_actividad;
>         pOutIdActividad := NULL;
>         pOutError       := SQLERRM;
> END MVL_PRC_GUARDAR_ACTIVIDAD_DOCENTE;
> /
> ```
