# Cómo trabajamos la migración de queries a vistas/funciones — 2026-09-14

Esta nota es de **continuidad**: si el chat de Claude se queda sin contexto o se cierra, sirve para
abrir uno nuevo y seguir exactamente donde se quedó, sin repreguntar el método.

Repo: `utn-movil-portafolio-estudiante`. Vault: Registro de queries (índice original de la
auditoría, 2026-09-09) y Descubrimientos queries (hallazgos que van saliendo *mientras* se
migra, distinto de la auditoría inicial).

> ⚠ **Leer junto con esta nota, son complementarias, no redundantes:**
> `Backup-Planes/2026-09-14 - Plan completo migracion SELECT a vistas (portafolio-estudiante).md`
> tiene el **inventario completo de las 150 sentencias SQL del repo** (archivo:línea, categoría
> V1/V2/F/T/M/YA/W, tablas Oracle, por qué), el análisis de `ficha_estudiante`, y los hallazgos
> `SILABO_CONSULTA`/`pagos`). Esta nota de aquí tiene el **ritual de trabajo** y el **estado del
> piloto**; aquella tiene **qué falta y por qué**. Si vas a retomar esto en un chat nuevo, lee las
> dos — no alcanza con una sola.

## El encargo

La auditoría en `Queries Encontradas/00_Indice_Resumen.md` encontró ~125 queries SQL escritas
literalmente (`hardcoded`) en los `.ts` del repo. Si el DBA cambia una tabla/columna en Oracle, el
código no se entera. Objetivo: mover esa lógica a objetos de Oracle (`MOVIL_UTN`) y que el código
solo los invoque.

## Orden de trabajo (decidido con el usuario)

1. **Primero solo los `SELECT`** de cada módulo. Las escrituras (`INSERT`/`UPDATE`/`DELETE`/`MERGE`/
   bloques PL/SQL) quedan para una **fase de procedimientos posterior**, no se tocan todavía.
2. Un **módulo piloto** primero (`foro_online`, ya casi terminado — ver estado abajo), después
   módulo por módulo del resto del repo.
3. **El usuario crea y valida los objetos en la réplica de dev con Toad**, conectado como
   vez**, nunca en archivos sueltos en `docs/` (eso se probó y se revirtió: ensucia el repo sin
   necesidad, el DDL vive en esta nota y en el chat).

## Regla de clasificación de un `SELECT`

| Caso | Objeto |
|---|---|
| Los binds solo filtran columnas que la vista puede exponer | **Vista** `MVL_VIEW_*` (el `WHERE :bind` se queda en el `.ts`, sobre la vista) |
| Bind dentro de la proyección (`CASE`), un subquery, `CONNECT BY`, un agregado o paginación | **Función** `MVL_FUN_*` que devuelve `SYS_REFCURSOR` |

## Ritual de trabajo, paso a paso (cómo se interactúa en el chat)

Esto es literal — así se hizo el piloto completo, objeto por objeto, y así sigue para los que
vengan. Un chat nuevo debe seguir exactamente este ciclo, sin saltarse pasos ni adelantar el cambio
de código:

1. **Claude prepara UN objeto** (una vista o una función) a la vez — nunca varios de golpe — y lo
   pega completo en el chat, listo para copiar y pegar en Toad tal cual (no como referencia a un
   archivo: el DDL va directo en el mensaje).
2. **El usuario lo pega en Toad** (conectado como `MOVIL_UTN` en la réplica de dev) y lo ejecuta.
3. **El usuario manda el resultado de vuelta al chat** — el error si algo falla, o el resultado de
   la prueba (el grid de `MINUS`, la captura del `Data Grid`, o el texto que salió). No hace falta
   que sea bonito: una captura de pantalla también sirve, Claude la puede leer.
4. **Claude confirma o corrige.** Si el `MINUS`/la comparación dio limpio, se marca ese objeto como
   validado y se pasa al siguiente. Si hubo un error (p. ej. `ORA-22848` por un `CLOB`, o
   nunca se avanza al siguiente objeto con uno sin confirmar.
5. **Se repite 1-4 hasta terminar toda la tanda** — todos los objetos `SELECT` (vistas + funciones)
   de un módulo, no solo uno. En `foro_online` la tanda fueron los 6 objetos completos antes de
   tocar código.
6. **Recién cuando toda la tanda del módulo está creada y validada en la BD**, Claude cambia el
   código (`.ts`) para que apunte a esos objetos, y prueba: primero `pnpm run build`, después
   levantar el servicio local y comparar con `curl` la respuesta antes/después del cambio (la prueba
   más fuerte, porque pasa por TypeORM/`oracledb` de verdad).

**Por qué en ese orden y no antes:** cambiar el `.ts` antes de que un objeto esté validado dejaría el
código apuntando a algo que puede no existir o no devolver lo mismo — se probaría con datos falsos.
Y cambiarlo objeto por objeto en vez de esperar a la tanda completa multiplicaría los ciclos de
`pnpm run build`/reinicio del servidor sin necesidad.

## Metodología de validación (qué se compara y cómo, en cada paso 3-4 de arriba)

- **Vistas**: `(query literal con binds reales) MINUS (SELECT ... FROM vista WHERE ...)` en los dos
  sentidos, debe dar 0 filas. Si hay una columna `CLOB` en el resultado, `MINUS` truena con
  `ORA-22848` — hay que envolverla con `DBMS_LOB.SUBSTR(columna, 4000, 1)` en ambos lados, solo para
  la comparación (la vista en sí no cambia).
- **Funciones**: en Toad, un bloque anónimo con `DBMS_SQL.RETURN_RESULT(cursor)` muestra el
  resultado como grid — compararlo fila por fila (conteo, orden, valores) contra correr la query
  literal envuelta en el mismo truco. `DBMS_OUTPUT`/`SET SERVEROUTPUT` casi nunca hace falta;
  `DBMS_SQL.RETURN_RESULT` alcanza y es más simple.
- **Datos de prueba reales**: se usan las cuentas de dev `<cuenta-de-prueba>` (estudiante, cédula
  `<cedula>`) y `<cuenta-de-prueba>` (docente, cédula `<cedula>`, aparece como autor en varios
  `src/config/entorno.ts`).
- **Verificación final, la más fuerte**: levantar el servicio local (`pnpm run start:dev`, contra la
  réplica de dev) y pegarle a los endpoints reales con `curl` antes y después del cambio de código.
  Si el JSON sale idéntico, es la prueba definitiva — más fuerte que el `MINUS` porque pasa por
  TypeORM/`oracledb` de verdad, no solo por SQL en Toad.

## Cómo llega un `SYS_REFCURSOR` a través de TypeORM/`oracledb`

`dataSource.query()` en modo Oracle usa `outFormat: OBJECT` sin `resultSet`
`SELECT MOVIL_UTN.MVL_FUN_X(:1, ...) AS FILAS FROM DUAL`, llega como
`[{ FILAS: [ {...fila1}, {...fila2} ] }]` — `oracledb` trata una columna `DB_TYPE_CURSOR` como cursor
anidado y lo trae completo (`oracledb/lib/impl/resultset.js:235`). **Confirmado en la práctica**, no
solo por lectura de código: se probó en vivo con `foro_online` (ver estado abajo), no hizo falta un
script de Node aparte.

En el repositorio, el patrón queda:
```ts
const resultados: { FILAS: Object[] }[] = await this.dataSource.query(QUERY, [...binds]);
return plainToInstance(Dto, resultados[0]?.FILAS ?? []);
```

## `git` en este repo — recordatorio

- 🚫 Nunca commit, push, checkout de rama, merge, pull. Excepción concedida el 2026-09-14:
  **`git stash` / `git stash pop` sí, pero exclusivamente para comparar contra el estado previo**
  (nunca para cambiar de rama ni traer remoto), siempre con `pop` inmediato en el mismo turno.
- Rama de trabajo actual (al 2026-09-14): **`practicas-preprofesionales`**, directo, sin rama propia
  creada todavía (el paso de crear rama se saltó a propósito por ahora). Hay cambios sin commitear.

## Estado del piloto `foro_online` (al 2026-09-14, fin de sesión)

**Los 6 objetos `SELECT` de este módulo están creados y validados en dev, y el código ya apunta a
ellos:**

| Objeto Oracle | Reemplaza (archivo) | Validado |
|---|---|---|
| `MOVIL_UTN.MVL_VIEW_FORO_TIPO` | `tipo_foro.query.ts` | ✅ MINUS + uso real vía PATCH |
| `MOVIL_UTN.MVL_VIEW_FORO_ACT_ESTADO` | `validar_actividad.query.ts` | ✅ MINUS + uso real vía PATCH |
| `MOVIL_UTN.MVL_VIEW_FORO_AUTORES` | `autores_foro.query.ts` | ✅ MINUS + uso real vía GET |
| `MOVIL_UTN.MVL_VIEW_FORO_INSTRUC_ACT` | `get_instrucciones_actividad.query.ts` | ✅ MINUS (con `DBMS_LOB.SUBSTR` por el CLOB) + uso real vía GET |
| `MOVIL_UTN.MVL_FUN_FORO_ACTIVIDAD` | `foro_actividad.query.ts` | ✅ comparación fila a fila + uso real vía GET |
| `MOVIL_UTN.MVL_FUN_FORO_GENERAL` | `foro_general.query.ts` | ✅ comparación fila a fila (32 filas idénticas) + uso real vía GET |

Archivos de código ya cambiados (sin commitear):
- `src/modules/foro_online/repository/foro_online.repository.ts`
- Los 6 `src/modules/foro_online/repository/consultas/*.query.ts` de la tabla de arriba

**No migrados, y no toca hacerlo ahora:**
- `estado_actividad.query.ts`, `fecha_fin_actividad.query.ts` — código muerto, nadie los importa.
- `crear_respuesta_actividad.query.ts`, `crear_respuesta_general.query.ts`,
  `actualizar_foro.query.ts`, `eliminar_foro.query.ts`, `marcar_actividad_entregada.query.ts` — son
  escrituras, quedan para la fase de procedimientos.

**Hallazgo de paso, documentado aparte**: ver Descubrimientos queries — un test de este módulo
ya estaba roto antes de esta migración.

## Datos de prueba que ya existen en dev (por si se necesitan de nuevo)

- Actividad de estudiante con foro: `idActividad = 627065` ("future"), `idActividadAlumno =
  18516355`, cédula `<cedula>`. Comentario padre `idForo = 1127676`, respuesta hija
  `idForo = 1127677` (ambos creados a propósito para esta prueba, contenido "de prueba").
- Materia de prueba para foro general: `idCurso = 54443`, `materiaCodigo = CAPRU-MATPRU`,
  `depenCodigo = 99999`, `nivelCodigo = 01`, `cicloAcadCodigo = 1021-1099`,
  `modaEstudCodigo = 01`, `sistEstudCodigo = 02`, `tcicloacadCodigo = 02`,
  `tfinanciaCodigo = 01`, `instCodigo = 001`. Tiene 32 foros reales (`ESTADO` `A` e `I` mezclados),
  incluida una respuesta anidada (`ID_FORO_PADRE`) — buen caso de prueba para el futuro.

## ⚠ Alcance recortado el 2026-09-14 (decisión del usuario, definitiva — manda sobre el punto 3 de abajo)

De las 150 sentencias del repo, **solo se migran las categorías V1 (vista directa), V2 (vista con
reescritura) y F (función con `SYS_REFCURSOR`)**. El usuario pidió explícitamente **no** crear
ningún objeto para:
- **T (trivial)** — `SELECT 1 FROM DUAL` o una tabla de 1-2 columnas sin `JOIN`.
- **YA (ya resuelto)** — ya usa una vista `MVL_VIEW_*` existente o solo llama a una función ya creada.
- **M (código muerto)** — nadie importa la constante, o el método no tiene llamadores fuera de tests.

El detalle de qué sentencia cae en cada categoría, módulo por módulo, está en el inventario completo
de `Backup-Planes/` (enlazado arriba) — no lo repito aquí para no duplicar y desactualizar dos copias.

## Ajuste al ritual — 2026-09-15: tandas para lo simple, paso a paso para lo complicado

El usuario preguntó si se podía agilizar. Dos cosas pasaron:

**1. Se evaluó y se descartó un atajo:** el usuario le preguntó a otra IA (Antigravity) cómo agilizar
esto, y le propuso un script (`scripts/ejecutar-ddl.ts`) que Claude correría por consola, que lee
decidió NO hacerlo.** Motivos, por si alguien lo vuelve a proponer:
  leerlo vía procesos indirectos") — que Claude no vea el valor de la contraseña en pantalla no
  cambia que sería Claude quien dispara la conexión a la BD cuantas veces quiera, sin que el usuario
  intervenga en cada una. Es distinto de levantar el servicio local (`pnpm run start:dev`), que es la
  app haciendo su trabajo normal, no un script creado para darle a Claude una vía de escritura nueva.
- Choca con la regla del proyecto en `utn-practicas-contexto-claude/CLAUDE.md`: *"DDL en Oracle pasa
  por el DBA, siempre. La instancia es compartida."* Hoy el usuario ya corre el DDL de dev a mano, en
  su propia sesión de Toad — automatizarlo con un agente quita ese control humano sobre una instancia
  que comparte con el resto del equipo (el resto del equipo).
- No resuelve el verdadero cuello de botella, que es la **validación** (conseguir datos de prueba,
  comparar resultados), no el copiar/pegar del `CREATE OR REPLACE`.

**2. Lo que sí se acordó:** combinar los dos ritmos.
- **Vistas V1 simples → en tanda.** Para los módulos pequeños con queries triviales de migrar, Claude
  prepara varios objetos (DDL + su validación `MINUS`) juntos en un mismo mensaje, y el usuario los
  corre todos seguidos en Toad antes de reportar resultados — en vez de una confirmación por objeto.
- **V2 (reescrituras) y F (funciones)** siguen el ritual de siempre, uno a la vez, con confirmación
  en cada paso — porque ahí sí hay más riesgo de que la reescritura cambie el resultado.

**Primera tanda acordada (2026-09-15), 3 vistas V1 de 3 módulos distintos, todas ya analizadas:**

| Módulo | Constante | Archivo | Bind(s) |
|---|---|---|---|
| `actividades` | `GET_INFO_TAREA_CONSULTA` | `respository/consultas/get_info_tarea_consulta.ts` | `:ID_ACTIVIDAD_ALUMNO`, `:CEDULA` |
| `documentos_directorio` | `OBTENER_ARCHIVO_BLOB_CONSULTA` | `repository/consulta/obtener_archivo_blob_consulta.ts` | `:P272_ID_DOCUMENTO_DIRECTORIO` |

SQL literal ya releído directo de los archivos (no del resumen de los subagentes, para no arriesgar
fidelidad) — se deja copiado aquí para que un chat nuevo no tenga que volver a abrirlos:


```sql
-- GET_INFO_TAREA_CONSULTA (actividades)
SELECT
   ACT_ALUM.ID_ACTIVIDAD_ALUMNO,
   ACT_ALUM.INTENTOS_DISPONIBLES,
   MATERIA.DESCRIPCION "MATERIA",
   ACT_ALUM.DESCRIPCION AS DESCRIPCION_ACTIVIDAD_ALUMNO,
   ACT_ALUM.URL AS URL_ACTIVIDAD_ALUMNO,
   ACT_ALUM.CALIFICACION,
   case
      WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 7 THEN 'NO_REQUIERE_ADJUNTO'
      WHEN ACT_ALUM.ENTREGADO = 'SI' AND ACT_ALUM.ID_DOCUMENTO_DIRECTORIO IS NOT NULL THEN 'ENTREGADO_CON_ADJUNTO'
      WHEN ACT_ALUM.ENTREGADO = 'SI' AND ACT_ALUM.ID_DOCUMENTO_DIRECTORIO IS NULL THEN 'ENTREGADO_SIN_ADJUNTO'
      ELSE 'NO_ENTREGADO'
   end as ENTREGADO,
   ACT_ALUM.ID_DOCUMENTO_DIRECTORIO AS ADJUNTO_ALUMNO,
   (SELECT NOMBRE_ARCHIVO FROM UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO WHERE ID_DOCUMENTO_DIRECTORIO = ACT_ALUM.ID_DOCUMENTO_DIRECTORIO) AS NOMBRE_ADJUNTO_ALUMNO,
   ACT_ALUM.OBSERVACION,
   ACTIVIDAD.NOMBRE_CORTO,
   ACTIVIDAD.DESCRIPCION AS DESCRIPCION_ACTIVIDAD,
   ACTIVIDAD.URL AS URL_ACTIVIDAD,
   ACTIVIDAD.FECHA_INICIO,
   ACTIVIDAD.FECHA_FIN,
   ACTIVIDAD.ID_DOCUMENTO_DIRECTORIO AS ADJUNTO_DOCENTE,
   (SELECT NOMBRE_ARCHIVO FROM UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO WHERE ID_DOCUMENTO_DIRECTORIO = ACTIVIDAD.ID_DOCUMENTO_DIRECTORIO) AS NOMBRE_ADJUNTO_DOCENTE,
   (
      CASE
         WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 2 and greatest(SYSDATE, FECHA_INICIO) = FECHA_INICIO THEN 'PRUEBA_NO_DISPONIBLE'
         WHEN ACTIVIDAD.TIPO_ACTIVIDAD = 2 and greatest(SYSDATE, FECHA_INICIO) = SYSDATE AND greatest(SYSDATE, FECHA_FIN) = FECHA_FIN THEN 'RENDIR_EVALUACION'
         WHEN (ACTIVIDAD.TIPO_ACTIVIDAD = 6) and (ACTIVIDAD.URL IS NOT NULL) THEN 'FORO_YAMMER'
         WHEN (ACTIVIDAD.TIPO_ACTIVIDAD = 3) and (ACTIVIDAD.URL IS NOT NULL) THEN 'EVALUACION_OFFICE_365'
         WHEN (ACTIVIDAD.TIPO_ACTIVIDAD = 4) and (ACTIVIDAD.URL IS NOT NULL) THEN 'EVALUACION_OTRAS'
         WHEN (ACTIVIDAD.TIPO_ACTIVIDAD = 7) and (ACTIVIDAD.URL IS NOT NULL) THEN 'CLASE_SINCRONA'
         WHEN greatest(SYSDATE, FECHA_FIN) = SYSDATE AND (ACTIVIDAD.TIPO_ACTIVIDAD IN (1, 2)) THEN 'ACTIVIDAD_FINALIZADA'
         WHEN (ACTIVIDAD.TIPO_ACTIVIDAD = 5) THEN 'FORO_UTN'
         ELSE 'RESPONDER'
      END
   ) AS RESPONDER,
    TIPO.NOMBRE_TIPO
FROM
   LMS_TAB_ACTIVIDADES_ALUMNOS ACT_ALUM
   JOIN LMS_TAB_ACTIVIDAD_ACADEMICA ACTIVIDAD ON (ACT_ALUM.ID_ACTIVIDAD = ACTIVIDAD.ID_ACTIVIDAD)
   JOIN ACA_TAB_MATERIAS MATERIA ON (MATERIA.CODIGO = ACTIVIDAD.MATERIA_CODIGO AND MATERIA.NIVEL_CODIGO = ACTIVIDAD.NIVEL_CODIGO)
   JOIN LMS_TAB_TIPO_ACTIVIDAD TIPO ON(TIPO.CODIGO = ACTIVIDAD.TIPO_ACTIVIDAD)
WHERE
   ACT_ALUM.ID_ACTIVIDAD_ALUMNO = :ID_ACTIVIDAD_ALUMNO
   AND ACTIVIDAD.ESTADO = 'A'
   AND ACT_ALUM.CEDULA_INTEGRANTE = :CEDULA
```

```sql
-- OBTENER_ARCHIVO_BLOB_CONSULTA (documentos_directorio)
SELECT 
    NOMBRE_UNICO, 
    DIRECTORIO, 
    MIME_TYPE, 
    NOMBRE_ARCHIVO, 
    MVL_FUN_OBTENER_DOC_DIR(DIRECTORIO, NOMBRE_UNICO) AS CONTENIDO_ARCHIVO
FROM 
    UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO 
WHERE 
    ID_DOCUMENTO_DIRECTORIO = :P272_ID_DOCUMENTO_DIRECTORIO
```

**Ojo con `GET_INFO_TAREA_CONSULTA`:** tiene `ACTIVIDAD.ESTADO = 'A'` como filtro fijo (se queda
dentro de la vista) y **dos subconsultas escalares correlacionadas** contra
`UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO` en la lista `SELECT` — no son binds, son subqueries que
referencian columnas de la fila externa (`ACT_ALUM.ID_DOCUMENTO_DIRECTORIO`,
`ACTIVIDAD.ID_DOCUMENTO_DIRECTORIO`), así que siguen funcionando igual dentro de una vista (no
dependen de ningún parámetro externo, solo de columnas de la propia fila). También usa `SYSDATE`
dentro del `CASE` de `RESPONDER` (ver el hallazgo del desfase de 5h en la nota de plataforma — no se
corrige aquí, se documenta nomás).

**Orden de binds, confirmado leyendo cada repositorio (2026-09-15):** los 3 coinciden con el orden en
el texto SQL — `ficha_estudiante.repository.ts:31` pasa `[cedula]`,
`actividades.repository.ts:17` pasa `[idActividadAlumno, cedula]`,
`documentos_directorio.repository.ts:29` pasa `[idDocumentoDirectorio]`. Sin sorpresas.

### Resultado de la tanda (2026-09-15)

Las 3 vistas se crearon en dev y se validaron con `MINUS` (registro completo, con el texto exacto de
cada `CREATE OR REPLACE VIEW` y su validación, en `Queries Encontradas/00_Indice_Resumen.md` Q7-Q9):

| Vista | MINUS | Nota |
|---|---|---|
| `MOVIL_UTN.MVL_VIEW_INFO_TAREA` | ✅ 0 filas | Se excluyeron del `MINUS` `DESCRIPCION_ACTIVIDAD_ALUMNO`/`DESCRIPCION_ACTIVIDAD` (esta última, `ACTIVIDAD.DESCRIPCION` de `LMS_TAB_ACTIVIDAD_ACADEMICA`, ya salió CLOB en el piloto de foro) |
| `MOVIL_UTN.MVL_VIEW_ARCHIVO_DIRECTORIO` | ✅ columnas de texto | ⚠ El `DBMS_LOB.COMPARE` del BLOB dio `ORA-22288 FILEOPEN failed` para `ID_DOCUMENTO_DIRECTORIO=1104210` — **no es un bug de la vista**: `MVL_FUN_OBTENER_DOC_DIR` (sin tocar, la vista lo llama igual que la consulta original) intenta abrir un archivo físico que no existe en la réplica de dev. Falla igual con o sin vista. No se insistió con los otros 4 IDs de la muestra (`1104211-1104214`) por el mismo motivo esperado. |

**Cambio de código de 2 de los 3 módulos** (el tercero, `ficha_estudiante`, se queda intacto porque
su tanda no está completa — falta `MVL_FUN_FICHA_ESTUDIANTE`, ver más abajo):

- **`actividades`** (`get_info_tarea_consulta.ts` → `SELECT ... FROM MOVIL_UTN.MVL_VIEW_INFO_TAREA`):
  antes/después del cambio — **JSON idéntico**. Migración completa y confirmada end-to-end.
- **`documentos_directorio`** (`obtener_archivo_blob_consulta.ts` → `SELECT ... FROM
  MOVIL_UTN.MVL_VIEW_ARCHIVO_DIRECTORIO`): `pnpm`/`tsc` compila limpio y el servicio local recompiló
  sin errores (watch mode). **No se pudo probar end-to-end con `curl`**: el endpoint
  (`documentos_directorio.service.ts:29`, `generarTokenDocumento`), que solo se emite desde otro flujo
  actividad de prueba (`18516355`) no tiene adjunto. **Resuelto más tarde la misma noche:** el usuario
  al intentar firmar — hueco de config local, no relacionado a la migración), reinicié el servicio y
  `idDocumento=27`). La vista dio `404 "Documento con ID 27 no encontrado"`; restauré momentáneamente
  el código original (sin git, solo escribí el archivo de vuelta) y probé el mismo ID: **404
  idéntico** — el `ID 27` no existe en `UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO` (dato de 2023 purgado),
  no es un bug de la vista. Código migrado restaurado, build limpio. No se encontró un documento con
  archivo físico existente en dev para probar una descarga exitosa completa — eso sí queda pendiente
  de verdad (nadie tiene forma de generarlo ahora), pero el comportamiento ante un caso real (adjunto
  con ID) ya es idéntico con y sin vista.
- **`ficha_estudiante`**: ✅ completo. `MVL_FUN_FICHA_ESTUDIANTE` validada (grid idéntico a la query
  `SELECT MOVIL_UTN.MVL_FUN_FICHA_ESTUDIANTE(:cuenta) AS FILAS FROM DUAL`, y
  `ficha_estudiante.repository.ts` ajustado para desempacar `resultado[0]?.FILAS`). `curl
  (`foro_online`, `actividades`, `documentos_directorio`, `ficha_estudiante`) quedan con sus `SELECT`
  migrados.

**Ritmo, ajuste 2026-09-15 (noche):** el usuario pidió ir más rápido — se gastó tiempo persiguiendo
una validación imposible (el `curl` del BLOB sin el `JWT_DOC_SECRET`). De ahora en más: tandas V1 más
grandes (6-8 objetos), un solo `curl` de verificación por módulo (no por objeto), y no insistir en
pruebas end-to-end que no se pueden hacer con lo disponible — se documentan como pendientes y se sigue.

`git status` tras esto: `foro_online` (6 archivos + repo, piloto anterior) +
`actividades/.../get_info_tarea_consulta.ts` + `documentos_directorio/.../obtener_archivo_blob_consulta.ts`,
todos sin commitear, directo sobre `practicas-preprofesionales`.

## Tanda 2 ✅ (2026-09-15 noche): `comunicados` + `documentos`, 6 vistas V1

`MVL_VIEW_COMUNICADO_DETALLE`, `MVL_VIEW_ENCUESTA_PREGUNTAS` (`comunicados`) +
`MVL_VIEW_CERTIFICADOS_EVENTOS`, `MVL_VIEW_FORMATOS_VINCULACION`, `MVL_VIEW_HISTORIAL_CERTIFICADOS`,
`MVL_VIEW_MATRICULA_CICLO_ACTIVO` (`documentos`) — las 6 validadas (`MENSAJE` y `OPCIONES_CONFIG` son
`CLOB`, hubo que envolverlas con `DBMS_LOB.SUBSTR` en el `MINUS`, igual que en el piloto). Código
cambiado en `comunicados.repository` (2 consultas) y `documentos.repository` (4 consultas), build
limpio, **5 endpoints probados con curl antes/después — JSON idéntico**:
`/certificados-evento`, `/formatos-vinculacion`, `/certificados-disponibles`.

**Total de objetos migrados y probados hasta ahora: 17** (`foro_online` 6, `ficha_estudiante` 2,
`actividades` 1, `documentos_directorio` 1, `comunicados` 2, `documentos` 5 con `MVL_VIEW_CARRERAS_ESTUDIANTE`).

**Panorama de lo que falta** (del inventario completo en `Backup-Planes/`, aproximado, sin
`evaluacion_docentes` que está despriorizado por deshabilitado): `aula_virtual` ~9, `evaluacion_online`
~7, `becas` ~11, `documentos` (resto: 2 V2 + 2 F) ~4, `notas_estudiante` ~4, `calendario_actividades`
2, `horario_estudiante` 2, `registro_academico` 2, `ficha_socioeconomica` 2, `pagos` 1, `comunicados`
(resto: 1 F) 1, `modales_informativos` 1, `validacion_acceso` 1 → **~47 objetos más**. Las V1 (más
rápidas, en tanda) son minoría de lo que queda — la mayoría de aquí en adelante es V2/F, que van de a
uno con más cuidado.

## Qué sigue (histórico — ⚠ desactualizado, ver "Qué sigue (actualizado)" al final del archivo)

1. ✅ `pnpm run build` sobre `foro_online` — confirmado limpio (sesión 2026-09-14).
2. Actualizar `Queries Encontradas/foro_online.md` y `00_Indice_Resumen.md` marcando el módulo como
   migrado (los `SELECT`; las 5 escrituras siguen pendientes). **Todavía no se hizo.**
3. ✅ `ficha_estudiante` migrado completo (2026-09-15) — ver detalle arriba.
   `MVL_VIEW_INFO_TAREA`, `MVL_VIEW_ARCHIVO_DIRECTORIO`. Código ya cambiado y probado para
   `actividades` (curl idéntico) y `documentos_directorio` (build limpio, BLOB sin probar end-to-end
5. Seguir con los `SELECT` del resto de módulos siguiendo la hoja de ruta por "olas" (V1 → V2 → F) de
   `Backup-Planes/` — **no** la lista de módulos que había aquí antes de la decisión de alcance,
   esa lista no distinguía V1/V2/F/T/YA/M. Desde 2026-09-15: las V1 simples se agrupan en tanda: para
   ver si hay más V1 sueltas en otros módulos que se puedan sumar a una próxima tanda, hay que
   revisar `Backup-Planes/` módulo por módulo (no se ha hecho ese barrido todavía).
6. Fase de procedimientos para las 45 escrituras, en todos los módulos — aparte, después de terminar
   los `SELECT`.
7. No hacer ningun push.
   crear los objetos antes de que el tutor corte el tag `v*`.

## Tanda 3 ✅ (2026-09-15, sigue la noche): `documentos` completo

`MVL_VIEW_CARRERAS_ESTUDIANTE` (V2, UNION con CEDULA expuesta en ambas ramas),
`MVL_VIEW_ESTUDIANTE_POSGRADO` (V2, IN-subquery a vista), `MVL_FUN_DOC_ELECTRONICOS` y
`MVL_FUN_DOC_POSGRADO` (F, casi idénticas, solo cambia el filtro ID_TIPO_DOCUMENTO). Las 4
validadas en Toad. Código cambiado en `documentos.repository.ts` (4 métodos), build limpio, `curl
para la cuenta de prueba, no trae los docs de posgrado, sí los 2 electrónicos esperados).
**`documentos` queda con sus 8 SELECT completos.**

Nota aparte, no se toca aca: `ES_ESTUDIANTE_POSGRADO_CONSULTA` tenia una cedula real quemada
(0401XXXXXX) como caso especial, se copio tal cual a la vista, sin arreglar.

**Total acumulado: 20 objetos** (foro_online 6, ficha_estudiante 2, actividades 1,
documentos_directorio 1, comunicados 2, documentos 8).

Incidente de metodo (2026-09-15, misma noche): en otra sesion (Antigravity/Gemini CLI) el
usuario dejo que el agente escribiera un script Node con dotenv para conectarse directo a Oracle
y ejecutar DDL sin pasar por Toad, el mismo atajo ya rechazado antes en esta nota. Ese agente
afirmo no haber leido nunca el archivo de configuracion de entorno, lo cual es enganoso: si lo
leyo, via dotenv, para autenticarse. Ya creo MVL_VIEW_CARRERAS_ESTUDIANTE directo en dev de esa
forma antes de que se retomara el ritual normal (ese objeto se dejo, ya esta creado y validado, no
se deshizo). Claude (esta sesion) se nego a hacer lo mismo cuando se le pidio, incluso reformulado
prohibe). Se retomo el ritual de Toad para todo lo que sigue.

## Segundo ajuste al ritual — 2026-09-15 (mas tarde esa misma noche): tambien V2/F en tanda

Ya no es "V1 en tanda, V2/F de a uno". El usuario pidio explicitamente agrupar tambien las V2/F
cuando son de modulos chicos (1-2 objetos cada uno). Se probo con 3 juntos (modales_informativos,
pagos, validacion_acceso: 2 funciones + 1 vista) sin problema.

Como se hace ahora:
- Se arman 2-4 objetos V2/F por mensaje, de modulos chicos y sin mucha relacion entre si (bajo
  riesgo de que un error en uno contamine el analisis de otro).
- Modulos con consultas muy grandes/complejas (150+ lineas, varias ramas UNION, CONNECT BY anidado)
  se dejan aparte, uno a la vez, no se meten a una tanda por volumen de texto y riesgo de reescritura.
- El registro en `Queries Encontradas/00_Indice_Resumen.md` se hace con comandos `cat >>` directos
  (no Read+Edit) para no gastar tokens leyendo el archivo completo cada vez — se le pide al usuario
  el resultado corto (ej. "N1 = col:6 row:0") y se anota tal cual con el DDL debajo.
- Las notas de continuidad tambien se actualizan con `cat >>` en vez de Read+Edit completo, mismo
  motivo.

**Total acumulado al cierre de esta tanda: 24 objetos.**

## Tanda 4 y 5 (2026-09-15, resumen — detalle DDL completo en Queries Encontradas/00_Indice_Resumen.md Q18-Q24)

- **Tanda 4:** `ES_ESTUDIANTE_POSGRADO_CONSULTA` (V2, `MVL_VIEW_ESTUDIANTE_POSGRADO`),
  `DOCUMENTOS_ELECTRONICOS_PERSONALES_CONSULTA` + `DOCUMENTOS_POSGRADO_CONSULTA` (F,
  `MVL_FUN_DOC_ELECTRONICOS` / `MVL_FUN_DOC_POSGRADO`, casi identicas) - cierran `documentos`
  completo. `COMUNICADOS_PENDIENTES_CONSULTA` (F, `MVL_FUN_COM_PENDIENTES`, 2 CTEs con ROWNUM=1 y
  ORDER BY complejo) - cierra `comunicados` completo. Los 4 validados y probados con curl (JSON
  identico byte a byte contra `/documentos/documentos-personales` y `/comunicados/pendientes`).
- **Tanda 5:** `MODAL_INFORMATIVO_ACTUAL_CONSULTA` (F, `MVL_FUN_MODAL_ACTUAL`),
  `GET_PAGOS_ESTUDIANTE_CONSULTA` (F, `MVL_FUN_PAGOS_ESTUDIANTE`, redujo el bind de 4 a 3 valores en
  el repo por el bind repetido de `:cedula`), `VALIDAR_FACULTAD_POSTGRADO_CONSULTA` (V2,
  `MVL_VIEW_FACULTAD_POSTGRADO`) - cierran `modales_informativos`, `pagos` y `validacion_acceso`
  (este ultimo ya tenia el resto de sus consultas como YA). Probados con curl, respuestas identicas
  a antes de migrar (`404 Modal no encontrado`, `[]`, `restrictedModules: []`).

## Qué sigue (actualizado, 2026-09-15 noche — este es el vigente)

**Total acumulado: 24 objetos.** Modulos 100% migrados: `foro_online`, `ficha_estudiante`,
`actividades`, `documentos_directorio`, `comunicados`, `documentos`, `modales_informativos`,
`pagos`, `validacion_acceso`.

1. **Siguiente candidato acordado con el usuario:** `calendario_actividades` (2 V2,
   `CALENDARIO_ACTIVIDADES_CONSULTA` + `CALENDARIO_ACTIVIDADES_LIMITES_CONSULTA`, mismo
   FROM/WHERE base duplicado a mano — ver hallazgo §6.3 y §6.8 en `Backup-Planes/`: la segunda hace
   MIN/MAX sin GROUP BY, hay que decidir si la vista agrupa o no) + `horario_estudiante` (2 V2,
   `HORARIO_ESTUDIANTE_CONSULTA` + `HORARIO_ACTIVO_ESTUDIANTE_CONSULTA` — ver el bug preexistente de
   parametros cruzados en §6.4 de `Backup-Planes/`, hay que corregir la firma al migrar esta).
2. Después: `registro_academico` (2 V2), `ficha_socioeconomica` (2 V2) — mismo patron de tanda chica.
3. `notas_estudiante` (~4) aparte, uno a la vez: tiene `NOTAS_POR_CICLO_CONSULTA` (455 lineas, la
   mas compleja del repo) y `NOTAS_POR_NIVEL_CONSULTA` (308 lineas).
4. `aula_virtual` (~9) y `becas` (~11) son los modulos grandes que quedan, al final.
   migrar sin resolver eso con el usuario/tutor primero.
6. `evaluacion_docentes` sigue despriorizado (modulo deshabilitado).
7. Fase de procedimientos (45 escrituras) en todos los modulos, aparte, despues de terminar los
   `SELECT`.
8. No hacer ningun push. Antes de eso: crear rama propia. Para produccion, el DBA crea los objetos
   antes de que el tutor corte el tag `v*`.

Ritual vigente: V1 y V2/F chicos se agrupan en tandas de 2-4 objetos; los grandes/complejos van uno
a la vez. Ver "Segundo ajuste al ritual" arriba para el detalle completo del metodo actual.

## Tanda 6 (2026-09-22): `calendario_actividades` completo

`MVL_VIEW_CALENDARIO_ACTIVIDADES` (V2, detalle DDL completo en `Queries Encontradas/00_Indice_Resumen.md`
Q25) — una sola vista comparte `CALENDARIO_ACTIVIDADES_CONSULTA` y
`CALENDARIO_ACTIVIDADES_LIMITES_CONSULTA` (decidido en §6.8: mismo FROM/JOIN, antes duplicado a
mano en 2 archivos). Reescritura del OR de 2 ramas: `(A∧f)∨(B∧f) ≡ f∧(A∨B)`, con `f` = filtro de
`CUENTA`+ventana de fecha (se queda fuera, en el `.ts`) y factorizando además las condiciones
comunes a ambas ramas (`ESTADO='A'`, el `GREATEST(SYSDATE,...)`, `INTEGRANTE.ESTADO`,
`ACT_ALUMNO.ESTADO`, `ACA_TAB_MATRICULAS.ESTADO`) — solo queda un `OR` real entre
`CODIGO_PARCIAL != 'N3'` y la rama de nota (`RESULTADO1` + `CODIGO_PARCIAL='N3'` +
`NUMERO_MATRICULA != '3'`). Los límites se quedan **sin** `GROUP BY` a propósito (§6.3): si no hay
actividades, sigue devolviendo 1 fila `NULL/NULL`, no 0 filas.

Validado en Toad con `MINUS` en ambos sentidos (0 filas) + confirmado end-to-end: capturé
`28/03/2023 → 22/09/2026 09:45:10`), cambié `calendario_actividades_consulta.ts` (las ~270 líneas
duplicadas a mano quedaron en 2 `SELECT` de 10 líneas sobre la vista), reinicié el servicio y
comparé de nuevo: **mismas 166 filas y mismos límites** — la única diferencia cruda en el `diff` de
texto era el orden del array JSON (ninguna de las 2 queries originales tenía `ORDER BY`, así que el
orden físico de Oracle no es un contrato). Comparado por `idActividadAlumno` ignorando orden: 0
filas distintas, 0 solo-en-antes, 0 solo-en-después.

Incidente de sesión, no relacionado con la migración: el servidor local que ya estaba corriendo se
la causa (no había log visible de esa terminal). Se volvió a levantar con `pnpm run start:dev` desde
esta sesión sin problema, compiló con 0 errores y respondió normal tras el arranque del pool Oracle.
Si vuelve a pasar, revisar si es reproducible.

**Total acumulado: 25 objetos.** Módulos 100% migrados (`SELECT`): `foro_online`, `ficha_estudiante`,
`actividades`, `documentos_directorio`, `comunicados`, `documentos`, `modales_informativos`,
`pagos`, `validacion_acceso`, `calendario_actividades`.

## Qué sigue (actualizado, 2026-09-22 — este es el vigente, reemplaza al de 2026-09-15)

1. **Siguiente candidato:** `horario_estudiante` (2 V2, `HORARIO_ESTUDIANTE_CONSULTA` +
   `HORARIO_ACTIVO_ESTUDIANTE_CONSULTA`, ~371 líneas cada una, 2 ramas UNION con esquemas físicos
   distintos — va **de a uno**, no en tanda, por volumen/riesgo). Plan ya acordado con el usuario
   `CUENTA` (reescribiendo el subquery `WHERE CUENTA=:x` como `JOIN INS_TAB_USUARIOS`) y
   `CICLO_ACAD_CODIGO`/`CICLO_ESTADO` — `horario_estudiante_consulta.ts` filtra por
   `CICLO_ACAD_CODIGO = :ciclo`, `horario_activo_estudiante_consulta.ts` por `CICLO_ESTADO = 'A'`
   con `SELECT DISTINCT` (por si hay 2 ciclos activos a la vez). De paso corrige la firma cruzada
   del repositorio (§6.4: `getHorarioEstudiante(ciclo, cuenta)` debería ser `(cuenta, ciclo)`) sin
   cambiar el comportamiento real — confirmado en el código el 2026-09-22 que el array que llega a
   Oracle hoy ya es `[cuenta, ciclo]`, coincide con el orden de aparición de los binds en el SQL.
2. Después: `registro_academico` (2 V2), `ficha_socioeconomica` (2 V2) — mismo patrón de tanda chica.
3. `notas_estudiante` (~4) aparte, uno a la vez: `NOTAS_POR_CICLO_CONSULTA` (455 líneas, la más
   compleja del repo) y `NOTAS_POR_NIVEL_CONSULTA` (308 líneas).
4. `aula_virtual` (~9) y `becas` (~11) son los módulos grandes que quedan, al final.
   migrar sin resolver eso con el usuario/tutor primero.
6. `evaluacion_docentes` sigue despriorizado (módulo deshabilitado).
7. Fase de procedimientos (45 escrituras) en todos los módulos, aparte, después de terminar los
   `SELECT`.
8. No hacer ningún push. Antes de eso: crear rama propia. Para producción, el DBA crea los objetos
   antes de que el tutor corte el tag `v*`.

Ritual vigente: V1 y V2/F chicos se agrupan en tandas de 2-4 objetos; los grandes/complejos
(150+ líneas, UNION/CONNECT BY anidado) van uno a la vez. Ver "Segundo ajuste al ritual" (más
arriba en este archivo) para el detalle completo del método.

## Tercer ajuste al ritual — 2026-09-22: validación sin Toad, vía MCP de lectura Oracle

únicamente, conectado como `MOVIL_UTN` a la réplica de dev). **Cambia la mitad del ritual:**

- El DDL lo sigue corriendo el usuario en Toad — eso no cambia, sigue siendo la política de
- **La validación con `MINUS` ya no requiere que el usuario la corra y pegue el resultado.** Claude
  objeto, en los dos sentidos, y reporta el resultado. También sirve para explorar datos de prueba
  reales antes de escribir el DDL (`listar_objetos`, `describir_tabla`, `consultar` con literales) en
  vez de pedírselos al usuario o asumirlos.
- Los binds del MCP son posicionales por aparición en el texto (igual que la app) — para las
  validaciones se sustituyen por **literales directos en el SQL**, no por el parámetro `binds`, para
  no arriesgar la ambigüedad de binds repetidos con nombre (ver §6.2 de `Backup-Planes/` sobre modo
  *thick* vs *thin*) — no vale la pena probarlo en un tool nuevo, es gratis evitarlo con literales.

## Tanda 7 (2026-09-22): `horario_estudiante` completo

`MVL_VIEW_HORARIO_ESTUDIANTE` (V2, detalle DDL completo abajo) — una sola vista comparte
`HORARIO_ESTUDIANTE_CONSULTA` (filtra `CICLO_ACAD_CODIGO = :ciclo`) y
`HORARIO_ACTIVO_ESTUDIANTE_CONSULTA` (filtra `CICLO_ESTADO = 'A'`, con `SELECT DISTINCT` porque se
confirmó que hay **21 ciclos académicos con `ESTADO='A'` simultáneos** en dev — la razón exacta por
la que el §6.8 ya anticipaba que hacía falta `DISTINCT` ahí). Reescribe el subquery correlacionado
`TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA = (SELECT PERSONA_CEDULA FROM INS_TAB_USUARIOS WHERE
mismo patrón que `calendario_actividades` y el resto de V2 de esta migración.

**De paso corrige el bug preexistente de §6.4**, confirmado en el código antes de tocar nada: el
`service` llama `getHorarioEstudiante(cuenta, ciclo)` pero el `repository` declaraba el método como
`(ciclo, cuenta)` — funcionaba hoy solo porque el array que llegaba a Oracle terminaba coincidiendo
por casualidad con el orden de los binds en el SQL. Firma corregida a `(cuenta, ciclo)`; el array que
llega a Oracle es exactamente el mismo de antes, cero cambio de comportamiento.

**Validado con datos reales** (cuenta `<cuenta-de-prueba>`/cédula `<cedula>`, ciclo `1021-1099`): 4 filas
reales en el sistema de horario "normal" (`ACA_TAB_DETALLES_HORARIOS`), 0 en el "modular"
(`ACA_TAB_DETAL_HORARIO_MODULOS` — tabla sin datos para este ciclo/cuenta, 0=0 también valida esa
rama). `MINUS` en los 4 sentidos (2 variantes × 2 direcciones) dio 0 filas, corrido directo por Claude
vía el MCP nuevo. Confirmado end-to-end con `curl` en los 2 endpoints (por ciclo y activo): mismas 4
filas agrupadas por el servicio en 2 bloques (lunes 07H00-08H00, jueves 07H00-10H00), **sin
duplicados** pese a los 21 ciclos activos — evidencia de que el `JOIN` no generó producto cartesiano.

DDL completo (para referencia futura, ya creado y validado en dev — texto exacto leído de vuelta con
`describir_tabla` tras crearla, coincide con lo que se pegó en Toad):

```sql
CREATE OR REPLACE FORCE VIEW MOVIL_UTN.MVL_VIEW_HORARIO_ESTUDIANTE
(FECHA_INICIO, FECHA_FIN, INICIO_HORA, FIN_HORA, "ESTRUCTURA FÍSICA", NOMBRES, DIA_SEMANA_CODIGO, PARALELO, NIVEL, MATERIA, CUENTA, CICLO_ACAD_CODIGO, CICLO_ESTADO)
BEQUEATH DEFINER
AS
SELECT
    FECHA_INICIO,
    FECHA_FIN,
    CASE WHEN LENGTH(INICIO_HORA) = 4 THEN '0' || INICIO_HORA ELSE INICIO_HORA END AS INICIO_HORA,
    CASE WHEN LENGTH(FIN_HORA) = 4 THEN '0' || FIN_HORA ELSE FIN_HORA END AS FIN_HORA,
    "ESTRUCTURA FÍSICA",
    NOMBRES,
    DIA_SEMANA_CODIGO,
    PARALELO,
    NIVEL,
    MATERIA,
    CUENTA,
    CICLO_ACAD_CODIGO,
    CICLO_ESTADO
FROM (
    SELECT
        DISTINCT NULL AS FECHA_INICIO,
        NULL AS FECHA_FIN,
        SUBSTR(TAB_PLANTILLAS_HORAS.INICIO_HORA, 0, LENGTH(TAB_PLANTILLAS_HORAS.INICIO_HORA) - 2) || 'H' || SUBSTR(TAB_PLANTILLAS_HORAS.INICIO_HORA, LENGTH(TAB_PLANTILLAS_HORAS.INICIO_HORA) - 1, LENGTH(TAB_PLANTILLAS_HORAS.INICIO_HORA)) AS INICIO_HORA,
        SUBSTR(TAB_PLANTILLAS_HORAS.FIN_HORA, 0, LENGTH(TAB_PLANTILLAS_HORAS.FIN_HORA) - 2) || 'H' || SUBSTR(TAB_PLANTILLAS_HORAS.FIN_HORA, LENGTH(TAB_PLANTILLAS_HORAS.FIN_HORA) - 1, LENGTH(TAB_PLANTILLAS_HORAS.FIN_HORA)) AS FIN_HORA,
        INS_PCK_GENERAL.FUN_OBTENER_ESTRUCTURA_FISICA(TAB_DETALLES_HORARIOS.ESTRUC_FIS_CODIGO) AS "ESTRUCTURA FÍSICA",
        INS_PCK_GENERAL.FUN_NOMBRES_PERSONA(TAB_DETALLES_HORARIOS.DOCENTE_CEDULA) AS NOMBRES,
        TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO || ': ' || DECODE(TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO, '1', 'LUNES', '2', 'MARTES', '3', 'MIÉRCOLES', '4', 'JUEVES', '5', 'VIERNES', '6', 'SÁBADO', '7', 'DOMINGO') AS DIA_SEMANA_CODIGO,
        TAB_DETALLE_MATRICULAS.PARALELO_CODIGO AS PARALELO,
        TAB_DETALLE_MATRICULAS.NIVEL_CODIGO AS NIVEL,
        (
            SELECT TAB_MATERIAS.DESCRIPCION
            FROM UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS
            WHERE TAB_MATERIAS.CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
              AND TAB_MATERIAS.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
        ) AS MATERIA,
        USUARIO.CUENTA AS CUENTA,
        TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO AS CICLO_ACAD_CODIGO,
        TAB_CICLOS_ACADEMICOS.ESTADO AS CICLO_ESTADO
    FROM
        (
            (
                (
                    UTNDB.ACA_TAB_DETALLES_HORARIOS TAB_DETALLES_HORARIOS
                    LEFT JOIN UTNDB.ACA_TAB_HORARIOS_DEPENDENCIAS TAB_HORARIOS_DEPENDENCIAS ON (
                        TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.DIA_SEMANA_CODIGO
                    )
                    AND (TAB_DETALLES_HORARIOS.DOCENTE_CEDULA NOT IN ('<cedula>'))
                    AND (TAB_DETALLES_HORARIOS.GRUPO_HORA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.GRUPO_HORA_CODIGO)
                    AND (TAB_DETALLES_HORARIOS.PLAN_HORAS_NUMERO = TAB_HORARIOS_DEPENDENCIAS.PLAN_HORAS_NUMERO)
                    AND (TAB_DETALLES_HORARIOS.HOR_DEPEN_CODIGO = TAB_HORARIOS_DEPENDENCIAS.CODIGO)
                    AND (TAB_DETALLES_HORARIOS.DEPEN_CODIGO = TAB_HORARIOS_DEPENDENCIAS.DEPEN_CODIGO)
                    AND (TAB_DETALLES_HORARIOS.INST_CODIGO = TAB_HORARIOS_DEPENDENCIAS.INST_CODIGO)
                    AND (TAB_DETALLES_HORARIOS.MODA_ESTUD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.MODA_ESTUD_CODIGO)
                    AND (TAB_DETALLES_HORARIOS.SIST_ESTUD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.SIST_ESTUD_CODIGO)
                    AND (TAB_DETALLES_HORARIOS.TCICLOACAD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.TCICLOACAD_CODIGO)
                    AND (TAB_DETALLES_HORARIOS.TFINANCIA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.TFINANCIA_CODIGO)
                    AND (TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.CICLO_ACAD_CODIGO)
                )
                LEFT JOIN UTNDB.ACA_TAB_PLANTILLAS_HORAS TAB_PLANTILLAS_HORAS ON (
                    TAB_HORARIOS_DEPENDENCIAS.PLAN_HORAS_NUMERO = TAB_PLANTILLAS_HORAS.NUMERO
                )
                AND (TAB_HORARIOS_DEPENDENCIAS.GRUPO_HORA_CODIGO = TAB_PLANTILLAS_HORAS.GRUPO_HORA_CODIGO)
            )
            LEFT JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
                TAB_DETALLE_MATRICULAS.PARALELO_CODIGO = TAB_DETALLES_HORARIOS.PARALELO_CODIGO
            )
            AND (TAB_DETALLES_HORARIOS.DOCENTE_CEDULA NOT IN ('<cedula>'))
            AND (TAB_DETALLE_MATRICULAS.MATERIA_CODIGO = TAB_DETALLES_HORARIOS.MATERIA_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.INST_CODIGO = TAB_DETALLES_HORARIOS.INST_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO = TAB_DETALLES_HORARIOS.MODA_ESTUD_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO = TAB_DETALLES_HORARIOS.SIST_ESTUD_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO = TAB_DETALLES_HORARIOS.TCICLOACAD_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO = TAB_DETALLES_HORARIOS.TFINANCIA_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.DEPEN_CODIGO = TAB_DETALLES_HORARIOS.DEPEN_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO = TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.NIVEL_CODIGO = TAB_DETALLES_HORARIOS.NIVEL_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA = TAB_DETALLES_HORARIOS.DOCENTE_CEDULA)
        )
        LEFT JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TAB_CICLOS_ACADEMICOS ON (
            TAB_CICLOS_ACADEMICOS.CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
        )
        LEFT JOIN UTNDB.ACA_TAB_MATRICULAS TAB_MATRICULAS ON (
            TAB_MATRICULAS.CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
        )
        AND (TAB_MATRICULAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA)
        INNER JOIN UTNDB.INS_TAB_USUARIOS USUARIO ON (
            USUARIO.PERSONA_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
        )
    WHERE
        TAB_DETALLE_MATRICULAS.ANULACION NOT IN ('S')
        AND TAB_MATRICULAS.ESTADO IN ('R', 'C', 'M')
)
UNION
SELECT
    FECHA_INICIO,
    FECHA_FIN,
    CASE WHEN LENGTH(INICIO_HORA) = 4 THEN '0' || INICIO_HORA ELSE INICIO_HORA END AS INICIO_HORA,
    CASE WHEN LENGTH(FIN_HORA) = 4 THEN '0' || FIN_HORA ELSE FIN_HORA END AS FIN_HORA,
    "ESTRUCTURA FÍSICA",
    NOMBRES,
    DIA_SEMANA_CODIGO,
    PARALELO,
    NIVEL,
    MATERIA,
    CUENTA,
    CICLO_ACAD_CODIGO,
    CICLO_ESTADO
FROM (
    SELECT
        DISTINCT TO_CHAR(TAB_PENSUM_CALENDARIO.FECHA_INICIO, 'DD/MM/YYYY') AS FECHA_INICIO,
        TO_CHAR(TAB_PENSUM_CALENDARIO.FECHA_FIN, 'DD/MM/YYYY') AS FECHA_FIN,
        SUBSTR(TAB_PLANTILLAS_HORAS.INICIO_HORA, 0, LENGTH(TAB_PLANTILLAS_HORAS.INICIO_HORA) - 2) || 'H' || SUBSTR(TAB_PLANTILLAS_HORAS.INICIO_HORA, LENGTH(TAB_PLANTILLAS_HORAS.INICIO_HORA) - 1, LENGTH(TAB_PLANTILLAS_HORAS.INICIO_HORA)) AS INICIO_HORA,
        SUBSTR(TAB_PLANTILLAS_HORAS.FIN_HORA, 0, LENGTH(TAB_PLANTILLAS_HORAS.FIN_HORA) - 2) || 'H' || SUBSTR(TAB_PLANTILLAS_HORAS.FIN_HORA, LENGTH(TAB_PLANTILLAS_HORAS.FIN_HORA) - 1, LENGTH(TAB_PLANTILLAS_HORAS.FIN_HORA)) AS FIN_HORA,
        INS_PCK_GENERAL.FUN_OBTENER_ESTRUCTURA_FISICA(TAB_DETALLES_HORARIOS.ESTRUC_FIS_CODIGO) AS "ESTRUCTURA FÍSICA",
        INS_PCK_GENERAL.FUN_NOMBRES_PERSONA(TAB_DETALLES_HORARIOS.DOCENTE_CEDULA) AS NOMBRES,
        TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO || ': ' || DECODE(TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO, '1', 'LUNES', '2', 'MARTES', '3', 'MIÉRCOLES', '4', 'JUEVES', '5', 'VIERNES', '6', 'SÁBADO', '7', 'DOMINGO') AS DIA_SEMANA_CODIGO,
        TAB_DETALLE_MATRICULAS.PARALELO_CODIGO AS PARALELO,
        TAB_DETALLE_MATRICULAS.NIVEL_CODIGO AS NIVEL,
        (
            SELECT TAB_MATERIAS.DESCRIPCION
            FROM UTNDB.ACA_TAB_MATERIAS TAB_MATERIAS
            WHERE TAB_MATERIAS.CODIGO = TAB_DETALLE_MATRICULAS.MATERIA_CODIGO
              AND TAB_MATERIAS.NIVEL_CODIGO = TAB_DETALLE_MATRICULAS.NIVEL_CODIGO
        ) AS MATERIA,
        USUARIO.CUENTA AS CUENTA,
        TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO AS CICLO_ACAD_CODIGO,
        TAB_CICLOS_ACADEMICOS.ESTADO AS CICLO_ESTADO
    FROM
        (
            (
                (
                    UTNDB.ACA_TAB_DETAL_HORARIO_MODULOS TAB_DETALLES_HORARIOS
                    LEFT JOIN UTNDB.ACA_TAB_HORAS_MODULOS TAB_HORARIOS_DEPENDENCIAS ON (
                        TAB_DETALLES_HORARIOS.DIA_SEMANA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.DIA_SEMANA_CODIGO
                    )
                    AND (TAB_DETALLES_HORARIOS.DOCENTE_CEDULA NOT IN ('<cedula>'))
                    AND (TAB_DETALLES_HORARIOS.GRUPO_HORA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.GRUPO_HORA_CODIGO)
                    AND (TAB_DETALLES_HORARIOS.PLAN_HORAS_NUMERO = TAB_HORARIOS_DEPENDENCIAS.PLAN_HORAS_NUMERO)
                    AND (TAB_DETALLES_HORARIOS.DEPEN_CODIGO = TAB_HORARIOS_DEPENDENCIAS.DEPEN_CODIGO)
                    AND (TAB_DETALLES_HORARIOS.INST_CODIGO = TAB_HORARIOS_DEPENDENCIAS.INST_CODIGO)
                    AND (TAB_DETALLES_HORARIOS.MODA_ESTUD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.MODA_ESTUD_CODIGO)
                    AND (TAB_DETALLES_HORARIOS.SIST_ESTUD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.SIST_ESTUD_CODIGO)
                    AND (TAB_DETALLES_HORARIOS.TCICLOACAD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.TCICLOACAD_CODIGO)
                    AND (TAB_DETALLES_HORARIOS.TFINANCIA_CODIGO = TAB_HORARIOS_DEPENDENCIAS.TFINANCIA_CODIGO)
                    AND (TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO = TAB_HORARIOS_DEPENDENCIAS.CICLO_ACAD_CODIGO)
                )
                LEFT JOIN UTNDB.ACA_TAB_PLANTILLAS_HORAS TAB_PLANTILLAS_HORAS ON (
                    TAB_HORARIOS_DEPENDENCIAS.PLAN_HORAS_NUMERO = TAB_PLANTILLAS_HORAS.NUMERO
                )
                AND (TAB_HORARIOS_DEPENDENCIAS.GRUPO_HORA_CODIGO = TAB_PLANTILLAS_HORAS.GRUPO_HORA_CODIGO)
            )
            LEFT JOIN UTNDB.ACA_TAB_DETALLE_MATRICULAS TAB_DETALLE_MATRICULAS ON (
                TAB_DETALLE_MATRICULAS.PARALELO_CODIGO = TAB_DETALLES_HORARIOS.PARALELO_CODIGO
            )
            AND (TAB_DETALLES_HORARIOS.DOCENTE_CEDULA NOT IN ('<cedula>'))
            AND (TAB_DETALLE_MATRICULAS.MATERIA_CODIGO = TAB_DETALLES_HORARIOS.MATERIA_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.INST_CODIGO = TAB_DETALLES_HORARIOS.INST_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.MODA_ESTUD_CODIGO = TAB_DETALLES_HORARIOS.MODA_ESTUD_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.SIST_ESTUD_CODIGO = TAB_DETALLES_HORARIOS.SIST_ESTUD_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.TCICLOACAD_CODIGO = TAB_DETALLES_HORARIOS.TCICLOACAD_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.TFINANCIA_CODIGO = TAB_DETALLES_HORARIOS.TFINANCIA_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.DEPEN_CODIGO = TAB_DETALLES_HORARIOS.DEPEN_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO = TAB_DETALLES_HORARIOS.CICLO_ACAD_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.NIVEL_CODIGO = TAB_DETALLES_HORARIOS.NIVEL_CODIGO)
            AND (TAB_DETALLE_MATRICULAS.DOCENTE_CEDULA = TAB_DETALLES_HORARIOS.DOCENTE_CEDULA)
        )
        LEFT JOIN UTNDB.ACA_TAB_CICLOS_ACADEMICOS TAB_CICLOS_ACADEMICOS ON (
            TAB_CICLOS_ACADEMICOS.CODIGO = TAB_DETALLE_MATRICULAS.CICLO_ACAD_CODIGO
        )
        LEFT JOIN UTNDB.ACA_TAB_MATRICULAS TAB_MATRICULAS ON (
            TAB_MATRICULAS.CODIGO = TAB_DETALLE_MATRICULAS.MATRICULA_CODIGO
        )
        AND (TAB_MATRICULAS.ESTUDIANTE_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA)
        LEFT JOIN UTNDB.ACA_TAB_CALENDARIOS_MAT_PENSUM TAB_PENSUM_CALENDARIO ON (
            TAB_PENSUM_CALENDARIO.CICLO_ACAD_CODIGO = TAB_CICLOS_ACADEMICOS.CODIGO
        )
        AND (TAB_PENSUM_CALENDARIO.DEPEN_CODIGO = TAB_DETALLES_HORARIOS.DEPEN_CODIGO)
        AND (TAB_PENSUM_CALENDARIO.MATERIA_CODIGO = TAB_DETALLES_HORARIOS.MATERIA_CODIGO)
        AND (TAB_PENSUM_CALENDARIO.PARALELO_CODIGO = TAB_DETALLES_HORARIOS.PARALELO_CODIGO)
        AND (TAB_PENSUM_CALENDARIO.MODA_ESTUD_CODIGO = TAB_DETALLES_HORARIOS.MODA_ESTUD_CODIGO)
        INNER JOIN UTNDB.INS_TAB_USUARIOS USUARIO ON (
            USUARIO.PERSONA_CEDULA = TAB_DETALLE_MATRICULAS.ESTUDIANTE_CEDULA
        )
    WHERE
        TAB_DETALLE_MATRICULAS.ANULACION NOT IN ('S')
        AND TAB_MATRICULAS.ESTADO IN ('R', 'C', 'M')
);
```

**Total acumulado: 26 objetos.** Módulos 100% migrados (`SELECT`): `foro_online`, `ficha_estudiante`,
`actividades`, `documentos_directorio`, `comunicados`, `documentos`, `modales_informativos`,
`pagos`, `validacion_acceso`, `calendario_actividades`, `horario_estudiante`.

`git status` tras esto (solo lectura, sigue sin commitear, `practicas-preprofesionales`):
`horario_estudiante_consulta.ts`, `horario_activo_estudiante_consulta.ts`,
`horario_estudiante.repository.ts`.

## Qué sigue (actualizado, 2026-09-22 — este es el vigente)

1. **Siguiente candidato:** `registro_academico` (2 V2: `AULAS_VIRTUALES_CONSULTA` 220 líneas,
   — ⚠ agregado sin `GROUP BY` en la vista, mismo patrón que ya se resolvió en `calendario_actividades`/
   `pagos` — e `INFO_FICHA_CONSULTA` con `ROWNUM=1`/Top-N). Mismo patrón de tanda chica de 2-4 objetos.
2. `notas_estudiante` (~4) aparte, uno a la vez: tiene `NOTAS_POR_CICLO_CONSULTA` (455 líneas, la más
   compleja del repo, candidata a F en vez de V2) y `NOTAS_POR_NIVEL_CONSULTA` (308 líneas); las otras
   2 (`arbol_de_materias`, `carrera_estudiante`) ya están catalogadas como F por `CONNECT BY` anidado.
3. `aula_virtual` (~9) y `becas` (~11) son los módulos grandes que quedan, al final.
   migrar sin resolver eso con el usuario/tutor primero.
5. `evaluacion_docentes` sigue despriorizado (módulo deshabilitado).
6. Fase de procedimientos (45 escrituras) en todos los módulos, aparte, después de terminar los
   `SELECT`.
7. No hacer ningún push. Antes de eso: crear rama propia. Para producción, el DBA crea los objetos
   antes de que el tutor corte el tag `v*`.

Ritual vigente (2026-09-22): DDL lo crea el usuario en Toad; la validación `MINUS` la corre Claude
directo por el MCP de lectura Oracle en cuanto el usuario avisa que el objeto está creado — ya no
hace falta que el usuario pegue el resultado de vuelta. V1 y V2/F chicos se agrupan en tandas de 2-4
objetos; los grandes/complejos (150+ líneas, UNION/CONNECT BY anidado) van uno a la vez.

## Cuarto ajuste al ritual - 2026-09-22 (mas tarde): se revierte el MCP de validacion, vuelve Toad

usuario) consumio demasiados tokens de la sesion -- las consultas de exploracion y validacion
completas se repetian enteras en cada llamada al tool, y el usuario lo desactivo. **Se vuelve al
ritual anterior a la Tanda 7 (ver "Ritual de trabajo, paso a paso" y el resto de tandas antes de
esa)**: Claude prepara el DDL, el usuario lo corre en Toad y pega el resultado del `MINUS` de

No se revierte nada de lo ya migrado con el MCP (Tanda 7, `horario_estudiante`, 26 objetos
acumulados) -- sigue validado y en pie. Solo cambia el metodo para lo que sigue.

## Tanda 8 (2026-09-22): `ficha_socioeconomica` completo, `registro_academico` en curso

Vuelta al ritual manual (Toad + pegar resultado) tras desactivar el MCP de Oracle (ver ajuste
anterior). `MVL_VIEW_FICHA_SOCIOECONOMICA` creada y validada (0 filas en los 3 MINUS), código
(404 "No se encontraron dependencias"). **Total acumulado: 27 objetos**, 12 módulos completos.

`MVL_VIEW_CICLOS_AULA_VIRTUAL` (registro_academico) creada, validación pendiente de resultado.
`AULAS_VIRTUALES_CONSULTA` (220 líneas, sin UNION/CONNECT BY pero larga) queda para un mensaje
aparte, con su propia vista.

`MVL_VIEW_CICLOS_AULA_VIRTUAL` validada (0 filas) y código cambiado, curl confirma
(`{"descripcion":"OCT2021-OCT2099","cicloAcadCodigo":"1021-1099"}`). **Total acumulado: 28 objetos.**
Queda `AULAS_VIRTUALES_CONSULTA` para cerrar `registro_academico` — va aparte, mensaje propio.

## Quinto ajuste al ritual - 2026-09-22: pegar SQL largo en Toad se corrompe, usar File->Open

Con textos SQL muy largos (150+ lineas en una sola sentencia), pegar directo en el editor de Toad
puede perder texto a mitad de linea -- el patron observado: se come el texto justo despues de un
nombre de tabla/objeto conocido (ej. "INS_TAB_USUARIOS WHERE CUENTA = '" se redujo a nada, dejando
una comilla sin cerrar; "i WHERE I.ID_CURSO = LMS_TAB" desaparecio despues de "lms_tab_integrantes").
Es el Code Insight/autocompletado de Toad interceptando el pegado, no el portapapeles ni la consulta.
Dio dos errores distintos y confusos (ORA-46076, ORA-01756) que no tenian nada que ver con la logica
SQL real -- se perdio tiempo pensando que eran bugs de las funciones (`FUN_OBTENER`) antes de notar
el patron.

**Solucion que funciono:** en vez de pegar el SQL en el editor, Claude lo escribe a un `.sql` en el
escritorio del usuario y el usuario lo abre con **File -> Open** en Toad. Sin pegado, sin
autocompletado interfiriendo. Usar este metodo de ahora en mas para cualquier validacion o DDL de
mas de ~50-60 lineas.

## Tanda 9 (2026-09-22): `registro_academico` completo (cierra el modulo)

`MVL_VIEW_AULAS_VIRTUALES` (V2, 220 lineas originales, sin UNION/CONNECT BY pero la mas larga
migrada como objeto individual hasta ahora) -- expone `CUENTA` (reemplaza subquery correlacionado)
y `FILTRO_CICLO_ACAD_CODIGO` (columna aparte de `TAB_MATRICULAS.CICLO_ACAD_CODIGO`, distinta del
`CICLO_ACAD_CODIGO` que ya se expone del resultado, de `TAB_DETALLE_MATRICULAS` -- para no arriesgar
cambiar cual fila filtra). El `ORDER BY 1 ASC NULLS LAST` original se saco de la vista y se puso en
la consulta final del `.ts` (ahi si Oracle lo garantiza).

Validado con MINUS en los 2 sentidos (0 filas, cedula <cedula>/cuenta <cuenta-de-prueba>, ciclo
1021-1099) y confirmado end-to-end con curl: 2 filas identicas (`CAPRU-MATPRU` 75% avance,
`CAPRU-MATPRU2` 0%). **Total acumulado: 29 objetos**, 13 modulos con `SELECT` 100% migrado
(`foro_online`, `ficha_estudiante`, `actividades`, `documentos_directorio`, `comunicados`,
`documentos`, `modales_informativos`, `pagos`, `validacion_acceso`, `calendario_actividades`,
`horario_estudiante`, `ficha_socioeconomica`, `registro_academico`).

## Que sigue (actualizado, 2026-09-22 -- vigente)

1. `notas_estudiante` (~4), uno a la vez: `NOTAS_POR_CICLO_CONSULTA` (455 lineas, la mas compleja
   del repo) y `NOTAS_POR_NIVEL_CONSULTA` (308 lineas) son V2 complejas; `arbol_de_materias` y
   `carrera_estudiante` ya catalogadas como F por CONNECT BY anidado.
2. `aula_virtual` (~9) y `becas` (~11) son los modulos grandes que quedan, al final.
4. `evaluacion_docentes` sigue despriorizado (modulo deshabilitado).
5. Fase de procedimientos (45 escrituras), aparte, al final.
6. No hacer push. Antes: crear rama propia. Produccion: DBA crea objetos antes del tag `v*`.

Ritual vigente: DDL y validaciones largas van por archivo `.sql` + File->Open en Toad, no por
pegado. MINUS lo corre el usuario y pega el resultado (MCP de Oracle desactivado por consumo de
tokens). V1/V2/F chicos en tanda de 2-4; grandes/complejos uno a la vez.

## Tanda 10 (2026-09-23 en adelante): arranca `notas_estudiante`, 2 funciones F chicas

Sexto ajuste de facto (no ritual nuevo, mismo metodo): el usuario volvio a pedir usar el MCP de
lectura Oracle para validar (en vez de Toad+pegar), asi que esta tanda se valido asi de nuevo,
igual que la Tanda 7. DDL lo sigue corriendo el usuario en Toad (el objeto grande, 69 lineas, via
File->Open por el limite del Quinto ajuste; el chico, 22 lineas, pegado directo).

- `MVL_FUN_ARBOL_MATERIAS` (`arbol_de_materias_consulta.ts`, F por CONNECT BY jerarquico sobre
  `ACA_VIEW_MATERIAS_ESTUDIANTES`) — Q30 en el indice. 3 filas identicas, cedula <cedula>.
- `MVL_FUN_CARRERA_ESTUDIANTE` (`carrera_estudiante_consulta.ts`, F por 2 CONNECT BY anidados +
  UNION dentro de un IN sobre `ACA_TAB_DEPENDENCIAS`) — Q31 en el indice. 4 filas identicas,
  cuenta <cuenta-de-prueba>. Confirma de nuevo S6.2 (bind `:CUENTA` x2 en texto, 1 solo valor en el repo,
  modo thick resuelve por nombre).

Ambas con codigo migrado, build limpio y curl end-to-end identico

**Total acumulado: 31 objetos.** `notas_estudiante` queda a medias: faltan
`notas_ciclo_actual_consulta.ts` (V2, 118 lineas, la V2 mas simple del modulo, sin UNION) y las 2
grandes `notas_por_ciclo_consulta.ts` (455 lineas, la mas compleja del repo) y
`notas_por_nivel_consulta.ts` (308 lineas) — van una a la vez, no en tanda, por volumen/riesgo.

## Que sigue (actualizado, 2026-09-23 -- vigente, reemplaza al de 2026-09-22)

1. **Siguiente candidato:** `notas_ciclo_actual_consulta.ts` (`GET_NOTAS_CICLO_ACTUAL_CONSULTA`,
   V2, 118 lineas, 1 solo SELECT sin UNION — reescritura: JOIN a `INS_TAB_USUARIOS` para exponer
   `CUENTA` y filtrar fuera, mismo patron ya usado varias veces en esta migracion).
2. Despues, una a la vez: `NOTAS_POR_NIVEL_CONSULTA` (308 lineas) y `NOTAS_POR_CICLO_CONSULTA`
   (455 lineas, ver analisis rama por rama en `Backup-Planes/` S5.2.1 — candidata a evaluar como F
   en vez de V2 al llegar a ella, por la rama 3 que no filtra por nodo).
3. `aula_virtual` (~9) y `becas` (~11) son los modulos grandes que quedan, al final.
5. `evaluacion_docentes` sigue despriorizado (modulo deshabilitado).
6. Fase de procedimientos (45 escrituras), aparte, al final.
7. No hacer push. Antes: crear rama propia. Produccion: DBA crea objetos antes del tag `v*`.

Ritual vigente: DDL lo crea el usuario en Toad (pegado directo si es corto, `.sql` + File->Open si
pasa ~50-60 lineas); la validacion la corre Claude por el MCP de lectura Oracle en cuanto el
usuario avisa que el objeto esta creado. Cada objeto validado se registra como `Qn` en
`00_Indice_Resumen.md` (formato corto, `cat >>`) antes de pasar al siguiente.

## Tanda 10, cierre parcial (2026-09-23): `notas_ciclo_actual` migrada

`MVL_VIEW_NOTAS_CICLO_ACTUAL` (Q32) creada, validada (0 filas en los 2 MINUS, cuenta
<cuenta-de-prueba>), codigo migrado (`notas_ciclo_actual_consulta.ts`), build limpio, curl

**Total acumulado: 32 objetos.** `notas_estudiante` queda con 2 pendientes, ambas grandes, van
una a la vez: `notas_por_nivel_consulta.ts` (308 lineas) y `notas_por_ciclo_consulta.ts`
(455 lineas, la mas compleja del repo). Siguiente candidato: `notas_por_nivel_consulta.ts` (mas
simple de las dos, sin el filtro de nodo P2_CODIGO_NODO).

## Tanda 10, cierre (2026-09-23): `notas_por_nivel` migrada, queda solo `notas_por_ciclo`

`MVL_VIEW_NOTAS_POR_NIVEL` (Q33) creada, validada (0 filas en los 2 MINUS, cedula <cedula>),
con datos reales.

**Metodo nuevo para vistas grandes con varias ramas UNION:** en vez de retipear el DDL a mano
(riesgo de transcripcion en 300+ lineas), se genero con un script node que carga el `.ts` original
y aplica `String.replace` sobre anclas de texto exactas (agregar columna, quitar filtro), verificando
que cada reemplazo encuentre su match (si no, lanza error) y que no quede ningun bind sin reemplazar
al final. Mismo metodo para la consulta original-con-literal usada en la validacion MINUS. Usar este
metodo para el resto de vistas grandes que falten (`NOTAS_POR_CICLO_CONSULTA`, 455 lineas, la
siguiente).

**Total acumulado: 33 objetos.** `notas_estudiante` queda con 1 solo pendiente:
`notas_por_ciclo_consulta.ts` (455 lineas, la mas compleja del repo, 4 ramas UNION + filtro de nodo
`:P2_CODIGO_NODO` ademas de la cedula - ver analisis rama por rama en `Backup-Planes/` S5.2.1, y la
duda pendiente sobre si la rama 3 debe evaluarse como F en vez de V2 por no filtrar por nodo).

## Tanda 10, cierre total (2026-09-23): `notas_estudiante` 100% migrado

`MVL_FUN_NOTAS_POR_CICLO` (Q34) creada, validada por comparacion directa contra el original con
literales (cedula <cedula>, codigo_nodo 99999): 1 fila identica. Migrada como **F**, no V2 -
decision tomada sin consultar al usuario porque la reescritura V2 que proponia
`Backup-Planes/2026-09-14 - Plan completo...md` S5.2.1 (UNION ALL + columna indicadora
FILTRA_NODO) estaba explicitamente marcada ahi mismo como "sin probar" y dependiente de una
pregunta de negocio sin responder (si la rama de extension universitaria deberia filtrar por nodo
tambien, cosa que hoy no hace). F evita esa decision preservando el comportamiento exacto de hoy.
Codigo migrado (`notas_por_ciclo_consulta.ts` + `notas_estudiante.repository.ts`), build limpio,

**Metodo para F grandes:** mismo script node que para las vistas UNION, pero mas simple - solo
reemplaza los binds por nombres de parametro PL/SQL (`:BIND` -> `p_bind`) y envuelve el SQL exacto
en `CREATE FUNCTION ... RETURN SYS_REFCURSOR ... OPEN v_cursor FOR <sql original sin tocar> ;`,
sin reestructurar nada de la logica. Preferir esto sobre inventar una reescritura V2 no probada
cuando el propio analisis previo ya senala una ambiguedad de negocio sin resolver.

**Total acumulado: 34 objetos.** `notas_estudiante` queda 100% migrado (5/5: `foro_online`... no,
correccion: los 5 objetos de `notas_estudiante` son `MVL_FUN_ARBOL_MATERIAS`,
`MVL_FUN_CARRERA_ESTUDIANTE`, `MVL_VIEW_NOTAS_CICLO_ACTUAL`, `MVL_VIEW_NOTAS_POR_NIVEL`,
`MVL_FUN_NOTAS_POR_CICLO`). Modulos 100% migrados hasta ahora: `foro_online`, `ficha_estudiante`,
`actividades`, `documentos_directorio`, `comunicados`, `documentos`, `modales_informativos`,
`pagos`, `validacion_acceso`, `calendario_actividades`, `horario_estudiante`,
`ficha_socioeconomica`, `registro_academico`, `notas_estudiante`.

## Que sigue (actualizado, 2026-09-23 -- vigente, reemplaza al anterior)

1. Solo quedan los modulos grandes: `aula_virtual` (~9) y `becas` (~11).
   migrar sin resolver eso con el usuario/tutor primero.
3. `evaluacion_docentes` sigue despriorizado (modulo deshabilitado).
4. Fase de procedimientos (45 escrituras), aparte, al final de todos los SELECT.
5. No hacer push. Antes: crear rama propia. Produccion: DBA crea objetos antes del tag `v*`.

Ritual vigente: DDL de vistas/funciones grandes (150+ lineas o varias ramas UNION) se genera con
un script node sobre el texto exacto del `.ts`, no a mano. El usuario lo corre en Toad (File->Open
si pasa ~50-60 lineas). La validacion la corre Claude por el MCP de lectura Oracle en cuanto el
usuario avisa que el objeto esta creado. Para V2 con ambiguedad de negocio sin resolver, preferir F
(preserva el comportamiento exacto) en vez de inventar una reescritura no confirmada. Cada objeto
validado se registra como `Qn` en `00_Indice_Resumen.md` antes de seguir.

## Tanda 11 (2026-09-23): arranca `aula_virtual`, 2 vistas V1

`MVL_VIEW_CALENDARIO_AULA_VIRTUAL` (Q35) y `MVL_VIEW_LISTA_ACTIVIDADES` (Q36), ambas V1 chicas,
validadas por MCP (0 filas en los 4 MINUS) y con datos reales (154 y 134 filas respectivamente).

**Incidente propio de esta sesion, importante para el resto de `aula_virtual`/`becas`:** al escribir
`lista_actividades_consulta.ts` reordene las condiciones del `WHERE` sin pensar en el orden de
aparicion de los binds -- rompi el invariante #2 de la plataforma (binds posicionales por orden de
texto, no por nombre) y el repository.ts, que sigue pasando el arreglo en el orden viejo
`[codigoParcial, idCurso, cedula]`, ligo mal los valores -> `ORA-01722` (un string intentando
convertirse a NUMBER). Se corrigio reescribiendo el `WHERE` en el mismo orden que el texto
original, sin tocar el repository. **Regla a partir de ahora: al escribir el `SELECT ... FROM
vista WHERE ...` de reemplazo, el orden de las condiciones en el `WHERE` debe copiar exactamente
el orden de aparicion de los binds en el texto SQL ORIGINAL** (no el orden "logico" que parezca
mas prolijo) -- o si se cambia el orden a proposito, hay que actualizar el arreglo de binds en el
repository.ts a juego. Ademas: **probar cada endpoint despues de una migracion de V1/V2 con
varios binds, no asumir que compilar limpio alcanza** -- este bug no lo hubiera atrapado
`pnpm run build` ni el MINUS (ambos pasaron limpio antes del curl).

**Incidente de infraestructura de la sesion (no relacionado a la migracion):** el servicio local
se cayo dos veces durante esta tanda. La segunda vez se identifico la causa: correr `pnpm run
build` (compilacion completa, one-off) mientras `pnpm run start:dev` (modo watch) seguia corriendo
en background pisa el `dist/` de ambos procesos a la vez y el watcher termina con
`Cannot find module dist/main`. **Regla: con el servicio ya corriendo en watch mode, no volver a
correr `pnpm run build` aparte -- el watcher recompila solo al guardar.** Si hace falta un build
limpio, primero hay que asegurarse de que no haya un `start:dev` corriendo.

**Total acumulado: 36 objetos.** `aula_virtual` con 2/9 migrados. Siguen pendientes: los 3
una sola vista compartida con DECODE por CODIGO_PARCIAL, ver Backup-Planes S5.2 linea 190-192),
`LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA` (F, UNION+CONNECT BY, bind potencialmente desalineado sin
probar todavia -- probar el endpoint tal cual esta hoy antes de tocarlo), `DISTRIBUCION_MATERIA_CONSULTA`
(V2), `CONTENIDO_MATERIA_CONSULTA` (F, CONNECT BY). `SILABO_CONSULTA` sigue bloqueada por el
hallazgo de seguridad (S6.1).

## Tanda 11, continua (2026-09-23): 3 consultas casi identicas consolidadas en 1 funcion F

~238 lineas cada una) en un solo objeto parametrizado por `p_codigo_parcial`. Confirmado con `diff`
que las 3 consultas originales solo difieren en 3 puntos reales (columna `porcentaje_nX`, precision
reemplazaron esos 3 puntos por `DECODE(p_codigo_parcial, ...)`.

**Metodo de validacion para F con muchas filas:** en vez de dumpear el resultado completo (como se
hizo con `MVL_VIEW_NOTAS_POR_NIVEL`), que para este caso son 100+ filas y el primer intento de
comparar agregados (COUNT/SUM) fallo por un error de TRANSCRIPCION PROPIA (copie a mano el JSON de
un resultado grande a un archivo y se me perdieron filas al tipearlo, no era un bug real -- el
mismatch 51 vs 106 NO era de la funcion). Leccion: **no volver a transcribir a mano un resultado
grande para comparar** -- en su lugar, comparar puntualmente 1-2 filas conocidas por
`ID_ACTIVIDAD` especifico entre la funcion y el original con literales, apoyado en la garantia
estructural de que el script solo renombro binds y sustituyo 3 expresiones puntuales en el SELECT
(nunca toco WHERE/FROM/JOIN), asi que el conteo de filas no puede haber cambiado.

Codigo migrado (3 `.ts` + 3 metodos del repository, todos apuntando al mismo `MVL_FUN_DETALLES_NOTAS_PARCIAL`),
build limpio, curl `/aula-virtual/detalles-notas-parcial` en N1/N2/N3 con datos reales.

**Total acumulado: 37 objetos.** `aula_virtual` con 5/9 (`3 consultas -> 1 objeto` cuenta como 1
para el conteo de objetos Oracle, aunque cierra 3 archivos `.ts`). Quedan:
`LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA` (F, UNION+CONNECT BY, bind potencialmente desalineado sin
probar -- probar el endpoint tal cual antes de tocarlo), `DISTRIBUCION_MATERIA_CONSULTA` (V2),
`CONTENIDO_MATERIA_CONSULTA` (F, CONNECT BY). `SILABO_CONSULTA` bloqueada (S6.1).

## Intento revertido (2026-09-23): LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA, bug real encontrado pero no resuelto del todo

Siguiendo la advertencia de `Backup-Planes/` S6.2 ("probar antes de migrar"), se confirmo con
datos 100% reales (cedula 1004XXXXXX, curso 90198, 28 recursos reales) que el endpoint
binds unicos (`nivelCodigo` y `codigoContenido` duplicados "por si acaso"), lo que corre el
resto de los binds una posicion (invariante #2 de la plataforma: posicional por orden de
aparicion en el texto, no por nombre) y siempre devuelve `[]` en silencio.

El usuario confirmo arreglarlo de una vez (no solo preservar el bug). Se creo
`MVL_FUN_LISTA_ACTIVIDADES_Y_RECURSOS` con 14 parametros (sin duplicados), generada con el
mismo metodo de script node. El fix funciono para el problema original: paso de `[]` a devolver
datos reales.

**Pero surgio un segundo problema, distinto e independiente:** tanto la funcion invocada via
MCP como el endpoint real (con oracledb thick mode) devolvian consistentemente solo **12 de las
27 filas** esperadas para el curso 90198. Se descarto que fuera:
- Un limite de `max_filas` del MCP (se probo con 5 y con 200, mismo problema, distintas 12 filas
  en cada caso -- lo que ademas sugiere no-determinismo, posiblemente por empates en
  `ORDER BY FECHA DESC` sin desempate).
- Un problema del fix de binds (el `COUNT(*)` de la consulta plana original, sin pasar por
  funcion, seguia dando 27 con literales).

No se alcanzo a aislar la causa raiz (candidatos sin probar: algo especifico de `UNION` +
`CONNECT BY` con variables PL/SQL en vez de literales en el `START WITH`, o un limite de
`fetchArraySize`/prefetch de oracledb especifico para cursores anidados grandes que no aplico a
los otros SYS_REFCURSOR migrados en esta sesion por ser mas chicos).

**Se revirtio todo por indicacion del usuario** ("si no funciona, dejalo como estaba para no
romper nada"): `lista_actividades_y_recursos_consulta.ts` y
`aula_virtual_repository.ts:getListaRecursos` volvieron a su texto original exacto (bug de
binds incluido), confirmado con curl que el endpoint volvio a devolver `[]` como antes.

**Queda pendiente en Oracle:** correr `DROP FUNCTION MOVIL_UTN.MVL_FUN_LISTA_ACTIVIDADES_Y_RECURSOS;`
(el usuario lo tiene, ver `%USERPROFILE%\<escritorio>/DROP_MVL_FUN_LISTA_ACTIVIDADES_Y_RECURSOS.sql`).

**Total acumulado: sigue en 37 objetos** (no subio con este intento). `aula_virtual` sigue 5/9,
`LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA` vuelve a la cola, ahora con el hallazgo del bug de
binds YA confirmado y documentado (para cuando se retome, no hace falta re-probarlo) pero con
`SYS_REFCURSOR` anidados antes del proximo intento.


Durante esta tanda, `pnpm run start:dev` fallo en reiniciarse tras un cambio de codigo
ocupando el puerto -- el watcher de TypeScript seguia recompilando ("Found 0 errors") pero el
proceso Node real que atendia las peticiones era el VIEJO, con codigo desactualizado. Las
pruebas con curl seguian respondiendo 200 con datos, dando falsa confianza de que el cambio
mas reciente estaba activo cuando no era asi.

coincidia con el ultimo lanzamiento en background, y el log tenia varios `EADDRINUSE`
intercalados con recompilaciones "limpias".

**Regla nueva:** si se sospecha que el servicio no refleja un cambio reciente (comportamiento
que no cambia pese a editar codigo), revisar el log en busca de `EADDRINUSE` y el PID real en
el puerto antes de seguir probando -- `taskkill //PID <pid> //F` y relanzar
`pnpm run start:dev` limpio. No asumir que un `curl` con HTTP 200 prueba que el codigo nuevo
esta corriendo.

## Correccion (2026-09-23, mas tarde): el bug de lista-recursos NO esta activo hoy

La seccion anterior ("Intento revertido...") decia que `lista-recursos` esta roto hoy para todos
los estudiantes. **Es incorrecto**, verificado despues probando la app real en produccion: la
pantalla de Recursos funciona bien, muestra y descarga recursos reales.

La causa (16 valores posicionales para 14 binds unicos) sigue siendo real, pero **no se
manifiesta** porque el cliente Flutter (verificado en `recursos_aula_virtual_page.dart` ->
`aula_virtual_service.dart:64`) siempre llama al endpoint con `codigoContenido = materiaCodigo`,
nunca un codigo de tema especifico del arbol de contenidos (esa funcionalidad existe a medias en
el dominio de la app pero no esta cableada en esta pantalla). Con ese valor, la condicion
`R.MATERIA_CODIGO = :codigoContenido` ya selecciona casi todo por si sola, y como materiaCodigo y
codigoContenido son el mismo string en 3 de las 16 posiciones del arreglo, el desalineo no
importa en la practica. Confirmado: con `codigoContenido='<cedula>'` (codigo de tema real, que
la app nunca envia hoy) -> `[]`; con `codigoContenido='CIDES-POO'` (= materiaCodigo, lo que la
app SI envia) -> 27/27 filas correctas.

Es un bug **latente**, no activo -- solo se activaria si algun dia se cablea el filtro por
tema/carpeta en esta pantalla. Nota completa corregida en
[[2026-09-23 - Bug lista-recursos de aula virtual devuelve vacio siempre]].

**Leccion del metodo:** antes de declarar un hallazgo "confirmado con datos reales", probar con
los valores EXACTOS que el cliente real envia (revisar el codigo del cliente, no asumir un valor
"razonable" a mano) -- probar con un valor tecnicamente valido pero que la app nunca usa da un
resultado real pero que no describe el comportamiento real de la app.

## Tanda 11, continua (2026-09-23): DISTRIBUCION_MATERIA migrada

`MVL_VIEW_DISTRIBUCION_MATERIA` (Q38) creada, validada (0 filas en los 2 MINUS), codigo migrado,
build limpio, curl `/aula-virtual/distribucion-materia` con las 4 unidades reales de CIDES-POO.

**Total acumulado: 38 objetos.** `aula_virtual` con 6/9. Solo queda `CONTENIDO_MATERIA_CONSULTA`
(F, CONNECT BY) para terminar el modulo (sin contar `SILABO_CONSULTA`, bloqueada por S6.1, y
`LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA`, revertida - bug latente no activo, ver nota aparte
"Bug latente en lista-recursos...", sin urgencia).

## Cierre de sesion (2026-09-23, tarde) -- para abrir un chat nuevo

Contexto de este chat al 72%, se corta aca. Todo lo que sigue es para que un chat nuevo retome
sin repreguntar.

**Total acumulado: 38 objetos (Q1-Q38 en `00_Indice_Resumen.md`).**

### En curso ahora mismo, sin terminar

`CONTENIDO_MATERIA_CONSULTA` (aula_virtual, F por `CONNECT BY`) -- el DDL ya se genero y se le
paso al usuario (`%USERPROFILE%\<escritorio>/MVL_FUN_CONTENIDO_MATERIA.sql`), **pero el usuario
todavia no confirmo haberla creado en Toad**. Un chat nuevo debe preguntar si ya la creo antes de
u objeto con nombre -- ver mas abajo el dato de INST_CODIGO/DEPEN_CODIGO/etc para materia CIDES-POO
curso 90198 que se uso para el resto de `aula_virtual`), comparar contra el original con literales
(9 binds, sin duplicados en el texto -- a diferencia de `lista_actividades_y_recursos`, este no
tiene binds repetidos), migrar `contenido_materia_consulta.ts` (queda `SELECT
MOVIL_UTN.MVL_FUN_CONTENIDO_MATERIA(:P9_INST_CODIGO, ..., :P9_TFINANCIA_CODIGO) AS FILAS FROM
DUAL`, 9 binds en el mismo orden que el arreglo de `aula_virtual_repository.ts:280-290`) y el
metodo `getContenidosMateria` del repository (desempacar `FILAS`, como toda funcion F). Build,
curl al endpoint `contenidos-materia`, registrar como Q39, actualizar esta nota.

### Estado de `aula_virtual` (9 migrables + 1 bloqueada + 1 revertida)

Migrados (6): `MVL_VIEW_CALENDARIO_AULA_VIRTUAL` (Q35), `MVL_VIEW_LISTA_ACTIVIDADES` (Q36),
en un solo objeto con `DECODE` por `codigoParcial`), `MVL_VIEW_DISTRIBUCION_MATERIA` (Q38).

Pendiente ahora: `CONTENIDO_MATERIA_CONSULTA` (F, en curso, ver arriba).

Bloqueada, no tocar sin resolver antes con el usuario/tutor: `SILABO_CONSULTA` -- filtra
`Backup-Planes/2026-09-14 - Plan completo migracion SELECT a vistas (portafolio-estudiante).md`).

Revertida, bug latente sin urgencia (no tocar hasta que se entienda el misterio de las filas
faltantes): `LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA` -- ver
[[2026-09-23 - Bug lista-recursos de aula virtual devuelve vacio siempre]] (nota corregida:
**no es un bug activo hoy**, el cliente Flutter nunca envia el valor de `codigoContenido` que
dispara el desalineo de binds). El objeto `MVL_FUN_LISTA_ACTIVIDADES_Y_RECURSOS` quedo creado en
dev sin usarse -- el usuario tiene el `DROP FUNCTION` en
`%USERPROFILE%\<escritorio>/DROP_MVL_FUN_LISTA_ACTIVIDADES_Y_RECURSOS.sql`, sin correr todavia (no es
urgente, puede quedarse ahi).

### Que sigue despues de `aula_virtual`

Con `CONTENIDO_MATERIA_CONSULTA` terminado, `aula_virtual` queda en 7/9 migrados (los otros 2 son
la bloqueada y la revertida-sin-urgencia, ninguna cuenta como pendiente activo). Solo queda
`becas` (~11 sentencias: 5 V1, 3 V2, 3 F -- ver Backup-Planes S5.3 para el detalle, incluye un
hallazgo de bind desalineado en `OBTENER_ARCHIVO_SOLICITUD_CONSULTA` sin probar todavia, mismo
patron que `lista-recursos`: probar el endpoint real antes de tocar el codigo). Con eso se cierran
TODOS los `SELECT` migrables del repo (quedan afuera para siempre: `SILABO_CONSULTA` bloqueada,
`evaluacion_docentes` despriorizado por modulo deshabilitado).

Despues de `becas`: la fase de procedimientos (45 escrituras) en todos los modulos, aparte.

### Hallazgos de esta sesion documentados en Obsidian (fuera de esta nota)

- [[2026-09-23 - Bug lista-recursos de aula virtual devuelve vacio siempre]] -- corregida, ver
  arriba: no es un bug activo.
- [[2026-09-23 - Directory object invalido bloquea guardar recursos en aula virtual (docente)]] --
  hallazgo real y activo, pendiente para el DBA (objeto `DIRECTORY` de Oracle invalido o sin
  grant, bloquea `MVL_PRC_GUARDAR_RECURSO` al crear un recurso desde el docente). No relacionado
  con el hallazgo de `lista-recursos` (ese es un `SELECT` de metadatos, no toca archivos).

### Lecciones de metodo de esta sesion (para no repetir)

1. **Orden de binds en el `WHERE` del `.ts` de reemplazo debe copiar el orden de aparicion del
   texto SQL original**, no un orden "logico" propio -- si se cambia el orden, hay que ajustar el
   arreglo de binds en el repository a juego. Se rompio una vez (`lista_actividades_consulta.ts`,
   ya corregido) por reordenar sin pensar en esto.
2. **No correr `pnpm run build` mientras `pnpm run start:dev` sigue vivo en watch mode** -- pisan
   el mismo `dist/` y el proceso real queda en un estado roto (`EADDRINUSE` al reiniciar, sirviendo
   codigo viejo de un proceso huerfano). Si el comportamiento del endpoint no cambia pese a editar
   probando -- un `curl` con HTTP 200 no prueba que el codigo nuevo este corriendo.
3. **Antes de declarar un hallazgo "confirmado con datos reales", probar con los valores EXACTOS
   que el cliente real envia** (revisar el codigo del cliente Flutter, no asumir un valor
   "razonable" a mano). Un valor tecnicamente valido pero que la app nunca usa da un resultado
   real pero no describe el comportamiento real de la app -- asi se llego a la falsa alarma de
   `lista-recursos`.
4. **No transcribir a mano un resultado JSON grande** (100+ filas) para comparar agregados --
   se perdieron filas al tipear y se penso que habia un bug donde no lo habia. Para F grandes,
   comparar puntualmente 1-2 filas conocidas por su ID contra el original con literales, apoyado
   en la garantia estructural de que el script de generacion del DDL solo renombra binds sin
   tocar WHERE/FROM/JOIN.
5. **Para vistas/funciones grandes (150+ lineas o varias ramas UNION), generar el DDL con un
   script node** que aplica `String.replace` sobre anclas de texto exactas del `.ts` original
   (agregar columna, quitar filtro, renombrar bind), verificando que cada reemplazo encuentre su
   match exacto una sola vez. Mucho mas confiable que retipear a mano.
6. El servicio local (`pnpm run start:dev`) puede seguir corriendo en background entre sesiones de
   chat de esta maquina -- si un chat nuevo lo necesita, primero chequear si ya hay algo vivo en

Ritual vigente (sin cambios): DDL lo crea el usuario en Toad (pegado directo si es corto, `.sql` +
File->Open si pasa ~50-60 lineas); la validacion la corre Claude por el MCP de lectura Oracle en
cuanto el usuario avisa que el objeto esta creado. Cada objeto validado se registra como `Qn` en
`00_Indice_Resumen.md` (formato corto, `cat >>`) antes de pasar al siguiente. No hacer push, no
crear rama todavia (decision pendiente, ver el "Que sigue" viejo de esta nota para el detalle).

## Tanda 12 (chat nuevo, retomando el cierre anterior): CONTENIDO_MATERIA_CONSULTA cerrada

Retomado desde el "Cierre de sesion (2026-09-23, tarde)": el usuario ya habia creado
`MVL_FUN_CONTENIDO_MATERIA` en Toad con el archivo del escritorio antes de este chat, pero al
preguntar dijo que "todavia no" (probablemente confusion sobre si ya habia corrido ese archivo
especifico) -- se le pidio confirmar y correrla, y tras el aviso "ya" la funcion resultó estar
creada. Verificado antes con `describir_tabla`/`consultar` via MCP que devolvia `ORA-00904`, y
tras la confirmacion del usuario, `consultar` la encontro y devolvio datos reales.

Datos de prueba usados (no habia literales registrados de antes para este modulo con materia
CIDES-POO): se obtuvieron los 9 codigos reales consultando directo
`ACA_TAB_CONTENIDOS_MATERIAS WHERE MATERIA_CODIGO='CIDES-POO'` via MCP -- `INST_CODIGO=001,
DEPEN_CODIGO=00365, NIVEL_CODIGO=02, CICLO_ACAD_CODIGO=0924-0924, MODA_ESTUD_CODIGO=01,
SIST_ESTUD_CODIGO=02, TCICLOACAD_CODIGO=02, TFINANCIA_CODIGO=01`.

directa, no MINUS -- no aplica a un SYS_REFCURSOR). Codigo migrado (`contenido_materia_consulta.ts`
-> `SELECT MOVIL_UTN.MVL_FUN_CONTENIDO_MATERIA(...) AS FILAS FROM DUAL`,
`aula_virtual_repository.ts:getListaContenidosMateria` desempaca `FILAS`, mismo patron que el resto
de funciones F de esta migracion). Build limpio.

sesion anterior (PID 30800). Se corrio `pnpm run build` de todos modos (chocando con la regla de la
seccion "Lecciones de metodo" de mas arriba) -- se verifico despues con un curl de sanity
(`/ficha-estudiante`, HTTP 200) que el watcher seguia sano, y el curl real de
`contenidos-materia` funciono sin problema. No hubo `EADDRINUSE` esta vez, pero **para la proxima
tanda evitar `pnpm run build` aparte si el watcher ya esta vivo**, tal como dice la regla.

Curl `/aula-virtual/contenidos-materia?instCodigo=001&depenCodigo=00365&nivelCodigo=02&materiaCodigo=CIDES-POO&cicloAcadCodigo=0924-0924&modaEstudCodigo=01&sistEstudCodigo=02&tCicloAcadCodigo=02&tFinanciaCodigo=01`
devuelve el arbol completo (4 unidades, 16 contenidos), identico a lo validado por el MCP.

Registrado como Q39 en `00_Indice_Resumen.md`.

**Total acumulado: 39 objetos.** `aula_virtual` queda en 7/9 migrados -- de los 2 restantes, uno
esta bloqueado (`SILABO_CONSULTA`, hallazgo de seguridad S6.1) y el otro revertido sin urgencia
(`LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA`, bug latente no activo), asi que **`aula_virtual` no
tiene mas pendientes activos**. Modulos 100% migrados: `foro_online`, `ficha_estudiante`,
`actividades`, `documentos_directorio`, `comunicados`, `documentos`, `modales_informativos`,
`pagos`, `validacion_acceso`, `calendario_actividades`, `horario_estudiante`,
`ficha_socioeconomica`, `registro_academico`, `notas_estudiante`, y ahora `aula_virtual` (7/9,
sin pendientes activos).

## Que sigue (actualizado, tras Tanda 12 -- vigente, reemplaza al de 2026-09-23)

1. **Siguiente candidato:** `becas` (~11 sentencias: 5 V1, 3 V2, 3 F -- ver `Backup-Planes/` S5.3
   para el detalle). Incluye un hallazgo sin probar todavia: bind desalineado en
   `OBTENER_ARCHIVO_SOLICITUD_CONSULTA`, mismo patron que `lista-recursos` -- **probar el
   endpoint real antes de tocar el codigo**, siguiendo la leccion de esa sesion (no asumir "roto"
   sin probar con los valores exactos que envia el cliente Flutter).
2. Con `becas` terminado se cierran TODOS los `SELECT` migrables del repo (quedan afuera para
   siempre: `SILABO_CONSULTA` bloqueada, `LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA` revertida,
   `evaluacion_docentes` despriorizado por modulo deshabilitado).
3. Despues: fase de procedimientos (45 escrituras) en todos los modulos, aparte.
4. No hacer push. Antes: crear rama propia. Produccion: DBA crea objetos antes del tag `v*`.

Ritual vigente (sin cambios): DDL lo crea el usuario en Toad (pegado directo si es corto, `.sql` +
File->Open si pasa ~50-60 lineas, o script node para vistas/funciones grandes con varias ramas
UNION); la validacion la corre Claude por el MCP de lectura Oracle en cuanto el usuario avisa que
el objeto esta creado -- comparacion fila a fila para funciones (no MINUS, no aplica a
SYS_REFCURSOR), MINUS en los 2 sentidos para vistas. Cada objeto validado se registra como `Qn` en
`00_Indice_Resumen.md` antes de pasar al siguiente. Antes de un `pnpm run build` aparte, comprobar

## Tanda 13 (2026-09-16): arranca `becas`, 5 vistas V1 -- revertidas, modulo inactivo en dev

Se armaron y validaron las 5 vistas V1 de `becas` (todas contra `UTNDB.BSE_TAB_SOLICTUDES_BECAS`,
datos reales de convocatoria activa numero 10, cedulas reales `1005XXXXXX` -ESTADO='A', con archivo
bancario- y `1725XXXXXX` -ESTADO='P'-, mas `<cedula>`/ciclo `1021-1099` para la vista de
matricula): `MVL_VIEW_BECAS_ARCHIVO_BANCARIO`, `MVL_VIEW_BECAS_DATOS_BANCARIOS`,
`MVL_VIEW_BECAS_DATOS_CONTRATO`, `MVL_VIEW_BECAS_MATRICULA` (expone `CICLO_ACAD_CODIGO`, que el
SELECT original no traia, solo lo usaba en el WHERE), `MVL_VIEW_BECAS_SOLICITUD_RESUMEN`. Las 5
con `MINUS` en los 2 sentidos, 0 filas -- la de archivo bancario ademas con `DBMS_LOB.COMPARE` para
el `DOCUMENTO` (BLOB, no admite `MINUS` directo), tambien 0 (identico).

Codigo migrado en los 5 `.consulta.ts` (repository.ts no necesito cambios, ninguna es funcion F),
build limpio. **Al levantar el servicio y probar con curl, los 5 endpoints de `becas` devolvieron
403**: `MOVIL_UTN.MVL_TAB_MODULOS_APP` tiene `BECAS`/`PORTAFOLIO_ESTUDIANTE` en
`ESTADO_MODULO='I'` (inactivo) en esta replica de dev -- el `EstadoModuloGuard` corta la petición
antes de llegar al repository, sin relacion con si la vista esta bien o mal.

**Decision del usuario: revertir todo el codigo (sin tocarlo via git, se restauro con `git
checkout --` ya que los 5 archivos no tenian otros cambios sin commitear) y dejar las 5 vistas
pendientes de un `DROP VIEW`** (`%USERPROFILE%\<escritorio>/DROP_becas_tanda1_5_vistas_V1.sql`, sin
correr todavia) para que la BD tambien quede como antes. No es un revertido por bug -- a diferencia
de `LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA` (aula_virtual), aqui la migracion SQL esta confirmada
correcta (MINUS + DBMS_LOB.COMPARE con datos reales); el bloqueo es puramente el modulo apagado, y
sin poder probar end-to-end el usuario prefirio no dejarlo a medio camino.

**Total acumulado: sigue en 39 objetos** (no subio, las 5 vistas quedan para DROP). `becas` sigue
en 0/11 migrado, pendiente real: reactivar el modulo en dev (`UPDATE
MOVIL_UTN.MVL_TAB_MODULOS_APP SET ESTADO_MODULO='A' WHERE NOMBRE_MODULO='BECAS' AND
NOMBRE_APLICACION='PORTAFOLIO_ESTUDIANTE'`, el usuario lo corre si quiere, no es DDL asi que no
esta en el archivo de DROP) antes de retomar, o aceptar de antemano que becas se valida solo a
nivel SQL sin curl end-to-end.

## Que sigue (actualizado, tras Tanda 13 -- vigente, reemplaza al de la Tanda 12)

1. **Antes de retomar `becas`:** decidir con el usuario si se reactiva el modulo en dev para poder
   probar end-to-end, o si esta migracion se acepta solo con validacion SQL (MINUS/comparacion
   fila a fila) sin curl, dado el precedente de otros modulos (ficha_socioeconomica,
   documentos_directorio) donde una parte tambien quedo sin probar end-to-end por un bloqueo ajeno
   a la migracion.
2. Con eso resuelto, retomar becas: 5 V1 (SQL ya escrito y validado una vez, revisar si sigue
   valido o hay que re-crear -- ver DDL completo en esta nota, tanda de arriba) + 3 V2 + 3 F. La
   V2 `OBTENER_ARCHIVO_SOLICITUD_CONSULTA` tiene el hallazgo de bind desalineado sin probar
   todavia (8 placeholders, 5 valores) -- **probar el endpoint real antes de tocar el codigo**,
   pero esto tambien esta bloqueado por el modulo inactivo salvo que se reactive.
3. Con `becas` terminado se cierran TODOS los `SELECT` migrables del repo (quedan afuera para
   siempre: `SILABO_CONSULTA` bloqueada, `LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA` revertida,
   `evaluacion_docentes` despriorizado por modulo deshabilitado).
4. Despues: fase de procedimientos (45 escrituras) en todos los modulos, aparte.
5. No hacer push. Antes: crear rama propia. Produccion: DBA crea objetos antes del tag `v*`.

Ritual vigente (sin cambios): DDL lo crea el usuario en Toad; la validacion la corre Claude por el
MCP de lectura Oracle. Comparacion fila a fila para funciones, MINUS en los 2 sentidos para vistas
(mas `DBMS_LOB.COMPARE` aparte para columnas BLOB/CLOB, que `MINUS` no admite). Antes de aceptar
una migracion como terminada, probar el endpoint real con curl -- si un guard de negocio (modulo
inactivo, permisos) lo bloquea, es una senal para pausar y decidir con el usuario, no para asumir
que la validacion SQL sola alcanza.

## Fase de procedimientos -- arranca (2026-09-16): foro_online, 5 escrituras, piloto de la fase W

Con `becas` en pausa (modulo inactivo en dev, ver Tanda 13) el resto de los SELECT ya estan
cerrados. El usuario decidio arrancar la fase de procedimientos (las ~45 escrituras
INSERT/UPDATE/DELETE en todos los modulos) en vez de retomar becas, empezando por `foro_online`
(el piloto de la migracion, ya migrado 100% en SELECT, 5 escrituras simples de una sola tabla).

estrictamente de solo lectura (solo admite SELECT/WITH), asi que no puede ejecutar un procedimiento
para probarlo antes de tocar el codigo, a diferencia de una vista/funcion donde se podia comparar
con MINUS antes de migrar el `.ts`. Para escrituras, la unica validacion posible es: **migrar el
via oracledb) y confirmar el resultado consultando la tabla afectada con el MCP antes/despues.**

**Hallazgo previo a migrar:** 2 de las 5 sentencias (`CREAR_FORO_ACTIVIDAD_QUERY`,
`MARCAR_ACTIVIDAD_ENTREGADA_QUERY`) tenian el mismo patron de "bind repetido por nombre" ya visto
en la fase de SELECT (`lista-recursos`, `OBTENER_ARCHIVO_SOLICITUD_CONSULTA`): el `.ts` pasaba 6 y 3
valores respectivamente para 5 y 2 nombres de bind unicos. **Decision del usuario: migrar
preservando el comportamiento tal cual**, sin replicar el duplicado -- en PL/SQL cada parametro se
referencia por nombre real, sin la ambiguedad que tenia el arreglo posicional de TypeORM.

Los 5 procedimientos (`MVL_PRC_FORO_*`) creados por el usuario en Toad, codigo migrado en los 5
`.query.ts` (ahora bloques `BEGIN MOVIL_UTN.MVL_PRC_X(...); END;`) + los 2 arreglos de binds del
repository recortados a su tamano real (5 y 2 valores en vez de 6 y 3). Build limpio.

**Validado con exito, curl + estado de tabla antes/despues via MCP:**
- `MVL_PRC_FORO_CREAR_RESPUESTA_GENERAL`: POST `/foro-online/general` (materia CAPRU-MATPRU, cuenta
  <cuenta-de-prueba>) -> 201, `ID_FORO=1127696` creado con todos los campos correctos (`CODIGO` y
  `MATERIA_CODIGO` ambos con el valor de `materiaCodigo`, tal como el `.ts` original).
- `MVL_PRC_FORO_ELIMINAR`: DELETE sobre esa misma fila nueva (1127696, para no tocar los datos
  reutilizables del piloto) -> 204, `ESTADO` paso a `'I'` (confirmado).
- `MVL_PRC_FORO_ACTUALIZAR`: PATCH `/foro-online/respuesta/1127677` (la respuesta hija del piloto)
  -> 204, `DESCRIPCION` actualizada (confirmado).

**No se pudo probar end-to-end:** `MVL_PRC_FORO_CREAR_RESPUESTA_ACTIVIDAD` +
`MVL_PRC_FORO_MARCAR_ACTIVIDAD_ENTREGADA` (las dos se disparan juntas desde
`FECHA_FIN` vigente en dev para la cedula de prueba `<cedula>` (la mas reciente vence
2026-03-06, hoy es 2026-09-16); el guard de negocio del service (`new Date() > actividad.fechaFin`)
tira 409 antes de llegar al repository. **Decision del usuario: aceptar la migracion igual**, por
ser traduccion literal 1:1 del mismo patron ya confirmado en los otros 3 (mismo tipo de INSERT/
UPDATE sobre las mismas 2 tablas). Pendiente real si alguna vez se quiere el end-to-end completo:
conseguir o extender una actividad tipo foro con fecha vigente en dev.

Registrado como Q40-Q44 en `00_Indice_Resumen.md`. `git status` tras esto: los 5 `.query.ts` +
`foro_online.repository.ts`, sin commitear, sobre `practicas-preprofesionales`.

`foro_online` queda con sus 5 SELECT (piloto original) + 5 escrituras migradas. Le quedan sin migrar
(por decision explicita, no por olvido): nada mas -- las 7 sentencias no-W/no-SELECT del modulo ya
estaban catalogadas T/YA/M desde la auditoria original.

## Que sigue (actualizado, tras arrancar fase de procedimientos -- vigente)

1. Seguir la fase de procedimientos modulo por modulo. Sin un inventario consolidado de las ~45
   escrituras todavia (el plan de `Backup-Planes/` se enfoco en SELECT) -- para el resto de modulos,
   armar el listado de escrituras leyendo el repository de cada uno igual que se hizo aqui con
   foro_online, no hay un documento previo que las liste todas juntas.
2. `becas` sigue en pausa (modulo inactivo en dev) -- retomar sus SELECT (5 V1 + 3 V2 + 3 F) cuando
   el usuario decida reactivar el modulo en dev o aceptar validacion solo-SQL.
4. `evaluacion_docentes` sigue despriorizado (modulo deshabilitado).
5. No hacer push. Antes: crear rama propia. Produccion: DBA crea objetos antes del tag `v*`.

Ritual vigente para escrituras: el usuario crea el procedimiento en Toad: Claude migra el codigo
de una vez (no hay forma de probar el procedimiento sin migrar primero, el MCP es solo lectura),
levanta el servicio local, ejercita el endpoint real con curl usando datos de prueba reales, y
confirma el resultado consultando la tabla afectada con el MCP antes/despues -- no existe
equivalente a `MINUS` para escrituras. Si un guard de negocio (fecha, estado, permisos) bloquea el
curl, es señal de pausar y decidir con el usuario si se acepta con evidencia indirecta, se ajustan
datos de prueba, o se deja pendiente -- igual que en la fase de SELECT.

## Correccion (2026-09-16, mismo dia): los 5 procedimientos de foro_online, confirmados end-to-end

La seccion anterior decia que `MVL_PRC_FORO_CREAR_RESPUESTA_ACTIVIDAD` y
`MVL_PRC_FORO_MARCAR_ACTIVIDAD_ENTREGADA` no se pudieron probar por falta de una actividad tipo
foro vigente en dev. **Se resolvio de raiz, no con evidencia indirecta**: el usuario sugirio

Se creo `ID_ACTIVIDAD=627086` ("Foro de prueba - fase de procedimientos", `TIPO_ACTIVIDAD=5`,
`CODIGO_PARCIAL='N1'` activo, `FECHA_FIN=2027-01-01`, materia CAPRU-MATPRU/curso 54443) -- Oracle
genero automaticamente las filas de `LMS_TAB_ACTIVIDADES_ALUMNOS` para los 3 matriculados,
incluida `ID_ACTIVIDAD_ALUMNO=18516468` para la cedula de prueba `<cedula>`. Con esa actividad
confirmo con el MCP: `ID_FORO=1127697` creado con todos los campos correctos, y `ENTREGADO` paso de
`null` a `'SI'` en `ID_ACTIVIDAD_ALUMNO=18516468`.

**Los 5 procedimientos de `foro_online` quedan validados end-to-end con datos reales, sin
excepcion.** No se revirtio la actividad de prueba ni el foro creado -- quedan en dev como el resto
de datos de prueba de esta migracion, reutilizables a futuro.

**Metodo nuevo para la fase de procedimientos, cuando el bloqueo es "no hay dato de prueba
vigente":** si el modulo estudiante depende de un objeto que solo puede crear el modulo docente (o
vigente, en vez de conformarse con evidencia indirecta o tocar datos a mano. Mas fuerte que ambas
alternativas, y sigue sin tocar Oracle por fuera de las apps reales.

**Total fase de procedimientos: 5/5 objetos de foro_online confirmados.** El modulo queda
completo (SELECT + escrituras, todo validado end-to-end).

## Fase de procedimientos, continua (2026-09-16): actividades + comunicados, 3 objetos mas

Con foro_online cerrado (5/5), se siguio con las escrituras sueltas de `actividades` (1: la otra ya
usaba un procedimiento existente, MVL_PRC_GUARDAR_TAREA_ADJ, categoria YA) y `comunicados` (2).

- **`MVL_PRC_ACTIVIDADES_ENTREGAR_REUTILIZAR_ADJUNTO`**: UPDATE simple sobre
  `LMS_TAB_ACTIVIDADES_ALUMNOS`, sin binds duplicados en el original (no habia bug que preservar
  ni evitar). Para probarlo se necesitaba una actividad vigente con un adjunto YA existente --
  `entregarTareaNuevoAdjunto` (el flujo de "adjunto nuevo", que usa el procedimiento preexistente
  `MVL_PRC_GUARDAR_TAREA_ADJ`, no parte de esta migracion) fallo con 500 generico al intentarlo
  primero, asi que en vez de insistir se reutilizo un adjunto real ya existente en dev
  (`idActividad=582166`, ESTADO='I' originalmente) extendiendo su `FECHA_FIN` y reactivandolo
  foro_online, ahora tambien para "resucitar" una actividad vieja con datos reales en vez de crear
  una nueva desde cero. Confirmado: `DESCRIPCION`/`URL` actualizados, `ID_DOCUMENTO_DIRECTORIO`
  preservado.
- **`MVL_PRC_COM_REGISTRAR_VISUALIZACION`**: traduccion literal del bloque PL/SQL de 145 lineas
  (`registrar_visualizacion_consulta.ts`), con su propio `COMMIT`/`ROLLBACK`/`RAISE_APPLICATION_ERROR`
  preservados tal cual -- el `comunicados.service.ts` matchea el mensaje de error por texto
  ("maximo de visualizaciones"), asi que no se podia tocar esa cadena. Probadas las 3 ramas reales:
  UPDATE (comunicado 189), INSERT (comunicado 190), y el error de maximo alcanzado (409 con el
  mensaje exacto, confirmando que el `RAISE_APPLICATION_ERROR` sigue funcionando igual dentro de
  un procedimiento que en un bloque anonimo).
- **`MVL_PRC_COM_GUARDAR_RESPUESTA_ENCUESTA`**: consolida `ELIMINAR_RESPUESTAS_PREGUNTA_CONSULTA` +
  `INSERTAR_RESPUESTA_ENCUESTA_CONSULTA` (2 sentencias que siempre se llamaban juntas) en un solo
  objeto, **sin** `COMMIT`/`ROLLBACK` propio a proposito -- se sigue llamando dentro de una
  transaccion de TypeORM (`dataSource.transaction`) en un loop por cada pregunta respondida.
  Probado con una encuesta real (`idComunicado=188`, 2 preguntas) y vuelto a probar respondiendo
  distinto: reemplaza sin duplicar (mismos `ID_PREGUNTA`/`ID_VISUALIZACION`, `ID_RESPUESTAS` fisico
  nuevo, valores actualizados) -- confirma que el DELETE+INSERT dentro del procedimiento sigue
  funcionando igual que las 2 sentencias sueltas de antes.

**Incidente de sesion, no relacionado a la migracion:** al relanzar el servicio, `EADDRINUSE` en
(mismo patron que el "Incidente de infraestructura" de la Tanda 11 de `aula_virtual`). Se
relanzo `start:dev` limpio antes de seguir probando.

**Total fase de procedimientos: 8/8 objetos confirmados end-to-end, sin excepcion** (5 de
`foro_online` + estos 3). Registrados como Q45-Q47 en `00_Indice_Resumen.md`.

## Que sigue (actualizado, tras cerrar actividades+comunicados -- vigente)

1. Seguir la fase de procedimientos con el resto de modulos. Pendientes conocidos de auditorias
   anteriores (sin garantia de estar completo, armar el inventario leyendo cada repository.ts al
   llegar): `documentos` (los 11 `*_procedure.ts` de certificados, ya via bloques `DECLARE` a
   procedimientos `CSE_PROC_CER_*` existentes -- revisar si son YA o si falta algo),
   `evaluacion_online`, `ficha_estudiante`/`becas` (escrituras de subir documentos), y cualquier
   `INSERT`/`UPDATE`/`DELETE`/`MERGE` que quede en los modulos ya migrados en SELECT.
2. `becas` sigue en pausa para sus SELECT (modulo inactivo en dev) -- separado de la fase de
   procedimientos, que no depende de ese guard para los modulos que no son becas.
4. `evaluacion_docentes` sigue despriorizado (modulo deshabilitado).
5. No hacer push. Antes: crear rama propia. Produccion: DBA crea objetos antes del tag `v*`.

Ritual vigente para escrituras: el usuario crea el procedimiento en Toad; Claude migra el codigo de
una vez (el MCP es solo lectura, no puede probar el procedimiento antes), levanta el servicio local
y ejercita el endpoint real con curl usando datos de prueba reales, confirmando el resultado con el
MCP antes/despues. Si falta un dato de prueba vigente (fecha, adjunto existente), **antes de
conformarse con evidencia indirecta**: considerar levantar el otro microservicio relacionado
(docente) para generarlo con su propio flujo real, o "resucitar" un registro viejo real
extendiendole la fecha/reactivandolo via el endpoint de actualizar correspondiente -- mas fuerte
que tocar Oracle a mano y más rápido que crear todo desde cero. Antes de relanzar `start:dev`,

## Cierre de sesion (2026-09-16) -- para abrir un chat nuevo

Contexto de este chat al 44%, se corta por decision del usuario (no por limite). Todo lo que sigue
es para que un chat nuevo retome sin repreguntar.

### Estado global

- **Fase de SELECT: 39 objetos (Q1-Q39), 15 modulos con sus SELECT 100% migrados** (ver "Cierre de
  sesion (2026-09-23, tarde)" mas arriba en este archivo para el detalle historico completo de esa
  fase -- sigue vigente, no cambio en esta sesion).
- **`becas` sigue en pausa** para sus SELECT (5 V1 + 3 V2 + 3 F): el modulo esta
  `ESTADO_MODULO='I'` en `MOVIL_UTN.MVL_TAB_MODULOS_APP` en esta replica de dev, bloquea el curl
  end-to-end con 403 antes de llegar al repository. Las 5 vistas V1 que se habian creado y
  validado se revirtieron (codigo con `git checkout --`, vistas pendientes de `DROP VIEW` en
  `%USERPROFILE%\<escritorio>/DROP_becas_tanda1_5_vistas_V1.sql`, sin correr todavia). Retomar cuando
  el usuario decida reactivar el modulo o aceptar validacion solo-SQL.
- **Fase de procedimientos (escrituras): arranco en esta sesion, 8/8 objetos confirmados
  end-to-end** (Q40-Q47): los 5 de `foro_online` (piloto) + `MVL_PRC_ACTIVIDADES_ENTREGAR_REUTILIZAR_ADJUNTO`
  (actividades) + `MVL_PRC_COM_REGISTRAR_VISUALIZACION` + `MVL_PRC_COM_GUARDAR_RESPUESTA_ENCUESTA`
  (comunicados). Sin inventario previo consolidado de las ~45 escrituras del repo (el plan de
  `Backup-Planes/` solo cubrio SELECT) -- se arma modulo por modulo leyendo el `repository.ts` al
  llegar a cada uno.

### En curso ahora mismo, sin terminar

Nada a medias -- los 3 objetos de esta sesion (actividades + comunicados) quedaron cerrados y
confirmados antes de cortar. **Candidato siguiente, sin empezar todavia:** `documentos`, que tiene
11 ficheros `*_procedure.ts` (`certificado_adeudar_biblioteca_procedure.ts`,
`certificado_almacen_bodega_procedure.ts`, etc. en `src/modules/documentos/repository/consultas/`)
que ya llaman a bloques `DECLARE ... UTNDB.CSE_PROC_CER_*` -- **sin verificar todavia si cuentan
como "YA" (ya usan procedimiento) o si falta algo** (el hallazgo de `Backup-Planes/` S5.3 solo dice
"cada uno tiene un SELECT de validacion interno, no se cuenta aparte" y que "todos tienen `WHEN
OTHERS` que traga el error real" -- eso es un hallazgo aparte, no arreglar sin pedirlo). Revisarlos
uno por uno antes de asumir que no hace falta tocarlos. Alternativa si se prefiere otro orden:
`evaluacion_online` (sin explorar todavia sus escrituras en esta fase).

### Metodo de la fase de procedimientos (nuevo respecto a SELECT, ver detalle en las secciones de
### arriba "Fase de procedimientos -- arranca" y "continua")

1. Claude lee el `repository.ts` del modulo para encontrar las escrituras (`INSERT`/`UPDATE`/
   `DELETE`/`MERGE`, o bloques `DECLARE`/`BEGIN` que ya llaman procedimientos existentes -- esos
   ultimos son YA, no se tocan).
2. Claude prepara el/los procedimiento(s) `MVL_PRC_<MODULO>_<ACCION>`, preservando el
   comportamiento EXACTO del `.ts` original -- incluido cualquier `COMMIT`/`ROLLBACK` propio (si
   el original no tenia porque corre dentro de una transaccion de TypeORM en el `.ts`, el
   procedimiento tampoco debe tenerlo) y cualquier `RAISE_APPLICATION_ERROR` con su texto exacto
   (el service.ts puede matchear el mensaje por substring). Si el `.ts` original pasaba mas
   valores en el arreglo de binds que nombres unicos tiene el SQL (el patron de "bind repetido"
   de la fase de SELECT, S6.2), **no se replica el duplicado**: en PL/SQL cada parametro va por
   nombre real, sin la ambiguedad del arreglo posicional de TypeORM -- decision ya tomada con el
   usuario, aplica a toda la fase de escrituras.
3. El usuario corre el DDL en Toad (mismo mecanismo que las vistas: pegado directo si es corto,
   `.sql` en el escritorio + File->Open si es largo).
4. **A diferencia de las vistas, el MCP no puede validar un procedimiento antes de tocar el
   que Claude migra el `.ts` de una vez tras confirmar que el objeto quedo `VALID` (`SELECT
   OBJECT_NAME, STATUS FROM ALL_OBJECTS WHERE OWNER='MOVIL_UTN' AND OBJECT_NAME='...'`), hace
   build, levanta el servicio local, y ejercita el endpoint real con curl usando datos de prueba
   reales -- confirmando el resultado consultando la tabla afectada con el MCP antes/despues. No
   hay equivalente a `MINUS` para escrituras.
5. **Si no hay un dato de prueba vigente** (fecha vencida, adjunto inexistente, etc.), antes de
   conformarse con evidencia indirecta: considerar levantar tambien el otro microservicio
   registro viejo real extendiendole la fecha / reactivandolo via el endpoint de actualizar
   correspondiente. Mas fuerte que tocar Oracle a mano, mas rapido que inventar todo desde cero.
   Se hizo 2 veces en esta sesion (actividad 627086 nueva para foro_online, actividad 582166
   resucitada para actividades) y funciono bien las 2 veces.
6. Registrar el objeto como `Qn` en `00_Indice_Resumen.md` y actualizar esta nota.

### Datos de prueba nuevos que quedan en dev (por si se necesitan de nuevo)

- **`ID_ACTIVIDAD=627086`** ("Foro de prueba - fase de procedimientos", tipo foro, `FECHA_FIN`
  2027-01-01, materia CAPRU-MATPRU/curso 54443, `CODIGO_PARCIAL='N1'`) -- creada para probar
  `foro_online`. `ID_FORO=1127697` (respuesta de actividad de prueba) colgado de ahi.
- **`ID_ACTIVIDAD=627087`** ("Tarea de prueba - fase de procedimientos", tipo tarea con adjunto,
  `FECHA_FIN` 2027-01-01, 3 intentos) -- `ID_ACTIVIDAD_ALUMNO=18516488` para la cedula
  `<cedula>`, sin adjunto (el flujo de "adjunto nuevo" esta roto, ver hallazgo abajo).
- **`ID_ACTIVIDAD=582166`** ("ADJUNTO INTENTOS", preexistente) -- se le extendio `FECHA_FIN` a
  2027-01-01 y se reactivo `ESTADO='A'` (antes 'I') para poder probar "reutilizar adjunto" con su
  `ID_DOCUMENTO_DIRECTORIO=7973664` real. `ID_ACTIVIDAD_ALUMNO=17257090`, `INTENTOS_DISPONIBLES`
  bajo de 4 a 3 tras la prueba.
- **`ID_COMUNICADO=189`** (IMPORTANTE, `MAX_VISUALIZACIONES=25`): `NUM_VISUALIZACION` de la cedula
  `<cedula>` subio de 4 a 5 durante la prueba.
- **`ID_COMUNICADO=190`** (INFORMATIVO, `MAX_VISUALIZACIONES=1`): la cedula `<cedula>` ya
  alcanzo el maximo (1/1) -- util para reproducir el error 409 de nuevo sin preparar nada.
- **`ID_COMUNICADO=188`** (ENCUESTA, preguntas `ID_PREGUNTA=103` RATING y `104` LIKERT): la cedula
  `<cedula>` tiene una respuesta real guardada (`3` y `NEUTRAL`, `ID_VISUALIZACION=382`).

### Hallazgo pendiente, no arreglar sin pedirlo (fuera del alcance de esta migracion)

**El flujo de "entregar tarea con adjunto nuevo" esta roto en dev**: `POST
/actividades/entregar` con `reutilizarAdjunto=false` y un archivo real devuelve 500 generico
("No se pudo entregar la actividad", mensaje que traga el error real -- `actividades.service.ts`
tiene el `catch` con el `console.log` comentado). Confirmado que NO es el `EADDRINUSE`/proceso
huerfano (se verifico con el servicio recien relanzado limpio). Es el procedimiento preexistente
`MVL_PRC_GUARDAR_TAREA_ADJ` (no tocado en esta migracion, categoria YA) el que esta fallando --
posible mismo patron que el hallazgo ya documentado en
[[2026-09-23 - Directory object invalido bloquea guardar recursos en aula virtual (docente)]]
(objeto `DIRECTORY` de Oracle invalido/sin grant), pero **sin confirmar** -- nadie investigo la
causa raiz todavia. No bloquea la migracion (se reciclo datos ya existentes), pero es un bug real
de la app que alguien deberia mirar aparte.

### Servicios locales que quedan corriendo entre sesiones

veces en esta migracion que un proceso viejo se queda huerfano sirviendo codigo desactualizado
tras un cambio, y hay que matarlo (`taskkill //PID <pid> //F`) antes de relanzar limpio.

Ritual vigente (sin cambios respecto a lo de arriba): DDL en Toad por el usuario; validacion por
Claude (MINUS para vistas via MCP, curl+MCP antes/despues para escrituras ya que el MCP no puede
ejecutar DML). No hacer push, no crear rama todavia (pendiente). No commitear nada de esto --
sigue todo sin commitear sobre `practicas-preprofesionales` en ambos repos (estudiante: ~60
archivos modificados de toda la migracion acumulada; docente: 1 archivo, cambio preexistente del
usuario, no tocado en esta sesion).

## `documentos` (fase de procedimientos) -- confirmado 100% YA (2026-09-16)

Los 12 ficheros `*_procedure.ts` de `src/modules/documentos/repository/consultas/` (los 11 del
patron `CSE_EMISION_CERTIFICADO` + `CSE_PROC_CER_*`/`CSE_PRO_GENERADOR_REPORTS`/
`CSE_PRO_GENERAR_CERTIFICADO_REPORTS`, mas `certificado_notas_beca_procedure.ts` que llama a
`PRO_CERTIFICADO_NOTAS_BECA`) son todos **YA**: bloques `DECLARE/BEGIN` que ya delegan a un
procedimiento `UTNDB.*` existente, sin logica de escritura propia -- no hace falta crear ningun
`MVL_PRC_*` nuevo. Los 12 estan importados y usados de verdad en `documentos.repository.ts`
(ninguno es codigo muerto).

**Hallazgo de paso, sin arreglar (no se pidio):** verificado con el MCP de lectura Oracle
(`ALL_OBJECTS`, `ALL_PROCEDURES`) contra la replica de dev:
- Casi todos los objetos `UTNDB.CSE_*` que llaman estos procedures (`CSE_EMISION_CERTIFICADO`,
  `CSE_PROC_CER_BIBLIOTECA`, `CSE_PROC_CER_ALM_BODEGA`, `CSE_PROC_CER_ASIS_CLASES`,
  `CSE_PROC_CER_GRUPOS_CULTURALES`, `CSE_PROC_CER_MATRICULA`, `CSE_PROC_CER_SANCION`,
  `CSE_PROC_CER_TER_MATRICULA`, `CSE_PRO_GENERADOR_REPORTS`) figuran `STATUS='INVALID'` en
  `ALL_OBJECTS` -- solo `CSE_FUN_APROBACION_CF` esta `VALID`. INVALID no implica necesariamente
  roto (Oracle intenta recompilar solo en cada invocacion), y el MCP es solo-lectura, no puede
  ejecutar el bloque para confirmar en vivo.
- **`UTNDB.CSE_PRO_GENERAR_CERTIFICADO_REPORTS`** (usado por
  `certificado_historial_academico_becas_procedure.ts`) **no existe en esta replica** -- 0 filas en
  `ALL_OBJECTS` y en `ALL_PROCEDURES` (ni como standalone ni como miembro de paquete). Invocar ese
  endpoint en dev fallaria con `PLS-00201` (identificador debe declararse).
- **`UTNDB.PRO_CERTIFICADO_NOTAS_BECA`** (usado por `certificado_notas_beca_procedure.ts`) existe
  pero esta `INVALID`, y el bloque que lo envuelve hace `SELECT ... FROM BSE_TAB_CICLOS_ANTERIORES`
  / `BSE_TAB_CONVOCATORIAS_BECAS` -- tablas de becas.
- Los dos ficheros afectados (`historial_academico_becas`, `notas_beca`) son certificados
  **ligados a becas**, aunque cuelgan del modulo `documentos` (no de `becas`, asi que no estan
  detras del `EstadoModuloGuard` que ya bloquea `becas` con 403). Encaja con que `becas` esta
  `ESTADO_MODULO='I'` en dev -- probable que estos dos nunca se hayan podido probar end-to-end ahi.
  No se toco nada, es solo verificacion.

**`documentos` queda confirmado 100% "YA" en la fase de procedimientos.** Siguiente candidato
acordado con el usuario si esto salia YA: **`evaluacion_online`** (sin explorar todavia sus
escrituras en esta fase).

## `evaluacion_online` (fase de procedimientos) -- arranca 2026-09-16

9 escrituras en `evaluacion_online.queries.ts`, de las cuales 1 ya era YA
(`FINALIZAR_EVALUACION` llama a `UTNDB.LMS_PRC_CALIFICAR_EVALUACION`). Las otras 8 son crudas
(`UPDATE`/`INSERT` directos). El worker de BullMQ (`evaluacion-auto-calificar.processor.ts`) no
tiene SQL propio, solo llama al repository -- no suma objetos nuevos.

Agrupacion acordada en 5 procedimientos (detalle Q48-Q49 en `00_Indice_Resumen.md`):
1. ✅ `MVL_PRC_EVAL_INICIAR_CRONOMETRO` -- confirmado end-to-end.
2. ✅ `MVL_PRC_EVAL_REANUDAR_INTENTO` -- confirmado end-to-end.
3. 🎯 `MVL_PRC_EVAL_GUARDAR_RESPUESTA` (`DESACTIVAR_RESPUESTAS_PREGUNTA` + `INSERTAR_NUEVA_RESPUESTA`,
   sirve a `guardarRespuestaUnica` y `guardarRespuestaAbierta`) -- siguiente.
4. 🎯 `MVL_PRC_EVAL_GUARDAR_RESPUESTA_EMPAREJAR` (`DESACTIVAR_RESPUESTA_EMPAREJAR` +
   `INSERTAR_RESPUESTA_EMPAREJAR`).
5. 🎯 `MVL_PRC_EVAL_TOGGLE_RESPUESTA_MULTIPLE` (`ELIMINAR_RESPUESTA_MULTIPLE` +
   `INSERTAR_RESPUESTA_MULTIPLE`, necesita parametro `p_marcado` para replicar el if/else).

(`app.module.ts:41,129,155`) -- sin `REDIS_HOST`, Nest ni siquiera registra las rutas de
`evaluacion-online` y cualquier request cae al fallback SPA de `ServeStaticModule`, que intenta
servir `public/index.html` (no existe, backend solo-API) y da 500 generico igual en cualquier
ruta del modulo, sin relacion con la migracion. Se identifico via los logs reales del servicio
(el usuario los pego en el chat) -- sin eso hubiera sido dificil de diagnosticar a ciegas. Se
2 PIDs porque el primer intento dejo un hijo vivo) y confirmo boot limpio por los logs antes de
probar.

**Ajuste de metodo, 2026-09-16:** usar siempre las cuentas de prueba estandar `<cuenta-de-prueba>` /
`<cuenta-de-prueba>` para cualquier curl, nunca otras cedulas reales de la replica aunque ya tengan el
estado de datos que hace falta -- pedido explicito del usuario despues de que Claude usara
escenario necesario (p. ej. `ENTREGADO='SI'` con intentos>0, o una ventana de fechas vigente) no
existe para las cuentas estandar, la salida es extender/crear datos de prueba PARA esas mismas
cuentas -- en este caso, extender `FECHA_FIN` de una actividad real ya existente
(`ID_ACTIVIDAD=627069`, "Evaluacion Online Test 08:16:55", curso CAPRU-MATPRU) via

**Hallazgo de paso:** esa actividad (627069) ya tenia en dev un estado raro heredado --
`ENTREGADO='SI'` con `FECHA_INICIO_EA=null` (entregada sin haber iniciado cronometro nunca, para
la cuenta <cedula>). Sirvio perfecto para probar los 2 procedimientos a la vez en una sola
llamada (`reanudarIntento` + `iniciarCronometro` no son mutuamente excluyentes en el `.ts`: ambos
`if` se evaluan en la misma ejecucion de `getFormulario`). No se investigo el origen de ese
estado raro, no bloquea nada.

`--restart`, cosa que no se hizo).

### `evaluacion_online` cierra (2026-09-16)

Los 5 procedimientos quedaron creados, validados y confirmados end-to-end (detalle Q48-Q52 en
`--restart=always`).

`documentos` (confirmado YA completo) + `evaluacion_online` (5/5 procedimientos) cierran esta
sesion. Candidato siguiente para la fase de procedimientos: revisar el resto de modulos por
escrituras pendientes (no se ha barrido `notas_estudiante`, `aula_virtual`, `becas` -- este
ultimo en pausa por el modulo inactivo en dev -- ni el resto de modulos chicos ya cerrados en la
fase SELECT).

**Total fase de procedimientos al cierre: 13 objetos confirmados end-to-end**, en 4 modulos
100% migrados (foro_online, actividades, comunicados, evaluacion_online) + documentos confirmado
YA sin objetos nuevos.

## Auditoria de escrituras en `notas_estudiante` y `aula_virtual` -- ambos confirmados 0 escrituras (2026-09-16)

Siguiente paso pendiente de la sesion anterior: revisar si a estos 2 modulos les falta algo en la
fase de procedimientos. Verificado leyendo `repository.ts` y `service.ts` de los dos (no solo la
carpeta `consultas/`), con grep de `INSERT|UPDATE|DELETE|MERGE|DECLARE|BEGIN` (con limite de
palabra, para no contar falsos positivos como la columna `ADJUNTO_LAST_UPDATE`):

- **`notas_estudiante`**: 0 coincidencias. Los 4 metodos del repository (`getNotasCicloActual`,
  `getNotasPorNivel`, `getNotasPorCiclo`, `getArbolDeMaterias`, `getCarrerasEstudiante` -- 5 en
  total) son todos `SELECT`. Modulo de solo lectura completo.
- **`aula_virtual`**: 0 coincidencias. Los 11 metodos del repository (`parcialActiva`,
  `getListaActividades`, `getListaRecursos`, `getInasistencia`, `getAsistencias`,
  `getAvanceMateria`, `getDistribucionMateria`, `getListaContenidosMateria`,
  `getDocumentoSilabo`) son todos `SELECT` -- incluido `parcialActiva`, que llama a
  `UTNDB.LMS_FUN_PARCIAL_ACTIVA` pero vía `SELECT ... FROM DUAL` (funcion de lectura, no escritura).

**Conclusion: no hay nada que migrar en la fase de procedimientos para estos 2 modulos** -- no hace
falta crear ningun `MVL_PRC_*` nuevo. Coincide con que ambos son 100% consultas academicas
(notas, horario de clases, avance, asistencia, contenidos) sin ningun flujo propio de escritura --
las unicas escrituras del alumno en esos dominios (entregar tarea, comentar en foro) viven en
`actividades`/`foro_online`, ya migrados.

Con esto, de los modulos con `SELECT` 100% migrado, faltan por auditar en la fase de
procedimientos: `ficha_estudiante`, `documentos_directorio`, `modales_informativos`, `pagos`,
`validacion_acceso`, `calendario_actividades`, `horario_estudiante`, `registro_academico`,
`ficha_socioeconomica` (los grandes que faltan del todo, `aula_virtual` resto y `becas`, siguen
fuera por lo ya documentado arriba).

**Total fase de procedimientos sigue en 13 objetos confirmados end-to-end**, ahora con 6 modulos
resueltos (foro_online, actividades, comunicados, evaluacion_online -- objetos nuevos;
documentos, notas_estudiante, aula_virtual -- confirmados sin objetos nuevos).

## `modales_informativos` (fase de procedimientos) -- cierra (2026-09-16)

Unica escritura real de la ronda auditada (`ficha_estudiante`, `documentos_directorio`, `pagos`,
`validacion_acceso`, `calendario_actividades`, `horario_estudiante`, `registro_academico`,
`ficha_socioeconomica` dieron 0 escrituras, ver seccion de arriba). `marcarModalComoVisto` hacia
un SELECT de existencia + INSERT en 2 llamadas separadas (TOCTOU en el original, no se empeoro:
el procedimiento nuevo lo hace atomico de paso). Migrado a `MVL_PRC_MODAL_MARCAR_VISTO`
(detalle DDL completo y prueba en `00_Indice_Resumen.md` Q53) -- OUT NUMBER en vez de
RAISE_APPLICATION_ERROR porque el `.ts` ya devolvia boolean, no matcheaba texto de error. Build
409 en encuesta ya respondida (COMEDOR_UTN_2023ENERO), 204+INSERT confirmado por MCP en encuesta
sin responder (PORTAFOLIO_ESTUDIANTES_202407_TEST, ENCUESTA_USUARIO_ID=151669), 409 de nuevo al
repetir la misma.

**Total fase de procedimientos: 14 objetos confirmados end-to-end**, en 5 modulos 100% migrados
(foro_online, actividades, comunicados, evaluacion_online, modales_informativos) + documentos,
notas_estudiante y aula_virtual confirmados sin objetos nuevos (ya eran YA o de solo lectura).

**Modulos que quedan por auditar en la fase de procedimientos:** `aula_virtual` (resto, el que
no se audito todavia porque su fase SELECT quedo en 7/9 -- ojo, `SILABO_CONSULTA` sigue bloqueado
por el hallazgo de seguridad, no auditar escrituras ahi sin resolver eso primero) y `becas` (en
pausa, modulo inactivo en dev). El resto de los 15 modulos con SELECT 100% migrado ya quedaron
auditados sin objetos nuevos salvo foro_online/actividades/comunicados/evaluacion_online/
modales_informativos.

## `aula_virtual` (fase de procedimientos) -- confirmado 0 escrituras (2026-09-16)

Verificado el controlador completo (`aula_virtual.controller.ts`): **10 rutas, todas `@Get()`**,
ningun `@Post`/`@Put`/`@Delete`. Coincide con lo ya confirmado en `repository.ts`/`service.ts` en
la auditoria anterior de esta misma sesion (11 metodos, todos lectura). No hay nada que migrar en
este modulo para la fase de procedimientos -- el bloqueo de `SILABO_CONSULTA` (hallazgo de

**Con esto, todos los modulos con `SELECT` 100% migrado quedan auditados en la fase de
procedimientos.** Unico modulo real con objetos nuevos en esta fase, ademas del piloto: `foro_online`
(5), `actividades` (1), `comunicados` (2), `evaluacion_online` (5), `modales_informativos` (1) --
**14 objetos en total**, confirmados end-to-end.

**Lo que queda de la migracion completa:**
1. `becas` -- en pausa, modulo `ESTADO_MODULO='I'` en dev (ni SELECT ni escrituras se pueden
   confirmar end-to-end ahi mientras siga asi).
2. `aula_virtual` -- resto de la fase SELECT: 2 objetos pendientes (`SILABO_CONSULTA` bloqueado
   por el hallazgo de seguridad; el otro sin recordar cual es exactamente, revisar
   `Backup-Planes/` o la seccion "Tanda 12" de esta nota).
3. Nada mas pendiente de escrituras en el resto de modulos -- todos auditados.

Rama sigue sin crear, nada commiteado, sobre `practicas-preprofesionales`.
