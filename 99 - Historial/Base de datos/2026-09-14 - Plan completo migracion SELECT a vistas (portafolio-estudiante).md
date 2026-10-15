# Plan completo — Migrar `SELECT` quemados a vistas/funciones Oracle (`utn-movil-portafolio-estudiante`)

**Fecha:** 2026-09-14
**Para qué sirve esta nota:** es un **backup de un plan de Claude Code**, escrito para que se pueda
pegar en un chat **totalmente nuevo** (sin el contexto de la conversación original) y esa sesión pueda
seguir exactamente donde se quedó, sin repreguntar nada de lo que ya se investigó. Contiene el
análisis completo sentencia por sentencia de las 150 consultas SQL del repo (hecho por 3 subagentes de
exploración + análisis manual), no solo el resumen.

Notas relacionadas en este vault: Registro de queries (auditoría original 2026-09-09, la que
generó el índice de "posibles" queries quemadas) y `07 - Documentacion/2026-09-14 - Como trabajamos la
migracion de queries a vistas (continuidad).md` (metodología + estado del piloto `foro_online`, que ya
está terminado y no se repite en detalle aquí — léela primero si no la has visto).

---

## 0. El encargo, en una frase

En `utn-movil-portafolio-estudiante` hay ~150 sentencias SQL escritas literalmente (*hardcoded*) en
archivos `.ts`. Si el DBA cambia una tabla/columna en Oracle, el código no se entera y el servicio
falla en producción sin aviso. La tarea es mover esa lógica a objetos de Oracle (vistas y funciones en
el esquema `MOVIL_UTN`) para que el `.ts` solo los invoque, y que un cambio de esquema se corrija en el
DDL (lo hace el DBA) sin tocar ni redesplegar la app.

## 1. Decisión de alcance del usuario (2026-09-14, la más reciente — **manda sobre cualquier cosa que diga lo contrario más abajo**)

> "No haré las triviales, ya está resuelto tampoco haré, código muerto [tampoco]."

Es decir: de las 6 categorías de lectura (ver §3), **solo se trabajan V1, V2 y F**. Quedan
explícitamente **fuera de esta migración**, sin abrir ningún objeto nuevo para ellas:

- **T (trivial)** — 18 sentencias. Son `SELECT 1 FROM DUAL`, o una tabla con 1-2 columnas sin `JOIN`.
  Técnicamente podrían ser vista, pero no aportan nada (el "riesgo" que resuelve una vista —que el
  código no se entere de un cambio de esquema— es mínimo en una consulta de una sola columna).
- **YA (ya resuelto)** — 11 sentencias. Ya consumen una vista `MOVIL_UTN.MVL_VIEW_*` existente o solo
  llaman a una función/procedimiento ya creado. No hay nada que migrar.
- **M (código muerto)** — 6 sentencias. La constante no se importa en ningún lado, o el método que la
  usa no tiene llamadores fuera de tests. No tiene sentido crear un objeto de BD para código que no
  corre.

Lo que sí se trabaja, en este orden de prioridad (menor a mayor riesgo):
1. **V1 — vista directa** (26 sentencias): el bind solo filtra una columna simple. Se copia el SQL tal
   cual, quitando el filtro, y el `.ts` hace `WHERE columna = :bind` sobre la vista.
2. **V2 — vista con reescritura** (26 sentencias): se puede hacer vista, pero hay que reescribir una
   parte del SQL (la subquery clásica `cuenta → cédula` pasa a `JOIN`; una rama de `UNION` expone una
   columna que hoy no expone; etc.). Requiere más cuidado al validar.
3. **F — función con `SYS_REFCURSOR`** (18 sentencias): no se puede como vista sin cambiar el
   resultado (bind dentro de `CONNECT BY`, de un `CASE`, de un `LEFT JOIN`/`EXISTS` correlacionado,
   antes de un agregado, o como argumento de una función PL/SQL). Se resuelve como función, con el
   mismo patrón que `MVL_FUN_FORO_GENERAL`/`MVL_FUN_FORO_ACTIVIDAD` del piloto.

Las **45 sentencias de escritura** (`INSERT`/`UPDATE`/`MERGE`/bloques PL/SQL) tampoco se tocan ahora:
son la **fase de procedimientos**, posterior y separada (igual que se decidió para `foro_online`).

## 2. Metodología (igual que en el piloto `foro_online`, ya probada)

1. **El usuario crea y valida los objetos en la réplica de dev**, conectado a Toad como `MOVIL_UTN`.
   el DDL se entrega **en el chat, un objeto a la vez**, nunca como archivos sueltos en el repo (se
   probó ponerlos en `docs/db-scripts/` y se revirtió: ensucia el repo sin necesidad).
2. **Validación de vistas:** `(query literal con binds reales) MINUS (SELECT ... FROM vista WHERE ...)`
   en los dos sentidos, debe dar 0 filas. Si el resultado tiene una columna `CLOB`, `MINUS` truena con
   `ORA-22848`; se envuelve con `DBMS_LOB.SUBSTR(columna, 4000, 1)` en ambos lados **solo para la
   comparación** (la vista no cambia).
3. **Validación de funciones:** en Toad, un bloque anónimo con `DBMS_SQL.RETURN_RESULT(cursor)`
   muestra el resultado como grid; se compara fila por fila (conteo, orden, valores) contra correr la
   query literal envuelta en el mismo truco.
   contra la réplica de dev) y pegarle a los endpoints reales con `curl` antes y después del cambio de
   código. Si el JSON sale idéntico, es la prueba definitiva — pasa por TypeORM/`oracledb` de verdad,
   no solo por SQL en Toad.
5. **Cómo llega un `SYS_REFCURSOR` a través de TypeORM/`oracledb`** (confirmado en la práctica con
   `foro_online`, no solo por lectura de código): `dataSource.query()` en modo Oracle usa
   Una función `SYS_REFCURSOR` llamada como `SELECT MOVIL_UTN.MVL_FUN_X(:1,...) AS FILAS FROM DUAL`
   llega como `[{ FILAS: [ {...fila1}, {...fila2} ] }]` — `oracledb` trata una columna `DB_TYPE_CURSOR`
   como cursor anidado y lo trae completo (`oracledb/lib/impl/resultset.js:235`). En el repositorio:
   ```ts
   const resultados: { FILAS: Object[] }[] = await this.dataSource.query(QUERY, [...binds]);
   return plainToInstance(Dto, resultados[0]?.FILAS ?? []);
   ```
6. **Nombres de objetos ≤ 30 caracteres** (por si la instancia es anterior a Oracle 12.2).
7. **Copiar el SQL literal**, sin "arreglarlo" de paso (no corregir el desfase de 5 h de `SYSDATE`, no
   tocar bugs que se noten al leer — eso se documenta como hallazgo aparte, no se resuelve aquí).
8. **`%TYPE` en los parámetros de las funciones** (`UTNDB.TABLA.COLUMNA%TYPE`) para que un cambio de
   tipo en la BD se refleje solo.

### 2.1 Reglas de `git` en este repo (recordatorio, viene del `CLAUDE.md` global del usuario)

- 🚫 Nunca `commit`, `push`, `checkout`/cambio de rama, `merge`, `pull` en ningún repo de
- **Excepción concedida el 2026-09-14:** `git stash`/`git stash pop` sí, pero **exclusivamente para
  comparar contra el estado previo** (p. ej. confirmar si un test roto ya fallaba antes del cambio),
  nunca para cambiar de rama ni traer remoto, siempre con `pop` inmediato en el mismo turno y avisando
  al usuario que se usó.
- Al 2026-09-14, el repo está parado directo en la rama `practicas-preprofesionales` (sin rama propia
  creada todavía), con 7 archivos sin commitear (los del piloto `foro_online`). ⚠ Push a esa rama **es
  sí).

### 2.2 Cuentas y datos de prueba en la réplica de dev (reutilizables)

  `src/config/entorno.ts`).
  nombre "PRUEBA ESTUDIANTE".
- Docente de prueba: `<cuenta-de-prueba>` → `cedula=<cedula>`, "PRUEBA DOCENTE" (usado como autor en varios
  registros, no se ha usado para *crear* nada todavía).
- Materia de prueba con datos reales: `idCurso=54443`, `materiaCodigo=CAPRU-MATPRU`,
  `depenCodigo=99999`, `nivelCodigo=01`, `cicloAcadCodigo=1021-1099`, `modaEstudCodigo=01`,
  `sistEstudCodigo=02`, `tcicloacadCodigo=02`, `tfinanciaCodigo=01`, `instCodigo=001` (ciclo activo de
- Actividad de estudiante con foro (usada en el piloto): `idActividad=627065` ("future"),
  `idActividadAlumno=18516355`.
- Comando para levantar el servicio local: `pnpm run start:dev` desde la raíz del repo (necesita

## 3. Piloto `foro_online` — YA TERMINADO (no repetir)

Los 6 `SELECT` de `foro_online` están migrados, validados en dev y probados end-to-end (curl
antes/después idéntico): 4 vistas (`MVL_VIEW_FORO_TIPO`, `MVL_VIEW_FORO_ACT_ESTADO`,
`MVL_VIEW_FORO_AUTORES`, `MVL_VIEW_FORO_INSTRUC_ACT`) + 2 funciones con `SYS_REFCURSOR`
(`MVL_FUN_FORO_ACTIVIDAD`, `MVL_FUN_FORO_GENERAL`). Código cambiado (sin commitear):
`foro_online.repository.ts` + 6 `consultas/*.query.ts`. `pnpm run build` compila limpio.

**Hallazgo de paso, ya documentado:** `foro_online.service.spec.ts` ya estaba roto **antes** de esta
migración (errores de tipos `string`/`number` y una propiedad `foto` que no existe en `AutorForoDto`),
confirmado con `git stash` + `npx jest foro_online` sobre el código previo. No se arregló (fuera de
alcance). Ver `Descubrimientos queries/2026-09-14 - foro_online.service.spec ya estaba roto antes de
migrar.md`.

Detalle completo del piloto (mapeo archivo→objeto, DDL usado, pasos exactos que se siguieron) en
`07 - Documentacion/2026-09-14 - Como trabajamos la migracion de queries a vistas (continuidad).md`.

## 4. `ficha_estudiante` — analizado, sin empezar a migrar


| Archivo | Constante | Categoría | Detalle |
|---|---|---|---|
| `repository/consultas/ficha_estudiante_consulta.ts` | `FICHA_ESTUDIANTE_CONSULTA` | **V2** (con una decisión pendiente, ver abajo) | Join a `RHU_TAB_PERSONAS + INS_TAB_LOCALIDADES + ACA_TAB_ESTUDIANTES` con 4 llamadas a `FUN_INST_OBTENER_LOCALIDAD`. El bind `:cuenta` aparece **dos veces**: dentro de `LMS_PCK_AULAS_VIRTUALES.LMS_FUN_CEDULA_USUARIO(:cuenta)` en un `LEFT JOIN`, y en una subquery `WHERE cuenta = :cuenta` contra `INS_TAB_USUARIOS`. |

**Detalle importante sobre el bind repetido:** en SQL normal (no PL/SQL), Oracle trata un bind
**con el mismo nombre repetido como la misma variable** — no hace falta pasar dos valores en el
array (a diferencia de `:1,:2` posicionales numerados, que sí son siempre distintos). Por eso
`dataSource.query(FICHA_ESTUDIANTE_CONSULTA, [cuenta])` con un solo valor funciona hoy pese a que
`:cuenta` aparece dos veces en el texto. Ojo con esto al escribir la función: dentro de PL/SQL un
parámetro se puede referenciar tantas veces como haga falta sin ningún problema, así que no cambia
nada para la función — es solo una aclaración de por qué el código actual no está roto.

**Decisión pendiente (quedó sin resolver, hay que preguntársela al usuario cuando se retome este
módulo):**

- **Opción A — función con `SYS_REFCURSOR`, SQL literal intacto (recomendada, menor riesgo):** se
  copia el `SELECT` tal cual (mismo `JOIN` con la función de paquete, misma subquery) dentro de una
  función PL/SQL con un solo parámetro `p_cuenta`. Cero riesgo de cambiar el plan de ejecución.
- **Opción B — vista, reescribiendo el `JOIN`:** cambiar el `LEFT JOIN` que usa
  `LMS_FUN_CEDULA_USUARIO(:cuenta)` por un `JOIN` directo a `INS_TAB_USUARIOS` por `CUENTA` (la propia
  query ya hace esa resolución en el `WHERE`), dejando un `WHERE CUENTA = :cuenta` simple → queda como
  vista pura. Es una reescritura real, no una copia literal, y `LMS_FUN_CEDULA_USUARIO` se reutiliza
  también en `aula_virtual` con el mismo patrón (fuera de alcance tocarlo ahí).

No se ha creado ningún objeto de BD ni tocado código de `ficha_estudiante` todavía.

## 5. Inventario completo — las 150 sentencias, sentencia por sentencia

Se dividió el repo en 3 franjas para 3 subagentes de exploración en paralelo (más `ficha_estudiante`,
analizado antes por separado, y `foro_online`, ya migrado). Cobertura: **todo `src/`**, incluido código
inline en repositorios/servicios, no solo `repository/consultas/`.

Leyenda de categorías: **V1** vista directa · **V2** vista con reescritura · **F** función con
`SYS_REFCURSOR` · **T** trivial (fuera de alcance, ver §1) · **M** código muerto (fuera de alcance) ·
**YA** ya resuelto (fuera de alcance) · **D** SQL dinámico (no apareció ninguno en todo el repo) ·
**W** escritura (fase de procedimientos, no ahora). **(s/e)** = objeto Oracle sin prefijo de esquema en
el texto (depende de sinónimos).

### 5.1 Franja A — `aula_virtual`, `evaluacion_online`, `actividades`, `calendario_actividades`, `pagos`, `documentos_directorio`, `shared`, `parametros_servidor_reportes`, `config/estado_app`, `config/estado_modulos`, `health`

**Resumen:** 45 sentencias → 9 V1, 9 V2, 4 F, 6 T, 2 M, 4 YA, 11 W, 0 D.

#### aula_virtual (`src/modules/aula_virtual/respository/`) — 14 sentencias: 2 V1, 5 V2, 2 F, 1 T, 4 YA

| Archivo:línea | Constante/método | Cat. | Binds | Objetos Oracle | Notas |
|---|---|---|---|---|---|
| `aula_virtual_repository.ts:36` | `parcialActiva()` inline | YA | `UTNDB.LMS_FUN_PARCIAL_ACTIVA(:P110_ID_CURSO,:PARCIAL)` en SELECT, FROM DUAL | UTNDB.LMS_FUN_PARCIAL_ACTIVA | Solo llama función; se invoca 3× en paralelo (N1/N2/N3) |
| `consultas/nota_parcial_consulta.ts:1` | `NOTA_PARCIAL_CONSULTA` | YA | `LMS_FUN_CALCULAR_PARCIAL(:idCurso,:cedula,:codigoParcial)`, FROM DUAL | UTNDB.LMS_FUN_CALCULAR_PARCIAL | Binds en orden correcto |
| `consultas/detalles_notas_parcial_1_consulta.ts` (L2-237) | `DETALLES_NOTAS_PARCIAL_1_CONSULTA` | V2 | Filtros simples `CODIGO_PARCIAL=:P212_CODIGO_PARCIAL` (ON+WHERE); 3 binds repetidos dentro de 6 subconsultas escalares en la lista SELECT | LMS_TAB_ACTIVIDAD_ACADEMICA, ACA_TAB_TIPOS_PORCENTAJE_EVAL, LMS_TAB_ACTIVIDADES_ALUMNOS, ACA_TAB_PORCENTAJES_EVAL(s/e), LMS_TAB_AULAS_VIRTUALES(s/e) | >230 líneas. Reescritura: correlacionar subconsultas con columnas externas (`ACT_ALUM.ID_CURSO` etc.) o `SUM/COUNT(...) OVER(PARTITION BY ID_CURSO,CEDULA_INTEGRANTE,CODIGO_PARCIAL,CODIGO_TIPO_EVAL)`. `(cols)=(SELECT DISTINCT...)` da ORA-01427 si >1 fila |
| `consultas/detalles_notas_parcial_2_consulta.ts` | `DETALLES_NOTAS_PARCIAL_2_CONSULTA` | V2 | Igual que N1, cambia `porcentaje_n2` | Igual que N1 | Casi idéntica a N1 — **una sola vista podría cubrir N1/N2/N3** con `DECODE(CODIGO_PARCIAL,...)` |
| `consultas/detalles_notas_parcial_3_consulta.ts` | `DETALLES_NOTAS_PARCIAL_3_CONSULTA` | V2 | Igual, `porcentaje_n3` | Igual que N1 | Solo cambia el `round(...,2)` vs 3 |
| `consultas/calendario_actividades_aula_virtual_consulta.ts` | `CALENDARIO_ACTIVIDADES_AULA_VIRTUAL_CONSULTA` | V1 | `AULA.ID_CURSO=:P110_ID_CURSO AND USUARIO.CUENTA=:CUENTA` | LMS_TAB_ACTIVIDAD_ACADEMICA, LMS_TAB_AULAS_VIRTUALES, ACA_TAB_CICLOS_ACADEMICOS, LMS_TAB_INTEGRANTES, ACA_TAB_MATERIAS, INS_TAB_USUARIOS, LMS_TAB_ACTIVIDADES_ALUMNOS (todas s/e) | `SELECT DISTINCT` |
| `consultas/lista_actividades_consulta.ts` | `LISTA_ACTIVIDADES_CONSULTA` | V1 | `CODIGO_PARCIAL=:P212_CODIGO_PARCIAL` (ON+WHERE); `ID_CURSO=:P212_ID_CURSO`; `CEDULA_INTEGRANTE=:P212_CEDULA_INTEGRANTE` | UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA, UTNDB.ACA_TAB_TIPOS_PORCENTAJE_EVAL, UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS | **Bind repetido: 4 apariciones, el repo pasa 3 valores** — probado en vivo, responde 200 sin error (ver §7) |
| `consultas/lista_actividades_y_recursos_consulta.ts` (L2-148) | `LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA` | **F** | (a) `CASE WHEN :nivelCodigo != 'AD'` en SELECT; (b) `LMS_PCK_AULAS_VIRTUALES.LMS_FUN_CEDULA_USUARIO(:cuenta)` en ON de JOIN; (c) `LIKE :parcial` solo en rama A; (d) 9 binds en ON de LEFT JOIN a `ACA_TAB_CONTENIDOS_MATERIAS`; (e) `START WITH CM.CODIGO=:codigoContenido CONNECT BY` dentro de IN; (f) filtros simples `ID_CURSO`,`TIPO_VISTA`,`MATERIA_CODIGO` | LMS_TAB_ACTIVIDAD_ACADEMICA(s/e), ACA_TAB_TIPOS_PORCENTAJE_EVAL(s/e), LMS_TAB_ACTIVIDADES_ALUMNOS(s/e), **LMS_PCK_AULAS_VIRTUALES(s/e, paquete)**, UTNDB.DOC_TAB_TAREA_ALU_DOCUMENTO, LMS_TAB_RECURSOS(s/e), LMS_TAB_TIPO_RECURSO(s/e), UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO, ACA_TAB_CONTENIDOS_MATERIAS(s/e) | UNION+CONNECT BY+SYSDATE en CASE. La service siempre pasa `parcial=""` y `tipoVista="R"` → **la rama A (actividades) nunca devuelve filas** (código muerto de facto, pero no se cuenta como M porque la constante sí se usa). Bind mal alineado (ver §7) |
| `consultas/inasistencia_consulta.ts` | `INASISTENCIA_CONSULTA` | YA | 13 binds como argumentos de `UTNDB.FUN_PORCENTAJE_INASISTENCIA(...)`, FROM DUAL | UTNDB.FUN_PORCENTAJE_INASISTENCIA | — |
| `consultas/asistencias_consulta.ts` | `ASISTENCIAS_CONSULTA` | T (sería V1) | `WHERE CICLO_ACAD_CODIGO=... AND MATERIA_CODIGO=... AND CEDULA=:G_CEDULA_USUARIO` | UTNDB.LMS_VIEW_ASISTENCIA_ESTUDIANTE (ya es vista de UTNDB) | 2 columnas, sin JOIN |
| `consultas/avance_materia_consulta.ts` | `AVANCE_MATERIA_CONSULTA` | YA | 11 binds como argumentos de `UTNDB.LMS_FUN_PORCENTAJE_EJECUTADO(...)` dentro de ROUND, FROM DUAL | UTNDB.LMS_FUN_PORCENTAJE_EJECUTADO | — |
| `consultas/distribucion_materia_consulta.ts` | `DISTRIBUCION_MATERIA_CONSULTA` | V2 | 9 filtros simples dentro de vista en línea; fuera, `WHERE CONTE_MATE_CODIGO=:P9_CODIGO_CONTENIDO` sobre un DECODE | UTNDB.ACA_TAB_CONTENIDOS_MATERIAS, UTNDB.ACA_TAB_TIPOS_CONTENIDOS | Reescritura: aplanar y exponer las 9 columnas + el DECODE como columna |
| `consultas/contenido_materia_consulta.ts` | `CONTENIDO_MATERIA_CONSULTA` | **F** | 9 binds + `:P9_NIVEL_CODIGO`,`:P9_MATERIA_CODIGO` **dentro del subquery que alimenta `START WITH...CONNECT BY PRIOR`** | ACA_TAB_CONTENIDOS_MATERIAS, ACA_TAB_TIPOS_CONTENIDOS, ACA_TAB_MATERIAS (s/e) | UNION+CONNECT BY+LEVEL. La service arma el árbol con LEVEL — filtrar fuera cambiaría la jerarquía |
| `consultas/silabo_consulta.ts` | `SILABO_CONSULTA` | V2 (estrictamente sería F) | `:cedulaDocente` y `:CUENTA` en la lista SELECT (concatenados en URL); filtros `ID_CURSO=:idCurso AND CEDULA_DOCENTE=:cedulaDocente`; ROWNUM=1 | INS_TAB_PARAMETROS, LMS_TAB_AULAS_VIRTUALES, ACA_TAB_DISTRIBUTIVOS, ACA_TAB_MATERIAS (s/e) | ⚠ **HALLAZGO DE SEGURIDAD** — ver §6.1. **No migrar sin resolver antes ese hallazgo.** Bind repetido: 3 valores para 4 apariciones |

#### evaluacion_online (`src/modules/evaluacion_online/repository/consultas/evaluacion_online.queries.ts`) — 17 sentencias: 4 V1, 2 V2, 1 F, 1 T, 9 W

| Línea | Constante | Cat. | Binds | Objetos | Notas |
|---|---|---|---|---|---|
| L1 | `GET_FORMULARIO_BASE` | V1 | `WHERE al.ID_ACTIVIDAD_ALUMNO=:1` | UTNDB.LMS_TAB_PREGUNTAS_CUESTIONARIO, LMS_TAB_PREGUNTAS, LMS_TAB_ACTIVIDAD_ACADEMICA, LMS_TAB_ACTIVIDADES_ALUMNOS | `PREGUNTA_HTML` posible CLOB (sin confirmar). `ADJUNTO` solo en `IS NOT NULL`. **TODO existente en el código: falta NVL en FECHAFINISO (L140-147)** — no se resuelve al migrar, se documenta tal cual |
| L37 | `GET_ALTERNATIVAS_Y_RESPUESTAS` | **F** | `:1` simple en CTE; `rest.CEDULA_ESTUDIANTE=:2` **en ON de LEFT JOIN** con GROUP BY (rama 1); `:2` en WHERE (rama 2) | LMS_TAB_PREGUNTAS_CUESTIONARIO, LMS_TAB_ACTIVIDADES_ALUMNOS, LMS_TAB_PREGUNTAS, LMS_TAB_RESPUESTAS, LMS_TAB_RESPUESTAS_ESTUDIANTE | WITH/CTE+UNION ALL. Sería V2 si `:2` se sustituye por `al.CEDULA_INTEGRANTE`, pero **`getFormulario` no valida que `:2` sea el dueño del intento** — con otra cédula hoy da alternativas sin respuestas, con vista daría 0 filas. ⚠ posible diferencia de comportamiento si se reescribe mal, mejor F literal. Bind repetido: 2 valores para 3 apariciones |
| L121 | `INICIAR_CRONOMETRO_EVALUACION` | W | UPDATE | LMS_TAB_ACTIVIDADES_ALUMNOS | SYSDATE |
| L129 | `REANUDAR_INTENTO_ENTREGADO` | W | UPDATE | ídem | — |
| L148 | `GET_REGLAS_EVALUACION` | V1 | `WHERE alu.ID_ACTIVIDAD_ALUMNO=:1` | LMS_TAB_ACTIVIDAD_ACADEMICA, LMS_TAB_ACTIVIDADES_ALUMNOS, UTNDB.LMS_FUN_ACTIVIDAD_ACTIVA | También la usa el processor BullMQ |
| L172 | `GET_REGLAS_EVALUACION_RESPONDER` | V1 | `WHERE alu.ID_ACTIVIDAD_ALUMNO=:1` | LMS_TAB_ACTIVIDADES_ALUMNOS, LMS_TAB_ACTIVIDAD_ACADEMICA | Cálculo con NVL |
| L199 | `DESACTIVAR_RESPUESTAS_PREGUNTA` | W | UPDATE con subquery | LMS_TAB_RESPUESTAS_ESTUDIANTE, LMS_TAB_ACTIVIDADES_ALUMNOS | — |
| L211 | `INSERTAR_NUEVA_RESPUESTA` | W | INSERT...VALUES((SELECT...)) | ídem | `:6` repetido |
| L230 | `INSERTAR_RESPUESTA_MULTIPLE` | W | INSERT | ídem | `:5` repetido |
| L247 | `ELIMINAR_RESPUESTA_MULTIPLE` | W | UPDATE | ídem | — |
| L260 | `FINALIZAR_EVALUACION` | W | Bloque PL/SQL | LMS_TAB_ACTIVIDADES_ALUMNOS, LMS_PRC_CALIFICAR_EVALUACION | ⚠ Hay **otra constante con el mismo nombre** en `evaluacion_docentes/.../evaluacion_docentes.queries.ts:282`, independiente |
| L277 | `GET_RESULTADO_NOTA_FINAL` | T (sería V1) | `WHERE ID_ACTIVIDAD_ALUMNO=:1 AND CEDULA_INTEGRANTE=:2` | LMS_TAB_ACTIVIDADES_ALUMNOS | 1 tabla, 1 columna |
| L287 | `GET_RESULTADO_DETALLE` | V2 | `WHERE AL.ID_ACTIVIDAD_ALUMNO=:1` **antes de `COUNT(*) OVER()`** | LMS_TAB_PREGUNTAS_CUESTIONARIO, LMS_TAB_PREGUNTAS, LMS_TAB_TIPO_PREGUNTA, LMS_TAB_ACTIVIDADES_ALUMNOS | Reescritura: `COUNT(*) OVER(PARTITION BY AL.ID_ACTIVIDAD_ALUMNO)` — es equivalente. `PREGUNTA_HTML` posible CLOB |
| L309 | `CONTAR_PREGUNTAS_RESPONDIDAS` | V2 | `re.ID_ACTIVIDAD=(SELECT...WHERE ID_ACTIVIDAD_ALUMNO=:1)` y `re.CEDULA_ESTUDIANTE=:2`, antes de `COUNT(DISTINCT)` | LMS_TAB_RESPUESTAS_ESTUDIANTE, LMS_TAB_ACTIVIDADES_ALUMNOS | Reescritura: JOIN + GROUP BY + filtro fuera. **El repo ya cubre el caso 0 filas** con `result[0]?.total \|\| 0` |
| L324 | `DESACTIVAR_RESPUESTA_EMPAREJAR` | W | UPDATE con EXISTS | ídem | — |
| L338 | `INSERTAR_RESPUESTA_EMPAREJAR` | W | INSERT | ídem | `:6` repetido |
| L356 | `IMAGEN_PREGUNTA_QUERY` | V1 | `WHERE CODIGO=:codigoPregunta` | UTNDB.LMS_TAB_PREGUNTAS | **BLOB `ADJUNTO`** (DTO lo trata como Buffer) |

#### actividades — 3 sentencias: 1 V1, 2 W
`get_info_tarea_consulta.ts` (`GET_INFO_TAREA_CONSULTA`, V1: `ID_ACTIVIDAD_ALUMNO=:ID_ACTIVIDAD_ALUMNO`, `CEDULA_INTEGRANTE=:CEDULA`; SYSDATE en CASE; BLOB comentado). `entregar_actividad_proc.ts` y `entregar_actividad_reutilizar_adjunto_insert.ts` son W.

#### calendario_actividades — 2 sentencias: 2 V2
`CALENDARIO_ACTIVIDADES_CONSULTA` y `CALENDARIO_ACTIVIDADES_LIMITES_CONSULTA`: mismo patrón,
`USUARIO.CUENTA=:CUENTA AND FECHA_INICIO BETWEEN :FECHA_DESDE AND :FECHA_HASTA` **repetido en las 2
ramas de un OR**. Reescritura: `(A∧f)∨(B∧f) ≡ f∧(A∨B)` — vista sin el filtro, `.ts` filtra fuera. La
segunda hace `MIN/MAX` sin `GROUP BY`: **si no hay datos hoy da 1 fila NULL/NULL, con vista agrupada
daría 0 filas** (cambio de comportamiento a vigilar, ver §6.3). SYSDATE en ambas. ~136 y ~110 líneas.

#### pagos — 1 sentencia: 1 F
`GET_PAGOS_ESTUDIANTE_CONSULTA`: `V.PERSONA_CEDULA=:cedula` dentro de un CTE, **con
`OFFSET :skip ROWS FETCH NEXT :limit ROWS ONLY` dentro del CTE, antes de un JOIN** → F. Alternativa
V2 con `ROW_NUMBER() OVER(PARTITION BY PERSONA_CEDULA ORDER BY MAX(FECHA_EMITE) DESC)` es posible pero
compleja. Bind repetido: el repo pasa `[cedula,skip,limit,cedula]` para 3 nombres.

#### documentos_directorio — 2 sentencias: 1 V1, 1 M
`INFORMACION_DOCUMENTO_CONSULTA` = M (sin llamadores). `OBTENER_ARCHIVO_BLOB_CONSULTA` = V1, pero
devuelve un **LOB** vía `MVL_FUN_OBTENER_DOC_DIR(s/e)`.

#### shared, parametros_servidor_reportes, config/*, health — 6 sentencias: 1 V1(T en la práctica), 2 T, 2 M, 1 T
`FOTO_PERSONA_QUERY` (T, BLOB `FOTO`). `parametros_reporte.repository.ts` (V1 sin binds, pero
**⚠ devuelve usuario/contraseña del servidor de reportes**, ver §6.1). `VALIDAR_ESTADO_APP_QUERY` y
`ESTADO_MODULOS_QUERY` (T). `ESTADO_MODULO_POR_NOMBRE_QUERY` (M, sin llamadores). `health.service.ts`
(`SELECT 1 FROM DUAL`, T).

### 5.2 Franja B — `notas_estudiante`, `horario_estudiante`, `registro_academico`, `ficha_socioeconomica`

**Resumen:** 11 sentencias → 0 V1, 9 V2, 2 F, 0 T/M/YA/W/D. **No hay ninguna V1 pura en esta franja** —
todos los binds pasan por la subconsulta cuenta→cédula o están dentro de ramas de `UNION`.

| Archivo:línea | Constante/método | Cat. | Binds | Objetos | Notas |
|---|---|---|---|---|---|
| `notas_estudiante/.../arbol_de_materias_consulta.ts` | `ARBOL_DE_MATERIAS_CONSULTA` | **F** | `WHERE PERSONA_CEDULA=:G_CEDULA_USUARIO` **dentro del subquery que alimenta `START WITH...CONNECT BY`** | ACA_VIEW_MATERIAS_ESTUDIANTES(s/e) | 22 líneas. `LEVEL`/`CONNECT_BY_ISLEAF` en CASE, códigos quemados. **Por qué no hay reescritura viable:** la jerarquía sobre todos los estudiantes uniría nodos de estudiantes distintos; Oracle no empuja el filtro dentro de `CONNECT BY`; se perdería `ORDER SIBLINGS BY` |
| `notas_estudiante/.../carrera_estudiante_consulta.ts` | `CARRERA_ESTUDIANTE_CONSULTA` | **F** | `:CUENTA` ×2, cada uno anidado en `INS_TAB_USUARIOS WHERE PERSONA_CEDULA=(SELECT...WHERE CUENTA=:CUENTA)` dentro de 2 `CONNECT BY` internos | aca_tab_dependencias(s/e)×3, UTNDB.ACA_TAB_DETALLE_MATRICULAS, UTNDB.ACA_TAB_DET_MATRICULAS_REVAL, INS_TAB_USUARIOS(s/e)×4 | 69 líneas. 3 `CONNECT BY` anidados + UNION. Técnicamente hay una reescritura teórica (jerarquía completa + `CONNECT_BY_ROOT` + JOIN por CUENTA) pero es costosa y exige exponer columna de orden del recorrido — **se recomienda F** |
| `notas_estudiante/.../notas_ciclo_actual_consulta.ts` | `GET_NOTAS_CICLO_ACTUAL_CONSULTA` | V2 | `ESTUDIANTE_CEDULA=(SELECT PERSONA_CEDULA FROM INS_TAB_USUARIOS WHERE CUENTA=:CUENTA)` | UTNDB.ACA_TAB_NOTAS, ACA_TAB_MATERIAS, ACA_TAB_DETALLE_MATRICULAS, ACA_TAB_CICLOS_ACADEMICOS, ACA_TAB_MATRICULAS(s/e), REC_VIEW_DEPENDENCIAS, INS_TAB_USUARIOS(s/e); func. `INS_PCK_GENERAL.FUN_NOMBRES_PERSONA`(s/e), `FUN_PORCENTAJE_INASISTENCIA`(s/e) | 118 líneas, 1 SELECT sin UNION. Reescritura: `JOIN INS_TAB_USUARIOS U ON U.PERSONA_CEDULA=TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA`, exponer `U.CUENTA`, filtrar `WHERE CUENTA=:cuenta` |
| `notas_estudiante/.../notas_por_ciclo_consulta.ts` | `NOTAS_POR_CICLO_CONSULTA` | V2 (compleja) | Ver análisis rama-por-rama abajo. `:G_CEDULA_USUARIO`×4, `:P2_CODIGO_NODO`×5 | ~15 tablas UTNDB distintas entre 4 ramas (detalle completo en el reporte original del agente, resumen: ACA_TAB_DEPENDENCIAS, DETALLE_MATRICULAS, MATRICULAS, NOTAS, DISTRIBUTIVOS, MATERIAS, NIVELES, CICLOS_ACADEMICOS, DOCENTES, ESTUDIANTES, DET_MATRICULAS_REVAL, VIN_TAB_EXTENSION/INSTITUCION/NOTAS, ACA_TAB_ACTIVIDADES_ESTUDIANTE) | **455 líneas, 4 ramas con UNION.** Ver §5.2.1 abajo — es la más compleja de todo el repo, candidata a evaluar como F en vez de V2 cuando se llegue a ella |
| `notas_estudiante/.../notas_por_nivel_consulta.ts` | `NOTAS_POR_NIVEL_CONSULTA` | V2 | `ESTUDIANTE_CEDULA=:G_CEDULA_USUARIO` (o `COD_EXTENSION`) en cada una de 4 ramas, **NO usa `:P2_CODIGO_NODO`** | Similar a la anterior sin el filtro de nodo | 308 líneas, 4 ramas UNION. Más simple que por-ciclo porque no tiene el filtro de nodo. Reescritura: exponer `ESTUDIANTE_CEDULA` con alias común en las 4 ramas y filtrar fuera — el UNION se mantiene igual. Posibles bugs preexistentes anotados por el agente: `TAB_MATRICULAS.ESTADO NOT IN ('AD')` redundante, typo "EXTENCIÓN" |
| `horario_estudiante/.../horario_estudiante_consulta.ts` | `HORARIO_ESTUDIANTE_CONSULTA` | V2 | `ESTUDIANTE_CEDULA=(SELECT...WHERE CUENTA=:CUENTA)` y `CICLO_ACAD_CODIGO=:CICLO_CODIGO` en 2 ramas UNION | ~9 tablas `ACA_TAB_*`(s/e) + INS_TAB_USUARIOS(s/e); func. `INS_PCK_GENERAL.FUN_OBTENER_ESTRUCTURA_FISICA`(s/e), `FUN_NOMBRES_PERSONA`(s/e) | 371 líneas. **⚠ Bug preexistente, no relacionado con la migración:** el servicio llama `getHorarioEstudiante(cuenta, ciclo)` pero el repo declara `(ciclo, cuenta)` — el array real es `[cuenta, ciclo]`, coincide con los binds solo por casualidad (los nombres están cruzados dos veces). **Al migrar a vista hay que corregir esto explícitamente o el orden de binds se rompe de verdad.** Ver §6.4 |
| `registro_academico/.../aulas_virtuales_consulta.ts` | `AULAS_VIRTUALES_CONSULTA` | V2 | `CICLO_ACAD_CODIGO=:P24_CICLO_ACADEMICO` simple; `PERSONA_CEDULA=(SELECT...WHERE CUENTA=:CUENTA)` | ~10 tablas UTNDB + subconsultas escalares + funciones (`NOMBRES`, `DBMS_LOB.GETLENGTH`, `FUN_OBTENER_INASISTENCIA`, `LMS_FUN_PORCENTAJE_EJECUTADO`) | 220 líneas. **BLOB `RHU_TAB_PERSONAS.FOTO`** solo se usa en `DBMS_LOB.GETLENGTH`, no se devuelve. Ciclos quemados. `ORDER BY 1` ordena fechas concatenadas como texto |
| `registro_academico/.../ciclos_aula_virtual_consulta.ts` | `CICLOS_AULA_VIRTUAL_CONSULTA` | V2 | `ESTUDIANTE_CEDULA=:G_CEDULA_USUARIO` en cada rama de un UNION de 2 | ACA_TAB_MATRICULAS, ACA_TAB_CICLOS_ACADEMICOS(s/e), ACA_TAB_DEPENDENCIAS(s/e)×3 | 43 líneas. **Bind repetido: 2 apariciones, 1 valor pasado** — probado en vivo, responde 200 (§7). Servicio corta a 5 filas en JS |
| `ficha_socioeconomica/.../info_ficha_consulta_dto.ts` | `INFO_FICHA_CONSULTA` | V2 | Igual, dentro de vista en línea ordenada + `ROWNUM=1` fuera | Igual | Top-N clásico, se puede pasar a `FETCH FIRST 1 ROW ONLY` sobre la vista. Con empates en `FECHA_INGRESO` el resultado no es determinista (ya pasa hoy) |

#### 5.2.1 `NOTAS_POR_CICLO_CONSULTA` — análisis rama por rama (la sentencia más compleja del repo)

| Rama | Qué es | Filtro `:G_CEDULA_USUARIO` | Filtro `:P2_CODIGO_NODO` |
|---|---|---|---|
| 1 (matrículas) | dentro de vista en línea con DISTINCT | `TAB_ESTUDIANTES.PERSONA_CEDULA=:G` | `OR` ×5 sobre `CODIGO_MATERIA/CODIGO_NODO/CARRERA/FACULTAD/INSTITUCION = :P2` |
| 2 (equiparación/revalidación) | dentro | `TAB_DET_MATRICULA_REV.ESTUDIANTE_CEDULA=:G` | `OR` ×5 igual |
| 3 (extensión universitaria) | — | `TAB_NOTAS.COD_EXTENSION=:G` | **No tiene filtro de nodo — estas filas salen siempre** |
| 4 (prácticas preprofesionales) | dentro | `TAB_ACT_EST.ESTUDIANTE_CEDULA=:G` | `OR` ×5 igual |

**Por qué no es V1 simple:** (1) la rama 3 no filtra por nodo — un filtro externo la eliminaría porque
sus columnas de nodo serían NULL; (2) el `UNION` deduplica **después de quitar** las 5 columnas de
nodo — si se exponen, dos filas que solo difieren en esas columnas dejarían de fusionarse.

`ESTUDIANTE_CEDULA` + las 5 columnas de nodo (NULL en la rama 3) + un indicador `FILTRA_NODO`
('S' en 1,2,4; 'N' en 3). El `.ts`: `SELECT DISTINCT <16 cols> FROM vista WHERE ESTUDIANTE_CEDULA=:c
AND (FILTRA_NODO='N' OR :nodo IN (CODIGO_MATERIA,CODIGO_NODO,CARRERA,FACULTAD,INSTITUCION))`. **Hay que
confirmar con negocio si es intencional que la rama 3 ignore el nodo** antes de dar esto por bueno —
puede ser más seguro tratarla como F.

### 5.3 Franja C — `becas`, `documentos`, `comunicados`, `evaluacion_docentes`, `modales_informativos`, `validacion_acceso`

**Resumen:** 79 sentencias → 12 V1, 7 V2, 10 F, 12 T, 29 W, 2 M, 7 YA, 0 D.

#### becas — 27 sentencias: 5 V1, 3 V2, 3 F, 9 T, 7 W
Selección de las relevantes (V1/V2/F; el resto —T/W— no se migra):

| Constante | Cat. | Binds/detalle | Notas |
|---|---|---|---|
| `OBTENER_ARCHIVO_SOLICITUD_CONSULTA` | V2 | `SOLICITANTE=:cedula` + `:tipoArchivo='doc_cedula'` en cada rama de un UNION ALL de 4 | Reescritura: cada rama expone `CEDULA` + literal `TIPO_ARCHIVO`; filtrar fuera. Columnas BLOB. **Bind muy desalineado: 8 placeholders, repo pasa 5** `[cedula,t,t,t,t]` (la 3ª posición recibe `tipoArchivo` donde iría `:cedula`) — no probado en vivo, revisar antes de tocar |
| `OBTENER_ARCHIVO_BANCARIO_CONSULTA` | V1 | `SOLICITANTE=:cedula` | A diferencia del resto, no filtra `ESTADO` |
| `OBTENER_DATOS_BANCARIOS_CONSULTA`, `OBTENER_DATOS_CONTRATO_CONSULTA` | V1 | `SOLICITANTE=:cedula` | Subconsulta escalar `=` (riesgo ORA-01427 si hay >1 fila) |
| `OBTENER_DATOS_MATRICULA_CONSULTA` | V1 | `ESTUDIANTE_CEDULA=:cedula AND CICLO_ACAD_CODIGO=:cicloAcad` | Vista debe exponer `CICLO_ACAD_CODIGO` (hoy no está en el SELECT). `FETCH FIRST 1 ROW ONLY` sin `ORDER BY` (no determinista, preexistente) |
| `OBTENER_SOLICITUD_RESUMEN_CONSULTA` | V1 | `SOLICITANTE=:cedula` | Usa paquete `UTNDB.INS_PCK_GENERAL.FUN_NOMBRES_PERSONA` |
| `VALIDACIONES_CONSULTAS.COND_ECONOM_INGRESOS` (código '007') | V2 | `CEDULA=:cedula AND UTNDB.BSE_FUN_INGRESOS_MAT_BECA(:cedula,...)=0` | El `:cedula` del argumento se sustituye por la columna. Usa esquema personal **JRODRIGUEZ.NOM_TAB_PARAM_ROL_GENERAL** |
| `VALIDACION_GENERAL` ('000'), `RENDIMIENTO_PROMEDIO` ('006'), `DISCAPACIDAD` ('005') | **F** | `:codMatricula` es argumento de función (`BSE_FUN_COMPR_MAT_BECA_GRAL`, `BSE_FUN_PROMEDIO_MAT_BECA`, `BSE_FUN_COMPR_MAT_BECA_DISCAP`), no columna | Un JOIN a `ACA_TAB_MATRICULAS` para exponer `CODIGO` no sería estrictamente equivalente (el SQL actual no exige que la matrícula sea de esa cédula) |

Notas de becas fuera de la tabla: `becas.repository.ts:81` elige una sentencia completa de un mapa
(`VALIDACIONES_BECAS`), no concatena SQL — no es D. Riesgo transversal: "convocatoria activa" está
escrita ~15 veces de 3 formas distintas entre becas y notas_beca (con `=` escalar → riesgo
`ORA-01427`; con `IN`; con `ORDER BY...FETCH FIRST 1`) — candidata a una vista base común cuando se
llegue a esta ola.

#### documentos — 21 sentencias: 4 V1, 2 V2, 2 F, 1 M, 12 W

| Constante | Cat. | Detalle |
|---|---|---|
| `CARRERAS_CONSULTA` | V2 | `ESTUDIANTE_CEDULA`/`CEDULA=:G_CEDULA_USUARIO` en 2 ramas UNION (DISTINCT). Reescritura: exponer `CEDULA` en ambas ramas. `EXTRACT(YEAR FROM SYSDATE)` — el año cambia 5h antes el 31 de diciembre (desfase conocido) |
| `CERTIFICADOS_EVENTOS_CONSULTA` | V1 | `CEDULA=:G_CEDULA_USUARIO` |
| `FORMATOS_VINCULACION_CONSULTA` | V1 | `DIRECTORIO=:P272_DIRECTORIO` |
| `HISTORIAL_CERTIFICADOS_CONSULTAS` | V1 | `CE.CEDULA=:G_CEDULA_USUARIO` |
| `VALIDAR_ASISTENCIA_CLASES_CONSULTA` (nombre real: `VALIDAR_MATRICULA_CICLO_ACTIVO_CONSULTA`) | V1 | `p.CEDULA=:G_CEDULA_USUARIO`, `SELECT 1` |
| `DOCUMENTOS_ELECTRONICOS_PERSONALES_CONSULTA`, `DOCUMENTOS_POSGRADO_CONSULTA` | **F** | `DOC.CEDULA=:G_CEDULA_USUARIO` **dentro de la tabla derivada del LEFT JOIN** — filtrar fuera perdería los tipos de documento sin registro (el LEFT JOIN conserva tipos aunque la persona no tenga documento). **Estas 2 también las importa `ficha_estudiante.repository.ts` — tocarlas afecta a ese módulo también.** Bind: 2 apariciones, 1 valor |
| `ES_ESTUDIANTE_POSGRADO_CONSULTA` | V2 | `WHERE :G_CEDULA_USUARIO IN (SELECT...UNION SELECT '0401XXXXXX'...)`. Reescritura: vista = `SELECT ESTUDIANTE_CEDULA AS CEDULA...UNION SELECT '0401XXXXXX' FROM DUAL`, `.ts` hace `SELECT 1 FROM vista WHERE CEDULA=:c`. **⚠ Cédula real quemada `'0401XXXXXX'` en el SQL** — dato personal hardcodeado, ver si vale la pena documentarlo aparte. También la importa `ficha_estudiante` |
| `VALIDAR_CULTURA_FISICA_CONSULTA` | YA | Solo llama `UTNDB.CSE_FUN_APROBACION_CF(:cedula)` — llevarlo a vista sería F (bind como argumento de función, sin tabla base), no se migra |
| Los 11 `*_procedure.ts` (`certificado_*`) | W | Bloques `DECLARE` que llaman `UTNDB.CSE_PROC_CER_*`. Cada uno tiene un `SELECT` de validación interno (`CSE_EMISION_CERTIFICADO(cedula, N)`) — no se cuenta aparte, es parte del bloque PL/SQL. **Todos con `WHEN OTHERS` que traga el error real** (hallazgo aparte, no se arregla aquí) |

#### comunicados — 8 sentencias: 2 V1, 1 F, 2 T, 3 W

| Constante | Cat. | Detalle |
|---|---|---|
| `COMUNICADOS_PENDIENTES_CONSULTA` | **F** | CTE `info_estudiante`: `ESTUDIANTE_CEDULA=:cedula` + `ORDER BY...WHERE ROWNUM=1`; CTE `mis_visualizaciones`: `USUARIO_CEDULA=:cedula` usado en LEFT JOIN. El bind está antes del `ROWNUM=1` y dentro del LEFT JOIN que decide `TOTAL_VISTAS IS NULL` |
| `OBTENER_COMUNICADO_POR_ID_CONSULTA` | V1 | `c.ID_COMUNICADO=:idComunicado`. BLOB `IMAGEN`. SYSDATE quedaría dentro de la vista |
| `OBTENER_PREGUNTAS_ENCUESTA_CONSULTA` | V1 | `p.ID_COMUNICADO=:idComunicado` |
| `OBTENER_ID_VISUALIZACION_POR_COMUNICADO_USUARIO_CONSULTA`, `VERIFICAR_PREGUNTA_PERTENECE_COMUNICADO_CONSULTA` | T | Top-N de 1 tabla — técnicamente V1 |
| `guardar_respuesta_encuesta_consulta` (2), `registrar_visualizacion_consulta` | W | DELETE+INSERT, y un bloque PL/SQL de 145 líneas con varios `SELECT INTO` |

#### evaluacion_docentes — **módulo deshabilitado** (`app.module.ts:22,154`, comentado, sigue compilando)
13 sentencias: 1 V1, 1 V2, 3 F, 2 M, 6 W. **No se prioriza migrar mientras siga deshabilitado** — si se
reactiva algún día, retomar de la tabla completa (guardada en el reporte original del agente, no
repetida aquí por espacio — buscar "evaluacion_docentes" en el historial de este chat si hace falta el
detalle exacto, o volver a correr el mismo agente de exploración sobre ese módulo).

#### modales_informativos — 3 sentencias: 1 F, 1 T, 1 W
`MODAL_INFORMATIVO_ACTUAL_CONSULTA` = F (CTE con `ROWNUM=1` + `NOT EXISTS` correlacionado, ambos con
el bind). BLOB `IMAGEN_BANNER` probable.

#### validacion_acceso — 7 sentencias: 1 V2, 6 YA
Ya casi todo resuelto: 6 sentencias son `YA` (consumen `MOVIL_UTN.MVL_VIEW_VALIDAR_*` existentes,
aunque **2 de esos métodos —`validarAdmision` y `validarCedulaDigital`— no tienen llamadores fuera de
tests**, revisar si vale la pena documentarlos como casi-muertos). La única V2:
`VALIDAR_FACULTAD_POSTGRADO_CONSULTA` (`DET.ESTUDIANTE_CEDULA=:cedula`, `SELECT DISTINCT FAC.SIGLAS`).

## 6. Hallazgos transversales verificados (afectan a varios módulos)


**Verificado leyendo el código** (no es una sospecha): `aula_virtual/.../silabo_consulta.ts` arma una
URL de la forma `...userid=<INS_TAB_PARAMETROS código 00009>/<código 00010>@servidor...` y la devuelve
completa en `SilaboDto.pdfUrl` (`aula_virtual.service.ts:318-325` la pasa tal cual). Lo mismo hace
`pagos.service.ts:130-134` para las URLs de factura y de formulario de matrícula
(`pagos.controller.ts:23-48` las devuelve en la respuesta HTTP). `parametros_reporte.repository.ts`
es quien lee esas dos columnas (usuario/contraseña) de `INS_TAB_PARAMETROS`.

**Implicación para esta migración:** si se crea una vista o función que exponga esas columnas
(`SILABO_CONSULTA` está clasificada V2/F arriba y usa `parametros_reporte`), **cualquier usuario con
`SELECT` sobre ese objeto vería la contraseña real del servidor de reportes**, ampliando quién puede
"migrar queries" arreglar esto, pero si se toca `SILABO_CONSULTA` o `parametros_reporte` hay que
la vista/función de estas dos sin esa conversación primero.**

*(Nota: si se decide documentar esto como hallazgo formal de seguridad en Obsidian, sacar los valores
reales — no van en ninguna nota, solo el nombre de las columnas y los códigos de parámetro 00009/00010.)*

### 6.2 Binds con nombre repetido, verificado en vivo — no es un bug activo (con una excepción sin probar)

Los 3 agentes señalaron ~15 sentencias donde el número de valores pasados en el array de
`dataSource.query(sql, [...])` no coincide con el número de veces que aparece el bind en el texto SQL,
especulando que podría dar `ORA-01008` (variable no ligada). **Se probó en vivo** contra la réplica de
dev con el servicio local y la cuenta `<cuenta-de-prueba>`:

| Endpoint probado | Resultado |
|---|---|

bind con nombre repetido cuenta como una sola posición** — igual que en PL/SQL, aunque estas son
consultas SQL puras, no bloques PL/SQL. Los agentes citaron el comportamiento de **modo *thin*** de
`node-oracledb` (`NJS-098`, exige un valor por cada aparición textual), que **no aplica aquí** porque
el proyecto usa *thick mode* explícitamente (`app.module.ts:68`, confirmado en `CLAUDE.md` del repo:
"`oracledb` 6.8 en *thick mode*"). Dicho de otra forma: el driver en *thick* resuelve por **nombre
único**, no por posición textual — coincide con cómo se comportaron `:cuenta`×2 en
`FICHA_ESTUDIANTE_CONSULTA` (§4) y con todos los `GET` de la tabla de arriba.

**No probado, queda pendiente antes de tocarlo:** `getListaRecursos` en `aula_virtual_repository.ts`
pasa 16 valores para 14 nombres de bind únicos y 25 apariciones en el SQL — no encaja ni con "una
posición por nombre único" ni con "una por aparición". Puede estar genuinamente desalineado (algunos
parámetros recibiendo el valor de otro). **Antes de migrar `LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA` (F),
y comparar la respuesta contra lo que se esperaría, para confirmar si hoy ya está roto o no.** Igual
con `OBTENER_ARCHIVO_SOLICITUD_CONSULTA` de becas (8 placeholders, 5 valores, con la 3ª posición
recibiendo `tipoArchivo` donde el texto pide `:cedula`).

**Consecuencia práctica para la migración:** de todas formas, al pasar cualquiera de estas sentencias
a vista o función, cada bind queda **una sola vez** en el `.ts` — el problema (sea cual sea hoy)
desaparece solo, sin necesidad de "arreglarlo" aparte.

### 6.3 Vistas agregadas: 0 filas vs. 1 fila con NULL

Cuando el SQL actual hace un agregado (`COUNT`, `MIN`, `MAX`) **sin** `GROUP BY` y no hay datos,
Oracle devuelve **1 fila** con el agregado en `NULL` (o 0 para `COUNT`). Si la reescritura V2 agrupa
por la columna de filtro (`GROUP BY CUENTA`, etc.), sin datos la vista devuelve **0 filas** — cambia el
contrato con quien consume el repositorio. Casos identificados:
  agrupa en la vista, el `COUNT(*)` se queda en el `.ts` sobre la vista sin agregar.
- `CALENDARIO_ACTIVIDADES_LIMITES_CONSULTA`: sin resolver todavía — si se agrupa, la app recibiría
  campos ausentes en vez de `fechaMin: null, fechaMax: null`. Hay que decidir esto al llegar a ese
  módulo (probablemente: misma solución que el anterior, no agregar en la vista).
- `CONTAR_PREGUNTAS_RESPONDIDAS` (evaluacion_online): el repositorio **ya** maneja el caso con
  `result[0]?.total ?? 0`, así que ahí sí es seguro agregar en la vista/reescritura.

### 6.4 Bug preexistente encontrado de paso (no se arregla en esta migración, se documenta)

`horario_estudiante.service.ts:12` llama a `getHorarioEstudiante(cuenta, ciclo)`, pero
`horario_estudiante.repository.ts:15` declara el método como `getHorarioEstudiante(ciclo, cuenta)`.
Hoy "funciona" porque los dos parámetros se usan cada uno dos veces en el SQL con el mismo nombre en
ambas apariciones — el orden real del array `[cuenta, ciclo]` termina coincidiendo por casualidad con
el orden de aparición en el texto. **Al migrar esta query a vista, hay que corregir explícitamente
esta firma** (no solo copiar el bug a la vista) — es el tipo exacto de error que el invariante 2 del
proyecto advierte que "no da error, da 0 filas en silencio", y aquí ya está latente.

### 6.5 Objetos sin esquema y permisos — aplica a casi todo el repo

La gran mayoría de las tablas (`INS_TAB_USUARIOS`, `ACA_TAB_MATRICULAS`, las tablas `LMS_TAB_*`, las
de horario, etc.) se referencian **sin** prefijo `UTNDB.` en el texto SQL actual — resuelven por
sinónimos del usuario de conexión (`MOVIL_UTN`, `app.module.ts`). **En el DDL de cualquier vista o
función nueva, siempre hay que poner el esquema explícito** (`UTNDB.TABLA`), porque una vista no
hereda los sinónimos de la sesión que la consulta, sino los del momento en que se crea/valida.
`MOVIL_UTN` necesita `SELECT`/`EXECUTE` **directo** (no por rol) sobre cada tabla/función que toque la
producción; en dev lo verifica el usuario al crear el objeto (si falta un grant, sale
`ORA-00942`/`ORA-01031` al primer intento de `SELECT` sobre la vista, aunque el `CREATE OR REPLACE
FORCE VIEW` haya compilado).

Caso especial: `becas/.../validaciones_solicitud.consulta.ts` usa el esquema personal
**`JRODRIGUEZ.NOM_TAB_PARAM_ROL_GENERAL`** — confirmar con el DBA si sigue vigente o es un resto de una
cuenta de desarrollo que ya no existe, antes de crear una vista que dependa de él.

### 6.6 `SYSDATE` y el desfase de 5 horas — no se corrige aquí

Unas 13 lecturas usan `SYSDATE` (comparaciones de fecha para ventanas de actividad, convocatorias
activas, etc.). El reloj de Oracle va 5 horas adelantado respecto al servidor de aplicaciones
(hallazgo ya documentado en la plataforma, ver `utn-practicas-contexto-claude/plataforma/infraestructura.md`).
Pasar estas queries a vista **no cambia ese comportamiento** — el `SYSDATE` se sigue evaluando igual
en el momento de la consulta. La vista sería el lugar natural para aplicar el arreglo conocido
(`CAST(SYSTIMESTAMP AT TIME ZONE 'America/Guayaquil' AS DATE)`), **pero eso es un cambio de
comportamiento, no parte de "migrar la query tal cual"** — se documenta como oportunidad, no se hace
sin que el usuario lo pida explícitamente aparte.

### 6.7 Columnas LOB (BLOB/CLOB) — no van bien en vistas con DISTINCT/GROUP BY/UNION

Inventario de LOBs encontrados: `RHU_TAB_PERSONAS.FOTO`, `LMS_TAB_PREGUNTAS.ADJUNTO`,
`MVL_FUN_OBTENER_DOC_DIR(...)` (BLOB, documentos_directorio), `MVL_TAB_COMUNICADOS.IMAGEN`,
`ENC_TAB_ENCUESTA.IMAGEN_BANNER` (probable), y varios `DOCUMENTO`/`DOC_CEDULA`/`CONADIS`/`REQUISITOS`/
`NO_IESS` en becas (todos en sentencias `W`, no aplica a esta fase). `PREGUNTA_HTML` y
`OPCIONES_CONFIG` son posiblemente `CLOB` (no confirmable solo leyendo el `.ts`, hay que verificarlo en
el diccionario de datos al llegar a esas vistas). **Regla ya aprendida en el piloto:** un LOB en el
resultado rompe `MINUS` con `ORA-22848` — se valida con `DBMS_LOB.SUBSTR(col,4000,1)` en ambos lados
solo para la comparación.

### 6.8 Consultas candidatas a compartir un solo objeto (menos vistas que sentencias)

  porcentaje usan y el redondeo. Una sola vista con `DECODE(CODIGO_PARCIAL,...)` podría cubrir las 3.
- `HORARIO_ESTUDIANTE_CONSULTA` + `HORARIO_ACTIVO_ESTUDIANTE_CONSULTA` — texto casi idéntico salvo el
  filtro de ciclo.
- `CALENDARIO_ACTIVIDADES_CONSULTA` + `CALENDARIO_ACTIVIDADES_LIMITES_CONSULTA` — mismo `FROM`/`WHERE`
  base, hoy duplicado a mano en dos archivos.
- La regla de "convocatoria activa" de becas, repetida ~15 veces de 3 formas.

Esto es una **decisión de diseño a tomar con el usuario cuando se llegue a cada ola** (menos objetos =
menos mantenimiento, pero un objeto compartido acopla más módulos entre sí) — no está resuelta, solo
identificada.

## 7. Endpoints ya probados en vivo en esta sesión (referencia rápida)


```
```

No probados todavía: `getListaRecursos` (aula_virtual), `getPagosByUsuario` con datos reales (la
cuenta de prueba no tiene pagos), casi todo `becas` y `evaluacion_online` (requieren estado de negocio
más específico: solicitud de beca activa, evaluación en curso).

## 8. Qué NO se hace en esta migración (alcance explícitamente descartado)

- Las **18 sentencias T** (triviales) — decisión del usuario, 2026-09-14.
- Las **11 sentencias YA** (ya resueltas) — decisión del usuario, 2026-09-14.
- Las **6 sentencias M** (código muerto) — decisión del usuario, 2026-09-14. Quedan documentadas por si
  alguien quiere limpiarlas en otro momento, pero no se les crea ningún objeto de BD.
- Las **45 sentencias W** (escrituras) — fase de procedimientos, posterior y separada.
- **`evaluacion_docentes`** completo — módulo deshabilitado, no se prioriza mientras siga así.
  hallazgo de seguridad §6.1 con el usuario/tutor.
- Corregir el desfase de `SYSDATE` (§6.6), el bug de `horario_estudiante` (§6.4 — este si se corrige,
  pero *al migrar esa vista específica*, no antes ni aparte), ni ningún otro bug de negocio que se
  note de paso: se documentan, no se arreglan salvo que el usuario lo pida.
- Cualquier cambio de rama, commit o push — sigue vigente la regla de git de §2.1.

## 9. Próximo paso concreto para quien retome esto

1. Confirmar con el usuario el **orden de las olas** (V1 primero, luego V2, luego F — ver la hoja de
   ruta completa que se armó en la conversación original, con el orden módulo por módulo; si no está
   disponible, usar el orden de "menor a mayor riesgo" ya esbozado en esta nota: `ficha_estudiante` →
   `actividades`/`documentos_directorio` → `documentos` → `comunicados` → `becas` → `aula_virtual` →
   `evaluacion_online`, y dejar `notas_por_ciclo` (§5.2.1) y la ola F para el final).
2. Resolver la **decisión pendiente de `ficha_estudiante`** (§4: función vs. vista con JOIN
   reescrito) — es el módulo más simple y natural para empezar apenas se retome.
3. Seguir el mismo ritual del piloto `foro_online` para cada objeto: SQL en el chat → usuario lo crea
   en Toad → validar (`MINUS` o fila a fila) → cambiar el `.ts` → probar con `curl` antes/después →
   documentar.
4. Antes de tocar `LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA` y `OBTENER_ARCHIVO_SOLICITUD_CONSULTA`,
   probar en vivo si los binds desalineados (§6.2) ya están rotos hoy.
5. Cuando se acumulen 3-4 módulos más migrados, actualizar esta nota (o crear una v2) con el estado.
