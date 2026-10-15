# Estudiante — migración de queries a objetos de MOVIL_UTN

- **Repo:** `utn-movil-portafolio-estudiante`, rama `practicas-preprofesionales`
- **Commits:** `18138f6` (2026-09-16, el código pasa a usar los objetos) · `1153a49` (2026-09-24, scripts en `db/dbscripts/`)
- **Objetos:** 53 — 26 vistas, 13 funciones y 14 procedimientos
- **En la base de desarrollo:** los 53 existen en `MOVIL_UTN` (comprobado con el MCP de estructura el 2026-10-14).
- **Producción:** no verificado; el MCP solo ve la réplica de desarrollo.

## Por qué

El SQL estaba escrito dentro de los `.ts`. Si el DBA cambia una tabla o una columna, el microservicio se entera recién cuando un estudiante abre la pantalla. Con el objeto en Oracle, el cambio lo deja **inválido en la base** y se ve antes; además la consulta queda en un solo lugar.

- **Vista** (`MVL_VIEW_*`): cuando el parámetro solo filtra el resultado. El `WHERE` con los binds se queda en el `.ts`.
- **Función** (`MVL_FUN_*`, devuelve `SYS_REFCURSOR`): cuando el parámetro va dentro de la consulta (subconsulta, `CONNECT BY`, agregados).
- **Procedimiento** (`MVL_PRC_*`): las escrituras (`INSERT`/`UPDATE`/bloques PL/SQL).

## Cómo se validó

| Tipo | Prueba | Resultado |
|---|---|---|
| Vista | consulta original con valores reales `MINUS` la vista, en los dos sentidos | sin diferencias en las 26 |
| Función | comparación fila a fila contra la consulta original (un cursor no admite `MINUS`) | igual en las 13 |
| Procedimiento | llamada real al servicio con `curl` y estado de la tabla en Oracle antes y después | confirmado en los 14 |

Cada objeto está registrado como `Q1`–`Q53` con su prueba en [[00_Indice_Resumen]]. Las columnas `CLOB`/`BLOB` se compararon con `DBMS_LOB.SUBSTR` / `DBMS_LOB.COMPARE`, porque `MINUS` no las admite.

## Objetos

| Registro | Objeto | Tipo | Módulo | En dev | Prueba |
|---|---|---|---|---|---|
| Q1 | `MVL_VIEW_FORO_TIPO` | vista | foro_online | sí | MINUS en los dos sentidos: 0 diferencias |
| Q2 | `MVL_VIEW_FORO_ACT_ESTADO` | vista | foro_online | sí | MINUS en los dos sentidos: 0 diferencias |
| Q3 | `MVL_VIEW_FORO_AUTORES` | vista | foro_online | sí | MINUS en los dos sentidos: 0 diferencias |
| Q4 | `MVL_VIEW_FORO_INSTRUC_ACT` | vista | foro_online | sí | MINUS en los dos sentidos: 0 diferencias |
| Q5 | `MVL_FUN_FORO_ACTIVIDAD` | función | foro_online | sí | comparación fila a fila: igual al original |
| Q6 | `MVL_FUN_FORO_GENERAL` | función | foro_online | sí | comparación fila a fila: igual al original |
| Q8 | `MVL_VIEW_INFO_TAREA` | vista | actividades | sí | MINUS en los dos sentidos: 0 diferencias |
| Q9 | `MVL_VIEW_ARCHIVO_DIRECTORIO` | vista | documentos_directorio | sí | MINUS en los dos sentidos: 0 diferencias |
| Q10 | `MVL_FUN_FICHA_ESTUDIANTE` | función | ficha_estudiante | sí | comparación fila a fila: igual al original |
| Q11 | `MVL_VIEW_COMUNICADO_DETALLE` | vista | comunicados | sí | MINUS en los dos sentidos: 0 diferencias |
| Q12 | `MVL_VIEW_ENCUESTA_PREGUNTAS` | vista | comunicados | sí | MINUS en los dos sentidos: 0 diferencias |
| Q13 | `MVL_VIEW_CERTIFICADOS_EVENTOS` | vista | documentos | sí | MINUS en los dos sentidos: 0 diferencias |
| Q14 | `MVL_VIEW_FORMATOS_VINCULACION` | vista | documentos | sí | MINUS en los dos sentidos: 0 diferencias |
| Q15 | `MVL_VIEW_HISTORIAL_CERTIFICADOS` | vista | documentos | sí | MINUS en los dos sentidos: 0 diferencias |
| Q16 | `MVL_VIEW_MATRICULA_CICLO_ACTIVO` | vista | documentos | sí | MINUS en los dos sentidos: 0 diferencias |
| Q17 | `MVL_VIEW_CARRERAS_ESTUDIANTE` | vista | documentos | sí | MINUS en los dos sentidos: 0 diferencias |
| Q18 | `MVL_VIEW_ESTUDIANTE_POSGRADO` | vista | documentos | sí | MINUS en los dos sentidos: 0 diferencias |
| Q19 | `MVL_FUN_DOC_ELECTRONICOS` | función | documentos | sí | comparación fila a fila: igual al original |
| Q20 | `MVL_FUN_DOC_POSGRADO` | función | documentos | sí | comparación fila a fila: igual al original |
| Q21 | `MVL_FUN_COM_PENDIENTES` | función | comunicados | sí | comparación fila a fila: igual al original |
| Q22 | `MVL_FUN_MODAL_ACTUAL` | función | modales_informativos | sí | comparación fila a fila: igual al original |
| Q23 | `MVL_FUN_PAGOS_ESTUDIANTE` | función | pagos | sí | comparación fila a fila: igual al original |
| Q24 | `MVL_VIEW_FACULTAD_POSTGRADO` | vista | validacion_acceso | sí | MINUS en los dos sentidos: 0 diferencias |
| Q25 | `MVL_VIEW_CALENDARIO_ACTIVIDADES` | vista | calendario_actividades | sí | MINUS en los dos sentidos: 0 diferencias |
| Q26 | `MVL_VIEW_HORARIO_ESTUDIANTE` | vista | horario_estudiante | sí | MINUS en los dos sentidos: 0 diferencias |
| Q27 | `MVL_VIEW_FICHA_SOCIOECONOMICA` | vista | ficha_socioeconomica | sí | MINUS en los dos sentidos: 0 diferencias |
| Q28 | `MVL_VIEW_CICLOS_AULA_VIRTUAL` | vista | registro_academico | sí | MINUS en los dos sentidos: 0 diferencias |
| Q29 | `MVL_VIEW_AULAS_VIRTUALES` | vista | registro_academico | sí | MINUS en los dos sentidos: 0 diferencias |
| Q30 | `MVL_FUN_ARBOL_MATERIAS` | función | notas_estudiante | sí | comparación fila a fila: igual al original |
| Q31 | `MVL_FUN_CARRERA_ESTUDIANTE` | función | notas_estudiante | sí | comparación fila a fila: igual al original |
| Q32 | `MVL_VIEW_NOTAS_CICLO_ACTUAL` | vista | notas_estudiante | sí | MINUS en los dos sentidos: 0 diferencias |
| Q33 | `MVL_VIEW_NOTAS_POR_NIVEL` | vista | notas_estudiante | sí | MINUS en los dos sentidos: 0 diferencias |
| Q34 | `MVL_FUN_NOTAS_POR_CICLO` | función | notas_estudiante | sí | comparación fila a fila: igual al original |
| Q35 | `MVL_VIEW_CALENDARIO_AULA_VIRTUAL` | vista | aula_virtual | sí | MINUS en los dos sentidos: 0 diferencias |
| Q36 | `MVL_VIEW_LISTA_ACTIVIDADES` | vista | aula_virtual | sí | MINUS en los dos sentidos: 0 diferencias |
| Q37 | `MVL_FUN_DETALLES_NOTAS_PARCIAL` | función | aula_virtual | sí | comparación fila a fila: igual al original |
| Q38 | `MVL_VIEW_DISTRIBUCION_MATERIA` | vista | aula_virtual | sí | MINUS en los dos sentidos: 0 diferencias |
| Q39 | `MVL_FUN_CONTENIDO_MATERIA` | función | aula_virtual | sí | comparación fila a fila: igual al original |
| Q40-Q44 | `MVL_PRC_FORO_ACTUALIZAR` | procedimiento | foro_online | sí | de punta a punta: curl real y tabla revisada en Oracle antes y después |
| Q40-Q44 | `MVL_PRC_FORO_CREAR_RESPUESTA_ACTIVIDAD` | procedimiento | foro_online | sí | de punta a punta: curl real y tabla revisada en Oracle antes y después |
| Q40-Q44 | `MVL_PRC_FORO_CREAR_RESPUESTA_GENERAL` | procedimiento | foro_online | sí | de punta a punta: curl real y tabla revisada en Oracle antes y después |
| Q40-Q44 | `MVL_PRC_FORO_ELIMINAR` | procedimiento | foro_online | sí | de punta a punta: curl real y tabla revisada en Oracle antes y después |
| Q40-Q44 | `MVL_PRC_FORO_MARCAR_ACTIVIDAD_ENTREGADA` | procedimiento | foro_online | sí | de punta a punta: curl real y tabla revisada en Oracle antes y después |
| Q45-Q47 | `MVL_PRC_ACTIVIDADES_ENTREGAR_REUTILIZAR_ADJUNTO` | procedimiento | actividades | sí | de punta a punta: curl real y tabla revisada en Oracle antes y después |
| Q45-Q47 | `MVL_PRC_COM_GUARDAR_RESPUESTA_ENCUESTA` | procedimiento | comunicados | sí | de punta a punta: curl real y tabla revisada en Oracle antes y después |
| Q45-Q47 | `MVL_PRC_COM_REGISTRAR_VISUALIZACION` | procedimiento | comunicados | sí | de punta a punta: curl real y tabla revisada en Oracle antes y después |
| Q48-Q49 | `MVL_PRC_EVAL_INICIAR_CRONOMETRO` | procedimiento | evaluacion_online | sí | de punta a punta: curl real y tabla revisada en Oracle antes y después |
| Q48-Q49 | `MVL_PRC_EVAL_REANUDAR_INTENTO` | procedimiento | evaluacion_online | sí | de punta a punta: curl real y tabla revisada en Oracle antes y después |
| Q50 | `MVL_PRC_EVAL_GUARDAR_RESPUESTA` | procedimiento | evaluacion_online | sí | de punta a punta: curl real y tabla revisada en Oracle antes y después |
| Q51 | `MVL_PRC_EVAL_GUARDAR_RESPUESTA_EMPAREJAR` | procedimiento | evaluacion_online | sí | de punta a punta: curl real y tabla revisada en Oracle antes y después |
| Q52 | `MVL_PRC_EVAL_TOGGLE_RESPUESTA_MULTIPLE` | procedimiento | evaluacion_online | sí | de punta a punta: curl real y tabla revisada en Oracle antes y después |
| Q53 | `MVL_PRC_MODAL_MARCAR_VISTO` | procedimiento | modales_informativos | sí | de punta a punta: curl real y tabla revisada en Oracle antes y después |

## Lo que no se migró

| Qué | Motivo |
|---|---|
| `LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA` (aula_virtual) | se migró y se revirtió; sigue como SQL en el `.ts` |
| `evaluacion_docentes` | el módulo está deshabilitado en `app.module.ts` |
| `becas` | sus 5 vistas se crearon y se revirtieron (código y base): el módulo está inactivo en dev y no se pudo probar de punta a punta. En la base no queda ningún objeto `*BECA*` (comprobado el 2026-10-14) |

## Pendiente

- [ ] Crear los 53 objetos en producción antes de que este código llegue a `main`.

## Antes y después, objeto por objeto

Cada bloque trae el archivo `.ts` antes del cambio, el script del objeto tal como está en `db/dbscripts/` y, en las vistas, el `MINUS` usado.


> [!example]- `MVL_VIEW_FORO_TIPO` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/tipo_foro.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/tipo_foro.query.ts`, versión previa al commit `18138f6`):
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
>
> **Prueba usada:**
>
> ```sql
> SELECT TIPO AS "TIPO", ID_ACTIVIDAD AS "ID_ACTIVIDAD"
> FROM UTNDB.LMS_TAB_FOROS WHERE ID_FORO = 1127676
> MINUS
> SELECT TIPO, ID_ACTIVIDAD FROM MOVIL_UTN.MVL_VIEW_FORO_TIPO WHERE ID_FORO = 1127676;
> ```

> [!example]- `MVL_VIEW_FORO_ACT_ESTADO` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/validar_actividad.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/validar_actividad.query.ts`, versión previa al commit `18138f6`):
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
>
> **Prueba usada:**
>
> ```sql
> SELECT ESTADO AS "ESTADO", FECHA_FIN AS "FECHA_FIN"
> FROM UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA WHERE ID_ACTIVIDAD = 627065
> MINUS
> SELECT ESTADO, FECHA_FIN FROM MOVIL_UTN.MVL_VIEW_FORO_ACT_ESTADO WHERE ID_ACTIVIDAD = 627065;
> ```

> [!example]- `MVL_VIEW_FORO_AUTORES` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/autores_foro.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/autores_foro.query.ts`, versión previa al commit `18138f6`):
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
>
> **Prueba usada:**
>
> ```sql
> SELECT CEDULA AS "CEDULA", PRIMER_NOMBRE || ' ' || PRIMER_APELLIDO AS "NOMBRE", GENERO AS "GENERO"
> FROM UTNDB.RHU_TAB_PERSONAS WHERE CEDULA = '<cedula>'
> MINUS
> SELECT CEDULA, NOMBRE, GENERO FROM MOVIL_UTN.MVL_VIEW_FORO_AUTORES WHERE CEDULA = '<cedula>';
> ```

> [!example]- `MVL_VIEW_FORO_INSTRUC_ACT` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/get_instrucciones_actividad.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/get_instrucciones_actividad.query.ts`, versión previa al commit `18138f6`):
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
>         UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS ACT_ALUM
>         INNER JOIN UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA ACT
>             ON ACT_ALUM.ID_ACTIVIDAD = ACT.ID_ACTIVIDAD
>     WHERE
>         ACT_ALUM.ID_ACTIVIDAD_ALUMNO = :ID_ACTIVIDAD_ALUMNO
>         AND ACT_ALUM.CEDULA_INTEGRANTE = :CEDULA
>         AND ACT.ESTADO = 'A'
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_FORO_INSTRUC_ACT
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/foro_online
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_FORO_INSTRUC_ACT ("ID_ACTIVIDAD", "NOMBRE", "FECHA_INICIO", "FECHA_FIN", "DESCRIPCION", "ID_ACTIVIDAD_ALUMNO", "CEDULA_INTEGRANTE") AS
> SELECT
>     ACT.ID_ACTIVIDAD    AS ID_ACTIVIDAD,
>     ACT.NOMBRE_CORTO    AS NOMBRE,
>     ACT.FECHA_INICIO    AS FECHA_INICIO,
>     ACT.FECHA_FIN       AS FECHA_FIN,
>     ACT.DESCRIPCION     AS DESCRIPCION,
>     ACT_ALUM.ID_ACTIVIDAD_ALUMNO AS ID_ACTIVIDAD_ALUMNO,
>     ACT_ALUM.CEDULA_INTEGRANTE   AS CEDULA_INTEGRANTE
> FROM
>     UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS ACT_ALUM
>     INNER JOIN UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA ACT
>         ON ACT_ALUM.ID_ACTIVIDAD = ACT.ID_ACTIVIDAD
> WHERE
>     ACT.ESTADO = 'A'
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> SELECT ACT.ID_ACTIVIDAD AS "ID_ACTIVIDAD", ACT.NOMBRE_CORTO AS "NOMBRE",
>        ACT.FECHA_INICIO AS "FECHA_INICIO", ACT.FECHA_FIN AS "FECHA_FIN",
>        DBMS_LOB.SUBSTR(ACT.DESCRIPCION, 4000, 1) AS "DESCRIPCION"
> FROM UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS ACT_ALUM
>      INNER JOIN UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA ACT ON ACT_ALUM.ID_ACTIVIDAD = ACT.ID_ACTIVIDAD
> WHERE ACT.ESTADO = 'A'
>   AND ACT_ALUM.ID_ACTIVIDAD_ALUMNO = 18516355
>   AND ACT_ALUM.CEDULA_INTEGRANTE = '<cedula>'
> MINUS
> SELECT ID_ACTIVIDAD, NOMBRE, FECHA_INICIO, FECHA_FIN, DBMS_LOB.SUBSTR(DESCRIPCION, 4000, 1)
> FROM MOVIL_UTN.MVL_VIEW_FORO_INSTRUC_ACT
> WHERE ID_ACTIVIDAD_ALUMNO = 18516355 AND CEDULA_INTEGRANTE = '<cedula>';
> ```

> [!example]- `MVL_FUN_FORO_ACTIVIDAD` (función)
> **Resultado:** comparación fila a fila: igual al original
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/foro_actividad.query.ts`, `src/modules/foro_online/repository/foro_online.repository.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/foro_actividad.query.ts`, versión previa al commit `18138f6`):
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
> **Resultado:** comparación fila a fila: igual al original
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/foro_general.query.ts`, `src/modules/foro_online/repository/foro_online.repository.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/foro_general.query.ts`, versión previa al commit `18138f6`):
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

> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** 4 col, 0 devuelta
>
>
>
> >
> **Script del objeto:**
>
> >
> **Prueba usada:**
>
> 
> [!example]- `MVL_VIEW_INFO_TAREA` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** 13 columnas, no devuelve nada.
>
> **Lo usa:** `src/modules/actividades/respository/consultas/get_info_tarea_consulta.ts`
>
> **Antes** (`src/modules/actividades/respository/consultas/get_info_tarea_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const GET_INFO_TAREA_CONSULTA = `
> SELECT
>    ACT_ALUM.ID_ACTIVIDAD_ALUMNO,
>    ACT_ALUM.INTENTOS_DISPONIBLES,
>    MATERIA.DESCRIPCION "MATERIA",
>    ACT_ALUM.DESCRIPCION AS DESCRIPCION_ACTIVIDAD_ALUMNO,
>    ACT_ALUM.URL AS URL_ACTIVIDAD_ALUMNO,
>    -- ACT_ALUM.ADJUNTO_DATA,
>    ACT_ALUM.CALIFICACION,
>    case
>       WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 7 THEN 'NO_REQUIERE_ADJUNTO'
>       WHEN ACT_ALUM.ENTREGADO = 'SI'
>       AND ACT_ALUM.ID_DOCUMENTO_DIRECTORIO IS NOT NULL THEN 'ENTREGADO_CON_ADJUNTO'
>       WHEN ACT_ALUM.ENTREGADO = 'SI'
>       AND ACT_ALUM.ID_DOCUMENTO_DIRECTORIO IS NULL THEN 'ENTREGADO_SIN_ADJUNTO'
>       ELSE 'NO_ENTREGADO'
>    end as ENTREGADO,
>    ACT_ALUM.ID_DOCUMENTO_DIRECTORIO AS ADJUNTO_ALUMNO,
>    (
>        SELECT NOMBRE_ARCHIVO
>        FROM UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO
>        WHERE ID_DOCUMENTO_DIRECTORIO = ACT_ALUM.ID_DOCUMENTO_DIRECTORIO
>    ) AS NOMBRE_ADJUNTO_ALUMNO,
>    ACT_ALUM.OBSERVACION,
>    ACTIVIDAD.NOMBRE_CORTO,
>    ACTIVIDAD.DESCRIPCION AS DESCRIPCION_ACTIVIDAD,
>    ACTIVIDAD.URL AS URL_ACTIVIDAD,
>    ACTIVIDAD.FECHA_INICIO,
>    ACTIVIDAD.FECHA_FIN,
>    ACTIVIDAD.ID_DOCUMENTO_DIRECTORIO AS ADJUNTO_DOCENTE,
>    (
>        SELECT NOMBRE_ARCHIVO
>        FROM UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO
>        WHERE ID_DOCUMENTO_DIRECTORIO = ACTIVIDAD.ID_DOCUMENTO_DIRECTORIO
>    ) AS NOMBRE_ADJUNTO_DOCENTE,
>    (
>       CASE
>          WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 2
>          and greatest(SYSDATE, FECHA_INICIO) = FECHA_INICIO 
>             THEN 'PRUEBA_NO_DISPONIBLE'
>          WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 2
>          and greatest(SYSDATE, FECHA_INICIO) = SYSDATE
>          AND greatest(SYSDATE, FECHA_FIN) = FECHA_FIN THEN 'RENDIR_EVALUACION'
>          WHEN (ACTIVIDAD.TIPO_ACTIVIDAD = 6)
>          and (ACTIVIDAD.URL IS NOT NULL) THEN 'FORO_YAMMER'
>          WHEN (ACTIVIDAD.TIPO_ACTIVIDAD = 3)
>          and (ACTIVIDAD.URL IS NOT NULL) THEN 'EVALUACION_OFFICE_365'
>          WHEN (ACTIVIDAD.TIPO_ACTIVIDAD = 4)
>          and (ACTIVIDAD.URL IS NOT NULL) THEN 'EVALUACION_OTRAS'
>          WHEN (ACTIVIDAD.TIPO_ACTIVIDAD = 7)
>          and (ACTIVIDAD.URL IS NOT NULL) THEN 'CLASE_SINCRONA'
>          WHEN greatest(SYSDATE, FECHA_FIN) = SYSDATE
>          AND (ACTIVIDAD.TIPO_ACTIVIDAD IN (1, 2)) THEN 'ACTIVIDAD_FINALIZADA'
>          WHEN (ACTIVIDAD.TIPO_ACTIVIDAD = 5) THEN 'FORO_UTN'
>          ELSE 'RESPONDER'
>       END
>    ) AS RESPONDER,
>     TIPO.NOMBRE_TIPO
> FROM
>    LMS_TAB_ACTIVIDADES_ALUMNOS ACT_ALUM
>    JOIN LMS_TAB_ACTIVIDAD_ACADEMICA ACTIVIDAD ON (
>       ACT_ALUM.ID_ACTIVIDAD = ACTIVIDAD.ID_ACTIVIDAD
>    )
>     JOIN ACA_TAB_MATERIAS MATERIA ON (
>       MATERIA.CODIGO = ACTIVIDAD.MATERIA_CODIGO
>       AND MATERIA.NIVEL_CODIGO = ACTIVIDAD.NIVEL_CODIGO
>    )
>    JOIN LMS_TAB_TIPO_ACTIVIDAD TIPO ON(
>        TIPO.CODIGO = ACTIVIDAD.TIPO_ACTIVIDAD
>     )
> WHERE
>    ACT_ALUM.ID_ACTIVIDAD_ALUMNO = :ID_ACTIVIDAD_ALUMNO
>    AND ACTIVIDAD.ESTADO = 'A'
>    AND ACT_ALUM.CEDULA_INTEGRANTE = :CEDULA
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_INFO_TAREA
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/actividades
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_INFO_TAREA ("ID_ACTIVIDAD_ALUMNO", "CEDULA_INTEGRANTE", "INTENTOS_DISPONIBLES", "MATERIA", "DESCRIPCION_ACTIVIDAD_ALUMNO", "URL_ACTIVIDAD_ALUMNO", "CALIFICACION", "ENTREGADO", "ADJUNTO_ALUMNO", "NOMBRE_ADJUNTO_ALUMNO", "OBSERVACION", "NOMBRE_CORTO", "DESCRIPCION_ACTIVIDAD", "URL_ACTIVIDAD", "FECHA_INICIO", "FECHA_FIN", "ADJUNTO_DOCENTE", "NOMBRE_ADJUNTO_DOCENTE", "RESPONDER", "NOMBRE_TIPO") AS
> SELECT
>    ACT_ALUM.ID_ACTIVIDAD_ALUMNO,
>    ACT_ALUM.CEDULA_INTEGRANTE,
>    ACT_ALUM.INTENTOS_DISPONIBLES,
>    MATERIA.DESCRIPCION,
>    ACT_ALUM.DESCRIPCION,
>    ACT_ALUM.URL,
>    ACT_ALUM.CALIFICACION,
>    CASE
>       WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 7 THEN 'NO_REQUIERE_ADJUNTO'
>       WHEN ACT_ALUM.ENTREGADO = 'SI' AND ACT_ALUM.ID_DOCUMENTO_DIRECTORIO IS NOT NULL THEN 'ENTREGADO_CON_ADJUNTO'
>       WHEN ACT_ALUM.ENTREGADO = 'SI' AND ACT_ALUM.ID_DOCUMENTO_DIRECTORIO IS NULL THEN 'ENTREGADO_SIN_ADJUNTO'
>       ELSE 'NO_ENTREGADO'
>    END,
>    ACT_ALUM.ID_DOCUMENTO_DIRECTORIO,
>    (
>        SELECT NOMBRE_ARCHIVO
>        FROM UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO
>        WHERE ID_DOCUMENTO_DIRECTORIO = ACT_ALUM.ID_DOCUMENTO_DIRECTORIO
>    ),
>    ACT_ALUM.OBSERVACION,
>    ACTIVIDAD.NOMBRE_CORTO,
>    ACTIVIDAD.DESCRIPCION,
>    ACTIVIDAD.URL,
>    ACTIVIDAD.FECHA_INICIO,
>    ACTIVIDAD.FECHA_FIN,
>    ACTIVIDAD.ID_DOCUMENTO_DIRECTORIO,
>    (
>        SELECT NOMBRE_ARCHIVO
>        FROM UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO
>        WHERE ID_DOCUMENTO_DIRECTORIO = ACTIVIDAD.ID_DOCUMENTO_DIRECTORIO
>    ),
>    (
>       CASE
>          WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 2 AND GREATEST(SYSDATE, ACTIVIDAD.FECHA_INICIO) = ACTIVIDAD.FECHA_INICIO THEN 'PRUEBA_NO_DISPONIBLE'
>          WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 2 AND GREATEST(SYSDATE, ACTIVIDAD.FECHA_INICIO) = SYSDATE AND GREATEST(SYSDATE, ACTIVIDAD.FECHA_FIN) = ACTIVIDAD.FECHA_FIN THEN 'RENDIR_EVALUACION'
>          WHEN (ACTIVIDAD.TIPO_ACTIVIDAD = 6) AND (ACTIVIDAD.URL IS NOT NULL) THEN 'FORO_YAMMER'
>          WHEN (ACTIVIDAD.TIPO_ACTIVIDAD = 3) AND (ACTIVIDAD.URL IS NOT NULL) THEN 'EVALUACION_OFFICE_365'
>          WHEN (ACTIVIDAD.TIPO_ACTIVIDAD = 4) AND (ACTIVIDAD.URL IS NOT NULL) THEN 'EVALUACION_OTRAS'
>          WHEN (ACTIVIDAD.TIPO_ACTIVIDAD = 7) AND (ACTIVIDAD.URL IS NOT NULL) THEN 'CLASE_SINCRONA'
>          WHEN GREATEST(SYSDATE, ACTIVIDAD.FECHA_FIN) = SYSDATE AND (ACTIVIDAD.TIPO_ACTIVIDAD IN (1, 2)) THEN 'ACTIVIDAD_FINALIZADA'
>          WHEN (ACTIVIDAD.TIPO_ACTIVIDAD = 5) THEN 'FORO_UTN'
>          ELSE 'RESPONDER'
>       END
>    ),
>    TIPO.NOMBRE_TIPO
> FROM
>    UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS ACT_ALUM
>    JOIN UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA ACTIVIDAD ON (ACT_ALUM.ID_ACTIVIDAD = ACTIVIDAD.ID_ACTIVIDAD)
>    JOIN UTNDB.ACA_TAB_MATERIAS MATERIA ON (MATERIA.CODIGO = ACTIVIDAD.MATERIA_CODIGO AND MATERIA.NIVEL_CODIGO = ACTIVIDAD.NIVEL_CODIGO)
>    JOIN UTNDB.LMS_TAB_TIPO_ACTIVIDAD TIPO ON (TIPO.CODIGO = ACTIVIDAD.TIPO_ACTIVIDAD)
> WHERE
>    ACTIVIDAD.ESTADO = 'A'
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> SELECT
>    ACT_ALUM.INTENTOS_DISPONIBLES, MATERIA.DESCRIPCION AS "MATERIA",
>    ACT_ALUM.URL AS URL_ACTIVIDAD_ALUMNO, ACT_ALUM.CALIFICACION,
>    CASE
>       WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 7 THEN 'NO_REQUIERE_ADJUNTO'
>       WHEN ACT_ALUM.ENTREGADO = 'SI' AND ACT_ALUM.ID_DOCUMENTO_DIRECTORIO IS NOT NULL THEN 'ENTREGADO_CON_ADJUNTO'
>       WHEN ACT_ALUM.ENTREGADO = 'SI' AND ACT_ALUM.ID_DOCUMENTO_DIRECTORIO IS NULL THEN 'ENTREGADO_SIN_ADJUNTO'
>       ELSE 'NO_ENTREGADO'
>    END AS ENTREGADO,
>    ACT_ALUM.ID_DOCUMENTO_DIRECTORIO AS ADJUNTO_ALUMNO,
>    ACT_ALUM.OBSERVACION, ACTIVIDAD.NOMBRE_CORTO,
>    ACTIVIDAD.URL AS URL_ACTIVIDAD,
>    ACTIVIDAD.FECHA_INICIO, ACTIVIDAD.FECHA_FIN,
>    ACTIVIDAD.ID_DOCUMENTO_DIRECTORIO AS ADJUNTO_DOCENTE, TIPO.NOMBRE_TIPO
> FROM
>    UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS ACT_ALUM
>    JOIN UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA ACTIVIDAD ON (ACT_ALUM.ID_ACTIVIDAD = ACTIVIDAD.ID_ACTIVIDAD)
>    JOIN UTNDB.ACA_TAB_MATERIAS MATERIA ON (MATERIA.CODIGO = ACTIVIDAD.MATERIA_CODIGO AND MATERIA.NIVEL_CODIGO = ACTIVIDAD.NIVEL_CODIGO)
>    JOIN UTNDB.LMS_TAB_TIPO_ACTIVIDAD TIPO ON (TIPO.CODIGO = ACTIVIDAD.TIPO_ACTIVIDAD)
> WHERE ACT_ALUM.ID_ACTIVIDAD_ALUMNO = 18516355 AND ACTIVIDAD.ESTADO = 'A' AND ACT_ALUM.CEDULA_INTEGRANTE = '<cedula>'
> MINUS
> SELECT INTENTOS_DISPONIBLES, MATERIA, URL_ACTIVIDAD_ALUMNO, CALIFICACION, ENTREGADO, ADJUNTO_ALUMNO, OBSERVACION, NOMBRE_CORTO, URL_ACTIVIDAD, FECHA_INICIO, FECHA_FIN, ADJUNTO_DOCENTE, NOMBRE_TIPO
> FROM MOVIL_UTN.MVL_VIEW_INFO_TAREA
> WHERE ID_ACTIVIDAD_ALUMNO = 18516355 AND CEDULA_INTEGRANTE = '<cedula>';
> ```

> [!example]- `MVL_VIEW_ARCHIVO_DIRECTORIO` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** 4 col, no return
>
> **Lo usa:** `src/modules/documentos_directorio/repository/consulta/obtener_archivo_blob_consulta.ts`
>
> **Antes** (`src/modules/documentos_directorio/repository/consulta/obtener_archivo_blob_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const OBTENER_ARCHIVO_BLOB_CONSULTA = `
> SELECT 
>     NOMBRE_UNICO, 
>     DIRECTORIO, 
>     MIME_TYPE, 
>     NOMBRE_ARCHIVO, 
>     MVL_FUN_OBTENER_DOC_DIR(DIRECTORIO, NOMBRE_UNICO) AS CONTENIDO_ARCHIVO
> FROM 
>     UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO 
> WHERE 
>     ID_DOCUMENTO_DIRECTORIO = :P272_ID_DOCUMENTO_DIRECTORIO
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_ARCHIVO_DIRECTORIO
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/documentos_directorio
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_ARCHIVO_DIRECTORIO ("ID_DOCUMENTO_DIRECTORIO", "NOMBRE_UNICO", "DIRECTORIO", "MIME_TYPE", "NOMBRE_ARCHIVO", "CONTENIDO_ARCHIVO") AS
> SELECT
>     ID_DOCUMENTO_DIRECTORIO,
>     NOMBRE_UNICO,
>     DIRECTORIO,
>     MIME_TYPE,
>     NOMBRE_ARCHIVO,
>     MVL_FUN_OBTENER_DOC_DIR(DIRECTORIO, NOMBRE_UNICO) AS CONTENIDO_ARCHIVO
> FROM
>     UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> SELECT NOMBRE_UNICO, DIRECTORIO, MIME_TYPE, NOMBRE_ARCHIVO
> FROM UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO WHERE ID_DOCUMENTO_DIRECTORIO = 1104210
> MINUS
> SELECT NOMBRE_UNICO, DIRECTORIO, MIME_TYPE, NOMBRE_ARCHIVO
> FROM MOVIL_UTN.MVL_VIEW_ARCHIVO_DIRECTORIO WHERE ID_DOCUMENTO_DIRECTORIO = 1104210;
> ```

> [!example]- `MVL_FUN_FICHA_ESTUDIANTE` (función)
> **Resultado:** comparación fila a fila: igual al original
>
> **Nota del registro:** devolvio lo mismo.
>
> **Lo usa:** `src/modules/ficha_estudiante/repository/consultas/ficha_estudiante_consulta.ts`
>
> **Antes** (`src/modules/ficha_estudiante/repository/consultas/ficha_estudiante_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const FICHA_ESTUDIANTE_CONSULTA = `
> SELECT 
>   tab_personas.primer_apellido || ' ' || tab_personas.segundo_apellido || ' ' || tab_personas.primer_nombre || ' ' || tab_personas.segundo_nombre AS "APELLIDOS Y NOMBRES", 
>   tab_personas.fecha_nacimiento, 
>   tab_personas.direccion, 
>   tab_personas.email, 
>   tab_personas.telefono, 
>   tab_personas.celular, 
>   fun_inst_obtener_localidad(tab_personas.lugar_residencia) AS "RESIDENCIA", 
>   fun_inst_obtener_localidad(tab_personas.lugar_nacimiento) AS "LUGAR DE NACIMIENTO", 
>   fun_inst_obtener_localidad(tab_personas.lugar_procedencia) AS "LUGAR DE PROCEDENCIA", 
>   fun_inst_obtener_localidad(tab_personas.nacionalidad) AS "NACIONALIDAD"
>   -- FOTO se excluye a propósito: es un BLOB que se leía completo en cada carga
>   -- de la ficha solo para devolverlo en base64. La foto propia la sirve el core
>   -- de seguridad por su endpoint binario.
> FROM
>   (
>     utndb.rhu_tab_personas tab_personas 
>     INNER JOIN utndb.ins_tab_localidades tab_localidades ON (
>       tab_personas.lugar_nacimiento = tab_localidades.codigo
>     )
>   ) 
>   INNER JOIN utndb.aca_tab_estudiantes tab_estudiantes ON (
>     tab_estudiantes.persona_cedula = tab_personas.cedula
>   ) 
>   LEFT JOIN utndb.rhu_tab_correo_institucional tab_correo ON (
>     tab_correo.cedula_persona = lms_pck_aulas_virtuales.lms_fun_cedula_usuario (:cuenta)
>   ) 
> WHERE 
>   (
>     tab_estudiantes.persona_cedula = (
>       SELECT 
>         persona_cedula 
>       FROM 
>         ins_tab_usuarios 
>       WHERE 
>         cuenta = :cuenta
>     )
>   )
>
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_FUN_FICHA_ESTUDIANTE
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_FUN_FICHA_ESTUDIANTE')
> -- Usado por: src/modules/ficha_estudiante
>
> CREATE OR REPLACE FUNCTION MOVIL_UTN.MVL_FUN_FICHA_ESTUDIANTE (
>     p_cuenta IN UTNDB.INS_TAB_USUARIOS.CUENTA%TYPE
> ) RETURN SYS_REFCURSOR
> AS
>     v_cursor SYS_REFCURSOR;
> BEGIN
>     OPEN v_cursor FOR
>         SELECT
>             tab_personas.primer_apellido || ' ' || tab_personas.segundo_apellido || ' ' || tab_personas.primer_nombre || ' ' || tab_personas.segundo_nombre AS "APELLIDOS Y NOMBRES",
>             tab_personas.fecha_nacimiento AS FECHA_NACIMIENTO,
>             tab_personas.direccion        AS DIRECCION,
>             tab_personas.email            AS EMAIL,
>             tab_personas.telefono         AS TELEFONO,
>             tab_personas.celular          AS CELULAR,
>             fun_inst_obtener_localidad(tab_personas.lugar_residencia)   AS "RESIDENCIA",
>             fun_inst_obtener_localidad(tab_personas.lugar_nacimiento)   AS "LUGAR DE NACIMIENTO",
>             fun_inst_obtener_localidad(tab_personas.lugar_procedencia)  AS "LUGAR DE PROCEDENCIA",
>             fun_inst_obtener_localidad(tab_personas.nacionalidad)       AS "NACIONALIDAD"
>         FROM
>             (
>                 UTNDB.RHU_TAB_PERSONAS tab_personas
>                 INNER JOIN UTNDB.INS_TAB_LOCALIDADES tab_localidades ON (
>                     tab_personas.lugar_nacimiento = tab_localidades.codigo
>                 )
>             )
>             INNER JOIN UTNDB.ACA_TAB_ESTUDIANTES tab_estudiantes ON (
>                 tab_estudiantes.persona_cedula = tab_personas.cedula
>             )
>             LEFT JOIN UTNDB.RHU_TAB_CORREO_INSTITUCIONAL tab_correo ON (
>                 tab_correo.cedula_persona = lms_pck_aulas_virtuales.lms_fun_cedula_usuario(p_cuenta)
>             )
>         WHERE
>             (
>                 tab_estudiantes.persona_cedula = (
>                     SELECT
>                         persona_cedula
>                     FROM
>                         UTNDB.INS_TAB_USUARIOS
>                     WHERE
>                         cuenta = p_cuenta
>                 )
>             );
>     RETURN v_cursor;
> END MVL_FUN_FICHA_ESTUDIANTE;
> /
> ```

> [!example]- `MVL_VIEW_COMUNICADO_DETALLE` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** 14 col, no return row.
>
> **Lo usa:** `src/modules/comunicados/repository/consultas/obtener_comunicado_por_id_consulta.ts`
>
> **Antes** (`src/modules/comunicados/repository/consultas/obtener_comunicado_por_id_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const OBTENER_COMUNICADO_POR_ID_CONSULTA = `
> SELECT 
>     c.ID_COMUNICADO,
>     c.CODIGO,
>     c.TITULO,
>     c.MENSAJE,
>     c.TIPO_ID,
>     c.PRIORIDAD,
>     c.FECHA_INICIO,
>     c.FECHA_FIN,
>     c.ACCION_TIPO,
>     c.ACCION_URL,
>     c.ACCION_BOTON_TEXTO,
>     c.FRECUENCIA,
>     c.MAX_VISUALIZACIONES,
>     c.IMAGEN,
>     c.OBSERVACIONES,
>     c.OBLIGATORIO
> FROM MOVIL_UTN.MVL_TAB_COMUNICADOS c
> WHERE c.ID_COMUNICADO = :idComunicado
>     AND c.ESTADO = 'A'
>     AND c.FECHA_INICIO <= SYSDATE
>     AND (c.FECHA_FIN IS NULL OR c.FECHA_FIN >= SYSDATE)
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_COMUNICADO_DETALLE
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/comunicados
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_COMUNICADO_DETALLE ("ID_COMUNICADO", "CODIGO", "TITULO", "MENSAJE", "TIPO_ID", "PRIORIDAD", "FECHA_INICIO", "FECHA_FIN", "ACCION_TIPO", "ACCION_URL", "ACCION_BOTON_TEXTO", "FRECUENCIA", "MAX_VISUALIZACIONES", "IMAGEN", "OBSERVACIONES", "OBLIGATORIO") AS
> SELECT
>     c.ID_COMUNICADO, c.CODIGO, c.TITULO, c.MENSAJE, c.TIPO_ID, c.PRIORIDAD,
>     c.FECHA_INICIO, c.FECHA_FIN, c.ACCION_TIPO, c.ACCION_URL, c.ACCION_BOTON_TEXTO,
>     c.FRECUENCIA, c.MAX_VISUALIZACIONES, c.IMAGEN, c.OBSERVACIONES, c.OBLIGATORIO
> FROM MOVIL_UTN.MVL_TAB_COMUNICADOS c
> WHERE c.ESTADO = 'A'
>     AND c.FECHA_INICIO <= SYSDATE
>     AND (c.FECHA_FIN IS NULL OR c.FECHA_FIN >= SYSDATE)
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> SELECT CODIGO, TITULO, DBMS_LOB.SUBSTR(MENSAJE,4000,1) AS MENSAJE, TIPO_ID, PRIORIDAD, FECHA_INICIO, FECHA_FIN, ACCION_TIPO, ACCION_URL, ACCION_BOTON_TEXTO, FRECUENCIA, MAX_VISUALIZACIONES, OBSERVACIONES, OBLIGATORIO
> FROM MOVIL_UTN.MVL_TAB_COMUNICADOS
> WHERE ID_COMUNICADO = 189 AND ESTADO='A' AND FECHA_INICIO <= SYSDATE AND (FECHA_FIN IS NULL OR FECHA_FIN >= SYSDATE)
> MINUS
> SELECT CODIGO, TITULO, DBMS_LOB.SUBSTR(MENSAJE,4000,1), TIPO_ID, PRIORIDAD, FECHA_INICIO, FECHA_FIN, ACCION_TIPO, ACCION_URL, ACCION_BOTON_TEXTO, FRECUENCIA, MAX_VISUALIZACIONES, OBSERVACIONES, OBLIGATORIO
> FROM MOVIL_UTN.MVL_VIEW_COMUNICADO_DETALLE WHERE ID_COMUNICADO = 189;
> ```

> [!example]- `MVL_VIEW_ENCUESTA_PREGUNTAS` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** 7 col, 0 row
>
> **Lo usa:** `src/modules/comunicados/repository/consultas/obtener_preguntas_encuesta_consulta.ts`
>
> **Antes** (`src/modules/comunicados/repository/consultas/obtener_preguntas_encuesta_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const OBTENER_PREGUNTAS_ENCUESTA_CONSULTA = `
> SELECT
>   p.ID_PREGUNTA,
>   p.ID_COMUNICADO,
>   p.TEXTO_PREGUNTA,
>   p.CODIGO_REF,
>   p.TIPO_WIDGET,
>   p.OPCIONES_CONFIG,
>   p.ES_OBLIGATORIO,
>   p.ORDEN
> FROM MOVIL_UTN.MVL_TAB_ENC_PREGUNTAS p
> WHERE p.ID_COMUNICADO = :idComunicado
> ORDER BY p.ORDEN ASC
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_ENCUESTA_PREGUNTAS
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/comunicados
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_ENCUESTA_PREGUNTAS ("ID_PREGUNTA", "ID_COMUNICADO", "TEXTO_PREGUNTA", "CODIGO_REF", "TIPO_WIDGET", "OPCIONES_CONFIG", "ES_OBLIGATORIO", "ORDEN") AS
> SELECT p.ID_PREGUNTA, p.ID_COMUNICADO, p.TEXTO_PREGUNTA, p.CODIGO_REF, p.TIPO_WIDGET, p.OPCIONES_CONFIG, p.ES_OBLIGATORIO, p.ORDEN
> FROM MOVIL_UTN.MVL_TAB_ENC_PREGUNTAS p
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> SELECT ID_PREGUNTA, TEXTO_PREGUNTA, CODIGO_REF, TIPO_WIDGET, DBMS_LOB.SUBSTR(OPCIONES_CONFIG,4000,1) AS OPCIONES_CONFIG, ES_OBLIGATORIO, ORDEN    FROM MOVIL_UTN.MVL_TAB_ENC_PREGUNTAS WHERE ID_COMUNICADO = 188
> MINUS    SELECT ID_PREGUNTA, TEXTO_PREGUNTA, CODIGO_REF, TIPO_WIDGET, DBMS_LOB.SUBSTR(OPCIONES_CONFIG,4000,1), ES_OBLIGATORIO, ORDEN
> FROM MOVIL_UTN.MVL_VIEW_ENCUESTA_PREGUNTAS WHERE ID_COMUNICADO = 188;
> ```

> [!example]- `MVL_VIEW_CERTIFICADOS_EVENTOS` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** 10 col, 0 rows.
>
> **Lo usa:** `src/modules/documentos/repository/consultas/certificados_eventos_consulta.ts`
>
> **Antes** (`src/modules/documentos/repository/consultas/certificados_eventos_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const CERTIFICADOS_EVENTOS_CONSULTA = `
> select ID_EVENTO,
>        TITULO_CERTIFICADO,
>        NOMBRE_EVENTO,
>        REALIZADO_EN,
>        LUGAR_EVENTO,
>        FECHA_INICIO,
>        FECHA_FIN,
>        NOMBRE_ORGANIZADOR,
>        CODIGO_QR,
>        CASE WHEN URL IS NULL THEN '' ELSE replace(URL,'http://','https://') END AS URL
>   from UEP_TAB_CERTIFICADOS_EMITIDOS
>   WHERE CEDULA= :G_CEDULA_USUARIO
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_CERTIFICADOS_EVENTOS
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/documentos
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_CERTIFICADOS_EVENTOS ("ID_EVENTO", "TITULO_CERTIFICADO", "NOMBRE_EVENTO", "REALIZADO_EN", "LUGAR_EVENTO", "FECHA_INICIO", "FECHA_FIN", "NOMBRE_ORGANIZADOR", "CODIGO_QR", "CEDULA", "URL") AS
> SELECT
>     ID_EVENTO, TITULO_CERTIFICADO, NOMBRE_EVENTO, REALIZADO_EN, LUGAR_EVENTO,
>     FECHA_INICIO, FECHA_FIN, NOMBRE_ORGANIZADOR, CODIGO_QR, CEDULA,
>     CASE WHEN URL IS NULL THEN '' ELSE REPLACE(URL,'http://','https://') END AS URL
> FROM UTNDB.UEP_TAB_CERTIFICADOS_EMITIDOS
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> SELECT ID_EVENTO, TITULO_CERTIFICADO, NOMBRE_EVENTO, REALIZADO_EN, LUGAR_EVENTO, FECHA_INICIO, FECHA_FIN, NOMBRE_ORGANIZADOR, CODIGO_QR,
>        CASE WHEN URL IS NULL THEN '' ELSE REPLACE(URL,'http://','https://') END AS URL
> FROM UTNDB.UEP_TAB_CERTIFICADOS_EMITIDOS WHERE CEDULA = '<cedula>'
> MINUS
> SELECT ID_EVENTO, TITULO_CERTIFICADO, NOMBRE_EVENTO, REALIZADO_EN, LUGAR_EVENTO, FECHA_INICIO, FECHA_FIN, NOMBRE_ORGANIZADOR, CODIGO_QR, URL
> FROM MOVIL_UTN.MVL_VIEW_CERTIFICADOS_EVENTOS WHERE CEDULA = '<cedula>';
> ```

> [!example]- `MVL_VIEW_FORMATOS_VINCULACION` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** 3col, 0 rows.
>
> **Lo usa:** `src/modules/documentos/repository/consultas/formatos_vinculacion_consulta.ts`
>
> **Antes** (`src/modules/documentos/repository/consultas/formatos_vinculacion_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const FORMATOS_VINCULACION_CONSULTA = `
>   SELECT
>     ID_DOCUMENTO_DIRECTORIO,
>     NOMBRE_ARCHIVO,
>     MIME_TYPE
>   FROM
>     UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO
>   WHERE
>     DIRECTORIO = :P272_DIRECTORIO
>     AND ESTADO = 'A'
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_FORMATOS_VINCULACION
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/documentos
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_FORMATOS_VINCULACION ("ID_DOCUMENTO_DIRECTORIO", "NOMBRE_ARCHIVO", "MIME_TYPE", "DIRECTORIO") AS
> SELECT ID_DOCUMENTO_DIRECTORIO, NOMBRE_ARCHIVO, MIME_TYPE, DIRECTORIO
> FROM UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO
> WHERE ESTADO = 'A'
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> SELECT ID_DOCUMENTO_DIRECTORIO, NOMBRE_ARCHIVO, MIME_TYPE FROM UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO WHERE DIRECTORIO = '9566' AND ESTADO='A'
> MINUS
> SELECT ID_DOCUMENTO_DIRECTORIO, NOMBRE_ARCHIVO, MIME_TYPE FROM MOVIL_UTN.MVL_VIEW_FORMATOS_VINCULACION WHERE DIRECTORIO = '9566';
> ```

> [!example]- `MVL_VIEW_HISTORIAL_CERTIFICADOS` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** 6col, 0rows
>
> **Lo usa:** `src/modules/documentos/repository/consultas/historial_certificados_consulta.ts`
>
> **Antes** (`src/modules/documentos/repository/consultas/historial_certificados_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const HISTORIAL_CERTIFICADOS_CONSULTAS = `
> Select CE.ID_CERTIFICADO, 
>   CE.CEDULA ,          
>   CE.NOMBRE ,          
>   CE.FECHA_EMISION ,   
>   CS.NOMBRE_SERVICIO,   
>   CE.CARRERA,      
>   CASE WHEN CE.URL_CERTIFICADO IS NOT NULL THEN REPLACE(CE.URL_CERTIFICADO,'http://','https://') ELSE 'En proceso...' END AS URL_CERTIFICADO
> FROM UTNDB.CSE_TAB_CERTIFICADOS_CART_SERV CE, UTNDB.CSE_TAB_CARTERA_SERVICIO_EST CS
> WHERE 
>     CE.CEDULA = :G_CEDULA_USUARIO
>     AND CE.ID_SERVICIO = CS.ID_SERVICIO
> ORDER BY CE.ID_CERTIFICADO DESC
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_HISTORIAL_CERTIFICADOS
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/documentos
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_HISTORIAL_CERTIFICADOS ("ID_CERTIFICADO", "CEDULA", "NOMBRE", "FECHA_EMISION", "NOMBRE_SERVICIO", "CARRERA", "URL_CERTIFICADO") AS
> SELECT CE.ID_CERTIFICADO, CE.CEDULA, CE.NOMBRE, CE.FECHA_EMISION, CS.NOMBRE_SERVICIO, CE.CARRERA,
>     CASE WHEN CE.URL_CERTIFICADO IS NOT NULL THEN REPLACE(CE.URL_CERTIFICADO,'http://','https://') ELSE 'En proceso...' END AS URL_CERTIFICADO
> FROM UTNDB.CSE_TAB_CERTIFICADOS_CART_SERV CE, UTNDB.CSE_TAB_CARTERA_SERVICIO_EST CS
> WHERE CE.ID_SERVICIO = CS.ID_SERVICIO
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> SELECT CE.ID_CERTIFICADO, CE.NOMBRE, CE.FECHA_EMISION, CS.NOMBRE_SERVICIO, CE.CARRERA,
>     CASE WHEN CE.URL_CERTIFICADO IS NOT NULL THEN REPLACE(CE.URL_CERTIFICADO,'http://','https://') ELSE 'En proceso...' END AS URL_CERTIFICADO
> FROM UTNDB.CSE_TAB_CERTIFICADOS_CART_SERV CE, UTNDB.CSE_TAB_CARTERA_SERVICIO_EST CS
> WHERE CE.CEDULA = '<cedula>' AND CE.ID_SERVICIO = CS.ID_SERVICIO
> MINUS
> SELECT ID_CERTIFICADO, NOMBRE, FECHA_EMISION, NOMBRE_SERVICIO, CARRERA, URL_CERTIFICADO
> FROM MOVIL_UTN.MVL_VIEW_HISTORIAL_CERTIFICADOS WHERE CEDULA = '<cedula>';
> ```

> [!example]- `MVL_VIEW_MATRICULA_CICLO_ACTIVO` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** Ambos select dio 1
>
> **Lo usa:** `src/modules/documentos/repository/consultas/validar_asistencia_clases_consulta.ts`
>
> **Antes** (`src/modules/documentos/repository/consultas/validar_asistencia_clases_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const VALIDAR_MATRICULA_CICLO_ACTIVO_CONSULTA = `
> Select 
>     1
> from RHU_TAB_PERSONAS p                
>     INNER JOIN ACA_TAB_MATRICULAS am ON p.CEDULA = am.ESTUDIANTE_CEDULA
>     INNER JOIN ACA_TAB_CICLOS_ACADEMICOS ca ON am.CICLO_ACAD_CODIGO = ca.CODIGO
> WHERE
>     p.CEDULA = :G_CEDULA_USUARIO
>     AND ca.ESTADO = 'A'
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_MATRICULA_CICLO_ACTIVO
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/documentos
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_MATRICULA_CICLO_ACTIVO ("CEDULA") AS
> SELECT p.CEDULA
> FROM UTNDB.RHU_TAB_PERSONAS p
>     INNER JOIN UTNDB.ACA_TAB_MATRICULAS am ON p.CEDULA = am.ESTUDIANTE_CEDULA
>     INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS ca ON am.CICLO_ACAD_CODIGO = ca.CODIGO
> WHERE ca.ESTADO = 'A'
> ;
> ```

> [!example]- `MVL_VIEW_CARRERAS_ESTUDIANTE` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** 0 filas MINUS en ambos sentidos (1 fila devuelta para <cedula>)
>
> **Lo usa:** `src/modules/documentos/repository/consultas/carreras_consulta.ts`
>
> **Antes** (`src/modules/documentos/repository/consultas/carreras_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const CARRERAS_CONSULTA = `
> SELECT 
>     d1.NOMBRE AS NOMBRE,
>     EC.DEPEN_CARRERA AS DEPENDENCIA
> FROM ACA_TAB_ESTUDIANTE_CARRERAS ec 
>     INNER JOIN ACA_TAB_DEPENDENCIAS d1 ON  d1.CODIGO = ec.DEPEN_CARRERA
>     INNER JOIN ACA_TAB_DEPENDENCIAS d2 ON d1.DEPEN_CODIGO = d2.CODIGO
>     INNER JOIN ACA_TAB_DEPENDENCIAS d3 ON d2.DEPEN_CODIGO = d3.CODIGO
>     INNER JOIN ACA_TAB_CICLOS_ACADEMICOS ca ON ec.ultimo_ciclo = ca.CODIGO
>     INNER JOIN ACA_TAB_PERIODOS_ACADEMICOS pa ON (ca.PER_ACAD_CODIGO = pa.CODIGO)
> WHERE
>     ec.ESTUDIANTE_CEDULA = :G_CEDULA_USUARIO
>     AND ec.estado = 'A' 
>     AND (ca.estado = 'A' OR EXTRACT(YEAR FROM ca.fecha_fin) IN (EXTRACT(YEAR FROM SYSDATE), EXTRACT(YEAR FROM SYSDATE) - 1)) /*Matriculado en ciclo actual o egreseado hasta 1 año  atras*/
> UNION
>
> SELECT 
>     d1.NOMBRE AS NOMBRE,
>     am.depen_codigo AS DEPENDENCIA
>
> FROM RHU_TAB_PERSONAS p                
>     INNER JOIN ACA_TAB_MATRICULAS am ON p.CEDULA = am.ESTUDIANTE_CEDULA
>     INNER JOIN ACA_TAB_DEPENDENCIAS d1 ON am.DEPEN_CODIGO = d1.CODIGO
>     INNER JOIN ACA_TAB_DEPENDENCIAS d2 ON d1.DEPEN_CODIGO = d2.CODIGO
>     INNER JOIN ACA_TAB_DEPENDENCIAS d3 ON d2.DEPEN_CODIGO = d3.CODIGO
>     INNER JOIN ACA_TAB_CICLOS_ACADEMICOS ca ON am.CICLO_ACAD_CODIGO = ca.CODIGO
>     INNER JOIN ACA_TAB_PERIODOS_ACADEMICOS pa ON (ca.PER_ACAD_CODIGO = pa.CODIGO)
>     LEFT JOIN ACA_TAB_ESTUDIANTE_CARRERAS ec ON (p.CEDULA = ec.ESTUDIANTE_CEDULA AND am.DEPEN_CODIGO = EC.DEPEN_CARRERA AND (ec.ESTADO = 'A' OR ec.termina_carrera = 'S'))
>     LEFT JOIN ACA_TAB_DEPENDENCIAS dp ON ec.DEPEN_CARRERA = dp.CODIGO
> WHERE
>     p.CEDULA = :G_CEDULA_USUARIO
>     AND d3.SIGLAS IN ('PO')
>     AND am.ESTADO IN ('M','R','C')
>
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_CARRERAS_ESTUDIANTE
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=INVALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/documentos
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_CARRERAS_ESTUDIANTE ("NOMBRE", "DEPENDENCIA", "CEDULA") AS
> SELECT
>           d1.NOMBRE AS NOMBRE,
>           EC.DEPEN_CARRERA AS DEPENDENCIA,
>           ec.ESTUDIANTE_CEDULA AS CEDULA
>       FROM UTNDB.ACA_TAB_ESTUDIANTE_CARRERAS ec
>           INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS d1 ON d1.CODIGO = ec.DEPEN_CARRERA
>           INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS d2 ON d1.DEPEN_CODIGO = d2.CODIGO
>           INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS d3 ON d2.DEPEN_CODIGO = d3.CODIGO
>           INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS ca ON ec.ultimo_ciclo = ca.CODIGO
>           INNER JOIN UTNDB.ACA_TAB_PERIODOS_ACADEMICOS pa ON (ca.PER_ACAD_CODIGO = pa.CODIGO)
>       WHERE
>           ec.estado = 'A'
>           AND (ca.estado = 'A' OR EXTRACT(YEAR FROM ca.fecha_fin) IN (EXTRACT(YEAR FROM SYSDATE), EXTRACT(YEAR FROM SYSDATE) - 1))
>       UNION
>       SELECT
>           d1.NOMBRE AS NOMBRE,
>           am.depen_codigo AS DEPENDENCIA,
>           p.CEDULA AS CEDULA
>       FROM UTNDB.RHU_TAB_PERSONAS p
>           INNER JOIN UTNDB.ACA_TAB_MATRICULAS am ON p.CEDULA = am.ESTUDIANTE_CEDULA
>           INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS d1 ON am.DEPEN_CODIGO = d1.CODIGO
>           INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS d2 ON d1.DEPEN_CODIGO = d2.CODIGO
>           INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS d3 ON d2.DEPEN_CODIGO = d3.CODIGO
>           INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS ca ON am.CICLO_ACAD_CODIGO = ca.CODIGO
>           INNER JOIN UTNDB.ACA_TAB_PERIODOS_ACADEMICOS pa ON (ca.PER_ACAD_CODIGO = pa.CODIGO)
>           LEFT JOIN UTNDB.ACA_TAB_ESTUDIANTE_CARRERAS ec ON (p.CEDULA = ec.ESTUDIANTE_CEDULA AND am.DEPEN_CODIGO = ec.DEPEN_CARRERA AND (ec.ESTADO = 'A' OR ec.termina_carrera = 'S'))
>           LEFT JOIN UTNDB.ACA_TAB_DEPENDENCIAS dp ON ec.DEPEN_CARRERA = dp.CODIGO
>       WHERE
>           d3.SIGLAS IN ('PO')
>           AND am.ESTADO IN ('M','R','C')
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> SELECT
>     d1.NOMBRE AS NOMBRE,
>     EC.DEPEN_CARRERA AS DEPENDENCIA,
>     ec.ESTUDIANTE_CEDULA AS CEDULA
> FROM UTNDB.ACA_TAB_ESTUDIANTE_CARRERAS ec
>     INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS d1 ON d1.CODIGO = ec.DEPEN_CARRERA
>     INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS d2 ON d1.DEPEN_CODIGO = d2.CODIGO
>     INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS d3 ON d2.DEPEN_CODIGO = d3.CODIGO
>     INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS ca ON ec.ultimo_ciclo = ca.CODIGO
>     INNER JOIN UTNDB.ACA_TAB_PERIODOS_ACADEMICOS pa ON (ca.PER_ACAD_CODIGO = pa.CODIGO)
> WHERE
>     ec.estado = 'A'
>     AND (ca.estado = 'A' OR EXTRACT(YEAR FROM ca.fecha_fin) IN (EXTRACT(YEAR FROM SYSDATE), EXTRACT(YEAR FROM SYSDATE) - 1))
> UNION
> SELECT
>     d1.NOMBRE AS NOMBRE,
>     am.depen_codigo AS DEPENDENCIA,
>     p.CEDULA AS CEDULA
> FROM UTNDB.RHU_TAB_PERSONAS p
>     INNER JOIN UTNDB.ACA_TAB_MATRICULAS am ON p.CEDULA = am.ESTUDIANTE_CEDULA
>     INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS d1 ON am.DEPEN_CODIGO = d1.CODIGO
>     INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS d2 ON d1.DEPEN_CODIGO = d2.CODIGO
>     INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS d3 ON d2.DEPEN_CODIGO = d3.CODIGO
>     INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS ca ON am.CICLO_ACAD_CODIGO = ca.CODIGO
>     INNER JOIN UTNDB.ACA_TAB_PERIODOS_ACADEMICOS pa ON (ca.PER_ACAD_CODIGO = pa.CODIGO)
>     LEFT JOIN UTNDB.ACA_TAB_ESTUDIANTE_CARRERAS ec ON (p.CEDULA = ec.ESTUDIANTE_CEDULA AND am.DEPEN_CODIGO = ec.DEPEN_CARRERA AND (ec.ESTADO = 'A' OR ec.termina_carrera = 'S'))
>     LEFT JOIN UTNDB.ACA_TAB_DEPENDENCIAS dp ON ec.DEPEN_CARRERA = dp.CODIGO
> WHERE
>     d3.SIGLAS IN ('PO')
>     AND am.ESTADO IN ('M','R','C');
> ```

> [!example]- `MVL_VIEW_ESTUDIANTE_POSGRADO` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** 1col N = 0
>
> **Lo usa:** `src/modules/documentos/repository/consultas/es_estudiante_posgrado_consulta.ts`
>
> **Antes** (`src/modules/documentos/repository/consultas/es_estudiante_posgrado_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const ES_ESTUDIANTE_POSGRADO_CONSULTA = `
> select 
>   1 
> FROM 
>   DUAL 
> WHERE 
>   :G_CEDULA_USUARIO IN(
>     SELECT 
>       ESTUDIANTE_CEDULA 
>     FROM 
>       ACA_TAB_MATRICULAS 
>     WHERE 
>       CICLO_ACAD_CODIGO IN(
>         SELECT 
>           CODIGO 
>         FROM 
>           ACA_TAB_CICLOS_ACADEMICOS 
>         WHERE 
>           ESTADO = 'A' 
>           AND CODIGO LIKE '%P'
>       ) 
>     UNION 
>     SELECT 
>       '0401XXXXXX' AS CEDULA 
>     FROM 
>       DUAL
>   )
>
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_ESTUDIANTE_POSGRADO
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/documentos
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_ESTUDIANTE_POSGRADO ("CEDULA") AS
> SELECT ESTUDIANTE_CEDULA AS CEDULA
> FROM UTNDB.ACA_TAB_MATRICULAS
> WHERE CICLO_ACAD_CODIGO IN (
>     SELECT CODIGO FROM UTNDB.ACA_TAB_CICLOS_ACADEMICOS WHERE ESTADO = 'A' AND CODIGO LIKE '%P'
> )
> UNION
> SELECT '0401XXXXXX' AS CEDULA FROM DUAL
> ;
> ```

> [!example]- `MVL_FUN_DOC_ELECTRONICOS` (función)
> **Resultado:** comparación fila a fila: igual al original
>
> **Nota del registro:** 3col, 2 filas (ID 1 y 8), coincide con original
>
> **Lo usa:** `src/modules/documentos/repository/consultas/documentos_electronicos_personales_consulta.ts`
>
> **Antes** (`src/modules/documentos/repository/consultas/documentos_electronicos_personales_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const DOCUMENTOS_ELECTRONICOS_PERSONALES_CONSULTA = `
> SELECT 
>   TIP.ID_TIPO_DOCUMENTO, 
>   TRANSLATE(TIP.DESCRIPCION, '_', ' ') DOCUMENTO, 
>   DESCARGAR 
> FROM 
>   DOC_TAB_TIPOS_DOCUMENTOS TIP 
>   LEFT JOIN (
>     SELECT 
>       DOC.ID_TIPO_DOCUMENTO, 
>       CASE WHEN DOC.URL_ARCHIVO IS NOT NULL THEN DOC_FUN_URL_DOCUMENTO(DOC.ID_DOCUMENTO) ELSE 'No disponible' END AS DESCARGAR 
>     FROM 
>       DOC_TAB_DOCUMENTOS DOC 
>     WHERE 
>       DOC.CEDULA = :G_CEDULA_USUARIO 
>       AND DOC.ID_TIPO_DOCUMENTO IN(1, 8) 
>       AND ESTADO = 'A' 
>     UNION 
>     SELECT 
>       DOC.ID_TIPO_DOCUMENTO, 
>       'Cargando...' AS DESCARGAR 
>     FROM 
>       DOC_TAB_DOCUMENTOS_TMP DOC 
>     WHERE 
>       DOC.CEDULA = :G_CEDULA_USUARIO 
>       AND DOC.ID_TIPO_DOCUMENTO IN(1, 8) 
>       AND ESTADO = 'A'
>   ) DOCU ON (
>     DOCU.ID_TIPO_DOCUMENTO = TIP.ID_TIPO_DOCUMENTO
>   ) 
> WHERE 
>   TIP.ID_TIPO_DOCUMENTO IN(1, 8) 
> ORDER BY 
>   1
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_FUN_DOC_ELECTRONICOS
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_FUN_DOC_ELECTRONICOS')
> -- Usado por: src/modules/documentos
>
> CREATE OR REPLACE FUNCTION MOVIL_UTN.MVL_FUN_DOC_ELECTRONICOS (
>     p_cedula IN UTNDB.DOC_TAB_DOCUMENTOS.CEDULA%TYPE
> ) RETURN SYS_REFCURSOR
> AS
>     v_cursor SYS_REFCURSOR;
> BEGIN
>     OPEN v_cursor FOR
>         SELECT
>             TIP.ID_TIPO_DOCUMENTO AS "ID_TIPO_DOCUMENTO",
>             TRANSLATE(TIP.DESCRIPCION, '_', ' ') AS "DOCUMENTO",
>             DESCARGAR AS "DESCARGAR"
>         FROM
>             UTNDB.DOC_TAB_TIPOS_DOCUMENTOS TIP
>             LEFT JOIN (
>                 SELECT
>                     DOC.ID_TIPO_DOCUMENTO,
>                     CASE WHEN DOC.URL_ARCHIVO IS NOT NULL THEN DOC_FUN_URL_DOCUMENTO(DOC.ID_DOCUMENTO) ELSE 'No disponible' END AS DESCARGAR
>                 FROM UTNDB.DOC_TAB_DOCUMENTOS DOC
>                 WHERE DOC.CEDULA = p_cedula AND DOC.ID_TIPO_DOCUMENTO IN (1, 8) AND ESTADO = 'A'
>                 UNION
>                 SELECT DOC.ID_TIPO_DOCUMENTO, 'Cargando...' AS DESCARGAR
>                 FROM UTNDB.DOC_TAB_DOCUMENTOS_TMP DOC
>                 WHERE DOC.CEDULA = p_cedula AND DOC.ID_TIPO_DOCUMENTO IN (1, 8) AND ESTADO = 'A'
>             ) DOCU ON (DOCU.ID_TIPO_DOCUMENTO = TIP.ID_TIPO_DOCUMENTO)
>         WHERE TIP.ID_TIPO_DOCUMENTO IN (1, 8)
>         ORDER BY 1;
>     RETURN v_cursor;
> END MVL_FUN_DOC_ELECTRONICOS;
> /
> ```

> [!example]- `MVL_FUN_DOC_POSGRADO` (función)
> **Resultado:** comparación fila a fila: igual al original
>
> **Nota del registro:** 3col, 2 filas (ID 9 y 10), coincide con original
>
> **Lo usa:** `src/modules/documentos/repository/consultas/documentos_posgrado_consulta.ts`
>
> **Antes** (`src/modules/documentos/repository/consultas/documentos_posgrado_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const DOCUMENTOS_POSGRADO_CONSULTA = `
> SELECT 
>   TIP.ID_TIPO_DOCUMENTO, 
>   TRANSLATE(TIP.DESCRIPCION, '_', ' ') DOCUMENTO, 
>   DESCARGAR 
> FROM 
>   DOC_TAB_TIPOS_DOCUMENTOS TIP 
>   LEFT JOIN (
>     SELECT 
>       DOC.ID_TIPO_DOCUMENTO, 
>       CASE WHEN DOC.URL_ARCHIVO IS NOT NULL THEN DOC_FUN_URL_DOCUMENTO(DOC.ID_DOCUMENTO) ELSE 'No disponible' END AS DESCARGAR 
>     FROM 
>       DOC_TAB_DOCUMENTOS DOC 
>     WHERE 
>       DOC.CEDULA = :G_CEDULA_USUARIO 
>       AND DOC.ID_TIPO_DOCUMENTO IN(9, 10) 
>       AND ESTADO = 'A' 
>     UNION 
>     SELECT 
>       DOC.ID_TIPO_DOCUMENTO, 
>       'Cargando...' AS DESCARGAR 
>     FROM 
>       DOC_TAB_DOCUMENTOS_TMP DOC 
>     WHERE 
>       DOC.CEDULA = :G_CEDULA_USUARIO 
>       AND DOC.ID_TIPO_DOCUMENTO IN(9, 10) 
>       AND ESTADO = 'A'
>   ) DOCU ON (
>     DOCU.ID_TIPO_DOCUMENTO = TIP.ID_TIPO_DOCUMENTO
>   ) 
> WHERE 
>   TIP.ID_TIPO_DOCUMENTO IN(9, 10) 
> ORDER BY 
>   1
>
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_FUN_DOC_POSGRADO
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_FUN_DOC_POSGRADO')
> -- Usado por: src/modules/documentos
>
> CREATE OR REPLACE FUNCTION MOVIL_UTN.MVL_FUN_DOC_POSGRADO (
>     p_cedula IN UTNDB.DOC_TAB_DOCUMENTOS.CEDULA%TYPE
> ) RETURN SYS_REFCURSOR
> AS
>     v_cursor SYS_REFCURSOR;
> BEGIN
>     OPEN v_cursor FOR
>         SELECT
>             TIP.ID_TIPO_DOCUMENTO AS "ID_TIPO_DOCUMENTO",
>             TRANSLATE(TIP.DESCRIPCION, '_', ' ') AS "DOCUMENTO",
>             DESCARGAR AS "DESCARGAR"
>         FROM
>             UTNDB.DOC_TAB_TIPOS_DOCUMENTOS TIP
>             LEFT JOIN (
>                 SELECT
>                     DOC.ID_TIPO_DOCUMENTO,
>                     CASE WHEN DOC.URL_ARCHIVO IS NOT NULL THEN DOC_FUN_URL_DOCUMENTO(DOC.ID_DOCUMENTO) ELSE 'No disponible' END AS DESCARGAR
>                 FROM UTNDB.DOC_TAB_DOCUMENTOS DOC
>                 WHERE DOC.CEDULA = p_cedula AND DOC.ID_TIPO_DOCUMENTO IN (9, 10) AND ESTADO = 'A'
>                 UNION
>                 SELECT DOC.ID_TIPO_DOCUMENTO, 'Cargando...' AS DESCARGAR
>                 FROM UTNDB.DOC_TAB_DOCUMENTOS_TMP DOC
>                 WHERE DOC.CEDULA = p_cedula AND DOC.ID_TIPO_DOCUMENTO IN (9, 10) AND ESTADO = 'A'
>             ) DOCU ON (DOCU.ID_TIPO_DOCUMENTO = TIP.ID_TIPO_DOCUMENTO)
>         WHERE TIP.ID_TIPO_DOCUMENTO IN (9, 10)
>         ORDER BY 1;
>     RETURN v_cursor;
> END MVL_FUN_DOC_POSGRADO;
> /
> ```

> [!example]- `MVL_FUN_COM_PENDIENTES` (función)
> **Resultado:** comparación fila a fila: igual al original
>
> **Nota del registro:** 15col, filas coinciden con original (189, 190) y orden por TIPO_ID correcto
>
> **Lo usa:** `src/modules/comunicados/repository/consultas/comunicados_pendientes_consulta.ts`
>
> **Antes** (`src/modules/comunicados/repository/consultas/comunicados_pendientes_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const COMUNICADOS_PENDIENTES_CONSULTA = `
> WITH 
>     -- 1. Facultad del Estudiante
>     info_estudiante AS (
>         SELECT CODIGO_FACULTAD FROM (
>             SELECT TAB_FAC.CODIGO AS CODIGO_FACULTAD
>             FROM UTNDB.ACA_TAB_DEPENDENCIAS TAB_FAC
>             INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_ESC ON (TAB_FAC.CODIGO = TAB_ESC.DEPEN_CODIGO)
>             INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_CARRERA ON (TAB_ESC.CODIGO = TAB_CARRERA.DEPEN_CODIGO)
>             INNER JOIN UTNDB.ACA_TAB_MATRICULAS TAB_MATRICULAS ON (TAB_CARRERA.CODIGO = TAB_MATRICULAS.DEPEN_CODIGO)
>             WHERE TAB_MATRICULAS.ESTADO IN ('C', 'M', 'R') 
>               AND TAB_MATRICULAS.ESTUDIANTE_CEDULA = :cedula
>             ORDER BY TAB_MATRICULAS.FECHA_MATRICULA DESC
>         ) WHERE ROWNUM = 1
>     ),
>     -- 2. Visualizaciones de este usuario (un solo registro por comunicado/usuario)
>     mis_visualizaciones AS (
>         SELECT 
>             ID_COMUNICADO,
>             NVL(NUM_VISUALIZACION, 0) as TOTAL_VISTAS
>         FROM MOVIL_UTN.MVL_TAB_COMUNICADOS_VISUALIZACIONES
>         WHERE USUARIO_CEDULA = :cedula
>     )
> SELECT 
>     c.ID_COMUNICADO,
>     c.CODIGO,
>     c.TITULO,
>     c.MENSAJE,
>     c.TIPO_ID,   
>     c.TARGET_ROL,
>     c.PRIORIDAD,
>     c.ACCION_TIPO,
>     c.ACCION_URL,
>     c.ACCION_BOTON_TEXTO,
>     c.IMAGEN,
>     c.FRECUENCIA,
>     c.MAX_VISUALIZACIONES,
>     c.OBLIGATORIO,
>     NVL(v.TOTAL_VISTAS, 0) as NUM_VISUALIZACIONES
> FROM MOVIL_UTN.MVL_TAB_COMUNICADOS c
> LEFT JOIN mis_visualizaciones v ON c.ID_COMUNICADO = v.ID_COMUNICADO
> LEFT JOIN info_estudiante ie ON 1 = 1 
> WHERE 
>     c.ESTADO = 'A'
>     AND c.FECHA_INICIO <= SYSDATE
>     AND (c.FECHA_FIN IS NULL OR c.FECHA_FIN >= SYSDATE)
>
>     AND c.TARGET_ROL IN ('GENERAL', 'BIENESTAR_ESTUDIANTE')
>
>     AND (
>         c.ALCANCE_TIPO = 'GENERAL'
>         OR (c.ALCANCE_TIPO = 'FACULTAD' AND c.ALCANCE_ID = ie.CODIGO_FACULTAD)
>     )
>
>     AND (
>         c.FRECUENCIA = 'UNA_VEZ'
>         OR c.MAX_VISUALIZACIONES IS NULL 
>         OR c.MAX_VISUALIZACIONES = 0
>         OR NVL(v.TOTAL_VISTAS, 0) < c.MAX_VISUALIZACIONES
>     )
>
>     AND (
>         c.FRECUENCIA IN ('SIEMPRE', 'CADA_SESION') 
>         OR 
>         (c.FRECUENCIA = 'UNA_VEZ' AND v.TOTAL_VISTAS IS NULL)
>     )
>
> ORDER BY 
>     CASE c.TIPO_ID 
>         WHEN 'IMPORTANTE' THEN 1
>         WHEN 'ENCUESTA' THEN 2
>         ELSE 3
>     END ASC,
>     NVL(c.PRIORIDAD, 9999) ASC,
>     c.FECHA_INICIO ASC,
>     c.OBLIGATORIO DESC,
>     c.ID_COMUNICADO ASC
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_FUN_COM_PENDIENTES
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_FUN_COM_PENDIENTES')
> -- Usado por: src/modules/comunicados
>
> CREATE OR REPLACE FUNCTION MOVIL_UTN.MVL_FUN_COM_PENDIENTES (
>     p_cedula IN UTNDB.ACA_TAB_MATRICULAS.ESTUDIANTE_CEDULA%TYPE
> ) RETURN SYS_REFCURSOR
> AS
>     v_cursor SYS_REFCURSOR;
> BEGIN
>     OPEN v_cursor FOR
>         WITH
>             info_estudiante AS (
>                 SELECT CODIGO_FACULTAD FROM (
>                     SELECT TAB_FAC.CODIGO AS CODIGO_FACULTAD
>                     FROM UTNDB.ACA_TAB_DEPENDENCIAS TAB_FAC
>                     INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_ESC ON (TAB_FAC.CODIGO = TAB_ESC.DEPEN_CODIGO)
>                     INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_CARRERA ON (TAB_ESC.CODIGO = TAB_CARRERA.DEPEN_CODIGO)
>                     INNER JOIN UTNDB.ACA_TAB_MATRICULAS TAB_MATRICULAS ON (TAB_CARRERA.CODIGO = TAB_MATRICULAS.DEPEN_CODIGO)
>                     WHERE TAB_MATRICULAS.ESTADO IN ('C', 'M', 'R')
>                       AND TAB_MATRICULAS.ESTUDIANTE_CEDULA = p_cedula
>                     ORDER BY TAB_MATRICULAS.FECHA_MATRICULA DESC
>                 ) WHERE ROWNUM = 1
>             ),
>             mis_visualizaciones AS (
>                 SELECT
>                     ID_COMUNICADO,
>                     NVL(NUM_VISUALIZACION, 0) AS TOTAL_VISTAS
>                 FROM MOVIL_UTN.MVL_TAB_COMUNICADOS_VISUALIZACIONES
>                 WHERE USUARIO_CEDULA = p_cedula
>             )
>         SELECT
>             c.ID_COMUNICADO       AS "ID_COMUNICADO",
>             c.CODIGO              AS "CODIGO",
>             c.TITULO              AS "TITULO",
>             c.MENSAJE             AS "MENSAJE",
>             c.TIPO_ID             AS "TIPO_ID",
>             c.TARGET_ROL          AS "TARGET_ROL",
>             c.PRIORIDAD           AS "PRIORIDAD",
>             c.ACCION_TIPO         AS "ACCION_TIPO",
>             c.ACCION_URL          AS "ACCION_URL",
>             c.ACCION_BOTON_TEXTO  AS "ACCION_BOTON_TEXTO",
>             c.IMAGEN              AS "IMAGEN",
>             c.FRECUENCIA          AS "FRECUENCIA",
>             c.MAX_VISUALIZACIONES AS "MAX_VISUALIZACIONES",
>             c.OBLIGATORIO         AS "OBLIGATORIO",
>             NVL(v.TOTAL_VISTAS, 0) AS "NUM_VISUALIZACIONES"
>         FROM MOVIL_UTN.MVL_TAB_COMUNICADOS c
>         LEFT JOIN mis_visualizaciones v ON c.ID_COMUNICADO = v.ID_COMUNICADO
>         LEFT JOIN info_estudiante ie ON 1 = 1
>         WHERE
>             c.ESTADO = 'A'
>             AND c.FECHA_INICIO <= SYSDATE
>             AND (c.FECHA_FIN IS NULL OR c.FECHA_FIN >= SYSDATE)
>             AND c.TARGET_ROL IN ('GENERAL', 'BIENESTAR_ESTUDIANTE')
>             AND (
>                 c.ALCANCE_TIPO = 'GENERAL'
>                 OR (c.ALCANCE_TIPO = 'FACULTAD' AND c.ALCANCE_ID = ie.CODIGO_FACULTAD)
>             )
>             AND (
>                 c.FRECUENCIA = 'UNA_VEZ'
>                 OR c.MAX_VISUALIZACIONES IS NULL
>                 OR c.MAX_VISUALIZACIONES = 0
>                 OR NVL(v.TOTAL_VISTAS, 0) < c.MAX_VISUALIZACIONES
>             )
>             AND (
>                 c.FRECUENCIA IN ('SIEMPRE', 'CADA_SESION')
>                 OR
>                 (c.FRECUENCIA = 'UNA_VEZ' AND v.TOTAL_VISTAS IS NULL)
>             )
>         ORDER BY
>             CASE c.TIPO_ID
>                 WHEN 'IMPORTANTE' THEN 1
>                 WHEN 'ENCUESTA' THEN 2
>                 ELSE 3
>             END ASC,
>             NVL(c.PRIORIDAD, 9999) ASC,
>             c.FECHA_INICIO ASC,
>             c.OBLIGATORIO DESC,
>             c.ID_COMUNICADO ASC;
>     RETURN v_cursor;
> END MVL_FUN_COM_PENDIENTES;
> /
> ```

> [!example]- `MVL_FUN_MODAL_ACTUAL` (función)
> **Resultado:** comparación fila a fila: igual al original
>
> **Nota del registro:** 6col 0 filas (coincide, cuenta sin modal pendiente)
>
> **Lo usa:** `src/modules/modales_informativos/repository/consultas/modales_informativos.consulta.ts`
>
> **Antes** (`src/modules/modales_informativos/repository/consultas/modales_informativos.consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const MODAL_INFORMATIVO_ACTUAL_CONSULTA = `
> WITH
>     InfoEstudiante AS (
>         SELECT SIGLAS FROM (
>             SELECT TAB_FAC.SIGLAS
>             FROM UTNDB.ACA_TAB_DEPENDENCIAS TAB_FAC
>             INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_ESC ON (TAB_FAC.CODIGO = TAB_ESC.DEPEN_CODIGO)
>             INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_CARRERA ON (TAB_ESC.CODIGO = TAB_CARRERA.DEPEN_CODIGO)
>             INNER JOIN UTNDB.ACA_TAB_MATRICULAS TAB_MATRICULAS ON (TAB_CARRERA.CODIGO = TAB_MATRICULAS.DEPEN_CODIGO)
>             INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
>                 TAB_MATRICULAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA 
>                 AND TAB_MATRICULAS.CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>             )
>             WHERE TAB_MATRICULAS.ESTADO IN ('C', 'M', 'R') 
>             AND TAB_MATRICULAS.NIVEL_CODIGO NOT IN ('AD') 
>             AND TAB_DETALLE_MATRICULAS.ANULACION != 'S' 
>             AND TAB_MATRICULAS.ESTUDIANTE_CEDULA = :cedula
>             ORDER BY TAB_MATRICULAS.FECHA_MATRICULA DESC
>         )
>         WHERE ROWNUM = 1
>     ),
>     ListaFacultades AS (
>         -- Definimos la lista explícita de facultades
>         SELECT 'FICA' AS SIGLAS FROM DUAL UNION ALL
>         SELECT 'FICAYA' FROM DUAL UNION ALL
>         SELECT 'FACAE' FROM DUAL UNION ALL
>         SELECT 'FCCSS' FROM DUAL UNION ALL
>         SELECT 'FECYT' FROM DUAL UNION ALL
>         SELECT 'PO' FROM DUAL
>     )
> SELECT
>     ENC.ENCUESTA_CODIGO     AS "CODIGO_ENCUESTA",
>     ENC.DESCRIPCION         AS "DESCRIPCION",
>     ENC.ENLACE_EXTERNO      AS "ENLACE_EXTERNO",
>     ENC.IMAGEN_BANNER       AS "IMAGEN_BANNER",
>     ENC.FECHA_INICIO        AS "FECHA_INICIO",
>     ENC.FECHA_FIN           AS "FECHA_FIN"
> FROM
>     UTNDB.ENC_TAB_ENCUESTA ENC
> LEFT JOIN InfoEstudiante IE ON 1=1
> WHERE
>     ENC.ESTADO = 'A'
>     AND SYSDATE BETWEEN ENC.FECHA_INICIO AND ENC.FECHA_FIN
>     AND NOT EXISTS (
>         SELECT 1 FROM UTNDB.ENC_TAB_ENCUESTA_USUARIO ENU
>         WHERE ENU.ENCUESTA_CODIGO = ENC.ENCUESTA_CODIGO AND ENU.CEDULA_USUARIO = :cedula
>     )
>     AND NVL(ENC.MOSTRAR_ESTUDIANTES, 'S') != 'N'
>     AND (
>         (IE.SIGLAS IS NOT NULL AND 
>          REGEXP_LIKE(ENC.ENCUESTA_CODIGO, '(^|[-_])' || IE.SIGLAS || '($|[-_])')
>         )
>         OR
>         (
>             NOT EXISTS (
>                 SELECT 1 FROM ListaFacultades F
>                 WHERE REGEXP_LIKE(ENC.ENCUESTA_CODIGO, '(^|[-_])' || F.SIGLAS || '($|[-_])')
>             )
>             AND ENC.MOSTRAR_ESTUDIANTES = 'S'
>         )
>     )
> ORDER BY
>     CASE
>         WHEN (IE.SIGLAS IS NOT NULL AND 
>               REGEXP_LIKE(ENC.ENCUESTA_CODIGO, '(^|[-_])' || IE.SIGLAS || '($|[-_])')) THEN 1
>         ELSE 2
>     END,
>     ENC.FECHA_CREACION DESC
> FETCH FIRST 1 ROWS ONLY
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_FUN_MODAL_ACTUAL
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=INVALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_FUN_MODAL_ACTUAL')
> -- Usado por: src/modules/modales_informativos
>
> CREATE OR REPLACE FUNCTION MOVIL_UTN.MVL_FUN_MODAL_ACTUAL (
>     p_cedula IN UTNDB.ACA_TAB_MATRICULAS.ESTUDIANTE_CEDULA%TYPE
> ) RETURN SYS_REFCURSOR
> AS
>     v_cursor SYS_REFCURSOR;
> BEGIN
>     OPEN v_cursor FOR
>         WITH
>             InfoEstudiante AS (
>                 SELECT SIGLAS FROM (
>                     SELECT TAB_FAC.SIGLAS
>                     FROM UTNDB.ACA_TAB_DEPENDENCIAS TAB_FAC
>                     INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_ESC ON (TAB_FAC.CODIGO = TAB_ESC.DEPEN_CODIGO)
>                     INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_CARRERA ON (TAB_ESC.CODIGO = TAB_CARRERA.DEPEN_CODIGO)
>                     INNER JOIN UTNDB.ACA_TAB_MATRICULAS TAB_MATRICULAS ON (TAB_CARRERA.CODIGO = TAB_MATRICULAS.DEPEN_CODIGO)
>                     INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
>                         TAB_MATRICULAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>                         AND TAB_MATRICULAS.CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>                     )
>                     WHERE TAB_MATRICULAS.ESTADO IN ('C', 'M', 'R')
>                     AND TAB_MATRICULAS.NIVEL_CODIGO NOT IN ('AD')
>                     AND TAB_DETALLE_MATRICULAS.ANULACION != 'S'
>                     AND TAB_MATRICULAS.ESTUDIANTE_CEDULA = p_cedula
>                     ORDER BY TAB_MATRICULAS.FECHA_MATRICULA DESC
>                 )
>                 WHERE ROWNUM = 1
>             ),
>             ListaFacultades AS (
>                 SELECT 'FICA' AS SIGLAS FROM DUAL UNION ALL
>                 SELECT 'FICAYA' FROM DUAL UNION ALL
>                 SELECT 'FACAE' FROM DUAL UNION ALL
>                 SELECT 'FCCSS' FROM DUAL UNION ALL
>                 SELECT 'FECYT' FROM DUAL UNION ALL
>                 SELECT 'PO' FROM DUAL
>             )
>         SELECT
>             ENC.ENCUESTA_CODIGO AS "CODIGO_ENCUESTA",
>             ENC.DESCRIPCION     AS "DESCRIPCION",
>             ENC.ENLACE_EXTERNO  AS "ENLACE_EXTERNO",
>             ENC.IMAGEN_BANNER   AS "IMAGEN_BANNER",
>             ENC.FECHA_INICIO    AS "FECHA_INICIO",
>             ENC.FECHA_FIN       AS "FECHA_FIN"
>         FROM
>             UTNDB.ENC_TAB_ENCUESTA ENC
>         LEFT JOIN InfoEstudiante IE ON 1=1
>         WHERE
>             ENC.ESTADO = 'A'
>             AND SYSDATE BETWEEN ENC.FECHA_INICIO AND ENC.FECHA_FIN
>             AND NOT EXISTS (
>                 SELECT 1 FROM UTNDB.ENC_TAB_ENCUESTA_USUARIO ENU
>                 WHERE ENU.ENCUESTA_CODIGO = ENC.ENCUESTA_CODIGO AND ENU.CEDULA_USUARIO = p_cedula
>             )
>             AND NVL(ENC.MOSTRAR_ESTUDIANTES, 'S') != 'N'
>             AND (
>                 (IE.SIGLAS IS NOT NULL AND
>                  REGEXP_LIKE(ENC.ENCUESTA_CODIGO, '(^|[-_])' || IE.SIGLAS || '($|[-_])')
>                 )
>                 OR
>                 (
>                     NOT EXISTS (
>                         SELECT 1 FROM ListaFacultades F
>                         WHERE REGEXP_LIKE(ENC.ENCUESTA_CODIGO, '(^|[-_])' || F.SIGLAS || '($|[-_])')
>                     )
>                     AND ENC.MOSTRAR_ESTUDIANTES = 'S'
>                 )
>             )
>         ORDER BY
>             CASE
>                 WHEN (IE.SIGLAS IS NOT NULL AND
>                       REGEXP_LIKE(ENC.ENCUESTA_CODIGO, '(^|[-_])' || IE.SIGLAS || '($|[-_])')) THEN 1
>                 ELSE 2
>             END,
>             ENC.FECHA_CREACION DESC
>         FETCH FIRST 1 ROWS ONLY;
>     RETURN v_cursor;
> END MVL_FUN_MODAL_ACTUAL;
> /
> ```

> [!example]- `MVL_FUN_PAGOS_ESTUDIANTE` (función)
> **Resultado:** comparación fila a fila: igual al original
>
> **Nota del registro:** 13col 0 filas (coincide, cuenta sin pagos)
>
> **Lo usa:** `src/modules/pagos/repository/consultas/get_pagos_estudiante_consulta.ts`
>
> **Antes** (`src/modules/pagos/repository/consultas/get_pagos_estudiante_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const GET_PAGOS_ESTUDIANTE_CONSULTA = `
> WITH transacciones_agrupadas AS (
>     SELECT
>         V.NRO_TRANSACCION,
>         MAX(V.FECHA_EMITE) as FECHA_EMITE,
>         MAX(V.FECHA_CANJEA) as FECHA_CANJEA,
>         MAX(V.NRO_DOCUMENTO) as NRO_DOCUMENTO,
>         MAX(V.DESCRIPCION_ESTADO) as DESCRIPCION_ESTADO,
>         MAX(V.TOTAL_TRANSACCION) as TOTAL_TRANSACCION,
>         MAX(V.RTEP_ID_ESTADO_PROCESO) as RTEP_ID_ESTADO_PROCESO,
>         MAX(CASE
>             WHEN (V.TPROC_COD_PROCESO IN ('MU', 'MP', 'VG', 'AP') AND V.RTEP_ID_ESTADO_PROCESO = 3) THEN 1
>             ELSE 0
>         END) as PUEDE_IMPRIMIR_FACTURA,
>         MAX(CASE
>             WHEN (V.TPROC_COD_PROCESO = 'MU') THEN 1
>             ELSE 0
>         END) as PUEDE_IMPRIMIR_MATRICULA
>     FROM
>         UTNDB.REC_VIEW_CONCEPTOS_BENEFICIAR V
>     WHERE
>         V.PERSONA_CEDULA = :cedula
>     GROUP BY
>         V.NRO_TRANSACCION
>     ORDER BY
>         MAX(V.FECHA_EMITE) DESC
>     OFFSET :skip ROWS FETCH NEXT :limit ROWS ONLY
> )
> SELECT 
>     TA.FECHA_EMITE,
>     TA.FECHA_CANJEA,
>     TA.NRO_DOCUMENTO,
>     TA.DESCRIPCION_ESTADO,
>     V.DESCRIPCION_CONCEPTO,
>     V.CANTIDAD,
>     V.VALOR_CONCEPTO,
>     V.SUBTOTAL,
>     TA.TOTAL_TRANSACCION,
>     TA.NRO_TRANSACCION,
>     TA.RTEP_ID_ESTADO_PROCESO,
>     TA.PUEDE_IMPRIMIR_FACTURA,
>     TA.PUEDE_IMPRIMIR_MATRICULA
> FROM transacciones_agrupadas TA
> JOIN UTNDB.REC_VIEW_CONCEPTOS_BENEFICIAR V 
>     ON TA.NRO_TRANSACCION = V.NRO_TRANSACCION 
>     AND V.PERSONA_CEDULA = :cedula
> ORDER BY 
>     TA.FECHA_EMITE DESC
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_FUN_PAGOS_ESTUDIANTE
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=INVALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_FUN_PAGOS_ESTUDIANTE')
> -- Usado por: src/modules/pagos
>
> CREATE OR REPLACE FUNCTION MOVIL_UTN.MVL_FUN_PAGOS_ESTUDIANTE (
>     p_cedula IN UTNDB.REC_VIEW_CONCEPTOS_BENEFICIAR.PERSONA_CEDULA%TYPE,
>     p_skip   IN PLS_INTEGER,
>     p_limit  IN PLS_INTEGER
> ) RETURN SYS_REFCURSOR
> AS
>     v_cursor SYS_REFCURSOR;
> BEGIN
>     OPEN v_cursor FOR
>         WITH transacciones_agrupadas AS (
>             SELECT
>                 V.NRO_TRANSACCION,
>                 MAX(V.FECHA_EMITE) as FECHA_EMITE,
>                 MAX(V.FECHA_CANJEA) as FECHA_CANJEA,
>                 MAX(V.NRO_DOCUMENTO) as NRO_DOCUMENTO,
>                 MAX(V.DESCRIPCION_ESTADO) as DESCRIPCION_ESTADO,
>                 MAX(V.TOTAL_TRANSACCION) as TOTAL_TRANSACCION,
>                 MAX(V.RTEP_ID_ESTADO_PROCESO) as RTEP_ID_ESTADO_PROCESO,
>                 MAX(CASE WHEN (V.TPROC_COD_PROCESO IN ('MU', 'MP', 'VG', 'AP') AND V.RTEP_ID_ESTADO_PROCESO = 3) THEN 1 ELSE 0 END) as PUEDE_IMPRIMIR_FACTURA,
>                 MAX(CASE WHEN (V.TPROC_COD_PROCESO = 'MU') THEN 1 ELSE 0 END) as PUEDE_IMPRIMIR_MATRICULA
>             FROM UTNDB.REC_VIEW_CONCEPTOS_BENEFICIAR V
>             WHERE V.PERSONA_CEDULA = p_cedula
>             GROUP BY V.NRO_TRANSACCION
>             ORDER BY MAX(V.FECHA_EMITE) DESC
>             OFFSET p_skip ROWS FETCH NEXT p_limit ROWS ONLY
>         )
>         SELECT
>             TA.FECHA_EMITE AS "FECHA_EMITE", TA.FECHA_CANJEA AS "FECHA_CANJEA",
>             TA.NRO_DOCUMENTO AS "NRO_DOCUMENTO", TA.DESCRIPCION_ESTADO AS "DESCRIPCION_ESTADO",
>             V.DESCRIPCION_CONCEPTO AS "DESCRIPCION_CONCEPTO", V.CANTIDAD AS "CANTIDAD",
>             V.VALOR_CONCEPTO AS "VALOR_CONCEPTO", V.SUBTOTAL AS "SUBTOTAL",
>             TA.TOTAL_TRANSACCION AS "TOTAL_TRANSACCION", TA.NRO_TRANSACCION AS "NRO_TRANSACCION",
>             TA.RTEP_ID_ESTADO_PROCESO AS "RTEP_ID_ESTADO_PROCESO",
>             TA.PUEDE_IMPRIMIR_FACTURA AS "PUEDE_IMPRIMIR_FACTURA",
>             TA.PUEDE_IMPRIMIR_MATRICULA AS "PUEDE_IMPRIMIR_MATRICULA"
>         FROM transacciones_agrupadas TA
>         JOIN UTNDB.REC_VIEW_CONCEPTOS_BENEFICIAR V ON TA.NRO_TRANSACCION = V.NRO_TRANSACCION AND V.PERSONA_CEDULA = p_cedula
>         ORDER BY TA.FECHA_EMITE DESC;
>     RETURN v_cursor;
> END MVL_FUN_PAGOS_ESTUDIANTE;
> /
> ```

> [!example]- `MVL_VIEW_FACULTAD_POSTGRADO` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** N=N=0 en ambos sentidos
>
> **Lo usa:** `src/modules/validacion_acceso/repository/consultas/validar_facultad_postgrado.consulta.ts`
>
> **Antes** (`src/modules/validacion_acceso/repository/consultas/validar_facultad_postgrado.consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> /**
>  * Consulta para verificar si un estudiante pertenece a la facultad de Postgrado (PO)
>  * en su matrícula VIGENTE.
>  *
>  * Verifica la jerarquía: Matrícula → Carrera → Escuela → Facultad
>  * para determinar si las siglas de la facultad son 'PO'.
>  *
>  * FIX 2026-09-08: se agregó el filtro de ciclo activo (CA.ESTADO='A') y
>  * estado de matrícula (MATR.ESTADO IN ('R','C','M')), igual que en
>  * MVL_VIEW_VALIDAR_FICHA_SOCIO. Sin este filtro, un estudiante que
>  * ALGUNA VEZ estuvo matriculado en Postgrado (aunque ahora curse pregrado
>  * en otra facultad) quedaba restringido de FORMATOS_VINCULACION para
>  * siempre — bug de datos históricos, no de diseño.
>  *
>  * Los estudiantes de Postgrado tienen restricciones en ciertos módulos
>  * como Formatos de Vinculación, ya que estos aplican solo a pregrado.
>  *
>  * Si retorna filas → El estudiante pertenece a Postgrado (PO) en el ciclo activo
>  * Si retorna 0 filas → El estudiante NO pertenece a Postgrado en el ciclo activo
>  */
> export const VALIDAR_FACULTAD_POSTGRADO_CONSULTA = `
> SELECT DISTINCT FAC.SIGLAS
> FROM ACA_TAB_MATRICULAS MATR
> INNER JOIN ACA_TAB_CICLOS_ACADEMICOS CA ON(CA.CODIGO=MATR.CICLO_ACAD_CODIGO)
> INNER JOIN ACA_TAB_DEPENDENCIAS CAR ON(CAR.CODIGO=MATR.DEPEN_CODIGO)
> INNER JOIN ACA_TAB_DEPENDENCIAS ESC ON(ESC.CODIGO=CAR.DEPEN_CODIGO)
> INNER JOIN ACA_TAB_DEPENDENCIAS FAC ON(FAC.CODIGO=ESC.DEPEN_CODIGO)
> INNER JOIN ACA_TAB_DETALLE_MATRICULAS DET ON(DET.MATRICULA_CODIGO=MATR.CODIGO)
> WHERE CA.ESTADO='A'
> AND MATR.ESTADO IN('R','C','M')
> AND FAC.SIGLAS IN('PO')
> AND DET.ESTUDIANTE_CEDULA = :cedula
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_FACULTAD_POSTGRADO
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/validacion_acceso
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_FACULTAD_POSTGRADO ("CEDULA", "SIGLAS") AS
> SELECT DISTINCT
>     DET.ESTUDIANTE_CEDULA AS CEDULA,
>     FAC.SIGLAS AS SIGLAS
> FROM UTNDB.ACA_TAB_MATRICULAS MATR
> INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS CA ON (CA.CODIGO = MATR.CICLO_ACAD_CODIGO)
> INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS CAR ON (CAR.CODIGO = MATR.DEPEN_CODIGO)
> INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS ESC ON (ESC.CODIGO = CAR.DEPEN_CODIGO)
> INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS FAC ON (FAC.CODIGO = ESC.DEPEN_CODIGO)
> INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS DET ON (DET.MATRICULA_CODIGO = MATR.CODIGO)
> WHERE CA.ESTADO = 'A'
> AND MATR.ESTADO IN ('R','C','M')
> AND FAC.SIGLAS IN ('PO')
> ;
> ```

> [!example]- `MVL_VIEW_CALENDARIO_ACTIVIDADES` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** 9col, 0 filas en ambos sentidos del MINUS.
>
> **Lo usa:** `src/modules/calendario_actividades/repository/consultas/calendario_actividades_consulta.ts`
>
> **Antes** (`src/modules/calendario_actividades/repository/consultas/calendario_actividades_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> // FIX 2026-09-08 (paginación por rango de fechas): antes esta consulta no
> // tenía ningún límite superior por fecha (traía TODO el historial del
> // estudiante desde que empezó a estudiar, ~225KB por carga). Se agregó
> // `ACTIVIDAD.FECHA_INICIO BETWEEN :FECHA_DESDE AND :FECHA_HASTA` en ambas
> // ramas del OR. El orden de aparición de los binds nombrados en el texto
> // determina el orden posicional del array que recibe dataSource.query():
> // 1) CUENTA, 2) FECHA_DESDE, 3) FECHA_HASTA -- ver calendario_actividades.repository.ts.
> //
> // Los límites REALES y completos (sin ventana) se calculan aparte en
> // CALENDARIO_ACTIVIDADES_LIMITES_CONSULTA, más abajo en este archivo — deben
> // mantenerse en sync si cambia el FROM/WHERE de esta consulta.
> export const CALENDARIO_ACTIVIDADES_CONSULTA = `
> SELECT
>     DISTINCT CASE
>         WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 5 THEN 'P'
>         WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 2 THEN 'X'
>         ELSE 'A'
>     END AS TIPO,
>     ACT_ALUMNO.ID_ACTIVIDAD_ALUMNO AS ID_ACTIVIDAD_ALUMNO,
>     ACTIVIDAD.NOMBRE_CORTO,
>     ACTIVIDAD.FECHA_FIN AS FECHA_FIN,
>     ACTIVIDAD.FECHA_INICIO AS FECHA_INICIO,
>     MATERIA.DESCRIPCION "MATERIA",
>     ACT_ALUMNO.ENTREGADO,
>     (
>         CASE
>             WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 7 THEN 'NO_REQUIERE_ADJUNTO'
>             WHEN ACT_ALUMNO.ENTREGADO = 'SI' AND ACT_ALUMNO.ID_DOCUMENTO_DIRECTORIO IS NOT NULL THEN 'ENTREGADO_CON_ADJUNTO'
>             WHEN ACT_ALUMNO.ENTREGADO = 'SI' AND ACT_ALUMNO.ID_DOCUMENTO_DIRECTORIO IS NULL THEN 'ENTREGADO_SIN_ADJUNTO'
>             ELSE 'NO_ENTREGADO'
>         END
>     ) AS CON_ADJUNTO,
>     ACTIVIDAD.ID_aCTIVIDAD
> FROM
>     LMS_TAB_ACTIVIDAD_ACADEMICA ACTIVIDAD
>     INNER JOIN LMS_TAB_AULAS_VIRTUALES AULA ON (AULA.ID_CURSO = ACTIVIDAD.ID_CURSO)
>     INNER JOIN ACA_TAB_CICLOS_ACADEMICOS CICLO ON (CICLO.CODIGO = AULA.CODIGO_CICLO_ACAD)
>     INNER JOIN LMS_TAB_INTEGRANTES INTEGRANTE ON (INTEGRANTE.ID_CURSO = AULA.ID_CURSO)
>     AND (INTEGRANTE.ESTADO = 'A')
>     INNER JOIN ACA_TAB_MATERIAS MATERIA ON (
>         MATERIA.CODIGO = AULA.CODIGO_MATERIA
>         AND MATERIA.NIVEL_CODIGO = AULA.CODIGO_NIVEL
>     )
>     INNER JOIN INS_TAB_USUARIOS USUARIO ON (
>         USUARIO.PERSONA_CEDULA = INTEGRANTE.CEDULA_INTEGRANTE
>     )
>     INNER JOIN LMS_TAB_ACTIVIDADES_ALUMNOS ACT_ALUMNO ON (
>         ACT_ALUMNO.ID_ACTIVIDAD = ACTIVIDAD.ID_ACTIVIDAD
>         AND ACT_ALUMNO.CEDULA_INTEGRANTE = INTEGRANTE.CEDULA_INTEGRANTE
>     )
>     AND ACT_ALUMNO.ESTADO = 'A'
>     INNER JOIN UTNDB.ACA_TAB_MATRICULAS ACA_TAB_MATRICULAS ON (
>         ACA_TAB_MATRICULAS.ESTUDIANTE_CEDULA = INTEGRANTE.CEDULA_INTEGRANTE
>     ) --AND (ACA_TAB_MATRICULAS.MODA_ESTUD_CODIGO = AULA.CODIGO_MOD_EST)
>     --AND (ACA_TAB_MATRICULAS.SIST_ESTUD_CODIGO = AULA.CODIGO_SIS_EST)
>     -- AND (ACA_TAB_MATRICULAS.TCICLOACAD_CODIGO =  AULA.CODIGO_TCICLO_ACAD)
>     --AND (ACA_TAB_MATRICULAS.TFINANCIA_CODIGO =   AULA.CODIGO_TIPO_FINANC)
>     AND (
>         ACA_TAB_MATRICULAS.CICLO_ACAD_CODIGO = AULA.CODIGO_CICLO_ACAD
>     ) --AND (ACA_TAB_MATRICULAS.DEPEN_CODIGO = AULA.CODIGO_DEPENDENCIA)
>     --de aqui tambien descomentar estado matricual
>     --AND ACA_TAB_MATRICULAS.ESTADO IN ('R', 'M', 'C', 'P')
>     INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS ACA_TAB_DETALLE_MATRICULAS ON (
>         ACA_TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA = ACA_TAB_MATRICULAS.ESTUDIANTE_CEDULA
>     )
>     AND (
>         ACA_TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO = ACA_TAB_MATRICULAS.CODIGO
>     )
>     AND (
>         ACA_TAB_DETALLE_MATRICULAS.MATERIA_CODIGO = AULA.CODIGO_MATERIA
>     )
>     AND (
>         ACA_TAB_DETALLE_MATRICULAS.PARALELO_CODIGO = AULA.CODIGO_PARALELO
>     )
>     AND (ACA_TAB_DETALLE_MATRICULAS.ANULACION != 'S')
>     AND ACA_TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO = AULA.CODIGO_CICLO_ACAD
>     LEFT JOIN ACA_TAB_NOTAS ON (
>         ACA_TAB_NOTAS.ESTUDIANTE_CEDULA = ACA_TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>     )
>     AND (
>         ACA_TAB_NOTAS.MATRICULA_CODIGO = ACA_TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>     )
>     AND (
>         ACA_TAB_NOTAS.NIVEL_CODIGO = ACA_TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
>     )
>     AND (
>         ACA_TAB_NOTAS.MATERIA_CODIGO = ACA_TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
>     )
>     AND (
>         ACA_TAB_NOTAS.DEPEN_CODIGO = ACA_TAB_DETALLE_MATRICULAS.DEPEN_CODIGO
>     )
>     AND (
>         ACA_TAB_NOTAS.INST_CODIGO = ACA_TAB_DETALLE_MATRICULAS.INST_CODIGO
>     )
>     AND (
>         ACA_TAB_NOTAS.TFINANCIA_CODIGO = ACA_TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO
>     )
>     AND (
>         ACA_TAB_NOTAS.MODA_ESTUD_CODIGO = ACA_TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO
>     )
>     AND (
>         ACA_TAB_NOTAS.TCICLOACAD_CODIGO = ACA_TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO
>     )
>     AND (
>         ACA_TAB_NOTAS.SIST_ESTUD_CODIGO = ACA_TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO
>     )
>     AND (
>         ACA_TAB_NOTAS.CICLO_ACAD_CODIGO = ACA_TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>     )
>     AND (
>         ACA_TAB_NOTAS.PARALELO_CODIGO = ACA_TAB_DETALLE_MATRICULAS.PARALELO_CODIGO
>     )
>     AND (
>         ACA_TAB_NOTAS.DOCENTE_CEDULA = ACA_TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA
>     ) --AND (ACA_TAB_DETALLE_MATRICULAS.DEPEN_CODIGO = AULA.CODIGO_DEPENDENCIA)
> WHERE
>     (
>         ACTIVIDAD.ESTADO = 'A'
>         AND (
>             GREATEST (SYSDATE, ACTIVIDAD.FECHA_INICIO) = SYSDATE
>             OR ACTIVIDAD.TIPO_ACTIVIDAD = 7
>         )
>         AND USUARIO.CUENTA = :CUENTA
>         AND ACTIVIDAD.FECHA_INICIO BETWEEN :FECHA_DESDE AND :FECHA_HASTA
>         AND (INTEGRANTE.ESTADO = 'A')
>         AND ACT_ALUMNO.ESTADO = 'A' --AQUI ES ESTADO DE LA MATRICULA
>         AND ACA_TAB_MATRICULAS.ESTADO IN ('R', 'M', 'C')
>         AND ACTIVIDAD.CODIGO_PARCIAL != 'N3'
>     )
>     OR (
>         ACTIVIDAD.ESTADO = 'A'
>         AND (
>             GREATEST (SYSDATE, ACTIVIDAD.FECHA_INICIO) = SYSDATE
>             OR ACTIVIDAD.TIPO_ACTIVIDAD = 7
>         )
>         AND USUARIO.CUENTA = :CUENTA
>         AND ACTIVIDAD.FECHA_INICIO BETWEEN :FECHA_DESDE AND :FECHA_HASTA
>         AND (INTEGRANTE.ESTADO = 'A')
>         AND ACT_ALUMNO.ESTADO = 'A' --AQUI ES
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_CALENDARIO_ACTIVIDADES
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      DBMS_METADATA.GET_DDL('VIEW', 'MVL_VIEW_CALENDARIO_ACTIVIDADES', 'MOVIL_UTN')
> -- Usado por: src/modules/calendario_actividades
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_CALENDARIO_ACTIVIDADES ("TIPO", "ID_ACTIVIDAD_ALUMNO", "NOMBRE_CORTO", "FECHA_FIN", "FECHA_INICIO", "MATERIA", "ENTREGADO", "CON_ADJUNTO", "ID_ACTIVIDAD", "CUENTA") AS
> SELECT
>     DISTINCT CASE
>         WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 5 THEN 'P'
>         WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 2 THEN 'X'
>         ELSE 'A'
>     END AS TIPO,
>     ACT_ALUMNO.ID_ACTIVIDAD_ALUMNO AS ID_ACTIVIDAD_ALUMNO,
>     ACTIVIDAD.NOMBRE_CORTO AS NOMBRE_CORTO,
>     ACTIVIDAD.FECHA_FIN AS FECHA_FIN,
>     ACTIVIDAD.FECHA_INICIO AS FECHA_INICIO,
>     MATERIA.DESCRIPCION AS MATERIA,
>     ACT_ALUMNO.ENTREGADO AS ENTREGADO,
>     (
>         CASE
>             WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 7 THEN 'NO_REQUIERE_ADJUNTO'
>             WHEN ACT_ALUMNO.ENTREGADO = 'SI' AND ACT_ALUMNO.ID_DOCUMENTO_DIRECTORIO IS NOT NULL THEN 'ENTREGADO_CON_ADJUNTO'
>             WHEN ACT_ALUMNO.ENTREGADO = 'SI' AND ACT_ALUMNO.ID_DOCUMENTO_DIRECTORIO IS NULL THEN 'ENTREGADO_SIN_ADJUNTO'
>             ELSE 'NO_ENTREGADO'
>         END
>     ) AS CON_ADJUNTO,
>     ACTIVIDAD.ID_ACTIVIDAD AS ID_ACTIVIDAD,
>     USUARIO.CUENTA AS CUENTA
> FROM
>     UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA ACTIVIDAD
>     INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES AULA ON (AULA.ID_CURSO = ACTIVIDAD.ID_CURSO)
>     INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS CICLO ON (CICLO.CODIGO = AULA.CODIGO_CICLO_ACAD)
>     INNER JOIN UTNDB.LMS_TAB_INTEGRANTES INTEGRANTE ON (INTEGRANTE.ID_CURSO = AULA.ID_CURSO)
>         AND (INTEGRANTE.ESTADO = 'A')
>     INNER JOIN UTNDB.ACA_TAB_MATERIAS MATERIA ON (
>         MATERIA.CODIGO = AULA.CODIGO_MATERIA
>         AND MATERIA.NIVEL_CODIGO = AULA.CODIGO_NIVEL
>     )
>     INNER JOIN UTNDB.INS_TAB_USUARIOS USUARIO ON (
>         USUARIO.PERSONA_CEDULA = INTEGRANTE.CEDULA_INTEGRANTE
>     )
>     INNER JOIN UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS ACT_ALUMNO ON (
>         ACT_ALUMNO.ID_ACTIVIDAD = ACTIVIDAD.ID_ACTIVIDAD
>         AND ACT_ALUMNO.CEDULA_INTEGRANTE = INTEGRANTE.CEDULA_INTEGRANTE
>     )
>         AND ACT_ALUMNO.ESTADO = 'A'
>     INNER JOIN UTNDB.ACA_TAB_MATRICULAS ACA_TAB_MATRICULAS ON (
>         ACA_TAB_MATRICULAS.ESTUDIANTE_CEDULA = INTEGRANTE.CEDULA_INTEGRANTE
>     )
>         AND (ACA_TAB_MATRICULAS.CICLO_ACAD_CODIGO = AULA.CODIGO_CICLO_ACAD)
>     INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS ACA_TAB_DETALLE_MATRICULAS ON (
>         ACA_TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA = ACA_TAB_MATRICULAS.ESTUDIANTE_CEDULA
>     )
>         AND (ACA_TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO = ACA_TAB_MATRICULAS.CODIGO)
>         AND (ACA_TAB_DETALLE_MATRICULAS.MATERIA_CODIGO = AULA.CODIGO_MATERIA)
>         AND (ACA_TAB_DETALLE_MATRICULAS.PARALELO_CODIGO = AULA.CODIGO_PARALELO)
>         AND (ACA_TAB_DETALLE_MATRICULAS.ANULACION != 'S')
>         AND ACA_TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO = AULA.CODIGO_CICLO_ACAD
>     LEFT JOIN UTNDB.ACA_TAB_NOTAS ACA_TAB_NOTAS ON (
>         ACA_TAB_NOTAS.ESTUDIANTE_CEDULA = ACA_TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>     )
>         AND (ACA_TAB_NOTAS.MATRICULA_CODIGO = ACA_TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO)
>         AND (ACA_TAB_NOTAS.NIVEL_CODIGO = ACA_TAB_DETALLE_MATRICULAS.NIVEL_CODIGO)
>         AND (ACA_TAB_NOTAS.MATERIA_CODIGO = ACA_TAB_DETALLE_MATRICULAS.MATERIA_CODIGO)
>         AND (ACA_TAB_NOTAS.DEPEN_CODIGO = ACA_TAB_DETALLE_MATRICULAS.DEPEN_CODIGO)
>         AND (ACA_TAB_NOTAS.INST_CODIGO = ACA_TAB_DETALLE_MATRICULAS.INST_CODIGO)
>         AND (ACA_TAB_NOTAS.TFINANCIA_CODIGO = ACA_TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO)
>         AND (ACA_TAB_NOTAS.MODA_ESTUD_CODIGO = ACA_TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO)
>         AND (ACA_TAB_NOTAS.TCICLOACAD_CODIGO = ACA_TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO)
>         AND (ACA_TAB_NOTAS.SIST_ESTUD_CODIGO = ACA_TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO)
>         AND (ACA_TAB_NOTAS.CICLO_ACAD_CODIGO = ACA_TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO)
>         AND (ACA_TAB_NOTAS.PARALELO_CODIGO = ACA_TAB_DETALLE_MATRICULAS.PARALELO_CODIGO)
>         AND (ACA_TAB_NOTAS.DOCENTE_CEDULA = ACA_TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA)
> WHERE
>     ACTIVIDAD.ESTADO = 'A'
>     AND (GREATEST(SYSDATE, ACTIVIDAD.FECHA_INICIO) = SYSDATE OR ACTIVIDAD.TIPO_ACTIVIDAD = 7)
>     AND INTEGRANTE.ESTADO = 'A'
>     AND ACT_ALUMNO.ESTADO = 'A'
>     AND ACA_TAB_MATRICULAS.ESTADO IN ('R', 'M', 'C')
>     AND (
>         ACTIVIDAD.CODIGO_PARCIAL != 'N3'
>         OR (
>             ACA_TAB_NOTAS.RESULTADO1 >= 11
>             AND ACA_TAB_NOTAS.RESULTADO1 < 14
>             AND ACTIVIDAD.CODIGO_PARCIAL = 'N3'
>             AND ACA_TAB_DETALLE_MATRICULAS.NUMERO_MATRICULA != '3'
>         )
>     )
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> SELECT
>     DISTINCT CASE
>         WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 5 THEN 'P'
>         WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 2 THEN 'X'
>         ELSE 'A'
>     END AS TIPO,
>     ACT_ALUMNO.ID_ACTIVIDAD_ALUMNO AS ID_ACTIVIDAD_ALUMNO,
>     ACTIVIDAD.NOMBRE_CORTO AS NOMBRE_CORTO,
>     ACTIVIDAD.FECHA_FIN AS FECHA_FIN,
>     ACTIVIDAD.FECHA_INICIO AS FECHA_INICIO,
>     MATERIA.DESCRIPCION AS MATERIA,
>     ACT_ALUMNO.ENTREGADO AS ENTREGADO,
>     (
>         CASE
>             WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 7 THEN 'NO_REQUIERE_ADJUNTO'
>             WHEN ACT_ALUMNO.ENTREGADO = 'SI' AND ACT_ALUMNO.ID_DOCUMENTO_DIRECTORIO IS NOT NULL THEN 'ENTREGADO_CON_ADJUNTO'
>             WHEN ACT_ALUMNO.ENTREGADO = 'SI' AND ACT_ALUMNO.ID_DOCUMENTO_DIRECTORIO IS NULL THEN 'ENTREGADO_SIN_ADJUNTO'
>             ELSE 'NO_ENTREGADO'
>         END
>     ) AS CON_ADJUNTO,
>     ACTIVIDAD.ID_ACTIVIDAD AS ID_ACTIVIDAD,
>     USUARIO.CUENTA AS CUENTA
> FROM
>     UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA ACTIVIDAD
>     INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES AULA ON (AULA.ID_CURSO = ACTIVIDAD.ID_CURSO)
>     INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS CICLO ON (CICLO.CODIGO = AULA.CODIGO_CICLO_ACAD)
>     INNER JOIN UTNDB.LMS_TAB_INTEGRANTES INTEGRANTE ON (INTEGRANTE.ID_CURSO = AULA.ID_CURSO)
>         AND (INTEGRANTE.ESTADO = 'A')
>     INNER JOIN UTNDB.ACA_TAB_MATERIAS MATERIA ON (
>         MATERIA.CODIGO = AULA.CODIGO_MATERIA
>         AND MATERIA.NIVEL_CODIGO = AULA.CODIGO_NIVEL
>     )
>     INNER JOIN UTNDB.INS_TAB_USUARIOS USUARIO ON (
>         USUARIO.PERSONA_CEDULA = INTEGRANTE.CEDULA_INTEGRANTE
>     )
>     INNER JOIN UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS ACT_ALUMNO ON (
>         ACT_ALUMNO.ID_ACTIVIDAD = ACTIVIDAD.ID_ACTIVIDAD
>         AND ACT_ALUMNO.CEDULA_INTEGRANTE = INTEGRANTE.CEDULA_INTEGRANTE
>     )
>         AND ACT_ALUMNO.ESTADO = 'A'
>     INNER JOIN UTNDB.ACA_TAB_MATRICULAS ACA_TAB_MATRICULAS ON (
>         ACA_TAB_MATRICULAS.ESTUDIANTE_CEDULA = INTEGRANTE.CEDULA_INTEGRANTE
>     )
>         AND (ACA_TAB_MATRICULAS.CICLO_ACAD_CODIGO = AULA.CODIGO_CICLO_ACAD)
>     INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS ACA_TAB_DETALLE_MATRICULAS ON (
>         ACA_TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA = ACA_TAB_MATRICULAS.ESTUDIANTE_CEDULA
>     )
>         AND (ACA_TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO = ACA_TAB_MATRICULAS.CODIGO)
>         AND (ACA_TAB_DETALLE_MATRICULAS.MATERIA_CODIGO = AULA.CODIGO_MATERIA)
>         AND (ACA_TAB_DETALLE_MATRICULAS.PARALELO_CODIGO = AULA.CODIGO_PARALELO)
>         AND (ACA_TAB_DETALLE_MATRICULAS.ANULACION != 'S')
>         AND ACA_TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO = AULA.CODIGO_CICLO_ACAD
>     LEFT JOIN UTNDB.ACA_TAB_NOTAS ACA_TAB_NOTAS ON (
>         ACA_TAB_NOTAS.ESTUDIANTE_CEDULA = ACA_TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>     )
>         AND (ACA_TAB_NOTAS.MATRICULA_CODIGO = ACA_TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO)
>         AND (ACA_TAB_NOTAS.NIVEL_CODIGO = ACA_TAB_DETALLE_MATRICULAS.NIVEL_CODIGO)
>         AND (ACA_TAB_NOTAS.MATERIA_CODIGO = ACA_TAB_DETALLE_MATRICULAS.MATERIA_CODIGO)
>         AND (ACA_TAB_NOTAS.DEPEN_CODIGO = ACA_TAB_DETALLE_MATRICULAS.DEPEN_CODIGO)
>         AND (ACA_TAB_NOTAS.INST_CODIGO = ACA_TAB_DETALLE_MATRICULAS.INST_CODIGO)
>         AND (ACA_TAB_NOTAS.TFINANCIA_CODIGO = ACA_TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO)
>         AND (ACA_TAB_NOTAS.MODA_ESTUD_CODIGO = ACA_TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO)
>         AND (ACA_TAB_NOTAS.TCICLOACAD_CODIGO = ACA_TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO)
>         AND (ACA_TAB_NOTAS.SIST_ESTUD_CODIGO = ACA_TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO)
>         AND (ACA_TAB_NOTAS.CICLO_ACAD_CODIGO = ACA_TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO)
>         AND (ACA_TAB_NOTAS.PARALELO_CODIGO = ACA_TAB_DETALLE_MATRICULAS.PARALELO_CODIGO)
>         AND (ACA_TAB_NOTAS.DOCENTE_CEDULA = ACA_TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA)
> WHERE
>     ACTIVIDAD.ESTADO = 'A'
>     AND (GREATEST(SYSDATE, ACTIVIDAD.FECHA_INICIO) = SYSDATE OR ACTIVIDAD.TIPO_ACTIVIDAD = 7)
>     AND INTEGRANTE.ESTADO = 'A'
>     AND ACT_ALUMNO.ESTADO = 'A'
>     AND ACA_TAB_MATRICULAS.ESTADO IN ('R', 'M', 'C')
>     AND (
>         ACTIVIDAD.CODIGO_PARCIAL != 'N3'
>         OR (
>             ACA_TAB_NOTAS.RESULTADO1 >= 11
>             AND ACA_TAB_NOTAS.RESULTADO1 < 14
>             AND ACTIVIDAD.CODIGO_PARCIAL = 'N3'
>             AND ACA_TAB_DETALLE_MATRICULAS.NUMERO_MATRICULA != '3'
>         )
>     );
> ```

> [!example]- `MVL_VIEW_HORARIO_ESTUDIANTE` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** 10col, 0 filas en los 4 MINUS (2 variantes x 2 sentidos).
>
> **Lo usa:** `src/modules/horario_estudiante/repository/consultas/horario_activo_estudiante_consulta.ts`, `src/modules/horario_estudiante/repository/consultas/horario_estudiante_consulta.ts`
>
> **Antes** (`src/modules/horario_estudiante/repository/consultas/horario_activo_estudiante_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const HORARIO_ACTIVO_ESTUDIANTE_CONSULTA = `
> SELECT 
>   FECHA_INICIO, 
>   FECHA_FIN, 
>   CASE WHEN LENGTH (INICIO_HORA) = 4 THEN '0' || INICIO_HORA ELSE INICIO_HORA END AS INICIO_HORA, 
>   CASE WHEN LENGTH (FIN_HORA) = 4 THEN '0' || FIN_HORA ELSE FIN_HORA END AS FIN_HORA, 
>   "ESTRUCTURA FÍSICA", 
>   NOMBRES, 
>   DIA_SEMANA_CODIGO, 
>   PARALELO, 
>   NIVEL, 
>   MATERIA 
> FROM 
>   (
>     SELECT 
>       DISTINCT NULL FECHA_INICIO, 
>       NULL FECHA_FIN, 
>       SUBSTR (
>         TAB_PLANTILLAS_HORAS.INICIO_HORA, 
>         0, 
>         LENGTH (
>           TAB_PLANTILLAS_HORAS.INICIO_HORA
>         ) -2
>       ) || 'H' || SUBSTR (
>         TAB_PLANTILLAS_HORAS.INICIO_HORA, 
>         LENGTH (
>           TAB_PLANTILLAS_HORAS.INICIO_HORA
>         ) -1, 
>         LENGTH (
>           TAB_PLANTILLAS_HORAS.INICIO_HORA
>         )
>       ) AS INICIO_HORA, 
>       SUBSTR (
>         TAB_PLANTILLAS_HORAS.FIN_HORA, 
>         0, 
>         LENGTH (TAB_PLANTILLAS_HORAS.FIN_HORA) -2
>       ) || 'H' || SUBSTR (
>         TAB_PLANTILLAS_HORAS.FIN_HORA, 
>         LENGTH (TAB_PLANTILLAS_HORAS.FIN_HORA) -1, 
>         LENGTH (TAB_PLANTILLAS_HORAS.FIN_HORA)
>       ) AS FIN_HORA, 
>       INS_PCK_GENERAL.FUN_OBTENER_ESTRUCTURA_FISICA (
>         TAB_DETALLES_HORARIOS.ESTRUC_FIS_CODIGO
>       ) AS "ESTRUCTURA FÍSICA", 
>       INS_PCK_GENERAL.FUN_NOMBRES_PERSONA (
>         TAB_DETALLES_HORARIOS.DOCENTE_CEDULA
>       ) AS NOMBRES, 
>       TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO || ': ' || DECODE (
>         TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO, 
>         '1', 'LUNES', '2', 'MARTES', '3', 'MIÉRCOLES', 
>         '4', 'JUEVES', '5', 'VIERNES', '6', 
>         'SÁBADO', '7', 'DOMINGO'
>       ) AS DIA_SEMANA_CODIGO, 
>       TAB_DETALLE_MATRICULAS.PARALELO_CODIGO AS PARALELO, 
>       TAB_DETALLE_MATRICULAS.NIVEL_CODIGO AS NIVEL, 
>       (
>         SELECT 
>           TAB_MATERIAS.DESCRIPCION 
>         FROM 
>           ACA_TAB_MATERIAS TAB_MATERIAS 
>         WHERE 
>           TAB_MATERIAS.CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO 
>           AND TAB_MATERIAS.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
>       ) AS MATERIA 
>     FROM 
>       (
>         (
>           (
>             ACA_TAB_DETALLES_HORARIOS TAB_DETALLES_HORARIOS 
>             LEFT JOIN ACA_TAB_HORARIOS_DEPENDENCIAS TAB_HORARIOS_DEPENDENCIAS ON (
>               TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.DIA_SEMANA_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.DOCENTE_CEDULA NOT IN ('<cedula>')
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.GRUPO_HORA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.GRUPO_HORA_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.PLAN_HORAS_NUMERO = TAB_HORARIOS_DEPENDENCIAS.PLAN_HORAS_NUMERO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.HOR_DEPEN_CODIGO = TAB_HORARIOS_DEPENDENCIAS.CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.DEPEN_CODIGO = TAB_HORARIOS_DEPENDENCIAS.DEPEN_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.INST_CODIGO = TAB_HORARIOS_DEPENDENCIAS.INST_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.MODA_ESTUD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.MODA_ESTUD_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.SIST_ESTUD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.SIST_ESTUD_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.TCICLOACAD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.TCICLOACAD_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.TFINANCIA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.TFINANCIA_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.CICLO_ACAD_CODIGO
>             )
>           ) 
>           LEFT JOIN ACA_TAB_PLANTILLAS_HORAS TAB_PLANTILLAS_HORAS ON (
>             TAB_HORARIOS_DEPENDENCIAS.PLAN_HORAS_NUMERO = TAB_PLANTILLAS_HORAS.NUMERO
>           ) 
>           AND (
>             TAB_HORARIOS_DEPENDENCIAS.GRUPO_HORA_CODIGO = TAB_PLANTILLAS_HORAS.GRUPO_HORA_CODIGO
>           )
>         ) 
>         LEFT JOIN ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
>           TAB_DETALLE_MATRICULAS.PARALELO_CODIGO = TAB_DETALLES_HORARIOS.PARALELO_CODIGO
>         ) 
>         AND (
>           TAB_DETALLES_HORARIOS.DOCENTE_CEDULA NOT IN ('<cedula>')
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.MATERIA_CODIGO = TAB_DETALLES_HORARIOS.MATERIA_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.INST_CODIGO = TAB_DETALLES_HORARIOS.INST_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO = TAB_DETALLES_HORARIOS.MODA_ESTUD_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO = TAB_DETALLES_HORARIOS.SIST_ESTUD_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO = TAB_DETALLES_HORARIOS.TCICLOACAD_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO = TAB_DETALLES_HORARIOS.TFINANCIA_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.DEPEN_CODIGO = TAB_DETALLES_HORARIOS.DEPEN_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO = TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.NIVEL_CODIGO = TAB_DETALLES_HORARIOS.NIVEL_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA = TAB_DETALLES_HORARIOS.DOCENTE_CEDULA
>         )
>       ) 
>       LEFT JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TAB_CICLOS_ACADEMICOS ON (
>         TAB_CICLOS_ACADEMICOS.CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>       ) 
>       LEFT JOIN ACA_TAB_MATRICULAS TAB_MATRICULAS ON (
>         TAB_MATRICULAS.CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>       ) 
>       AND (
>         TAB_MATRICULAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>       ) 
>     WHERE 
>       (
>         TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA = (
>           SELECT
> ```
>
> **Antes** (`src/modules/horario_estudiante/repository/consultas/horario_estudiante_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const HORARIO_ESTUDIANTE_CONSULTA = `
> SELECT 
>   FECHA_INICIO, 
>   FECHA_FIN, 
>   CASE WHEN LENGTH (INICIO_HORA) = 4 THEN '0' || INICIO_HORA ELSE INICIO_HORA END AS INICIO_HORA, 
>   CASE WHEN LENGTH (FIN_HORA) = 4 THEN '0' || FIN_HORA ELSE FIN_HORA END AS FIN_HORA, 
>   "ESTRUCTURA FÍSICA", 
>   NOMBRES, 
>   DIA_SEMANA_CODIGO, 
>   PARALELO, 
>   NIVEL, 
>   MATERIA 
> FROM 
>   (
>     SELECT 
>       DISTINCT NULL FECHA_INICIO, 
>       NULL FECHA_FIN, 
>       SUBSTR (
>         TAB_PLANTILLAS_HORAS.INICIO_HORA, 
>         0, 
>         LENGTH (
>           TAB_PLANTILLAS_HORAS.INICIO_HORA
>         ) -2
>       ) || 'H' || SUBSTR (
>         TAB_PLANTILLAS_HORAS.INICIO_HORA, 
>         LENGTH (
>           TAB_PLANTILLAS_HORAS.INICIO_HORA
>         ) -1, 
>         LENGTH (
>           TAB_PLANTILLAS_HORAS.INICIO_HORA
>         )
>       ) AS INICIO_HORA, 
>       SUBSTR (
>         TAB_PLANTILLAS_HORAS.FIN_HORA, 
>         0, 
>         LENGTH (TAB_PLANTILLAS_HORAS.FIN_HORA) -2
>       ) || 'H' || SUBSTR (
>         TAB_PLANTILLAS_HORAS.FIN_HORA, 
>         LENGTH (TAB_PLANTILLAS_HORAS.FIN_HORA) -1, 
>         LENGTH (TAB_PLANTILLAS_HORAS.FIN_HORA)
>       ) AS FIN_HORA, 
>       INS_PCK_GENERAL.FUN_OBTENER_ESTRUCTURA_FISICA (
>         TAB_DETALLES_HORARIOS.ESTRUC_FIS_CODIGO
>       ) AS "ESTRUCTURA FÍSICA", 
>       INS_PCK_GENERAL.FUN_NOMBRES_PERSONA (
>         TAB_DETALLES_HORARIOS.DOCENTE_CEDULA
>       ) AS NOMBRES, 
>       TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO || ': ' || DECODE (
>         TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO, 
>         '1', 'LUNES', '2', 'MARTES', '3', 'MIÉRCOLES', 
>         '4', 'JUEVES', '5', 'VIERNES', '6', 
>         'SÁBADO', '7', 'DOMINGO'
>       ) AS DIA_SEMANA_CODIGO, 
>       TAB_DETALLE_MATRICULAS.PARALELO_CODIGO AS PARALELO, 
>       TAB_DETALLE_MATRICULAS.NIVEL_CODIGO AS NIVEL, 
>       (
>         SELECT 
>           TAB_MATERIAS.DESCRIPCION 
>         FROM 
>           ACA_TAB_MATERIAS TAB_MATERIAS 
>         WHERE 
>           TAB_MATERIAS.CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO 
>           AND TAB_MATERIAS.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
>       ) AS MATERIA 
>     FROM 
>       (
>         (
>           (
>             ACA_TAB_DETALLES_HORARIOS TAB_DETALLES_HORARIOS 
>             LEFT JOIN ACA_TAB_HORARIOS_DEPENDENCIAS TAB_HORARIOS_DEPENDENCIAS ON (
>               TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.DIA_SEMANA_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.DOCENTE_CEDULA NOT IN ('<cedula>')
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.GRUPO_HORA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.GRUPO_HORA_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.PLAN_HORAS_NUMERO = TAB_HORARIOS_DEPENDENCIAS.PLAN_HORAS_NUMERO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.HOR_DEPEN_CODIGO = TAB_HORARIOS_DEPENDENCIAS.CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.DEPEN_CODIGO = TAB_HORARIOS_DEPENDENCIAS.DEPEN_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.INST_CODIGO = TAB_HORARIOS_DEPENDENCIAS.INST_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.MODA_ESTUD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.MODA_ESTUD_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.SIST_ESTUD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.SIST_ESTUD_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.TCICLOACAD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.TCICLOACAD_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.TFINANCIA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.TFINANCIA_CODIGO
>             ) 
>             AND (
>               TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.CICLO_ACAD_CODIGO
>             )
>           ) 
>           LEFT JOIN ACA_TAB_PLANTILLAS_HORAS TAB_PLANTILLAS_HORAS ON (
>             TAB_HORARIOS_DEPENDENCIAS.PLAN_HORAS_NUMERO = TAB_PLANTILLAS_HORAS.NUMERO
>           ) 
>           AND (
>             TAB_HORARIOS_DEPENDENCIAS.GRUPO_HORA_CODIGO = TAB_PLANTILLAS_HORAS.GRUPO_HORA_CODIGO
>           )
>         ) 
>         LEFT JOIN ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
>           TAB_DETALLE_MATRICULAS.PARALELO_CODIGO = TAB_DETALLES_HORARIOS.PARALELO_CODIGO
>         ) 
>         AND (
>           TAB_DETALLES_HORARIOS.DOCENTE_CEDULA NOT IN ('<cedula>')
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.MATERIA_CODIGO = TAB_DETALLES_HORARIOS.MATERIA_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.INST_CODIGO = TAB_DETALLES_HORARIOS.INST_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO = TAB_DETALLES_HORARIOS.MODA_ESTUD_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO = TAB_DETALLES_HORARIOS.SIST_ESTUD_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO = TAB_DETALLES_HORARIOS.TCICLOACAD_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO = TAB_DETALLES_HORARIOS.TFINANCIA_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.DEPEN_CODIGO = TAB_DETALLES_HORARIOS.DEPEN_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO = TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.NIVEL_CODIGO = TAB_DETALLES_HORARIOS.NIVEL_CODIGO
>         ) 
>         AND (
>           TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA = TAB_DETALLES_HORARIOS.DOCENTE_CEDULA
>         )
>       ) 
>       LEFT JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TAB_CICLOS_ACADEMICOS ON (
>         TAB_CICLOS_ACADEMICOS.CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>       ) 
>       LEFT JOIN ACA_TAB_MATRICULAS TAB_MATRICULAS ON (
>         TAB_MATRICULAS.CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>       ) 
>       AND (
>         TAB_MATRICULAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>       ) 
>     WHERE 
>       (
>         TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA = (
>           SELECT
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_HORARIO_ESTUDIANTE
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      DBMS_METADATA.GET_DDL('VIEW', 'MVL_VIEW_HORARIO_ESTUDIANTE', 'MOVIL_UTN')
> -- Usado por: src/modules/horario_estudiante
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_HORARIO_ESTUDIANTE ("FECHA_INICIO", "FECHA_FIN", "INICIO_HORA", "FIN_HORA", "ESTRUCTURA FÍSICA", "NOMBRES", "DIA_SEMANA_CODIGO", "PARALELO", "NIVEL", "MATERIA", "CUENTA", "CICLO_ACAD_CODIGO", "CICLO_ESTADO") AS
> SELECT
>     FECHA_INICIO,
>     FECHA_FIN,
>     CASE WHEN LENGTH(INICIO_HORA) = 4 THEN '0' || INICIO_HORA ELSE INICIO_HORA END AS INICIO_HORA,
>     CASE WHEN LENGTH(FIN_HORA) = 4 THEN '0' || FIN_HORA ELSE FIN_HORA END AS FIN_HORA,
>     "ESTRUCTURA FÍSICA",
>     NOMBRES,
>     DIA_SEMANA_CODIGO,
>     PARALELO,
>     NIVEL,
>     MATERIA,
>     CUENTA,
>     CICLO_ACAD_CODIGO,
>     CICLO_ESTADO
> FROM (
>     SELECT
>         DISTINCT NULL AS FECHA_INICIO,
>         NULL AS FECHA_FIN,
>         SUBSTR(TAB_PLANTILLAS_HORAS.INICIO_HORA, 0, LENGTH(TAB_PLANTILLAS_HORAS.INICIO_HORA) - 2) || 'H' || SUBSTR(TAB_PLANTILLAS_HORAS.INICIO_HORA, LENGTH(TAB_PLANTILLAS_HORAS.INICIO_HORA) - 1, LENGTH(TAB_PLANTILLAS_HORAS.INICIO_HORA)) AS INICIO_HORA,
>         SUBSTR(TAB_PLANTILLAS_HORAS.FIN_HORA, 0, LENGTH(TAB_PLANTILLAS_HORAS.FIN_HORA) - 2) || 'H' || SUBSTR(TAB_PLANTILLAS_HORAS.FIN_HORA, LENGTH(TAB_PLANTILLAS_HORAS.FIN_HORA) - 1, LENGTH(TAB_PLANTILLAS_HORAS.FIN_HORA)) AS FIN_HORA,
>         INS_PCK_GENERAL.FUN_OBTENER_ESTRUCTURA_FISICA(TAB_DETALLES_HORARIOS.ESTRUC_FIS_CODIGO) AS "ESTRUCTURA FÍSICA",
>         INS_PCK_GENERAL.FUN_NOMBRES_PERSONA(TAB_DETALLES_HORARIOS.DOCENTE_CEDULA) AS NOMBRES,
>         TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO || ': ' || DECODE(TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO, '1', 'LUNES', '2', 'MARTES', '3', 'MIÉRCOLES', '4', 'JUEVES', '5', 'VIERNES', '6', 'SÁBADO', '7', 'DOMINGO') AS DIA_SEMANA_CODIGO,
>         TAB_DETALLE_MATRICULAS.PARALELO_CODIGO AS PARALELO,
>         TAB_DETALLE_MATRICULAS.NIVEL_CODIGO AS NIVEL,
>         (
>             SELECT TAB_MATERIAS.DESCRIPCION
>             FROM UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS
>             WHERE TAB_MATERIAS.CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
>               AND TAB_MATERIAS.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
>         ) AS MATERIA,
>         USUARIO.CUENTA AS CUENTA,
>         TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO AS CICLO_ACAD_CODIGO,
>         TAB_CICLOS_ACADEMICOS.ESTADO AS CICLO_ESTADO
>     FROM
>         (
>             (
>                 (
>                     UTNDB.ACA_TAB_DETALLES_HORARIOS TAB_DETALLES_HORARIOS
>                     LEFT JOIN UTNDB.ACA_TAB_HORARIOS_DEPENDENCIAS TAB_HORARIOS_DEPENDENCIAS ON (
>                         TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.DIA_SEMANA_CODIGO
>                     )
>                     AND (TAB_DETALLES_HORARIOS.DOCENTE_CEDULA NOT IN ('<cedula>'))
>                     AND (TAB_DETALLES_HORARIOS.GRUPO_HORA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.GRUPO_HORA_CODIGO)
>                     AND (TAB_DETALLES_HORARIOS.PLAN_HORAS_NUMERO = TAB_HORARIOS_DEPENDENCIAS.PLAN_HORAS_NUMERO)
>                     AND (TAB_DETALLES_HORARIOS.HOR_DEPEN_CODIGO = TAB_HORARIOS_DEPENDENCIAS.CODIGO)
>                     AND (TAB_DETALLES_HORARIOS.DEPEN_CODIGO = TAB_HORARIOS_DEPENDENCIAS.DEPEN_CODIGO)
>                     AND (TAB_DETALLES_HORARIOS.INST_CODIGO = TAB_HORARIOS_DEPENDENCIAS.INST_CODIGO)
>                     AND (TAB_DETALLES_HORARIOS.MODA_ESTUD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.MODA_ESTUD_CODIGO)
>                     AND (TAB_DETALLES_HORARIOS.SIST_ESTUD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.SIST_ESTUD_CODIGO)
>                     AND (TAB_DETALLES_HORARIOS.TCICLOACAD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.TCICLOACAD_CODIGO)
>                     AND (TAB_DETALLES_HORARIOS.TFINANCIA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.TFINANCIA_CODIGO)
>                     AND (TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.CICLO_ACAD_CODIGO)
>                 )
>                 LEFT JOIN UTNDB.ACA_TAB_PLANTILLAS_HORAS TAB_PLANTILLAS_HORAS ON (
>                     TAB_HORARIOS_DEPENDENCIAS.PLAN_HORAS_NUMERO = TAB_PLANTILLAS_HORAS.NUMERO
>                 )
>                 AND (TAB_HORARIOS_DEPENDENCIAS.GRUPO_HORA_CODIGO = TAB_PLANTILLAS_HORAS.GRUPO_HORA_CODIGO)
>             )
>             LEFT JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
>                 TAB_DETALLE_MATRICULAS.PARALELO_CODIGO = TAB_DETALLES_HORARIOS.PARALELO_CODIGO
>             )
>             AND (TAB_DETALLES_HORARIOS.DOCENTE_CEDULA NOT IN ('<cedula>'))
>             AND (TAB_DETALLE_MATRICULAS.MATERIA_CODIGO = TAB_DETALLES_HORARIOS.MATERIA_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.INST_CODIGO = TAB_DETALLES_HORARIOS.INST_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO = TAB_DETALLES_HORARIOS.MODA_ESTUD_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO = TAB_DETALLES_HORARIOS.SIST_ESTUD_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO = TAB_DETALLES_HORARIOS.TCICLOACAD_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO = TAB_DETALLES_HORARIOS.TFINANCIA_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.DEPEN_CODIGO = TAB_DETALLES_HORARIOS.DEPEN_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO = TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.NIVEL_CODIGO = TAB_DETALLES_HORARIOS.NIVEL_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA = TAB_DETALLES_HORARIOS.DOCENTE_CEDULA)
>         )
>         LEFT JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TAB_CICLOS_ACADEMICOS ON (
>             TAB_CICLOS_ACADEMICOS.CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>         )
>         LEFT JOIN UTNDB.ACA_TAB_MATRICULAS TAB_MATRICULAS ON (
>             TAB_MATRICULAS.CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>         )
>         AND (TAB_MATRICULAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA)
>         INNER JOIN UTNDB.INS_TAB_USUARIOS USUARIO ON (
>             USUARIO.PERSONA_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>         )
>     WHERE
>         TAB_DETALLE_MATRICULAS.ANULACION NOT IN ('S')
>         AND TAB_MATRICULAS.ESTADO IN ('R', 'C', 'M')
> )
> UNION
> SELECT
>     FECHA_INICIO,
>     FECHA_FIN,
>     CASE WHEN LENGTH(INICIO_HORA) = 4 THEN '0' || INICIO_HORA ELSE INICIO_HORA END AS INICIO_HORA,
>     CASE WHEN LENGTH(FIN_HORA) = 4 THEN '0' || FIN_HORA ELSE FIN_HORA END AS FIN_HORA,
>     "ESTRUCTURA FÍSICA",
>     NOMBRES,
>     DIA_SEMANA_CODIGO,
>     PARALELO,
>     NIVEL,
>     MATERIA,
>     CUENTA,
>     CICLO_ACAD_CODIGO,
>     CICLO_ESTADO
> FROM (
>     SELECT
>         DISTINCT TO_CHAR(TAB_PENSUM_CALENDARIO.FECHA_INICIO, 'DD/MM/YYYY') AS FECHA_INICIO,
>         TO_CHAR(TAB_PENSUM_CALENDARIO.FECHA_FIN, 'DD/MM/YYYY') AS FECHA_FIN,
>         SUBSTR(TAB_PLANTILLAS_HORAS.INICIO_HORA, 0, LENGTH(TAB_PLANTILLAS_HORAS.INICIO_HORA) - 2) || 'H' || SUBSTR(TAB_PLANTILLAS_HORAS.INICIO_HORA, LENGTH(TAB_PLANTILLAS_HORAS.INICIO_HORA) - 1, LENGTH(TAB_PLANTILLAS_HORAS.INICIO_HORA)) AS INICIO_HORA,
>         SUBSTR(TAB_PLANTILLAS_HORAS.FIN_HORA, 0, LENGTH(TAB_PLANTILLAS_HORAS.FIN_HORA) - 2) || 'H' || SUBSTR(TAB_PLANTILLAS_HORAS.FIN_HORA, LENGTH(TAB_PLANTILLAS_HORAS.FIN_HORA) - 1, LENGTH(TAB_PLANTILLAS_HORAS.FIN_HORA)) AS FIN_HORA,
>         INS_PCK_GENERAL.FUN_OBTENER_ESTRUCTURA_FISICA(TAB_DETALLES_HORARIOS.ESTRUC_FIS_CODIGO) AS "ESTRUCTURA FÍSICA",
>         INS_PCK_GENERAL.FUN_NOMBRES_PERSONA(TAB_DETALLES_HORARIOS.DOCENTE_CEDULA) AS NOMBRES,
>         TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO || ': ' || DECODE(TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO, '1', 'LUNES', '2', 'MARTES', '3', 'MIÉRCOLES', '4', 'JUEVES', '5', 'VIERNES', '6', 'SÁBADO', '7', 'DOMINGO') AS DIA_SEMANA_CODIGO,
>         TAB_DETALLE_MATRICULAS.PARALELO_CODIGO AS PARALELO,
>         TAB_DETALLE_MATRICULAS.NIVEL_CODIGO AS NIVEL,
>         (
>             SELECT TAB_MATERIAS.DESCRIPCION
>             FROM UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS
>             WHERE TAB_MATERIAS.CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
>               AND TAB_MATERIAS.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
>         ) AS MATERIA,
>         USUARIO.CUENTA AS CUENTA,
>         TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO AS CICLO_ACAD_CODIGO,
>         TAB_CICLOS_ACADEMICOS.ESTADO AS CICLO_ESTADO
>     FROM
>         (
>             (
>                 (
>                     UTNDB.ACA_TAB_DETAL_HORARIO_MODULOS TAB_DETALLES_HORARIOS
>                     LEFT JOIN UTNDB.ACA_TAB_HORAS_MODULOS TAB_HORARIOS_DEPENDENCIAS ON (
>                         TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.DIA_SEMANA_CODIGO
>                     )
>                     AND (TAB_DETALLES_HORARIOS.DOCENTE_CEDULA NOT IN ('<cedula>'))
>                     AND (TAB_DETALLES_HORARIOS.GRUPO_HORA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.GRUPO_HORA_CODIGO)
>                     AND (TAB_DETALLES_HORARIOS.PLAN_HORAS_NUMERO = TAB_HORARIOS_DEPENDENCIAS.PLAN_HORAS_NUMERO)
>                     AND (TAB_DETALLES_HORARIOS.DEPEN_CODIGO = TAB_HORARIOS_DEPENDENCIAS.DEPEN_CODIGO)
>                     AND (TAB_DETALLES_HORARIOS.INST_CODIGO = TAB_HORARIOS_DEPENDENCIAS.INST_CODIGO)
>                     AND (TAB_DETALLES_HORARIOS.MODA_ESTUD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.MODA_ESTUD_CODIGO)
>                     AND (TAB_DETALLES_HORARIOS.SIST_ESTUD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.SIST_ESTUD_CODIGO)
>                     AND (TAB_DETALLES_HORARIOS.TCICLOACAD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.TCICLOACAD_CODIGO)
>                     AND (TAB_DETALLES_HORARIOS.TFINANCIA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.TFINANCIA_CODIGO)
>                     AND (TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.CICLO_ACAD_CODIGO)
>                 )
>                 LEFT JOIN UTNDB.ACA_TAB_PLANTILLAS_HORAS TAB_PLANTILLAS_HORAS ON (
>                     TAB_HORARIOS_DEPENDENCIAS.PLAN_HORAS_NUMERO = TAB_PLANTILLAS_HORAS.NUMERO
>                 )
>                 AND (TAB_HORARIOS_DEPENDENCIAS.GRUPO_HORA_CODIGO = TAB_PLANTILLAS_HORAS.GRUPO_HORA_CODIGO)
>             )
>             LEFT JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
>                 TAB_DETALLE_MATRICULAS.PARALELO_CODIGO = TAB_DETALLES_HORARIOS.PARALELO_CODIGO
>             )
>             AND (TAB_DETALLES_HORARIOS.DOCENTE_CEDULA NOT IN ('<cedula>'))
>             AND (TAB_DETALLE_MATRICULAS.MATERIA_CODIGO = TAB_DETALLES_HORARIOS.MATERIA_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.INST_CODIGO = TAB_DETALLES_HORARIOS.INST_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO = TAB_DETALLES_HORARIOS.MODA_ESTUD_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO = TAB_DETALLES_HORARIOS.SIST_ESTUD_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO = TAB_DETALLES_HORARIOS.TCICLOACAD_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO = TAB_DETALLES_HORARIOS.TFINANCIA_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.DEPEN_CODIGO = TAB_DETALLES_HORARIOS.DEPEN_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO = TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.NIVEL_CODIGO = TAB_DETALLES_HORARIOS.NIVEL_CODIGO)
>             AND (TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA = TAB_DETALLES_HORARIOS.DOCENTE_CEDULA)
>         )
>         LEFT JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TAB_CICLOS_ACADEMICOS ON (
>             TAB_CICLOS_ACADEMICOS.CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>         )
>         LEFT JOIN UTNDB.ACA_TAB_MATRICULAS TAB_MATRICULAS ON (
>             TAB_MATRICULAS.CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>         )
>         AND (TAB_MATRICULAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA)
>         LEFT JOIN UTNDB.ACA_TAB_CALENDARIOS_MAT_PENSUM TAB_PENSUM_CALENDARIO ON (
>             TAB_PENSUM_CALENDARIO.CICLO_ACAD_CODIGO = TAB_CICLOS_ACADEMICOS.CODIGO
>         )
>         AND (TAB_PENSUM_CALENDARIO.DEPEN_CODIGO = TAB_DETALLES_HORARIOS.DEPEN_CODIGO)
>         AND (TAB_PENSUM_CALENDARIO.MATERIA_CODIGO = TAB_DETALLES_HORARIOS.MATERIA_CODIGO)
>         AND (TAB_PENSUM_CALENDARIO.PARALELO_CODIGO = TAB_DETALLES_HORARIOS.PARALELO_CODIGO)
>         AND (TAB_PENSUM_CALENDARIO.MODA_ESTUD_CODIGO = TAB_DETALLES_HORARIOS.MODA_ESTUD_CODIGO)
>         INNER JOIN UTNDB.INS_TAB_USUARIOS USUARIO ON (
>             USUARIO.PERSONA_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>         )
>     WHERE
>         TAB_DETALLE_MATRICULAS.ANULACION NOT IN ('S')
>         AND TAB_MATRICULAS.ESTADO IN ('R', 'C', 'M')
> )
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> Q26 ✅: MVL_VIEW_HORARIO_ESTUDIANTE, 10col, 0 filas en los 4 MINUS (2 variantes x 2 sentidos).
> 	Validado por primera vez SIN Toad: el usuario corrio el DDL, Claude valido con MINUS directo
> 	resultado por Toad. Vista compartida por HORARIO_ESTUDIANTE_CONSULTA (filtra CICLO_ACAD_CODIGO)
> 	+ HORARIO_ACTIVO_ESTUDIANTE_CONSULTA (filtra CICLO_ESTADO='A', con SELECT DISTINCT porque hay 21
> 	ciclos ESTADO='A' simultaneos en dev). Reescribe el subquery correlacionado
> 	TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA=(SELECT PERSONA_CEDULA FROM INS_TAB_USUARIOS WHERE
> 	De paso corrige el bug preexistente documentado en Backup-Planes §6.4: el repositorio declaraba
> 	getHorarioEstudiante(ciclo, cuenta) pero el service lo llama (cuenta, ciclo) - funcionaba antes
> 	solo por casualidad de orden de binds. Firma corregida a (cuenta, ciclo), comportamiento real
> 	sin cambios (el array que llega a Oracle ya era [cuenta, ciclo]).
> 	Validado con datos reales: cuenta <cuenta-de-prueba>/cedula <cedula>, ciclo 1021-1099, 4 filas reales
> 	del sistema de horario "normal" (ACA_TAB_DETALLES_HORARIOS) y 0 del "modular"
> 	(ACA_TAB_DETAL_HORARIO_MODULOS, tabla sin datos para este ciclo/cuenta - 0=0 tambien valida).
> 	Confirmado end-to-end con curl en los 2 endpoints (por ciclo y activo): mismas 4 filas agrupadas
> 	por el servicio (lunes 07H00-08H00, jueves 07H00-10H00), sin duplicados pese a los 21 ciclos
> 	activos.
>
> -- (DDL completo de MVL_VIEW_HORARIO_ESTUDIANTE en la nota de continuidad, no se repite aqui por tamano);
> ```

> [!example]- `MVL_VIEW_FICHA_SOCIOECONOMICA` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** (ficha_socioeconomica), 1col/5col, 0 filas en los 3 MINUS
>
>
>
> ```ts
> SELECT
> FROM
>    DBU_TAB_FICHA_SOCIOEC FS,
>    ACA_TAB_MATRICULAS M
> WHERE
>    FS.CI_PASAPORTE = M.ESTUDIANTE_CEDULA
>    AND FS.COD_MATRICULA = M.CODIGO
>    AND M.ESTADO IN ('R', 'C', 'M')
>    AND M.ESTUDIANTE_CEDULA =(
>       SELECT
>          PERSONA_CEDULA
>       FROM
>          INS_TAB_USUARIOS
>       WHERE
>          CUENTA = :CUENTA
>    )
>    AND FS.DECLARACION = 'SI'
> `;
> ```
>
> **Antes** (`src/modules/ficha_socioeconomica/repository/consultas/info_ficha_consulta_dto.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const INFO_FICHA_CONSULTA = `
> SELECT
>    CICLO,
>    DEPEN_CODIGO,
>    FECHA_MATRICULA AS lvarc3Ciclo,
>    DEPEN_CODIGO AS lvarc2Dependencia,
>    FECHA_MATRICULA AS lvarc2Fecha
> FROM
>    (
>         SELECT
>             M.CICLO_ACAD_CODIGO CICLO,
>             M.DEPEN_CODIGO,
>             M.FECHA_MATRICULA
>         FROM
>             DBU_TAB_FICHA_SOCIOEC FS,
>             ACA_TAB_MATRICULAS M
>         WHERE
>             FS.CI_PASAPORTE = M.ESTUDIANTE_CEDULA
>             AND FS.COD_MATRICULA = M.CODIGO
>             --AND M.DEPEN_CODIGO=:P32_DEPEN
>             AND M.ESTADO IN ('R', 'C', 'M')
>             AND M.ESTUDIANTE_CEDULA =(
>             SELECT
>                 PERSONA_CEDULA
>             FROM
>                 INS_TAB_USUARIOS
>             WHERE
>                 CUENTA = :CUENTA
>             )
>             AND FS.DECLARACION = 'SI'
>         ORDER BY
>             FS.FECHA_INGRESO DESC
>     )
> WHERE
>    ROWNUM = 1
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_FICHA_SOCIOECONOMICA
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/ficha_socioeconomica
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_FICHA_SOCIOECONOMICA ("CUENTA", "CICLO_ACAD_CODIGO", "DEPEN_CODIGO", "FECHA_MATRICULA", "FECHA_INGRESO") AS
> SELECT
>     USUARIO.CUENTA AS CUENTA,
>     M.CICLO_ACAD_CODIGO AS CICLO_ACAD_CODIGO,
>     M.DEPEN_CODIGO AS DEPEN_CODIGO,
>     M.FECHA_MATRICULA AS FECHA_MATRICULA,
>     FS.FECHA_INGRESO AS FECHA_INGRESO
> FROM
>     UTNDB.DBU_TAB_FICHA_SOCIOEC FS
>     INNER JOIN UTNDB.ACA_TAB_MATRICULAS M ON (
>         FS.CI_PASAPORTE = M.ESTUDIANTE_CEDULA
>         AND FS.COD_MATRICULA = M.CODIGO
>     )
>     INNER JOIN UTNDB.INS_TAB_USUARIOS USUARIO ON (
>         USUARIO.PERSONA_CEDULA = M.ESTUDIANTE_CEDULA
>     )
> WHERE
>     M.ESTADO IN ('R', 'C', 'M')
>     AND FS.DECLARACION = 'SI'
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> Q27 ✅: MVL_VIEW_FICHA_SOCIOECONOMICA (ficha_socioeconomica), 1col/5col, 0 filas en los 3 MINUS
> 	resultado). Vista compartida entre las 2 consultas del modulo. curl /ficha-socioeconomica: 404
> 	"No se encontraron dependencias" identico a antes de migrar.;
> ```

> [!example]- `MVL_VIEW_CICLOS_AULA_VIRTUAL` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** (registro_academico), 0 filas MINUS. curl /registro_academico/ciclos
>
> **Lo usa:** `src/modules/registro_academico/repository/consultas/ciclos_aula_virtual_consulta.ts`
>
> **Antes** (`src/modules/registro_academico/repository/consultas/ciclos_aula_virtual_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const CICLOS_AULA_VIRTUAL_CONSULTA = `
> SELECT
>     DESCRIPCION,
>     CICLO_ACAD_CODIGO
> FROM
> (
>     SELECT
>         CICLO.DESCRIPCION,
>         MATRICULAS.CICLO_ACAD_CODIGO,
>         CICLO.FECHA_FIN
>     FROM
>         UTNDB.ACA_TAB_MATRICULAS MATRICULAS,
>         ACA_TAB_CICLOS_ACADEMICOS CICLO
>     WHERE
>         MATRICULAS.CICLO_ACAD_CODIGO = ciclo.CODIGO
>         AND MATRICULAS.ESTUDIANTE_CEDULA = :G_CEDULA_USUARIO
>         AND MATRICULAS.NIVEL_CODIGO NOT IN ('99', '00', 'AD')
>         AND CICLO.CODIGO NOT IN('0326-0326E', '0526-0526E')
>         /*AND ciclo.ESTADO = 'A'*/
>         -- AND MATRICULAS.FECHA_MATRICULA >(SYSDATE-600)
>     UNION
>     SELECT
>         CICLO.DESCRIPCION,
>         MATRICULAS.CICLO_ACAD_CODIGO,
>         CICLO.FECHA_FIN
>     FROM
>         UTNDB.ACA_TAB_MATRICULAS MATRICULAS,
>         ACA_TAB_CICLOS_ACADEMICOS CICLO,
>         ACA_TAB_DEPENDENCIAS D1,
>         ACA_TAB_DEPENDENCIAS D2,
>         ACA_TAB_DEPENDENCIAS D3
>     WHERE
>         MATRICULAS.CICLO_ACAD_CODIGO = ciclo.CODIGO
>         AND MATRICULAS.ESTUDIANTE_CEDULA = :G_CEDULA_USUARIO
>         AND MATRICULAS.DEPEN_CODIGO = D1.CODIGO
>         AND D1.DEPEN_CODIGO = D2.CODIGO
>         AND D2.DEPEN_CODIGO = D3.CODIGO
>         AND D3.SIGLAS = 'PO'
>         AND CICLO.ESTADO = 'A'
>         AND MATRICULAS.NIVEL_CODIGO IN ('99')
>         -- AND MATRICULAS.FECHA_MATRICULA >(SYSDATE-600)
>     ORDER BY
>         FECHA_FIN DESC
> )
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_CICLOS_AULA_VIRTUAL
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/registro_academico
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_CICLOS_AULA_VIRTUAL ("DESCRIPCION", "CICLO_ACAD_CODIGO", "ESTUDIANTE_CEDULA") AS
> SELECT
>     DESCRIPCION,
>     CICLO_ACAD_CODIGO,
>     ESTUDIANTE_CEDULA
> FROM (
>     SELECT
>         CICLO.DESCRIPCION,
>         MATRICULAS.CICLO_ACAD_CODIGO,
>         MATRICULAS.ESTUDIANTE_CEDULA,
>         CICLO.FECHA_FIN
>     FROM
>         UTNDB.ACA_TAB_MATRICULAS MATRICULAS,
>         UTNDB.ACA_TAB_CICLOS_ACADEMICOS CICLO
>     WHERE
>         MATRICULAS.CICLO_ACAD_CODIGO = CICLO.CODIGO
>         AND MATRICULAS.NIVEL_CODIGO NOT IN ('99', '00', 'AD')
>         AND CICLO.CODIGO NOT IN ('0326-0326E', '0526-0526E')
>     UNION
>     SELECT
>         CICLO.DESCRIPCION,
>         MATRICULAS.CICLO_ACAD_CODIGO,
>         MATRICULAS.ESTUDIANTE_CEDULA,
>         CICLO.FECHA_FIN
>     FROM
>         UTNDB.ACA_TAB_MATRICULAS MATRICULAS,
>         UTNDB.ACA_TAB_CICLOS_ACADEMICOS CICLO,
>         UTNDB.ACA_TAB_DEPENDENCIAS D1,
>         UTNDB.ACA_TAB_DEPENDENCIAS D2,
>         UTNDB.ACA_TAB_DEPENDENCIAS D3
>     WHERE
>         MATRICULAS.CICLO_ACAD_CODIGO = CICLO.CODIGO
>         AND MATRICULAS.DEPEN_CODIGO = D1.CODIGO
>         AND D1.DEPEN_CODIGO = D2.CODIGO
>         AND D2.DEPEN_CODIGO = D3.CODIGO
>         AND D3.SIGLAS = 'PO'
>         AND CICLO.ESTADO = 'A'
>         AND MATRICULAS.NIVEL_CODIGO IN ('99')
>     ORDER BY
>         FECHA_FIN DESC
> )
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> Q28 ✅: MVL_VIEW_CICLOS_AULA_VIRTUAL (registro_academico), 0 filas MINUS. curl /registro_academico/ciclos:
> 	[{"descripcion":"OCT2021-OCT2099","cicloAcadCodigo":"1021-1099"}] - coincide con el ciclo conocido.;
> ```

> [!example]- `MVL_VIEW_AULAS_VIRTUALES` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** (registro_academico), 26col, 0 filas en los 2 MINUS. Costo varias
>
> **Lo usa:** `src/modules/registro_academico/repository/consultas/aulas_virtuales_consulta.ts`
>
> **Antes** (`src/modules/registro_academico/repository/consultas/aulas_virtuales_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const AULAS_VIRTUALES_CONSULTA = `
> SELECT
>     TAB_MAT_PENSUM.FECHA_INICIO || ' - ' || TAB_MAT_PENSUM.FECHA_FIN AS FECHAS,
>     TAB_MATERIAS.CODIGO AS CODIGO_MATERIA,
>     TAB_MATERIAS.DESCRIPCION || (
>         SELECT
>             DESCRIPCION
>         FROM
>             UTNDB.PEI_TAB_POA_PROYECTOS
>         WHERE
>             CODIGO = TAB_DETALLE_MATRICULAS.PARALELO_CODIGO
>     ) AS MATERIA,
>     NOMBRES (TAB_DOCENTES.EMPLEADO_CEDULA) AS DOCENTE,
>     TAB_PERSONAS.EMAIL_INSTITUCIONAL AS DOCENTE_EMAIL,
>     --TAB_MATERIAS.CREDITOS
>     (
>         SELECT
>             MP.CREDITOS
>         FROM
>             ACA_TAB_MATERIAS_PENSUMS MP
>         WHERE
>             MP.DEPEN_CODIGO = TAB_DETALLE_MATRICULAS.DEPEN_CODIGO
>             AND MP.MATERIA_CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
>             AND MP.CICLO_ACAD_CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>             AND MP.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
>             AND MP.PENSUM_CODIGO = TAB_DETALLE_MATRICULAS.PENSUM_CODIGO
>             AND MP.MODA_ESTUD_CODIGO = TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO
>     ) AS "CRÉDITOS",
>     TAB_DETALLE_MATRICULAS.NUMERO_MATRICULA,
>     TAB_NIVELES.CODIGO AS NIVEL,
>     (
>         CASE
>             WHEN TAB_PERSONAS.FOTO IS NOT NULL
>             AND DBMS_LOB.GETLENGTH(TAB_PERSONAS.FOTO) > 0 THEN 1
>             ELSE 0
>         END
>     ) AS "DOCENTE_TIENE_FOTO",
>     TAB_MATERIAS.DEPEN_CODIGO,
>     TAB_MATERIAS.NIVEL_CODIGO,
>     TAB_MATERIAS.INST_CODIGO,
>     TAB_MATERIAS.CODIGO AS MATERIA_CODIGO,
>     TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO,
>     TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO,
>     TAB_DETALLE_MATRICULAS.PARALELO_CODIGO,
>     TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA,
>     TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO,
>     TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO,
>     TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO,
>     (
>         CASE
>             WHEN LMS_TAB_AULAS_VIRTUALES.ID_CURSO IS NULL
>             OR LMS_TAB_AULAS_VIRTUALES.ID_CURSO = '' THEN 'AULA_NO_CREADA'
>             WHEN (
>                 SELECT
>                     COUNT(I.CEDULA_INTEGRANTE)
>                 FROM
>                     lms_tab_integrantes i
>                 WHERE
>                     I.ID_CURSO = LMS_TAB_AULAS_VIRTUALES.ID_CURSO
>                     AND I.CEDULA_INTEGRANTE = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>                     AND TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA != '<cedula>'
>             ) = 0 THEN 'UNIRSE_AULA'
>             ELSE 'INGRESAR_AULA'
>         END
>     ) AS AULA_VIRTUAL,
>     LMS_TAB_AULAS_VIRTUALES.ID_CURSO,
>     FUN_OBTENER (
>         'ACA_TAB_DEPENDENCIAS',
>         'NOMBRE',
>         TAB_DETALLE_MATRICULAS.INST_CODIGO,
>         TAB_DETALLE_MATRICULAS.DEPEN_CODIGO,
>         NULL
>     ) AS "NOMBRE_DEPENDENCIA",
>     TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO,
>     UTNDB.FUN_PORCENTAJE_INASISTENCIA(
>         TAB_MATERIAS.DEPEN_CODIGO,
>         TAB_MATERIAS.CODIGO,
>         TAB_MATERIAS.NIVEL_CODIGO,
>         TAB_DETALLE_MATRICULAS.PARALELO_CODIGO,
>         TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO,
>         TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO,
>         TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO,
>         TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO,
>         TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO,
>         TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA,
>         TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO,
>         TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA,
>         TAB_DETALLE_MATRICULAS.INST_CODIGO
>     ) as "INASISTENCIA",
>     ROUND(
>         UTNDB.LMS_FUN_PORCENTAJE_EJECUTADO (
>             TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA,
>             TAB_MATERIAS.DEPEN_CODIGO,
>             TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO,
>             TAB_MATERIAS.NIVEL_CODIGO,
>             TAB_MATERIAS.CODIGO,
>             TAB_DETALLE_MATRICULAS.INST_CODIGO,
>             TAB_DETALLE_MATRICULAS.PARALELO_CODIGO,
>             TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO,
>             TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO,
>             TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO,
>             TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO
>         ), 
>         2
>     ) AS "PORCENTAJE_EJECUTADO"
> FROM
>     (
>         (
>             (
>                 (
>                     (
>                         (
>                             UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS
>                             INNER JOIN UTNDB.ACA_TAB_NIVELES TAB_NIVELES ON (
>                                 TAB_MATERIAS.NIVEL_CODIGO = TAB_NIVELES.CODIGO
>                             )
>                         )
>                         INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
>                             TAB_MATERIAS.CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
>                         )
>                         AND (
>                             TAB_MATERIAS.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
>                         )
>                     )
>                     LEFT JOIN UTNDB.ACA_TAB_DOCENTES TAB_DOCENTES ON (
>                         TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA = TAB_DOCENTES.EMPLEADO_CEDULA
>                     )
>                 )
>                 LEFT JOIN UTNDB.RHU_TAB_EMPLEADOS TAB_EMPLEADOS ON (
>                     TAB_DOCENTES.EMPLEADO_CEDULA = TAB_EMPLEADOS.PERSONA_CEDULA
>                 )
>             )
>             INNER JOIN UTNDB.RHU_TAB_PERSONAS TAB_PERSONAS ON (
>                 TAB_EMPLEADOS.PERSONA_CEDULA = TAB_PERSONAS.CEDULA
>             )
>         )
>         INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TAB_CICLOS_ACADEMICOS ON (
>             TAB_CICLOS_ACADEMICOS.CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>         )
>     )
>     INNER JOIN ACA_TAB_MATRICULAS TAB_MATRICULAS ON (
>         TAB_MATRICULAS.CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>     )
>     AND (
>         TAB_MATRICULAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>     )
>     INNER JOIN UTNDB.ACA_TAB_ESTUDIANTES TAB_ESTUDIANTES ON (
>         TAB_ESTUDIANTES.PERSONA_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>     )
>     LEFT JOIN ACA_TAB_CALENDARIOS_MAT_PENSUM TAB_MAT_PENSUM ON TAB_MAT_PENSUM.CICL
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_AULAS_VIRTUALES
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      DBMS_METADATA.GET_DDL('VIEW', 'MVL_VIEW_AULAS_VIRTUALES', 'MOVIL_UTN')
> -- Usado por: src/modules/registro_academico
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_AULAS_VIRTUALES ("FECHAS", "CODIGO_MATERIA", "MATERIA", "DOCENTE", "DOCENTE_EMAIL", "CRÉDITOS", "NUMERO_MATRICULA", "NIVEL", "DOCENTE_TIENE_FOTO", "DEPEN_CODIGO", "NIVEL_CODIGO", "INST_CODIGO", "MATERIA_CODIGO", "CICLO_ACAD_CODIGO", "MODA_ESTUD_CODIGO", "PARALELO_CODIGO", "DOCENTE_CEDULA", "SIST_ESTUD_CODIGO", "TCICLOACAD_CODIGO", "TFINANCIA_CODIGO", "AULA_VIRTUAL", "ID_CURSO", "NOMBRE_DEPENDENCIA", "MATRICULA_CODIGO", "INASISTENCIA", "PORCENTAJE_EJECUTADO", "CUENTA", "FILTRO_CICLO_ACAD_CODIGO") AS
> SELECT
>     TAB_MAT_PENSUM.FECHA_INICIO || ' - ' || TAB_MAT_PENSUM.FECHA_FIN AS FECHAS,
>     TAB_MATERIAS.CODIGO AS CODIGO_MATERIA,
>     TAB_MATERIAS.DESCRIPCION || (
>         SELECT DESCRIPCION FROM UTNDB.PEI_TAB_POA_PROYECTOS WHERE CODIGO = TAB_DETALLE_MATRICULAS.PARALELO_CODIGO
>     ) AS MATERIA,
>     NOMBRES(TAB_DOCENTES.EMPLEADO_CEDULA) AS DOCENTE,
>     TAB_PERSONAS.EMAIL_INSTITUCIONAL AS DOCENTE_EMAIL,
>     (
>         SELECT MP.CREDITOS
>         FROM UTNDB.ACA_TAB_MATERIAS_PENSUMS MP
>         WHERE MP.DEPEN_CODIGO = TAB_DETALLE_MATRICULAS.DEPEN_CODIGO
>           AND MP.MATERIA_CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
>           AND MP.CICLO_ACAD_CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>           AND MP.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
>           AND MP.PENSUM_CODIGO = TAB_DETALLE_MATRICULAS.PENSUM_CODIGO
>           AND MP.MODA_ESTUD_CODIGO = TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO
>     ) AS "CRÉDITOS",
>     TAB_DETALLE_MATRICULAS.NUMERO_MATRICULA,
>     TAB_NIVELES.CODIGO AS NIVEL,
>     (
>         CASE WHEN TAB_PERSONAS.FOTO IS NOT NULL AND DBMS_LOB.GETLENGTH(TAB_PERSONAS.FOTO) > 0 THEN 1 ELSE 0 END
>     ) AS "DOCENTE_TIENE_FOTO",
>     TAB_MATERIAS.DEPEN_CODIGO,
>     TAB_MATERIAS.NIVEL_CODIGO,
>     TAB_MATERIAS.INST_CODIGO,
>     TAB_MATERIAS.CODIGO AS MATERIA_CODIGO,
>     TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO,
>     TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO,
>     TAB_DETALLE_MATRICULAS.PARALELO_CODIGO,
>     TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA,
>     TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO,
>     TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO,
>     TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO,
>     (
>         CASE
>             WHEN LMS_TAB_AULAS_VIRTUALES.ID_CURSO IS NULL OR LMS_TAB_AULAS_VIRTUALES.ID_CURSO = '' THEN 'AULA_NO_CREADA'
>             WHEN (
>                 SELECT COUNT(I.CEDULA_INTEGRANTE)
>                 FROM UTNDB.LMS_TAB_INTEGRANTES I
>                 WHERE I.ID_CURSO = LMS_TAB_AULAS_VIRTUALES.ID_CURSO
>                   AND I.CEDULA_INTEGRANTE = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>                   AND TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA != '<cedula>'
>             ) = 0 THEN 'UNIRSE_AULA'
>             ELSE 'INGRESAR_AULA'
>         END
>     ) AS AULA_VIRTUAL,
>     LMS_TAB_AULAS_VIRTUALES.ID_CURSO,
>     FUN_OBTENER('ACA_TAB_DEPENDENCIAS', 'NOMBRE', TAB_DETALLE_MATRICULAS.INST_CODIGO, TAB_DETALLE_MATRICULAS.DEPEN_CODIGO, NULL) AS "NOMBRE_DEPENDENCIA",
>     TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO,
>     UTNDB.FUN_PORCENTAJE_INASISTENCIA(
>         TAB_MATERIAS.DEPEN_CODIGO, TAB_MATERIAS.CODIGO, TAB_MATERIAS.NIVEL_CODIGO, TAB_DETALLE_MATRICULAS.PARALELO_CODIGO,
>         TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO, TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO, TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO,
>         TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO, TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO, TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA,
>         TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO, TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA, TAB_DETALLE_MATRICULAS.INST_CODIGO
>     ) AS "INASISTENCIA",
>     ROUND(
>         UTNDB.LMS_FUN_PORCENTAJE_EJECUTADO(
>             TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA, TAB_MATERIAS.DEPEN_CODIGO, TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO,
>             TAB_MATERIAS.NIVEL_CODIGO, TAB_MATERIAS.CODIGO, TAB_DETALLE_MATRICULAS.INST_CODIGO, TAB_DETALLE_MATRICULAS.PARALELO_CODIGO,
>             TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO, TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO, TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO,
>             TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO
>         ), 2
>     ) AS "PORCENTAJE_EJECUTADO",
>     USUARIO.CUENTA AS CUENTA,
>     TAB_MATRICULAS.CICLO_ACAD_CODIGO AS FILTRO_CICLO_ACAD_CODIGO
> FROM
>     (
>         (
>             (
>                 (
>                     (
>                         (
>                             UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS
>                             INNER JOIN UTNDB.ACA_TAB_NIVELES TAB_NIVELES ON (TAB_MATERIAS.NIVEL_CODIGO = TAB_NIVELES.CODIGO)
>                         )
>                         INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
>                             TAB_MATERIAS.CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
>                         )
>                         AND (TAB_MATERIAS.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO)
>                     )
>                     LEFT JOIN UTNDB.ACA_TAB_DOCENTES TAB_DOCENTES ON (
>                         TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA = TAB_DOCENTES.EMPLEADO_CEDULA
>                     )
>                 )
>                 LEFT JOIN UTNDB.RHU_TAB_EMPLEADOS TAB_EMPLEADOS ON (TAB_DOCENTES.EMPLEADO_CEDULA = TAB_EMPLEADOS.PERSONA_CEDULA)
>             )
>             INNER JOIN UTNDB.RHU_TAB_PERSONAS TAB_PERSONAS ON (TAB_EMPLEADOS.PERSONA_CEDULA = TAB_PERSONAS.CEDULA)
>         )
>         INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TAB_CICLOS_ACADEMICOS ON (
>             TAB_CICLOS_ACADEMICOS.CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>         )
>     )
>     INNER JOIN UTNDB.ACA_TAB_MATRICULAS TAB_MATRICULAS ON (
>         TAB_MATRICULAS.CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>     )
>     AND (TAB_MATRICULAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA)
>     INNER JOIN UTNDB.ACA_TAB_ESTUDIANTES TAB_ESTUDIANTES ON (
>         TAB_ESTUDIANTES.PERSONA_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>     )
>     LEFT JOIN UTNDB.ACA_TAB_CALENDARIOS_MAT_PENSUM TAB_MAT_PENSUM ON TAB_MAT_PENSUM.CICLO_ACAD_CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>     AND TAB_MAT_PENSUM.MODA_ESTUD_CODIGO = TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO
>     AND TAB_MAT_PENSUM.DEPEN_CODIGO = TAB_DETALLE_MATRICULAS.DEPEN_CODIGO
>     AND TAB_MAT_PENSUM.MATERIA_CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
>     AND TAB_MAT_PENSUM.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
>     AND TAB_MAT_PENSUM.PARALELO_CODIGO = TAB_DETALLE_MATRICULAS.PARALELO_CODIGO
>     LEFT JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES LMS_TAB_AULAS_VIRTUALES ON (
>         TAB_DETALLE_MATRICULAS.INST_CODIGO = LMS_TAB_AULAS_VIRTUALES.CODIGO_INSTITUCION
>     )
>     AND (TAB_DETALLE_MATRICULAS.DEPEN_CODIGO = LMS_TAB_AULAS_VIRTUALES.CODIGO_DEPENDENCIA)
>     AND (TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO = LMS_TAB_AULAS_VIRTUALES.CODIGO_CICLO_ACAD)
>     AND (TAB_DETALLE_MATRICULAS.NIVEL_CODIGO = LMS_TAB_AULAS_VIRTUALES.CODIGO_NIVEL)
>     AND (TAB_DETALLE_MATRICULAS.MATERIA_CODIGO = LMS_TAB_AULAS_VIRTUALES.CODIGO_MATERIA)
>     AND (TAB_DETALLE_MATRICULAS.PARALELO_CODIGO = LMS_TAB_AULAS_VIRTUALES.CODIGO_PARALELO)
>     AND (TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO = LMS_TAB_AULAS_VIRTUALES.CODIGO_MOD_EST)
>     AND (TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO = LMS_TAB_AULAS_VIRTUALES.CODIGO_SIS_EST)
>     AND (TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO = LMS_TAB_AULAS_VIRTUALES.CODIGO_TIPO_FINANC)
>     AND (TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA = LMS_TAB_AULAS_VIRTUALES.CEDULA_DOCENTE)
>     INNER JOIN UTNDB.INS_TAB_USUARIOS USUARIO ON (
>         USUARIO.PERSONA_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>     )
> WHERE
>     TAB_DETALLE_MATRICULAS.ANULACION NOT IN ('S')
>     AND TAB_MATRICULAS.DEPEN_CODIGO NOT IN ('00263')
>     AND TAB_MATRICULAS.ESTADO IN ('R', 'C', 'M')
>     AND TAB_MATRICULAS.NIVEL_CODIGO NOT IN ('AD')
>     AND TAB_MATRICULAS.CICLO_ACAD_CODIGO NOT IN ('0326-0326E', '0526-0526E')
>     AND TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA NOT IN ('<cedula>')
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> Q29 ✅: MVL_VIEW_AULAS_VIRTUALES (registro_academico), 26col, 0 filas en los 2 MINUS. Costo varias
> 	rondas por corrupcion de copia/pegado en Toad (Code Insight interceptando el pegado en textos
> 	largos, se resolvio abriendo el .sql como archivo con File->Open en vez de pegar). curl
> 	/registro_academico/aulas-virtuales?ciclo=1021-1099: 2 filas identicas a las validadas
> 	(CAPRU-MATPRU 75% avance, CAPRU-MATPRU2 0%).;
> ```

> [!example]- `MVL_FUN_ARBOL_MATERIAS` (función)
> **Resultado:** comparación fila a fila: igual al original
>
> **Nota del registro:** (notas_estudiante), F por CONNECT BY (filtro dentro del subquery
>
> **Lo usa:** `src/modules/notas_estudiante/repository/consultas/arbol_de_materias_consulta.ts`
>
> **Antes** (`src/modules/notas_estudiante/repository/consultas/arbol_de_materias_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const ARBOL_DE_MATERIAS_CONSULTA = `
> SELECT 
>     CASE
>         WHEN CONNECT_BY_ISLEAF = 1 THEN 0
>         WHEN LEVEL = 1 THEN 1
>         ELSE -1
>         END AS status,
>     LEVEL,
>     CASE
>         WHEN "CODIGO_NODO" = '00199' THEN 'CAI' 
>         WHEN "CODIGO_NODO" = '00205' THEN 'Inglés'
>         WHEN "CODIGO_NODO" = '00238' THEN "NOMBRE"  
>         WHEN CONNECT_BY_ISLEAF = 1 THEN "NOMBRE" ELSE "SIGLAS" END
>         AS title,
>     "CODIGO_NODO" AS VALUE
>
> FROM (
>     SELECT *
>     FROM ACA_VIEW_MATERIAS_ESTUDIANTES VIEW_EST_MAT WHERE PERSONA_CEDULA=:G_CEDULA_USUARIO)
>     START WITH "DEPEN_CODIGO" IS NULL OR "DEPEN_CODIGO" = '00000'
>     CONNECT BY PRIOR "CODIGO" = "DEPEN_CODIGO"
>     
> ORDER SIBLINGS BY "NOMBRE"
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_FUN_ARBOL_MATERIAS
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_FUN_ARBOL_MATERIAS')
> -- Usado por: src/modules/notas_estudiante
>
> CREATE OR REPLACE FUNCTION MOVIL_UTN.MVL_FUN_ARBOL_MATERIAS (
>     p_cedula IN UTNDB.RHU_TAB_PERSONAS.CEDULA%TYPE
> ) RETURN SYS_REFCURSOR
> AS
>     v_cursor SYS_REFCURSOR;
> BEGIN
>     OPEN v_cursor FOR
>         SELECT
>             CASE
>                 WHEN CONNECT_BY_ISLEAF = 1 THEN 0
>                 WHEN LEVEL = 1 THEN 1
>                 ELSE -1
>                 END AS STATUS,
>             LEVEL,
>             CASE
>                 WHEN "CODIGO_NODO" = '00199' THEN 'CAI'
>                 WHEN "CODIGO_NODO" = '00205' THEN 'Inglés'
>                 WHEN "CODIGO_NODO" = '00238' THEN "NOMBRE"
>                 WHEN CONNECT_BY_ISLEAF = 1 THEN "NOMBRE" ELSE "SIGLAS" END
>                 AS TITLE,
>             "CODIGO_NODO" AS VALUE
>         FROM (
>             SELECT *
>             FROM UTNDB.ACA_VIEW_MATERIAS_ESTUDIANTES VIEW_EST_MAT WHERE PERSONA_CEDULA = p_cedula)
>             START WITH "DEPEN_CODIGO" IS NULL OR "DEPEN_CODIGO" = '00000'
>             CONNECT BY PRIOR "CODIGO" = "DEPEN_CODIGO"
>         ORDER SIBLINGS BY "NOMBRE";
>     RETURN v_cursor;
> END MVL_FUN_ARBOL_MATERIAS;
> /
> ```

> [!example]- `MVL_FUN_CARRERA_ESTUDIANTE` (función)
> **Resultado:** comparación fila a fila: igual al original
>
> **Nota del registro:** (notas_estudiante), F por 2 CONNECT BY anidados + UNION
>
> **Lo usa:** `src/modules/notas_estudiante/repository/consultas/carrera_estudiante_consulta.ts`
>
> **Antes** (`src/modules/notas_estudiante/repository/consultas/carrera_estudiante_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const CARRERA_ESTUDIANTE_CONSULTA = `
> SELECT 
>   CASE WHEN CONNECT_BY_ISLEAF = 1 THEN 0 WHEN LEVEL = 1 THEN 1 ELSE -1 END AS status, 
>   LEVEL, 
>   "NOMBRE" AS title, 
>   "CODIGO" AS VALUE, 
>   "NOMBRE" AS tooltip 
> FROM 
>   aca_tab_dependencias 
> WHERE 
>   inst_codigo = '001' 
>   AND codigo IN (
>     SELECT 
>       codigo 
>     FROM 
>       aca_tab_dependencias CONNECT BY codigo = PRIOR depen_codigo START WITH codigo IN (
>         SELECT 
>           DISTINCT TAB_DETALLE_MATRICULAS.DEPEN_CODIGO 
>         FROM 
>           UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS 
>         WHERE 
>           (
>             TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA IN (
>               SELECT 
>                 PERSONA_CEDULA 
>               FROM 
>                 INS_TAB_USUARIOS 
>               WHERE 
>                 PERSONA_CEDULA = (
>                   SELECT 
>                     PERSONA_CEDULA 
>                   FROM 
>                     INS_TAB_USUARIOS 
>                   WHERE 
>                     CUENTA = :CUENTA
>                 )
>             )
>           ) 
>         UNION 
>         SELECT 
>           codigo 
>         FROM 
>           aca_tab_dependencias CONNECT BY codigo = PRIOR depen_codigo START WITH codigo IN (
>             SELECT 
>               DISTINCT DR.DEPEN_CODIGO 
>             FROM 
>               UTNDB.ACA_TAB_DET_MATRICULAS_REVAL DR 
>             WHERE 
>               (
>                 DR.ESTUDIANTE_CEDULA IN (
>                   SELECT 
>                     PERSONA_CEDULA 
>                   FROM 
>                     INS_TAB_USUARIOS 
>                   WHERE 
>                     PERSONA_CEDULA = (
>                       SELECT 
>                         PERSONA_CEDULA 
>                       FROM 
>                         INS_TAB_USUARIOS 
>                       WHERE 
>                         CUENTA = :CUENTA
>                     )
>                 )
>               )
>           )
>       )
>   ) CONNECT BY PRIOR (inst_codigo || codigo) = (
>     depen_inst_codigo || depen_codigo
>   ) START WITH depen_codigo IS NULL
>
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_FUN_CARRERA_ESTUDIANTE
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_FUN_CARRERA_ESTUDIANTE')
> -- Usado por: src/modules/notas_estudiante
>
> CREATE OR REPLACE FUNCTION MOVIL_UTN.MVL_FUN_CARRERA_ESTUDIANTE (
>     p_cuenta IN UTNDB.INS_TAB_USUARIOS.CUENTA%TYPE
> ) RETURN SYS_REFCURSOR
> AS
>     v_cursor SYS_REFCURSOR;
> BEGIN
>     OPEN v_cursor FOR
>         SELECT
>           CASE WHEN CONNECT_BY_ISLEAF = 1 THEN 0 WHEN LEVEL = 1 THEN 1 ELSE -1 END AS STATUS,
>           LEVEL,
>           "NOMBRE" AS TITLE,
>           "CODIGO" AS VALUE,
>           "NOMBRE" AS TOOLTIP
>         FROM
>           UTNDB.ACA_TAB_DEPENDENCIAS
>         WHERE
>           INST_CODIGO = '001'
>           AND CODIGO IN (
>             SELECT
>               CODIGO
>             FROM
>               UTNDB.ACA_TAB_DEPENDENCIAS CONNECT BY CODIGO = PRIOR DEPEN_CODIGO START WITH CODIGO IN (
>                 SELECT
>                   DISTINCT TAB_DETALLE_MATRICULAS.DEPEN_CODIGO
>                 FROM
>                   UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS
>                 WHERE
>                   (
>                     TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA IN (
>                       SELECT
>                         PERSONA_CEDULA
>                       FROM
>                         UTNDB.INS_TAB_USUARIOS
>                       WHERE
>                         PERSONA_CEDULA = (
>                           SELECT
>                             PERSONA_CEDULA
>                           FROM
>                             UTNDB.INS_TAB_USUARIOS
>                           WHERE
>                             CUENTA = p_cuenta
>                         )
>                     )
>                   )
>                 UNION
>                 SELECT
>                   CODIGO
>                 FROM
>                   UTNDB.ACA_TAB_DEPENDENCIAS CONNECT BY CODIGO = PRIOR DEPEN_CODIGO START WITH CODIGO IN (
>                     SELECT
>                       DISTINCT DR.DEPEN_CODIGO
>                     FROM
>                       UTNDB.ACA_TAB_DET_MATRICULAS_REVAL DR
>                     WHERE
>                       (
>                         DR.ESTUDIANTE_CEDULA IN (
>                           SELECT
>                             PERSONA_CEDULA
>                           FROM
>                             UTNDB.INS_TAB_USUARIOS
>                           WHERE
>                             PERSONA_CEDULA = (
>                               SELECT
>                                 PERSONA_CEDULA
>                               FROM
>                                 UTNDB.INS_TAB_USUARIOS
>                               WHERE
>                                 CUENTA = p_cuenta
>                             )
>                         )
>                       )
>                   )
>               )
>           ) CONNECT BY PRIOR (INST_CODIGO || CODIGO) = (
>             DEPEN_INST_CODIGO || DEPEN_CODIGO
>           ) START WITH DEPEN_CODIGO IS NULL;
>     RETURN v_cursor;
> END MVL_FUN_CARRERA_ESTUDIANTE;
> /
> ```

> [!example]- `MVL_VIEW_NOTAS_CICLO_ACTUAL` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** (notas_estudiante), V2 - reescribe el subquery escalar
>
> **Lo usa:** `src/modules/notas_estudiante/repository/consultas/notas_ciclo_actual_consulta.ts`
>
> **Antes** (`src/modules/notas_estudiante/repository/consultas/notas_ciclo_actual_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const GET_NOTAS_CICLO_ACTUAL_CONSULTA = `
>     SELECT
>         TAB_MATERIAS.codigo,
>         VIEW_DEPENDENCIAS.FACULTAD AS FACULTAD,
>         UPPER (VIEW_DEPENDENCIAS.CARRERA) AS CARRERA,
>         TAB_MATERIAS.DESCRIPCION AS MATERIA,
>         TAB_NOTAS.NIVEL_CODIGO AS NIVEL,
>         TAB_NOTAS.PARALELO_CODIGO AS PARALELO,
>         TAB_NOTAS.APROBO,
>         TAB_NOTAS.NOTA1 AS N1,
>         TAB_NOTAS.NOTA2 AS N2,
>         TAB_NOTAS.NOTA3 AS N3,
>         TAB_NOTAS.NOTA4 AS N4,
>         TAB_NOTAS.NOTA5 AS N5,
>         TAB_NOTAS.RESULTADO1 AS S1,
>         TAB_NOTAS.RESULTADO2 AS S2,
>         TAB_NOTAS.RESULTADO3 AS S3,
>         TAB_NOTAS.FINAL1 AS F1,
>         TAB_NOTAS.FINAL2 AS F2,
>         TAB_NOTAS.FINAL3 AS F3,
>         TAB_NOTAS.NOTA_FINAL AS NF,
>         TAB_DETALLE_MATRICULAS.NUMERO_MATRICULA,
>         INS_PCK_GENERAL.FUN_NOMBRES_PERSONA (TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA) AS DOCENTE,
>         FUN_PORCENTAJE_INASISTENCIA(
>             TAB_NOTAS.DEPEN_CODIGO,
>             TAB_NOTAS.MATERIA_CODIGO,
>             TAB_NOTAS.NIVEL_CODIGO,
>             TAB_NOTAS.PARALELO_CODIGO,
>             TAB_NOTAS.CICLO_ACAD_CODIGO,
>             TAB_NOTAS.MODA_ESTUD_CODIGO,
>             TAB_NOTAS.SIST_ESTUD_CODIGO,
>             TAB_NOTAS.TCICLOACAD_CODIGO,
>             TAB_NOTAS.TFINANCIA_CODIGO,
>             TAB_NOTAS.ESTUDIANTE_CEDULA,
>             TAB_NOTAS.MATRICULA_CODIGO,
>             TAB_NOTAS.DOCENTE_CEDULA,
>             TAB_NOTAS.INST_CODIGO
>         ) as Inasistencia
>     FROM
>         (
>             (
>                 (
>                     UTNDB.ACA_TAB_NOTAS TAB_NOTAS
>                     INNER JOIN UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS ON (TAB_NOTAS.MATERIA_CODIGO = TAB_MATERIAS.CODIGO)
>                     AND (
>                         TAB_NOTAS.NIVEL_CODIGO = TAB_MATERIAS.NIVEL_CODIGO
>                     )
>                 )
>                 INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
>                     TAB_NOTAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>                 )
>                 AND (
>                     TAB_NOTAS.MATRICULA_CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>                 )
>                 AND (
>                     TAB_NOTAS.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
>                 )
>                 AND (
>                     TAB_NOTAS.MATERIA_CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
>                 )
>                 AND (
>                     TAB_NOTAS.DEPEN_CODIGO = TAB_DETALLE_MATRICULAS.DEPEN_CODIGO
>                 )
>                 AND (
>                     TAB_NOTAS.INST_CODIGO = TAB_DETALLE_MATRICULAS.INST_CODIGO
>                 )
>                 AND (
>                     TAB_NOTAS.TFINANCIA_CODIGO = TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO
>                 )
>                 AND (
>                     TAB_NOTAS.MODA_ESTUD_CODIGO = TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO
>                 )
>                 AND (
>                     TAB_NOTAS.TCICLOACAD_CODIGO = TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO
>                 )
>                 AND (
>                     TAB_NOTAS.SIST_ESTUD_CODIGO = TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO
>                 )
>                 AND (
>                     TAB_NOTAS.CICLO_ACAD_CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>                 )
>                 AND (
>                     TAB_NOTAS.PARALELO_CODIGO = TAB_DETALLE_MATRICULAS.PARALELO_CODIGO
>                 )
>                 AND (
>                     TAB_NOTAS.DOCENTE_CEDULA = TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA
>                 )
>             )
>             INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TAB_CICLOS_ACADEMICOS ON (
>                 TAB_CICLOS_ACADEMICOS.CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>             )
>             INNER JOIN ACA_TAB_MATRICULAS TAB_MATRICULAS ON (
>                 (
>                     TAB_MATRICULAS.CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>                 )
>                 AND TAB_MATRICULAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>             )
>         )
>         INNER JOIN UTNDB.REC_VIEW_DEPENDENCIAS VIEW_DEPENDENCIAS ON (
>             VIEW_DEPENDENCIAS.CODIGO_CA = TAB_MATRICULAS.DEPEN_CODIGO
>         )
>     WHERE
>         (
>             TAB_CICLOS_ACADEMICOS.ESTADO = 'A'
>             /*TAB_CICLOS_ACADEMICOS.CODIGO = '0315-0815'*/
>         )
>         AND (
>             TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA = (
>                 SELECT
>                     PERSONA_CEDULA
>                 FROM
>                     INS_TAB_USUARIOS
>                 WHERE
>                     CUENTA = :CUENTA
>             )
>         )
>         AND (TAB_DETALLE_MATRICULAS.ANULACION NOT IN ('S'))
>         AND TAB_MATRICULAS.ESTADO IN ('R', 'C', 'M')
>         AND TAB_MATRICULAS.NIVEL_CODIGO NOT IN ('AD')
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_NOTAS_CICLO_ACTUAL
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/notas_estudiante
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_NOTAS_CICLO_ACTUAL ("CODIGO", "FACULTAD", "CARRERA", "MATERIA", "NIVEL", "PARALELO", "APROBO", "N1", "N2", "N3", "N4", "N5", "S1", "S2", "S3", "F1", "F2", "F3", "NF", "NUMERO_MATRICULA", "DOCENTE", "INASISTENCIA", "CUENTA") AS
> SELECT
>     TAB_MATERIAS.CODIGO AS CODIGO,
>     VIEW_DEPENDENCIAS.FACULTAD AS FACULTAD,
>     UPPER(VIEW_DEPENDENCIAS.CARRERA) AS CARRERA,
>     TAB_MATERIAS.DESCRIPCION AS MATERIA,
>     TAB_NOTAS.NIVEL_CODIGO AS NIVEL,
>     TAB_NOTAS.PARALELO_CODIGO AS PARALELO,
>     TAB_NOTAS.APROBO AS APROBO,
>     TAB_NOTAS.NOTA1 AS N1,
>     TAB_NOTAS.NOTA2 AS N2,
>     TAB_NOTAS.NOTA3 AS N3,
>     TAB_NOTAS.NOTA4 AS N4,
>     TAB_NOTAS.NOTA5 AS N5,
>     TAB_NOTAS.RESULTADO1 AS S1,
>     TAB_NOTAS.RESULTADO2 AS S2,
>     TAB_NOTAS.RESULTADO3 AS S3,
>     TAB_NOTAS.FINAL1 AS F1,
>     TAB_NOTAS.FINAL2 AS F2,
>     TAB_NOTAS.FINAL3 AS F3,
>     TAB_NOTAS.NOTA_FINAL AS NF,
>     TAB_DETALLE_MATRICULAS.NUMERO_MATRICULA AS NUMERO_MATRICULA,
>     INS_PCK_GENERAL.FUN_NOMBRES_PERSONA(TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA) AS DOCENTE,
>     FUN_PORCENTAJE_INASISTENCIA(
>         TAB_NOTAS.DEPEN_CODIGO,
>         TAB_NOTAS.MATERIA_CODIGO,
>         TAB_NOTAS.NIVEL_CODIGO,
>         TAB_NOTAS.PARALELO_CODIGO,
>         TAB_NOTAS.CICLO_ACAD_CODIGO,
>         TAB_NOTAS.MODA_ESTUD_CODIGO,
>         TAB_NOTAS.SIST_ESTUD_CODIGO,
>         TAB_NOTAS.TCICLOACAD_CODIGO,
>         TAB_NOTAS.TFINANCIA_CODIGO,
>         TAB_NOTAS.ESTUDIANTE_CEDULA,
>         TAB_NOTAS.MATRICULA_CODIGO,
>         TAB_NOTAS.DOCENTE_CEDULA,
>         TAB_NOTAS.INST_CODIGO
>     ) AS INASISTENCIA,
>     USUARIO.CUENTA AS CUENTA
> FROM
>     (
>         (
>             (
>                 UTNDB.ACA_TAB_NOTAS TAB_NOTAS
>                 INNER JOIN UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS ON (TAB_NOTAS.MATERIA_CODIGO = TAB_MATERIAS.CODIGO)
>                 AND (TAB_NOTAS.NIVEL_CODIGO = TAB_MATERIAS.NIVEL_CODIGO)
>             )
>             INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
>                 TAB_NOTAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>             )
>             AND (TAB_NOTAS.MATRICULA_CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO)
>             AND (TAB_NOTAS.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO)
>             AND (TAB_NOTAS.MATERIA_CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO)
>             AND (TAB_NOTAS.DEPEN_CODIGO = TAB_DETALLE_MATRICULAS.DEPEN_CODIGO)
>             AND (TAB_NOTAS.INST_CODIGO = TAB_DETALLE_MATRICULAS.INST_CODIGO)
>             AND (TAB_NOTAS.TFINANCIA_CODIGO = TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO)
>             AND (TAB_NOTAS.MODA_ESTUD_CODIGO = TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO)
>             AND (TAB_NOTAS.TCICLOACAD_CODIGO = TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO)
>             AND (TAB_NOTAS.SIST_ESTUD_CODIGO = TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO)
>             AND (TAB_NOTAS.CICLO_ACAD_CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO)
>             AND (TAB_NOTAS.PARALELO_CODIGO = TAB_DETALLE_MATRICULAS.PARALELO_CODIGO)
>             AND (TAB_NOTAS.DOCENTE_CEDULA = TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA)
>         )
>         INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TAB_CICLOS_ACADEMICOS ON (
>             TAB_CICLOS_ACADEMICOS.CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>         )
>         INNER JOIN UTNDB.ACA_TAB_MATRICULAS TAB_MATRICULAS ON (
>             (TAB_MATRICULAS.CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO)
>             AND TAB_MATRICULAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>         )
>     )
>     INNER JOIN UTNDB.REC_VIEW_DEPENDENCIAS VIEW_DEPENDENCIAS ON (
>         VIEW_DEPENDENCIAS.CODIGO_CA = TAB_MATRICULAS.DEPEN_CODIGO
>     )
>     INNER JOIN UTNDB.INS_TAB_USUARIOS USUARIO ON (
>         USUARIO.PERSONA_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>     )
> WHERE
>     TAB_CICLOS_ACADEMICOS.ESTADO = 'A'
>     AND TAB_DETALLE_MATRICULAS.ANULACION NOT IN ('S')
>     AND TAB_MATRICULAS.ESTADO IN ('R', 'C', 'M')
>     AND TAB_MATRICULAS.NIVEL_CODIGO NOT IN ('AD')
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> Q32 ✅: MVL_VIEW_NOTAS_CICLO_ACTUAL (notas_estudiante), V2 - reescribe el subquery escalar
> 	ESTUDIANTE_CEDULA=(SELECT PERSONA_CEDULA FROM INS_TAB_USUARIOS WHERE CUENTA=:CUENTA) como
> 	INNER JOIN INS_TAB_USUARIOS, expone CUENTA para filtrar afuera (mismo patron que
> 	horario_estudiante/aulas_virtuales). ESTADO='A' del ciclo se queda fijo dentro de la vista.
> 	22 col, 0 filas en los 2 MINUS (cuenta <cuenta-de-prueba>). Codigo migrado
> 	(notas_ciclo_actual_consulta.ts, sin cambios en el repository - no es funcion), build limpio,
> 	Validado por MCP.;
> ```

> [!example]- `MVL_VIEW_NOTAS_POR_NIVEL` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** (notas_estudiante), V2 compleja - 4 ramas UNION (matriculas
>
> **Lo usa:** `src/modules/notas_estudiante/repository/consultas/notas_por_nivel_consulta.ts`
>
> **Antes** (`src/modules/notas_estudiante/repository/consultas/notas_por_nivel_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const NOTAS_POR_NIVEL_CONSULTA = `
> SELECT
>     MATERIA AS MATERIA,
>     NIVEL AS NIVEL,
>     PARALELO AS PARALELO,
>     MATRICULA AS "N_MATRICULA",
>     DOCENTE AS DOCENTE,
>     NOTA_1 AS "NOTA_1",
>     NOTA_2 AS "NOTA_2",
>     NOTA_3 AS "NOTA_3",
>     NOTA_4 AS "NOTA_4",
>     SUMA_1 AS "SUMA_1",
>     PROM,
>     SUMA_2 AS "SUMA_2",
>     "FINAL",
>     APROBO,
>     CICLO AS "CICLO",
>     FECHA_INICIO,
>     UPPER (CARRERA_DESCRIPCION) AS CARRERA_DESCRIPCION,
>     FACULTAD_DESCRIPCION AS FACULTAD_DESCRIPCION
> FROM
>     (
>         SELECT
>             DISTINCT TAB_MATERIAS.DESCRIPCION AS MATERIA,
>             TAB_MATERIAS.NIVEL_CODIGO AS NIVEL,
>             TAB_DETALLE_MATRICULAS.PARALELO_CODIGO AS PARALELO,
>             TAB_DETALLE_MATRICULAS.NUMERO_MATRICULA AS "MATRICULA",
>             INS_PCK_GENERAL.FUN_NOMBRES_PERSONA (
>                 TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA
>             ) AS DOCENTE,
>             TAB_NOTAS.NOTA1 AS "NOTA_1",
>             TAB_NOTAS.NOTA2 AS "NOTA_2",
>             TAB_NOTAS.NOTA3 AS "NOTA_3",
>             TAB_NOTAS.NOTA4 AS "NOTA_4",
>             TAB_NOTAS.RESULTADO1 AS "SUMA_1",
>             TAB_NOTAS.FINAL1 AS PROM,
>             TAB_NOTAS.RESULTADO2 AS "SUMA_2",
>             TAB_NOTAS.NOTA_FINAL AS "FINAL",
>             TAB_NOTAS.APROBO AS APROBO,
>             TAB_CICLOS_ACADEMICOS.DESCRIPCION AS "CICLO",
>             TAB_CICLOS_ACADEMICOS.FECHA_INICIO,
>             VIEW_DEPENDENCIAS.CODIGO_CA || '-' || TAB_MATERIAS.NIVEL_CODIGO AS CODIGO_NODO,
>             VIEW_DEPENDENCIAS.CODIGO_CA AS CARRERA,
>             VIEW_DEPENDENCIAS.CODIGO_FAC AS FACULTAD,
>             TAB_MATERIAS.CODIGO AS CODIGO_MATERIA,
>             VIEW_DEPENDENCIAS.CARRERA AS CARRERA_DESCRIPCION,
>             VIEW_DEPENDENCIAS.FACULTAD AS FACULTAD_DESCRIPCION
>         FROM
>             (
>                 (
>                     (
>                         UTNDB.ACA_TAB_NOTAS TAB_NOTAS
>                         INNER JOIN UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS ON (
>                             TAB_NOTAS.MATERIA_CODIGO = TAB_MATERIAS.CODIGO
>                         )
>                         AND (
>                             TAB_NOTAS.NIVEL_CODIGO = TAB_MATERIAS.NIVEL_CODIGO
>                         )
>                     )
>                     INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
>                         TAB_NOTAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>                     )
>                     AND (
>                         TAB_NOTAS.MATRICULA_CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.MATERIA_CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.DEPEN_CODIGO = TAB_DETALLE_MATRICULAS.DEPEN_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.INST_CODIGO = TAB_DETALLE_MATRICULAS.INST_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.TFINANCIA_CODIGO = TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.MODA_ESTUD_CODIGO = TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.TCICLOACAD_CODIGO = TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.SIST_ESTUD_CODIGO = TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.CICLO_ACAD_CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.PARALELO_CODIGO = TAB_DETALLE_MATRICULAS.PARALELO_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.DOCENTE_CEDULA = TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA
>                     )
>                 )
>                 INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TAB_CICLOS_ACADEMICOS ON (
>                     TAB_CICLOS_ACADEMICOS.CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>                 )
>                 INNER JOIN ACA_TAB_MATRICULAS TAB_MATRICULAS ON (
>                     (
>                         TAB_MATRICULAS.CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>                     )
>                     AND TAB_MATRICULAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>                 )
>             )
>             INNER JOIN UTNDB.REC_VIEW_DEPENDENCIAS VIEW_DEPENDENCIAS ON (
>                 VIEW_DEPENDENCIAS.CODIGO_CA = TAB_MATRICULAS.DEPEN_CODIGO
>             )
>         WHERE
>             (
>                 TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA = :G_CEDULA_USUARIO
>             )
>             AND (TAB_DETALLE_MATRICULAS.ANULACION NOT IN ('S'))
>             AND TAB_MATRICULAS.ESTADO IN ('R', 'C', 'M')
>             AND TAB_MATRICULAS.ESTADO NOT IN ('AD')
>     )
> UNION
> SELECT
>     MATERIA AS MATERIA,
>     NIVEL AS NIVEL,
>     'EQ' AS PARALELO,
>     1 AS "N_MATRICULA",
>     'EQUIPARACIÓN' AS DOCENTE,
>     NOTA AS "NOTA_1",
>     NOTA AS "NOTA_2",
>     NULL AS "NOTA_3",
>     NULL AS "NOTA_4",
>     NOTA + NOTA AS "SUMA_1",
>     NOTA,
>     NULL AS "SUMA_2",
>     NOTA,
>     'S' AS APROBO,
>     CICLO AS "CICLO",
>     FECHA_INICIO,
>     CARRERA_DESCRIPCION AS CARRERA_DESCRIPCION,
>     FACULTAD_DESCRIPCION AS FACULTAD_DESCRIPCION
> FROM
>     (
>         SELECT
>             DISTINCT TAB_MATERIAS.DESCRIPCION AS MATERIA,
>             TAB_NIVELES.CODIGO || ': ' || TAB_NIVELES.DESCRIPCION AS NIVEL,
>             TAB_CICLOS_ACADEMICOS.DESCRIPCION AS "CICLO",
>             TAB_CICLOS_ACADEMICOS.FECHA_INICIO,
>             VIEW_DEPENDENCIAS.CODIGO_CA || '-' || TAB_NIVELES.CODIGO AS CODIGO_NODO,
>             VIEW_DEPENDENCIAS.CODIGO_CA AS CARRERA,
>             VIEW_DEPENDENCIAS.CODIGO_FAC AS FACULTAD,
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_NOTAS_POR_NIVEL
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      DBMS_METADATA.GET_DDL('VIEW', 'MVL_VIEW_NOTAS_POR_NIVEL', 'MOVIL_UTN')
> -- Usado por: src/modules/notas_estudiante
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_NOTAS_POR_NIVEL ("MATERIA", "NIVEL", "PARALELO", "N_MATRICULA", "DOCENTE", "NOTA_1", "NOTA_2", "NOTA_3", "NOTA_4", "SUMA_1", "PROM", "SUMA_2", "FINAL", "APROBO", "CICLO", "FECHA_INICIO", "CARRERA_DESCRIPCION", "FACULTAD_DESCRIPCION", "CEDULA") AS
> SELECT
>     MATERIA AS MATERIA,
>     NIVEL AS NIVEL,
>     PARALELO AS PARALELO,
>     MATRICULA AS "N_MATRICULA",
>     DOCENTE AS DOCENTE,
>     NOTA_1 AS "NOTA_1",
>     NOTA_2 AS "NOTA_2",
>     NOTA_3 AS "NOTA_3",
>     NOTA_4 AS "NOTA_4",
>     SUMA_1 AS "SUMA_1",
>     PROM,
>     SUMA_2 AS "SUMA_2",
>     "FINAL",
>     APROBO,
>     CICLO AS "CICLO",
>     FECHA_INICIO,
>     UPPER (CARRERA_DESCRIPCION) AS CARRERA_DESCRIPCION,
>     FACULTAD_DESCRIPCION AS FACULTAD_DESCRIPCION,
>     CEDULA
> FROM
>     (
>         SELECT
>             DISTINCT TAB_MATERIAS.DESCRIPCION AS MATERIA,
>             TAB_MATERIAS.NIVEL_CODIGO AS NIVEL,
>             TAB_DETALLE_MATRICULAS.PARALELO_CODIGO AS PARALELO,
>             TAB_DETALLE_MATRICULAS.NUMERO_MATRICULA AS "MATRICULA",
>             INS_PCK_GENERAL.FUN_NOMBRES_PERSONA (
>                 TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA
>             ) AS DOCENTE,
>             TAB_NOTAS.NOTA1 AS "NOTA_1",
>             TAB_NOTAS.NOTA2 AS "NOTA_2",
>             TAB_NOTAS.NOTA3 AS "NOTA_3",
>             TAB_NOTAS.NOTA4 AS "NOTA_4",
>             TAB_NOTAS.RESULTADO1 AS "SUMA_1",
>             TAB_NOTAS.FINAL1 AS PROM,
>             TAB_NOTAS.RESULTADO2 AS "SUMA_2",
>             TAB_NOTAS.NOTA_FINAL AS "FINAL",
>             TAB_NOTAS.APROBO AS APROBO,
>             TAB_CICLOS_ACADEMICOS.DESCRIPCION AS "CICLO",
>             TAB_CICLOS_ACADEMICOS.FECHA_INICIO,
>             VIEW_DEPENDENCIAS.CODIGO_CA || '-' || TAB_MATERIAS.NIVEL_CODIGO AS CODIGO_NODO,
>             VIEW_DEPENDENCIAS.CODIGO_CA AS CARRERA,
>             VIEW_DEPENDENCIAS.CODIGO_FAC AS FACULTAD,
>             TAB_MATERIAS.CODIGO AS CODIGO_MATERIA,
>             VIEW_DEPENDENCIAS.CARRERA AS CARRERA_DESCRIPCION,
>             VIEW_DEPENDENCIAS.FACULTAD AS FACULTAD_DESCRIPCION,
>             TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA AS CEDULA
>         FROM
>             (
>                 (
>                     (
>                         UTNDB.ACA_TAB_NOTAS TAB_NOTAS
>                         INNER JOIN UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS ON (
>                             TAB_NOTAS.MATERIA_CODIGO = TAB_MATERIAS.CODIGO
>                         )
>                         AND (
>                             TAB_NOTAS.NIVEL_CODIGO = TAB_MATERIAS.NIVEL_CODIGO
>                         )
>                     )
>                     INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
>                         TAB_NOTAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>                     )
>                     AND (
>                         TAB_NOTAS.MATRICULA_CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.MATERIA_CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.DEPEN_CODIGO = TAB_DETALLE_MATRICULAS.DEPEN_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.INST_CODIGO = TAB_DETALLE_MATRICULAS.INST_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.TFINANCIA_CODIGO = TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.MODA_ESTUD_CODIGO = TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.TCICLOACAD_CODIGO = TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.SIST_ESTUD_CODIGO = TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.CICLO_ACAD_CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.PARALELO_CODIGO = TAB_DETALLE_MATRICULAS.PARALELO_CODIGO
>                     )
>                     AND (
>                         TAB_NOTAS.DOCENTE_CEDULA = TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA
>                     )
>                 )
>                 INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TAB_CICLOS_ACADEMICOS ON (
>                     TAB_CICLOS_ACADEMICOS.CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>                 )
>                 INNER JOIN ACA_TAB_MATRICULAS TAB_MATRICULAS ON (
>                     (
>                         TAB_MATRICULAS.CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>                     )
>                     AND TAB_MATRICULAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>                 )
>             )
>             INNER JOIN UTNDB.REC_VIEW_DEPENDENCIAS VIEW_DEPENDENCIAS ON (
>                 VIEW_DEPENDENCIAS.CODIGO_CA = TAB_MATRICULAS.DEPEN_CODIGO
>             )
>         WHERE
>             (TAB_DETALLE_MATRICULAS.ANULACION NOT IN ('S'))
>             AND TAB_MATRICULAS.ESTADO IN ('R', 'C', 'M')
>             AND TAB_MATRICULAS.ESTADO NOT IN ('AD')
>     )
> UNION
> SELECT
>     MATERIA AS MATERIA,
>     NIVEL AS NIVEL,
>     'EQ' AS PARALELO,
>     1 AS "N_MATRICULA",
>     'EQUIPARACIÓN' AS DOCENTE,
>     NOTA AS "NOTA_1",
>     NOTA AS "NOTA_2",
>     NULL AS "NOTA_3",
>     NULL AS "NOTA_4",
>     NOTA + NOTA AS "SUMA_1",
>     NOTA,
>     NULL AS "SUMA_2",
>     NOTA,
>     'S' AS APROBO,
>     CICLO AS "CICLO",
>     FECHA_INICIO,
>     CARRERA_DESCRIPCION AS CARRERA_DESCRIPCION,
>     FACULTAD_DESCRIPCION AS FACULTAD_DESCRIPCION,
>     CEDULA
> FROM
>     (
>         SELECT
>             DISTINCT TAB_MATERIAS.DESCRIPCION AS MATERIA,
>             TAB_NIVELES.CODIGO || ': ' || TAB_NIVELES.DESCRIPCION AS NIVEL,
>             TAB_CICLOS_ACADEMICOS.DESCRIPCION AS "CICLO",
>             TAB_CICLOS_ACADEMICOS.FECHA_INICIO,
>             VIEW_DEPENDENCIAS.CODIGO_CA || '-' || TAB_NIVELES.CODIGO AS CODIGO_NODO,
>             VIEW_DEPENDENCIAS.CODIGO_CA AS CARRERA,
>             VIEW_DEPENDENCIAS.CODIGO_FAC AS FACULTAD,
>             TAB_MATERIAS.CODIGO AS CODIGO_MATERIA,
>             TAB_DET_MATRICULAS_REVAL.NOTA,
>             VIEW_DEPENDENCIAS.CARRERA AS CARRERA_DESCRIPCION,
>             VIEW_DEPENDENCIAS.FACULTAD AS FACULTAD_DESCRIPCION,
>             TAB_DET_MATRICULAS_REVAL.ESTUDIANTE_CEDULA AS CEDULA
>         FROM
>             (
>                 (
>                     (
>                         UTNDB.ACA_TAB_DET_MATRICULAS_REVAL TAB_DET_MATRICULAS_REVAL
>                         INNER JOIN UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS ON (
>                             TAB_DET_MATRICULAS_REVAL.NIVEL_CODIGO = TAB_MATERIAS.NIVEL_CODIGO
>                         )
>                         AND (
>                             TAB_DET_MATRICULAS_REVAL.MATERIA_CODIGO = TAB_MATERIAS.CODIGO
>                         )
>                     )
>                     INNER JOIN UTNDB.ACA_TAB_NIVELES TAB_NIVELES ON (TAB_MATERIAS.NIVEL_CODIGO = TAB_NIVELES.CODIGO)
>                 )
>                 INNER JOIN UTNDB.REC_VIEW_DEPENDENCIAS VIEW_DEPENDENCIAS ON (
>                     VIEW_DEPENDENCIAS.CODIGO_CA = TAB_DET_MATRICULAS_REVAL.DEPEN_CODIGO
>                 )
>             )
>             INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TAB_CICLOS_ACADEMICOS ON (
>                 TAB_CICLOS_ACADEMICOS.CODIGO = TAB_DET_MATRICULAS_REVAL.CICLO_ACAD_CODIGO
>             )
>     )
> UNION
> SELECT
>     DISTINCT 'EXTENSIÓN UNIVERSITARIA:' || TAB_EXTENSION.DESCRIPCION AS MATERIA,
>     'EXTENSIÓN UNIVERSITARIA' AS NIVEL,
>     NULL AS PARALELO,
>     NULL AS "N_MATRICULA",
>     --TAB_EXTENSION.COORDINADOR_LOCAL AS DOCENTE,
>     case
>         when TAB_EXTENSION.COD_PROYECTO is NULL then TAB_EXTENSION.COORDINADOR_LOCAL
>         else UTNDB.tmp_APELLIDOS_NOMBRES2(TAB_EXTENSION.USUARIO)
>     end as DOCENTE,
>     TAB_NOTAS.PARTICIPACION AS "NOTA_1",
>     TAB_NOTAS.ENTREGA_DOC AS "NOTA_2",
>     TAB_NOTAS.SEGUIMIENTO AS "NOTA_3",
>     NULL AS "NOTA_4",
>     NULL AS "SUMA_1",
>     TAB_NOTAS.PROMEDIO_EXT AS PROM,
>     NULL AS "SUMA_2",
>     TAB_NOTAS.PROMEDIO_EXT AS "FINAL",
>     TAB_NOTAS.APRUEBA_EXT AS APROBO,
>     TAB_EXTENSION.PERIODO AS "CICLO",
>     TAB_EXTENSION.FECHA_INICIO AS FECHA_INICIO,
>     'EXTENCIÓN UNIVERSITARIA' AS CARRERA_DESCRIPCION,
>     'VINCULACIÓN' AS FACULTAD_DESCRIPCION,
>     TAB_NOTAS.COD_EXTENSION AS CEDULA
> FROM
>     (
>         UTNDB.VIN_TAB_EXTENSION TAB_EXTENSION
>         INNER JOIN UTNDB.VIN_TAB_INSTITUCION TAB_INSTITUCION ON (
>             TAB_EXTENSION.COD_INSTITUCION = TAB_INSTITUCION.CODIGO
>         )
>     )
>     INNER JOIN UTNDB.VIN_TAB_NOTAS TAB_NOTAS ON (
>         TAB_NOTAS.COD_EXTENSION = TAB_EXTENSION.COD_PERSONA
>     )
>     AND (TAB_NOTAS.PERIODO = TAB_EXTENSION.PERIODO)
> UNION
> SELECT
>     'PRÁCTICA PRE PROFESIONAL:' || MATERIA AS MATERIA,
>     NIVEL AS NIVEL,
>     NULL AS PARALELO,
>     NULL AS "N_MATRICULA",
>     DOCENTE AS DOCENTE,
>     NULL AS "NOTA_1",
>     NULL AS "NOTA_2",
>     NULL AS "NOTA_3",
>     NULL AS "NOTA_4",
>     NULL AS "SUMA_1",
>     NULL as "PROM",
>     NULL AS "SUMA_2",
>     NOTA,
>     NULL AS APROBO,
>     CICLO AS "CICLO",
>     FECHA_INICIO,
>     CARRERA_DESCRIPCION AS CARRERA_DESCRIPCION,
>     FACULTAD_DESCRIPCION AS FACULTAD_DESCRIPCION,
>     CEDULA
> FROM
>     (
>         SELECT
>             DISTINCT DECODE (
>                 TAB_MATERIAS.DESCRIPCION,
>                 null,
>                 ' ',
>                 'PRACTICA PRE-PROFESIONAL',
>                 ' ',
>                 ' (' || TAB_MATERIAS.DESCRIPCION || ')'
>             ) || ' ' || TAB_ACT_EST.HORAS || ' HORAS EN LA INSTITUCION: ' || TAB_ACT_EST.INSTITUCION || ' TIPO: ' || TAB_ACT_EST.TIPO_INSTITUCION MATERIA,
>             DECODE(
>                 TAB_ACT_EST.NIVEL_CODIGO,
>                 NULL,
>                 'PRÁCTICA',
>                 TAB_ACT_EST.NIVEL_CODIGO
>             ) NIVEL,
>             'DESDE:' || TAB_ACT_EST.FECHA_INICIO || ' HASTA: ' || TAB_ACT_EST.FECHA_FIN AS CICLO,
>             TAB_ACT_EST.FECHA_INICIO,
>             TAB_CARRERA.CODIGO || '-' || TAB_NIVELES.CODIGO AS CODIGO_NODO,
>             TAB_CARRERA.CODIGO AS CARRERA,
>             TAB_FACULTAD.CODIGO AS FACULTAD,
>             TAB_INSTITUCION.CODIGO AS INSTITUCION,
>             TAB_MATERIAS.CODIGO AS CODIGO_MATERIA,
>             APELLIDOS_NOMBRES(TAB_ACT_EST.DOCENTE_CEDULA) DOCENTE,
>             TAB_ACT_EST.NOTA,
>             UPPER(TAB_CARRERA.NOMBRE) CARRERA_DESCRIPCION,
>             TAB_FACULTAD.NOMBRE FACULTAD_DESCRIPCION,
>             TAB_ACT_EST.ESTUDIANTE_CEDULA AS CEDULA
>         FROM
>             (
>                 (
>                     (
>                         (
>                             (
>                                 UTNDB.ACA_TAB_DEPENDENCIAS TAB_FACULTAD
>                                 LEFT JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_ESCUELA ON (
>                                     TAB_FACULTAD.INST_CODIGO = TAB_ESCUELA.DEPEN_INST_CODIGO
>                                 )
>                                 AND (
>                                     TAB_FACULTAD.CODIGO = TAB_ESCUELA.DEPEN_CODIGO
>                                 )
>                             )
>                             LEFT JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_CARRERA ON (
>                                 TAB_ESCUELA.INST_CODIGO = TAB_CARRERA.DEPEN_INST_CODIGO
>                             )
>                             AND (
>                                 TAB_ESCUELA.CODIGO = TAB_CARRERA.DEPEN_CODIGO
>                             )
>                         )
>                         LEFT JOIN UTNDB.aca_taB_actividades_estudiante TAB_ACT_EST ON (
>                             TAB_CARRERA.CODIGO = TAB_ACT_EST.DEPEN_CODIGO
>                             AND TAB_ACT_EST.ACTIVIDAD_CODIGO = '0055'
>                         )
>                     )
>                     LEFT JOIN UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS ON (
>                         TAB_ACT_EST.NIVEL_CODIGO = TAB_MATERIAS.NIVEL_CODIGO
>                     )
>                     AND (
>                         TAB_ACT_EST.MATERIA_CODIGO = TAB_MATERIAS.CODIGO
>                     )
>                 )
>                 LEFT JOIN UTNDB.ACA_TAB_NIVELES TAB_NIVELES ON (TAB_MATERIAS.NIVEL_CODIGO = TAB_NIVELES.CODIGO)
>             )
>             LEFT JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_INSTITUCION ON (
>                 TAB_INSTITUCION.INST_CODIGO = TAB_FACULTAD.DEPEN_INST_CODIGO
>             )
>             AND (
>                 TAB_INSTITUCION.CODIGO = TAB_FACULTAD.DEPEN_CODIGO
>             )
>     )
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> Q33 ✅: MVL_VIEW_NOTAS_POR_NIVEL (notas_estudiante), V2 compleja - 4 ramas UNION (matriculas,
> 	equiparacion/revalidacion, extension universitaria, practica preprofesional). Reescritura
> 	generada con script (node) sobre el texto exacto del .ts, no a mano, por el tamano (308 lineas
> 	origen): se agrego CEDULA como 19na columna en cada rama (tomando la columna que cada rama
> 	usaba en su propio filtro: ESTUDIANTE_CEDULA en 3 ramas, COD_EXTENSION en la de extension) y
> 	se quito el bind :G_CEDULA_USUARIO de las 4, filtro se mueve afuera. Se preservo intacto el bug
> 	documentado (ESTADO NOT IN ('AD') redundante) y el typo 'EXTENCIÓN UNIVERSITARIA'. 18 col
> 	(+CEDULA), 0 filas en los 2 MINUS (cedula <cedula>). Codigo migrado
> 	reales identicos a los ya validados. Validado por MCP.;
> ```

> [!example]- `MVL_FUN_NOTAS_POR_CICLO` (función)
> **Resultado:** comparación fila a fila: igual al original
>
> **Nota del registro:** (notas_estudiante), F - la sentencia mas compleja del repo (455
>
> **Lo usa:** `src/modules/notas_estudiante/repository/consultas/notas_por_ciclo_consulta.ts`
>
> **Antes** (`src/modules/notas_estudiante/repository/consultas/notas_por_ciclo_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const NOTAS_POR_CICLO_CONSULTA = `
> SELECT 
>   MATERIA AS MATERIA, 
>   NIVEL AS NIVEL, 
>   PARALELO AS PARALELO, 
>   MATRICULA AS "N_MATRICULA", 
>   DOCENTE AS DOCENTE, 
>   NOTA_1 AS "NOTA_1", 
>   NOTA_2 AS "NOTA_2", 
>   NOTA_3 AS "NOTA_3", 
>   NOTA_4 AS "NOTA_4", 
>   SUMA_1 AS "SUMA_1", 
>   PROM, 
>   SUMA_2 AS "SUMA_2", 
>   "FINAL", 
>   APROBO, 
>   CICLO AS "CICLO_ACADEMICO", 
>   FECHA_INICIO 
> FROM 
>   (
>     SELECT 
>       DISTINCT TAB_MATERIAS.DESCRIPCION AS MATERIA, 
>       TAB_NIVELES.DESCRIPCION AS NIVEL, 
>       TAB_DETALLE_MATRICULAS.PARALELO_CODIGO AS PARALELO, 
>       TAB_DETALLE_MATRICULAS.NUMERO_MATRICULA AS "MATRICULA", 
>       NOMBRES (TAB_DOCENTES.EMPLEADO_CEDULA) AS DOCENTE, 
>       TAB_NOTAS.NOTA1 AS "NOTA_1", 
>       TAB_NOTAS.NOTA2 AS "NOTA_2", 
>       TAB_NOTAS.NOTA3 AS "NOTA_3", 
>       TAB_NOTAS.NOTA4 AS "NOTA_4", 
>       TAB_NOTAS.RESULTADO1 AS "SUMA_1", 
>       TAB_NOTAS.FINAL1 AS PROM, 
>       TAB_NOTAS.RESULTADO2 AS "SUMA_2", 
>       TAB_NOTAS.NOTA_FINAL AS "FINAL", 
>       TAB_NOTAS.APROBO AS APROBO, 
>       TAB_CICLOS_ACADEMICOS.DESCRIPCION AS "CICLO", 
>       TAB_CICLOS_ACADEMICOS.FECHA_INICIO, 
>       TAB_CARRERA.CODIGO || '-' || TAB_NIVELES.CODIGO AS CODIGO_NODO, 
>       TAB_CARRERA.CODIGO AS CARRERA, 
>       TAB_FAC.CODIGO AS FACULTAD, 
>       TAB_INS.CODIGO AS INSTITUCION, 
>       TAB_MATERIAS.CODIGO AS CODIGO_MATERIA 
>     FROM 
>       (
>         (
>           (
>             (
>               (
>                 (
>                   (
>                     (
>                       (
>                         (
>                           (
>                             (
>                               UTNDB.ACA_TAB_DEPENDENCIAS TAB_FAC 
>                               INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_ESC ON (
>                                 TAB_FAC.INST_CODIGO = TAB_ESC.DEPEN_INST_CODIGO
>                               ) 
>                               AND (
>                                 TAB_FAC.CODIGO = TAB_ESC.DEPEN_CODIGO
>                               )
>                             ) 
>                             INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_CARRERA ON (
>                               TAB_ESC.INST_CODIGO = TAB_CARRERA.DEPEN_INST_CODIGO
>                             ) 
>                             AND (
>                               TAB_ESC.CODIGO = TAB_CARRERA.DEPEN_CODIGO
>                             )
>                           ) 
>                           INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
>                             TAB_CARRERA.CODIGO = TAB_DETALLE_MATRICULAS.DEPEN_CODIGO
>                           ) 
>                           AND (
>                             TAB_CARRERA.INST_CODIGO = TAB_DETALLE_MATRICULAS.INST_CODIGO
>                           )
>                         ) 
>                         INNER JOIN UTNDB.ACA_TAB_MATRICULAS TAB_MATRICULAS ON (
>                           TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA = TAB_MATRICULAS.ESTUDIANTE_CEDULA
>                         ) 
>                         AND (
>                           TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO = TAB_MATRICULAS.CODIGO
>                         )
>                       ) 
>                       INNER JOIN UTNDB.ACA_TAB_NOTAS TAB_NOTAS ON (
>                         TAB_NOTAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>                       ) 
>                       AND (
>                         TAB_NOTAS.MATRICULA_CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.MATERIA_CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.DEPEN_CODIGO = TAB_DETALLE_MATRICULAS.DEPEN_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.INST_CODIGO = TAB_DETALLE_MATRICULAS.INST_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.TFINANCIA_CODIGO = TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.MODA_ESTUD_CODIGO = TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO
>                       ) 
>                       /*AND (TAB_NOTAS.TCICLOACAD_CODIGO =
>                                                                                   TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO)*/
>                       AND (
>                         TAB_NOTAS.SIST_ESTUD_CODIGO = TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.CICLO_ACAD_CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.PARALELO_CODIGO = TAB_DETALLE_MATRICULAS.PARALELO_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.DOCENTE_CEDULA = TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA
>                       )
>                     ) 
>                     INNER JOIN UTNDB.ACA_TAB_DISTRIBUTIVOS TAB_DISTRIBUTIVOS ON (
>                       TAB_DETALLE_MATRICULAS.NIVEL_CODIGO = TAB_DISTRIBUTIVOS.NIVEL_CODIGO
>                     ) 
>                     AND (
>                       TAB_DETALLE_MATRICULAS.MATERIA_CODIGO = TAB_DISTRIBUTIVOS.MATERIA_CODIGO
>                     ) 
>                     AND (
>                       TAB_DETALLE_MATRICULAS.DEPEN_CODIGO = TAB_DISTRIBUTIVOS.DEPEN_CODIGO
>                     ) 
>                     AND (
>                       TAB_DETALLE_MATRICULAS.INST_CODIGO = TAB_DISTRIBUTIVOS.INST_CODIGO
>                     ) 
>                     AND (
>                       TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO = TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO
>                     ) 
>                     AND (
>                       TAB_DETALLE_MATR
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_FUN_NOTAS_POR_CICLO
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_FUN_NOTAS_POR_CICLO')
> -- Usado por: src/modules/notas_estudiante
>
> CREATE OR REPLACE FUNCTION MOVIL_UTN.MVL_FUN_NOTAS_POR_CICLO (
>     p_cedula IN UTNDB.RHU_TAB_PERSONAS.CEDULA%TYPE,
>     p_codigo_nodo IN VARCHAR2
> ) RETURN SYS_REFCURSOR
> AS
>     v_cursor SYS_REFCURSOR;
> BEGIN
>     OPEN v_cursor FOR
> SELECT 
>   MATERIA AS MATERIA, 
>   NIVEL AS NIVEL, 
>   PARALELO AS PARALELO, 
>   MATRICULA AS "N_MATRICULA", 
>   DOCENTE AS DOCENTE, 
>   NOTA_1 AS "NOTA_1", 
>   NOTA_2 AS "NOTA_2", 
>   NOTA_3 AS "NOTA_3", 
>   NOTA_4 AS "NOTA_4", 
>   SUMA_1 AS "SUMA_1", 
>   PROM, 
>   SUMA_2 AS "SUMA_2", 
>   "FINAL", 
>   APROBO, 
>   CICLO AS "CICLO_ACADEMICO", 
>   FECHA_INICIO 
> FROM 
>   (
>     SELECT 
>       DISTINCT TAB_MATERIAS.DESCRIPCION AS MATERIA, 
>       TAB_NIVELES.DESCRIPCION AS NIVEL, 
>       TAB_DETALLE_MATRICULAS.PARALELO_CODIGO AS PARALELO, 
>       TAB_DETALLE_MATRICULAS.NUMERO_MATRICULA AS "MATRICULA", 
>       NOMBRES (TAB_DOCENTES.EMPLEADO_CEDULA) AS DOCENTE, 
>       TAB_NOTAS.NOTA1 AS "NOTA_1", 
>       TAB_NOTAS.NOTA2 AS "NOTA_2", 
>       TAB_NOTAS.NOTA3 AS "NOTA_3", 
>       TAB_NOTAS.NOTA4 AS "NOTA_4", 
>       TAB_NOTAS.RESULTADO1 AS "SUMA_1", 
>       TAB_NOTAS.FINAL1 AS PROM, 
>       TAB_NOTAS.RESULTADO2 AS "SUMA_2", 
>       TAB_NOTAS.NOTA_FINAL AS "FINAL", 
>       TAB_NOTAS.APROBO AS APROBO, 
>       TAB_CICLOS_ACADEMICOS.DESCRIPCION AS "CICLO", 
>       TAB_CICLOS_ACADEMICOS.FECHA_INICIO, 
>       TAB_CARRERA.CODIGO || '-' || TAB_NIVELES.CODIGO AS CODIGO_NODO, 
>       TAB_CARRERA.CODIGO AS CARRERA, 
>       TAB_FAC.CODIGO AS FACULTAD, 
>       TAB_INS.CODIGO AS INSTITUCION, 
>       TAB_MATERIAS.CODIGO AS CODIGO_MATERIA 
>     FROM 
>       (
>         (
>           (
>             (
>               (
>                 (
>                   (
>                     (
>                       (
>                         (
>                           (
>                             (
>                               UTNDB.ACA_TAB_DEPENDENCIAS TAB_FAC 
>                               INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_ESC ON (
>                                 TAB_FAC.INST_CODIGO = TAB_ESC.DEPEN_INST_CODIGO
>                               ) 
>                               AND (
>                                 TAB_FAC.CODIGO = TAB_ESC.DEPEN_CODIGO
>                               )
>                             ) 
>                             INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_CARRERA ON (
>                               TAB_ESC.INST_CODIGO = TAB_CARRERA.DEPEN_INST_CODIGO
>                             ) 
>                             AND (
>                               TAB_ESC.CODIGO = TAB_CARRERA.DEPEN_CODIGO
>                             )
>                           ) 
>                           INNER JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
>                             TAB_CARRERA.CODIGO = TAB_DETALLE_MATRICULAS.DEPEN_CODIGO
>                           ) 
>                           AND (
>                             TAB_CARRERA.INST_CODIGO = TAB_DETALLE_MATRICULAS.INST_CODIGO
>                           )
>                         ) 
>                         INNER JOIN UTNDB.ACA_TAB_MATRICULAS TAB_MATRICULAS ON (
>                           TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA = TAB_MATRICULAS.ESTUDIANTE_CEDULA
>                         ) 
>                         AND (
>                           TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO = TAB_MATRICULAS.CODIGO
>                         )
>                       ) 
>                       INNER JOIN UTNDB.ACA_TAB_NOTAS TAB_NOTAS ON (
>                         TAB_NOTAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>                       ) 
>                       AND (
>                         TAB_NOTAS.MATRICULA_CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.MATERIA_CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.DEPEN_CODIGO = TAB_DETALLE_MATRICULAS.DEPEN_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.INST_CODIGO = TAB_DETALLE_MATRICULAS.INST_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.TFINANCIA_CODIGO = TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.MODA_ESTUD_CODIGO = TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO
>                       ) 
>                       /*AND (TAB_NOTAS.TCICLOACAD_CODIGO =
>                                                                                   TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO)*/
>                       AND (
>                         TAB_NOTAS.SIST_ESTUD_CODIGO = TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.CICLO_ACAD_CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.PARALELO_CODIGO = TAB_DETALLE_MATRICULAS.PARALELO_CODIGO
>                       ) 
>                       AND (
>                         TAB_NOTAS.DOCENTE_CEDULA = TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA
>                       )
>                     ) 
>                     INNER JOIN UTNDB.ACA_TAB_DISTRIBUTIVOS TAB_DISTRIBUTIVOS ON (
>                       TAB_DETALLE_MATRICULAS.NIVEL_CODIGO = TAB_DISTRIBUTIVOS.NIVEL_CODIGO
>                     ) 
>                     AND (
>                       TAB_DETALLE_MATRICULAS.MATERIA_CODIGO = TAB_DISTRIBUTIVOS.MATERIA_CODIGO
>                     ) 
>                     AND (
>                       TAB_DETALLE_MATRICULAS.DEPEN_CODIGO = TAB_DISTRIBUTIVOS.DEPEN_CODIGO
>                     ) 
>                     AND (
>                       TAB_DETALLE_MATRICULAS.INST_CODIGO = TAB_DISTRIBUTIVOS.INST_CODIGO
>                     ) 
>                     AND (
>                       TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO = TAB_DISTRIBUTIVOS.TFINANCIA_CODIGO
>                     ) 
>                     AND (
>                       TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO = TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO
>                     ) 
>                     AND (
>                       TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO = TAB_DISTRIBUTIVOS.TCICLOACAD_CODIGO
>                     ) 
>                     AND (
>                       TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO = TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO
>                     ) 
>                     AND (
>                       TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO
>                     ) 
>                     AND (
>                       TAB_DETALLE_MATRICULAS.PARALELO_CODIGO = TAB_DISTRIBUTIVOS.PARALELO_CODIGO
>                     ) 
>                     AND (
>                       TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA = TAB_DISTRIBUTIVOS.DOCENTE_CEDULA
>                     )
>                   ) 
>                   INNER JOIN UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS ON (
>                     TAB_MATERIAS.CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
>                   ) 
>                   AND (
>                     TAB_MATERIAS.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
>                   ) 
>                   AND (
>                     TAB_MATERIAS.DEPEN_CODIGO = TAB_DETALLE_MATRICULAS.DEPEN_CODIGO
>                   ) 
>                   AND (
>                     TAB_MATERIAS.INST_CODIGO = TAB_DETALLE_MATRICULAS.INST_CODIGO
>                   )
>                 ) 
>                 INNER JOIN UTNDB.ACA_TAB_NIVELES TAB_NIVELES ON (
>                   TAB_MATERIAS.NIVEL_CODIGO = TAB_NIVELES.CODIGO
>                 )
>               ) 
>               INNER JOIN UTNDB.REC_VIEW_DEPENDENCIAS VIEW_DEPENDENCIAS ON (
>                 VIEW_DEPENDENCIAS.CODIGO_CA = TAB_MATRICULAS.DEPEN_CODIGO
>               )
>             ) 
>             INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TAB_CICLOS_ACADEMICOS ON (
>               TAB_CICLOS_ACADEMICOS.CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
>             )
>           ) 
>           INNER JOIN UTNDB.ACA_TAB_DOCENTES TAB_DOCENTES ON (
>             TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA = TAB_DOCENTES.EMPLEADO_CEDULA
>           )
>         ) 
>         INNER JOIN UTNDB.ACA_TAB_ESTUDIANTES TAB_ESTUDIANTES ON (
>           TAB_ESTUDIANTES.PERSONA_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
>         )
>       ) 
>       INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_INS ON (
>         TAB_INS.INST_CODIGO = TAB_FAC.DEPEN_INST_CODIGO
>       ) 
>       AND (
>         TAB_INS.CODIGO = TAB_FAC.DEPEN_CODIGO
>       ) 
>     WHERE 
>       (
>         TAB_MATRICULAS.ESTADO IN ('C', 'M', 'R')
>       ) 
>       AND (
>         TAB_MATRICULAS.NIVEL_CODIGO NOT IN ('AD')
>       ) 
>       AND (
>         TAB_DETALLE_MATRICULAS.ANULACION != 'S'
>       ) 
>       AND (
>         TAB_ESTUDIANTES.PERSONA_CEDULA = p_cedula
>       ) 
>     ORDER BY 
>       TAB_CICLOS_ACADEMICOS.PER_ACAD_CODIGO, 
>       TAB_CICLOS_ACADEMICOS.CODIGO, 
>       TAB_CICLOS_ACADEMICOS.ORDEN, 
>       TAB_CICLOS_ACADEMICOS.FECHA_INICIO, 
>       TAB_NIVELES.CODIGO ASC
>   ) 
> WHERE 
>   (
>     CODIGO_MATERIA = p_codigo_nodo 
>     OR CODIGO_NODO = p_codigo_nodo 
>     OR CARRERA = p_codigo_nodo 
>     OR FACULTAD = p_codigo_nodo 
>     OR INSTITUCION = p_codigo_nodo
>   ) 
> UNION 
> SELECT 
>   MATERIA AS MATERIA, 
>   NIVEL AS NIVEL, 
>   'EQ' AS PARALELO, 
>   1 AS "N_MATRICULA", 
>   'EQUIPARACIÓN' AS DOCENTE, 
>   NOTA AS "NOTA_1", 
>   NOTA AS "NOTA_2", 
>   NULL AS "NOTA_3", 
>   NULL AS "NOTA_4", 
>   NOTA + NOTA AS "SUMA_1", 
>   NOTA, 
>   NULL AS "SUMA_2", 
>   NOTA, 
>   'S' AS APROBO, 
>   CICLO AS "CICLO_ACADEMICO", 
>   FECHA_INICIO 
> FROM 
>   (
>     SELECT 
>       DISTINCT TAB_MATERIAS.DESCRIPCION AS MATERIA, 
>       TAB_NIVELES.DESCRIPCION AS NIVEL, 
>       TAB_CICLOS_ACADEMICOS.DESCRIPCION AS "CICLO", 
>       TAB_CICLOS_ACADEMICOS.FECHA_INICIO, 
>       TAB_CARRERA.CODIGO || '-' || TAB_NIVELES.CODIGO AS CODIGO_NODO, 
>       TAB_CARRERA.CODIGO AS CARRERA, 
>       TAB_FACULTAD.CODIGO AS FACULTAD, 
>       TAB_INSTITUCION.CODIGO AS INSTITUCION, 
>       TAB_MATERIAS.CODIGO AS CODIGO_MATERIA, 
>       TAB_DET_MATRICULA_REV.NOTA 
>     FROM 
>       (
>         (
>           (
>             (
>               (
>                 (
>                   UTNDB.ACA_TAB_DEPENDENCIAS TAB_FACULTAD 
>                   LEFT JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_ESCUELA ON (
>                     TAB_FACULTAD.INST_CODIGO = TAB_ESCUELA.DEPEN_INST_CODIGO
>                   ) 
>                   AND (
>                     TAB_FACULTAD.CODIGO = TAB_ESCUELA.DEPEN_CODIGO
>                   )
>                 ) 
>                 LEFT JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_CARRERA ON (
>                   TAB_ESCUELA.INST_CODIGO = TAB_CARRERA.DEPEN_INST_CODIGO
>                 ) 
>                 AND (
>                   TAB_ESCUELA.CODIGO = TAB_CARRERA.DEPEN_CODIGO
>                 )
>               ) 
>               LEFT JOIN UTNDB.ACA_TAB_DET_MATRICULAS_REVAL TAB_DET_MATRICULA_REV ON (
>                 TAB_CARRERA.CODIGO = TAB_DET_MATRICULA_REV.DEPEN_CODIGO
>               ) 
>               AND (
>                 TAB_CARRERA.INST_CODIGO = TAB_DET_MATRICULA_REV.INST_CODIGO
>               )
>             ) 
>             LEFT JOIN UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS ON (
>               TAB_DET_MATRICULA_REV.NIVEL_CODIGO = TAB_MATERIAS.NIVEL_CODIGO
>             ) 
>             AND (
>               TAB_DET_MATRICULA_REV.MATERIA_CODIGO = TAB_MATERIAS.CODIGO
>             )
>           ) 
>           LEFT JOIN UTNDB.ACA_TAB_NIVELES TAB_NIVELES ON (
>             TAB_MATERIAS.NIVEL_CODIGO = TAB_NIVELES.CODIGO
>           )
>         ) 
>         LEFT JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TAB_CICLOS_ACADEMICOS ON (
>           TAB_CICLOS_ACADEMICOS.CODIGO = TAB_DET_MATRICULA_REV.CICLO_ACAD_CODIGO
>         )
>       ) 
>       LEFT JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_INSTITUCION ON (
>         TAB_INSTITUCION.INST_CODIGO = TAB_FACULTAD.DEPEN_INST_CODIGO
>       ) 
>       AND (
>         TAB_INSTITUCION.CODIGO = TAB_FACULTAD.DEPEN_CODIGO
>       ) 
>     WHERE 
>       (
>         TAB_DET_MATRICULA_REV.ESTUDIANTE_CEDULA = p_cedula
>       ) 
>     ORDER BY 
>       TAB_CICLOS_ACADEMICOS.PER_ACAD_CODIGO, 
>       TAB_CICLOS_ACADEMICOS.CODIGO, 
>       TAB_CICLOS_ACADEMICOS.ORDEN, 
>       TAB_CICLOS_ACADEMICOS.FECHA_INICIO, 
>       TAB_NIVELES.CODIGO ASC
>   ) 
> WHERE 
>   (
>     CODIGO_MATERIA = p_codigo_nodo 
>     OR CODIGO_NODO = p_codigo_nodo 
>     OR CARRERA = p_codigo_nodo 
>     OR FACULTAD = p_codigo_nodo 
>     OR INSTITUCION = p_codigo_nodo
>   ) 
> UNION 
> SELECT 
>   DISTINCT 'EXTENSIÓN UNIVERSITARIA:' || TAB_EXTENSION.DESCRIPCION AS MATERIA, 
>   'EXTENSIÓN UNIVERSITARIA' AS NIVEL, 
>   NULL AS PARALELO, 
>   NULL AS "N_MATRICULA", 
>   TAB_EXTENSION.COORDINADOR_LOCAL AS DOCENTE, 
>   TAB_NOTAS.PARTICIPACION AS "NOTA_1", 
>   TAB_NOTAS.ENTREGA_DOC AS "NOTA_2", 
>   TAB_NOTAS.SEGUIMIENTO AS "NOTA_3", 
>   NULL AS "NOTA_4", 
>   NULL AS "SUMA_1", 
>   TAB_NOTAS.PROMEDIO_EXT AS PROM, 
>   NULL AS "SUMA_2", 
>   TAB_NOTAS.PROMEDIO_EXT AS "FINAL", 
>   TAB_NOTAS.APRUEBA_EXT AS APROBO, 
>   TAB_EXTENSION.PERIODO AS "CICLO_ACADEMICO", 
>   TAB_EXTENSION.FECHA_INICIO AS FECHA_INICIO 
> FROM 
>   (
>     UTNDB.VIN_TAB_EXTENSION TAB_EXTENSION 
>     INNER JOIN UTNDB.VIN_TAB_INSTITUCION TAB_INSTITUCION ON (
>       TAB_EXTENSION.COD_INSTITUCION = TAB_INSTITUCION.CODIGO
>     )
>   ) 
>   INNER JOIN UTNDB.VIN_TAB_NOTAS TAB_NOTAS ON (
>     TAB_NOTAS.COD_EXTENSION = TAB_EXTENSION.COD_PERSONA
>   ) 
>   AND (
>     TAB_NOTAS.PERIODO = TAB_EXTENSION.PERIODO
>   ) 
> WHERE 
>   (
>     TAB_NOTAS.COD_EXTENSION = p_cedula
>   ) 
> UNION 
> SELECT 
>   'PRÁCTICA PRE PROFESIONAL:' || MATERIA AS MATERIA, 
>   NIVEL AS NIVEL, 
>   NULL AS PARALELO, 
>   NULL AS "N_MATRICULA", 
>   DOCENTE AS DOCENTE, 
>   NULL AS "NOTA_1", 
>   NULL AS "NOTA_2", 
>   NULL AS "NOTA_3", 
>   NULL AS "NOTA_4", 
>   NULL AS "SUMA_1", 
>   NULL as "PROM", 
>   NULL AS "SUMA_2", 
>   NOTA, 
>   NULL AS APROBO, 
>   CICLO AS "CICLO_ACADEMICO", 
>   FECHA_INICIO 
> FROM 
>   (
>     SELECT 
>       DISTINCT DECODE (
>         TAB_MATERIAS.DESCRIPCION, null, ' ', 
>         'PRACTICA PRE-PROFESIONAL', ' ', 
>         ' (' || TAB_MATERIAS.DESCRIPCION || ')'
>       )|| ' ' || TAB_ACT_EST.HORAS || ' HORAS EN LA INSTITUCION: ' || TAB_ACT_EST.INSTITUCION || ' TIPO: ' || TAB_ACT_EST.TIPO_INSTITUCION MATERIA, 
>       DECODE(
>         TAB_NIVELES.DESCRIPCION, 'CERO', 
>         'PRÁCTICA', NULL, 'PRÁCTICA', TAB_NIVELES.DESCRIPCION
>       ) AS NIVEL, 
>       'DESDE: ' || TAB_ACT_EST.FECHA_INICIO || ' HASTA: ' || TAB_ACT_EST.FECHA_FIN AS CICLO, 
>       TAB_ACT_EST.FECHA_INICIO, 
>       TAB_CARRERA.CODIGO || '-' || TAB_NIVELES.CODIGO AS CODIGO_NODO, 
>       TAB_CARRERA.CODIGO AS CARRERA, 
>       TAB_FACULTAD.CODIGO AS FACULTAD, 
>       TAB_INSTITUCION.CODIGO AS INSTITUCION, 
>       TAB_MATERIAS.CODIGO AS CODIGO_MATERIA, 
>       APELLIDOS_NOMBRES(TAB_ACT_EST.DOCENTE_CEDULA) DOCENTE, 
>       TAB_ACT_EST.NOTA 
>     FROM 
>       (
>         (
>           (
>             (
>               (
>                 UTNDB.ACA_TAB_DEPENDENCIAS TAB_FACULTAD 
>                 LEFT JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_ESCUELA ON (
>                   TAB_FACULTAD.INST_CODIGO = TAB_ESCUELA.DEPEN_INST_CODIGO
>                 ) 
>                 AND (
>                   TAB_FACULTAD.CODIGO = TAB_ESCUELA.DEPEN_CODIGO
>                 )
>               ) 
>               LEFT JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_CARRERA ON (
>                 TAB_ESCUELA.INST_CODIGO = TAB_CARRERA.DEPEN_INST_CODIGO
>               ) 
>               AND (
>                 TAB_ESCUELA.CODIGO = TAB_CARRERA.DEPEN_CODIGO
>               )
>             ) 
>             LEFT JOIN UTNDB.aca_taB_actividades_estudiante TAB_ACT_EST ON (
>               TAB_CARRERA.CODIGO = TAB_ACT_EST.DEPEN_CODIGO 
>               AND TAB_ACT_EST.ACTIVIDAD_CODIGO = '0055'
>             )
>           ) 
>           LEFT JOIN UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS ON (
>             TAB_ACT_EST.NIVEL_CODIGO = TAB_MATERIAS.NIVEL_CODIGO
>           ) 
>           AND (
>             TAB_ACT_EST.MATERIA_CODIGO = TAB_MATERIAS.CODIGO
>           )
>         ) 
>         LEFT JOIN UTNDB.ACA_TAB_NIVELES TAB_NIVELES ON (
>           TAB_MATERIAS.NIVEL_CODIGO = TAB_NIVELES.CODIGO
>         )
>       ) 
>       LEFT JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_INSTITUCION ON (
>         TAB_INSTITUCION.INST_CODIGO = TAB_FACULTAD.DEPEN_INST_CODIGO
>       ) 
>       AND (
>         TAB_INSTITUCION.CODIGO = TAB_FACULTAD.DEPEN_CODIGO
>       ) 
>     WHERE 
>       (
>         TAB_ACT_EST.ESTUDIANTE_CEDULA = p_cedula
>       ) 
>     ORDER BY 
>       TAB_ACT_EST.FECHA_INICIO
>   ) 
> WHERE 
>   (
>     CODIGO_MATERIA = p_codigo_nodo 
>     OR CODIGO_NODO = p_codigo_nodo 
>     OR CARRERA = p_codigo_nodo 
>     OR FACULTAD = p_codigo_nodo 
>     OR INSTITUCION = p_codigo_nodo
>   )
>     ;
>     RETURN v_cursor;
> END MVL_FUN_NOTAS_POR_CICLO;
> /
> ```

> [!example]- `MVL_VIEW_CALENDARIO_AULA_VIRTUAL` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** (aula_virtual), V1 - expone ID_CURSO y CUENTA (no
>
> **Lo usa:** `src/modules/aula_virtual/respository/consultas/calendario_actividades_aula_virtual_consulta.ts`
>
> **Antes** (`src/modules/aula_virtual/respository/consultas/calendario_actividades_aula_virtual_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const CALENDARIO_ACTIVIDADES_AULA_VIRTUAL_CONSULTA = `
> SELECT
>     DISTINCT ACTIVIDAD.ID_ACTIVIDAD,
>     ACTIVIDAD.NOMBRE_CORTO,
>     ACTIVIDAD.FECHA_FIN,
>     MATERIA.DESCRIPCION "MATERIA",
>     ACT_ALUMNO.ENTREGADO,
>     (
>         CASE
>             WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 7 THEN 'NO_REQUIERE_ADJUNTO'
>             WHEN ACT_ALUMNO.ENTREGADO = 'SI' AND ACT_ALUMNO.ID_DOCUMENTO_DIRECTORIO IS NOT NULL THEN 'ENTREGADO_CON_ADJUNTO'
>             WHEN ACT_ALUMNO.ENTREGADO = 'SI' AND ACT_ALUMNO.ID_DOCUMENTO_DIRECTORIO IS NULL THEN 'ENTREGADO_SIN_ADJUNTO'
>             ELSE 'NO_ENTREGADO'
>         END
>     ) AS CON_ADJUNTO,
>     ACT_ALUMNO.ID_ACTIVIDAD_ALUMNO AS ID_ACTIVIDAD_ALUMNO
> FROM
>     LMS_TAB_ACTIVIDAD_ACADEMICA ACTIVIDAD
>     INNER JOIN LMS_TAB_AULAS_VIRTUALES AULA ON(AULA.ID_CURSO = ACTIVIDAD.ID_CURSO)
>     INNER JOIN ACA_TAB_CICLOS_ACADEMICOS CICLO ON(CICLO.CODIGO = AULA.CODIGO_CICLO_ACAD)
>     INNER JOIN LMS_TAB_INTEGRANTES INTEGRANTE ON(INTEGRANTE.ID_CURSO = AULA.ID_CURSO)
>     INNER JOIN ACA_TAB_MATERIAS MATERIA ON(
>         MATERIA.CODIGO = AULA.CODIGO_MATERIA
>         AND MATERIA.NIVEL_CODIGO = AULA.CODIGO_NIVEL
>     )
>     INNER JOIN INS_TAB_USUARIOS USUARIO ON (
>         USUARIO.PERSONA_CEDULA = INTEGRANTE.CEDULA_INTEGRANTE
>     )
>     INNER JOIN LMS_TAB_ACTIVIDADES_ALUMNOS ACT_ALUMNO ON (
>         ACT_ALUMNO.ID_ACTIVIDAD = ACTIVIDAD.ID_ACTIVIDAD
>         AND ACT_ALUMNO.CEDULA_INTEGRANTE = INTEGRANTE.CEDULA_INTEGRANTE
>     )
> WHERE
>     CICLO.ESTADO = 'A'
>     AND AULA.ID_CURSO = :P110_ID_CURSO
>     AND USUARIO.CUENTA = :CUENTA
>     and ACTIVIDAD.ESTADO = 'A'
>
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_CALENDARIO_AULA_VIRTUAL
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=INVALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/aula_virtual
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_CALENDARIO_AULA_VIRTUAL ("ID_ACTIVIDAD", "NOMBRE_CORTO", "FECHA_FIN", "MATERIA", "ENTREGADO", "CON_ADJUNTO", "ID_ACTIVIDAD_ALUMNO", "ID_CURSO", "CUENTA") AS
> SELECT
>     DISTINCT ACTIVIDAD.ID_ACTIVIDAD,
>     ACTIVIDAD.NOMBRE_CORTO,
>     ACTIVIDAD.FECHA_FIN,
>     MATERIA.DESCRIPCION AS MATERIA,
>     ACT_ALUMNO.ENTREGADO,
>     (
>         CASE
>             WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 7 THEN 'NO_REQUIERE_ADJUNTO'
>             WHEN ACT_ALUMNO.ENTREGADO = 'SI' AND ACT_ALUMNO.ID_DOCUMENTO_DIRECTORIO IS NOT NULL THEN 'ENTREGADO_CON_ADJUNTO'
>             WHEN ACT_ALUMNO.ENTREGADO = 'SI' AND ACT_ALUMNO.ID_DOCUMENTO_DIRECTORIO IS NULL THEN 'ENTREGADO_SIN_ADJUNTO'
>             ELSE 'NO_ENTREGADO'
>         END
>     ) AS CON_ADJUNTO,
>     ACT_ALUMNO.ID_ACTIVIDAD_ALUMNO AS ID_ACTIVIDAD_ALUMNO,
>     AULA.ID_CURSO AS ID_CURSO,
>     USUARIO.CUENTA AS CUENTA
> FROM
>     UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA ACTIVIDAD
>     INNER JOIN UTNDB.LMS_TAB_AULAS_VIRTUALES AULA ON(AULA.ID_CURSO = ACTIVIDAD.ID_CURSO)
>     INNER JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS CICLO ON(CICLO.CODIGO = AULA.CODIGO_CICLO_ACAD)
>     INNER JOIN UTNDB.LMS_TAB_INTEGRANTES INTEGRANTE ON(INTEGRANTE.ID_CURSO = AULA.ID_CURSO)
>     INNER JOIN UTNDB.ACA_TAB_MATERIAS MATERIA ON(
>         MATERIA.CODIGO = AULA.CODIGO_MATERIA
>         AND MATERIA.NIVEL_CODIGO = AULA.CODIGO_NIVEL
>     )
>     INNER JOIN UTNDB.INS_TAB_USUARIOS USUARIO ON (
>         USUARIO.PERSONA_CEDULA = INTEGRANTE.CEDULA_INTEGRANTE
>     )
>     INNER JOIN UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS ACT_ALUMNO ON (
>         ACT_ALUMNO.ID_ACTIVIDAD = ACTIVIDAD.ID_ACTIVIDAD
>         AND ACT_ALUMNO.CEDULA_INTEGRANTE = INTEGRANTE.CEDULA_INTEGRANTE
>     )
> WHERE
>     CICLO.ESTADO = 'A'
>     AND ACTIVIDAD.ESTADO = 'A'
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> CICLO.ESTADO='A' y ACTIVIDAD.ESTADO='A'
> 	fijos dentro. 7 col, 0 filas MINUS en los 2 sentidos (154 filas reales, idCurso 54443, cuenta
> 	<cuenta-de-prueba>). Codigo migrado, build limpio, curl /aula-virtual/calendario-actividades con
> 	datos reales.;
> ```

> [!example]- `MVL_VIEW_LISTA_ACTIVIDADES` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** (aula_virtual), V1 - expone ID_CURSO y CEDULA_INTEGRANTE
>
> **Lo usa:** `src/modules/aula_virtual/respository/consultas/lista_actividades_consulta.ts`
>
> **Antes** (`src/modules/aula_virtual/respository/consultas/lista_actividades_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const LISTA_ACTIVIDADES_CONSULTA = `
> SELECT
>     LMS_TAB_ACTIVIDAD_ACADEMICA.ID_ACTIVIDAD,
>     ACA_TAB_TIPOS_PORCENTAJE_EVAL.DESCRIPCION AS TIPO_ACTIVIDAD,
>     LMS_TAB_ACTIVIDAD_ACADEMICA.NOMBRE_CORTO,
>     LMS_TAB_ACTIVIDAD_ACADEMICA.ESTADO,
>     LMS_TAB_ACTIVIDADES_ALUMNOS.ID_ACTIVIDAD_ALUMNO,
>     LMS_TAB_ACTIVIDADES_ALUMNOS.ADJUNTO_LAST_UPDATE as FECHA_ENTREGA,
>     LMS_TAB_ACTIVIDADES_ALUMNOS.CALIFICACION,
>     LMS_TAB_ACTIVIDAD_ACADEMICA.CODIGO_PARCIAL,
>     LMS_TAB_ACTIVIDAD_ACADEMICA.FECHA_FIN,
>     case
>         WHEN LMS_TAB_ACTIVIDAD_ACADEMICA.TIPO_ACTIVIDAD = 7 THEN 'NO_REQUIERE_ADJUNTO'
>         WHEN LMS_TAB_ACTIVIDADES_ALUMNOS.ENTREGADO = 'SI' AND LMS_TAB_ACTIVIDADES_ALUMNOS.ID_DOCUMENTO_DIRECTORIO IS NOT NULL THEN 'ENTREGADO_CON_ADJUNTO'
>         WHEN LMS_TAB_ACTIVIDADES_ALUMNOS.ENTREGADO = 'SI' AND LMS_TAB_ACTIVIDADES_ALUMNOS.ID_DOCUMENTO_DIRECTORIO IS NULL THEN 'ENTREGADO_SIN_ADJUNTO'
>         ELSE 'NO_ENTREGADO'
>     end as ENTREGADO
> FROM
>     (
>         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA LMS_TAB_ACTIVIDAD_ACADEMICA
>         INNER JOIN UTNDB.ACA_TAB_TIPOS_PORCENTAJE_EVAL ACA_TAB_TIPOS_PORCENTAJE_EVAL ON (
>             LMS_TAB_ACTIVIDAD_ACADEMICA.CODIGO_TIPO_EVAL = ACA_TAB_TIPOS_PORCENTAJE_EVAL.CODIGO
>         )
>     )
>     INNER JOIN UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS LMS_TAB_ACTIVIDADES_ALUMNOS ON (
>         LMS_TAB_ACTIVIDADES_ALUMNOS.ID_ACTIVIDAD = LMS_TAB_ACTIVIDAD_ACADEMICA.ID_ACTIVIDAD
>     )
>     AND LMS_TAB_ACTIVIDAD_ACADEMICA.ESTADO = 'A'
>     AND (
>         LMS_TAB_ACTIVIDAD_ACADEMICA.ESTADO = 'A'
>     )
>     AND (
>         LMS_TAB_ACTIVIDAD_ACADEMICA.CODIGO_PARCIAL = :P212_CODIGO_PARCIAL
>     )
> WHERE
>     (
>         LMS_TAB_ACTIVIDADES_ALUMNOS.ID_CURSO = :P212_ID_CURSO
>     )
>     AND (
>         LMS_TAB_ACTIVIDADES_ALUMNOS.CEDULA_INTEGRANTE = :P212_CEDULA_INTEGRANTE
>     )
>     AND (LMS_TAB_ACTIVIDAD_ACADEMICA.ESTADO = 'A')
>     AND (
>         LMS_TAB_ACTIVIDAD_ACADEMICA.CODIGO_PARCIAL = :P212_CODIGO_PARCIAL
>     )
> ORDER BY
>     LMS_TAB_ACTIVIDAD_ACADEMICA.FECHA_FIN desc
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_LISTA_ACTIVIDADES
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=INVALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/aula_virtual
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_LISTA_ACTIVIDADES ("ID_ACTIVIDAD", "TIPO_ACTIVIDAD", "NOMBRE_CORTO", "ESTADO", "ID_ACTIVIDAD_ALUMNO", "FECHA_ENTREGA", "CALIFICACION", "CODIGO_PARCIAL", "FECHA_FIN", "ENTREGADO", "ID_CURSO", "CEDULA_INTEGRANTE") AS
> SELECT
>     LMS_TAB_ACTIVIDAD_ACADEMICA.ID_ACTIVIDAD,
>     ACA_TAB_TIPOS_PORCENTAJE_EVAL.DESCRIPCION AS TIPO_ACTIVIDAD,
>     LMS_TAB_ACTIVIDAD_ACADEMICA.NOMBRE_CORTO,
>     LMS_TAB_ACTIVIDAD_ACADEMICA.ESTADO,
>     LMS_TAB_ACTIVIDADES_ALUMNOS.ID_ACTIVIDAD_ALUMNO,
>     LMS_TAB_ACTIVIDADES_ALUMNOS.ADJUNTO_LAST_UPDATE AS FECHA_ENTREGA,
>     LMS_TAB_ACTIVIDADES_ALUMNOS.CALIFICACION,
>     LMS_TAB_ACTIVIDAD_ACADEMICA.CODIGO_PARCIAL,
>     LMS_TAB_ACTIVIDAD_ACADEMICA.FECHA_FIN,
>     CASE
>         WHEN LMS_TAB_ACTIVIDAD_ACADEMICA.TIPO_ACTIVIDAD = 7 THEN 'NO_REQUIERE_ADJUNTO'
>         WHEN LMS_TAB_ACTIVIDADES_ALUMNOS.ENTREGADO = 'SI' AND LMS_TAB_ACTIVIDADES_ALUMNOS.ID_DOCUMENTO_DIRECTORIO IS NOT NULL THEN 'ENTREGADO_CON_ADJUNTO'
>         WHEN LMS_TAB_ACTIVIDADES_ALUMNOS.ENTREGADO = 'SI' AND LMS_TAB_ACTIVIDADES_ALUMNOS.ID_DOCUMENTO_DIRECTORIO IS NULL THEN 'ENTREGADO_SIN_ADJUNTO'
>         ELSE 'NO_ENTREGADO'
>     END AS ENTREGADO,
>     LMS_TAB_ACTIVIDADES_ALUMNOS.ID_CURSO,
>     LMS_TAB_ACTIVIDADES_ALUMNOS.CEDULA_INTEGRANTE
> FROM
>     UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA LMS_TAB_ACTIVIDAD_ACADEMICA
>     INNER JOIN UTNDB.ACA_TAB_TIPOS_PORCENTAJE_EVAL ACA_TAB_TIPOS_PORCENTAJE_EVAL ON (
>         LMS_TAB_ACTIVIDAD_ACADEMICA.CODIGO_TIPO_EVAL = ACA_TAB_TIPOS_PORCENTAJE_EVAL.CODIGO
>     )
>     INNER JOIN UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS LMS_TAB_ACTIVIDADES_ALUMNOS ON (
>         LMS_TAB_ACTIVIDADES_ALUMNOS.ID_ACTIVIDAD = LMS_TAB_ACTIVIDAD_ACADEMICA.ID_ACTIVIDAD
>     )
> WHERE
>     LMS_TAB_ACTIVIDAD_ACADEMICA.ESTADO = 'A'
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> colapsadas las condiciones duplicadas del original (ESTADO='A' y CODIGO_PARCIAL=:x aparecian
> 	repetidas 2 veces cada una sin efecto). 10 col, 0 filas MINUS en los 2 sentidos (idCurso 54443,
> 	cedula <cedula>, codigoParcial N1, 134 filas reales). Codigo migrado, build limpio.
> 	**Incidente propio de la migracion:** al escribir el WHERE del .ts reordene las condiciones
> 	(ID_CURSO, CEDULA_INTEGRANTE, CODIGO_PARCIAL) sin notar que el repository.ts pasa el arreglo
> 	[codigoParcial, idCurso, cedula] - los binds de Oracle son posicionales por ORDEN DE APARICION
> 	en el texto, no por nombre (invariante de plataforma #2), asi que el primer valor del arreglo
> 	(un string 'N1') se ligo al primer placeholder del texto (ID_CURSO, NUMBER) -> ORA-01722.
> 	Corregido reordenando el WHERE a CODIGO_PARCIAL, ID_CURSO, CEDULA_INTEGRANTE (mismo orden que
> 	el texto original), sin tocar el repository. curl /aula-virtual/lista-actividades confirmado
> 	con datos reales tras el fix.;
> ```

> [!example]- `MVL_FUN_DETALLES_NOTAS_PARCIAL` (función)
> **Resultado:** comparación fila a fila: igual al original
>
> **Nota del registro:** (aula_virtual), F que consolida las 3 consultas casi
>
> **Lo usa:** `src/modules/aula_virtual/respository/consultas/detalles_notas_parcial_1_consulta.ts`, `src/modules/aula_virtual/respository/consultas/detalles_notas_parcial_2_consulta.ts`, `src/modules/aula_virtual/respository/consultas/detalles_notas_parcial_3_consulta.ts`
>
> **Antes** (`src/modules/aula_virtual/respository/consultas/detalles_notas_parcial_1_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> /**
>  * Detalle de notas del PRIMER parcial (N1).
>  *
>  * Reescrita para eliminar las subconsultas correlacionadas que hacían que el
>  * endpoint tardara ~10 s. La versión anterior calculaba, POR CADA FILA:
>  *   - 3 veces el SUM(CALIFICACION) del tipo de evaluación,
>  *   - 2 veces el COUNT(ID_ACTIVIDAD_ALUMNO) del mismo tipo,
>  *   - 2 lookups a ACA_TAB_PORCENTAJES_EVAL, cada uno con un
>  *     SELECT DISTINCT anidado sobre LMS_TAB_AULAS_VIRTUALES.
>  * Todas correlacionadas por ACA_TAB_TIPOS_PORCENTAJE_EVAL.CODIGO, así que
>  * Oracle no podía reutilizarlas entre filas: con N actividades salían ~5N
>  * recorridos del join de las dos tablas grandes.
>  *
>  * Ahora:
>  *   - SUMA y el conteo se calculan de UNA pasada con funciones analíticas
>  *     sobre el mismo conjunto de filas que ya devuelve la consulta.
>  *   - La resolución del aula (LMS_TAB_AULAS_VIRTUALES) se hace una sola vez
>  *     en el CTE AULA.
>  *
>  * La salida es idéntica: mismas columnas, mismo orden y mismos valores.
>  *
>  * ⚠️ Se conserva a propósito `SUM(CALIFICACION) / COUNT(ID_ACTIVIDAD_ALUMNO)`
>  * en vez de AVG(): AVG divide por los valores NO NULOS, mientras que el conteo
>  * original cuenta todas las filas. Con actividades sin calificar los resultados
>  * difieren, y esto son notas.
>  *
>  * ⚠️ El repositorio pasa los binds por POSICIÓN ([idCurso, cedula, codigoParcial])
>  * y el driver los asigna por ORDEN DE APARICIÓN de cada placeholder en el SQL.
>  * Por eso la consulta usa EXACTAMENTE 3 placeholders, uno por bind, en ese
>  * orden. Repetir uno corre a los siguientes y provoca ORA-01008 (pasó: una
>  * segunda aparición de :P212_ID_CURSO dejó :P212_CODIGO_PARCIAL sin valor).
>  * Por eso el CTE AULA se deriva de BASE en vez de volver a usar el bind.
>  */
> export const DETALLES_NOTAS_PARCIAL_1_CONSULTA = `
> WITH BASE AS (
>     SELECT
>         ACT.ID_ACTIVIDAD,
>         TPE.DESCRIPCION AS TIPO_ACTIVIDAD,
>         ACT.NOMBRE_CORTO,
>         ACT.DESCRIPCION,
>         ACT.ESTADO,
>         ALU.ADJUNTO_LAST_UPDATE AS FECHA_ENTREGA,
>         ALU.ID_ACTIVIDAD_ALUMNO,
>         ALU.CALIFICACION,
>         ACT.CODIGO_PARCIAL,
>         ALU.ENTREGADO,
>         ACT.FECHA_FIN,
>         TPE.CODIGO AS TIPO_EVAL_CODIGO,
>         ALU.ID_CURSO AS ID_CURSO_BASE
>     FROM UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA ACT
>         INNER JOIN UTNDB.ACA_TAB_TIPOS_PORCENTAJE_EVAL TPE
>             ON ACT.CODIGO_TIPO_EVAL = TPE.CODIGO
>         INNER JOIN UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS ALU
>             ON ALU.ID_ACTIVIDAD = ACT.ID_ACTIVIDAD
>     WHERE ALU.ID_CURSO = :P212_ID_CURSO
>       AND ALU.CEDULA_INTEGRANTE = :P212_CEDULA_INTEGRANTE
>       AND ACT.CODIGO_PARCIAL = :P212_CODIGO_PARCIAL
>       AND ACT.ESTADO = 'A'
> ),
> AULA AS (
>     SELECT DISTINCT
>         AV.CODIGO_MATERIA,
>         AV.CODIGO_INSTITUCION,
>         AV.CODIGO_MOD_EST,
>         AV.CODIGO_SIS_EST,
>         AV.CODIGO_TCICLO_ACAD,
>         AV.CODIGO_TIPO_FINANC,
>         AV.CODIGO_CICLO_ACAD,
>         AV.CODIGO_NIVEL
>     FROM UTNDB.LMS_TAB_AULAS_VIRTUALES AV
>     WHERE AV.ID_CURSO IN (SELECT ID_CURSO_BASE FROM BASE)
> ),
> AGREGADOS AS (
>     SELECT
>         BASE.*,
>         SUM(CALIFICACION) OVER (PARTITION BY TIPO_EVAL_CODIGO) AS SUMA,
>         COUNT(ID_ACTIVIDAD_ALUMNO) OVER (PARTITION BY TIPO_EVAL_CODIGO) AS NUM_ACTIVIDADES
>     FROM BASE
> )
> SELECT
>     AG.ID_ACTIVIDAD,
>     AG.TIPO_ACTIVIDAD,
>     AG.NOMBRE_CORTO,
>     AG.DESCRIPCION,
>     AG.ESTADO,
>     AG.FECHA_ENTREGA,
>     AG.ID_ACTIVIDAD_ALUMNO,
>     AG.CALIFICACION,
>     AG.CODIGO_PARCIAL,
>     AG.ENTREGADO,
>     AG.SUMA,
>     ROUND(AG.SUMA / AG.NUM_ACTIVIDADES, 3) AS PROMEDIO,
>     TRIM(TO_CHAR(
>         ROUND(
>             (AG.SUMA / AG.NUM_ACTIVIDADES) * (
>                 SELECT PE.PORCENTAJE_N1
>                 FROM ACA_TAB_PORCENTAJES_EVAL PE
>                 WHERE (
>                         PE.MATERIA_CODIGO,
>                         PE.MODA_ESTUD_CODIGO,
>                         PE.SIST_ESTUD_CODIGO,
>                         PE.CICLO_ACAD_CODIGO,
>                         PE.NIVEL_CODIGO
>                       ) = (
>                         SELECT
>                             A.CODIGO_MATERIA,
>                             A.CODIGO_MOD_EST,
>                             A.CODIGO_SIS_EST,
>                             A.CODIGO_CICLO_ACAD,
>                             A.CODIGO_NIVEL
>                         FROM AULA A
>                       )
>                   AND PE.TIPO_EVAL_CODIGO = AG.TIPO_EVAL_CODIGO
>             ),
>             3
>         ),
>         '999990,00'
>     )) || '/' || TRIM(TO_CHAR(
>         ROUND(
>             (
>                 SELECT 10 * PE.PORCENTAJE_N1
>                 FROM ACA_TAB_PORCENTAJES_EVAL PE
>                 WHERE (
>                         PE.MATERIA_CODIGO,
>                         PE.INST_CODIGO,
>                         PE.MODA_ESTUD_CODIGO,
>                         PE.SIST_ESTUD_CODIGO,
>                         PE.TCICLOACAD_CODIGO,
>                         PE.TFINANCIA_CODIGO,
>                         PE.CICLO_ACAD_CODIGO,
>                         PE.NIVEL_CODIGO
>                       ) = (
>                         SELECT
>                             A.CODIGO_MATERIA,
>                             A.CODIGO_INSTITUCION,
>                             A.CODIGO_MOD_EST,
>                             A.CODIGO_SIS_EST,
>                             A.CODIGO_TCICLO_ACAD,
>                             A.CODIGO_TIPO_FINANC,
>                             A.CODIGO_CICLO_ACAD,
>                             A.CODIGO_NIVEL
>                         FROM AULA A
>                       )
>                   AND PE.TIPO_EVAL_CODIGO = AG.TIPO_EVAL_CODIGO
>             ),
>             3
>         ),
>         '999990,00'
>     )) AS SUBTOTAL
> FROM AGREGADOS AG
> ORDER BY AG.FECHA_FIN DESC
> `;
> ```
>
> **Antes** (`src/modules/aula_virtual/respository/consultas/detalles_notas_parcial_2_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> /**
>  * Detalle de notas del parcial N2.
>  *
>  * Reescrita para eliminar las subconsultas correlacionadas que hacían que el
>  * endpoint tardara ~10 s. La versión anterior calculaba, POR CADA FILA:
>  *   - 3 veces el SUM(CALIFICACION) del tipo de evaluación,
>  *   - 2 veces el COUNT(ID_ACTIVIDAD_ALUMNO) del mismo tipo,
>  *   - 2 lookups a ACA_TAB_PORCENTAJES_EVAL, cada uno con un
>  *     SELECT DISTINCT anidado sobre LMS_TAB_AULAS_VIRTUALES.
>  * Todas correlacionadas por ACA_TAB_TIPOS_PORCENTAJE_EVAL.CODIGO, así que
>  * Oracle no podía reutilizarlas entre filas: con N actividades salían ~5N
>  * recorridos del join de las dos tablas grandes.
>  *
>  * Ahora:
>  *   - SUMA y el conteo se calculan de UNA pasada con funciones analíticas
>  *     sobre el mismo conjunto de filas que ya devuelve la consulta.
>  *   - La resolución del aula (LMS_TAB_AULAS_VIRTUALES) se hace una sola vez
>  *     en el CTE AULA.
>  *
>  * La salida es idéntica: mismas columnas, mismo orden y mismos valores.
>  *
>  * ⚠️ Se conserva a propósito `SUM(CALIFICACION) / COUNT(ID_ACTIVIDAD_ALUMNO)`
>  * en vez de AVG(): AVG divide por los valores NO NULOS, mientras que el conteo
>  * original cuenta todas las filas. Con actividades sin calificar los resultados
>  * difieren, y esto son notas.
>  *
>  * ⚠️ El repositorio pasa los binds por POSICIÓN ([idCurso, cedula, codigoParcial])
>  * y el driver los asigna por ORDEN DE APARICIÓN de cada placeholder en el SQL.
>  * Por eso la consulta usa EXACTAMENTE 3 placeholders, uno por bind, en ese
>  * orden. Repetir uno corre a los siguientes y provoca ORA-01008 (pasó: una
>  * segunda aparición de :P212_ID_CURSO dejó :P212_CODIGO_PARCIAL sin valor).
>  * Por eso el CTE AULA se deriva de BASE en vez de volver a usar el bind.
>  */
> export const DETALLES_NOTAS_PARCIAL_2_CONSULTA = `
> WITH BASE AS (
>     SELECT
>         ACT.ID_ACTIVIDAD,
>         TPE.DESCRIPCION AS TIPO_ACTIVIDAD,
>         ACT.NOMBRE_CORTO,
>         ACT.DESCRIPCION,
>         ACT.ESTADO,
>         ALU.ADJUNTO_LAST_UPDATE AS FECHA_ENTREGA,
>         ALU.ID_ACTIVIDAD_ALUMNO,
>         ALU.CALIFICACION,
>         ACT.CODIGO_PARCIAL,
>         ALU.ENTREGADO,
>         ACT.FECHA_FIN,
>         TPE.CODIGO AS TIPO_EVAL_CODIGO,
>         ALU.ID_CURSO AS ID_CURSO_BASE
>     FROM UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA ACT
>         INNER JOIN UTNDB.ACA_TAB_TIPOS_PORCENTAJE_EVAL TPE
>             ON ACT.CODIGO_TIPO_EVAL = TPE.CODIGO
>         INNER JOIN UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS ALU
>             ON ALU.ID_ACTIVIDAD = ACT.ID_ACTIVIDAD
>     WHERE ALU.ID_CURSO = :P212_ID_CURSO
>       AND ALU.CEDULA_INTEGRANTE = :P212_CEDULA_INTEGRANTE
>       AND ACT.CODIGO_PARCIAL = :P212_CODIGO_PARCIAL
>       AND ACT.ESTADO = 'A'
> ),
> AULA AS (
>     SELECT DISTINCT
>         AV.CODIGO_MATERIA,
>         AV.CODIGO_INSTITUCION,
>         AV.CODIGO_MOD_EST,
>         AV.CODIGO_SIS_EST,
>         AV.CODIGO_TCICLO_ACAD,
>         AV.CODIGO_TIPO_FINANC,
>         AV.CODIGO_CICLO_ACAD,
>         AV.CODIGO_NIVEL
>     FROM UTNDB.LMS_TAB_AULAS_VIRTUALES AV
>     WHERE AV.ID_CURSO IN (SELECT ID_CURSO_BASE FROM BASE)
> ),
> AGREGADOS AS (
>     SELECT
>         BASE.*,
>         SUM(CALIFICACION) OVER (PARTITION BY TIPO_EVAL_CODIGO) AS SUMA,
>         COUNT(ID_ACTIVIDAD_ALUMNO) OVER (PARTITION BY TIPO_EVAL_CODIGO) AS NUM_ACTIVIDADES
>     FROM BASE
> )
> SELECT
>     AG.ID_ACTIVIDAD,
>     AG.TIPO_ACTIVIDAD,
>     AG.NOMBRE_CORTO,
>     AG.DESCRIPCION,
>     AG.ESTADO,
>     AG.FECHA_ENTREGA,
>     AG.ID_ACTIVIDAD_ALUMNO,
>     AG.CALIFICACION,
>     AG.CODIGO_PARCIAL,
>     AG.ENTREGADO,
>     AG.SUMA,
>     ROUND(AG.SUMA / AG.NUM_ACTIVIDADES, 3) AS PROMEDIO,
>     TRIM(TO_CHAR(
>         ROUND(
>             (AG.SUMA / AG.NUM_ACTIVIDADES) * (
>                 SELECT PE.PORCENTAJE_N2
>                 FROM ACA_TAB_PORCENTAJES_EVAL PE
>                 WHERE (
>                         PE.MATERIA_CODIGO,
>                         PE.MODA_ESTUD_CODIGO,
>                         PE.SIST_ESTUD_CODIGO,
>                         PE.CICLO_ACAD_CODIGO,
>                         PE.NIVEL_CODIGO
>                       ) = (
>                         SELECT
>                             A.CODIGO_MATERIA,
>                             A.CODIGO_MOD_EST,
>                             A.CODIGO_SIS_EST,
>                             A.CODIGO_CICLO_ACAD,
>                             A.CODIGO_NIVEL
>                         FROM AULA A
>                       )
>                   AND PE.TIPO_EVAL_CODIGO = AG.TIPO_EVAL_CODIGO
>             ),
>             3
>         ),
>         '999990,00'
>     )) || '/' || TRIM(TO_CHAR(
>         ROUND(
>             (
>                 SELECT 10 * PE.PORCENTAJE_N2
>                 FROM ACA_TAB_PORCENTAJES_EVAL PE
>                 WHERE (
>                         PE.MATERIA_CODIGO,
>                         PE.INST_CODIGO,
>                         PE.MODA_ESTUD_CODIGO,
>                         PE.SIST_ESTUD_CODIGO,
>                         PE.TCICLOACAD_CODIGO,
>                         PE.TFINANCIA_CODIGO,
>                         PE.CICLO_ACAD_CODIGO,
>                         PE.NIVEL_CODIGO
>                       ) = (
>                         SELECT
>                             A.CODIGO_MATERIA,
>                             A.CODIGO_INSTITUCION,
>                             A.CODIGO_MOD_EST,
>                             A.CODIGO_SIS_EST,
>                             A.CODIGO_TCICLO_ACAD,
>                             A.CODIGO_TIPO_FINANC,
>                             A.CODIGO_CICLO_ACAD,
>                             A.CODIGO_NIVEL
>                         FROM AULA A
>                       )
>                   AND PE.TIPO_EVAL_CODIGO = AG.TIPO_EVAL_CODIGO
>             ),
>             3
>         ),
>         '999990,00'
>     )) AS SUBTOTAL
> FROM AGREGADOS AG
> ORDER BY AG.FECHA_FIN DESC
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_FUN_DETALLES_NOTAS_PARCIAL
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=INVALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_FUN_DETALLES_NOTAS_PARCIAL')
> -- Usado por: src/modules/aula_virtual
>
> CREATE OR REPLACE FUNCTION MOVIL_UTN.MVL_FUN_DETALLES_NOTAS_PARCIAL (
>     p_id_curso          IN UTNDB.LMS_TAB_AULAS_VIRTUALES.ID_CURSO%TYPE,
>     p_cedula_integrante IN UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS.CEDULA_INTEGRANTE%TYPE,
>     p_codigo_parcial    IN UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA.CODIGO_PARCIAL%TYPE
> ) RETURN SYS_REFCURSOR
> AS
>     v_cursor SYS_REFCURSOR;
> BEGIN
>     OPEN v_cursor FOR
>         WITH BASE AS (
>             SELECT
>                 ACT.ID_ACTIVIDAD,
>                 TPE.DESCRIPCION AS TIPO_ACTIVIDAD,
>                 ACT.NOMBRE_CORTO,
>                 ACT.DESCRIPCION,
>                 ACT.ESTADO,
>                 ALU.ADJUNTO_LAST_UPDATE AS FECHA_ENTREGA,
>                 ALU.ID_ACTIVIDAD_ALUMNO,
>                 ALU.CALIFICACION,
>                 ACT.CODIGO_PARCIAL,
>                 ALU.ENTREGADO,
>                 ACT.FECHA_FIN,
>                 TPE.CODIGO AS TIPO_EVAL_CODIGO,
>                 ALU.ID_CURSO AS ID_CURSO_BASE
>             FROM UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA ACT
>                 INNER JOIN UTNDB.ACA_TAB_TIPOS_PORCENTAJE_EVAL TPE
>                     ON ACT.CODIGO_TIPO_EVAL = TPE.CODIGO
>                 INNER JOIN UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS ALU
>                     ON ALU.ID_ACTIVIDAD = ACT.ID_ACTIVIDAD
>             WHERE ALU.ID_CURSO = p_id_curso
>               AND ALU.CEDULA_INTEGRANTE = p_cedula_integrante
>               AND ACT.CODIGO_PARCIAL = p_codigo_parcial
>               AND ACT.ESTADO = 'A'
>         ),
>         AULA AS (
>             SELECT DISTINCT
>                 AV.CODIGO_MATERIA,
>                 AV.CODIGO_INSTITUCION,
>                 AV.CODIGO_MOD_EST,
>                 AV.CODIGO_SIS_EST,
>                 AV.CODIGO_TCICLO_ACAD,
>                 AV.CODIGO_TIPO_FINANC,
>                 AV.CODIGO_CICLO_ACAD,
>                 AV.CODIGO_NIVEL
>             FROM UTNDB.LMS_TAB_AULAS_VIRTUALES AV
>             WHERE AV.ID_CURSO IN (SELECT ID_CURSO_BASE FROM BASE)
>         ),
>         AGREGADOS AS (
>             SELECT
>                 BASE.*,
>                 SUM(CALIFICACION) OVER (PARTITION BY TIPO_EVAL_CODIGO) AS SUMA,
>                 COUNT(ID_ACTIVIDAD_ALUMNO) OVER (PARTITION BY TIPO_EVAL_CODIGO) AS NUM_ACTIVIDADES
>             FROM BASE
>         )
>         SELECT
>             AG.ID_ACTIVIDAD,
>             AG.TIPO_ACTIVIDAD,
>             AG.NOMBRE_CORTO,
>             AG.DESCRIPCION,
>             AG.ESTADO,
>             AG.FECHA_ENTREGA,
>             AG.ID_ACTIVIDAD_ALUMNO,
>             AG.CALIFICACION,
>             AG.CODIGO_PARCIAL,
>             AG.ENTREGADO,
>             AG.SUMA,
>             ROUND(AG.SUMA / AG.NUM_ACTIVIDADES, 3) AS PROMEDIO,
>             TRIM(TO_CHAR(
>                 ROUND(
>                     (AG.SUMA / AG.NUM_ACTIVIDADES) * (
>                         SELECT DECODE(p_codigo_parcial, 'N1', PE.PORCENTAJE_N1, 'N2', PE.PORCENTAJE_N2, 'N3', PE.PORCENTAJE_N3)
>                         FROM ACA_TAB_PORCENTAJES_EVAL PE
>                         WHERE (
>                                 PE.MATERIA_CODIGO,
>                                 PE.MODA_ESTUD_CODIGO,
>                                 PE.SIST_ESTUD_CODIGO,
>                                 PE.CICLO_ACAD_CODIGO,
>                                 PE.NIVEL_CODIGO
>                               ) = (
>                                 SELECT A.CODIGO_MATERIA, A.CODIGO_MOD_EST, A.CODIGO_SIS_EST, A.CODIGO_CICLO_ACAD, A.CODIGO_NIVEL
>                                 FROM AULA A
>                               )
>                           AND PE.TIPO_EVAL_CODIGO = AG.TIPO_EVAL_CODIGO
>                     ),
>                     3
>                 ),
>                 '999990,00'
>             )) || '/' || TRIM(TO_CHAR(
>                 ROUND(
>                     (
>                         SELECT 10 * DECODE(p_codigo_parcial, 'N1', PE.PORCENTAJE_N1, 'N2', PE.PORCENTAJE_N2, 'N3', PE.PORCENTAJE_N3)
>                         FROM ACA_TAB_PORCENTAJES_EVAL PE
>                         WHERE (
>                                 PE.MATERIA_CODIGO,
>                                 PE.INST_CODIGO,
>                                 PE.MODA_ESTUD_CODIGO,
>                                 PE.SIST_ESTUD_CODIGO,
>                                 PE.TCICLOACAD_CODIGO,
>                                 PE.TFINANCIA_CODIGO,
>                                 PE.CICLO_ACAD_CODIGO,
>                                 PE.NIVEL_CODIGO
>                               ) = (
>                                 SELECT A.CODIGO_MATERIA, A.CODIGO_INSTITUCION, A.CODIGO_MOD_EST, A.CODIGO_SIS_EST,
>                                        A.CODIGO_TCICLO_ACAD, A.CODIGO_TIPO_FINANC, A.CODIGO_CICLO_ACAD, A.CODIGO_NIVEL
>                                 FROM AULA A
>                               )
>                           AND PE.TIPO_EVAL_CODIGO = AG.TIPO_EVAL_CODIGO
>                     ),
>                     3
>                 ),
>                 '999990,00'
>             )) AS SUBTOTAL
>         FROM AGREGADOS AG
>         ORDER BY AG.FECHA_FIN DESC;
>     RETURN v_cursor;
> END MVL_FUN_DETALLES_NOTAS_PARCIAL;
> /
> ```

> [!example]- `MVL_VIEW_DISTRIBUCION_MATERIA` (vista)
> **Resultado:** MINUS en los dos sentidos: 0 diferencias
>
> **Nota del registro:** (aula_virtual), V2 - 10 filtros simples (sin binds
>
> **Lo usa:** `src/modules/aula_virtual/respository/consultas/distribucion_materia_consulta.ts`
>
> **Antes** (`src/modules/aula_virtual/respository/consultas/distribucion_materia_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const DISTRIBUCION_MATERIA_CONSULTA = `
> SELECT DISTINCT CONTENIDO AS TEMA, PORCENTAJE_ITEM
>   FROM (SELECT DISTINCT
>                   TAB_TIPOS_CONTENIDOS.DESCRIPCION
>                || ' '
>                || TAB_CONTENIDOS_MATERIAS.ITEM
>                || '. '
>                || TAB_CONTENIDOS_MATERIAS.DESCRIPCION
>                   AS CONTENIDO,
>                DECODE (
>                   TAB_CONTENIDOS_MATERIAS.CONTE_MATE_CODIGO,
>                   NULL, TAB_CONTENIDOS_MATERIAS.MATERIA_CODIGO,
>                   TAB_CONTENIDOS_MATERIAS.CONTE_MATE_CODIGO, TAB_CONTENIDOS_MATERIAS.CONTE_MATE_CODIGO)
>                   AS CONTE_MATE_CODIGO,
>                TAB_CONTENIDOS_MATERIAS.PORCENTAJE_ITEM
>           FROM    UTNDB.ACA_TAB_CONTENIDOS_MATERIAS TAB_CONTENIDOS_MATERIAS
>                INNER JOIN
>                   UTNDB.ACA_TAB_TIPOS_CONTENIDOS TAB_TIPOS_CONTENIDOS
>                ON (TAB_CONTENIDOS_MATERIAS.TCONTENIDO_CODIGO =
>                       TAB_TIPOS_CONTENIDOS.CODIGO)
>          WHERE     TAB_CONTENIDOS_MATERIAS.INST_CODIGO = :P9_INST_CODIGO
>                AND TAB_CONTENIDOS_MATERIAS.DEPEN_CODIGO = :P9_DEPEN_CODIGO
>                AND NIVEL_CODIGO = :P9_NIVEL_CODIGO
>                AND TAB_CONTENIDOS_MATERIAS.MATERIA_CODIGO =
>                       :P9_MATERIA_CODIGO
>                AND TAB_CONTENIDOS_MATERIAS.CICLO_ACAD_CODIGO =
>                       :P9_CICLO_ACAD_CODIGO
>                AND TAB_CONTENIDOS_MATERIAS.MODA_ESTUD_CODIGO =
>                       :P9_MODA_ESTUD_CODIGO
>                AND TAB_CONTENIDOS_MATERIAS.SIST_ESTUD_CODIGO =
>                       :P9_SIST_ESTUD_CODIGO
>                AND TAB_CONTENIDOS_MATERIAS.TCICLOACAD_CODIGO =
>                       :P9_TCICLOACAD_CODIGO
>                AND TAB_CONTENIDOS_MATERIAS.TFINANCIA_CODIGO =
>                       :P9_TFINANCIA_CODIGO)
>  WHERE CONTE_MATE_CODIGO = :P9_CODIGO_CONTENIDO
>  ORDER BY TEMA
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_VIEW_DISTRIBUCION_MATERIA
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_VIEWS.TEXT_VC + ALL_TAB_COLUMNS
> -- Usado por: src/modules/aula_virtual
>
> CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_DISTRIBUCION_MATERIA ("TEMA", "PORCENTAJE_ITEM", "CONTE_MATE_CODIGO", "INST_CODIGO", "DEPEN_CODIGO", "NIVEL_CODIGO", "MATERIA_CODIGO", "CICLO_ACAD_CODIGO", "MODA_ESTUD_CODIGO", "SIST_ESTUD_CODIGO", "TCICLOACAD_CODIGO", "TFINANCIA_CODIGO") AS
> SELECT DISTINCT
>     TAB_TIPOS_CONTENIDOS.DESCRIPCION
>     || ' '
>     || TAB_CONTENIDOS_MATERIAS.ITEM
>     || '. '
>     || TAB_CONTENIDOS_MATERIAS.DESCRIPCION AS TEMA,
>     TAB_CONTENIDOS_MATERIAS.PORCENTAJE_ITEM,
>     DECODE(
>         TAB_CONTENIDOS_MATERIAS.CONTE_MATE_CODIGO,
>         NULL, TAB_CONTENIDOS_MATERIAS.MATERIA_CODIGO,
>         TAB_CONTENIDOS_MATERIAS.CONTE_MATE_CODIGO, TAB_CONTENIDOS_MATERIAS.CONTE_MATE_CODIGO
>     ) AS CONTE_MATE_CODIGO,
>     TAB_CONTENIDOS_MATERIAS.INST_CODIGO,
>     TAB_CONTENIDOS_MATERIAS.DEPEN_CODIGO,
>     TAB_CONTENIDOS_MATERIAS.NIVEL_CODIGO,
>     TAB_CONTENIDOS_MATERIAS.MATERIA_CODIGO,
>     TAB_CONTENIDOS_MATERIAS.CICLO_ACAD_CODIGO,
>     TAB_CONTENIDOS_MATERIAS.MODA_ESTUD_CODIGO,
>     TAB_CONTENIDOS_MATERIAS.SIST_ESTUD_CODIGO,
>     TAB_CONTENIDOS_MATERIAS.TCICLOACAD_CODIGO,
>     TAB_CONTENIDOS_MATERIAS.TFINANCIA_CODIGO
> FROM
>     UTNDB.ACA_TAB_CONTENIDOS_MATERIAS TAB_CONTENIDOS_MATERIAS
>     INNER JOIN UTNDB.ACA_TAB_TIPOS_CONTENIDOS TAB_TIPOS_CONTENIDOS ON (
>         TAB_CONTENIDOS_MATERIAS.TCONTENIDO_CODIGO = TAB_TIPOS_CONTENIDOS.CODIGO
>     )
> ;
> ```
>
> **Prueba usada:**
>
> ```sql
> Q38 ✅: MVL_VIEW_DISTRIBUCION_MATERIA (aula_virtual), V2 - 10 filtros simples (sin binds
> 	repetidos), expone CONTE_MATE_CODIGO (ya calculado con el DECODE original) + las 9 columnas
> 	de filtro para mover todo afuera. 3 col, 0 filas MINUS en los 2 sentidos (materia CIDES-POO,
> 	curso 90198, contenido raiz = materiaCodigo). Codigo migrado (distribucion_materia_consulta.ts,
> 	sin cambios en repository - no es funcion), build limpio, curl /aula-virtual/distribucion-materia
> 	devuelve las 4 unidades reales (25% cada una), identico a lo validado.;
> ```

> [!example]- `MVL_FUN_CONTENIDO_MATERIA` (función)
> **Resultado:** comparación fila a fila: igual al original
>
> **Nota del registro:** (aula_virtual), F por CONNECT BY jerarquico sobre
>
> **Lo usa:** `src/modules/aula_virtual/respository/consultas/contenido_materia_consulta.ts`
>
> **Antes** (`src/modules/aula_virtual/respository/consultas/contenido_materia_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const CONTENIDO_MATERIA_CONSULTA = `
> SELECT
>     LEVEL,
>     CONTENIDO AS title,
>     "CODIGO" AS VALUE
> FROM
>     (
>         SELECT
>             DISTINCT TAB_TIPOS_CONTENIDOS.DESCRIPCION || ' ' || TAB_CONTENIDOS_MATERIAS.ITEM || '. ' || TAB_CONTENIDOS_MATERIAS.DESCRIPCION AS CONTENIDO,
>             TAB_CONTENIDOS_MATERIAS.CODIGO,
>             DECODE (
>                 TAB_CONTENIDOS_MATERIAS.CONTE_MATE_CODIGO,
>                 NULL,
>                 TAB_CONTENIDOS_MATERIAS.MATERIA_CODIGO,
>                 TAB_CONTENIDOS_MATERIAS.CONTE_MATE_CODIGO,
>                 TAB_CONTENIDOS_MATERIAS.CONTE_MATE_CODIGO
>             ) AS CONTE_MATE_CODIGO
>         FROM
>             ACA_TAB_CONTENIDOS_MATERIAS TAB_CONTENIDOS_MATERIAS
>             INNER JOIN ACA_TAB_TIPOS_CONTENIDOS TAB_TIPOS_CONTENIDOS ON (
>                 TAB_CONTENIDOS_MATERIAS.TCONTENIDO_CODIGO = TAB_TIPOS_CONTENIDOS.CODIGO
>             )
>         WHERE
>             TAB_CONTENIDOS_MATERIAS.INST_CODIGO = :P9_INST_CODIGO
>             AND TAB_CONTENIDOS_MATERIAS.DEPEN_CODIGO = :P9_DEPEN_CODIGO
>             AND TAB_CONTENIDOS_MATERIAS.NIVEL_CODIGO = :P9_NIVEL_CODIGO
>             AND TAB_CONTENIDOS_MATERIAS.MATERIA_CODIGO = :P9_MATERIA_CODIGO
>             AND TAB_CONTENIDOS_MATERIAS.CICLO_ACAD_CODIGO = :P9_CICLO_ACAD_CODIGO
>             AND TAB_CONTENIDOS_MATERIAS.MODA_ESTUD_CODIGO = :P9_MODA_ESTUD_CODIGO
>             AND TAB_CONTENIDOS_MATERIAS.SIST_ESTUD_CODIGO = :P9_SIST_ESTUD_CODIGO
>             AND TAB_CONTENIDOS_MATERIAS.TCICLOACAD_CODIGO = :P9_TCICLOACAD_CODIGO
>             AND TAB_CONTENIDOS_MATERIAS.TFINANCIA_CODIGO = :P9_TFINANCIA_CODIGO
>         UNION
>         SELECT
>             DISTINCT 'MATERIA: ' || TAB_MATERIAS.DESCRIPCION AS CONTENIDO,
>             TAB_MATERIAS.CODIGO,
>             '-' AS CONTE_MATE_CODIGO
>         FROM
>             ACA_TAB_MATERIAS TAB_MATERIAS
>         WHERE
>             TAB_MATERIAS.NIVEL_CODIGO = :P9_NIVEL_CODIGO
>             AND TAB_MATERIAS.CODIGO = :P9_MATERIA_CODIGO
>     ) START WITH "CONTE_MATE_CODIGO" = '-' CONNECT BY PRIOR "CODIGO" = "CONTE_MATE_CODIGO" ORDER SIBLINGS BY "CONTENIDO"
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_FUN_CONTENIDO_MATERIA
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_FUN_CONTENIDO_MATERIA')
> -- Usado por: src/modules/aula_virtual
>
> CREATE OR REPLACE FUNCTION MOVIL_UTN.MVL_FUN_CONTENIDO_MATERIA (
>     p_inst_codigo IN VARCHAR2,
>     p_depen_codigo IN VARCHAR2,
>     p_nivel_codigo IN VARCHAR2,
>     p_materia_codigo IN VARCHAR2,
>     p_ciclo_acad_codigo IN VARCHAR2,
>     p_moda_estud_codigo IN VARCHAR2,
>     p_sist_estud_codigo IN VARCHAR2,
>     p_tciclo_acad_codigo IN VARCHAR2,
>     p_tfinancia_codigo IN VARCHAR2
> ) RETURN SYS_REFCURSOR
> AS
>     v_cursor SYS_REFCURSOR;
> BEGIN
>     OPEN v_cursor FOR
>         SELECT
>             LEVEL,
>             CONTENIDO AS TITLE,
>             "CODIGO" AS VALUE
>         FROM
>             (
>                 SELECT
>                     DISTINCT TAB_TIPOS_CONTENIDOS.DESCRIPCION || ' ' || TAB_CONTENIDOS_MATERIAS.ITEM || '. ' || TAB_CONTENIDOS_MATERIAS.DESCRIPCION AS CONTENIDO,
>                     TAB_CONTENIDOS_MATERIAS.CODIGO,
>                     DECODE (
>                         TAB_CONTENIDOS_MATERIAS.CONTE_MATE_CODIGO,
>                         NULL,
>                         TAB_CONTENIDOS_MATERIAS.MATERIA_CODIGO,
>                         TAB_CONTENIDOS_MATERIAS.CONTE_MATE_CODIGO,
>                         TAB_CONTENIDOS_MATERIAS.CONTE_MATE_CODIGO
>                     ) AS CONTE_MATE_CODIGO
>                 FROM
>                     UTNDB.ACA_TAB_CONTENIDOS_MATERIAS TAB_CONTENIDOS_MATERIAS
>                     INNER JOIN UTNDB.ACA_TAB_TIPOS_CONTENIDOS TAB_TIPOS_CONTENIDOS ON (
>                         TAB_CONTENIDOS_MATERIAS.TCONTENIDO_CODIGO = TAB_TIPOS_CONTENIDOS.CODIGO
>                     )
>                 WHERE
>                     TAB_CONTENIDOS_MATERIAS.INST_CODIGO = p_inst_codigo
>                     AND TAB_CONTENIDOS_MATERIAS.DEPEN_CODIGO = p_depen_codigo
>                     AND TAB_CONTENIDOS_MATERIAS.NIVEL_CODIGO = p_nivel_codigo
>                     AND TAB_CONTENIDOS_MATERIAS.MATERIA_CODIGO = p_materia_codigo
>                     AND TAB_CONTENIDOS_MATERIAS.CICLO_ACAD_CODIGO = p_ciclo_acad_codigo
>                     AND TAB_CONTENIDOS_MATERIAS.MODA_ESTUD_CODIGO = p_moda_estud_codigo
>                     AND TAB_CONTENIDOS_MATERIAS.SIST_ESTUD_CODIGO = p_sist_estud_codigo
>                     AND TAB_CONTENIDOS_MATERIAS.TCICLOACAD_CODIGO = p_tciclo_acad_codigo
>                     AND TAB_CONTENIDOS_MATERIAS.TFINANCIA_CODIGO = p_tfinancia_codigo
>                 UNION
>                 SELECT
>                     DISTINCT 'MATERIA: ' || TAB_MATERIAS.DESCRIPCION AS CONTENIDO,
>                     TAB_MATERIAS.CODIGO,
>                     '-' AS CONTE_MATE_CODIGO
>                 FROM
>                     UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS
>                 WHERE
>                     TAB_MATERIAS.NIVEL_CODIGO = p_nivel_codigo
>                     AND TAB_MATERIAS.CODIGO = p_materia_codigo
>             ) START WITH "CONTE_MATE_CODIGO" = '-' CONNECT BY PRIOR "CODIGO" = "CONTE_MATE_CODIGO" ORDER SIBLINGS BY "CONTENIDO";
>     RETURN v_cursor;
> END MVL_FUN_CONTENIDO_MATERIA;
> /
> ```

> [!example]- `MVL_PRC_FORO_ACTUALIZAR` (procedimiento)
> **Resultado:** de punta a punta: curl real y tabla revisada en Oracle antes y después
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/actualizar_foro.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/actualizar_foro.query.ts`, versión previa al commit `18138f6`):
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
> **Resultado:** de punta a punta: curl real y tabla revisada en Oracle antes y después
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/crear_respuesta_actividad.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/crear_respuesta_actividad.query.ts`, versión previa al commit `18138f6`):
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
> **Resultado:** de punta a punta: curl real y tabla revisada en Oracle antes y después
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/crear_respuesta_general.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/crear_respuesta_general.query.ts`, versión previa al commit `18138f6`):
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
> **Resultado:** de punta a punta: curl real y tabla revisada en Oracle antes y después
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/eliminar_foro.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/eliminar_foro.query.ts`, versión previa al commit `18138f6`):
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

> [!example]- `MVL_PRC_FORO_MARCAR_ACTIVIDAD_ENTREGADA` (procedimiento)
> **Resultado:** de punta a punta: curl real y tabla revisada en Oracle antes y después
>
> **Lo usa:** `src/modules/foro_online/repository/consultas/marcar_actividad_entregada.query.ts`
>
> **Antes** (`src/modules/foro_online/repository/consultas/marcar_actividad_entregada.query.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const MARCAR_ACTIVIDAD_ENTREGADA_QUERY = `
>     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS 
>     SET ENTREGADO = 'SI' 
>     WHERE ID_ACTIVIDAD = :idActividad 
>       AND ID_CURSO = (SELECT ID_CURSO FROM UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA WHERE ID_ACTIVIDAD = :idActividad) 
>       AND CEDULA_INTEGRANTE = :cedula
>       AND (ENTREGADO IS NULL OR ENTREGADO = 'NO' OR ENTREGADO = 'S')
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_PRC_FORO_MARCAR_ACTIVIDAD_ENTREGADA
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=INVALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_PRC_FORO_MARCAR_ACTIVIDAD_ENTREGADA')
> -- Usado por: src/modules/foro_online
>
> CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_FORO_MARCAR_ACTIVIDAD_ENTREGADA (
>     p_id_actividad IN NUMBER,
>     p_cedula IN VARCHAR2
> ) AS
> BEGIN
>     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     SET ENTREGADO = 'SI'
>     WHERE ID_ACTIVIDAD = p_id_actividad
>       AND ID_CURSO = (SELECT ID_CURSO FROM UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA WHERE ID_ACTIVIDAD = p_id_actividad)
>       AND CEDULA_INTEGRANTE = p_cedula
>       AND (ENTREGADO IS NULL OR ENTREGADO = 'NO' OR ENTREGADO = 'S');
> END MVL_PRC_FORO_MARCAR_ACTIVIDAD_ENTREGADA;
> /
> ```

> [!example]- `MVL_PRC_ACTIVIDADES_ENTREGAR_REUTILIZAR_ADJUNTO` (procedimiento)
> **Resultado:** de punta a punta: curl real y tabla revisada en Oracle antes y después
>
> **Lo usa:** `src/modules/actividades/respository/consultas/entregar_actividad_reutilizar_adjunto_insert.ts`
>
> **Antes** (`src/modules/actividades/respository/consultas/entregar_actividad_reutilizar_adjunto_insert.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const ENTREGAR_ACTIVIDAD_REUTILIZAR_ADJUNTO_INSERT = `
> UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
> SET DESCRIPCION = :pDescripcion, URL = :pUrl
> WHERE ID_ACTIVIDAD_ALUMNO = :pIdActividadAlumno
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_PRC_ACTIVIDADES_ENTREGAR_REUTILIZAR_ADJUNTO
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_PRC_ACTIVIDADES_ENTREGAR_REUTILIZAR_ADJUNTO')
> -- Usado por: src/modules/actividades
>
> CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_ACTIVIDADES_ENTREGAR_REUTILIZAR_ADJUNTO (
>     p_descripcion IN VARCHAR2,
>     p_url IN VARCHAR2,
>     p_id_actividad_alumno IN NUMBER
> ) AS
> BEGIN
>     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     SET DESCRIPCION = p_descripcion, URL = p_url
>     WHERE ID_ACTIVIDAD_ALUMNO = p_id_actividad_alumno;
> END MVL_PRC_ACTIVIDADES_ENTREGAR_REUTILIZAR_ADJUNTO;
> /
> ```

> [!example]- `MVL_PRC_COM_GUARDAR_RESPUESTA_ENCUESTA` (procedimiento)
> **Resultado:** de punta a punta: curl real y tabla revisada en Oracle antes y después
>
> **Lo usa:** `src/modules/comunicados/repository/consultas/guardar_respuesta_encuesta_consulta.ts`
>
> **Antes** (`src/modules/comunicados/repository/consultas/guardar_respuesta_encuesta_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> /**
>  * Elimina las respuestas existentes de una pregunta para una visualizacion
>  * Esto permite re-responder y manejar CHECK_LIST/CHIPS con múltiples valores
>  * NOTA: Esta consulta se ejecuta dentro de una transacción manejada por TypeORM
>  * por lo que NO debe incluir COMMIT/ROLLBACK explícito
>  */
> export const ELIMINAR_RESPUESTAS_PREGUNTA_CONSULTA = `
> DELETE FROM MOVIL_UTN.MVL_TAB_ENC_RESPUESTAS
> WHERE ID_PREGUNTA = :idPregunta
> AND ID_VISUALIZACION = :idVisualizacion
> `;
>
> /**
>  * Inserta una nueva respuesta para una pregunta
>  * Para CHECK_LIST y CHIPS se llama múltiples veces (una por cada opción seleccionada)
>  * Para los demás tipos se llama una sola vez
>  * NOTA: Esta consulta se ejecuta dentro de una transacción manejada por TypeORM
>  * por lo que NO debe incluir COMMIT/ROLLBACK explícito
>  */
> export const INSERTAR_RESPUESTA_ENCUESTA_CONSULTA = `
> INSERT INTO MOVIL_UTN.MVL_TAB_ENC_RESPUESTAS (
>   ID_PREGUNTA,
>   ID_VISUALIZACION,
>   VALOR_RESPUESTA,
>   FECHA_RESPUESTA
> ) VALUES (
>   :idPregunta,
>   :idVisualizacion,
>   :valorRespuesta,
>   SYSDATE
> )
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_PRC_COM_GUARDAR_RESPUESTA_ENCUESTA
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_PRC_COM_GUARDAR_RESPUESTA_ENCUESTA')
> -- Usado por: src/modules/comunicados
>
> CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_COM_GUARDAR_RESPUESTA_ENCUESTA (
>     p_id_pregunta IN NUMBER,
>     p_id_visualizacion IN NUMBER,
>     p_valor_respuesta IN VARCHAR2
> ) AS
> BEGIN
>     DELETE FROM MOVIL_UTN.MVL_TAB_ENC_RESPUESTAS
>     WHERE ID_PREGUNTA = p_id_pregunta
>     AND ID_VISUALIZACION = p_id_visualizacion;
>
>     INSERT INTO MOVIL_UTN.MVL_TAB_ENC_RESPUESTAS (
>         ID_PREGUNTA,
>         ID_VISUALIZACION,
>         VALOR_RESPUESTA,
>         FECHA_RESPUESTA
>     ) VALUES (
>         p_id_pregunta,
>         p_id_visualizacion,
>         p_valor_respuesta,
>         SYSDATE
>     );
> END MVL_PRC_COM_GUARDAR_RESPUESTA_ENCUESTA;
> /
> ```

> [!example]- `MVL_PRC_COM_REGISTRAR_VISUALIZACION` (procedimiento)
> **Resultado:** de punta a punta: curl real y tabla revisada en Oracle antes y después
>
> **Lo usa:** `src/modules/comunicados/repository/consultas/registrar_visualizacion_consulta.ts`
>
> **Antes** (`src/modules/comunicados/repository/consultas/registrar_visualizacion_consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const REGISTRAR_VISUALIZACION_CONSULTA = `
> DECLARE
>     v_num_visualizacion NUMBER;
>     v_max_visualizaciones NUMBER;
>     v_existe NUMBER;
>     v_nombre_completo VARCHAR2(300);
>     v_genero VARCHAR2(20);
>     v_facultad VARCHAR2(200);
>     v_carrera VARCHAR2(200);
> BEGIN
>     -- Obtener configuración del comunicado
>     SELECT MAX_VISUALIZACIONES
>     INTO v_max_visualizaciones
>     FROM MOVIL_UTN.MVL_TAB_COMUNICADOS
>     WHERE ID_COMUNICADO = :idComunicado
>     AND ESTADO = 'A';
>     
>     -- Obtener nombre completo de la persona 
>     BEGIN
>         SELECT TRIM(
>             PRIMER_NOMBRE || ' ' || 
>             NVL(SEGUNDO_NOMBRE, '') || ' ' || 
>             PRIMER_APELLIDO || ' ' || 
>             NVL(SEGUNDO_APELLIDO, '')
>         )
>         INTO v_nombre_completo
>         FROM UTNDB.RHU_TAB_PERSONAS
>         WHERE CEDULA = :cedula;
>     EXCEPTION
>         WHEN NO_DATA_FOUND THEN
>             v_nombre_completo := NULL;
>     END;
>
>     -- Obtener género de la persona
>     BEGIN
>         SELECT GENERO
>         INTO v_genero
>         FROM UTNDB.RHU_TAB_PERSONAS
>         WHERE CEDULA = :cedula;
>     EXCEPTION
>         WHEN NO_DATA_FOUND THEN
>             v_genero := NULL;
>     END;
>
>     -- Obtener facultad y carrera más reciente del estudiante
>     BEGIN
>         SELECT FACULTAD, CARRERA
>         INTO v_facultad, v_carrera
>         FROM (
>             SELECT 
>                 NVL(TAB_FAC.SIGLAS, TAB_FAC.NOMBRE) AS FACULTAD,
>                 TAB_CARRERA.NOMBRE AS CARRERA
>             FROM UTNDB.ACA_TAB_DEPENDENCIAS TAB_FAC
>             INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_ESC ON (TAB_FAC.CODIGO = TAB_ESC.DEPEN_CODIGO)
>             INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_CARRERA ON (TAB_ESC.CODIGO = TAB_CARRERA.DEPEN_CODIGO)
>             INNER JOIN UTNDB.ACA_TAB_MATRICULAS TAB_MATRICULAS ON (TAB_CARRERA.CODIGO = TAB_MATRICULAS.DEPEN_CODIGO)
>             WHERE TAB_MATRICULAS.ESTADO IN ('C', 'M', 'R')
>               AND TAB_MATRICULAS.ESTUDIANTE_CEDULA = :cedula
>             ORDER BY TAB_MATRICULAS.FECHA_MATRICULA DESC
>         ) WHERE ROWNUM = 1;
>     EXCEPTION
>         WHEN NO_DATA_FOUND THEN
>             v_facultad := NULL;
>             v_carrera := NULL;
>     END;
>     
>     -- Verificar si ya existe un registro para este comunicado/usuario
>     SELECT COUNT(*), NVL(MAX(NUM_VISUALIZACION), 0)
>     INTO v_existe, v_num_visualizacion
>     FROM MOVIL_UTN.MVL_TAB_COMUNICADOS_VISUALIZACIONES
>     WHERE ID_COMUNICADO = :idComunicado
>     AND USUARIO_CEDULA = :cedula;
>     
>     -- Calcular nuevo número de visualización
>     v_num_visualizacion := v_num_visualizacion + 1;
>     
>     -- Validar si puede registrar más visualizaciones
>     IF v_max_visualizaciones IS NOT NULL THEN
>         IF v_num_visualizacion > v_max_visualizaciones THEN
>             RAISE_APPLICATION_ERROR(-20001, 'Se ha alcanzado el máximo de visualizaciones permitidas');
>         END IF;
>     END IF;
>     
>     IF v_existe = 0 THEN
>         -- No existe: INSERT nuevo registro
>         INSERT INTO MOVIL_UTN.MVL_TAB_COMUNICADOS_VISUALIZACIONES (
>             ID_COMUNICADO,
>             USUARIO_CEDULA,
>             NOMBRE_COMPLETO,
>             GENERO,
>             FACULTAD,
>             CARRERA,
>             FECHA_VIS,
>             ACEPTO,
>             NUM_VISUALIZACION,
>             ENCUESTA_FECHA_INICIO_RESPUESTA,
>             ENCUESTA_FECHA_FIN_RESPUESTA
>         ) VALUES (
>             :idComunicado,
>             :cedula,
>             v_nombre_completo,
>             v_genero,
>             v_facultad,
>             v_carrera,
>             SYSDATE,
>             :acepto,
>             v_num_visualizacion,
>             CASE WHEN :encuestaFechaInicio IS NOT NULL 
>                 THEN TO_DATE(:encuestaFechaInicio, 'DD/MM/YYYY HH24:MI:SS') 
>                  ELSE NULL END,
>             CASE WHEN :encuestaFechaFin IS NOT NULL 
>                 THEN TO_DATE(:encuestaFechaFin, 'DD/MM/YYYY HH24:MI:SS') 
>                  ELSE NULL END
>         );
>     ELSE
>         -- Ya existe: UPDATE el registro existente (actualizar nombre por si cambió)
>         UPDATE MOVIL_UTN.MVL_TAB_COMUNICADOS_VISUALIZACIONES
>         SET FECHA_VIS = SYSDATE,
>             NUM_VISUALIZACION = v_num_visualizacion,
>             NOMBRE_COMPLETO = NVL(v_nombre_completo, NOMBRE_COMPLETO),
>             GENERO = NVL(v_genero, GENERO),
>             FACULTAD = NVL(v_facultad, FACULTAD),
>             CARRERA = NVL(v_carrera, CARRERA),
>             ACEPTO = NVL(:acepto, ACEPTO),
>             ENCUESTA_FECHA_INICIO_RESPUESTA = CASE 
>                 WHEN :encuestaFechaInicio IS NOT NULL 
>                 THEN TO_DATE(:encuestaFechaInicio, 'DD/MM/YYYY HH24:MI:SS') 
>                 ELSE ENCUESTA_FECHA_INICIO_RESPUESTA END,
>             ENCUESTA_FECHA_FIN_RESPUESTA = CASE 
>                 WHEN :encuestaFechaFin IS NOT NULL 
>                 THEN TO_DATE(:encuestaFechaFin, 'DD/MM/YYYY HH24:MI:SS') 
>                 ELSE ENCUESTA_FECHA_FIN_RESPUESTA END
>         WHERE ID_COMUNICADO = :idComunicado
>         AND USUARIO_CEDULA = :cedula;
>     END IF;
>     
>     COMMIT;
> EXCEPTION
>     WHEN NO_DATA_FOUND THEN
>         RAISE_APPLICATION_ERROR(-20002, 'Comunicado no encontrado o inactivo');
>     WHEN OTHERS THEN
>         ROLLBACK;
>         RAISE;
> END;
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_PRC_COM_REGISTRAR_VISUALIZACION
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=INVALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_PRC_COM_REGISTRAR_VISUALIZACION')
> -- Usado por: src/modules/comunicados
>
> CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_COM_REGISTRAR_VISUALIZACION (
>     p_id_comunicado IN NUMBER,
>     p_cedula IN VARCHAR2,
>     p_acepto IN VARCHAR2,
>     p_encuesta_fecha_inicio IN VARCHAR2,
>     p_encuesta_fecha_fin IN VARCHAR2
> ) AS
>     v_num_visualizacion NUMBER;
>     v_max_visualizaciones NUMBER;
>     v_existe NUMBER;
>     v_nombre_completo VARCHAR2(300);
>     v_genero VARCHAR2(20);
>     v_facultad VARCHAR2(200);
>     v_carrera VARCHAR2(200);
> BEGIN
>     SELECT MAX_VISUALIZACIONES
>     INTO v_max_visualizaciones
>     FROM MOVIL_UTN.MVL_TAB_COMUNICADOS
>     WHERE ID_COMUNICADO = p_id_comunicado
>     AND ESTADO = 'A';
>
>     BEGIN
>         SELECT TRIM(
>             PRIMER_NOMBRE || ' ' ||
>             NVL(SEGUNDO_NOMBRE, '') || ' ' ||
>             PRIMER_APELLIDO || ' ' ||
>             NVL(SEGUNDO_APELLIDO, '')
>         )
>         INTO v_nombre_completo
>         FROM UTNDB.RHU_TAB_PERSONAS
>         WHERE CEDULA = p_cedula;
>     EXCEPTION
>         WHEN NO_DATA_FOUND THEN
>             v_nombre_completo := NULL;
>     END;
>
>     BEGIN
>         SELECT GENERO
>         INTO v_genero
>         FROM UTNDB.RHU_TAB_PERSONAS
>         WHERE CEDULA = p_cedula;
>     EXCEPTION
>         WHEN NO_DATA_FOUND THEN
>             v_genero := NULL;
>     END;
>
>     BEGIN
>         SELECT FACULTAD, CARRERA
>         INTO v_facultad, v_carrera
>         FROM (
>             SELECT
>                 NVL(TAB_FAC.SIGLAS, TAB_FAC.NOMBRE) AS FACULTAD,
>                 TAB_CARRERA.NOMBRE AS CARRERA
>             FROM UTNDB.ACA_TAB_DEPENDENCIAS TAB_FAC
>             INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_ESC ON (TAB_FAC.CODIGO = TAB_ESC.DEPEN_CODIGO)
>             INNER JOIN UTNDB.ACA_TAB_DEPENDENCIAS TAB_CARRERA ON (TAB_ESC.CODIGO = TAB_CARRERA.DEPEN_CODIGO)
>             INNER JOIN UTNDB.ACA_TAB_MATRICULAS TAB_MATRICULAS ON (TAB_CARRERA.CODIGO = TAB_MATRICULAS.DEPEN_CODIGO)
>             WHERE TAB_MATRICULAS.ESTADO IN ('C', 'M', 'R')
>               AND TAB_MATRICULAS.ESTUDIANTE_CEDULA = p_cedula
>             ORDER BY TAB_MATRICULAS.FECHA_MATRICULA DESC
>         ) WHERE ROWNUM = 1;
>     EXCEPTION
>         WHEN NO_DATA_FOUND THEN
>             v_facultad := NULL;
>             v_carrera := NULL;
>     END;
>
>     SELECT COUNT(*), NVL(MAX(NUM_VISUALIZACION), 0)
>     INTO v_existe, v_num_visualizacion
>     FROM MOVIL_UTN.MVL_TAB_COMUNICADOS_VISUALIZACIONES
>     WHERE ID_COMUNICADO = p_id_comunicado
>     AND USUARIO_CEDULA = p_cedula;
>
>     v_num_visualizacion := v_num_visualizacion + 1;
>
>     IF v_max_visualizaciones IS NOT NULL THEN
>         IF v_num_visualizacion > v_max_visualizaciones THEN
>             RAISE_APPLICATION_ERROR(-20001, 'Se ha alcanzado el máximo de visualizaciones permitidas');
>         END IF;
>     END IF;
>
>     IF v_existe = 0 THEN
>         INSERT INTO MOVIL_UTN.MVL_TAB_COMUNICADOS_VISUALIZACIONES (
>             ID_COMUNICADO,
>             USUARIO_CEDULA,
>             NOMBRE_COMPLETO,
>             GENERO,
>             FACULTAD,
>             CARRERA,
>             FECHA_VIS,
>             ACEPTO,
>             NUM_VISUALIZACION,
>             ENCUESTA_FECHA_INICIO_RESPUESTA,
>             ENCUESTA_FECHA_FIN_RESPUESTA
>         ) VALUES (
>             p_id_comunicado,
>             p_cedula,
>             v_nombre_completo,
>             v_genero,
>             v_facultad,
>             v_carrera,
>             SYSDATE,
>             p_acepto,
>             v_num_visualizacion,
>             CASE WHEN p_encuesta_fecha_inicio IS NOT NULL
>                 THEN TO_DATE(p_encuesta_fecha_inicio, 'DD/MM/YYYY HH24:MI:SS')
>                  ELSE NULL END,
>             CASE WHEN p_encuesta_fecha_fin IS NOT NULL
>                 THEN TO_DATE(p_encuesta_fecha_fin, 'DD/MM/YYYY HH24:MI:SS')
>                  ELSE NULL END
>         );
>     ELSE
>         UPDATE MOVIL_UTN.MVL_TAB_COMUNICADOS_VISUALIZACIONES
>         SET FECHA_VIS = SYSDATE,
>             NUM_VISUALIZACION = v_num_visualizacion,
>             NOMBRE_COMPLETO = NVL(v_nombre_completo, NOMBRE_COMPLETO),
>             GENERO = NVL(v_genero, GENERO),
>             FACULTAD = NVL(v_facultad, FACULTAD),
>             CARRERA = NVL(v_carrera, CARRERA),
>             ACEPTO = NVL(p_acepto, ACEPTO),
>             ENCUESTA_FECHA_INICIO_RESPUESTA = CASE
>                 WHEN p_encuesta_fecha_inicio IS NOT NULL
>                 THEN TO_DATE(p_encuesta_fecha_inicio, 'DD/MM/YYYY HH24:MI:SS')
>                 ELSE ENCUESTA_FECHA_INICIO_RESPUESTA END,
>             ENCUESTA_FECHA_FIN_RESPUESTA = CASE
>                 WHEN p_encuesta_fecha_fin IS NOT NULL
>                 THEN TO_DATE(p_encuesta_fecha_fin, 'DD/MM/YYYY HH24:MI:SS')
>                 ELSE ENCUESTA_FECHA_FIN_RESPUESTA END
>         WHERE ID_COMUNICADO = p_id_comunicado
>         AND USUARIO_CEDULA = p_cedula;
>     END IF;
>
>     COMMIT;
> EXCEPTION
>     WHEN NO_DATA_FOUND THEN
>         RAISE_APPLICATION_ERROR(-20002, 'Comunicado no encontrado o inactivo');
>     WHEN OTHERS THEN
>         ROLLBACK;
>         RAISE;
> END MVL_PRC_COM_REGISTRAR_VISUALIZACION;
> /
> ```

> [!example]- `MVL_PRC_EVAL_INICIAR_CRONOMETRO` (procedimiento)
> **Resultado:** de punta a punta: curl real y tabla revisada en Oracle antes y después
>
> **Lo usa:** `src/modules/evaluacion_online/evaluacion_online.service.ts`, `src/modules/evaluacion_online/repository/consultas/evaluacion_online.queries.ts`, `src/modules/evaluacion_online/tests/evaluacion_online.conectividad.spec.ts`
>
> **Antes** (`src/modules/evaluacion_online/repository/consultas/evaluacion_online.queries.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const GET_FORMULARIO_BASE = `
>     SELECT
>         act.NOMBRE_CORTO AS "TITULO",
>         act.DESCRIPCION AS "DESCRIPCION",
>         pc.CUESTIONARIO_CODIGO AS "IDACTIVIDAD",
>         p.CODIGO AS "PREGUNTAID",
>         p.PREGUNTA_HTML AS "PREGUNTAHTML",
>         p.COD_TIPO_PREGUNTA AS "TIPOPREGUNTA",
>         CASE 
>             WHEN p.ADJUNTO IS NOT NULL AND p.ADJUNTO_MIME LIKE 'image/%' THEN 1 
>         ELSE 0 
>             END AS "TIENEADJUNTO",
>         al.FECHA_INICIO_EA AS "FECHAINICIOISO",
>         CASE
>             WHEN al.FECHA_INICIO_EA IS NULL THEN NULL
>             WHEN act.FECHA_FIN IS NULL THEN al.FECHA_INICIO_EA + (act.LIM_TIEMPO_HORAS / 24) + (act.LIMITE_TIEMPO / 1440)
>             ELSE LEAST(
>                 act.FECHA_FIN,
>                 al.FECHA_INICIO_EA + (act.LIM_TIEMPO_HORAS / 24) + (act.LIMITE_TIEMPO / 1440)
>             )
>         END AS "FECHAFINISO"
>     FROM
>         UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>     INNER JOIN
>         UTNDB.LMS_TAB_PREGUNTAS p ON pc.PREGUNTA_CODIGO = p.CODIGO
>     INNER JOIN
>         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA act ON pc.CUESTIONARIO_CODIGO = act.ID_ACTIVIDAD
>     INNER JOIN
>         UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS al ON pc.CUESTIONARIO_CODIGO = al.ID_ACTIVIDAD
>                                            AND pc.ESTUDIANTE_CEDULA = al.CEDULA_INTEGRANTE
>     WHERE
>         al.ID_ACTIVIDAD_ALUMNO = :1
>     ORDER BY
>         pc.SUB_ID
> `;
>
> export const GET_ALTERNATIVAS_Y_RESPUESTAS = `
>     WITH PREGUNTAS_ACTIVIDAD AS (
>         SELECT 
>             pc.PREGUNTA_CODIGO,
>             p.COD_TIPO_PREGUNTA,
>             al.ID_ACTIVIDAD
>         FROM 
>             UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>         INNER JOIN 
>             UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS al 
>             ON pc.CUESTIONARIO_CODIGO = al.ID_ACTIVIDAD 
>             AND pc.ESTUDIANTE_CEDULA = al.CEDULA_INTEGRANTE
>         INNER JOIN
>             UTNDB.LMS_TAB_PREGUNTAS p
>             ON pc.PREGUNTA_CODIGO = p.CODIGO
>         WHERE 
>             al.ID_ACTIVIDAD_ALUMNO = :1 
>     )
>     
>     SELECT
>         r.CODIGO_PREGUNTA AS "PREGUNTAID",
>         r.CODIGO AS "ALTERNATIVAID",
>         r.NOMBRE AS "ALTERNATIVANOMBRE",             
>         r.COLUMNA_EMPAREJAMIENTO,                     
>         r.CALIFICACION AS "ALTERNATIVACALIFICACION",
>         r.RETROALIMENTACION AS "ALTERNATIVARETROALIMENTACION",
>         r.RESPUESTA_NUM AS "RESPUESTANUM",
>         r.ESTADO AS "ESTADORESPUESTA",
>         rest.RESPUESTA AS "RESPUESTAESTUDIANTE",
>         rest.CALIFICACION_ESTUDIANTE AS "CALIFICACIONESTUDIANTE",
>         CASE
>             WHEN COUNT(rest.CODIGO) > 0 THEN 'A'
>             ELSE 'I'
>         END AS "ALTERNATIVAESTADO"
>     FROM
>         UTNDB.LMS_TAB_RESPUESTAS r
>     INNER JOIN 
>         PREGUNTAS_ACTIVIDAD pq ON r.CODIGO_PREGUNTA = pq.PREGUNTA_CODIGO
>     LEFT JOIN
>         UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE rest
>         ON r.CODIGO = rest.CODIGO_RESPUESTA
>        AND pq.ID_ACTIVIDAD = rest.ID_ACTIVIDAD 
>        AND rest.CEDULA_ESTUDIANTE = :2
>        AND rest.ESTADO = 'A'
>     WHERE
>         pq.COD_TIPO_PREGUNTA <> 4 
>     GROUP BY
>         r.CODIGO_PREGUNTA,
>         r.CODIGO,
>         r.NOMBRE,
>         r.COLUMNA_EMPAREJAMIENTO,
>         r.CALIFICACION,
>         r.RETROALIMENTACION,
>         r.RESPUESTA_NUM,
>         r.ESTADO,
>         rest.RESPUESTA,
>         rest.CALIFICACION_ESTUDIANTE
>
>     UNION ALL
>
>     SELECT
>         rest.CODIGO_PREGUNTA AS "PREGUNTAID",
>         NULL AS "ALTERNATIVAID",
>         NULL AS "ALTERNATIVANOMBRE",             
>         NULL AS "COLUMNA_EMPAREJAMIENTO",                     
>         NULL AS "ALTERNATIVACALIFICACION",
>         NULL AS "ALTERNATIVARETROALIMENTACION",
>         NULL AS "RESPUESTANUM",
>         NULL AS "ESTADORESPUESTA",
>         rest.RESPUESTA AS "RESPUESTAESTUDIANTE",
>         rest.CALIFICACION_ESTUDIANTE AS "CALIFICACIONESTUDIANTE",
>         'A' AS "ALTERNATIVAESTADO"
>     FROM
>         UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE rest
>     INNER JOIN 
>         PREGUNTAS_ACTIVIDAD pq ON rest.CODIGO_PREGUNTA = pq.PREGUNTA_CODIGO
>     WHERE
>        pq.ID_ACTIVIDAD = rest.ID_ACTIVIDAD 
>        AND rest.CEDULA_ESTUDIANTE = :2
>        AND rest.ESTADO = 'A'
>        AND rest.CODIGO_RESPUESTA IS NULL 
>        AND pq.COD_TIPO_PREGUNTA = 4 
> `;
>
> export const INICIAR_CRONOMETRO_EVALUACION = `
>     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     SET FECHA_INICIO_EA = SYSDATE, USUARIO_ACTUALIZACION = :1
>     WHERE ID_ACTIVIDAD_ALUMNO = :2
>       AND CEDULA_INTEGRANTE = :3
>       AND FECHA_INICIO_EA IS NULL
> `;
>
> export const REANUDAR_INTENTO_ENTREGADO = `
>     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     SET ENTREGADO = 'NO',
>         FECHA_FIN_EA = NULL,
>         CALIFICACION = NULL,
>         USUARIO_ACTUALIZACION = :1
>     WHERE ID_ACTIVIDAD_ALUMNO = :2
>       AND CEDULA_INTEGRANTE = :3
>       AND ENTREGADO = 'SI'
> `;
>
> // TODO: Agregar guardas NVL al cálculo de FECHAFINISO en esta consulta y en
> // GET_FORMULARIO_BASE, replicando lo que ya hace GET_REGLAS_EVALUACION_RESPONDER.
> // En Oracle FECHA_INICIO_EA + NULL = NULL y LEAST(x, NULL) = NULL, así que si una
> // actividad tiene LIM_TIEMPO_HORAS o LIMITE_TIEMPO en NULL estas dos consultas
> // devuelven FECHAFINISO = NULL mientras la de responder sí calcula un límite real.
> // no se programa el job de auto-calificación (if (reglas.fechaFinISO)), pero
> // /responder empieza a rechazar respuestas con 403 EXPIRADO sin avisar al estudiante.
> export const GET_REGLAS_EVALUACION = `
>     SELECT
>         act.FECHA_INICIO AS "FECHAINICIO",
>         act.FECHA_FIN AS "FECHAFIN",
>         alu.INTENTOS_DISPONIBLES AS "INTENTOSDISPONIBLES",
>         alu.ENTREGADO AS "ENTREGADO",
>         alu.FECHA_INICIO_EA AS "FECHAINICIOEA",
>         UTNDB.LMS_FUN_ACTIVIDAD_ACTIVA(alu.ID_ACTIVIDAD, alu.CEDULA_INTEGRANTE) AS "ESTADOACTIVIDAD",
>         CASE
>             WHEN alu.FECHA_INICIO_EA IS NULL THEN NULL
>             WHEN act.FECHA_FIN IS NULL THEN alu.FECHA_INICIO_EA + (act.LIM_TIEMPO_HORAS / 24) + (act.LIMITE_TIEMPO / 1440)
>             ELSE
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_PRC_EVAL_INICIAR_CRONOMETRO
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_PRC_EVAL_INICIAR_CRONOMETRO')
> -- Usado por: src/modules/evaluacion_online
>
> CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_EVAL_INICIAR_CRONOMETRO (
>     p_cuenta               IN VARCHAR2,
>     p_id_actividad_alumno  IN NUMBER,
>     p_cedula               IN VARCHAR2
> ) AS
> BEGIN
>     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     SET FECHA_INICIO_EA = SYSDATE,
>         USUARIO_ACTUALIZACION = p_cuenta
>     WHERE ID_ACTIVIDAD_ALUMNO = p_id_actividad_alumno
>       AND CEDULA_INTEGRANTE = p_cedula
>       AND FECHA_INICIO_EA IS NULL;
> END;
> /
> ```

> [!example]- `MVL_PRC_EVAL_REANUDAR_INTENTO` (procedimiento)
> **Resultado:** de punta a punta: curl real y tabla revisada en Oracle antes y después
>
> **Lo usa:** `src/modules/evaluacion_online/evaluacion_online.service.ts`, `src/modules/evaluacion_online/repository/consultas/evaluacion_online.queries.ts`, `src/modules/evaluacion_online/tests/evaluacion_online.conectividad.spec.ts`, `src/modules/evaluacion_online/tests/evaluacion_online.service.spec.ts`
>
> **Antes** (`src/modules/evaluacion_online/repository/consultas/evaluacion_online.queries.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const GET_FORMULARIO_BASE = `
>     SELECT
>         act.NOMBRE_CORTO AS "TITULO",
>         act.DESCRIPCION AS "DESCRIPCION",
>         pc.CUESTIONARIO_CODIGO AS "IDACTIVIDAD",
>         p.CODIGO AS "PREGUNTAID",
>         p.PREGUNTA_HTML AS "PREGUNTAHTML",
>         p.COD_TIPO_PREGUNTA AS "TIPOPREGUNTA",
>         CASE 
>             WHEN p.ADJUNTO IS NOT NULL AND p.ADJUNTO_MIME LIKE 'image/%' THEN 1 
>         ELSE 0 
>             END AS "TIENEADJUNTO",
>         al.FECHA_INICIO_EA AS "FECHAINICIOISO",
>         CASE
>             WHEN al.FECHA_INICIO_EA IS NULL THEN NULL
>             WHEN act.FECHA_FIN IS NULL THEN al.FECHA_INICIO_EA + (act.LIM_TIEMPO_HORAS / 24) + (act.LIMITE_TIEMPO / 1440)
>             ELSE LEAST(
>                 act.FECHA_FIN,
>                 al.FECHA_INICIO_EA + (act.LIM_TIEMPO_HORAS / 24) + (act.LIMITE_TIEMPO / 1440)
>             )
>         END AS "FECHAFINISO"
>     FROM
>         UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>     INNER JOIN
>         UTNDB.LMS_TAB_PREGUNTAS p ON pc.PREGUNTA_CODIGO = p.CODIGO
>     INNER JOIN
>         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA act ON pc.CUESTIONARIO_CODIGO = act.ID_ACTIVIDAD
>     INNER JOIN
>         UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS al ON pc.CUESTIONARIO_CODIGO = al.ID_ACTIVIDAD
>                                            AND pc.ESTUDIANTE_CEDULA = al.CEDULA_INTEGRANTE
>     WHERE
>         al.ID_ACTIVIDAD_ALUMNO = :1
>     ORDER BY
>         pc.SUB_ID
> `;
>
> export const GET_ALTERNATIVAS_Y_RESPUESTAS = `
>     WITH PREGUNTAS_ACTIVIDAD AS (
>         SELECT 
>             pc.PREGUNTA_CODIGO,
>             p.COD_TIPO_PREGUNTA,
>             al.ID_ACTIVIDAD
>         FROM 
>             UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>         INNER JOIN 
>             UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS al 
>             ON pc.CUESTIONARIO_CODIGO = al.ID_ACTIVIDAD 
>             AND pc.ESTUDIANTE_CEDULA = al.CEDULA_INTEGRANTE
>         INNER JOIN
>             UTNDB.LMS_TAB_PREGUNTAS p
>             ON pc.PREGUNTA_CODIGO = p.CODIGO
>         WHERE 
>             al.ID_ACTIVIDAD_ALUMNO = :1 
>     )
>     
>     SELECT
>         r.CODIGO_PREGUNTA AS "PREGUNTAID",
>         r.CODIGO AS "ALTERNATIVAID",
>         r.NOMBRE AS "ALTERNATIVANOMBRE",             
>         r.COLUMNA_EMPAREJAMIENTO,                     
>         r.CALIFICACION AS "ALTERNATIVACALIFICACION",
>         r.RETROALIMENTACION AS "ALTERNATIVARETROALIMENTACION",
>         r.RESPUESTA_NUM AS "RESPUESTANUM",
>         r.ESTADO AS "ESTADORESPUESTA",
>         rest.RESPUESTA AS "RESPUESTAESTUDIANTE",
>         rest.CALIFICACION_ESTUDIANTE AS "CALIFICACIONESTUDIANTE",
>         CASE
>             WHEN COUNT(rest.CODIGO) > 0 THEN 'A'
>             ELSE 'I'
>         END AS "ALTERNATIVAESTADO"
>     FROM
>         UTNDB.LMS_TAB_RESPUESTAS r
>     INNER JOIN 
>         PREGUNTAS_ACTIVIDAD pq ON r.CODIGO_PREGUNTA = pq.PREGUNTA_CODIGO
>     LEFT JOIN
>         UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE rest
>         ON r.CODIGO = rest.CODIGO_RESPUESTA
>        AND pq.ID_ACTIVIDAD = rest.ID_ACTIVIDAD 
>        AND rest.CEDULA_ESTUDIANTE = :2
>        AND rest.ESTADO = 'A'
>     WHERE
>         pq.COD_TIPO_PREGUNTA <> 4 
>     GROUP BY
>         r.CODIGO_PREGUNTA,
>         r.CODIGO,
>         r.NOMBRE,
>         r.COLUMNA_EMPAREJAMIENTO,
>         r.CALIFICACION,
>         r.RETROALIMENTACION,
>         r.RESPUESTA_NUM,
>         r.ESTADO,
>         rest.RESPUESTA,
>         rest.CALIFICACION_ESTUDIANTE
>
>     UNION ALL
>
>     SELECT
>         rest.CODIGO_PREGUNTA AS "PREGUNTAID",
>         NULL AS "ALTERNATIVAID",
>         NULL AS "ALTERNATIVANOMBRE",             
>         NULL AS "COLUMNA_EMPAREJAMIENTO",                     
>         NULL AS "ALTERNATIVACALIFICACION",
>         NULL AS "ALTERNATIVARETROALIMENTACION",
>         NULL AS "RESPUESTANUM",
>         NULL AS "ESTADORESPUESTA",
>         rest.RESPUESTA AS "RESPUESTAESTUDIANTE",
>         rest.CALIFICACION_ESTUDIANTE AS "CALIFICACIONESTUDIANTE",
>         'A' AS "ALTERNATIVAESTADO"
>     FROM
>         UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE rest
>     INNER JOIN 
>         PREGUNTAS_ACTIVIDAD pq ON rest.CODIGO_PREGUNTA = pq.PREGUNTA_CODIGO
>     WHERE
>        pq.ID_ACTIVIDAD = rest.ID_ACTIVIDAD 
>        AND rest.CEDULA_ESTUDIANTE = :2
>        AND rest.ESTADO = 'A'
>        AND rest.CODIGO_RESPUESTA IS NULL 
>        AND pq.COD_TIPO_PREGUNTA = 4 
> `;
>
> export const INICIAR_CRONOMETRO_EVALUACION = `
>     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     SET FECHA_INICIO_EA = SYSDATE, USUARIO_ACTUALIZACION = :1
>     WHERE ID_ACTIVIDAD_ALUMNO = :2
>       AND CEDULA_INTEGRANTE = :3
>       AND FECHA_INICIO_EA IS NULL
> `;
>
> export const REANUDAR_INTENTO_ENTREGADO = `
>     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     SET ENTREGADO = 'NO',
>         FECHA_FIN_EA = NULL,
>         CALIFICACION = NULL,
>         USUARIO_ACTUALIZACION = :1
>     WHERE ID_ACTIVIDAD_ALUMNO = :2
>       AND CEDULA_INTEGRANTE = :3
>       AND ENTREGADO = 'SI'
> `;
>
> // TODO: Agregar guardas NVL al cálculo de FECHAFINISO en esta consulta y en
> // GET_FORMULARIO_BASE, replicando lo que ya hace GET_REGLAS_EVALUACION_RESPONDER.
> // En Oracle FECHA_INICIO_EA + NULL = NULL y LEAST(x, NULL) = NULL, así que si una
> // actividad tiene LIM_TIEMPO_HORAS o LIMITE_TIEMPO en NULL estas dos consultas
> // devuelven FECHAFINISO = NULL mientras la de responder sí calcula un límite real.
> // no se programa el job de auto-calificación (if (reglas.fechaFinISO)), pero
> // /responder empieza a rechazar respuestas con 403 EXPIRADO sin avisar al estudiante.
> export const GET_REGLAS_EVALUACION = `
>     SELECT
>         act.FECHA_INICIO AS "FECHAINICIO",
>         act.FECHA_FIN AS "FECHAFIN",
>         alu.INTENTOS_DISPONIBLES AS "INTENTOSDISPONIBLES",
>         alu.ENTREGADO AS "ENTREGADO",
>         alu.FECHA_INICIO_EA AS "FECHAINICIOEA",
>         UTNDB.LMS_FUN_ACTIVIDAD_ACTIVA(alu.ID_ACTIVIDAD, alu.CEDULA_INTEGRANTE) AS "ESTADOACTIVIDAD",
>         CASE
>             WHEN alu.FECHA_INICIO_EA IS NULL THEN NULL
>             WHEN act.FECHA_FIN IS NULL THEN alu.FECHA_INICIO_EA + (act.LIM_TIEMPO_HORAS / 24) + (act.LIMITE_TIEMPO / 1440)
>             ELSE
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_PRC_EVAL_REANUDAR_INTENTO
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_PRC_EVAL_REANUDAR_INTENTO')
> -- Usado por: src/modules/evaluacion_online
>
> CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_EVAL_REANUDAR_INTENTO (
>     p_cuenta               IN VARCHAR2,
>     p_id_actividad_alumno  IN NUMBER,
>     p_cedula               IN VARCHAR2
> ) AS
> BEGIN
>     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     SET ENTREGADO = 'NO',
>         FECHA_FIN_EA = NULL,
>         FECHA_INICIO_EA = NULL,
>         CALIFICACION = NULL,
>         USUARIO_ACTUALIZACION = p_cuenta
>     WHERE ID_ACTIVIDAD_ALUMNO = p_id_actividad_alumno
>       AND CEDULA_INTEGRANTE = p_cedula
>       AND ENTREGADO = 'SI';
> END;
> /
> ```

> [!example]- `MVL_PRC_EVAL_GUARDAR_RESPUESTA` (procedimiento)
> **Resultado:** de punta a punta: curl real y tabla revisada en Oracle antes y después
>
> **Nota del registro:** evaluacion_online, sigue -- MVL_PRC_EVAL_GUARDAR_RESPUESTA (consolida
>
> **Lo usa:** `src/modules/evaluacion_online/repository/consultas/evaluacion_online.queries.ts`
>
> **Antes** (`src/modules/evaluacion_online/repository/consultas/evaluacion_online.queries.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const GET_FORMULARIO_BASE = `
>     SELECT
>         act.NOMBRE_CORTO AS "TITULO",
>         act.DESCRIPCION AS "DESCRIPCION",
>         pc.CUESTIONARIO_CODIGO AS "IDACTIVIDAD",
>         p.CODIGO AS "PREGUNTAID",
>         p.PREGUNTA_HTML AS "PREGUNTAHTML",
>         p.COD_TIPO_PREGUNTA AS "TIPOPREGUNTA",
>         CASE 
>             WHEN p.ADJUNTO IS NOT NULL AND p.ADJUNTO_MIME LIKE 'image/%' THEN 1 
>         ELSE 0 
>             END AS "TIENEADJUNTO",
>         al.FECHA_INICIO_EA AS "FECHAINICIOISO",
>         CASE
>             WHEN al.FECHA_INICIO_EA IS NULL THEN NULL
>             WHEN act.FECHA_FIN IS NULL THEN al.FECHA_INICIO_EA + (act.LIM_TIEMPO_HORAS / 24) + (act.LIMITE_TIEMPO / 1440)
>             ELSE LEAST(
>                 act.FECHA_FIN,
>                 al.FECHA_INICIO_EA + (act.LIM_TIEMPO_HORAS / 24) + (act.LIMITE_TIEMPO / 1440)
>             )
>         END AS "FECHAFINISO"
>     FROM
>         UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>     INNER JOIN
>         UTNDB.LMS_TAB_PREGUNTAS p ON pc.PREGUNTA_CODIGO = p.CODIGO
>     INNER JOIN
>         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA act ON pc.CUESTIONARIO_CODIGO = act.ID_ACTIVIDAD
>     INNER JOIN
>         UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS al ON pc.CUESTIONARIO_CODIGO = al.ID_ACTIVIDAD
>                                            AND pc.ESTUDIANTE_CEDULA = al.CEDULA_INTEGRANTE
>     WHERE
>         al.ID_ACTIVIDAD_ALUMNO = :1
>     ORDER BY
>         pc.SUB_ID
> `;
>
> export const GET_ALTERNATIVAS_Y_RESPUESTAS = `
>     WITH PREGUNTAS_ACTIVIDAD AS (
>         SELECT 
>             pc.PREGUNTA_CODIGO,
>             p.COD_TIPO_PREGUNTA,
>             al.ID_ACTIVIDAD
>         FROM 
>             UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>         INNER JOIN 
>             UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS al 
>             ON pc.CUESTIONARIO_CODIGO = al.ID_ACTIVIDAD 
>             AND pc.ESTUDIANTE_CEDULA = al.CEDULA_INTEGRANTE
>         INNER JOIN
>             UTNDB.LMS_TAB_PREGUNTAS p
>             ON pc.PREGUNTA_CODIGO = p.CODIGO
>         WHERE 
>             al.ID_ACTIVIDAD_ALUMNO = :1 
>     )
>     
>     SELECT
>         r.CODIGO_PREGUNTA AS "PREGUNTAID",
>         r.CODIGO AS "ALTERNATIVAID",
>         r.NOMBRE AS "ALTERNATIVANOMBRE",             
>         r.COLUMNA_EMPAREJAMIENTO,                     
>         r.CALIFICACION AS "ALTERNATIVACALIFICACION",
>         r.RETROALIMENTACION AS "ALTERNATIVARETROALIMENTACION",
>         r.RESPUESTA_NUM AS "RESPUESTANUM",
>         r.ESTADO AS "ESTADORESPUESTA",
>         rest.RESPUESTA AS "RESPUESTAESTUDIANTE",
>         rest.CALIFICACION_ESTUDIANTE AS "CALIFICACIONESTUDIANTE",
>         CASE
>             WHEN COUNT(rest.CODIGO) > 0 THEN 'A'
>             ELSE 'I'
>         END AS "ALTERNATIVAESTADO"
>     FROM
>         UTNDB.LMS_TAB_RESPUESTAS r
>     INNER JOIN 
>         PREGUNTAS_ACTIVIDAD pq ON r.CODIGO_PREGUNTA = pq.PREGUNTA_CODIGO
>     LEFT JOIN
>         UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE rest
>         ON r.CODIGO = rest.CODIGO_RESPUESTA
>        AND pq.ID_ACTIVIDAD = rest.ID_ACTIVIDAD 
>        AND rest.CEDULA_ESTUDIANTE = :2
>        AND rest.ESTADO = 'A'
>     WHERE
>         pq.COD_TIPO_PREGUNTA <> 4 
>     GROUP BY
>         r.CODIGO_PREGUNTA,
>         r.CODIGO,
>         r.NOMBRE,
>         r.COLUMNA_EMPAREJAMIENTO,
>         r.CALIFICACION,
>         r.RETROALIMENTACION,
>         r.RESPUESTA_NUM,
>         r.ESTADO,
>         rest.RESPUESTA,
>         rest.CALIFICACION_ESTUDIANTE
>
>     UNION ALL
>
>     SELECT
>         rest.CODIGO_PREGUNTA AS "PREGUNTAID",
>         NULL AS "ALTERNATIVAID",
>         NULL AS "ALTERNATIVANOMBRE",             
>         NULL AS "COLUMNA_EMPAREJAMIENTO",                     
>         NULL AS "ALTERNATIVACALIFICACION",
>         NULL AS "ALTERNATIVARETROALIMENTACION",
>         NULL AS "RESPUESTANUM",
>         NULL AS "ESTADORESPUESTA",
>         rest.RESPUESTA AS "RESPUESTAESTUDIANTE",
>         rest.CALIFICACION_ESTUDIANTE AS "CALIFICACIONESTUDIANTE",
>         'A' AS "ALTERNATIVAESTADO"
>     FROM
>         UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE rest
>     INNER JOIN 
>         PREGUNTAS_ACTIVIDAD pq ON rest.CODIGO_PREGUNTA = pq.PREGUNTA_CODIGO
>     WHERE
>        pq.ID_ACTIVIDAD = rest.ID_ACTIVIDAD 
>        AND rest.CEDULA_ESTUDIANTE = :2
>        AND rest.ESTADO = 'A'
>        AND rest.CODIGO_RESPUESTA IS NULL 
>        AND pq.COD_TIPO_PREGUNTA = 4 
> `;
>
> export const INICIAR_CRONOMETRO_EVALUACION = `
>     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     SET FECHA_INICIO_EA = SYSDATE, USUARIO_ACTUALIZACION = :1
>     WHERE ID_ACTIVIDAD_ALUMNO = :2
>       AND CEDULA_INTEGRANTE = :3
>       AND FECHA_INICIO_EA IS NULL
> `;
>
> export const REANUDAR_INTENTO_ENTREGADO = `
>     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     SET ENTREGADO = 'NO',
>         FECHA_FIN_EA = NULL,
>         CALIFICACION = NULL,
>         USUARIO_ACTUALIZACION = :1
>     WHERE ID_ACTIVIDAD_ALUMNO = :2
>       AND CEDULA_INTEGRANTE = :3
>       AND ENTREGADO = 'SI'
> `;
>
> // TODO: Agregar guardas NVL al cálculo de FECHAFINISO en esta consulta y en
> // GET_FORMULARIO_BASE, replicando lo que ya hace GET_REGLAS_EVALUACION_RESPONDER.
> // En Oracle FECHA_INICIO_EA + NULL = NULL y LEAST(x, NULL) = NULL, así que si una
> // actividad tiene LIM_TIEMPO_HORAS o LIMITE_TIEMPO en NULL estas dos consultas
> // devuelven FECHAFINISO = NULL mientras la de responder sí calcula un límite real.
> // no se programa el job de auto-calificación (if (reglas.fechaFinISO)), pero
> // /responder empieza a rechazar respuestas con 403 EXPIRADO sin avisar al estudiante.
> export const GET_REGLAS_EVALUACION = `
>     SELECT
>         act.FECHA_INICIO AS "FECHAINICIO",
>         act.FECHA_FIN AS "FECHAFIN",
>         alu.INTENTOS_DISPONIBLES AS "INTENTOSDISPONIBLES",
>         alu.ENTREGADO AS "ENTREGADO",
>         alu.FECHA_INICIO_EA AS "FECHAINICIOEA",
>         UTNDB.LMS_FUN_ACTIVIDAD_ACTIVA(alu.ID_ACTIVIDAD, alu.CEDULA_INTEGRANTE) AS "ESTADOACTIVIDAD",
>         CASE
>             WHEN alu.FECHA_INICIO_EA IS NULL THEN NULL
>             WHEN act.FECHA_FIN IS NULL THEN alu.FECHA_INICIO_EA + (act.LIM_TIEMPO_HORAS / 24) + (act.LIMITE_TIEMPO / 1440)
>             ELSE
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_PRC_EVAL_GUARDAR_RESPUESTA
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_PRC_EVAL_GUARDAR_RESPUESTA')
> -- Usado por: src/modules/evaluacion_online
>
> CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_EVAL_GUARDAR_RESPUESTA (
>     p_cuenta               IN VARCHAR2,
>     p_id_actividad_alumno  IN NUMBER,
>     p_cedula               IN VARCHAR2,
>     p_id_pregunta          IN NUMBER,
>     p_id_alternativa       IN NUMBER,
>     p_texto_respuesta      IN VARCHAR2
> ) AS
>     v_id_actividad UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS.ID_ACTIVIDAD%TYPE;
> BEGIN
>     SELECT ID_ACTIVIDAD
>     INTO v_id_actividad
>     FROM UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     WHERE ID_ACTIVIDAD_ALUMNO = p_id_actividad_alumno;
>
>     UPDATE UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE
>     SET ESTADO = 'I', USUARIO_ACTUALIZACION = p_cuenta
>     WHERE ID_ACTIVIDAD = v_id_actividad
>       AND CEDULA_ESTUDIANTE = p_cedula
>       AND CODIGO_PREGUNTA = p_id_pregunta;
>
>     INSERT INTO UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE
>         (ID_ACTIVIDAD, CEDULA_ESTUDIANTE, CODIGO_PREGUNTA, CODIGO_RESPUESTA, ESTADO,
>          RESPUESTA, USUARIO_CREACION, USUARIO_ACTUALIZACION)
>     VALUES
>         (v_id_actividad, p_cedula, p_id_pregunta, p_id_alternativa, 'A',
>          p_texto_respuesta, p_cuenta, p_cuenta);
> END;
> /
> ```

> [!example]- `MVL_PRC_EVAL_GUARDAR_RESPUESTA_EMPAREJAR` (procedimiento)
> **Resultado:** de punta a punta: curl real y tabla revisada en Oracle antes y después
>
> **Nota del registro:** evaluacion_online, sigue -- MVL_PRC_EVAL_GUARDAR_RESPUESTA_EMPAREJAR (consolida
>
> **Lo usa:** `src/modules/evaluacion_online/repository/consultas/evaluacion_online.queries.ts`
>
> **Antes** (`src/modules/evaluacion_online/repository/consultas/evaluacion_online.queries.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const GET_FORMULARIO_BASE = `
>     SELECT
>         act.NOMBRE_CORTO AS "TITULO",
>         act.DESCRIPCION AS "DESCRIPCION",
>         pc.CUESTIONARIO_CODIGO AS "IDACTIVIDAD",
>         p.CODIGO AS "PREGUNTAID",
>         p.PREGUNTA_HTML AS "PREGUNTAHTML",
>         p.COD_TIPO_PREGUNTA AS "TIPOPREGUNTA",
>         CASE 
>             WHEN p.ADJUNTO IS NOT NULL AND p.ADJUNTO_MIME LIKE 'image/%' THEN 1 
>         ELSE 0 
>             END AS "TIENEADJUNTO",
>         al.FECHA_INICIO_EA AS "FECHAINICIOISO",
>         CASE
>             WHEN al.FECHA_INICIO_EA IS NULL THEN NULL
>             WHEN act.FECHA_FIN IS NULL THEN al.FECHA_INICIO_EA + (act.LIM_TIEMPO_HORAS / 24) + (act.LIMITE_TIEMPO / 1440)
>             ELSE LEAST(
>                 act.FECHA_FIN,
>                 al.FECHA_INICIO_EA + (act.LIM_TIEMPO_HORAS / 24) + (act.LIMITE_TIEMPO / 1440)
>             )
>         END AS "FECHAFINISO"
>     FROM
>         UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>     INNER JOIN
>         UTNDB.LMS_TAB_PREGUNTAS p ON pc.PREGUNTA_CODIGO = p.CODIGO
>     INNER JOIN
>         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA act ON pc.CUESTIONARIO_CODIGO = act.ID_ACTIVIDAD
>     INNER JOIN
>         UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS al ON pc.CUESTIONARIO_CODIGO = al.ID_ACTIVIDAD
>                                            AND pc.ESTUDIANTE_CEDULA = al.CEDULA_INTEGRANTE
>     WHERE
>         al.ID_ACTIVIDAD_ALUMNO = :1
>     ORDER BY
>         pc.SUB_ID
> `;
>
> export const GET_ALTERNATIVAS_Y_RESPUESTAS = `
>     WITH PREGUNTAS_ACTIVIDAD AS (
>         SELECT 
>             pc.PREGUNTA_CODIGO,
>             p.COD_TIPO_PREGUNTA,
>             al.ID_ACTIVIDAD
>         FROM 
>             UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>         INNER JOIN 
>             UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS al 
>             ON pc.CUESTIONARIO_CODIGO = al.ID_ACTIVIDAD 
>             AND pc.ESTUDIANTE_CEDULA = al.CEDULA_INTEGRANTE
>         INNER JOIN
>             UTNDB.LMS_TAB_PREGUNTAS p
>             ON pc.PREGUNTA_CODIGO = p.CODIGO
>         WHERE 
>             al.ID_ACTIVIDAD_ALUMNO = :1 
>     )
>     
>     SELECT
>         r.CODIGO_PREGUNTA AS "PREGUNTAID",
>         r.CODIGO AS "ALTERNATIVAID",
>         r.NOMBRE AS "ALTERNATIVANOMBRE",             
>         r.COLUMNA_EMPAREJAMIENTO,                     
>         r.CALIFICACION AS "ALTERNATIVACALIFICACION",
>         r.RETROALIMENTACION AS "ALTERNATIVARETROALIMENTACION",
>         r.RESPUESTA_NUM AS "RESPUESTANUM",
>         r.ESTADO AS "ESTADORESPUESTA",
>         rest.RESPUESTA AS "RESPUESTAESTUDIANTE",
>         rest.CALIFICACION_ESTUDIANTE AS "CALIFICACIONESTUDIANTE",
>         CASE
>             WHEN COUNT(rest.CODIGO) > 0 THEN 'A'
>             ELSE 'I'
>         END AS "ALTERNATIVAESTADO"
>     FROM
>         UTNDB.LMS_TAB_RESPUESTAS r
>     INNER JOIN 
>         PREGUNTAS_ACTIVIDAD pq ON r.CODIGO_PREGUNTA = pq.PREGUNTA_CODIGO
>     LEFT JOIN
>         UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE rest
>         ON r.CODIGO = rest.CODIGO_RESPUESTA
>        AND pq.ID_ACTIVIDAD = rest.ID_ACTIVIDAD 
>        AND rest.CEDULA_ESTUDIANTE = :2
>        AND rest.ESTADO = 'A'
>     WHERE
>         pq.COD_TIPO_PREGUNTA <> 4 
>     GROUP BY
>         r.CODIGO_PREGUNTA,
>         r.CODIGO,
>         r.NOMBRE,
>         r.COLUMNA_EMPAREJAMIENTO,
>         r.CALIFICACION,
>         r.RETROALIMENTACION,
>         r.RESPUESTA_NUM,
>         r.ESTADO,
>         rest.RESPUESTA,
>         rest.CALIFICACION_ESTUDIANTE
>
>     UNION ALL
>
>     SELECT
>         rest.CODIGO_PREGUNTA AS "PREGUNTAID",
>         NULL AS "ALTERNATIVAID",
>         NULL AS "ALTERNATIVANOMBRE",             
>         NULL AS "COLUMNA_EMPAREJAMIENTO",                     
>         NULL AS "ALTERNATIVACALIFICACION",
>         NULL AS "ALTERNATIVARETROALIMENTACION",
>         NULL AS "RESPUESTANUM",
>         NULL AS "ESTADORESPUESTA",
>         rest.RESPUESTA AS "RESPUESTAESTUDIANTE",
>         rest.CALIFICACION_ESTUDIANTE AS "CALIFICACIONESTUDIANTE",
>         'A' AS "ALTERNATIVAESTADO"
>     FROM
>         UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE rest
>     INNER JOIN 
>         PREGUNTAS_ACTIVIDAD pq ON rest.CODIGO_PREGUNTA = pq.PREGUNTA_CODIGO
>     WHERE
>        pq.ID_ACTIVIDAD = rest.ID_ACTIVIDAD 
>        AND rest.CEDULA_ESTUDIANTE = :2
>        AND rest.ESTADO = 'A'
>        AND rest.CODIGO_RESPUESTA IS NULL 
>        AND pq.COD_TIPO_PREGUNTA = 4 
> `;
>
> export const INICIAR_CRONOMETRO_EVALUACION = `
>     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     SET FECHA_INICIO_EA = SYSDATE, USUARIO_ACTUALIZACION = :1
>     WHERE ID_ACTIVIDAD_ALUMNO = :2
>       AND CEDULA_INTEGRANTE = :3
>       AND FECHA_INICIO_EA IS NULL
> `;
>
> export const REANUDAR_INTENTO_ENTREGADO = `
>     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     SET ENTREGADO = 'NO',
>         FECHA_FIN_EA = NULL,
>         CALIFICACION = NULL,
>         USUARIO_ACTUALIZACION = :1
>     WHERE ID_ACTIVIDAD_ALUMNO = :2
>       AND CEDULA_INTEGRANTE = :3
>       AND ENTREGADO = 'SI'
> `;
>
> // TODO: Agregar guardas NVL al cálculo de FECHAFINISO en esta consulta y en
> // GET_FORMULARIO_BASE, replicando lo que ya hace GET_REGLAS_EVALUACION_RESPONDER.
> // En Oracle FECHA_INICIO_EA + NULL = NULL y LEAST(x, NULL) = NULL, así que si una
> // actividad tiene LIM_TIEMPO_HORAS o LIMITE_TIEMPO en NULL estas dos consultas
> // devuelven FECHAFINISO = NULL mientras la de responder sí calcula un límite real.
> // no se programa el job de auto-calificación (if (reglas.fechaFinISO)), pero
> // /responder empieza a rechazar respuestas con 403 EXPIRADO sin avisar al estudiante.
> export const GET_REGLAS_EVALUACION = `
>     SELECT
>         act.FECHA_INICIO AS "FECHAINICIO",
>         act.FECHA_FIN AS "FECHAFIN",
>         alu.INTENTOS_DISPONIBLES AS "INTENTOSDISPONIBLES",
>         alu.ENTREGADO AS "ENTREGADO",
>         alu.FECHA_INICIO_EA AS "FECHAINICIOEA",
>         UTNDB.LMS_FUN_ACTIVIDAD_ACTIVA(alu.ID_ACTIVIDAD, alu.CEDULA_INTEGRANTE) AS "ESTADOACTIVIDAD",
>         CASE
>             WHEN alu.FECHA_INICIO_EA IS NULL THEN NULL
>             WHEN act.FECHA_FIN IS NULL THEN alu.FECHA_INICIO_EA + (act.LIM_TIEMPO_HORAS / 24) + (act.LIMITE_TIEMPO / 1440)
>             ELSE
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_PRC_EVAL_GUARDAR_RESPUESTA_EMPAREJAR
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_PRC_EVAL_GUARDAR_RESPUESTA_EMPAREJAR')
> -- Usado por: src/modules/evaluacion_online
>
> CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_EVAL_GUARDAR_RESPUESTA_EMPAREJAR (
>     p_cuenta                     IN VARCHAR2,
>     p_id_actividad_alumno        IN NUMBER,
>     p_cedula                     IN VARCHAR2,
>     p_id_pregunta                IN NUMBER,
>     p_id_alternativa             IN NUMBER,
>     p_id_respuesta_seleccionada  IN NUMBER
> ) AS
>     v_id_actividad UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS.ID_ACTIVIDAD%TYPE;
> BEGIN
>     SELECT ID_ACTIVIDAD
>     INTO v_id_actividad
>     FROM UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     WHERE ID_ACTIVIDAD_ALUMNO = p_id_actividad_alumno;
>
>     UPDATE UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE
>     SET ESTADO = 'I', USUARIO_ACTUALIZACION = p_cuenta
>     WHERE ID_ACTIVIDAD = v_id_actividad
>       AND CEDULA_ESTUDIANTE = p_cedula
>       AND CODIGO_PREGUNTA = p_id_pregunta
>       AND CODIGO_RESPUESTA = p_id_alternativa;
>
>     INSERT INTO UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE
>         (ID_ACTIVIDAD, CEDULA_ESTUDIANTE, CODIGO_PREGUNTA, CODIGO_RESPUESTA, RESPUESTA, ESTADO,
>          USUARIO_CREACION, USUARIO_ACTUALIZACION)
>     VALUES
>         (v_id_actividad, p_cedula, p_id_pregunta, p_id_alternativa, p_id_respuesta_seleccionada, 'A',
>          p_cuenta, p_cuenta);
> END;
> /
> ```

> [!example]- `MVL_PRC_EVAL_TOGGLE_RESPUESTA_MULTIPLE` (procedimiento)
> **Resultado:** de punta a punta: curl real y tabla revisada en Oracle antes y después
>
> **Nota del registro:** evaluacion_online, cierra -- MVL_PRC_EVAL_TOGGLE_RESPUESTA_MULTIPLE (consolida
>
> **Lo usa:** `src/modules/evaluacion_online/repository/consultas/evaluacion_online.queries.ts`, `src/modules/evaluacion_online/repository/evaluacion_online.repository.ts`
>
> **Antes** (`src/modules/evaluacion_online/repository/consultas/evaluacion_online.queries.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const GET_FORMULARIO_BASE = `
>     SELECT
>         act.NOMBRE_CORTO AS "TITULO",
>         act.DESCRIPCION AS "DESCRIPCION",
>         pc.CUESTIONARIO_CODIGO AS "IDACTIVIDAD",
>         p.CODIGO AS "PREGUNTAID",
>         p.PREGUNTA_HTML AS "PREGUNTAHTML",
>         p.COD_TIPO_PREGUNTA AS "TIPOPREGUNTA",
>         CASE 
>             WHEN p.ADJUNTO IS NOT NULL AND p.ADJUNTO_MIME LIKE 'image/%' THEN 1 
>         ELSE 0 
>             END AS "TIENEADJUNTO",
>         al.FECHA_INICIO_EA AS "FECHAINICIOISO",
>         CASE
>             WHEN al.FECHA_INICIO_EA IS NULL THEN NULL
>             WHEN act.FECHA_FIN IS NULL THEN al.FECHA_INICIO_EA + (act.LIM_TIEMPO_HORAS / 24) + (act.LIMITE_TIEMPO / 1440)
>             ELSE LEAST(
>                 act.FECHA_FIN,
>                 al.FECHA_INICIO_EA + (act.LIM_TIEMPO_HORAS / 24) + (act.LIMITE_TIEMPO / 1440)
>             )
>         END AS "FECHAFINISO"
>     FROM
>         UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>     INNER JOIN
>         UTNDB.LMS_TAB_PREGUNTAS p ON pc.PREGUNTA_CODIGO = p.CODIGO
>     INNER JOIN
>         UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA act ON pc.CUESTIONARIO_CODIGO = act.ID_ACTIVIDAD
>     INNER JOIN
>         UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS al ON pc.CUESTIONARIO_CODIGO = al.ID_ACTIVIDAD
>                                            AND pc.ESTUDIANTE_CEDULA = al.CEDULA_INTEGRANTE
>     WHERE
>         al.ID_ACTIVIDAD_ALUMNO = :1
>     ORDER BY
>         pc.SUB_ID
> `;
>
> export const GET_ALTERNATIVAS_Y_RESPUESTAS = `
>     WITH PREGUNTAS_ACTIVIDAD AS (
>         SELECT 
>             pc.PREGUNTA_CODIGO,
>             p.COD_TIPO_PREGUNTA,
>             al.ID_ACTIVIDAD
>         FROM 
>             UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO pc
>         INNER JOIN 
>             UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS al 
>             ON pc.CUESTIONARIO_CODIGO = al.ID_ACTIVIDAD 
>             AND pc.ESTUDIANTE_CEDULA = al.CEDULA_INTEGRANTE
>         INNER JOIN
>             UTNDB.LMS_TAB_PREGUNTAS p
>             ON pc.PREGUNTA_CODIGO = p.CODIGO
>         WHERE 
>             al.ID_ACTIVIDAD_ALUMNO = :1 
>     )
>     
>     SELECT
>         r.CODIGO_PREGUNTA AS "PREGUNTAID",
>         r.CODIGO AS "ALTERNATIVAID",
>         r.NOMBRE AS "ALTERNATIVANOMBRE",             
>         r.COLUMNA_EMPAREJAMIENTO,                     
>         r.CALIFICACION AS "ALTERNATIVACALIFICACION",
>         r.RETROALIMENTACION AS "ALTERNATIVARETROALIMENTACION",
>         r.RESPUESTA_NUM AS "RESPUESTANUM",
>         r.ESTADO AS "ESTADORESPUESTA",
>         rest.RESPUESTA AS "RESPUESTAESTUDIANTE",
>         rest.CALIFICACION_ESTUDIANTE AS "CALIFICACIONESTUDIANTE",
>         CASE
>             WHEN COUNT(rest.CODIGO) > 0 THEN 'A'
>             ELSE 'I'
>         END AS "ALTERNATIVAESTADO"
>     FROM
>         UTNDB.LMS_TAB_RESPUESTAS r
>     INNER JOIN 
>         PREGUNTAS_ACTIVIDAD pq ON r.CODIGO_PREGUNTA = pq.PREGUNTA_CODIGO
>     LEFT JOIN
>         UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE rest
>         ON r.CODIGO = rest.CODIGO_RESPUESTA
>        AND pq.ID_ACTIVIDAD = rest.ID_ACTIVIDAD 
>        AND rest.CEDULA_ESTUDIANTE = :2
>        AND rest.ESTADO = 'A'
>     WHERE
>         pq.COD_TIPO_PREGUNTA <> 4 
>     GROUP BY
>         r.CODIGO_PREGUNTA,
>         r.CODIGO,
>         r.NOMBRE,
>         r.COLUMNA_EMPAREJAMIENTO,
>         r.CALIFICACION,
>         r.RETROALIMENTACION,
>         r.RESPUESTA_NUM,
>         r.ESTADO,
>         rest.RESPUESTA,
>         rest.CALIFICACION_ESTUDIANTE
>
>     UNION ALL
>
>     SELECT
>         rest.CODIGO_PREGUNTA AS "PREGUNTAID",
>         NULL AS "ALTERNATIVAID",
>         NULL AS "ALTERNATIVANOMBRE",             
>         NULL AS "COLUMNA_EMPAREJAMIENTO",                     
>         NULL AS "ALTERNATIVACALIFICACION",
>         NULL AS "ALTERNATIVARETROALIMENTACION",
>         NULL AS "RESPUESTANUM",
>         NULL AS "ESTADORESPUESTA",
>         rest.RESPUESTA AS "RESPUESTAESTUDIANTE",
>         rest.CALIFICACION_ESTUDIANTE AS "CALIFICACIONESTUDIANTE",
>         'A' AS "ALTERNATIVAESTADO"
>     FROM
>         UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE rest
>     INNER JOIN 
>         PREGUNTAS_ACTIVIDAD pq ON rest.CODIGO_PREGUNTA = pq.PREGUNTA_CODIGO
>     WHERE
>        pq.ID_ACTIVIDAD = rest.ID_ACTIVIDAD 
>        AND rest.CEDULA_ESTUDIANTE = :2
>        AND rest.ESTADO = 'A'
>        AND rest.CODIGO_RESPUESTA IS NULL 
>        AND pq.COD_TIPO_PREGUNTA = 4 
> `;
>
> export const INICIAR_CRONOMETRO_EVALUACION = `
>     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     SET FECHA_INICIO_EA = SYSDATE, USUARIO_ACTUALIZACION = :1
>     WHERE ID_ACTIVIDAD_ALUMNO = :2
>       AND CEDULA_INTEGRANTE = :3
>       AND FECHA_INICIO_EA IS NULL
> `;
>
> export const REANUDAR_INTENTO_ENTREGADO = `
>     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     SET ENTREGADO = 'NO',
>         FECHA_FIN_EA = NULL,
>         CALIFICACION = NULL,
>         USUARIO_ACTUALIZACION = :1
>     WHERE ID_ACTIVIDAD_ALUMNO = :2
>       AND CEDULA_INTEGRANTE = :3
>       AND ENTREGADO = 'SI'
> `;
>
> // TODO: Agregar guardas NVL al cálculo de FECHAFINISO en esta consulta y en
> // GET_FORMULARIO_BASE, replicando lo que ya hace GET_REGLAS_EVALUACION_RESPONDER.
> // En Oracle FECHA_INICIO_EA + NULL = NULL y LEAST(x, NULL) = NULL, así que si una
> // actividad tiene LIM_TIEMPO_HORAS o LIMITE_TIEMPO en NULL estas dos consultas
> // devuelven FECHAFINISO = NULL mientras la de responder sí calcula un límite real.
> // no se programa el job de auto-calificación (if (reglas.fechaFinISO)), pero
> // /responder empieza a rechazar respuestas con 403 EXPIRADO sin avisar al estudiante.
> export const GET_REGLAS_EVALUACION = `
>     SELECT
>         act.FECHA_INICIO AS "FECHAINICIO",
>         act.FECHA_FIN AS "FECHAFIN",
>         alu.INTENTOS_DISPONIBLES AS "INTENTOSDISPONIBLES",
>         alu.ENTREGADO AS "ENTREGADO",
>         alu.FECHA_INICIO_EA AS "FECHAINICIOEA",
>         UTNDB.LMS_FUN_ACTIVIDAD_ACTIVA(alu.ID_ACTIVIDAD, alu.CEDULA_INTEGRANTE) AS "ESTADOACTIVIDAD",
>         CASE
>             WHEN alu.FECHA_INICIO_EA IS NULL THEN NULL
>             WHEN act.FECHA_FIN IS NULL THEN alu.FECHA_INICIO_EA + (act.LIM_TIEMPO_HORAS / 24) + (act.LIMITE_TIEMPO / 1440)
>             ELSE
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_PRC_EVAL_TOGGLE_RESPUESTA_MULTIPLE
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=VALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_PRC_EVAL_TOGGLE_RESPUESTA_MULTIPLE')
> -- Usado por: src/modules/evaluacion_online
>
> CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_EVAL_TOGGLE_RESPUESTA_MULTIPLE (
>     p_cuenta                IN VARCHAR2,
>     p_id_actividad_alumno   IN NUMBER,
>     p_cedula                IN VARCHAR2,
>     p_id_pregunta           IN NUMBER,
>     p_id_alternativa        IN NUMBER,
>     p_marcado               IN VARCHAR2
> ) AS
>     v_id_actividad UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS.ID_ACTIVIDAD%TYPE;
> BEGIN
>     SELECT ID_ACTIVIDAD
>     INTO v_id_actividad
>     FROM UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
>     WHERE ID_ACTIVIDAD_ALUMNO = p_id_actividad_alumno;
>
>     UPDATE UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE
>     SET ESTADO = 'I', USUARIO_ACTUALIZACION = p_cuenta
>     WHERE ID_ACTIVIDAD = v_id_actividad
>       AND CEDULA_ESTUDIANTE = p_cedula
>       AND CODIGO_PREGUNTA = p_id_pregunta
>       AND CODIGO_RESPUESTA = p_id_alternativa;
>
>     IF p_marcado = 'S' THEN
>         INSERT INTO UTNDB.LMS_TAB_RESPUESTAS_ESTUDIANTE
>             (ID_ACTIVIDAD, CEDULA_ESTUDIANTE, CODIGO_PREGUNTA, CODIGO_RESPUESTA, ESTADO,
>              USUARIO_CREACION, USUARIO_ACTUALIZACION)
>         VALUES
>             (v_id_actividad, p_cedula, p_id_pregunta, p_id_alternativa, 'A',
>              p_cuenta, p_cuenta);
>     END IF;
> END;
> /
> ```

> [!example]- `MVL_PRC_MODAL_MARCAR_VISTO` (procedimiento)
> **Resultado:** de punta a punta: curl real y tabla revisada en Oracle antes y después
>
> **Lo usa:** `src/modules/modales_informativos/repository/consultas/marcar_modal.consulta.ts`
>
> **Antes** (`src/modules/modales_informativos/repository/consultas/marcar_modal.consulta.ts`, versión previa al commit `18138f6`):
>
> ```ts
> export const MARCAR_MODAL_COMO_VISTO = `
> INSERT INTO UTNDB.ENC_TAB_ENCUESTA_USUARIO (
>     ENCUESTA_USUARIO_ID,
>     ENCUESTA_CODIGO,
>     CEDULA_USUARIO,
>     ESTADO,
>     FECHA,
>     OBSERVACION
> ) VALUES (
>     (SELECT NVL(MAX(ENCUESTA_USUARIO_ID), 0) + 1 FROM UTNDB.ENC_TAB_ENCUESTA_USUARIO),
>     :codigoEncuesta,
>     :cedula,
>     'A',
>     SYSDATE,
>     'PORTAFOLIO ESTUDIANTE MÓVIL'
> )
> `;
> ```
>
> **Script del objeto:**
>
> ```sql
> -- Objeto:   MOVIL_UTN.MVL_PRC_MODAL_MARCAR_VISTO
> -- Obtenido: 2026-09-24, entorno de desarrollo (réplica), STATUS=INVALID
> -- Vía:      ALL_SOURCE (OWNER='MOVIL_UTN', NAME='MVL_PRC_MODAL_MARCAR_VISTO')
> -- Usado por: src/modules/modales_informativos
>
> CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_MODAL_MARCAR_VISTO (
>     P_CODIGO_ENCUESTA IN  UTNDB.ENC_TAB_ENCUESTA_USUARIO.ENCUESTA_CODIGO%TYPE,
>     P_CEDULA          IN  UTNDB.ENC_TAB_ENCUESTA_USUARIO.CEDULA_USUARIO%TYPE,
>     P_INSERTADO       OUT NUMBER
> ) AS
>     V_EXISTE NUMBER;
> BEGIN
>     SELECT COUNT(*)
>     INTO V_EXISTE
>     FROM UTNDB.ENC_TAB_ENCUESTA_USUARIO
>     WHERE ENCUESTA_CODIGO = P_CODIGO_ENCUESTA
>       AND CEDULA_USUARIO = P_CEDULA;
>
>     IF V_EXISTE = 0 THEN
>         INSERT INTO UTNDB.ENC_TAB_ENCUESTA_USUARIO (
>             ENCUESTA_USUARIO_ID,
>             ENCUESTA_CODIGO,
>             CEDULA_USUARIO,
>             ESTADO,
>             FECHA,
>             OBSERVACION
>         ) VALUES (
>             (SELECT NVL(MAX(ENCUESTA_USUARIO_ID), 0) + 1 FROM UTNDB.ENC_TAB_ENCUESTA_USUARIO),
>             P_CODIGO_ENCUESTA,
>             P_CEDULA,
>             'A',
>             SYSDATE,
>             'PORTAFOLIO ESTUDIANTE MÓVIL'
>         );
>         P_INSERTADO := 1;
>     ELSE
>         P_INSERTADO := 0;
>     END IF;
> END MVL_PRC_MODAL_MARCAR_VISTO;
> /
> ```
