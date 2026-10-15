# Docentes — fase 1: queries a vistas, funciones y procedimientos de MOVIL_UTN

- **Repo:** `utn-movil-portafolio-docentes`, rama `practicas-preprofesionales`
- **Commits:** `f2b24ea` (2026-09-25) · merge `7fc1e77` (2026-09-25)
- **Scripts:** `db/cambios/004_migracion_queries/` (26 vistas, 2 funciones, 4 procedimientos)
- **En la base de desarrollo:** los 32 existen en `MOVIL_UTN` (comprobado con el MCP de estructura el 2026-10-14).
- **Producción:** no verificado.

## Por qué

El mismo motivo que en estudiante: sacar el SQL de los `.ts` para que un cambio de tabla o columna deje el objeto inválido en la base, a la vista del DBA, en vez de fallar cuando un docente abre la pantalla.

## Cómo se validó

- **Vistas:** consulta original `MINUS` vista en los dos sentidos, 0 diferencias. Registradas como `D1`–`D19` en [[00_Indice_Docentes]].
- **Módulo `foro_online`** (3 vistas, 2 funciones, 4 procedimientos): probado de punta a punta el 2026-09-17 con `curl` real (GET, POST, PATCH y DELETE) con `<cuenta-de-prueba>`, cruzado contra Oracle antes y después.
- **Comparación general antes del merge (2026-09-22):** el código original y el migrado, levantados a la vez, contra las mismas 37 llamadas GET: 35 con el mismo contenido (28 idénticas byte a byte y 7 que solo cambian el orden de claves JSON o de empates sin `ORDER BY` en las dos versiones).

> [!warning] Sin prueba registrada por objeto
> `MVL_VIEW_ESTUDIANTES_EVAL_CUESTIONARIO`, `MVL_VIEW_ESTUDIANTES_EVAL_NOTAS`, `MVL_VIEW_POLITICAS_EVALUACION`, `MVL_VIEW_PREGUNTAS_EVAL_ESTUDIANTES`. Existen en la base y el código de la rama los usa, pero no hay un MINUS ni un `curl` anotado para cada uno.

## Objetos

| Registro | Objeto | Tipo | Módulo | En dev | Prueba |
|---|---|---|---|---|---|
| D1 | `MVL_VIEW_CICLOS_DISTRIBUTIVO` | vista | distributivo-docente | sí | MINUS en los dos sentidos: 0 diferencias |
| D2 | `MVL_VIEW_DISTRIBUTIVO_ACADEMICO` | vista | distributivo-docente | sí | MINUS en los dos sentidos: 0 diferencias |
| D3 | `MVL_VIEW_DISTRIBUTIVO_PERSONAL` | vista | distributivo-docente | sí | MINUS en los dos sentidos: 0 diferencias |
| D4 | `MVL_VIEW_CICLOS_HORARIO_DOCENTE` | vista | horario-docente | sí | MINUS en los dos sentidos: 0 diferencias |
| D5 | `MVL_VIEW_HORARIO_DOCENTE` | vista | horario-docente | sí | MINUS en los dos sentidos: 0 diferencias |
| D6 | `MVL_VIEW_CALENDARIO_GENERAL_DOCENTE` | vista | calendario-general | sí | MINUS en los dos sentidos: 0 diferencias |
| D7 | `MVL_VIEW_MATERIA_ID_CURSO_DOCENTE` | vista | calendario-general | sí | MINUS en los dos sentidos: 0 diferencias |
| D8 | `MVL_VIEW_ACTIVIDAD_INSTRUC_DOCENTE` | vista | foro_online | sí | MINUS en los dos sentidos: 0 diferencias |
| D09 | `MVL_VIEW_CICLOS_REGISTRO_ACADEMICO` | vista | registro-academico | sí | MINUS en los dos sentidos: 0 diferencias |
| D10 | `MVL_VIEW_DETALLE_MATERIA_NOTAS_DOCENTE` | vista | registro-academico | sí | MINUS en los dos sentidos: 0 diferencias |
| D11 | `MVL_VIEW_ESTUDIANTES_MATERIA_DOCENTE` | vista | registro-academico | sí | MINUS en los dos sentidos: 0 diferencias |
| D12 | `MVL_VIEW_LISTA_ESTUDIANTES_FOTO_DOCENTE` | vista | registro-academico | sí | MINUS en los dos sentidos: 0 diferencias |
| D13 | `MVL_VIEW_NOTAS_GENERAL_ESTUDIANTES_DOCENTE` | vista | registro-academico | sí | MINUS en los dos sentidos: 0 diferencias |
| D14 | `MVL_VIEW_MATERIAS_REGISTRO_ACADEMICO_DOCENTE` | vista | registro-academico | sí | MINUS en los dos sentidos: 0 diferencias |
| D15 | `MVL_VIEW_ESTADO_AULA_VIRTUAL_DOCENTE` | vista | registro-academico | sí | MINUS en los dos sentidos: 0 diferencias |
| D16 | `MVL_VIEW_ACTIVIDAD_DOCENTE` | vista | actividad | sí | MINUS en los dos sentidos: 0 diferencias |
| D17 | `MVL_VIEW_CONTENIDOS_ACTIVIDAD` | vista | actividad | sí | MINUS en los dos sentidos: 0 diferencias |
| D18 | `MVL_VIEW_TIPOS_ACTIVIDAD` | vista | actividad | sí | MINUS en los dos sentidos: 0 diferencias |
| D19 | `MVL_VIEW_PARCIALES_ACTIVIDAD` | vista | actividad, aula-virtual | sí | MINUS en los dos sentidos: 0 diferencias |
| foro | `MVL_FUN_FORO_ACTIVIDAD` | función | foro_online | sí | de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después |
| foro | `MVL_FUN_FORO_GENERAL` | función | foro_online | sí | de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después |
| foro | `MVL_PRC_FORO_ACTUALIZAR` | procedimiento | foro_online | sí | de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después |
| foro | `MVL_PRC_FORO_CREAR_RESPUESTA_ACTIVIDAD` | procedimiento | foro_online | sí | de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después |
| foro | `MVL_PRC_FORO_CREAR_RESPUESTA_GENERAL` | procedimiento | foro_online | sí | de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después |
| foro | `MVL_PRC_FORO_ELIMINAR` | procedimiento | foro_online | sí | de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después |
| foro | `MVL_VIEW_FORO_ACT_ESTADO` | vista | foro_online | sí | de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después |
| foro | `MVL_VIEW_FORO_AUTORES` | vista | foro_online | sí | de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después |
| foro | `MVL_VIEW_FORO_TIPO` | vista | foro_online | sí | de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después |
| — | `MVL_VIEW_ESTUDIANTES_EVAL_CUESTIONARIO` | vista | actividad | sí | sin prueba registrada por objeto |
| — | `MVL_VIEW_ESTUDIANTES_EVAL_NOTAS` | vista | actividad | sí | sin prueba registrada por objeto |
| — | `MVL_VIEW_POLITICAS_EVALUACION` | vista | actividad | sí | sin prueba registrada por objeto |
| — | `MVL_VIEW_PREGUNTAS_EVAL_ESTUDIANTES` | vista | actividad | sí | sin prueba registrada por objeto |

## Pendiente

- [ ] Correr el MINUS de `MVL_VIEW_ESTUDIANTES_EVAL_CUESTIONARIO`, `MVL_VIEW_ESTUDIANTES_EVAL_NOTAS`, `MVL_VIEW_POLITICAS_EVALUACION`, `MVL_VIEW_PREGUNTAS_EVAL_ESTUDIANTES`.

## Antes y después, objeto por objeto


> [!example]- `MVL_VIEW_CICLOS_DISTRIBUTIVO` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `CICLO_ACADEMICO_DISTRIBUTIVO_QUERY` (`distributivo-docente`). V2, subconsulta cuenta→cédula reescrita a JOIN con `INS_TAB_USUARIOS`. Validada (MINUS 0 en los 2 sentidos), curl idéntico.
>
> **Lo usa:** `src/modules/distributivo-docente/repository/queries/ciclo-academico-distributivo.query.ts`
>
> **Antes** (`src/modules/distributivo-docente/repository/queries/ciclo-academico-distributivo.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const CICLO_ACADEMICO_DISTRIBUTIVO_QUERY = `
> SELECT DISTINCT
>        (SELECT C.DESCRIPCION
>                   FROM ACA_TAB_CICLOS_ACADEMICOS C
>                  WHERE C.CODIGO = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO) AS DESCRIPCION,
>        TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO AS CODIGO_CICLO
>   FROM    UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS
>        INNER JOIN
>           UTNDB.ACA_TAB_DISTRIBUTIVOS TAB_DISTRIBUTIVOS
>        ON     (TAB_MATERIAS.NIVEL_CODIGO = TAB_DISTRIBUTIVOS.NIVEL_CODIGO)
>           AND (TAB_MATERIAS.CODIGO = TAB_DISTRIBUTIVOS.MATERIA_CODIGO)
>           AND (TAB_MATERIAS.TMATERIA_CODIGO != '04')
>  WHERE (TAB_DISTRIBUTIVOS.INST_CODIGO = '001'
>         AND TAB_DISTRIBUTIVOS.MATERIA_CODIGO NOT IN
>                (SELECT MA.CODIGO
>                   FROM ACA_TAB_MATERIAS MA
>                  WHERE MA.TMATERIA_CODIGO = '07' OR MA.TMATERIA_CODIGO = '04')
>         AND TAB_DISTRIBUTIVOS.DOCENTE_CEDULA =
>                (SELECT PERSONA_CEDULA
>                   FROM INS_TAB_USUARIOS
>                  WHERE CUENTA = :G_USUARIO_SOPORTE)                                    
>                        
>         AND TAB_DISTRIBUTIVOS.NIVEL_CODIGO <> '00'
>         AND (TAB_MATERIAS.TMATERIA_CODIGO != '04')
>         AND TAB_MATERIAS.DEPEN_CODIGO NOT IN ('00263'))
>         ORDER BY substr(CODIGO_CICLO,3,2) desc, substr(CODIGO_CICLO,1,2) desc        
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_CICLOS_DISTRIBUTIVO
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/distributivo-docente
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_CICLOS_DISTRIBUTIVO ("CUENTA", "DESCRIPCION", "CODIGO_CICLO") AS
> SELECT DISTINCT
>        IU.CUENTA,
>        (SELECT C.DESCRIPCION
>           FROM UTNDB.ACA_TAB_CICLOS_ACADEMICOS C
>          WHERE C.CODIGO = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO) AS DESCRIPCION,
>        TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO AS CODIGO_CICLO
>   FROM UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS
>   INNER JOIN UTNDB.ACA_TAB_DISTRIBUTIVOS TAB_DISTRIBUTIVOS
>      ON (TAB_MATERIAS.NIVEL_CODIGO = TAB_DISTRIBUTIVOS.NIVEL_CODIGO
>      AND TAB_MATERIAS.CODIGO = TAB_DISTRIBUTIVOS.MATERIA_CODIGO
>      AND TAB_MATERIAS.TMATERIA_CODIGO != '04')
>   INNER JOIN UTNDB.INS_TAB_USUARIOS IU
>      ON (IU.PERSONA_CEDULA = TAB_DISTRIBUTIVOS.DOCENTE_CEDULA)
>  WHERE TAB_DISTRIBUTIVOS.INST_CODIGO = '001'
>    AND TAB_DISTRIBUTIVOS.MATERIA_CODIGO NOT IN
>           (SELECT MA.CODIGO
>              FROM UTNDB.ACA_TAB_MATERIAS MA
>             WHERE MA.TMATERIA_CODIGO = '07' OR MA.TMATERIA_CODIGO = '04')
>    AND TAB_DISTRIBUTIVOS.NIVEL_CODIGO <> '00'
>    AND TAB_MATERIAS.DEPEN_CODIGO NOT IN ('00263')
> ;
> ```

> [!example]- `MVL_VIEW_DISTRIBUTIVO_ACADEMICO` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `DISTRIBUTIVO_ACADEMICO_QUERY`. V2, `LMS_FUN_CEDULA_USUARIO(:bind)` reescrito a JOIN. Validada, curl idéntico.
>
> **Lo usa:** `src/modules/distributivo-docente/repository/queries/distributivo-academico.dto.ts`
>
> **Antes** (`src/modules/distributivo-docente/repository/queries/distributivo-academico.dto.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const DISTRIBUTIVO_ACADEMICO_QUERY = `
> SELECT CODIGO,
>        DEPENDENCIA,
>        CICLO AS "CICLO",
>        DESCRIPCION,
>        MATERIA,
>        PARALELO_CODIGO,
>        MODALIDAD,
>        OBSERVACION as "HORAS"
>   FROM (SELECT DISTINCT
>                ACA_TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>                ACA_TAB_MATERIAS.CODIGO,
>                ACA_TAB_DISTRIBUTIVOS.ESTADO DIST_ESTADO,
>                ACA_TAB_CICLOS_ACADEMICOS.ESTADO CICLO_ESTADO,
>                ACA_TAB_DEPENDENCIAS.NOMBRE DEPENDENCIA,
>                ACA_TAB_CICLOS_ACADEMICOS.DESCRIPCION CICLO,
>                'HORAS DOCENCIA' AS DESCRIPCION,
>                ACA_TAB_MATERIAS.DESCRIPCION AS MATERIA,
>                -- Modificación aquí
>                (SELECT MAX(HORAS_SEMANALES)
>                   FROM ACA_TAB_MATERIAS_PENSUMS MP
>                  WHERE     MP.MODA_ESTUD_CODIGO = ACA_TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO
>                        AND MP.CICLO_ACAD_CODIGO = ACA_TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO
>                        AND MP.DEPEN_CODIGO = ACA_TAB_DISTRIBUTIVOS.DEPEN_CODIGO
>                        AND MP.MATERIA_CODIGO = ACA_TAB_DISTRIBUTIVOS.MATERIA_CODIGO)
>                    AS OBSERVACION,
>                -- Modificación aquí
>                (SELECT MAX(DESCRIPCION)
>                   FROM UTNDB.ACA_TAB_MODALIDADES_ESTUDIOS
>                  WHERE CODIGO = ACA_TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO)
>                    AS MODALIDAD,
>                ACA_TAB_DISTRIBUTIVOS.PARALELO_CODIGO AS PARALELO_CODIGO
>           FROM UTNDB.ACA_TAB_DISTRIBUTIVOS  ACA_TAB_DISTRIBUTIVOS
>                INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS ACA_TAB_DEPENDENCIAS
>                    ON (    ACA_TAB_DISTRIBUTIVOS.DEPEN_CODIGO = ACA_TAB_DEPENDENCIAS.CODIGO
>                        AND ACA_TAB_DISTRIBUTIVOS.INST_CODIGO = ACA_TAB_DEPENDENCIAS.INST_CODIGO)
>                INNER JOIN UTNDB.ACA_TAB_MATERIAS ACA_TAB_MATERIAS
>                    ON (    ACA_TAB_DISTRIBUTIVOS.MATERIA_CODIGO = ACA_TAB_MATERIAS.CODIGO
>                        AND ACA_TAB_DISTRIBUTIVOS.NIVEL_CODIGO = ACA_TAB_MATERIAS.NIVEL_CODIGO)
>                INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS ACA_TAB_CICLOS_ACADEMICOS
>                    ON (ACA_TAB_CICLOS_ACADEMICOS.CODIGO = ACA_TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO)
>          WHERE     ACA_TAB_MATERIAS.NIVEL_CODIGO != '00'               
>                AND ACA_TAB_MATERIAS.TMATERIA_CODIGO <> '04'
>                AND ACA_TAB_CICLOS_ACADEMICOS.CODIGO = :P26_CICLO_ACADEMICO)
>  WHERE     DIST_ESTADO = 'A'       
>        AND DOCENTE_CEDULA = LMS_PCK_AULAS_VIRTUALES.LMS_FUN_CEDULA_USUARIO(:G_USUARIO_SOPORTE)
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_DISTRIBUTIVO_ACADEMICO
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/distributivo-docente
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_DISTRIBUTIVO_ACADEMICO ("CUENTA", "CICLO_ACAD_CODIGO", "CODIGO", "DEPENDENCIA", "CICLO", "DESCRIPCION", "MATERIA", "PARALELO_CODIGO", "MODALIDAD", "HORAS") AS
> SELECT DISTINCT
>        IU.CUENTA,
>        D.CICLO_ACAD_CODIGO,
>        M.CODIGO,
>        DEP.NOMBRE AS DEPENDENCIA,
>        CIC.DESCRIPCION AS CICLO,
>        'HORAS DOCENCIA' AS DESCRIPCION,
>        M.DESCRIPCION AS MATERIA,
>        D.PARALELO_CODIGO,
>        (SELECT MAX(MODA.DESCRIPCION)
>           FROM UTNDB.ACA_TAB_MODALIDADES_ESTUDIOS MODA
>          WHERE MODA.CODIGO = D.MODA_ESTUD_CODIGO) AS MODALIDAD,
>        (SELECT MAX(MP.HORAS_SEMANALES)
>           FROM UTNDB.ACA_TAB_MATERIAS_PENSUMS MP
>          WHERE MP.MODA_ESTUD_CODIGO = D.MODA_ESTUD_CODIGO
>            AND MP.CICLO_ACAD_CODIGO = D.CICLO_ACAD_CODIGO
>            AND MP.DEPEN_CODIGO = D.DEPEN_CODIGO
>            AND MP.MATERIA_CODIGO = D.MATERIA_CODIGO) AS HORAS
>   FROM UTNDB.ACA_TAB_DISTRIBUTIVOS D
>   INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS DEP
>      ON (D.DEPEN_CODIGO = DEP.CODIGO AND D.INST_CODIGO = DEP.INST_CODIGO)
>   INNER JOIN UTNDB.ACA_TAB_MATERIAS M
>      ON (D.MATERIA_CODIGO = M.CODIGO AND D.NIVEL_CODIGO = M.NIVEL_CODIGO)
>   INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS CIC
>      ON (CIC.CODIGO = D.CICLO_ACAD_CODIGO)
>   INNER JOIN UTNDB.INS_TAB_USUARIOS IU
>      ON (IU.PERSONA_CEDULA = D.DOCENTE_CEDULA)
>  WHERE M.NIVEL_CODIGO != '00'
>    AND M.TMATERIA_CODIGO <> '04'
>    AND D.ESTADO = 'A'
> ;
> ```

> [!example]- `MVL_VIEW_DISTRIBUTIVO_PERSONAL` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `DISTRIBUTIVO_PERSONAL_QUERY`. V2, mismo patrón, **sin DISTINCT** (el original no lo lleva; confirmado con datos reales que hay filas duplicadas legítimas que se suman en el backend). Validada (MINUS + COUNT(*) 2=2), curl idéntico.
>
> **Lo usa:** `src/modules/distributivo-docente/repository/queries/distributivo-personal.query.ts`
>
> **Antes** (`src/modules/distributivo-docente/repository/queries/distributivo-personal.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const DISTRIBUTIVO_PERSONAL_QUERY = `
> SELECT DEPENDENCIA,CICLO,DESCRIPCION,HORAS,OBSERVACION FROM(
> SELECT ACA_TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>         ACA_TAB_DISTRIBUTIVOS.ESTADO DIST_ESTADO,
>         ACA_TAB_CICLOS_ACADEMICOS.ESTADO CICLO_ESTADO,
>         ACA_TAB_DEPENDENCIAS.NOMBRE DEPENDENCIA,
>        ACA_TAB_CICLOS_ACADEMICOS.DESCRIPCION CICLO,
>        ACA_TAB_MATERIAS.DESCRIPCION,   
>        ACA_TAB_DISTRIBUTIVOS.HORAS_COMPLEMENTARIAS HORAS,
>        ACA_TAB_DISTRIBUTIVOS.OBSERVACION
> FROM UTNDB.ACA_TAB_DISTRIBUTIVOS ACA_TAB_DISTRIBUTIVOS
>     INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS ACA_TAB_DEPENDENCIAS
>         ON (ACA_TAB_DISTRIBUTIVOS.DEPEN_CODIGO = ACA_TAB_DEPENDENCIAS.CODIGO
>             AND ACA_TAB_DISTRIBUTIVOS.INST_CODIGO =ACA_TAB_DEPENDENCIAS.INST_CODIGO)
>     INNER JOIN UTNDB.ACA_TAB_MATERIAS ACA_TAB_MATERIAS
>         ON (ACA_TAB_DISTRIBUTIVOS.MATERIA_CODIGO = ACA_TAB_MATERIAS.CODIGO
>             AND ACA_TAB_DISTRIBUTIVOS.NIVEL_CODIGO = ACA_TAB_MATERIAS.NIVEL_CODIGO)
>     INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS ACA_TAB_CICLOS_ACADEMICOS
>         ON (ACA_TAB_CICLOS_ACADEMICOS.CODIGO =ACA_TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO)
>  WHERE ACA_TAB_MATERIAS.NIVEL_CODIGO='00'
>     AND ACA_TAB_CICLOS_ACADEMICOS.CODIGO = :P26_CICLO_ACADEMICO
>  )
>  WHERE DIST_ESTADO='A'    
>         AND DOCENTE_CEDULA=LMS_PCK_AULAS_VIRTUALES.LMS_FUN_CEDULA_USUARIO(:G_USUARIO_SOPORTE)
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_DISTRIBUTIVO_PERSONAL
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/distributivo-docente
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_DISTRIBUTIVO_PERSONAL ("CUENTA", "CICLO_ACAD_CODIGO", "DEPENDENCIA", "CICLO", "DESCRIPCION", "HORAS", "OBSERVACION") AS
> SELECT IU.CUENTA,
>        D.CICLO_ACAD_CODIGO,
>        DEP.NOMBRE AS DEPENDENCIA,
>        CIC.DESCRIPCION AS CICLO,
>        M.DESCRIPCION AS DESCRIPCION,
>        D.HORAS_COMPLEMENTARIAS AS HORAS,
>        D.OBSERVACION
>   FROM UTNDB.ACA_TAB_DISTRIBUTIVOS D
>   INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS DEP
>      ON (D.DEPEN_CODIGO = DEP.CODIGO AND D.INST_CODIGO = DEP.INST_CODIGO)
>   INNER JOIN UTNDB.ACA_TAB_MATERIAS M
>      ON (D.MATERIA_CODIGO = M.CODIGO AND D.NIVEL_CODIGO = M.NIVEL_CODIGO)
>   INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS CIC
>      ON (CIC.CODIGO = D.CICLO_ACAD_CODIGO)
>   INNER JOIN UTNDB.INS_TAB_USUARIOS IU
>      ON (IU.PERSONA_CEDULA = D.DOCENTE_CEDULA)
>  WHERE M.NIVEL_CODIGO = '00'
>    AND D.ESTADO = 'A'
> ;
> ```

> [!example]- `MVL_VIEW_CICLOS_HORARIO_DOCENTE` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `CICLO_ACADEMICO_QUERY` (`horario-docente`). **V1** (el plan maestro la clasificaba V2 con `ROW_NUMBER()`, dato desactualizado — el archivo real es un filtro directo por cédula). Validada (MINUS 0 en los 2 sentidos).
>
> **Lo usa:** `src/modules/horario-docente/repository/queries/ciclo-academico.query.ts`
>
> **Antes** (`src/modules/horario-docente/repository/queries/ciclo-academico.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const CICLO_ACADEMICO_QUERY = `
> SELECT DESCRIPCION,CODIGO FROM(
> SELECT DISTINCT CIC.DESCRIPCION,CIC.CODIGO,CIC.FECHA_INICIO,CIC.FECHA_FIN
>     FROM ACA_TAB_CICLOS_ACADEMICOS CIC
>     INNER JOIN UTNDB.ACA_TAB_DISTRIBUTIVOS DIS ON(DIS.CICLO_ACAD_CODIGO = CIC.CODIGO)
>     INNER JOIN UTNDB.ACA_TAB_MATERIAS MAT ON(MAT.CODIGO=DIS.MATERIA_CODIGO AND MAT.NIVEL_CODIGO=DIS.NIVEL_CODIGO
>         AND MAT.TMATERIA_CODIGO NOT IN('04','07') AND MAT.NIVEL_CODIGO <> '00' AND MAT.DEPEN_CODIGO NOT IN ('00263')
>         AND DIS.INST_CODIGO = '001')
>     WHERE DIS.DOCENTE_CEDULA = :G_CEDULA_USUARIO
>     AND CIC.ESTADO='A'
>     ORDER BY CIC.FECHA_INICIO DESC, CIC.DESCRIPCION
> )  
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_CICLOS_HORARIO_DOCENTE
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/horario-docente
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_CICLOS_HORARIO_DOCENTE ("DOCENTE_CEDULA", "DESCRIPCION", "CODIGO", "FECHA_INICIO", "FECHA_FIN") AS
> SELECT DISTINCT
>        DIS.DOCENTE_CEDULA,
>        CIC.DESCRIPCION,
>        CIC.CODIGO,
>        CIC.FECHA_INICIO,
>        CIC.FECHA_FIN
>   FROM UTNDB.ACA_TAB_CICLOS_ACADEMICOS CIC
>   INNER JOIN UTNDB.ACA_TAB_DISTRIBUTIVOS DIS ON (DIS.CICLO_ACAD_CODIGO = CIC.CODIGO)
>   INNER JOIN UTNDB.ACA_TAB_MATERIAS MAT ON (MAT.CODIGO = DIS.MATERIA_CODIGO AND MAT.NIVEL_CODIGO = DIS.NIVEL_CODIGO
>        AND MAT.TMATERIA_CODIGO NOT IN ('04','07') AND MAT.NIVEL_CODIGO <> '00' AND MAT.DEPEN_CODIGO NOT IN ('00263')
>        AND DIS.INST_CODIGO = '001')
>  WHERE CIC.ESTADO = 'A'
> ;
> ```

> [!example]- `MVL_VIEW_HORARIO_DOCENTE` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `HORARIO_DOCENTE_QUERIES` (`UNION` de horario modular/no modular). **V1**, mismo motivo. Validada (MINUS 0 en los 2 sentidos), curl confirma 2 bloques agrupados desde 4 filas crudas.
>
> **Lo usa:** `src/modules/horario-docente/repository/queries/horario.query.ts`
>
> **Antes** (`src/modules/horario-docente/repository/queries/horario.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const HORARIO_DOCENTE_QUERIES =
>     `
> SELECT
>     FECHA_INICIO,
>     FECHA_FIN,
>     CASE WHEN LENGTH(INICIO_HORA) = 4 THEN '0' || INICIO_HORA ELSE INICIO_HORA END AS INICIO_HORA,
>     CASE WHEN LENGTH(FIN_HORA) = 4 THEN '0' || FIN_HORA ELSE FIN_HORA END AS FIN_HORA,
>     MATERIA,
>     PARALELO,
>     NIVEL,
>     "ESTRUCTURA FÍSICA",
>     CARRERA,
>     DIA_SEMANA_CODIGO,
>     CICLO_ACAD_CODIGO,
>     DEPEN_CODIGO,
>     INST_CODIGO,
>     MATERIA_CODIGO,
>     MODA_ESTUD_CODIGO,
>     NIVEL_CODIGO,
>     PARALELO_CODIGO,
>     SIST_ESTUD_CODIGO,
>     TCICLOACAD_CODIGO,
>     TFINANCIA_CODIGO
>     
> FROM (
>     SELECT DISTINCT
>         NULL AS FECHA_INICIO,
>         NULL AS FECHA_FIN,
>         SUBSTR(TPH.INICIO_HORA, 1, LENGTH(TPH.INICIO_HORA) - 2) || 'H' || SUBSTR(TPH.INICIO_HORA, -1) AS INICIO_HORA,
>         SUBSTR(TPH.FIN_HORA, 1, LENGTH(TPH.FIN_HORA) - 2) || 'H' || SUBSTR(TPH.FIN_HORA, -1) AS FIN_HORA,
>         INS_PCK_GENERAL.FUN_OBTENER_ESTRUCTURA_FISICA(TH.ESTRUC_FIS_CODIGO) AS "ESTRUCTURA FÍSICA",
>         TH.DIA_SEMANA_CODIGO || ': ' || DECODE(TH.DIA_SEMANA_CODIGO,
>             '1', 'LUNES',
>             '2', 'MARTES',
>             '3', 'MIÉRCOLES',
>             '4', 'JUEVES',
>             '5', 'VIERNES',
>             '6', 'SÁBADO',
>             '7', 'DOMINGO') AS DIA_SEMANA_CODIGO,
>         TH.PARALELO_CODIGO AS PARALELO,
>         TH.NIVEL_CODIGO AS NIVEL,
>         (SELECT TAB_MATERIAS.DESCRIPCION
>          FROM ACA_TAB_MATERIAS TAB_MATERIAS
>          WHERE TAB_MATERIAS.CODIGO = TH.MATERIA_CODIGO
>            AND TAB_MATERIAS.NIVEL_CODIGO = TH.NIVEL_CODIGO) AS MATERIA,
>         FUN_OBTENER('ACA_TAB_DEPENDENCIAS', 'NOMBRE', TH.INST_CODIGO, TH.DEPEN_CODIGO, NULL) AS CARRERA,
>         TH.CICLO_ACAD_CODIGO,
>         TH.DEPEN_CODIGO,
>         TH.INST_CODIGO,
>         TH.MATERIA_CODIGO,
>         TH.MODA_ESTUD_CODIGO,
>         TH.NIVEL_CODIGO AS NIVEL_CODIGO,
>         TH.PARALELO_CODIGO AS PARALELO_CODIGO,
>         TH.SIST_ESTUD_CODIGO,
>         TH.TCICLOACAD_CODIGO,
>         TH.TFINANCIA_CODIGO
>     FROM
>         ACA_TAB_DETALLES_HORARIOS TH
>         LEFT JOIN ACA_TAB_PLANTILLAS_HORAS TPH ON TH.PLAN_HORAS_NUMERO = TPH.NUMERO AND TH.GRUPO_HORA_CODIGO = TPH.GRUPO_HORA_CODIGO
>         LEFT JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TC ON TC.CODIGO = TH.CICLO_ACAD_CODIGO
>     WHERE
>         TC.CODIGO = :P15_CICLO_ACADEMICO AND
>         TH.DOCENTE_CEDULA = :G_CEDULA_USUARIO
> )
> UNION
> SELECT
>     FECHA_INICIO,
>     FECHA_FIN,
>     INICIO_HORA AS CASO_INICIO_HORA,
>     FIN_HORA AS CASO_FIN_HORA,
>     MATERIA,
>     PARALELO,
>     NIVEL,
>     ESTRUCTURA_FISICA,
>     CARRERA,
>     DIA_SEMANA,
>     CICLO_ACAD_CODIGO,
>     DEPEN_CODIGO,
>     INST_CODIGO,
>     MATERIA_CODIGO,
>     MODA_ESTUD_CODIGO,
>     NIVEL_CODIGO,
>     PARALELO_CODIGO,
>     SIST_ESTUD_CODIGO,
>     TCICLOACAD_CODIGO,
>     TFINANCIA_CODIGO
> FROM (
>     SELECT DISTINCT
>         TO_CHAR(TCP.FECHA_INICIO, 'DD/MM/YYYY') AS FECHA_INICIO,
>         TO_CHAR(TCP.FECHA_FIN, 'DD/MM/YYYY') AS FECHA_FIN,
>         SUBSTR(TPH.INICIO_HORA, 1, LENGTH(TPH.INICIO_HORA) - 2) || 'H' || SUBSTR(TPH.INICIO_HORA, -1) AS INICIO_HORA,
>         SUBSTR(TPH.FIN_HORA, 1, LENGTH(TPH.FIN_HORA) - 2) || 'H' || SUBSTR(TPH.FIN_HORA, -1) AS FIN_HORA,
>         (SELECT TAB_MATERIAS.DESCRIPCION
>          FROM ACA_TAB_MATERIAS TAB_MATERIAS
>          WHERE TAB_MATERIAS.CODIGO = THM.MATERIA_CODIGO
>            AND TAB_MATERIAS.NIVEL_CODIGO = THM.NIVEL_CODIGO) AS MATERIA,
>         THM.PARALELO_CODIGO AS PARALELO,
>         THM.NIVEL_CODIGO AS NIVEL,
>         INS_PCK_GENERAL.FUN_OBTENER_ESTRUCTURA_FISICA(THM.ESTRUC_FIS_CODIGO) AS ESTRUCTURA_FISICA,
>         FUN_OBTENER('ACA_TAB_DEPENDENCIAS', 'NOMBRE', THM.INST_CODIGO, THM.DEPEN_CODIGO, NULL) AS CARRERA,
>         THM.DIA_SEMANA_CODIGO || ': ' || DECODE(THM.DIA_SEMANA_CODIGO,
>             '1', 'LUNES',
>             '2', 'MARTES',
>             '3', 'MIÉRCOLES',
>             '4', 'JUEVES',
>             '5', 'VIERNES',
>             '6', 'SÁBADO',
>             '7', 'DOMINGO') AS DIA_SEMANA,
>         THM.CICLO_ACAD_CODIGO,
>         THM.DEPEN_CODIGO,
>         THM.INST_CODIGO,
>         THM.MATERIA_CODIGO,
>         THM.MODA_ESTUD_CODIGO,
>         THM.NIVEL_CODIGO AS NIVEL_CODIGO,
>         THM.PARALELO_CODIGO AS PARALELO_CODIGO,
>         THM.SIST_ESTUD_CODIGO,
>         THM.TCICLOACAD_CODIGO,
>         THM.TFINANCIA_CODIGO
>     FROM
>         ACA_TAB_DETAL_HORARIO_MODULOS THM
>         LEFT JOIN ACA_TAB_HORAS_MODULOS THD ON
>             THM.DIA_SEMANA_CODIGO = THD.DIA_SEMANA_CODIGO AND
>             THM.GRUPO_HORA_CODIGO = THD.GRUPO_HORA_CODIGO AND
>             THM.PLAN_HORAS_NUMERO = THD.PLAN_HORAS_NUMERO AND
>             THM.DEPEN_CODIGO = THD.DEPEN_CODIGO AND
>             THM.INST_CODIGO = THD.INST_CODIGO AND
>             THM.MODA_ESTUD_CODIGO = THD.MODA_ESTUD_CODIGO AND
>             THM.SIST_ESTUD_CODIGO = THD.SIST_ESTUD_CODIGO AND
>             THM.TCICLOACAD_CODIGO = THD.TCICLOACAD_CODIGO AND
>             THM.TFINANCIA_CODIGO = THD.TFINANCIA_CODIGO AND
>             THM.CICLO_ACAD_CODIGO = THD.CICLO_ACAD_CODIGO
>         LEFT JOIN ACA_TAB_PLANTILLAS_HORAS TPH ON
>             THD.PLAN_HORAS_NUMERO = TPH.NUMERO AND
>             THD.GRUPO_HORA_CODIGO = TPH.GRUPO_HORA_CODIGO
>         LEFT JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TC ON TC.CODIGO = THM.CICLO_ACAD_CODIGO
>         LEFT JOIN ACA_TAB_CALENDARIOS_MAT_PENSUM TCP ON
>             TCP.CICLO_ACAD_CODIGO = TC.CODIGO AND
>             TCP.MATERIA_CODIGO = THM.MATERIA_CODIGO AND
>             TCP.NIVEL_CODIGO = THM.NIVEL_CODIGO AND
>             TCP.PARALELO_CODIGO = THM.PARALELO_CODIGO
>     WHERE
>         TC.CODIGO = :P15_CICLO_ACADEMICO AND
>         THM.DOCENTE_CEDULA = :G_CEDULA_USUARIO
> )
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_HORARIO_DOCENTE
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      DBMS_METADATA.GET_DDL (supera 4000 caracteres)
> -- Usado por: src/modules/horario-docente
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_HORARIO_DOCENTE ("DOCENTE_CEDULA", "FECHA_INICIO", "FECHA_FIN", "INICIO_HORA", "FIN_HORA", "MATERIA", "PARALELO", "NIVEL", "ESTRUCTURA FÍSICA", "CARRERA", "DIA_SEMANA_CODIGO", "CICLO_ACAD_CODIGO", "DEPEN_CODIGO", "INST_CODIGO", "MATERIA_CODIGO", "MODA_ESTUD_CODIGO", "NIVEL_CODIGO", "PARALELO_CODIGO", "SIST_ESTUD_CODIGO", "TCICLOACAD_CODIGO", "TFINANCIA_CODIGO") AS
> SELECT
>     DOCENTE_CEDULA,
>     FECHA_INICIO,
>     FECHA_FIN,
>     CASE WHEN LENGTH(INICIO_HORA) = 4 THEN '0' || INICIO_HORA ELSE INICIO_HORA END AS INICIO_HORA,
>     CASE WHEN LENGTH(FIN_HORA) = 4 THEN '0' || FIN_HORA ELSE FIN_HORA END AS FIN_HORA,
>     MATERIA,
>     PARALELO,
>     NIVEL,
>     "ESTRUCTURA FÍSICA",
>     CARRERA,
>     DIA_SEMANA_CODIGO,
>     CICLO_ACAD_CODIGO,
>     DEPEN_CODIGO,
>     INST_CODIGO,
>     MATERIA_CODIGO,
>     MODA_ESTUD_CODIGO,
>     NIVEL_CODIGO,
>     PARALELO_CODIGO,
>     SIST_ESTUD_CODIGO,
>     TCICLOACAD_CODIGO,
>     TFINANCIA_CODIGO
> FROM (
>     SELECT DISTINCT
>         TH.DOCENTE_CEDULA,
>         NULL AS FECHA_INICIO,
>         NULL AS FECHA_FIN,
>         SUBSTR(TPH.INICIO_HORA, 1, LENGTH(TPH.INICIO_HORA) - 2) || 'H' || SUBSTR(TPH.INICIO_HORA, -1) AS INICIO_HORA,
>         SUBSTR(TPH.FIN_HORA, 1, LENGTH(TPH.FIN_HORA) - 2) || 'H' || SUBSTR(TPH.FIN_HORA, -1) AS FIN_HORA,
>         INS_PCK_GENERAL.FUN_OBTENER_ESTRUCTURA_FISICA(TH.ESTRUC_FIS_CODIGO) AS "ESTRUCTURA FÍSICA",
>         TH.DIA_SEMANA_CODIGO || ': ' || DECODE(TH.DIA_SEMANA_CODIGO,
>             '1', 'LUNES', '2', 'MARTES', '3', 'MIÉRCOLES', '4', 'JUEVES',
>             '5', 'VIERNES', '6', 'SÁBADO', '7', 'DOMINGO') AS DIA_SEMANA_CODIGO,
>         TH.PARALELO_CODIGO AS PARALELO,
>         TH.NIVEL_CODIGO AS NIVEL,
>         (SELECT TAB_MATERIAS.DESCRIPCION
>            FROM UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS
>           WHERE TAB_MATERIAS.CODIGO = TH.MATERIA_CODIGO
>             AND TAB_MATERIAS.NIVEL_CODIGO = TH.NIVEL_CODIGO) AS MATERIA,
>         FUN_OBTENER('ACA_TAB_DEPENDENCIAS', 'NOMBRE', TH.INST_CODIGO, TH.DEPEN_CODIGO, NULL) AS CARRERA,
>         TH.CICLO_ACAD_CODIGO,
>         TH.DEPEN_CODIGO,
>         TH.INST_CODIGO,
>         TH.MATERIA_CODIGO,
>         TH.MODA_ESTUD_CODIGO,
>         TH.NIVEL_CODIGO AS NIVEL_CODIGO,
>         TH.PARALELO_CODIGO AS PARALELO_CODIGO,
>         TH.SIST_ESTUD_CODIGO,
>         TH.TCICLOACAD_CODIGO,
>         TH.TFINANCIA_CODIGO
>     FROM UTNDB.ACA_TAB_DETALLES_HORARIOS TH
>         LEFT JOIN UTNDB.ACA_TAB_PLANTILLAS_HORAS TPH ON TH.PLAN_HORAS_NUMERO = TPH.NUMERO AND TH.GRUPO_HORA_CODIGO = TPH.GRUPO_HORA_CODIGO
>     UNION
>     SELECT
>         DOCENTE_CEDULA,
>         FECHA_INICIO,
>         FECHA_FIN,
>         INICIO_HORA,
>         FIN_HORA,
>         MATERIA,
>         PARALELO,
>         NIVEL,
>         ESTRUCTURA_FISICA,
>         CARRERA,
>         DIA_SEMANA,
>         CICLO_ACAD_CODIGO,
>         DEPEN_CODIGO,
>         INST_CODIGO,
>         MATERIA_CODIGO,
>         MODA_ESTUD_CODIGO,
>         NIVEL_CODIGO,
>         PARALELO_CODIGO,
>         SIST_ESTUD_CODIGO,
>         TCICLOACAD_CODIGO,
>         TFINANCIA_CODIGO
>     FROM (
>         SELECT DISTINCT
>             THM.DOCENTE_CEDULA,
>             TO_CHAR(TCP.FECHA_INICIO, 'DD/MM/YYYY') AS FECHA_INICIO,
>             TO_CHAR(TCP.FECHA_FIN, 'DD/MM/YYYY') AS FECHA_FIN,
>             SUBSTR(TPH.INICIO_HORA, 1, LENGTH(TPH.INICIO_HORA) - 2) || 'H' || SUBSTR(TPH.INICIO_HORA, -1) AS INICIO_HORA,
>             SUBSTR(TPH.FIN_HORA, 1, LENGTH(TPH.FIN_HORA) - 2) || 'H' || SUBSTR(TPH.FIN_HORA, -1) AS FIN_HORA,
>             (SELECT TAB_MATERIAS.DESCRIPCION
>                FROM UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS
>               WHERE TAB_MATERIAS.CODIGO = THM.MATERIA_CODIGO
>                 AND TAB_MATERIAS.NIVEL_CODIGO = THM.NIVEL_CODIGO) AS MATERIA,
>             THM.PARALELO_CODIGO AS PARALELO,
>             THM.NIVEL_CODIGO AS NIVEL,
>             INS_PCK_GENERAL.FUN_OBTENER_ESTRUCTURA_FISICA(THM.ESTRUC_FIS_CODIGO) AS ESTRUCTURA_FISICA,
>             FUN_OBTENER('ACA_TAB_DEPENDENCIAS', 'NOMBRE', THM.INST_CODIGO, THM.DEPEN_CODIGO, NULL) AS CARRERA,
>             THM.DIA_SEMANA_CODIGO || ': ' || DECODE(THM.DIA_SEMANA_CODIGO,
>                 '1', 'LUNES', '2', 'MARTES', '3', 'MIÉRCOLES', '4', 'JUEVES',
>                 '5', 'VIERNES', '6', 'SÁBADO', '7', 'DOMINGO') AS DIA_SEMANA,
>             THM.CICLO_ACAD_CODIGO,
>             THM.DEPEN_CODIGO,
>             THM.INST_CODIGO,
>             THM.MATERIA_CODIGO,
>             THM.MODA_ESTUD_CODIGO,
>             THM.NIVEL_CODIGO AS NIVEL_CODIGO,
>             THM.PARALELO_CODIGO AS PARALELO_CODIGO,
>             THM.SIST_ESTUD_CODIGO,
>             THM.TCICLOACAD_CODIGO,
>             THM.TFINANCIA_CODIGO
>         FROM UTNDB.ACA_TAB_DETAL_HORARIO_MODULOS THM
>             LEFT JOIN UTNDB.ACA_TAB_HORAS_MODULOS THD ON
>                 THM.DIA_SEMANA_CODIGO = THD.DIA_SEMANA_CODIGO AND
>                 THM.GRUPO_HORA_CODIGO = THD.GRUPO_HORA_CODIGO AND
>                 THM.PLAN_HORAS_NUMERO = THD.PLAN_HORAS_NUMERO AND
>                 THM.DEPEN_CODIGO = THD.DEPEN_CODIGO AND
>                 THM.INST_CODIGO = THD.INST_CODIGO AND
>                 THM.MODA_ESTUD_CODIGO = THD.MODA_ESTUD_CODIGO AND
>                 THM.SIST_ESTUD_CODIGO = THD.SIST_ESTUD_CODIGO AND
>                 THM.TCICLOACAD_CODIGO = THD.TCICLOACAD_CODIGO AND
>                 THM.TFINANCIA_CODIGO = THD.TFINANCIA_CODIGO AND
>                 THM.CICLO_ACAD_CODIGO = THD.CICLO_ACAD_CODIGO
>             LEFT JOIN UTNDB.ACA_TAB_PLANTILLAS_HORAS TPH ON
>                 THD.PLAN_HORAS_NUMERO = TPH.NUMERO AND
>                 THD.GRUPO_HORA_CODIGO = TPH.GRUPO_HORA_CODIGO
>             LEFT JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TC ON TC.CODIGO = THM.CICLO_ACAD_CODIGO
>             LEFT JOIN UTNDB.ACA_TAB_CALENDARIOS_MAT_PENSUM TCP ON
>                 TCP.CICLO_ACAD_CODIGO = TC.CODIGO AND
>                 TCP.MATERIA_CODIGO = THM.MATERIA_CODIGO AND
>                 TCP.NIVEL_CODIGO = THM.NIVEL_CODIGO AND
>                 TCP.PARALELO_CODIGO = THM.PARALELO_CODIGO
>     )
> )
> ;
> ```

> [!example]- `MVL_VIEW_CALENDARIO_GENERAL_DOCENTE` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `CALENDARIO_GENERAL_QUERY` y `CALENDARIO_GENERAL_LIMITES_QUERY` (`calendario-general`). V1. Una sola vista sirve a las dos consultas (detalle con `FECHA_FIN BETWEEN`, límites con `MIN/MAX`). `CALENDARIO_GENERAL_LIMITES_QUERY` no estaba en el plan maestro (omisión del audit original). Validada (MINUS 0 + límites idénticos).
>
> **Lo usa:** `src/modules/calendario-general/repository/queries/calendario-general.query.ts`
>
> **Antes** (`src/modules/calendario-general/repository/queries/calendario-general.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> // Actividades del calendario general del docente, acotadas a una ventana de
> // fechas. Antes la consulta traía TODO el histórico del docente en cada
> // llamada; el cliente ahora pide una ventana (hoy ± 6 meses por defecto) y la
> // amplía bajo demanda al navegar el calendario cerca de sus bordes.
> //
> // ⚠️ Los binds se pasan por POSICIÓN desde el repositorio y el driver los
> // asigna por ORDEN DE APARICIÓN de cada placeholder en el SQL. El orden es
> // 1) G_CEDULA_USUARIO, 2) FECHA_DESDE, 3) FECHA_HASTA
> // y cada uno aparece EXACTAMENTE UNA VEZ. Repetir uno corre a los siguientes y
> // provoca ORA-01008 en tiempo de ejecución (no lo detecta el build).
> export const CALENDARIO_GENERAL_QUERY = `
> SELECT DISTINCT
>            ACTIVIDAD.ID_ACTIVIDAD,
>            AULA.ID_CURSO,
>            ACTIVIDAD.NOMBRE_CORTO AS ACTIVIDAD_NOMBRE,
>            ACTIVIDAD.FECHA_FIN,
>            ACTIVIDAD.TIPO_ACTIVIDAD,
>            ACTIVIDAD.EVAL_AUTO AS ES_EVALUACION_AUTOMATICA,
>            ACTIVIDAD.CODIGO_PARCIAL,
>            MATERIA.DESCRIPCION AS MATERIA,
>            AULA.CODIGO_DEPENDENCIA,
>            AULA.CODIGO_MOD_EST,
>            AULA.CODIGO_CICLO_ACAD,
>            AULA.CODIGO_MATERIA,
>            AULA.CODIGO_NIVEL,
>            AULA.CODIGO_PARALELO,
>            CASE
>              WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 7 THEN 2
>              WHEN UTNDB.LMS_FUN_PENDIENTES_CALIFICAR(ACTIVIDAD.ID_ACTIVIDAD) = 0
>                   AND SYSDATE > ACTIVIDAD.FECHA_FIN THEN 1
>              ELSE 0
>            END AS ESTADO_COLOR,
>            'ACTIVIDAD' AS TIPO_REGISTRO
>       FROM LMS_TAB_ACTIVIDAD_ACADEMICA ACTIVIDAD
>       INNER JOIN LMS_TAB_AULAS_VIRTUALES AULA
>          ON AULA.ID_CURSO = ACTIVIDAD.ID_CURSO
>       INNER JOIN ACA_TAB_CICLOS_ACADEMICOS CICLO
>          ON (CICLO.CODIGO = AULA.CODIGO_CICLO_ACAD
>              AND (CICLO.ESTADO='A' OR CICLO.CODIGO='1021-1099'))
>       INNER JOIN ACA_TAB_MATERIAS MATERIA
>          ON (MATERIA.CODIGO = AULA.CODIGO_MATERIA
>              AND MATERIA.NIVEL_CODIGO = AULA.CODIGO_NIVEL)
>       INNER JOIN INS_TAB_USUARIOS USUARIO
>          ON (USUARIO.PERSONA_CEDULA = AULA.CEDULA_DOCENTE)
>      WHERE ACTIVIDAD.ESTADO = 'A'
>        AND AULA.CEDULA_DOCENTE = :G_CEDULA_USUARIO
>        AND ACTIVIDAD.FECHA_FIN BETWEEN :FECHA_DESDE AND :FECHA_HASTA
> `;
>
> // Rango completo real de actividades del docente, SIN ventana. El calendario
> // del cliente lo usa para sus límites navegables (firstDay/lastDay), mientras
> // el detalle se pide por ventana con la consulta de arriba.
> //
> // Repite los mismos JOIN y filtros que CALENDARIO_GENERAL_QUERY —salvo el de
> // fechas— para que los límites correspondan exactamente al universo de
> // actividades que esa consulta puede devolver. Si se cambia un filtro allá,
> // hay que cambiarlo aquí.
> //
> // Un solo bind: G_CEDULA_USUARIO.
> export const CALENDARIO_GENERAL_LIMITES_QUERY = `
> SELECT
>     MIN(ACTIVIDAD.FECHA_FIN) AS FECHA_MINIMA,
>     MAX(ACTIVIDAD.FECHA_FIN) AS FECHA_MAXIMA
>       FROM LMS_TAB_ACTIVIDAD_ACADEMICA ACTIVIDAD
>       INNER JOIN LMS_TAB_AULAS_VIRTUALES AULA
>          ON AULA.ID_CURSO = ACTIVIDAD.ID_CURSO
>       INNER JOIN ACA_TAB_CICLOS_ACADEMICOS CICLO
>          ON (CICLO.CODIGO = AULA.CODIGO_CICLO_ACAD
>              AND (CICLO.ESTADO='A' OR CICLO.CODIGO='1021-1099'))
>       INNER JOIN ACA_TAB_MATERIAS MATERIA
>          ON (MATERIA.CODIGO = AULA.CODIGO_MATERIA
>              AND MATERIA.NIVEL_CODIGO = AULA.CODIGO_NIVEL)
>       INNER JOIN INS_TAB_USUARIOS USUARIO
>          ON (USUARIO.PERSONA_CEDULA = AULA.CEDULA_DOCENTE)
>      WHERE ACTIVIDAD.ESTADO = 'A'
>        AND AULA.CEDULA_DOCENTE = :G_CEDULA_USUARIO
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_CALENDARIO_GENERAL_DOCENTE
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=INVALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/calendario-general
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_CALENDARIO_GENERAL_DOCENTE ("CEDULA_DOCENTE", "ID_ACTIVIDAD", "ID_CURSO", "ACTIVIDAD_NOMBRE", "FECHA_FIN", "TIPO_ACTIVIDAD", "ES_EVALUACION_AUTOMATICA", "CODIGO_PARCIAL", "MATERIA", "CODIGO_DEPENDENCIA", "CODIGO_MOD_EST", "CODIGO_CICLO_ACAD", "CODIGO_MATERIA", "CODIGO_NIVEL", "CODIGO_PARALELO", "ESTADO_COLOR", "TIPO_REGISTRO") AS
> SELECT DISTINCT
>        AULA.CEDULA_DOCENTE,
>        ACTIVIDAD.ID_ACTIVIDAD,
>        AULA.ID_CURSO,
>        ACTIVIDAD.NOMBRE_CORTO AS ACTIVIDAD_NOMBRE,
>        ACTIVIDAD.FECHA_FIN,
>        ACTIVIDAD.TIPO_ACTIVIDAD,
>        ACTIVIDAD.EVAL_AUTO AS ES_EVALUACION_AUTOMATICA,
>        ACTIVIDAD.CODIGO_PARCIAL,
>        MATERIA.DESCRIPCION AS MATERIA,
>        AULA.CODIGO_DEPENDENCIA,
>        AULA.CODIGO_MOD_EST,
>        AULA.CODIGO_CICLO_ACAD,
>        AULA.CODIGO_MATERIA,
>        AULA.CODIGO_NIVEL,
>        AULA.CODIGO_PARALELO,
>        CASE
>          WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 7 THEN 2
>          WHEN UTNDB.LMS_FUN_PENDIENTES_CALIFICAR(ACTIVIDAD.ID_ACTIVIDAD) = 0
>               AND SYSDATE > ACTIVIDAD.FECHA_FIN THEN 1
>          ELSE 0
>        END AS ESTADO_COLOR,
>        'ACTIVIDAD' AS TIPO_REGISTRO
>   FROM UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA ACTIVIDAD
>   INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES AULA
>      ON AULA.ID_CURSO = ACTIVIDAD.ID_CURSO
>   INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS CICLO
>      ON (CICLO.CODIGO = AULA.CODIGO_CICLO_ACAD
>          AND (CICLO.ESTADO = 'A' OR CICLO.CODIGO = '1021-1099'))
>   INNER JOIN UTNDB.ACA_TAB_MATERIAS MATERIA
>      ON (MATERIA.CODIGO = AULA.CODIGO_MATERIA
>          AND MATERIA.NIVEL_CODIGO = AULA.CODIGO_NIVEL)
>   INNER JOIN UTNDB.INS_TAB_USUARIOS USUARIO
>      ON (USUARIO.PERSONA_CEDULA = AULA.CEDULA_DOCENTE)
>  WHERE ACTIVIDAD.ESTADO = 'A'
> ;
> ```

> [!example]- `MVL_VIEW_MATERIA_ID_CURSO_DOCENTE` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `MATERIAL_ID_CURSO_QUERY`. V1. Validada (MINUS 0 en los 2 sentidos).
>
> **Lo usa:** `src/modules/calendario-general/repository/queries/materia-id-curso.query.ts`
>
> **Antes** (`src/modules/calendario-general/repository/queries/materia-id-curso.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const MATERIAL_ID_CURSO_QUERY = `
> SELECT DISTINCT
>        TAB_AULAS.ID_CURSO,
>        TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>        TAB_DISTRIBUTIVOS.INST_CODIGO,
>        TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>        TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>        TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>        TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO,
>        TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>        TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>        TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO AS CICLO_ACADEMICO_,
>        TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>        TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>        TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>        TAB_DISTRIBUTIVOS.ESTADO,
>        TAB_DISTRIBUTIVOS.ESTADO_EVAL_DOC,
>        TAB_DISTRIBUTIVOS.PUNTAJE_EVALUACION,
>        TAB_MATERIAS.DESCRIPCION AS MATERIA,
>        -- FECHA_INICIO_FIN (sin etiquetas HTML)
>        TAB_MAT_PENSUM.FECHA_INICIO || ' - ' || TAB_MAT_PENSUM.FECHA_FIN AS FECHA_INICIO_FIN,
>        -- NOMBRE_MATERIA (sin etiquetas)
>        TAB_MATERIAS.DESCRIPCION
>          || ' '
>          || (
>               SELECT DESCRIPCION
>                 FROM UTNDB.PEI_TAB_POA_PROYECTOS
>                WHERE CODIGO = TAB_DISTRIBUTIVOS.PARALELO_CODIGO
>             ) AS NOMBRE_MATERIA,
>        FUN_OBTENER('ACA_TAB_NIVELES', 'DESCRIPCION', TAB_DISTRIBUTIVOS.NIVEL_CODIGO, NULL, NULL) AS NIVEL,
>        FUN_OBTENER('ACA_TAB_PARALELOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.PARALELO_CODIGO, NULL, NULL) AS PARALELO,
>        FUN_OBTENER('ACA_TAB_TIPOS_CICLOS_ACADEMICO', 'DESCRIPCION', TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, NULL, NULL) AS TIPO_CICLO_ACADEMICO,
>        FUN_OBTENER('ACA_TAB_TIPOS_FINANCIAMIENTOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO, NULL, NULL) AS TIPO_FINANCIAMIENTO,
>        FUN_OBTENER('ACA_TAB_MODALIDADES_ESTUDIOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, NULL, NULL) AS MODALIDAD_ESTUDIO,
>        FUN_OBTENER('ACA_TAB_SISTEMAS_ESTUDIOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO, NULL, NULL) AS SISTEMA_ESTUDIO,
>        FUN_OBTENER('ACA_TAB_CICLOS_ACADEMICOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO, NULL, NULL) AS CICLO_ACADEMICO,
>        FUN_OBTENER('ACA_TAB_DEPENDENCIAS', 'NOMBRE', TAB_DISTRIBUTIVOS.INST_CODIGO, TAB_DISTRIBUTIVOS.DEPEN_CODIGO, NULL) AS NOMBRE_DEPENDENCIA,
>
>        -- Número de estudiantes
>        INS_PCK_GENERAL.FUN_NUM_ESTUDIANTES (
>          TAB_DISTRIBUTIVOS.DOCENTE_CEDULA, 
>          TAB_DISTRIBUTIVOS.DEPEN_CODIGO, 
>          TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO, 
>          TAB_DISTRIBUTIVOS.NIVEL_CODIGO, 
>          TAB_DISTRIBUTIVOS.MATERIA_CODIGO, 
>          TAB_DISTRIBUTIVOS.INST_CODIGO, 
>          TAB_DISTRIBUTIVOS.PARALELO_CODIGO, 
>          TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, 
>          TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO, 
>          TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, 
>          TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO
>        ) AS NUM_ESTUDIANTES,
>
>        -- Porcentaje Planificado
>        CASE 
>           WHEN (TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO NOT IN ('03')
>                 AND TAB_DISTRIBUTIVOS.NIVEL_CODIGO NOT IN ('NI')
>                 AND TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO NOT IN ('0922-0323'))    
>           THEN ROUND(ACA_PCK_ACADEMICO.FUN_PORCENTAJE_AVANCE_PLANIF(
>                TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>                TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>                TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>                TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>                TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>                TAB_DISTRIBUTIVOS.INST_CODIGO,
>                TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>                TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>                TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>                TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>                TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO), 2)
>           ELSE ROUND(ACA_PCK_ACADEMICO.FUN_PORCENTAJE_AVAN_PLANIF_MOD(
>                TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>                TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>                TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>                TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>                TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>                TAB_DISTRIBUTIVOS.INST_CODIGO,
>                TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>                TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>                TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>                TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>                TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO), 2)
>        END AS PORCENTAJE_PLANIFICADO,
>
>        -- Porcentaje Ejecutado
>        ROUND(UTNDB.LMS_FUN_PORCENTAJE_EJECUTADO (
>          TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>          TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>          TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>          TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>          TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>          TAB_DISTRIBUTIVOS.INST_CODIGO,
>          TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>          TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>          TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>          TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>          TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO), 2
>        ) AS PORCENTAJE_EJECUTADO,
>
>        -- Aula Virtual
>        CASE
>          WHEN TAB_AULAS.ID_CURSO IS NULL
>               OR TAB_AULAS.ID_CURSO = '' THEN
>            CASE
>               WHEN UTNDB.LMS_FUN_HABILITA_CREAR_AULA(
>                      TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>                      TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>                      TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>                      TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>                      TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>                      TAB_DISTRIBUTIVOS.INST_CODIGO,
>                      TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>                      TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>                      TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>                      TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>                      TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO
>                    ) > 0
>               THEN 'CREAR'
>               ELSE 'NO DISPONIBLE'
>            END
>          ELSE
>            CASE
>               WHEN UTNDB.LMS_FUN_HABILITA_CREAR_AULA(
>                      TAB_DIST
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_MATERIA_ID_CURSO_DOCENTE
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      DBMS_METADATA.GET_DDL (supera 4000 caracteres)
> -- Usado por: src/modules/calendario-general
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_MATERIA_ID_CURSO_DOCENTE ("ID_CURSO", "DOCENTE_CEDULA", "INST_CODIGO", "MODA_ESTUD_CODIGO", "SIST_ESTUD_CODIGO", "TCICLOACAD_CODIGO", "TFINANCIA_CODIGO", "DEPEN_CODIGO", "CICLO_ACAD_CODIGO", "CICLO_ACADEMICO_", "MATERIA_CODIGO", "NIVEL_CODIGO", "PARALELO_CODIGO", "ESTADO", "ESTADO_EVAL_DOC", "PUNTAJE_EVALUACION", "MATERIA", "FECHA_INICIO_FIN", "NOMBRE_MATERIA", "NIVEL", "PARALELO", "TIPO_CICLO_ACADEMICO", "TIPO_FINANCIAMIENTO", "MODALIDAD_ESTUDIO", "SISTEMA_ESTUDIO", "CICLO_ACADEMICO", "NOMBRE_DEPENDENCIA", "NUM_ESTUDIANTES", "PORCENTAJE_PLANIFICADO", "PORCENTAJE_EJECUTADO", "AULA_VIRTUAL") AS
> SELECT DISTINCT
>        TAB_AULAS.ID_CURSO,
>        TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>        TAB_DISTRIBUTIVOS.INST_CODIGO,
>        TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>        TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>        TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>        TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO,
>        TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>        TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>        TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO AS CICLO_ACADEMICO_,
>        TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>        TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>        TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>        TAB_DISTRIBUTIVOS.ESTADO,
>        TAB_DISTRIBUTIVOS.ESTADO_EVAL_DOC,
>        TAB_DISTRIBUTIVOS.PUNTAJE_EVALUACION,
>        TAB_MATERIAS.DESCRIPCION AS MATERIA,
>        TAB_MAT_PENSUM.FECHA_INICIO || ' - ' || TAB_MAT_PENSUM.FECHA_FIN AS FECHA_INICIO_FIN,
>        TAB_MATERIAS.DESCRIPCION
>          || ' '
>          || (
>               SELECT DESCRIPCION
>                 FROM UTNDB.PEI_TAB_POA_PROYECTOS
>                WHERE CODIGO = TAB_DISTRIBUTIVOS.PARALELO_CODIGO
>             ) AS NOMBRE_MATERIA,
>        FUN_OBTENER('ACA_TAB_NIVELES', 'DESCRIPCION', TAB_DISTRIBUTIVOS.NIVEL_CODIGO, NULL, NULL) AS NIVEL,
>        FUN_OBTENER('ACA_TAB_PARALELOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.PARALELO_CODIGO, NULL, NULL) AS PARALELO,
>        FUN_OBTENER('ACA_TAB_TIPOS_CICLOS_ACADEMICO', 'DESCRIPCION', TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, NULL, NULL) AS TIPO_CICLO_ACADEMICO,
>        FUN_OBTENER('ACA_TAB_TIPOS_FINANCIAMIENTOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO, NULL, NULL) AS TIPO_FINANCIAMIENTO,
>        FUN_OBTENER('ACA_TAB_MODALIDADES_ESTUDIOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, NULL, NULL) AS MODALIDAD_ESTUDIO,
>        FUN_OBTENER('ACA_TAB_SISTEMAS_ESTUDIOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO, NULL, NULL) AS SISTEMA_ESTUDIO,
>        FUN_OBTENER('ACA_TAB_CICLOS_ACADEMICOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO, NULL, NULL) AS CICLO_ACADEMICO,
>        FUN_OBTENER('ACA_TAB_DEPENDENCIAS', 'NOMBRE', TAB_DISTRIBUTIVOS.INST_CODIGO, TAB_DISTRIBUTIVOS.DEPEN_CODIGO, NULL) AS NOMBRE_DEPENDENCIA,
>        INS_PCK_GENERAL.FUN_NUM_ESTUDIANTES (
>          TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>          TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>          TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>          TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>          TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>          TAB_DISTRIBUTIVOS.INST_CODIGO,
>          TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>          TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>          TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>          TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>          TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO
>        ) AS NUM_ESTUDIANTES,
>        CASE
>           WHEN (TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO NOT IN ('03')
>                 AND TAB_DISTRIBUTIVOS.NIVEL_CODIGO NOT IN ('NI')
>                 AND TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO NOT IN ('0922-0323'))
>           THEN ROUND(ACA_PCK_ACADEMICO.FUN_PORCENTAJE_AVANCE_PLANIF(
>                TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>                TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>                TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>                TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>                TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>                TAB_DISTRIBUTIVOS.INST_CODIGO,
>                TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>                TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>                TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>                TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>                TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO), 2)
>           ELSE ROUND(ACA_PCK_ACADEMICO.FUN_PORCENTAJE_AVAN_PLANIF_MOD(
>                TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>                TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>                TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>                TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>                TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>                TAB_DISTRIBUTIVOS.INST_CODIGO,
>                TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>                TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>                TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>                TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>                TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO), 2)
>        END AS PORCENTAJE_PLANIFICADO,
>        ROUND(UTNDB.LMS_FUN_PORCENTAJE_EJECUTADO (
>          TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>          TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>          TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>          TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>          TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>          TAB_DISTRIBUTIVOS.INST_CODIGO,
>          TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>          TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>          TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>          TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>          TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO), 2
>        ) AS PORCENTAJE_EJECUTADO,
>        CASE
>          WHEN TAB_AULAS.ID_CURSO IS NULL
>               OR TAB_AULAS.ID_CURSO = '' THEN
>            CASE
>               WHEN UTNDB.LMS_FUN_HABILITA_CREAR_AULA(
>                      TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>                      TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>                      TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>                      TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>                      TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>                      TAB_DISTRIBUTIVOS.INST_CODIGO,
>                      TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>                      TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>                      TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>                      TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>                      TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO
>                    ) > 0
>               THEN 'CREAR'
>               ELSE 'NO DISPONIBLE'
>            END
>          ELSE
>            CASE
>               WHEN UTNDB.LMS_FUN_HABILITA_CREAR_AULA(
>                      TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>                      TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>                      TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>                      TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>                      TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>                      TAB_DISTRIBUTIVOS.INST_CODIGO,
>                      TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>                      TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>                      TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>                      TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>                      TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO
>                    ) > 0
>                    OR (SELECT CA.ESTADO
>                          FROM UTNDB.ACA_TAB_CICLOS_ACADEMICOS CA
>                         WHERE CA.CODIGO = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO
>                       ) <> 'A'
>               THEN 'ACTIVO'
>               ELSE 'NO DISPONIBLE'
>            END
>        END AS AULA_VIRTUAL
>   FROM UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS
>   INNER JOIN UTNDB.ACA_TAB_DISTRIBUTIVOS TAB_DISTRIBUTIVOS
>      ON  TAB_MATERIAS.NIVEL_CODIGO  = TAB_DISTRIBUTIVOS.NIVEL_CODIGO
>      AND TAB_MATERIAS.CODIGO        = TAB_DISTRIBUTIVOS.MATERIA_CODIGO
>      AND TAB_MATERIAS.TMATERIA_CODIGO != '04'
>   INNER JOIN UTNDB.ACA_TAB_MATERIAS_PENSUMS TAB_MATERIAS_PENSUM
>      ON  TAB_MATERIAS_PENSUM.CICLO_ACAD_CODIGO = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO
>      AND TAB_MATERIAS_PENSUM.MODA_ESTUD_CODIGO = TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO
>      AND TAB_MATERIAS_PENSUM.DEPEN_CODIGO      = TAB_DISTRIBUTIVOS.DEPEN_CODIGO
>      AND TAB_MATERIAS_PENSUM.MATERIA_CODIGO    = TAB_DISTRIBUTIVOS.MATERIA_CODIGO
>      AND TAB_MATERIAS_PENSUM.NIVEL_CODIGO      = TAB_DISTRIBUTIVOS.NIVEL_CODIGO
>      AND TAB_MATERIAS_PENSUM.ESTADO            = 'A'
>   LEFT JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES TAB_AULAS
>      ON  TAB_AULAS.CODIGO_INSTITUCION  = TAB_DISTRIBUTIVOS.INST_CODIGO
>      AND TAB_AULAS.CODIGO_DEPENDENCIA  = TAB_DISTRIBUTIVOS.DEPEN_CODIGO
>      AND TAB_AULAS.CODIGO_NIVEL        = TAB_DISTRIBUTIVOS.NIVEL_CODIGO
>      AND TAB_AULAS.CODIGO_MATERIA      = TAB_DISTRIBUTIVOS.MATERIA_CODIGO
>      AND TAB_AULAS.CODIGO_MOD_EST      = TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO
>      AND TAB_AULAS.CODIGO_SIS_EST      = TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO
>      AND TAB_AULAS.CODIGO_CICLO_ACAD   = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO
>      AND TAB_AULAS.CODIGO_PARALELO     = TAB_DISTRIBUTIVOS.PARALELO_CODIGO
>      AND TAB_AULAS.CODIGO_TIPO_FINANC  = TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO
>      AND TAB_AULAS.CEDULA_DOCENTE      = TAB_DISTRIBUTIVOS.DOCENTE_CEDULA
>      AND TAB_AULAS.ESTADO             = 'A'
>   LEFT JOIN UTNDB.ACA_TAB_CALENDARIOS_MAT_PENSUM TAB_MAT_PENSUM
>      ON  TAB_MAT_PENSUM.CICLO_ACAD_CODIGO = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO
>      AND TAB_MAT_PENSUM.MODA_ESTUD_CODIGO = TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO
>      AND TAB_MAT_PENSUM.DEPEN_CODIGO      = TAB_DISTRIBUTIVOS.DEPEN_CODIGO
>      AND TAB_MAT_PENSUM.MATERIA_CODIGO    = TAB_DISTRIBUTIVOS.MATERIA_CODIGO
>      AND TAB_MAT_PENSUM.NIVEL_CODIGO      = TAB_DISTRIBUTIVOS.NIVEL_CODIGO
>      AND TAB_MAT_PENSUM.PARALELO_CODIGO   = TAB_DISTRIBUTIVOS.PARALELO_CODIGO
>      AND TAB_MAT_PENSUM.ESTADO           = 'A'
>  WHERE TAB_DISTRIBUTIVOS.INST_CODIGO = '001'
>    AND TAB_DISTRIBUTIVOS.MATERIA_CODIGO NOT IN (
>        SELECT MA.CODIGO
>          FROM UTNDB.ACA_TAB_MATERIAS MA
>         WHERE MA.TMATERIA_CODIGO IN ('07', '04')
>    )
>    AND TAB_DISTRIBUTIVOS.NIVEL_CODIGO != '00'
>    AND TAB_MATERIAS.TMATERIA_CODIGO != '04'
>    AND TAB_MATERIAS.DEPEN_CODIGO NOT IN ('00263', '00194')
> ;
> ```

> [!example]- `MVL_VIEW_ACTIVIDAD_INSTRUC_DOCENTE` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** nueva, para `get_instrucciones_actividad.query.ts` (`foro_online`). Pasthrough simple de `LMS_TAB_ACTIVIDAD_ACADEMICA` (`ID_ACTIVIDAD, NOMBRE_CORTO, FECHA_INICIO, FECHA_FIN, DESCRIPCION`), sin filtro embebido. **No reutilizar `MVL_VIEW_FORO_INSTRUC_ACT`** (la de estudiante): hace `JOIN` a `LMS_TAB_ACTIVIDADES_ALUMNOS` y fuerza `ESTADO='A'`, produciría filas duplicadas por estudiante inscrito — el docente solo necesita 1 fila por `ID_ACTIVIDAD`. Validada (MINUS 0, `DESCRIPCION` es CLOB, envuelta con `DBMS_LOB.SUBSTR`).
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/get_instrucciones_actividad.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/get_instrucciones_actividad.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const GET_INSTRUCCIONES_ACTIVIDAD_QUERY = `
>     SELECT
>         ACT.ID_ACTIVIDAD    AS "ID_ACTIVIDAD",
>         ACT.NOMBRE_CORTO    AS "NOMBRE",
>         ACT.FECHA_INICIO    AS "FECHA_INICIO",
>         ACT.FECHA_FIN       AS "FECHA_FIN",
>         ACT.DESCRIPCION     AS "DESCRIPCION"
>     FROM
>         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA ACT
>     WHERE
>         ACT.ID_ACTIVIDAD = :ID_ACTIVIDAD
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_ACTIVIDAD_INSTRUC_DOCENTE
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/foro_online
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_ACTIVIDAD_INSTRUC_DOCENTE ("ID_ACTIVIDAD", "NOMBRE_CORTO", "FECHA_INICIO", "FECHA_FIN", "DESCRIPCION") AS
> SELECT
>     ID_ACTIVIDAD,
>     NOMBRE_CORTO,
>     FECHA_INICIO,
>     FECHA_FIN,
>     DESCRIPCION
> FROM UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA
> ;
> ```

> [!example]- `MVL_VIEW_CICLOS_REGISTRO_ACADEMICO` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `CICLO_ACADEMICO_REGISTRO_ACADEMICO_QUERY`. V1. Validada (MINUS 0/0), curl real.
>
> **Lo usa:** `src/modules/registro-academico/repository/queries/ciclo-academico-registro-academico.query.ts`
>
> **Antes** (`src/modules/registro-academico/repository/queries/ciclo-academico-registro-academico.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const CICLO_ACADEMICO_REGISTRO_ACADEMICO_QUERY = `
> SELECT DESCRIPCION,CODIGO FROM(
>     SELECT DISTINCT DESCRIPCION,CODIGO,FECHA_INICIO,FECHA_FIN FROM(
> SELECT DISTINCT CIC.DESCRIPCION,CIC.CODIGO,CIC.FECHA_INICIO,CIC.FECHA_FIN
>     FROM ACA_TAB_CICLOS_ACADEMICOS CIC
>     INNER JOIN UTNDB.ACA_TAB_DISTRIBUTIVOS DIS ON(DIS.CICLO_ACAD_CODIGO = CIC.CODIGO)
>     INNER JOIN UTNDB.ACA_TAB_MATERIAS MAT ON(MAT.CODIGO=DIS.MATERIA_CODIGO AND MAT.NIVEL_CODIGO=DIS.NIVEL_CODIGO
>         AND MAT.TMATERIA_CODIGO NOT IN('04','07') AND MAT.NIVEL_CODIGO NOT IN('00','AD')  AND MAT.DEPEN_CODIGO NOT IN ('00263')
>         AND DIS.INST_CODIGO = '001')
>     WHERE DIS.DOCENTE_CEDULA = :G_CEDULA_USUARIO
> UNION
> SELECT DISTINCT CIC.DESCRIPCION,CIC.CODIGO,CIC.FECHA_INICIO,CIC.FECHA_FIN
>     FROM ACA_TAB_CICLOS_ACADEMICOS CIC
>     INNER JOIN UTNDB.ACA_TAB_DISTRIBUTIVOS DIS ON(DIS.CICLO_ACAD_CODIGO = CIC.CODIGO)
>     INNER JOIN UTNDB.ACA_TAB_MATERIAS MAT ON(MAT.CODIGO=DIS.MATERIA_CODIGO AND MAT.NIVEL_CODIGO=DIS.NIVEL_CODIGO
>         AND MAT.TMATERIA_CODIGO NOT IN('04','07') AND MAT.NIVEL_CODIGO  IN('AD')  AND MAT.DEPEN_CODIGO NOT IN ('00263')
>         AND DIS.INST_CODIGO = '001')
>     WHERE DIS.DOCENTE_CEDULA = :G_CEDULA_USUARIO AND CIC.ESTADO='A'
> )ORDER BY FECHA_INICIO DESC, DESCRIPCION )
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_CICLOS_REGISTRO_ACADEMICO
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/registro-academico
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_CICLOS_REGISTRO_ACADEMICO ("DESCRIPCION", "CODIGO", "FECHA_INICIO", "FECHA_FIN", "DOCENTE_CEDULA") AS
> SELECT DISTINCT CIC.DESCRIPCION, CIC.CODIGO, CIC.FECHA_INICIO, CIC.FECHA_FIN, DIS.DOCENTE_CEDULA
> FROM UTNDB.ACA_TAB_CICLOS_ACADEMICOS CIC
> INNER JOIN UTNDB.ACA_TAB_DISTRIBUTIVOS DIS ON (DIS.CICLO_ACAD_CODIGO = CIC.CODIGO)
> INNER JOIN UTNDB.ACA_TAB_MATERIAS MAT ON (MAT.CODIGO = DIS.MATERIA_CODIGO AND MAT.NIVEL_CODIGO = DIS.NIVEL_CODIGO
>     AND MAT.TMATERIA_CODIGO NOT IN ('04','07') AND MAT.NIVEL_CODIGO NOT IN ('00','AD') AND MAT.DEPEN_CODIGO NOT IN ('00263')
>     AND DIS.INST_CODIGO = '001')
> UNION
> SELECT DISTINCT CIC.DESCRIPCION, CIC.CODIGO, CIC.FECHA_INICIO, CIC.FECHA_FIN, DIS.DOCENTE_CEDULA
> FROM UTNDB.ACA_TAB_CICLOS_ACADEMICOS CIC
> INNER JOIN UTNDB.ACA_TAB_DISTRIBUTIVOS DIS ON (DIS.CICLO_ACAD_CODIGO = CIC.CODIGO)
> INNER JOIN UTNDB.ACA_TAB_MATERIAS MAT ON (MAT.CODIGO = DIS.MATERIA_CODIGO AND MAT.NIVEL_CODIGO = DIS.NIVEL_CODIGO
>     AND MAT.TMATERIA_CODIGO NOT IN ('04','07') AND MAT.NIVEL_CODIGO IN ('AD') AND MAT.DEPEN_CODIGO NOT IN ('00263')
>     AND DIS.INST_CODIGO = '001')
> WHERE CIC.ESTADO = 'A'
> ;
> ```

> [!example]- `MVL_VIEW_DETALLE_MATERIA_NOTAS_DOCENTE` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
>
> **Lo usa:** `src/modules/registro-academico/repository/queries/detalle-materia-notas.query.ts`
>
> **Antes** (`src/modules/registro-academico/repository/queries/detalle-materia-notas.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const DETALLE_MATERIA_NOTAS_QUERY = `
> SELECT DISTINCT
>          TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>          INS_PCK_GENERAL.FUN_NOMBRES_PERSONA(TAB_DISTRIBUTIVOS.DOCENTE_CEDULA) AS "NOMBRES",
>          FUN_OBTENER('ACA_TAB_CICLOS_ACADEMICOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO, NULL, NULL) AS "CICLO_ACADEMICO",
>          FUN_OBTENER('ACA_TAB_MATERIAS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.NIVEL_CODIGO, TAB_DISTRIBUTIVOS.MATERIA_CODIGO, NULL) AS "NOMBRE_MATERIA",
>          FUN_OBTENER('ACA_TAB_TIPOS_CICLOS_ACADEMICO', 'DESCRIPCION', TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, NULL, NULL) AS "TIPO_CICLO_ACADEMICO",
>          FUN_OBTENER('ACA_TAB_DEPENDENCIAS', 'NOMBRE', TAB_DISTRIBUTIVOS.INST_CODIGO, TAB_DISTRIBUTIVOS.DEPEN_CODIGO, NULL) AS "NOMBRE_DEPENDENCIA",
>          FUN_OBTENER('ACA_TAB_MODALIDADES_ESTUDIOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, NULL, NULL) AS "MODALIDAD_ESTUDIO",
>          FUN_OBTENER('ACA_TAB_NIVELES', 'DESCRIPCION', TAB_DISTRIBUTIVOS.NIVEL_CODIGO, NULL, NULL) AS "NIVEL",
>          FUN_OBTENER('ACA_TAB_SISTEMAS_ESTUDIOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO, NULL, NULL) AS "SISTEMA_ESTUDIO",
>          FUN_OBTENER('ACA_TAB_PARALELOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.PARALELO_CODIGO, NULL, NULL) AS "PARALELO",
>          FUN_OBTENER('ACA_TAB_TIPOS_FINANCIAMIENTOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO, NULL, NULL) AS "TIPO_FINANCIAMIENTO"
>     FROM ACA_TAB_DISTRIBUTIVOS TAB_DISTRIBUTIVOS
>          INNER JOIN RHU_TAB_PERSONAS TAB_PERSONAS
>             ON TAB_PERSONAS.CEDULA = TAB_DISTRIBUTIVOS.DOCENTE_CEDULA
>    WHERE TAB_DISTRIBUTIVOS.DOCENTE_CEDULA =
>             (SELECT PERSONA_CEDULA
>                FROM INS_TAB_USUARIOS
>               WHERE CUENTA = :G_USUARIO_SOPORTE)
>          AND TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO = :P9_CICLO_ACAD_CODIGO
>          AND TAB_DISTRIBUTIVOS.MATERIA_CODIGO = :P9_MATERIA_CODIGO
>          AND TAB_DISTRIBUTIVOS.PARALELO_CODIGO = :P9_PARALELO_CODIGO
>          AND TAB_DISTRIBUTIVOS.DOCENTE_CEDULA = :P9_DOCENTE_CEDULA
>          AND TAB_DISTRIBUTIVOS.INST_CODIGO = :P9_INST_CODIGO
>          AND TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO = :P9_MODA_ESTUD_CODIGO
>          AND TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO = :P9_SIST_ESTUD_CODIGO
>          AND TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO = :P9_TCICLOACAD_CODIGO
>          AND TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO = :P9_TFINANCIA_CODIGO
>          AND TAB_DISTRIBUTIVOS.DEPEN_CODIGO = :P9_DEPEN_CODIGO
>          AND TAB_DISTRIBUTIVOS.NIVEL_CODIGO = :P9_NIVEL_CODIGO
> ORDER BY "NOMBRE_DEPENDENCIA", "NOMBRE_MATERIA", "PARALELO"
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_DETALLE_MATERIA_NOTAS_DOCENTE
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/registro-academico
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_DETALLE_MATERIA_NOTAS_DOCENTE ("CUENTA", "DOCENTE_CEDULA", "CICLO_ACAD_CODIGO", "MATERIA_CODIGO", "PARALELO_CODIGO", "INST_CODIGO", "MODA_ESTUD_CODIGO", "SIST_ESTUD_CODIGO", "TCICLOACAD_CODIGO", "TFINANCIA_CODIGO", "DEPEN_CODIGO", "NIVEL_CODIGO", "NOMBRES", "CICLO_ACADEMICO", "NOMBRE_MATERIA", "TIPO_CICLO_ACADEMICO", "NOMBRE_DEPENDENCIA", "MODALIDAD_ESTUDIO", "NIVEL", "SISTEMA_ESTUDIO", "PARALELO", "TIPO_FINANCIAMIENTO") AS
> SELECT DISTINCT
>     US.CUENTA,
>     TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>     TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>     TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>     TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>     TAB_DISTRIBUTIVOS.INST_CODIGO,
>     TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>     TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>     TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>     TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO,
>     TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>     TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>     UTNDB.INS_PCK_GENERAL.FUN_NOMBRES_PERSONA(TAB_DISTRIBUTIVOS.DOCENTE_CEDULA) AS "NOMBRES",
>     UTNDB.FUN_OBTENER('ACA_TAB_CICLOS_ACADEMICOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO, NULL, NULL) AS "CICLO_ACADEMICO",
>     UTNDB.FUN_OBTENER('ACA_TAB_MATERIAS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.NIVEL_CODIGO, TAB_DISTRIBUTIVOS.MATERIA_CODIGO, NULL) AS "NOMBRE_MATERIA",
>     UTNDB.FUN_OBTENER('ACA_TAB_TIPOS_CICLOS_ACADEMICO', 'DESCRIPCION', TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, NULL, NULL) AS "TIPO_CICLO_ACADEMICO",
>     UTNDB.FUN_OBTENER('ACA_TAB_DEPENDENCIAS', 'NOMBRE', TAB_DISTRIBUTIVOS.INST_CODIGO, TAB_DISTRIBUTIVOS.DEPEN_CODIGO, NULL) AS "NOMBRE_DEPENDENCIA",
>     UTNDB.FUN_OBTENER('ACA_TAB_MODALIDADES_ESTUDIOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, NULL, NULL) AS "MODALIDAD_ESTUDIO",
>     UTNDB.FUN_OBTENER('ACA_TAB_NIVELES', 'DESCRIPCION', TAB_DISTRIBUTIVOS.NIVEL_CODIGO, NULL, NULL) AS "NIVEL",
>     UTNDB.FUN_OBTENER('ACA_TAB_SISTEMAS_ESTUDIOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO, NULL, NULL) AS "SISTEMA_ESTUDIO",
>     UTNDB.FUN_OBTENER('ACA_TAB_PARALELOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.PARALELO_CODIGO, NULL, NULL) AS "PARALELO",
>     UTNDB.FUN_OBTENER('ACA_TAB_TIPOS_FINANCIAMIENTOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO, NULL, NULL) AS "TIPO_FINANCIAMIENTO"
> FROM UTNDB.ACA_TAB_DISTRIBUTIVOS TAB_DISTRIBUTIVOS
> INNER JOIN UTNDB.RHU_TAB_PERSONAS TAB_PERSONAS
>     ON TAB_PERSONAS.CEDULA = TAB_DISTRIBUTIVOS.DOCENTE_CEDULA
> INNER JOIN UTNDB.INS_TAB_USUARIOS US
>     ON US.PERSONA_CEDULA = TAB_DISTRIBUTIVOS.DOCENTE_CEDULA
> ;
> ```

> [!example]- `MVL_VIEW_ESTUDIANTES_MATERIA_DOCENTE` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `ESTUDIANTES_POR_MATERIA_QUERY`. V1. Validada (MINUS 0/0), curl real.
>
> **Lo usa:** `src/modules/registro-academico/repository/queries/estudiantes-materia.query.ts`
>
> **Antes** (`src/modules/registro-academico/repository/queries/estudiantes-materia.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const ESTUDIANTES_POR_MATERIA_QUERY = `
> SELECT 
>     (P.PRIMER_APELLIDO || ' ' || P.SEGUNDO_APELLIDO) AS APELLIDOS,
>     (P.PRIMER_NOMBRE   || ' ' || P.SEGUNDO_NOMBRE)  AS NOMBRES,
>     P.EMAIL,
>     CI.CORREO_INSTITUCIONAL,
>     P.CELULAR,
>     TDM.NUMERO_MATRICULA,
>     TDM.ESTUDIANTE_CEDULA AS "Estudiante Cédula",
>     (SELECT NOMBRE FROM ACA_TAB_DEPENDENCIAS WHERE CODIGO = M.DEPEN_CODIGO) AS "CARRERA",
>     (CASE WHEN IA.CEDULA_INTEGRANTE IS NOT NULL THEN 'ACTIVO' ELSE 'NO INGRESA' END) AS AULA_VIRTUAL
> FROM 
>     UTNDB.ACA_TAB_DETALLE_MATRICULAS TDM
>     INNER JOIN UTNDB.RHU_TAB_PERSONAS P ON TDM.ESTUDIANTE_CEDULA = P.CEDULA
>     INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS CA ON CA.CODIGO = TDM.CICLO_ACAD_CODIGO
>     INNER JOIN UTNDB.ACA_TAB_MATRICULAS M ON TDM.ESTUDIANTE_CEDULA = M.ESTUDIANTE_CEDULA AND TDM.MATRICULA_CODIGO = M.CODIGO
>     LEFT JOIN UTNDB.RHU_TAB_CORREO_INSTITUCIONAL CI ON CI.CEDULA_PERSONA = TDM.ESTUDIANTE_CEDULA
>     LEFT JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES AV ON AV.CODIGO_MATERIA = TDM.MATERIA_CODIGO AND AV.CODIGO_CICLO_ACAD = CA.CODIGO AND AV.CODIGO_PARALELO = TDM.PARALELO_CODIGO
>     LEFT JOIN UTNDB.LMS_TAB_INTEGRANTES IA ON IA.ID_CURSO = AV.ID_CURSO AND IA.CEDULA_INTEGRANTE = TDM.ESTUDIANTE_CEDULA
> WHERE 
>     TDM.DOCENTE_CEDULA = :DOCENTE_CEDULA
>     AND TDM.ANULACION != 'S'
>     AND TDM.DEPEN_CODIGO = :DEPEN_CODIGO
>     AND TDM.MATERIA_CODIGO = :MATERIA_CODIGO
>     AND TDM.NIVEL_CODIGO = :NIVEL_CODIGO
>     AND CA.CODIGO = :CODIGO_CICLO
>     AND TDM.MODA_ESTUD_CODIGO = :MODALIDAD_CODIGO
>     AND M.ESTADO IN ('M', 'C', 'R')
>     AND TDM.ANULACION = 'N'
>     AND TDM.PARALELO_CODIGO = :PARALELO_CODIGO
>     ORDER BY APELLIDOS ASC
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_ESTUDIANTES_MATERIA_DOCENTE
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/registro-academico
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_ESTUDIANTES_MATERIA_DOCENTE ("APELLIDOS", "NOMBRES", "EMAIL", "CORREO_INSTITUCIONAL", "CELULAR", "NUMERO_MATRICULA", "Estudiante Cédula", "CARRERA", "AULA_VIRTUAL", "DOCENTE_CEDULA", "DEPEN_CODIGO", "MATERIA_CODIGO", "NIVEL_CODIGO", "CODIGO_CICLO", "MODA_ESTUD_CODIGO", "PARALELO_CODIGO") AS
> SELECT
>     (P.PRIMER_APELLIDO || ' ' || P.SEGUNDO_APELLIDO) AS APELLIDOS,
>     (P.PRIMER_NOMBRE   || ' ' || P.SEGUNDO_NOMBRE)  AS NOMBRES,
>     P.EMAIL,
>     CI.CORREO_INSTITUCIONAL,
>     P.CELULAR,
>     TDM.NUMERO_MATRICULA,
>     TDM.ESTUDIANTE_CEDULA AS "Estudiante Cédula",
>     (SELECT NOMBRE FROM UTNDB.ACA_TAB_DEPENDENCIAS WHERE CODIGO = M.DEPEN_CODIGO) AS "CARRERA",
>     (CASE WHEN IA.CEDULA_INTEGRANTE IS NOT NULL THEN 'ACTIVO' ELSE 'NO INGRESA' END) AS AULA_VIRTUAL,
>     TDM.DOCENTE_CEDULA,
>     TDM.DEPEN_CODIGO,
>     TDM.MATERIA_CODIGO,
>     TDM.NIVEL_CODIGO,
>     CA.CODIGO AS CODIGO_CICLO,
>     TDM.MODA_ESTUD_CODIGO,
>     TDM.PARALELO_CODIGO
> FROM
>     UTNDB.ACA_TAB_DETALLE_MATRICULAS TDM
>     INNER JOIN UTNDB.RHU_TAB_PERSONAS P ON TDM.ESTUDIANTE_CEDULA = P.CEDULA
>     INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS CA ON CA.CODIGO = TDM.CICLO_ACAD_CODIGO
>     INNER JOIN UTNDB.ACA_TAB_MATRICULAS M ON TDM.ESTUDIANTE_CEDULA = M.ESTUDIANTE_CEDULA AND TDM.MATRICULA_CODIGO = M.CODIGO
>     LEFT JOIN UTNDB.RHU_TAB_CORREO_INSTITUCIONAL CI ON CI.CEDULA_PERSONA = TDM.ESTUDIANTE_CEDULA
>     LEFT JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES AV ON AV.CODIGO_MATERIA = TDM.MATERIA_CODIGO AND AV.CODIGO_CICLO_ACAD = CA.CODIGO AND AV.CODIGO_PARALELO = TDM.PARALELO_CODIGO
>     LEFT JOIN UTNDB.LMS_TAB_INTEGRANTES IA ON IA.ID_CURSO = AV.ID_CURSO AND IA.CEDULA_INTEGRANTE = TDM.ESTUDIANTE_CEDULA
> WHERE
>     TDM.ANULACION != 'S'
>     AND TDM.ANULACION = 'N'
>     AND M.ESTADO IN ('M', 'C', 'R')
> ;
> ```

> [!example]- `MVL_VIEW_LISTA_ESTUDIANTES_FOTO_DOCENTE` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `LISTA_ESTUDIANTES_FOTO_QUERY`. V1, no expone el BLOB `FOTO` (igual que el original). Validada (MINUS 0/0), curl real.
>
> **Lo usa:** `src/modules/registro-academico/repository/queries/lista-estudiantes-foto.query.ts`
>
> **Antes** (`src/modules/registro-academico/repository/queries/lista-estudiantes-foto.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> /**
>  * Lista de estudiantes de una materia para la vista con fotos.
>  *
>  * NO se selecciona el BLOB `P.FOTO`: traerlo multiplicaba el peso de la respuesta y
>  * obligaba a recomprimir cada imagen en el servidor. En su lugar se devuelve una
>  * bandera y el cliente pide cada foto al endpoint binario `/shared/foto-persona`.
>  */
> export const LISTA_ESTUDIANTES_FOTO_QUERY = `
> SELECT
>     P.CEDULA AS "CEDULA",
>     INS_PCK_GENERAL.FUN_NOMBRES_PERSONA(P.CEDULA) AS "NOMBRES",
>     CASE WHEN P.FOTO IS NOT NULL AND DBMS_LOB.GETLENGTH(P.FOTO) > 0
>          THEN 1 ELSE 0 END AS "TIENE_FOTO"
> FROM UTNDB.ACA_TAB_DETALLE_MATRICULAS DM
> INNER JOIN UTNDB.RHU_TAB_PERSONAS P
>   ON DM.ESTUDIANTE_CEDULA = P.CEDULA
> INNER JOIN UTNDB.ACA_TAB_MATRICULAS M
>   ON DM.ESTUDIANTE_CEDULA = M.ESTUDIANTE_CEDULA
>   AND DM.MATRICULA_CODIGO = M.CODIGO
> WHERE DM.DOCENTE_CEDULA = :cedulaDocente
>   AND DM.DEPEN_CODIGO = :depenCodigo
>   AND DM.MATERIA_CODIGO = :materiaCodigo
>   AND DM.NIVEL_CODIGO = :nivelCodigo
>   AND DM.CICLO_ACAD_CODIGO = :cicloCodigo
>   AND DM.MODA_ESTUD_CODIGO = :modalidadCodigo
>   AND DM.PARALELO_CODIGO = :paraleloCodigo
>   AND DM.ANULACION = 'N'
>   AND M.ESTADO IN ('M', 'C', 'R')
> ORDER BY INS_PCK_GENERAL.FUN_NOMBRES_PERSONA(P.CEDULA)
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_LISTA_ESTUDIANTES_FOTO_DOCENTE
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/registro-academico
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_LISTA_ESTUDIANTES_FOTO_DOCENTE ("CEDULA", "NOMBRES", "TIENE_FOTO", "DOCENTE_CEDULA", "DEPEN_CODIGO", "MATERIA_CODIGO", "NIVEL_CODIGO", "CICLO_ACAD_CODIGO", "MODA_ESTUD_CODIGO", "PARALELO_CODIGO") AS
> SELECT
>     P.CEDULA AS "CEDULA",
>     UTNDB.INS_PCK_GENERAL.FUN_NOMBRES_PERSONA(P.CEDULA) AS "NOMBRES",
>     CASE WHEN P.FOTO IS NOT NULL AND DBMS_LOB.GETLENGTH(P.FOTO) > 0
>          THEN 1 ELSE 0 END AS "TIENE_FOTO",
>     DM.DOCENTE_CEDULA,
>     DM.DEPEN_CODIGO,
>     DM.MATERIA_CODIGO,
>     DM.NIVEL_CODIGO,
>     DM.CICLO_ACAD_CODIGO,
>     DM.MODA_ESTUD_CODIGO,
>     DM.PARALELO_CODIGO
> FROM UTNDB.ACA_TAB_DETALLE_MATRICULAS DM
> INNER JOIN UTNDB.RHU_TAB_PERSONAS P
>   ON DM.ESTUDIANTE_CEDULA = P.CEDULA
> INNER JOIN UTNDB.ACA_TAB_MATRICULAS M
>   ON DM.ESTUDIANTE_CEDULA = M.ESTUDIANTE_CEDULA
>   AND DM.MATRICULA_CODIGO = M.CODIGO
> WHERE DM.ANULACION = 'N'
>   AND M.ESTADO IN ('M', 'C', 'R')
> ;
> ```

> [!example]- `MVL_VIEW_NOTAS_GENERAL_ESTUDIANTES_DOCENTE` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `NOTAS_GENERAL_ESTUDIANTES_QUERY`. V2, el `IN` original filtraba `ACA_TAB_DETALLE_MATRICULAS` por los mismos binds que ya filtraban la tabla externa (mismo nombre reusado) → se reescribió como `EXISTS` autocorrelacionado sin binds. Validada (MINUS 0/0), curl real.
>
> **Lo usa:** `src/modules/registro-academico/repository/queries/notas-general-estudiantes.query.ts`
>
> **Antes** (`src/modules/registro-academico/repository/queries/notas-general-estudiantes.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const NOTAS_GENERAL_ESTUDIANTES_QUERY = `
> SELECT 
>     ACA_TAB_NOTAS.ESTUDIANTE_CEDULA AS CEDULA,
>     (TAB_PERSONAS.PRIMER_APELLIDO || ' ' || TAB_PERSONAS.SEGUNDO_APELLIDO) AS APELLIDOS,
>     (TAB_PERSONAS.PRIMER_NOMBRE || ' ' || TAB_PERSONAS.SEGUNDO_NOMBRE) AS NOMBRES,
>     ACA_TAB_NOTAS.NOTA1 AS N1,
>     ACA_TAB_NOTAS.NOTA2 AS N2,
>     ACA_TAB_NOTAS.NOTA3 AS SUP,
>     ACA_TAB_NOTAS.RESULTADO1 AS S1,
>     ACA_TAB_NOTAS.RESULTADO2 AS S2,
>     ACA_TAB_NOTAS.FINAL1 AS NF1,
>     ACA_TAB_NOTAS.FINAL2 AS NF2,
>     ACA_TAB_NOTAS.NOTA_FINAL,
>     ACA_TAB_NOTAS.PORCENTAJE_FALTAS AS "INASISTENCIA (%)",
>     ACA_TAB_NOTAS.APROBO AS APROBADO,
>     ACA_TAB_NOTAS.PIERDE_POR_FALTAS
> FROM 
>     ACA_TAB_NOTAS
>     INNER JOIN RHU_TAB_PERSONAS TAB_PERSONAS
>         ON ACA_TAB_NOTAS.ESTUDIANTE_CEDULA = TAB_PERSONAS.CEDULA
> WHERE 
>     ACA_TAB_NOTAS.ESTUDIANTE_CEDULA IN (
>         SELECT DM.ESTUDIANTE_CEDULA
>         FROM ACA_TAB_DETALLE_MATRICULAS DM
>         JOIN ACA_TAB_MATRICULAS MA ON MA.CODIGO = DM.MATRICULA_CODIGO
>             AND MA.ESTUDIANTE_CEDULA = DM.ESTUDIANTE_CEDULA
>         WHERE 
>             DM.MATERIA_CODIGO = :P9_MATERIA_CODIGO
>             AND DM.NIVEL_CODIGO = :P9_NIVEL_CODIGO
>             AND DM.PARALELO_CODIGO = :P9_PARALELO_CODIGO
>             AND DM.DEPEN_CODIGO = :P9_DEPEN_CODIGO
>             AND DM.INST_CODIGO = :P9_INST_CODIGO
>             AND DM.CICLO_ACAD_CODIGO = :P9_CICLO_ACAD_CODIGO
>             AND DM.MODA_ESTUD_CODIGO = :P9_MODA_ESTUD_CODIGO
>             AND DM.SIST_ESTUD_CODIGO = :P9_SIST_ESTUD_CODIGO
>             AND DM.TCICLOACAD_CODIGO = :P9_TCICLOACAD_CODIGO
>             AND DM.TFINANCIA_CODIGO = :P9_TFINANCIA_CODIGO
>             AND DM.DOCENTE_CEDULA = :P9_DOCENTE_CEDULA
>             AND MA.ESTADO NOT IN ('P', 'A')
>             AND DM.ANULACION <> 'S'
>     )
>     AND ACA_TAB_NOTAS.MATERIA_CODIGO = :P9_MATERIA_CODIGO
>     AND ACA_TAB_NOTAS.PARALELO_CODIGO = :P9_PARALELO_CODIGO
>     AND ACA_TAB_NOTAS.DOCENTE_CEDULA = :P9_DOCENTE_CEDULA
>     AND ACA_TAB_NOTAS.INST_CODIGO = :P9_INST_CODIGO
>     AND ACA_TAB_NOTAS.MODA_ESTUD_CODIGO = :P9_MODA_ESTUD_CODIGO
>     AND ACA_TAB_NOTAS.SIST_ESTUD_CODIGO = :P9_SIST_ESTUD_CODIGO
>     AND ACA_TAB_NOTAS.TCICLOACAD_CODIGO = :P9_TCICLOACAD_CODIGO
>     AND ACA_TAB_NOTAS.TFINANCIA_CODIGO = :P9_TFINANCIA_CODIGO
>     AND ACA_TAB_NOTAS.DEPEN_CODIGO = :P9_DEPEN_CODIGO
>     AND ACA_TAB_NOTAS.CICLO_ACAD_CODIGO = :P9_CICLO_ACAD_CODIGO
>     AND ACA_TAB_NOTAS.NIVEL_CODIGO = :P9_NIVEL_CODIGO
> ORDER BY 
>     APELLIDOS ASC
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_NOTAS_GENERAL_ESTUDIANTES_DOCENTE
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/registro-academico
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_NOTAS_GENERAL_ESTUDIANTES_DOCENTE ("CEDULA", "APELLIDOS", "NOMBRES", "N1", "N2", "SUP", "S1", "S2", "NF1", "NF2", "NOTA_FINAL", "INASISTENCIA (%)", "APROBADO", "PIERDE_POR_FALTAS", "MATERIA_CODIGO", "NIVEL_CODIGO", "PARALELO_CODIGO", "DOCENTE_CEDULA", "INST_CODIGO", "MODA_ESTUD_CODIGO", "SIST_ESTUD_CODIGO", "TCICLOACAD_CODIGO", "TFINANCIA_CODIGO", "DEPEN_CODIGO", "CICLO_ACAD_CODIGO") AS
> SELECT
>     ACA_TAB_NOTAS.ESTUDIANTE_CEDULA AS CEDULA,
>     (TAB_PERSONAS.PRIMER_APELLIDO || ' ' || TAB_PERSONAS.SEGUNDO_APELLIDO) AS APELLIDOS,
>     (TAB_PERSONAS.PRIMER_NOMBRE || ' ' || TAB_PERSONAS.SEGUNDO_NOMBRE) AS NOMBRES,
>     ACA_TAB_NOTAS.NOTA1 AS N1,
>     ACA_TAB_NOTAS.NOTA2 AS N2,
>     ACA_TAB_NOTAS.NOTA3 AS SUP,
>     ACA_TAB_NOTAS.RESULTADO1 AS S1,
>     ACA_TAB_NOTAS.RESULTADO2 AS S2,
>     ACA_TAB_NOTAS.FINAL1 AS NF1,
>     ACA_TAB_NOTAS.FINAL2 AS NF2,
>     ACA_TAB_NOTAS.NOTA_FINAL,
>     ACA_TAB_NOTAS.PORCENTAJE_FALTAS AS "INASISTENCIA (%)",
>     ACA_TAB_NOTAS.APROBO AS APROBADO,
>     ACA_TAB_NOTAS.PIERDE_POR_FALTAS,
>     ACA_TAB_NOTAS.MATERIA_CODIGO,
>     ACA_TAB_NOTAS.NIVEL_CODIGO,
>     ACA_TAB_NOTAS.PARALELO_CODIGO,
>     ACA_TAB_NOTAS.DOCENTE_CEDULA,
>     ACA_TAB_NOTAS.INST_CODIGO,
>     ACA_TAB_NOTAS.MODA_ESTUD_CODIGO,
>     ACA_TAB_NOTAS.SIST_ESTUD_CODIGO,
>     ACA_TAB_NOTAS.TCICLOACAD_CODIGO,
>     ACA_TAB_NOTAS.TFINANCIA_CODIGO,
>     ACA_TAB_NOTAS.DEPEN_CODIGO,
>     ACA_TAB_NOTAS.CICLO_ACAD_CODIGO
> FROM
>     UTNDB.ACA_TAB_NOTAS ACA_TAB_NOTAS
>     INNER JOIN UTNDB.RHU_TAB_PERSONAS TAB_PERSONAS
>         ON ACA_TAB_NOTAS.ESTUDIANTE_CEDULA = TAB_PERSONAS.CEDULA
> WHERE
>     EXISTS (
>         SELECT 1
>         FROM UTNDB.ACA_TAB_DETALLE_MATRICULAS DM
>         JOIN UTNDB.ACA_TAB_MATRICULAS MA ON MA.CODIGO = DM.MATRICULA_CODIGO
>             AND MA.ESTUDIANTE_CEDULA = DM.ESTUDIANTE_CEDULA
>         WHERE DM.ESTUDIANTE_CEDULA = ACA_TAB_NOTAS.ESTUDIANTE_CEDULA
>             AND DM.MATERIA_CODIGO = ACA_TAB_NOTAS.MATERIA_CODIGO
>             AND DM.NIVEL_CODIGO = ACA_TAB_NOTAS.NIVEL_CODIGO
>             AND DM.PARALELO_CODIGO = ACA_TAB_NOTAS.PARALELO_CODIGO
>             AND DM.DEPEN_CODIGO = ACA_TAB_NOTAS.DEPEN_CODIGO
>             AND DM.INST_CODIGO = ACA_TAB_NOTAS.INST_CODIGO
>             AND DM.CICLO_ACAD_CODIGO = ACA_TAB_NOTAS.CICLO_ACAD_CODIGO
>             AND DM.MODA_ESTUD_CODIGO = ACA_TAB_NOTAS.MODA_ESTUD_CODIGO
>             AND DM.SIST_ESTUD_CODIGO = ACA_TAB_NOTAS.SIST_ESTUD_CODIGO
>             AND DM.TCICLOACAD_CODIGO = ACA_TAB_NOTAS.TCICLOACAD_CODIGO
>             AND DM.TFINANCIA_CODIGO = ACA_TAB_NOTAS.TFINANCIA_CODIGO
>             AND DM.DOCENTE_CEDULA = ACA_TAB_NOTAS.DOCENTE_CEDULA
>             AND MA.ESTADO NOT IN ('P', 'A')
>             AND DM.ANULACION <> 'S'
>     )
> ;
> ```

> [!example]- `MVL_VIEW_MATERIAS_REGISTRO_ACADEMICO_DOCENTE` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `MATERIAS_REGISTRO_ACADEMICO_QUERY`. V2, `CICLO_ACAD_CODIGO IN (SELECT...WHERE CODIGO=:bind)` se separó en igualdad externa + `EXISTS` de integridad autocorrelacionado. Validada (MINUS 0/0), curl real.
>
> **Lo usa:** `src/modules/registro-academico/repository/queries/registro-academico.query.ts`
>
> **Antes** (`src/modules/registro-academico/repository/queries/registro-academico.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const MATERIAS_REGISTRO_ACADEMICO_QUERY = `
>   SELECT DISTINCT
>     TAB_AULAS.ID_CURSO,
>     TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>     TAB_DISTRIBUTIVOS.INST_CODIGO,
>     TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>     TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>     TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>     TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO,
>     TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>     TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>     TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO AS CICLO_ACADEMICO_,
>     TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>     TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>     TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>     TAB_DISTRIBUTIVOS.ESTADO,
>     TAB_DISTRIBUTIVOS.ESTADO_EVAL_DOC,
>     TAB_DISTRIBUTIVOS.PUNTAJE_EVALUACION,
>     TAB_MATERIAS.DESCRIPCION AS MATERIA,
>     -- Adjusted 'FECHA_INICIO_FIN' without HTML tags
>     TAB_MAT_PENSUM.FECHA_INICIO || ' - ' || TAB_MAT_PENSUM.FECHA_FIN AS FECHA_INICIO_FIN,
>     -- Adjusted 'NOMBRE_MATERIA' without HTML tags
>     TAB_MATERIAS.DESCRIPCION || ' ' || 
>     (SELECT DESCRIPCION
>       FROM UTNDB.PEI_TAB_POA_PROYECTOS
>      WHERE CODIGO = TAB_DISTRIBUTIVOS.PARALELO_CODIGO) AS NOMBRE_MATERIA,
>     FUN_OBTENER('ACA_TAB_NIVELES', 'DESCRIPCION', TAB_DISTRIBUTIVOS.NIVEL_CODIGO, NULL, NULL) AS NIVEL,
>     FUN_OBTENER('ACA_TAB_PARALELOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.PARALELO_CODIGO, NULL, NULL) AS PARALELO,
>     FUN_OBTENER('ACA_TAB_TIPOS_CICLOS_ACADEMICO', 'DESCRIPCION', TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, NULL, NULL) AS TIPO_CICLO_ACADEMICO,
>     FUN_OBTENER('ACA_TAB_TIPOS_FINANCIAMIENTOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO, NULL, NULL) AS TIPO_FINANCIAMIENTO,
>     FUN_OBTENER('ACA_TAB_MODALIDADES_ESTUDIOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, NULL, NULL) AS MODALIDAD_ESTUDIO,
>     FUN_OBTENER('ACA_TAB_SISTEMAS_ESTUDIOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO, NULL, NULL) AS SISTEMA_ESTUDIO,
>     FUN_OBTENER('ACA_TAB_CICLOS_ACADEMICOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO, NULL, NULL) AS CICLO_ACADEMICO,
>     FUN_OBTENER('ACA_TAB_DEPENDENCIAS', 'NOMBRE', TAB_DISTRIBUTIVOS.INST_CODIGO, TAB_DISTRIBUTIVOS.DEPEN_CODIGO, NULL) AS NOMBRE_DEPENDENCIA,
>     -- Número de estudiantes en la materia
>     INS_PCK_GENERAL.FUN_NUM_ESTUDIANTES (
>         TAB_DISTRIBUTIVOS.DOCENTE_CEDULA, 
>         TAB_DISTRIBUTIVOS.DEPEN_CODIGO, 
>         TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO, 
>         TAB_DISTRIBUTIVOS.NIVEL_CODIGO, 
>         TAB_DISTRIBUTIVOS.MATERIA_CODIGO, 
>         TAB_DISTRIBUTIVOS.INST_CODIGO, 
>         TAB_DISTRIBUTIVOS.PARALELO_CODIGO, 
>         TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, 
>         TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO, 
>         TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, 
>         TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO
>     ) AS NUM_ESTUDIANTES,
>     -- Porcentaje Planificado
>     CASE 
>          WHEN (TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO NOT IN ('03')
>                AND TAB_DISTRIBUTIVOS.NIVEL_CODIGO NOT IN ('NI')
>                AND TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO NOT IN ('0922-0323'))    
>          THEN 
>              ROUND(ACA_PCK_ACADEMICO.FUN_PORCENTAJE_AVANCE_PLANIF(
>                 TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>                 TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>                 TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>                 TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>                 TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>                 TAB_DISTRIBUTIVOS.INST_CODIGO,
>                 TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>                 TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>                 TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>                 TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>                 TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO), 2)
>          ELSE
>              ROUND(ACA_PCK_ACADEMICO.FUN_PORCENTAJE_AVAN_PLANIF_MOD(
>                 TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>                 TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>                 TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>                 TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>                 TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>                 TAB_DISTRIBUTIVOS.INST_CODIGO,
>                 TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>                 TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>                 TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>                 TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>                 TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO), 2)
>     END AS PORCENTAJE_PLANIFICADO,
>     -- Porcentaje Ejecutado
>     ROUND(UTNDB.LMS_FUN_PORCENTAJE_EJECUTADO (
>         TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>         TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>         TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>         TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>         TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>         TAB_DISTRIBUTIVOS.INST_CODIGO,
>         TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>         TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>         TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>         TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>         TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO), 2) AS PORCENTAJE_EJECUTADO,
>     -- Aula Virtual
>     CASE  
>         WHEN TAB_AULAS.ID_CURSO IS NULL OR TAB_AULAS.ID_CURSO = ''  THEN    
>             CASE 
>                 WHEN UTNDB.LMS_FUN_HABILITA_CREAR_AULA(
>                         TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>                         TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>                         TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>                         TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>                         TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>                         TAB_DISTRIBUTIVOS.INST_CODIGO,
>                         TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>                         TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>                         TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>                         TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>                         TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO
>                     ) > 0 
>                 THEN
>                     'CREAR'
>                 ELSE 
>                     'NO DISPONIBLE'
>             END
>         ELSE  
>             CASE 
>                 WHEN UTNDB.LMS_FUN_HABILITA_CREAR_AULA(
>                         TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_MATERIAS_REGISTRO_ACADEMICO_DOCENTE
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      DBMS_METADATA.GET_DDL (supera 4000 caracteres)
> -- Usado por: src/modules/registro-academico
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_MATERIAS_REGISTRO_ACADEMICO_DOCENTE ("ID_CURSO", "DOCENTE_CEDULA", "INST_CODIGO", "MODA_ESTUD_CODIGO", "SIST_ESTUD_CODIGO", "TCICLOACAD_CODIGO", "TFINANCIA_CODIGO", "DEPEN_CODIGO", "CICLO_ACAD_CODIGO", "CICLO_ACADEMICO_", "MATERIA_CODIGO", "NIVEL_CODIGO", "PARALELO_CODIGO", "ESTADO", "ESTADO_EVAL_DOC", "PUNTAJE_EVALUACION", "MATERIA", "FECHA_INICIO_FIN", "NOMBRE_MATERIA", "NIVEL", "PARALELO", "TIPO_CICLO_ACADEMICO", "TIPO_FINANCIAMIENTO", "MODALIDAD_ESTUDIO", "SISTEMA_ESTUDIO", "CICLO_ACADEMICO", "NOMBRE_DEPENDENCIA", "NUM_ESTUDIANTES", "PORCENTAJE_PLANIFICADO", "PORCENTAJE_EJECUTADO", "AULA_VIRTUAL") AS
> SELECT DISTINCT
>     TAB_AULAS.ID_CURSO,
>     TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>     TAB_DISTRIBUTIVOS.INST_CODIGO,
>     TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>     TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>     TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>     TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO,
>     TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>     TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>     TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO AS CICLO_ACADEMICO_,
>     TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>     TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>     TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>     TAB_DISTRIBUTIVOS.ESTADO,
>     TAB_DISTRIBUTIVOS.ESTADO_EVAL_DOC,
>     TAB_DISTRIBUTIVOS.PUNTAJE_EVALUACION,
>     TAB_MATERIAS.DESCRIPCION AS MATERIA,
>     TAB_MAT_PENSUM.FECHA_INICIO || ' - ' || TAB_MAT_PENSUM.FECHA_FIN AS FECHA_INICIO_FIN,
>     TAB_MATERIAS.DESCRIPCION || ' ' ||
>     (SELECT DESCRIPCION FROM UTNDB.PEI_TAB_POA_PROYECTOS WHERE CODIGO = TAB_DISTRIBUTIVOS.PARALELO_CODIGO) AS NOMBRE_MATERIA,
>     UTNDB.FUN_OBTENER('ACA_TAB_NIVELES', 'DESCRIPCION', TAB_DISTRIBUTIVOS.NIVEL_CODIGO, NULL, NULL) AS NIVEL,
>     UTNDB.FUN_OBTENER('ACA_TAB_PARALELOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.PARALELO_CODIGO, NULL, NULL) AS PARALELO,
>     UTNDB.FUN_OBTENER('ACA_TAB_TIPOS_CICLOS_ACADEMICO', 'DESCRIPCION', TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, NULL, NULL) AS TIPO_CICLO_ACADEMICO,
>     UTNDB.FUN_OBTENER('ACA_TAB_TIPOS_FINANCIAMIENTOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO, NULL, NULL) AS TIPO_FINANCIAMIENTO,
>     UTNDB.FUN_OBTENER('ACA_TAB_MODALIDADES_ESTUDIOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, NULL, NULL) AS MODALIDAD_ESTUDIO,
>     UTNDB.FUN_OBTENER('ACA_TAB_SISTEMAS_ESTUDIOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO, NULL, NULL) AS SISTEMA_ESTUDIO,
>     UTNDB.FUN_OBTENER('ACA_TAB_CICLOS_ACADEMICOS', 'DESCRIPCION', TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO, NULL, NULL) AS CICLO_ACADEMICO,
>     UTNDB.FUN_OBTENER('ACA_TAB_DEPENDENCIAS', 'NOMBRE', TAB_DISTRIBUTIVOS.INST_CODIGO, TAB_DISTRIBUTIVOS.DEPEN_CODIGO, NULL) AS NOMBRE_DEPENDENCIA,
>     UTNDB.INS_PCK_GENERAL.FUN_NUM_ESTUDIANTES(
>         TAB_DISTRIBUTIVOS.DOCENTE_CEDULA, TAB_DISTRIBUTIVOS.DEPEN_CODIGO, TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>         TAB_DISTRIBUTIVOS.NIVEL_CODIGO, TAB_DISTRIBUTIVOS.MATERIA_CODIGO, TAB_DISTRIBUTIVOS.INST_CODIGO,
>         TAB_DISTRIBUTIVOS.PARALELO_CODIGO, TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>         TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO
>     ) AS NUM_ESTUDIANTES,
>     CASE
>          WHEN (TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO NOT IN ('03')
>                AND TAB_DISTRIBUTIVOS.NIVEL_CODIGO NOT IN ('NI')
>                AND TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO NOT IN ('0922-0323'))
>          THEN
>              ROUND(UTNDB.ACA_PCK_ACADEMICO.FUN_PORCENTAJE_AVANCE_PLANIF(
>                 TAB_DISTRIBUTIVOS.DOCENTE_CEDULA, TAB_DISTRIBUTIVOS.DEPEN_CODIGO, TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>                 TAB_DISTRIBUTIVOS.NIVEL_CODIGO, TAB_DISTRIBUTIVOS.MATERIA_CODIGO, TAB_DISTRIBUTIVOS.INST_CODIGO,
>                 TAB_DISTRIBUTIVOS.PARALELO_CODIGO, TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>                 TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO), 2)
>          ELSE
>              ROUND(UTNDB.ACA_PCK_ACADEMICO.FUN_PORCENTAJE_AVAN_PLANIF_MOD(
>                 TAB_DISTRIBUTIVOS.DOCENTE_CEDULA, TAB_DISTRIBUTIVOS.DEPEN_CODIGO, TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>                 TAB_DISTRIBUTIVOS.NIVEL_CODIGO, TAB_DISTRIBUTIVOS.MATERIA_CODIGO, TAB_DISTRIBUTIVOS.INST_CODIGO,
>                 TAB_DISTRIBUTIVOS.PARALELO_CODIGO, TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>                 TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO), 2)
>     END AS PORCENTAJE_PLANIFICADO,
>     ROUND(UTNDB.LMS_FUN_PORCENTAJE_EJECUTADO(
>         TAB_DISTRIBUTIVOS.DOCENTE_CEDULA, TAB_DISTRIBUTIVOS.DEPEN_CODIGO, TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>         TAB_DISTRIBUTIVOS.NIVEL_CODIGO, TAB_DISTRIBUTIVOS.MATERIA_CODIGO, TAB_DISTRIBUTIVOS.INST_CODIGO,
>         TAB_DISTRIBUTIVOS.PARALELO_CODIGO, TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>         TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO), 2) AS PORCENTAJE_EJECUTADO,
>     CASE
>         WHEN TAB_AULAS.ID_CURSO IS NULL OR TAB_AULAS.ID_CURSO = '' THEN
>             CASE WHEN UTNDB.LMS_FUN_HABILITA_CREAR_AULA(
>                         TAB_DISTRIBUTIVOS.DOCENTE_CEDULA, TAB_DISTRIBUTIVOS.DEPEN_CODIGO, TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>                         TAB_DISTRIBUTIVOS.NIVEL_CODIGO, TAB_DISTRIBUTIVOS.MATERIA_CODIGO, TAB_DISTRIBUTIVOS.INST_CODIGO,
>                         TAB_DISTRIBUTIVOS.PARALELO_CODIGO, TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>                         TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO) > 0
>                  THEN 'CREAR' ELSE 'NO DISPONIBLE' END
>         ELSE
>             CASE WHEN UTNDB.LMS_FUN_HABILITA_CREAR_AULA(
>                         TAB_DISTRIBUTIVOS.DOCENTE_CEDULA, TAB_DISTRIBUTIVOS.DEPEN_CODIGO, TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>                         TAB_DISTRIBUTIVOS.NIVEL_CODIGO, TAB_DISTRIBUTIVOS.MATERIA_CODIGO, TAB_DISTRIBUTIVOS.INST_CODIGO,
>                         TAB_DISTRIBUTIVOS.PARALELO_CODIGO, TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO,
>                         TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO) > 0
>                  OR (SELECT CA.ESTADO FROM UTNDB.ACA_TAB_CICLOS_ACADEMICOS CA WHERE CA.CODIGO = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO) <> 'A'
>                  THEN 'ACTIVO' ELSE 'NO DISPONIBLE' END
>     END AS AULA_VIRTUAL
> FROM
>     UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS
>     INNER JOIN UTNDB.ACA_TAB_DISTRIBUTIVOS TAB_DISTRIBUTIVOS
>         ON TAB_MATERIAS.NIVEL_CODIGO = TAB_DISTRIBUTIVOS.NIVEL_CODIGO
>         AND TAB_MATERIAS.CODIGO = TAB_DISTRIBUTIVOS.MATERIA_CODIGO
>         AND TAB_MATERIAS.TMATERIA_CODIGO != '04'
>     INNER JOIN UTNDB.ACA_TAB_MATERIAS_PENSUMS TAB_MATERIAS_PENSUM
>         ON TAB_MATERIAS_PENSUM.CICLO_ACAD_CODIGO = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO
>         AND TAB_MATERIAS_PENSUM.MODA_ESTUD_CODIGO = TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO
>         AND TAB_MATERIAS_PENSUM.DEPEN_CODIGO = TAB_DISTRIBUTIVOS.DEPEN_CODIGO
>         AND TAB_MATERIAS_PENSUM.MATERIA_CODIGO = TAB_DISTRIBUTIVOS.MATERIA_CODIGO
>         AND TAB_MATERIAS_PENSUM.NIVEL_CODIGO = TAB_DISTRIBUTIVOS.NIVEL_CODIGO
>         AND TAB_MATERIAS_PENSUM.ESTADO = 'A'
>     LEFT JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES TAB_AULAS
>         ON TAB_AULAS.CODIGO_INSTITUCION = TAB_DISTRIBUTIVOS.INST_CODIGO
>         AND TAB_AULAS.CODIGO_DEPENDENCIA = TAB_DISTRIBUTIVOS.DEPEN_CODIGO
>         AND TAB_AULAS.CODIGO_NIVEL = TAB_DISTRIBUTIVOS.NIVEL_CODIGO
>         AND TAB_AULAS.CODIGO_MATERIA = TAB_DISTRIBUTIVOS.MATERIA_CODIGO
>         AND TAB_AULAS.CODIGO_MOD_EST = TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO
>         AND TAB_AULAS.CODIGO_SIS_EST = TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO
>         AND TAB_AULAS.CODIGO_CICLO_ACAD = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO
>         AND TAB_AULAS.CODIGO_PARALELO = TAB_DISTRIBUTIVOS.PARALELO_CODIGO
>         AND TAB_AULAS.CODIGO_TIPO_FINANC = TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO
>         AND TAB_AULAS.CEDULA_DOCENTE = TAB_DISTRIBUTIVOS.DOCENTE_CEDULA
>         AND TAB_AULAS.ESTADO = 'A'
>     LEFT JOIN UTNDB.ACA_TAB_CALENDARIOS_MAT_PENSUM TAB_MAT_PENSUM
>         ON TAB_MAT_PENSUM.CICLO_ACAD_CODIGO = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO
>         AND TAB_MAT_PENSUM.MODA_ESTUD_CODIGO = TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO
>         AND TAB_MAT_PENSUM.DEPEN_CODIGO = TAB_DISTRIBUTIVOS.DEPEN_CODIGO
>         AND TAB_MAT_PENSUM.MATERIA_CODIGO = TAB_DISTRIBUTIVOS.MATERIA_CODIGO
>         AND TAB_MAT_PENSUM.NIVEL_CODIGO = TAB_DISTRIBUTIVOS.NIVEL_CODIGO
>         AND TAB_MAT_PENSUM.PARALELO_CODIGO = TAB_DISTRIBUTIVOS.PARALELO_CODIGO
>         AND TAB_MAT_PENSUM.ESTADO = 'A'
> WHERE
>     TAB_DISTRIBUTIVOS.INST_CODIGO = '001'
>     AND TAB_DISTRIBUTIVOS.MATERIA_CODIGO NOT IN (
>         SELECT MA.CODIGO FROM UTNDB.ACA_TAB_MATERIAS MA WHERE MA.TMATERIA_CODIGO IN ('07', '04')
>     )
>     AND EXISTS (
>         SELECT 1 FROM UTNDB.ACA_TAB_CICLOS_ACADEMICOS C WHERE C.CODIGO = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO
>     )
>     AND TAB_DISTRIBUTIVOS.NIVEL_CODIGO != '00'
>     AND TAB_MATERIAS.TMATERIA_CODIGO != '04'
>     AND TAB_MATERIAS.DEPEN_CODIGO NOT IN ('00263', '00194')
> ;
> ```

> [!example]- `MVL_VIEW_ESTADO_AULA_VIRTUAL_DOCENTE` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `VALIDAR_ESTADO_AULA_VIRTUAL_QUERY`. V1, `ROWNUM=1` movido al `.ts` (no puede vivir en la vista). Validada por MINUS (0/0) contra Oracle; **no probada por curl** porque su único invocador es `crearAulaVirtual` (POST de escritura, no se ejecutó para no crear un aula virtual real).
>
> **Lo usa:** `src/modules/registro-academico/repository/queries/validar-estado-aula-virtual.query.ts`
>
> **Antes** (`src/modules/registro-academico/repository/queries/validar-estado-aula-virtual.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const VALIDAR_ESTADO_AULA_VIRTUAL_QUERY = `
>     SELECT 
>         CASE  
>             WHEN TAB_AULAS.ID_CURSO IS NULL OR TAB_AULAS.ID_CURSO = '' THEN    
>                 CASE 
>                     WHEN UTNDB.LMS_FUN_HABILITA_CREAR_AULA(
>                             TAB_DISTRIBUTIVOS.DOCENTE_CEDULA, TAB_DISTRIBUTIVOS.DEPEN_CODIGO, 
>                             TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO, TAB_DISTRIBUTIVOS.NIVEL_CODIGO, 
>                             TAB_DISTRIBUTIVOS.MATERIA_CODIGO, TAB_DISTRIBUTIVOS.INST_CODIGO, 
>                             TAB_DISTRIBUTIVOS.PARALELO_CODIGO, TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, 
>                             TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO, TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, 
>                             TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO
>                         ) > 0 
>                     THEN 'CREAR'
>                     ELSE 'NO DISPONIBLE'
>                 END
>             ELSE  
>                 CASE 
>                     WHEN UTNDB.LMS_FUN_HABILITA_CREAR_AULA(
>                             TAB_DISTRIBUTIVOS.DOCENTE_CEDULA, TAB_DISTRIBUTIVOS.DEPEN_CODIGO, 
>                             TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO, TAB_DISTRIBUTIVOS.NIVEL_CODIGO, 
>                             TAB_DISTRIBUTIVOS.MATERIA_CODIGO, TAB_DISTRIBUTIVOS.INST_CODIGO, 
>                             TAB_DISTRIBUTIVOS.PARALELO_CODIGO, TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO, 
>                             TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO, TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO, 
>                             TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO
>                         ) > 0 
>                         OR (SELECT CA.ESTADO FROM UTNDB.ACA_TAB_CICLOS_ACADEMICOS CA WHERE CA.CODIGO = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO) <> 'A' 
>                     THEN 'ACTIVO'
>                     ELSE 'NO DISPONIBLE'
>                 END
>         END AS ESTADO_AULA_VIRTUAL
>     FROM
>         UTNDB.ACA_TAB_DISTRIBUTIVOS TAB_DISTRIBUTIVOS
>         INNER JOIN UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS
>             ON TAB_MATERIAS.NIVEL_CODIGO = TAB_DISTRIBUTIVOS.NIVEL_CODIGO
>             AND TAB_MATERIAS.CODIGO = TAB_DISTRIBUTIVOS.MATERIA_CODIGO
>         LEFT JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES TAB_AULAS
>             ON TAB_AULAS.CODIGO_INSTITUCION = TAB_DISTRIBUTIVOS.INST_CODIGO
>             AND TAB_AULAS.CODIGO_DEPENDENCIA = TAB_DISTRIBUTIVOS.DEPEN_CODIGO
>             AND TAB_AULAS.CODIGO_NIVEL = TAB_DISTRIBUTIVOS.NIVEL_CODIGO
>             AND TAB_AULAS.CODIGO_MATERIA = TAB_DISTRIBUTIVOS.MATERIA_CODIGO
>             AND TAB_AULAS.CODIGO_MOD_EST = TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO
>             AND TAB_AULAS.CODIGO_SIS_EST = TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO
>             AND TAB_AULAS.CODIGO_CICLO_ACAD = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO
>             AND TAB_AULAS.CODIGO_PARALELO = TAB_DISTRIBUTIVOS.PARALELO_CODIGO
>             AND TAB_AULAS.CEDULA_DOCENTE = TAB_DISTRIBUTIVOS.DOCENTE_CEDULA
>             AND TAB_AULAS.ESTADO = 'A'
>     WHERE
>         TAB_DISTRIBUTIVOS.DOCENTE_CEDULA = :cedula
>         AND TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO = :cicloAcademico
>         AND TAB_DISTRIBUTIVOS.MATERIA_CODIGO = :codMateria
>         AND TAB_DISTRIBUTIVOS.PARALELO_CODIGO = :codParalelo
>         AND ROWNUM = 1
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_ESTADO_AULA_VIRTUAL_DOCENTE
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/registro-academico
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_ESTADO_AULA_VIRTUAL_DOCENTE ("DOCENTE_CEDULA", "CICLO_ACAD_CODIGO", "MATERIA_CODIGO", "PARALELO_CODIGO", "ESTADO_AULA_VIRTUAL") AS
> SELECT
>     TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
>     TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO,
>     TAB_DISTRIBUTIVOS.MATERIA_CODIGO,
>     TAB_DISTRIBUTIVOS.PARALELO_CODIGO,
>     CASE
>         WHEN TAB_AULAS.ID_CURSO IS NULL OR TAB_AULAS.ID_CURSO = '' THEN
>             CASE WHEN UTNDB.LMS_FUN_HABILITA_CREAR_AULA(
>                     TAB_DISTRIBUTIVOS.DOCENTE_CEDULA, TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>                     TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO, TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>                     TAB_DISTRIBUTIVOS.MATERIA_CODIGO, TAB_DISTRIBUTIVOS.INST_CODIGO,
>                     TAB_DISTRIBUTIVOS.PARALELO_CODIGO, TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>                     TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO, TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>                     TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO) > 0
>                 THEN 'CREAR' ELSE 'NO DISPONIBLE' END
>         ELSE
>             CASE WHEN UTNDB.LMS_FUN_HABILITA_CREAR_AULA(
>                     TAB_DISTRIBUTIVOS.DOCENTE_CEDULA, TAB_DISTRIBUTIVOS.DEPEN_CODIGO,
>                     TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO, TAB_DISTRIBUTIVOS.NIVEL_CODIGO,
>                     TAB_DISTRIBUTIVOS.MATERIA_CODIGO, TAB_DISTRIBUTIVOS.INST_CODIGO,
>                     TAB_DISTRIBUTIVOS.PARALELO_CODIGO, TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
>                     TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO, TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO,
>                     TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO) > 0
>                 OR (SELECT CA.ESTADO FROM UTNDB.ACA_TAB_CICLOS_ACADEMICOS CA WHERE CA.CODIGO = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO) <> 'A'
>                 THEN 'ACTIVO' ELSE 'NO DISPONIBLE' END
>     END AS ESTADO_AULA_VIRTUAL
> FROM
>     UTNDB.ACA_TAB_DISTRIBUTIVOS TAB_DISTRIBUTIVOS
>     INNER JOIN UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS
>         ON TAB_MATERIAS.NIVEL_CODIGO = TAB_DISTRIBUTIVOS.NIVEL_CODIGO
>         AND TAB_MATERIAS.CODIGO = TAB_DISTRIBUTIVOS.MATERIA_CODIGO
>     LEFT JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES TAB_AULAS
>         ON TAB_AULAS.CODIGO_INSTITUCION = TAB_DISTRIBUTIVOS.INST_CODIGO
>         AND TAB_AULAS.CODIGO_DEPENDENCIA = TAB_DISTRIBUTIVOS.DEPEN_CODIGO
>         AND TAB_AULAS.CODIGO_NIVEL = TAB_DISTRIBUTIVOS.NIVEL_CODIGO
>         AND TAB_AULAS.CODIGO_MATERIA = TAB_DISTRIBUTIVOS.MATERIA_CODIGO
>         AND TAB_AULAS.CODIGO_MOD_EST = TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO
>         AND TAB_AULAS.CODIGO_SIS_EST = TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO
>         AND TAB_AULAS.CODIGO_CICLO_ACAD = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO
>         AND TAB_AULAS.CODIGO_PARALELO = TAB_DISTRIBUTIVOS.PARALELO_CODIGO
>         AND TAB_AULAS.CEDULA_DOCENTE = TAB_DISTRIBUTIVOS.DOCENTE_CEDULA
>         AND TAB_AULAS.ESTADO = 'A'
> ;
> ```

> [!example]- `MVL_VIEW_ACTIVIDAD_DOCENTE` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `ACTIVIDAD_DOCENTE_QUERY`. V1. Validada (MINUS 0/0).
>
> **Lo usa:** `src/modules/actividad/repository/queries/actividad.query.ts`
>
> **Antes** (`src/modules/actividad/repository/queries/actividad.query.ts`, versión previa al commit `ccf22f4`):
>
> >
> **Script del objeto:**
>
> 
> [!example]- `MVL_VIEW_CONTENIDOS_ACTIVIDAD` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `CONTENIDOS_QUERY`. V1. Validada (MINUS 0/0).
>
> **Lo usa:** `src/modules/actividad/repository/queries/contenidos.query.ts`
>
> **Antes** (`src/modules/actividad/repository/queries/contenidos.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const CONTENIDOS_QUERY = `
> SELECT 
>     T.DESCRIPCION || ' ' || C.ITEM || ' ' || C.DESCRIPCION AS DESCRIPCION,
>     C.CODIGO
> FROM ACA_TAB_CONTENIDOS_MATERIAS C
> INNER JOIN ACA_TAB_TIPOS_CONTENIDOS T
>     ON C.TCONTENIDO_CODIGO = T.CODIGO
> INNER JOIN LMS_TAB_AULAS_VIRTUALES AV
>     ON C.INST_CODIGO         = AV.CODIGO_INSTITUCION
>    AND C.DEPEN_CODIGO        = AV.CODIGO_DEPENDENCIA
>    AND C.NIVEL_CODIGO        = AV.CODIGO_NIVEL
>    AND C.MATERIA_CODIGO      = AV.CODIGO_MATERIA
>    AND C.CICLO_ACAD_CODIGO   = AV.CODIGO_CICLO_ACAD
>    AND C.MODA_ESTUD_CODIGO   = AV.CODIGO_MOD_EST
>    AND C.SIST_ESTUD_CODIGO   = AV.CODIGO_SIS_EST
>    AND C.TCICLOACAD_CODIGO   = AV.CODIGO_TCICLO_ACAD
>    AND C.TFINANCIA_CODIGO    = AV.CODIGO_TIPO_FINANC
> WHERE AV.ID_CURSO = :ID_CURSO
> ORDER BY C.ITEM
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_CONTENIDOS_ACTIVIDAD
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/actividad
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_CONTENIDOS_ACTIVIDAD ("DESCRIPCION", "CODIGO", "ITEM", "ID_CURSO") AS
> SELECT
>     T.DESCRIPCION || ' ' || C.ITEM || ' ' || C.DESCRIPCION AS DESCRIPCION,
>     C.CODIGO,
>     C.ITEM,
>     AV.ID_CURSO
> FROM UTNDB.ACA_TAB_CONTENIDOS_MATERIAS C
> INNER JOIN UTNDB.ACA_TAB_TIPOS_CONTENIDOS T
>     ON C.TCONTENIDO_CODIGO = T.CODIGO
> INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES AV
>     ON C.INST_CODIGO         = AV.CODIGO_INSTITUCION
>    AND C.DEPEN_CODIGO        = AV.CODIGO_DEPENDENCIA
>    AND C.NIVEL_CODIGO        = AV.CODIGO_NIVEL
>    AND C.MATERIA_CODIGO      = AV.CODIGO_MATERIA
>    AND C.CICLO_ACAD_CODIGO   = AV.CODIGO_CICLO_ACAD
>    AND C.MODA_ESTUD_CODIGO   = AV.CODIGO_MOD_EST
>    AND C.SIST_ESTUD_CODIGO   = AV.CODIGO_SIS_EST
>    AND C.TCICLOACAD_CODIGO   = AV.CODIGO_TCICLO_ACAD
>    AND C.TFINANCIA_CODIGO    = AV.CODIGO_TIPO_FINANC
> ;
> ```

> [!example]- `MVL_VIEW_TIPOS_ACTIVIDAD` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `TIPOS_ACTIVIDAD_QUERY`. Passthrough de `LMS_TAB_TIPO_ACTIVIDAD`; la lógica de negocio del `WHERE`/`UNION` original se reconstruye en el `.ts`. Validada (MINUS 0/0).
>
> **Lo usa:** `src/modules/actividad/repository/queries/tipos-actividad-query.ts`
>
> **Antes** (`src/modules/actividad/repository/queries/tipos-actividad-query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const TIPOS_ACTIVIDAD_QUERY = `
> SELECT DESCRIPCION, CODIGO
> FROM UTNDB.LMS_TAB_TIPO_ACTIVIDAD
> WHERE ESTADO = 'A'
> AND (POLITICA_EVAL_CODIGO IS NULL)
> AND (CODIGO <> 7 AND :P316_CODIGO_TIPO_EVAL <> 35)
> OR (CODIGO = 7 AND :P316_CODIGO_TIPO_EVAL = 35)
> UNION
> SELECT DESCRIPCION, CODIGO
> FROM UTNDB.LMS_TAB_TIPO_ACTIVIDAD
> WHERE ESTADO = 'A'
> AND (POLITICA_EVAL_CODIGO = 35)
> AND :P316_CODIGO_TIPO_EVAL = 35
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_TIPOS_ACTIVIDAD
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/actividad
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_TIPOS_ACTIVIDAD ("DESCRIPCION", "CODIGO", "ESTADO", "POLITICA_EVAL_CODIGO") AS
> SELECT DESCRIPCION, CODIGO, ESTADO, POLITICA_EVAL_CODIGO
> FROM UTNDB.LMS_TAB_TIPO_ACTIVIDAD
> ;
> ```

> [!example]- `MVL_VIEW_PARCIALES_ACTIVIDAD` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** reemplaza `PARCIALES_QUERY`. V2, técnica de columna `NULL` para ramas de `UNION` con distinta dependencia del bind (ver nota de continuidad). Validada (MINUS 0/0).
>
> **Lo usa:** `src/modules/actividad/repository/queries/parciales.query.ts`, `src/modules/aula-virtual/repository/queries/parciales-materia.query.ts`
>
> **Antes** (`src/modules/actividad/repository/queries/parciales.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const PARCIALES_QUERY = `
> SELECT 'Primera Parcial' D,'N1' R FROM DUAL
> UNION
> SELECT 'Segunda Parcial' D,'N2' FROM ACA_TAB_REGLAS_NOTAS REG
> INNER JOIN LMS_TAB_AULAS_VIRTUALES AV ON (AV.CODIGO_DEPENDENCIA=REG.DEPEN_CODIGO AND AV.CODIGO_SIS_EST = REG.SIST_ESTUD_CODIGO)
> WHERE NOTA2_ACTIVA='S' AND AV.ID_CURSO= :P110_ID_CURSO
> UNION
> SELECT 'Tercera Parcial' D,'N3' FROM ACA_TAB_REGLAS_NOTAS REG
> INNER JOIN LMS_TAB_AULAS_VIRTUALES AV ON (AV.CODIGO_DEPENDENCIA=REG.DEPEN_CODIGO AND AV.CODIGO_SIS_EST = REG.SIST_ESTUD_CODIGO)
> WHERE NOTA3_ACTIVA='S' AND AV.ID_CURSO= :P110_ID_CURSO
> UNION
> SELECT 'Cuarta Parcial' D,'N4' FROM ACA_TAB_REGLAS_NOTAS REG
> INNER JOIN LMS_TAB_AULAS_VIRTUALES AV ON (AV.CODIGO_DEPENDENCIA=REG.DEPEN_CODIGO AND AV.CODIGO_SIS_EST = REG.SIST_ESTUD_CODIGO)
> WHERE NOTA4_ACTIVA='S' AND AV.ID_CURSO= :P110_ID_CURSO
> UNION
> SELECT 'Todo' D,'%' R FROM DUAL
> `;
> ```
>
> **Antes** (`src/modules/aula-virtual/repository/queries/parciales-materia.query.ts`, versión previa al commit `ccf22f4`):
>
> ```ts
> export const PARCIAL_MATERIA_QUERY = `
> SELECT 'Primera Parcial' D,'N1' R FROM DUAL
> UNION
> SELECT 'Segunda Parcial' D,'N2' FROM ACA_TAB_REGLAS_NOTAS REG
> INNER JOIN LMS_TAB_AULAS_VIRTUALES AV ON (AV.CODIGO_DEPENDENCIA=REG.DEPEN_CODIGO AND AV.CODIGO_SIS_EST = REG.SIST_ESTUD_CODIGO)
> WHERE NOTA2_ACTIVA='S' AND AV.ID_CURSO= :P110_ID_CURSO
> UNION
> SELECT 'Tercera Parcial' D,'N3' FROM ACA_TAB_REGLAS_NOTAS REG
> INNER JOIN LMS_TAB_AULAS_VIRTUALES AV ON (AV.CODIGO_DEPENDENCIA=REG.DEPEN_CODIGO AND AV.CODIGO_SIS_EST = REG.SIST_ESTUD_CODIGO)
> WHERE NOTA3_ACTIVA='S' AND AV.ID_CURSO= :P110_ID_CURSO
> UNION
> SELECT 'Cuarta Parcial' D,'N4' FROM ACA_TAB_REGLAS_NOTAS REG
> INNER JOIN LMS_TAB_AULAS_VIRTUALES AV ON (AV.CODIGO_DEPENDENCIA=REG.DEPEN_CODIGO AND AV.CODIGO_SIS_EST = REG.SIST_ESTUD_CODIGO)
> WHERE NOTA4_ACTIVA='S' AND AV.ID_CURSO= :P110_ID_CURSO
> UNION
> SELECT 'Todo' D,'%' R FROM DUAL
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_PARCIALES_ACTIVIDAD
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/actividad
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_PARCIALES_ACTIVIDAD ("D", "R", "ID_CURSO") AS
> SELECT 'Primera Parcial' D, 'N1' R, CAST(NULL AS NUMBER) ID_CURSO FROM DUAL
> UNION
> SELECT 'Segunda Parcial' D, 'N2' R, AV.ID_CURSO
> FROM UTNDB.ACA_TAB_REGLAS_NOTAS REG
> INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES AV ON (AV.CODIGO_DEPENDENCIA = REG.DEPEN_CODIGO AND AV.CODIGO_SIS_EST = REG.SIST_ESTUD_CODIGO)
> WHERE REG.NOTA2_ACTIVA = 'S'
> UNION
> SELECT 'Tercera Parcial' D, 'N3' R, AV.ID_CURSO
> FROM UTNDB.ACA_TAB_REGLAS_NOTAS REG
> INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES AV ON (AV.CODIGO_DEPENDENCIA = REG.DEPEN_CODIGO AND AV.CODIGO_SIS_EST = REG.SIST_ESTUD_CODIGO)
> WHERE REG.NOTA3_ACTIVA = 'S'
> UNION
> SELECT 'Cuarta Parcial' D, 'N4' R, AV.ID_CURSO
> FROM UTNDB.ACA_TAB_REGLAS_NOTAS REG
> INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES AV ON (AV.CODIGO_DEPENDENCIA = REG.DEPEN_CODIGO AND AV.CODIGO_SIS_EST = REG.SIST_ESTUD_CODIGO)
> WHERE REG.NOTA4_ACTIVA = 'S'
> UNION
> SELECT 'Todo' D, '%' R, CAST(NULL AS NUMBER) ID_CURSO FROM DUAL
> ;
> ```

> [!example]- `MVL_FUN_FORO_ACTIVIDAD` (función)
> **Resultado:** de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/foro_actividad.query.ts`, `src/modules/foro_online/repository/foro_online.repository.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/foro_actividad.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const GET_FORO_ACTIVIDAD_QUERY = `
>     SELECT
>         f.ID_FORO                                         AS "ID",
>         f.ID_FORO_PADRE                                   AS "ID_PADRE",
>         f.DESCRIPCION                                     AS "RESPUESTA",
>         f.ESTADO                                          AS "ESTADO",
>         f.FECHA_CREACION                                  AS "FECHA_CREACION",
>         COALESCE(f.PERSONA_CEDULA, SUBSTR(f.USUARIO_CREACION, 2)) AS "AUTOR_CEDULA",
>         CASE
>             WHEN COALESCE(f.PERSONA_CEDULA, SUBSTR(f.USUARIO_CREACION, 2)) = :cedula AND f.ESTADO = 'A' THEN 1
>             ELSE 0
>         END                                               AS "PUEDE_ELIMINAR"
>     FROM
>         UTNDB.LMS_TAB_FOROS f
>     WHERE
>         f.ID_ACTIVIDAD = :idActividad AND f.ESTADO IN ('A', 'I')
>     ORDER BY
>         f.FECHA_CREACION DESC, f.ID_FORO DESC
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_FUN_FORO_ACTIVIDAD
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_FUN_FORO_ACTIVIDAD')
> -- Usado por: src/modules/foro_online
>
> CREATE OR REPLACE FUNCTION MOVIL_UTN.MVL_FUN_FORO_ACTIVIDAD (
>     p_cedula       IN UTNDB.LMS_TAB_FOROS.PERSONA_CEDULA%TYPE,
>     p_id_actividad IN UTNDB.LMS_TAB_FOROS.ID_ACTIVIDAD%TYPE
> ) RETURN SYS_REFCURSOR
> AS
>     v_cursor SYS_REFCURSOR;
> BEGIN
>     OPEN v_cursor FOR
>         SELECT
>             f.ID_FORO                                                  AS "ID",
>             f.ID_FORO_PADRE                                            AS "ID_PADRE",
>             f.DESCRIPCION                                              AS "RESPUESTA",
>             f.ESTADO                                                   AS "ESTADO",
>             f.FECHA_CREACION                                           AS "FECHA_CREACION",
>             COALESCE(f.PERSONA_CEDULA, SUBSTR(f.USUARIO_CREACION, 2))  AS "AUTOR_CEDULA",
>             CASE
>                 WHEN COALESCE(f.PERSONA_CEDULA, SUBSTR(f.USUARIO_CREACION, 2)) = p_cedula
>                      AND f.ESTADO = 'A'
>                 THEN 1
>                 ELSE 0
>             END                                                        AS "PUEDE_ELIMINAR"
>         FROM
>             UTNDB.LMS_TAB_FOROS f
>         WHERE
>             f.ID_ACTIVIDAD = p_id_actividad AND f.ESTADO IN ('A', 'I')
>         ORDER BY
>             f.FECHA_CREACION DESC, f.ID_FORO DESC;
>     RETURN v_cursor;
> END MVL_FUN_FORO_ACTIVIDAD;
> /
> ```

> [!example]- `MVL_FUN_FORO_GENERAL` (función)
> **Resultado:** de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/foro_general.query.ts`, `src/modules/foro_online/repository/foro_online.repository.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/foro_general.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const GET_FORO_GENERAL_QUERY = `
>     SELECT
>         f.ID_FORO                                       AS "ID",
>         f.ID_FORO_PADRE                                   AS "ID_PADRE",
>         f.DESCRIPCION                                     AS "RESPUESTA",
>         f.FECHA_CREACION                                  AS "FECHA_CREACION",
>         f.ESTADO                                          AS "ESTADO",
>         COALESCE(f.PERSONA_CEDULA, SUBSTR(f.USUARIO_CREACION, 2)) AS "AUTOR_CEDULA",
>
>         CASE
>             WHEN COALESCE(f.PERSONA_CEDULA, SUBSTR(f.USUARIO_CREACION, 2)) = :cedula AND f.ESTADO = 'A'
>         THEN 1
>             ELSE 0
>         END                                               AS "PUEDE_ELIMINAR"
>
>     FROM
>         UTNDB.LMS_TAB_FOROS f
>     WHERE
>         f.ID_CURSO = :idCurso
>         AND f.MATERIA_CODIGO = :materiaCodigo
>         AND f.DEPEN_CODIGO = :depenCodigo
>         AND f.NIVEL_CODIGO = :nivelCodigo
>         AND f.CICLO_ACAD_CODIGO = :cicloAcadCodigo
>         AND f.MODA_ESTUD_CODIGO = :modaEstudCodigo
>         AND f.SIST_ESTUD_CODIGO = :sistEstudCodigo
>         AND f.TCICLOACAD_CODIGO = :tcicloacadCodigo
>         AND f.TFINANCIA_CODIGO = :tfinanciaCodigo
>         AND f.INST_CODIGO = :instCodigo
>         
>         AND f.TIPO = 'G' AND f.CODIGO = f.MATERIA_CODIGO
>         
>         AND f.ESTADO IN ('A', 'I')
>     ORDER BY f.FECHA_CREACION DESC, f.ID_FORO DESC
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_FUN_FORO_GENERAL
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_FUN_FORO_GENERAL')
> -- Usado por: src/modules/foro_online
>
> CREATE OR REPLACE FUNCTION MOVIL_UTN.MVL_FUN_FORO_GENERAL (
>     p_cedula            IN UTNDB.LMS_TAB_FOROS.PERSONA_CEDULA%TYPE,
>     p_id_curso          IN UTNDB.LMS_TAB_FOROS.ID_CURSO%TYPE,
>     p_materia_codigo    IN UTNDB.LMS_TAB_FOROS.MATERIA_CODIGO%TYPE,
>     p_depen_codigo      IN UTNDB.LMS_TAB_FOROS.DEPEN_CODIGO%TYPE,
>     p_nivel_codigo      IN UTNDB.LMS_TAB_FOROS.NIVEL_CODIGO%TYPE,
>     p_ciclo_acad_codigo IN UTNDB.LMS_TAB_FOROS.CICLO_ACAD_CODIGO%TYPE,
>     p_moda_estud_codigo IN UTNDB.LMS_TAB_FOROS.MODA_ESTUD_CODIGO%TYPE,
>     p_sist_estud_codigo IN UTNDB.LMS_TAB_FOROS.SIST_ESTUD_CODIGO%TYPE,
>     p_tcicloacad_codigo IN UTNDB.LMS_TAB_FOROS.TCICLOACAD_CODIGO%TYPE,
>     p_tfinancia_codigo  IN UTNDB.LMS_TAB_FOROS.TFINANCIA_CODIGO%TYPE,
>     p_inst_codigo       IN UTNDB.LMS_TAB_FOROS.INST_CODIGO%TYPE
> ) RETURN SYS_REFCURSOR
> AS
>     v_cursor SYS_REFCURSOR;
> BEGIN
>     OPEN v_cursor FOR
>         SELECT
>             f.ID_FORO                                                  AS "ID",
>             f.ID_FORO_PADRE                                            AS "ID_PADRE",
>             f.DESCRIPCION                                              AS "RESPUESTA",
>             f.FECHA_CREACION                                           AS "FECHA_CREACION",
>             f.ESTADO                                                   AS "ESTADO",
>             COALESCE(f.PERSONA_CEDULA, SUBSTR(f.USUARIO_CREACION, 2))  AS "AUTOR_CEDULA",
>             CASE
>                 WHEN COALESCE(f.PERSONA_CEDULA, SUBSTR(f.USUARIO_CREACION, 2)) = p_cedula
>                      AND f.ESTADO = 'A'
>                 THEN 1
>                 ELSE 0
>             END                                                        AS "PUEDE_ELIMINAR"
>         FROM
>             UTNDB.LMS_TAB_FOROS f
>         WHERE
>             f.ID_CURSO = p_id_curso
>             AND f.MATERIA_CODIGO = p_materia_codigo
>             AND f.DEPEN_CODIGO = p_depen_codigo
>             AND f.NIVEL_CODIGO = p_nivel_codigo
>             AND f.CICLO_ACAD_CODIGO = p_ciclo_acad_codigo
>             AND f.MODA_ESTUD_CODIGO = p_moda_estud_codigo
>             AND f.SIST_ESTUD_CODIGO = p_sist_estud_codigo
>             AND f.TCICLOACAD_CODIGO = p_tcicloacad_codigo
>             AND f.TFINANCIA_CODIGO = p_tfinancia_codigo
>             AND f.INST_CODIGO = p_inst_codigo
>             AND f.TIPO = 'G' AND f.CODIGO = f.MATERIA_CODIGO
>             AND f.ESTADO IN ('A', 'I')
>         ORDER BY f.FECHA_CREACION DESC, f.ID_FORO DESC;
>     RETURN v_cursor;
> END MVL_FUN_FORO_GENERAL;
> /
> ```

> [!example]- `MVL_PRC_FORO_ACTUALIZAR` (procedimiento)
> **Resultado:** de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/actualizar_foro.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/actualizar_foro.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const ACTUALIZAR_FORO_QUERY = `
>     UPDATE 
>         UTNDB.LMS_TAB_FOROS
>     SET
>         DESCRIPCION = :contenido
>     WHERE
>         ID_FORO = :idForo AND PERSONA_CEDULA = :cedula
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_PRC_FORO_ACTUALIZAR
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_PRC_FORO_ACTUALIZAR')
> -- Usado por: src/modules/foro_online
>
> CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_FORO_ACTUALIZAR (
>     p_contenido IN VARCHAR2,
>     p_id_foro IN NUMBER,
>     p_cedula IN VARCHAR2
> ) AS
> BEGIN
>     UPDATE UTNDB.LMS_TAB_FOROS
>     SET DESCRIPCION = p_contenido
>     WHERE ID_FORO = p_id_foro AND PERSONA_CEDULA = p_cedula;
> END MVL_PRC_FORO_ACTUALIZAR;
> /
> ```

> [!example]- `MVL_PRC_FORO_CREAR_RESPUESTA_ACTIVIDAD` (procedimiento)
> **Resultado:** de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/crear_respuesta_actividad.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/crear_respuesta_actividad.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const CREAR_FORO_ACTIVIDAD_QUERY = `
>     INSERT INTO UTNDB.LMS_TAB_FOROS (
>         ID_CURSO, CODIGO, INST_CODIGO, MODA_ESTUD_CODIGO, SIST_ESTUD_CODIGO,
>         TFINANCIA_CODIGO, TCICLOACAD_CODIGO, CICLO_ACAD_CODIGO, DEPEN_CODIGO,
>         MATERIA_CODIGO, NIVEL_CODIGO, TIPO, DESCRIPCION, ID_ACTIVIDAD,
>         USUARIO_CREACION, PERSONA_CEDULA, ID_FORO_PADRE
>     )
>     SELECT
>         a.ID_CURSO, a.CODIGO_CONTENIDO, a.INST_CODIGO, a.MODA_ESTUD_CODIGO, a.SIST_ESTUD_CODIGO,
>         a.TFINANCIA_CODIGO, a.TCICLOACAD_CODIGO, a.CICLO_ACAD_CODIGO, a.DEPEN_CODIGO,
>         a.MATERIA_CODIGO, a.NIVEL_CODIGO, 'C' AS TIPO, :contenido, :idActividad,
>         :cuenta, :cedula, :idPadre
>     FROM
>         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA a
>     WHERE
>         a.ID_ACTIVIDAD = :idActividad
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_PRC_FORO_CREAR_RESPUESTA_ACTIVIDAD
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=INVALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_PRC_FORO_CREAR_RESPUESTA_ACTIVIDAD')
> -- Usado por: src/modules/foro_online
>
> CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_FORO_CREAR_RESPUESTA_ACTIVIDAD (
>     p_contenido IN VARCHAR2,
>     p_id_actividad IN NUMBER,
>     p_cuenta IN VARCHAR2,
>     p_cedula IN VARCHAR2,
>     p_id_padre IN NUMBER
> ) AS
> BEGIN
>     INSERT INTO UTNDB.LMS_TAB_FOROS (
>         ID_CURSO, CODIGO, INST_CODIGO, MODA_ESTUD_CODIGO, SIST_ESTUD_CODIGO,
>         TFINANCIA_CODIGO, TCICLOACAD_CODIGO, CICLO_ACAD_CODIGO, DEPEN_CODIGO,
>         MATERIA_CODIGO, NIVEL_CODIGO, TIPO, DESCRIPCION, ID_ACTIVIDAD,
>         USUARIO_CREACION, PERSONA_CEDULA, ID_FORO_PADRE
>     )
>     SELECT
>         a.ID_CURSO, a.CODIGO_CONTENIDO, a.INST_CODIGO, a.MODA_ESTUD_CODIGO, a.SIST_ESTUD_CODIGO,
>         a.TFINANCIA_CODIGO, a.TCICLOACAD_CODIGO, a.CICLO_ACAD_CODIGO, a.DEPEN_CODIGO,
>         a.MATERIA_CODIGO, a.NIVEL_CODIGO, 'C' AS TIPO, p_contenido, p_id_actividad,
>         p_cuenta, p_cedula, p_id_padre
>     FROM
>         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA a
>     WHERE
>         a.ID_ACTIVIDAD = p_id_actividad;
> END MVL_PRC_FORO_CREAR_RESPUESTA_ACTIVIDAD;
> /
> ```

> [!example]- `MVL_PRC_FORO_CREAR_RESPUESTA_GENERAL` (procedimiento)
> **Resultado:** de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/crear_respuesta_general.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/crear_respuesta_general.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const CREAR_RESPUESTA_GENERAL_QUERY = `
>     INSERT INTO UTNDB.LMS_TAB_FOROS (
>         ID_CURSO, CODIGO, INST_CODIGO, MODA_ESTUD_CODIGO, SIST_ESTUD_CODIGO,
>         TFINANCIA_CODIGO, TCICLOACAD_CODIGO, CICLO_ACAD_CODIGO, DEPEN_CODIGO,
>         MATERIA_CODIGO, NIVEL_CODIGO, TIPO, DESCRIPCION, ID_ACTIVIDAD,
>         USUARIO_CREACION, PERSONA_CEDULA, ID_FORO_PADRE
>     ) VALUES (
>         :idCurso, :materiaCodigo, :instCodigo, :modaEstudCodigo, :sistEstudCodigo,
>         :tfinanciaCodigo, :tcicloacadCodigo, :cicloAcadCodigo, :depenCodigo,
>         :materiaCodigo, :nivelCodigo, 'G', :contenido, NULL,
>         :cuenta, :cedula, :idPadre
>     )
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_PRC_FORO_CREAR_RESPUESTA_GENERAL
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_PRC_FORO_CREAR_RESPUESTA_GENERAL')
> -- Usado por: src/modules/foro_online
>
> CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_FORO_CREAR_RESPUESTA_GENERAL (
>     p_id_curso IN NUMBER,
>     p_materia_codigo IN VARCHAR2,
>     p_inst_codigo IN VARCHAR2,
>     p_moda_estud_codigo IN VARCHAR2,
>     p_sist_estud_codigo IN VARCHAR2,
>     p_tfinancia_codigo IN VARCHAR2,
>     p_tciclo_acad_codigo IN VARCHAR2,
>     p_ciclo_acad_codigo IN VARCHAR2,
>     p_depen_codigo IN VARCHAR2,
>     p_nivel_codigo IN VARCHAR2,
>     p_contenido IN VARCHAR2,
>     p_cuenta IN VARCHAR2,
>     p_cedula IN VARCHAR2,
>     p_id_padre IN NUMBER
> ) AS
> BEGIN
>     INSERT INTO UTNDB.LMS_TAB_FOROS (
>         ID_CURSO, CODIGO, INST_CODIGO, MODA_ESTUD_CODIGO, SIST_ESTUD_CODIGO,
>         TFINANCIA_CODIGO, TCICLOACAD_CODIGO, CICLO_ACAD_CODIGO, DEPEN_CODIGO,
>         MATERIA_CODIGO, NIVEL_CODIGO, TIPO, DESCRIPCION, ID_ACTIVIDAD,
>         USUARIO_CREACION, PERSONA_CEDULA, ID_FORO_PADRE
>     ) VALUES (
>         p_id_curso, p_materia_codigo, p_inst_codigo, p_moda_estud_codigo, p_sist_estud_codigo,
>         p_tfinancia_codigo, p_tciclo_acad_codigo, p_ciclo_acad_codigo, p_depen_codigo,
>         p_materia_codigo, p_nivel_codigo, 'G', p_contenido, NULL,
>         p_cuenta, p_cedula, p_id_padre
>     );
> END MVL_PRC_FORO_CREAR_RESPUESTA_GENERAL;
> /
> ```

> [!example]- `MVL_PRC_FORO_ELIMINAR` (procedimiento)
> **Resultado:** de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/eliminar_foro.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/eliminar_foro.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const ELIMINAR_FORO_QUERY = `
>   UPDATE 
>     UTNDB.LMS_TAB_FOROS
>   SET ESTADO = 'I'
>   WHERE 
>     ID_FORO = :idForo 
>     AND PERSONA_CEDULA = :cedula
>     AND ESTADO = 'A'
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_PRC_FORO_ELIMINAR
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_PRC_FORO_ELIMINAR')
> -- Usado por: src/modules/foro_online
>
> CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_FORO_ELIMINAR (
>     p_id_foro IN NUMBER,
>     p_cedula IN VARCHAR2
> ) AS
> BEGIN
>     UPDATE UTNDB.LMS_TAB_FOROS
>     SET ESTADO = 'I'
>     WHERE ID_FORO = p_id_foro
>       AND PERSONA_CEDULA = p_cedula
>       AND ESTADO = 'A';
> END MVL_PRC_FORO_ELIMINAR;
> /
> ```

> [!example]- `MVL_VIEW_FORO_ACT_ESTADO` (vista)
> **Resultado:** de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/validar_actividad.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/validar_actividad.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const VALIDAR_ACTIVIDAD_QUERY = `
>     SELECT
>         ESTADO  AS "ESTADO",
>         FECHA_FIN AS "FECHA_FIN"
>     FROM
>         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA
>     WHERE
>         ID_ACTIVIDAD = :idActividad
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_FORO_ACT_ESTADO
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/foro_online
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_FORO_ACT_ESTADO ("ID_ACTIVIDAD", "ESTADO", "FECHA_FIN") AS
> SELECT
>     ID_ACTIVIDAD AS ID_ACTIVIDAD,
>     ESTADO       AS ESTADO,
>     FECHA_FIN    AS FECHA_FIN
> FROM
>     UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA
> ;
> ```

> [!example]- `MVL_VIEW_FORO_AUTORES` (vista)
> **Resultado:** de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/autores_foro.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/autores_foro.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const GET_AUTORES_FORO_QUERY = (count: number): string => {
>   const placeholders = Array.from({ length: count }, (_, i) => `:c${i}`).join(', ');
>   return `
>     SELECT
>         p.CEDULA                                          AS "CEDULA",
>         p.PRIMER_NOMBRE || ' ' || p.PRIMER_APELLIDO       AS "NOMBRE",
>         p.GENERO                                          AS "GENERO"
>     FROM UTNDB.RHU_TAB_PERSONAS p
>     WHERE p.CEDULA IN (${placeholders})
>   `;
> };
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_FORO_AUTORES
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/foro_online
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_FORO_AUTORES ("CEDULA", "NOMBRE", "GENERO") AS
> SELECT
>     p.CEDULA                                    AS CEDULA,
>     p.PRIMER_NOMBRE || ' ' || p.PRIMER_APELLIDO  AS NOMBRE,
>     p.GENERO                                    AS GENERO
> FROM
>     UTNDB.RHU_TAB_PERSONAS p
> ;
> ```

> [!example]- `MVL_VIEW_FORO_TIPO` (vista)
> **Resultado:** de punta a punta: curl real (GET, POST, PATCH, DELETE) y Oracle revisado antes y después
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/tipo_foro.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/tipo_foro.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const OBTENER_TIPO_FORO_QUERY = `
>   SELECT 
>     TIPO,
>     ID_ACTIVIDAD
>   FROM 
>     UTNDB.LMS_TAB_FOROS 
>   WHERE 
>     ID_FORO = :idForo
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_FORO_TIPO
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/foro_online
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_FORO_TIPO ("ID_FORO", "TIPO", "ID_ACTIVIDAD") AS
> SELECT
>     ID_FORO      AS ID_FORO,
>     TIPO         AS TIPO,
>     ID_ACTIVIDAD AS ID_ACTIVIDAD
> FROM
>     UTNDB.LMS_TAB_FOROS
> ;
> ```

> [!example]- `MVL_VIEW_ESTUDIANTES_EVAL_CUESTIONARIO` (vista)
> **Resultado:** sin prueba registrada por objeto
>
> **Lo usa:** `src/modules/actividad/repository/queries/evaluacion/estudiantes-evaluacion.query.ts`
>
> **Antes** (`src/modules/actividad/repository/queries/evaluacion/estudiantes-evaluacion.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const ESTUDIANTES_EVALUACION_N1_N2_QUERY = `
>     SELECT
>         p.CEDULA,
>         NOMBRES(p.CEDULA) AS NOMBRES,
>         p.GENERO
>     FROM UTNDB.RHU_TAB_PERSONAS p
>     WHERE EXISTS (
>         SELECT 1
>         FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>         WHERE pc.ESTUDIANTE_CEDULA = p.CEDULA
>         AND pc.CUESTIONARIO_CODIGO = :idActividad
>     )
>     AND UTNDB.LMS_FUN_MATRICULA_ACTIVA(:idCurso, p.CEDULA) > 0
>     ORDER BY NOMBRES
>     OFFSET :skip ROWS FETCH NEXT :limit ROWS ONLY
> `;
>
> export const COUNT_ESTUDIANTES_EVALUACION_N1_N2_QUERY = `
>     SELECT COUNT(*) AS TOTAL
>     FROM UTNDB.RHU_TAB_PERSONAS p
>     WHERE EXISTS (
>         SELECT 1
>         FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>         WHERE pc.ESTUDIANTE_CEDULA = p.CEDULA
>         AND pc.CUESTIONARIO_CODIGO = :idActividad
>     )
>     AND UTNDB.LMS_FUN_MATRICULA_ACTIVA(:idCurso, p.CEDULA) > 0
> `;
>
> export const ESTUDIANTES_EVALUACION_N3_N4_QUERY = `
> SELECT
>     p.CEDULA,
>     NOMBRES(p.CEDULA) AS NOMBRES,
>     p.GENERO
> FROM UTNDB.RHU_TAB_PERSONAS p
> WHERE EXISTS (
>     SELECT 1
>     FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>     INNER JOIN UTNDB.LMS_TAB_PREGUNTAS pre
>         ON pc.PREGUNTA_CODIGO = pre.CODIGO
>     INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS dm
>         ON dm.ESTUDIANTE_CEDULA = pc.ESTUDIANTE_CEDULA
>     INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES av
>         ON av.ID_CURSO = pre.CODIGO_AULA
>         AND dm.PARALELO_CODIGO = av.CODIGO_PARALELO
>         AND dm.MATERIA_CODIGO = av.CODIGO_MATERIA
>         AND dm.DOCENTE_CEDULA = av.CEDULA_DOCENTE
>         AND dm.MODA_ESTUD_CODIGO = av.CODIGO_MOD_EST
>         AND dm.SIST_ESTUD_CODIGO = av.CODIGO_SIS_EST
>         AND dm.DEPEN_CODIGO = av.CODIGO_DEPENDENCIA
>         AND dm.CICLO_ACAD_CODIGO = av.CODIGO_CICLO_ACAD
>         AND dm.NIVEL_CODIGO = av.CODIGO_NIVEL
>     INNER JOIN UTNDB.ACA_TAB_MATRICULAS m
>         ON dm.ESTUDIANTE_CEDULA = m.ESTUDIANTE_CEDULA
>         AND dm.MATRICULA_CODIGO = m.CODIGO
>     INNER JOIN UTNDB.ACA_TAB_NOTAS n
>         ON n.ESTUDIANTE_CEDULA = dm.ESTUDIANTE_CEDULA
>         AND n.MATRICULA_CODIGO = dm.MATRICULA_CODIGO
>         AND n.NIVEL_CODIGO = dm.NIVEL_CODIGO
>         AND n.MATERIA_CODIGO = dm.MATERIA_CODIGO
>         AND n.DEPEN_CODIGO = dm.DEPEN_CODIGO
>         AND n.INST_CODIGO = dm.INST_CODIGO
>         AND n.TFINANCIA_CODIGO = dm.TFINANCIA_CODIGO
>         AND n.MODA_ESTUD_CODIGO = dm.MODA_ESTUD_CODIGO
>         AND n.TCICLOACAD_CODIGO = dm.TCICLOACAD_CODIGO
>         AND n.SIST_ESTUD_CODIGO = dm.SIST_ESTUD_CODIGO
>         AND n.CICLO_ACAD_CODIGO = dm.CICLO_ACAD_CODIGO
>         AND n.PARALELO_CODIGO = dm.PARALELO_CODIGO
>         AND n.DOCENTE_CEDULA = dm.DOCENTE_CEDULA
>     WHERE pc.ESTUDIANTE_CEDULA = p.CEDULA
>       AND pc.CUESTIONARIO_CODIGO = :idActividad
>       AND m.ESTADO IN ('M', 'C', 'R')
>       AND dm.ANULACION != 'S'
>       AND dm.NUMERO_MATRICULA != '3'
>       AND (
>           (:tipoParcial = 'N3' AND n.RESULTADO1 >= 11 AND n.RESULTADO1 < 14)
>           OR (:tipoParcial = 'N4' AND n.RESULTADO1 >= 18 AND n.RESULTADO1 < 21)
>       )
> )
> ORDER BY NOMBRES
> OFFSET :skip ROWS FETCH NEXT :limit ROWS ONLY
> `;
>
> export const COUNT_ESTUDIANTES_EVALUACION_N3_N4_QUERY = `
> SELECT COUNT(*) AS TOTAL
> FROM UTNDB.RHU_TAB_PERSONAS p
> WHERE EXISTS (
>     SELECT 1
>     FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>     INNER JOIN UTNDB.LMS_TAB_PREGUNTAS pre
>         ON pc.PREGUNTA_CODIGO = pre.CODIGO
>     INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS dm
>         ON dm.ESTUDIANTE_CEDULA = pc.ESTUDIANTE_CEDULA
>     INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES av
>         ON av.ID_CURSO = pre.CODIGO_AULA
>         AND dm.PARALELO_CODIGO = av.CODIGO_PARALELO
>         AND dm.MATERIA_CODIGO = av.CODIGO_MATERIA
>         AND dm.DOCENTE_CEDULA = av.CEDULA_DOCENTE
>         AND dm.MODA_ESTUD_CODIGO = av.CODIGO_MOD_EST
>         AND dm.SIST_ESTUD_CODIGO = av.CODIGO_SIS_EST
>         AND dm.DEPEN_CODIGO = av.CODIGO_DEPENDENCIA
>         AND dm.CICLO_ACAD_CODIGO = av.CODIGO_CICLO_ACAD
>         AND dm.NIVEL_CODIGO = av.CODIGO_NIVEL
>     INNER JOIN UTNDB.ACA_TAB_MATRICULAS m
>         ON dm.ESTUDIANTE_CEDULA = m.ESTUDIANTE_CEDULA
>         AND dm.MATRICULA_CODIGO = m.CODIGO
>     INNER JOIN UTNDB.ACA_TAB_NOTAS n
>         ON n.ESTUDIANTE_CEDULA = dm.ESTUDIANTE_CEDULA
>         AND n.MATRICULA_CODIGO = dm.MATRICULA_CODIGO
>         AND n.NIVEL_CODIGO = dm.NIVEL_CODIGO
>         AND n.MATERIA_CODIGO = dm.MATERIA_CODIGO
>         AND n.DEPEN_CODIGO = dm.DEPEN_CODIGO
>         AND n.INST_CODIGO = dm.INST_CODIGO
>         AND n.TFINANCIA_CODIGO = dm.TFINANCIA_CODIGO
>         AND n.MODA_ESTUD_CODIGO = dm.MODA_ESTUD_CODIGO
>         AND n.TCICLOACAD_CODIGO = dm.TCICLOACAD_CODIGO
>         AND n.SIST_ESTUD_CODIGO = dm.SIST_ESTUD_CODIGO
>         AND n.CICLO_ACAD_CODIGO = dm.CICLO_ACAD_CODIGO
>         AND n.PARALELO_CODIGO = dm.PARALELO_CODIGO
>         AND n.DOCENTE_CEDULA = dm.DOCENTE_CEDULA
>     WHERE pc.ESTUDIANTE_CEDULA = p.CEDULA
>       AND pc.CUESTIONARIO_CODIGO = :idActividad
>       AND m.ESTADO IN ('M', 'C', 'R')
>       AND dm.ANULACION != 'S'
>       AND dm.NUMERO_MATRICULA != '3'
>       AND (
>           (:tipoParcial = 'N3' AND n.RESULTADO1 >= 11 AND n.RESULTADO1 < 14)
>           OR (:tipoParcial = 'N4' AND n.RESULTADO1 >= 18 AND n.RESULTADO1 < 21)
>       )
> )
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_ESTUDIANTES_EVAL_CUESTIONARIO
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/actividad
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_ESTUDIANTES_EVAL_CUESTIONARIO ("CUESTIONARIO_CODIGO", "CEDULA", "NOMBRES", "GENERO") AS
> SELECT DISTINCT
>   pc.CUESTIONARIO_CODIGO,
>   p.CEDULA,
>   NOMBRES(p.CEDULA) AS NOMBRES,
>   p.GENERO
> FROM UTNDB.RHU_TAB_PERSONAS p
> JOIN UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>   ON pc.ESTUDIANTE_CEDULA = p.CEDULA
> ;
> ```

> [!example]- `MVL_VIEW_ESTUDIANTES_EVAL_NOTAS` (vista)
> **Resultado:** sin prueba registrada por objeto
>
> **Lo usa:** `src/modules/actividad/repository/queries/evaluacion/estudiantes-evaluacion.query.ts`
>
> **Antes** (`src/modules/actividad/repository/queries/evaluacion/estudiantes-evaluacion.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const ESTUDIANTES_EVALUACION_N1_N2_QUERY = `
>     SELECT
>         p.CEDULA,
>         NOMBRES(p.CEDULA) AS NOMBRES,
>         p.GENERO
>     FROM UTNDB.RHU_TAB_PERSONAS p
>     WHERE EXISTS (
>         SELECT 1
>         FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>         WHERE pc.ESTUDIANTE_CEDULA = p.CEDULA
>         AND pc.CUESTIONARIO_CODIGO = :idActividad
>     )
>     AND UTNDB.LMS_FUN_MATRICULA_ACTIVA(:idCurso, p.CEDULA) > 0
>     ORDER BY NOMBRES
>     OFFSET :skip ROWS FETCH NEXT :limit ROWS ONLY
> `;
>
> export const COUNT_ESTUDIANTES_EVALUACION_N1_N2_QUERY = `
>     SELECT COUNT(*) AS TOTAL
>     FROM UTNDB.RHU_TAB_PERSONAS p
>     WHERE EXISTS (
>         SELECT 1
>         FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>         WHERE pc.ESTUDIANTE_CEDULA = p.CEDULA
>         AND pc.CUESTIONARIO_CODIGO = :idActividad
>     )
>     AND UTNDB.LMS_FUN_MATRICULA_ACTIVA(:idCurso, p.CEDULA) > 0
> `;
>
> export const ESTUDIANTES_EVALUACION_N3_N4_QUERY = `
> SELECT
>     p.CEDULA,
>     NOMBRES(p.CEDULA) AS NOMBRES,
>     p.GENERO
> FROM UTNDB.RHU_TAB_PERSONAS p
> WHERE EXISTS (
>     SELECT 1
>     FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>     INNER JOIN UTNDB.LMS_TAB_PREGUNTAS pre
>         ON pc.PREGUNTA_CODIGO = pre.CODIGO
>     INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS dm
>         ON dm.ESTUDIANTE_CEDULA = pc.ESTUDIANTE_CEDULA
>     INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES av
>         ON av.ID_CURSO = pre.CODIGO_AULA
>         AND dm.PARALELO_CODIGO = av.CODIGO_PARALELO
>         AND dm.MATERIA_CODIGO = av.CODIGO_MATERIA
>         AND dm.DOCENTE_CEDULA = av.CEDULA_DOCENTE
>         AND dm.MODA_ESTUD_CODIGO = av.CODIGO_MOD_EST
>         AND dm.SIST_ESTUD_CODIGO = av.CODIGO_SIS_EST
>         AND dm.DEPEN_CODIGO = av.CODIGO_DEPENDENCIA
>         AND dm.CICLO_ACAD_CODIGO = av.CODIGO_CICLO_ACAD
>         AND dm.NIVEL_CODIGO = av.CODIGO_NIVEL
>     INNER JOIN UTNDB.ACA_TAB_MATRICULAS m
>         ON dm.ESTUDIANTE_CEDULA = m.ESTUDIANTE_CEDULA
>         AND dm.MATRICULA_CODIGO = m.CODIGO
>     INNER JOIN UTNDB.ACA_TAB_NOTAS n
>         ON n.ESTUDIANTE_CEDULA = dm.ESTUDIANTE_CEDULA
>         AND n.MATRICULA_CODIGO = dm.MATRICULA_CODIGO
>         AND n.NIVEL_CODIGO = dm.NIVEL_CODIGO
>         AND n.MATERIA_CODIGO = dm.MATERIA_CODIGO
>         AND n.DEPEN_CODIGO = dm.DEPEN_CODIGO
>         AND n.INST_CODIGO = dm.INST_CODIGO
>         AND n.TFINANCIA_CODIGO = dm.TFINANCIA_CODIGO
>         AND n.MODA_ESTUD_CODIGO = dm.MODA_ESTUD_CODIGO
>         AND n.TCICLOACAD_CODIGO = dm.TCICLOACAD_CODIGO
>         AND n.SIST_ESTUD_CODIGO = dm.SIST_ESTUD_CODIGO
>         AND n.CICLO_ACAD_CODIGO = dm.CICLO_ACAD_CODIGO
>         AND n.PARALELO_CODIGO = dm.PARALELO_CODIGO
>         AND n.DOCENTE_CEDULA = dm.DOCENTE_CEDULA
>     WHERE pc.ESTUDIANTE_CEDULA = p.CEDULA
>       AND pc.CUESTIONARIO_CODIGO = :idActividad
>       AND m.ESTADO IN ('M', 'C', 'R')
>       AND dm.ANULACION != 'S'
>       AND dm.NUMERO_MATRICULA != '3'
>       AND (
>           (:tipoParcial = 'N3' AND n.RESULTADO1 >= 11 AND n.RESULTADO1 < 14)
>           OR (:tipoParcial = 'N4' AND n.RESULTADO1 >= 18 AND n.RESULTADO1 < 21)
>       )
> )
> ORDER BY NOMBRES
> OFFSET :skip ROWS FETCH NEXT :limit ROWS ONLY
> `;
>
> export const COUNT_ESTUDIANTES_EVALUACION_N3_N4_QUERY = `
> SELECT COUNT(*) AS TOTAL
> FROM UTNDB.RHU_TAB_PERSONAS p
> WHERE EXISTS (
>     SELECT 1
>     FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>     INNER JOIN UTNDB.LMS_TAB_PREGUNTAS pre
>         ON pc.PREGUNTA_CODIGO = pre.CODIGO
>     INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS dm
>         ON dm.ESTUDIANTE_CEDULA = pc.ESTUDIANTE_CEDULA
>     INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES av
>         ON av.ID_CURSO = pre.CODIGO_AULA
>         AND dm.PARALELO_CODIGO = av.CODIGO_PARALELO
>         AND dm.MATERIA_CODIGO = av.CODIGO_MATERIA
>         AND dm.DOCENTE_CEDULA = av.CEDULA_DOCENTE
>         AND dm.MODA_ESTUD_CODIGO = av.CODIGO_MOD_EST
>         AND dm.SIST_ESTUD_CODIGO = av.CODIGO_SIS_EST
>         AND dm.DEPEN_CODIGO = av.CODIGO_DEPENDENCIA
>         AND dm.CICLO_ACAD_CODIGO = av.CODIGO_CICLO_ACAD
>         AND dm.NIVEL_CODIGO = av.CODIGO_NIVEL
>     INNER JOIN UTNDB.ACA_TAB_MATRICULAS m
>         ON dm.ESTUDIANTE_CEDULA = m.ESTUDIANTE_CEDULA
>         AND dm.MATRICULA_CODIGO = m.CODIGO
>     INNER JOIN UTNDB.ACA_TAB_NOTAS n
>         ON n.ESTUDIANTE_CEDULA = dm.ESTUDIANTE_CEDULA
>         AND n.MATRICULA_CODIGO = dm.MATRICULA_CODIGO
>         AND n.NIVEL_CODIGO = dm.NIVEL_CODIGO
>         AND n.MATERIA_CODIGO = dm.MATERIA_CODIGO
>         AND n.DEPEN_CODIGO = dm.DEPEN_CODIGO
>         AND n.INST_CODIGO = dm.INST_CODIGO
>         AND n.TFINANCIA_CODIGO = dm.TFINANCIA_CODIGO
>         AND n.MODA_ESTUD_CODIGO = dm.MODA_ESTUD_CODIGO
>         AND n.TCICLOACAD_CODIGO = dm.TCICLOACAD_CODIGO
>         AND n.SIST_ESTUD_CODIGO = dm.SIST_ESTUD_CODIGO
>         AND n.CICLO_ACAD_CODIGO = dm.CICLO_ACAD_CODIGO
>         AND n.PARALELO_CODIGO = dm.PARALELO_CODIGO
>         AND n.DOCENTE_CEDULA = dm.DOCENTE_CEDULA
>     WHERE pc.ESTUDIANTE_CEDULA = p.CEDULA
>       AND pc.CUESTIONARIO_CODIGO = :idActividad
>       AND m.ESTADO IN ('M', 'C', 'R')
>       AND dm.ANULACION != 'S'
>       AND dm.NUMERO_MATRICULA != '3'
>       AND (
>           (:tipoParcial = 'N3' AND n.RESULTADO1 >= 11 AND n.RESULTADO1 < 14)
>           OR (:tipoParcial = 'N4' AND n.RESULTADO1 >= 18 AND n.RESULTADO1 < 21)
>       )
> )
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_ESTUDIANTES_EVAL_NOTAS
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/actividad
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_ESTUDIANTES_EVAL_NOTAS ("CUESTIONARIO_CODIGO", "CEDULA", "NOMBRES", "GENERO", "CUMPLE_N3", "CUMPLE_N4") AS
> SELECT
>   pc.CUESTIONARIO_CODIGO,
>   p.CEDULA,
>   NOMBRES(p.CEDULA) AS NOMBRES,
>   p.GENERO,
>   MAX(CASE WHEN n.RESULTADO1 >= 11 AND n.RESULTADO1 < 14 THEN 1 ELSE 0 END) AS CUMPLE_N3,
>   MAX(CASE WHEN n.RESULTADO1 >= 18 AND n.RESULTADO1 < 21 THEN 1 ELSE 0 END) AS CUMPLE_N4
> FROM UTNDB.RHU_TAB_PERSONAS p
> JOIN UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>   ON pc.ESTUDIANTE_CEDULA = p.CEDULA
> JOIN UTNDB.LMS_TAB_PREGUNTAS pre
>   ON pc.PREGUNTA_CODIGO = pre.CODIGO
> JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS dm
>   ON dm.ESTUDIANTE_CEDULA = pc.ESTUDIANTE_CEDULA
> JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES av
>   ON av.ID_CURSO = pre.CODIGO_AULA
>  AND dm.PARALELO_CODIGO = av.CODIGO_PARALELO
>  AND dm.MATERIA_CODIGO = av.CODIGO_MATERIA
>  AND dm.DOCENTE_CEDULA = av.CEDULA_DOCENTE
>  AND dm.MODA_ESTUD_CODIGO = av.CODIGO_MOD_EST
>  AND dm.SIST_ESTUD_CODIGO = av.CODIGO_SIS_EST
>  AND dm.DEPEN_CODIGO = av.CODIGO_DEPENDENCIA
>  AND dm.CICLO_ACAD_CODIGO = av.CODIGO_CICLO_ACAD
>  AND dm.NIVEL_CODIGO = av.CODIGO_NIVEL
> JOIN UTNDB.ACA_TAB_MATRICULAS m
>   ON dm.ESTUDIANTE_CEDULA = m.ESTUDIANTE_CEDULA
>  AND dm.MATRICULA_CODIGO = m.CODIGO
> JOIN UTNDB.ACA_TAB_NOTAS n
>   ON n.ESTUDIANTE_CEDULA = dm.ESTUDIANTE_CEDULA
>  AND n.MATRICULA_CODIGO = dm.MATRICULA_CODIGO
>  AND n.NIVEL_CODIGO = dm.NIVEL_CODIGO
>  AND n.MATERIA_CODIGO = dm.MATERIA_CODIGO
>  AND n.DEPEN_CODIGO = dm.DEPEN_CODIGO
>  AND n.INST_CODIGO = dm.INST_CODIGO
>  AND n.TFINANCIA_CODIGO = dm.TFINANCIA_CODIGO
>  AND n.MODA_ESTUD_CODIGO = dm.MODA_ESTUD_CODIGO
>  AND n.TCICLOACAD_CODIGO = dm.TCICLOACAD_CODIGO
>  AND n.SIST_ESTUD_CODIGO = dm.SIST_ESTUD_CODIGO
>  AND n.CICLO_ACAD_CODIGO = dm.CICLO_ACAD_CODIGO
>  AND n.PARALELO_CODIGO = dm.PARALELO_CODIGO
>  AND n.DOCENTE_CEDULA = dm.DOCENTE_CEDULA
> WHERE m.ESTADO IN ('M', 'C', 'R')
>   AND dm.ANULACION != 'S'
>   AND dm.NUMERO_MATRICULA != '3'
> GROUP BY pc.CUESTIONARIO_CODIGO, p.CEDULA, NOMBRES(p.CEDULA), p.GENERO
> ;
> ```

> [!example]- `MVL_VIEW_POLITICAS_EVALUACION` (vista)
> **Resultado:** sin prueba registrada por objeto
>
> **Lo usa:** `src/modules/actividad/repository/actividad.repository.ts`, `src/modules/actividad/repository/queries/politicas-evaluacion.query.ts`
>
> **Antes** (`src/modules/actividad/repository/queries/politicas-evaluacion.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const POLITICAS_EVALUACION_QUERY = `
> SELECT
>   CASE :CODIGO_PARCIAL
>     WHEN 'N1' THEN TE.DESCRIPCION || ' (' || PE.PORCENTAJE_N1 || '%)'
>     WHEN 'N2' THEN TE.DESCRIPCION || ' (' || PE.PORCENTAJE_N2 || '%)'
>     WHEN 'N3' THEN TE.DESCRIPCION || ' (' || PE.PORCENTAJE_N3 || '%)'
>     WHEN 'N4' THEN TE.DESCRIPCION || ' (' || PE.PORCENTAJE_N4 || '%)'
>     WHEN 'N5' THEN TE.DESCRIPCION || ' (' || PE.PORCENTAJE_N5 || '%)'
>   END AS DESCRIPCION,
>   TE.CODIGO
> FROM LMS_TAB_AULAS_VIRTUALES AV
> JOIN ACA_TAB_PORCENTAJES_EVAL PE
>   ON PE.MATERIA_CODIGO    = AV.CODIGO_MATERIA
>  AND PE.NIVEL_CODIGO      = AV.CODIGO_NIVEL
>  AND PE.MODA_ESTUD_CODIGO = AV.CODIGO_MOD_EST
>  AND PE.CICLO_ACAD_CODIGO = AV.CODIGO_CICLO_ACAD
> JOIN ACA_TAB_TIPOS_PORCENTAJE_EVAL TE
>   ON PE.TIPO_EVAL_CODIGO = TE.CODIGO
> WHERE AV.ID_CURSO = :ID_CURSO
>   AND (
>        -- 1) condiciones por parcial
>        (PE.PORCENTAJE_N1 > 0 AND :CODIGO_PARCIAL = 'N1')
>     OR (PE.PORCENTAJE_N2 > 0 AND :CODIGO_PARCIAL = 'N2')
>     OR (PE.PORCENTAJE_N3 > 0 AND :CODIGO_PARCIAL = 'N3')
>     OR (PE.PORCENTAJE_N4 > 0 AND :CODIGO_PARCIAL = 'N4')
>     OR (PE.PORCENTAJE_N5 > 0 AND :CODIGO_PARCIAL = 'N5')
>        -- 2) tipo 35 siempre visible independiente del parcial
>     OR (TE.CODIGO = 35)
>        -- 3) tipo "42" (Clase Asincrónica 0%) sólo en N1 y si la facultad es '00006' (Postgrado)
>     OR (
>          TE.CODIGO = 42
>       AND :CODIGO_PARCIAL = 'N1'
>       AND (
>         SELECT D2.CODIGO
>           FROM ACA_TAB_DEPENDENCIAS D
>           JOIN ACA_TAB_DEPENDENCIAS D1 ON D1.CODIGO = D.DEPEN_CODIGO
>           JOIN ACA_TAB_DEPENDENCIAS D2 ON D2.CODIGO = D1.DEPEN_CODIGO
>          WHERE D.CODIGO = AV.CODIGO_DEPENDENCIA
>       ) = '00006'
>     )
>   )
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_POLITICAS_EVALUACION
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/actividad
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_POLITICAS_EVALUACION ("ID_CURSO", "CODIGO", "DESCRIPCION", "PORCENTAJE_N1", "PORCENTAJE_N2", "PORCENTAJE_N3", "PORCENTAJE_N4", "PORCENTAJE_N5", "ES_FACULTAD_POSTGRADO") AS
> SELECT
>     AV.ID_CURSO,
>     TE.CODIGO,
>     TE.DESCRIPCION,
>     PE.PORCENTAJE_N1, PE.PORCENTAJE_N2, PE.PORCENTAJE_N3, PE.PORCENTAJE_N4, PE.PORCENTAJE_N5,
>     CASE WHEN (
>         SELECT D2.CODIGO
>           FROM UTNDB.ACA_TAB_DEPENDENCIAS D
>           JOIN UTNDB.ACA_TAB_DEPENDENCIAS D1 ON D1.CODIGO = D.DEPEN_CODIGO
>           JOIN UTNDB.ACA_TAB_DEPENDENCIAS D2 ON D2.CODIGO = D1.DEPEN_CODIGO
>          WHERE D.CODIGO = AV.CODIGO_DEPENDENCIA
>     ) = '00006' THEN 1 ELSE 0 END AS ES_FACULTAD_POSTGRADO
> FROM UTNDB.LMS_TAB_AULAS_VIRTUALES AV
> JOIN UTNDB.ACA_TAB_PORCENTAJES_EVAL PE
>     ON PE.MATERIA_CODIGO = AV.CODIGO_MATERIA
>    AND PE.NIVEL_CODIGO = AV.CODIGO_NIVEL
>    AND PE.MODA_ESTUD_CODIGO = AV.CODIGO_MOD_EST
>    AND PE.CICLO_ACAD_CODIGO = AV.CODIGO_CICLO_ACAD
> JOIN UTNDB.ACA_TAB_TIPOS_PORCENTAJE_EVAL TE
>     ON PE.TIPO_EVAL_CODIGO = TE.CODIGO
> ;
> ```

> [!example]- `MVL_VIEW_PREGUNTAS_EVAL_ESTUDIANTES` (vista)
> **Resultado:** sin prueba registrada por objeto
>
> **Lo usa:** `src/modules/actividad/repository/queries/evaluacion/preguntas-evaluacion.query.ts`
>
> **Antes** (`src/modules/actividad/repository/queries/evaluacion/preguntas-evaluacion.query.ts`, versión previa al commit `f2b24ea`):
>
> ```ts
> export const PREGUNTAS_EVALUACION_ESTUDIANTE_QUERY = `
>     SELECT
>         pc.SUB_ID AS NRO_PREGUNTA,
>         pre.CODIGO AS CODIGO_PREGUNTA,
>         pre.PREGUNTA_HTML AS ENUNCIADO_HTML,
>         pre.NIVEL_DIFICULTAD,
>         tp.NOMBRE AS TIPO_PREGUNTA
>     FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>     INNER JOIN UTNDB.LMS_TAB_PREGUNTAS pre
>         ON pc.PREGUNTA_CODIGO = pre.CODIGO
>     INNER JOIN UTNDB.LMS_TAB_TIPO_PREGUNTA tp
>         ON pre.COD_TIPO_PREGUNTA = tp.CODIGO
>     WHERE pc.CUESTIONARIO_CODIGO = :idActividad
>     AND pc.ESTUDIANTE_CEDULA = :cedulaEstudiante
>     ORDER BY NRO_PREGUNTA
> `;
>
> export const PREGUNTAS_EVALUACION_ESTUDIANTES_QUERY = (cedulas: string[]): string => `
>     SELECT
>         pc.ESTUDIANTE_CEDULA AS CEDULA,
>         pc.SUB_ID AS NRO_PREGUNTA,
>         pre.CODIGO AS CODIGO_PREGUNTA,
>         pre.PREGUNTA_HTML AS ENUNCIADO_HTML,
>         pre.NIVEL_DIFICULTAD,
>         tp.NOMBRE AS TIPO_PREGUNTA
>     FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>     INNER JOIN UTNDB.LMS_TAB_PREGUNTAS pre
>         ON pc.PREGUNTA_CODIGO = pre.CODIGO
>     INNER JOIN UTNDB.LMS_TAB_TIPO_PREGUNTA tp
>         ON pre.COD_TIPO_PREGUNTA = tp.CODIGO
>     WHERE pc.CUESTIONARIO_CODIGO = :idActividad
>     AND pc.ESTUDIANTE_CEDULA IN (${cedulas.map(c => `'${c}'`).join(', ')})
>     ORDER BY pc.ESTUDIANTE_CEDULA, pc.SUB_ID
> `;
>
> export const COUNT_PREGUNTAS_ASIGNADAS_EVALUACION_QUERY = `
>     SELECT
>         NUM_PREG_EA AS COUNT_PREGUNTAS
>     FROM
>         LMS_TAB_ACTIVIDAD_ACADEMICA
>     WHERE
>         ID_ACTIVIDAD = :idActividad
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_PREGUNTAS_EVAL_ESTUDIANTES
> -- Obtenido: 2026-09-25, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/actividad
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_PREGUNTAS_EVAL_ESTUDIANTES ("CUESTIONARIO_CODIGO", "CEDULA", "NRO_PREGUNTA", "CODIGO_PREGUNTA", "ENUNCIADO_HTML", "NIVEL_DIFICULTAD", "TIPO_PREGUNTA") AS
> SELECT
>   pc.CUESTIONARIO_CODIGO,
>   pc.ESTUDIANTE_CEDULA AS CEDULA,
>   pc.SUB_ID AS NRO_PREGUNTA,
>   pre.CODIGO AS CODIGO_PREGUNTA,
>   pre.PREGUNTA_HTML AS ENUNCIADO_HTML,
>   pre.NIVEL_DIFICULTAD,
>   tp.NOMBRE AS TIPO_PREGUNTA
> FROM UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
> INNER JOIN UTNDB.LMS_TAB_PREGUNTAS pre
>   ON pc.PREGUNTA_CODIGO = pre.CODIGO
> INNER JOIN UTNDB.LMS_TAB_TIPO_PREGUNTA tp
>   ON pre.COD_TIPO_PREGUNTA = tp.CODIGO
> ;
> ```
