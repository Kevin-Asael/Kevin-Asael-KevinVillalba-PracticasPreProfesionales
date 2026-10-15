# Cómo trabajamos la migración de queries en Portafolio Docente (Continuidad) — 2026-09-17

Esta nota es de **continuidad maestra**: si el chat se reinicia, se cambia de modelo o se agota el contexto, permite retomar el trabajo en `utn-movil-portafolio-docentes` de forma inmediata, manteniendo la misma disciplina y metodología probada con éxito en `utn-movil-portafolio-estudiante`.

- **Estado de acceso:** **Solo Lectura** en código fuente (hasta iniciar formalmente la migración por módulos acordada con el usuario).
- **Esquema de base de datos destino:** `MOVIL_UTN` en réplica de desarrollo Oracle.
- **Índice de objetos:** [[00_Indice_Docentes]] (inicia con prefijo `D1, D2, D3...`).

> [!NOTE]
> **Notas complementarias esenciales:**
> 1. [[2026-09-16 - Plan completo migracion queries a vistas y procedimientos (portafolio-docentes)|Plan Maestro Docentes]]: Inventario exhaustivo de las 242 consultas/bloques SQL clasificados por módulo.
> 2. (nota interna, no publicada): Detalle de los 7 puntos vulnerables congelados por seguridad.
> 3. [[2026-09-17 - Correcciones a la auditoria inicial de docentes]]: Ajustes de módulos (21 módulos), conteos reales y diferencias con estudiantes.
> 4. [[2026-09-14 - Como trabajamos la migracion de queries a vistas (continuidad)|Continuidad Estudiantes]]: Registro de lecciones aprendidas y patrones en el repo de estudiantes (Q1 a Q53).

---

## 1. El encargo y objetivos técnicos

En `utn-movil-portafolio-docentes` existen sentencias SQL embebidas (*hardcoded*) en repositorios TypeScript. El objetivo es encapsular esta lógica relacional en la base de datos Oracle (`MOVIL_UTN`), protegiendo al backend de modificaciones en tablas o estructuras institucionales subyacentes (`UTNDB`).

### Reglas de Clasificación y Alcance (Filtro Estricto)

Solo se migran las categorías que aportan valor arquitectónico y desacoplamiento:

| Categoría | Objeto Oracle | Comportamiento |
|---|---|---|
| **V1 — Vista directa** | `MOVIL_UTN.MVL_VIEW_*` | Los binds solo filtran columnas en el `WHERE` externo desde TypeScript. |
| **V2 — Vista reescrita** | `MOVIL_UTN.MVL_VIEW_*` | Requiere reescritura de SQL (eliminar subqueries escalares, joins con tablas de usuarios, proyecciones uniformes). |
| **F — Función cursor** | `MOVIL_UTN.MVL_FUN_*` | Binds dentro de proyecciones `CASE`, subconsultas correlacionadas, agregados o paginación. Devuelve `SYS_REFCURSOR`. |
| **P / W — Procedimiento** | `MOVIL_UTN.MVL_PRC_*` | Operaciones de escritura (`INSERT`, `UPDATE`, `DELETE`, `MERGE` o bloques PL/SQL). |

**Quedan estrictamente EXCLUIDOS de la migración (No se crean objetos):**
- **T (Trivial):** `SELECT 1 FROM DUAL`, conteos o lecturas de 1 sola columna por Primary Key sin `JOIN`.
- **YA (Ya resuelto):** El código ya invoca vistas `MVL_VIEW_*` existentes, vistas institucionales `LMS_VIEW_*`, o paquetes PL/SQL.
- **M (Código muerto):** Consultas en módulos descartados (ej. `foro-online-old`) o constantes sin llamadores.

---

## 2. Ritual de Trabajo Paso a Paso (Toad + Chat) — ACTUALIZADO 2026-09-17

permite que Claude corra la validación `MINUS` él mismo en cuanto el usuario crea la vista — no hace
falta que el usuario ejecute el `MINUS` y pegue el resultado. Y como esta sesión de Claude corre en
la misma máquina (shell propio), también levanta el backend local (`pnpm run start:dev`) y corre los
`curl` antes/después él mismo, comparando el JSON directamente. El usuario solo ejecuta el DDL
(`CREATE OR REPLACE VIEW`/función/procedimiento) en Toad — eso sigue siendo intransferible.

La creación de objetos DDL se realiza bajo control humano estricto en Toad. Ningún script automatizado corre DDL directamente contra Oracle.

```
+------------------+         +---------------------+         +---------------------+
|   Claude / IA    |         |       Usuario       |         |    Oracle (Dev)     |
+------------------+         +---------------------+         +---------------------+
         |                              |                               |
         |  1. Entrega DDL + Validación |                               |
         |----------------------------->|                               |
         |                              |  2. Guarda .sql en Escritorio |
         |                              |     Abre en Toad (File->Open) |
         |                              |  3. Ejecuta DDL               |
         |                              |------------------------------>|
         |                              |  4. Ejecuta MINUS / Cursor    |
         |                              |------------------------------>|
         |                              |  5. Envía resultado al chat   |
         |  6. Confirma o corrige       |<------------------------------|
         |<-----------------------------|                               |
         |                              |                               |
 (Repite para todos los objetos)        |                               |
         |                              |                               |
         |  7. Aplica cambios en .ts    |                               |
         |     pnpm build + curl dev    |                               |
         |----------------------------->|                               |
```

### Protocolo de ejecución:
1. **Claude prepara UN objeto a la vez** (o una tanda de V1 simples perfectamente acotadas), suministrando el DDL completo y el script de validación.
2. **Workflow Seguro en Toad (Prevención de corrupción sintáctica):**
   > [!IMPORTANT]
   > **Regla de oro de Toad:** No pegar scripts largos directamente en el Editor de Toad. La función de autocompletado y Code Insight corrompe textos extensos e introduce errores sintácticos inexistentes (como el falso `ORA-00907: missing right parenthesis`).
   > **Procedimiento:** Guardar el script como archivo `.sql` en el Escritorio (`%USERPROFILE%\<escritorio>/...`) y abrirlo en Toad mediante el menú **File -> Open**.
3. **Ejecución en Toad:** El usuario ejecuta el DDL conectado con el usuario `MOVIL_UTN` en la instancia réplica de desarrollo.
4. **Reporte de resultados:** El usuario pega en el chat el mensaje de compilación y el resultado de la validación (grid, captura o texto).
5. **Validación:**
   - **Vistas:** Se valida con `MINUS` bidireccional entre la query original y la vista:
     ```sql
     -- Sentido 1: Original MINUS Vista
     (SELECT ... FROM tablas_originales WHERE condicion = :bind)
     MINUS
     (SELECT ... FROM MOVIL_UTN.MVL_VIEW_* WHERE condicion = :bind);

     -- Sentido 2: Vista MINUS Original
     (SELECT ... FROM MOVIL_UTN.MVL_VIEW_* WHERE condicion = :bind)
     MINUS
     (SELECT ... FROM tablas_originales WHERE condicion = :bind);
     ```
     Ambas consultas deben devolver exactamente **0 filas**.
   - **Manejo de CLOBs:** Si el conjunto incluye columnas de tipo `CLOB`, Oracle lanzará `ORA-22848`. Se debe envolver la columna con `DBMS_LOB.SUBSTR(columna, 4000, 1)` exclusivamente en el script de validación.
   - **Funciones:** Se validan mediante bloque anónimo con `DBMS_SQL.RETURN_RESULT(cursor)` comparando conteo, tipos y valores fila a fila con la query original.
6. **Modificación de código TypeScript:** Únicamente tras haber completado y validado en Oracle **toda la tanda de objetos del módulo**, se procede a actualizar los archivos `.ts`.
7. **Verificación final:**
   - Compilación limpia con `pnpm run build`.
   - Ejecución local (`pnpm run start:dev`) y contraste de respuesta JSON mediante `curl` antes y después de la modificación.

---

## 3. Cuentas de Prueba y Entorno de Desarrollo

- **Cuenta Docente Principal:** `<cuenta-de-prueba>` (cédula `<cedula>`).
- **Cuenta Estudiante Relacionada:** `<cuenta-de-prueba>` (cédula `<cedula>`, útil para verificar asistencia, calificaciones y foros donde interactúan ambos roles).
  ```bash
  ```

---

## 4. Consumo de `SYS_REFCURSOR` en TypeORM / `oracledb`

Cuando una función PL/SQL retorna un cursor referenciado, el backend lo consume mediante `dataSource.query()`:

```sql
SELECT MOVIL_UTN.MVL_FUN_NOMBRE_FUNCION(:1, :2) AS FILAS FROM DUAL
```

Debido a que `oracledb` mapea `DB_TYPE_CURSOR` como un cursor anidado completo, la respuesta llega estructurada como:
```ts
const resultados: { FILAS: any[] }[] = await this.dataSource.query(QUERY, [...binds]);
return plainToInstance(DtoClass, resultados[0]?.FILAS ?? []);
```

---

## 5. Reglas de Git y Seguridad del Repositorio

- 🚫 **PROHIBICIÓN TOTAL SOBRE `main`:** Queda terminantemente prohibido hacer cambios, commits o pushes directos en la rama `main`. Solo se puede consultar en modo lectura.
- ✅ **RAMAS DE TRABAJO PERMITIDAS:** Todo cambio debe realizarse exclusivamente sobre **`practicas-preprofesionales`**, o en ramas de soporte derivadas de ella.
- El repositorio se mantiene en **Modo Solo Lectura** por defecto para el agente.
- No crear archivos `.sql` sueltos dentro del árbol del repositorio backend para no ensuciar el control de versiones. Todo el DDL se registra en Obsidian y en el chat.

---

## 6. Puntos Críticos y Casos Especiales en Docentes

> [!CAUTION]

### B. Particularidad de `foro_online`
En estudiante, la vista `MVL_VIEW_FORO_INSTRUC_ACT` filtraba por `ID_ACTIVIDAD_ALUMNO` y `CEDULA`. En docentes, `get_instrucciones_actividad.query.ts` filtra directamente por `ID_ACTIVIDAD`. **No reutilizar ciegamente el objeto de estudiante sin verificar la estructura y parámetros requeridos por el rol docente.**

### C. `horario-docente` — la nota del plan maestro está desactualizada
El plan maestro (`Backup-Planes/2026-09-16...`) describe `CICLO_ACADEMICO_QUERY` de `horario-docente`
con `ROW_NUMBER()` y lo clasifica V2. El archivo real (`ciclo-academico.query.ts`) no tiene
`ROW_NUMBER()` — es un filtro directo `DOCENTE_CEDULA = :bind`, igual que `horario.query.ts`
(`UNION` con binds simples en el `WHERE`). **Las dos son V1, no V2.** Re-auditar contra el código
antes de generar DDL para este módulo — no confiar en la clasificación del plan sin releer el archivo.

## 7. Registro de avance por módulo

### `distributivo-docente` — completo (2026-09-17)
3 objetos (D1, D2, D3 — ver [[00_Indice_Docentes]]), los 3 V2 con el mismo patrón: subconsulta o
función `cuenta→cédula` en el `WHERE` reescrita a `JOIN` con `INS_TAB_USUARIOS`. Validados con MINUS
bidireccional por MCP (0 filas los 6). Hallazgo importante: `DISTRIBUTIVO_PERSONAL_QUERY` (D3) no
lleva `DISTINCT` en el original — se preservó así en la vista a propósito, porque hay filas duplicadas
reales (cédula `0923XXXXXX`, ciclo `1117-0418`, horas 1 y 2) que el backend suma con `.reduce()`; un
`DISTINCT` de más las habría colapsado sin error visible. Validado también con `COUNT(*)` (2=2) además
del MINUS. Código migrado en los 3 `.query.ts`, build limpio, curl antes/después idéntico en los 3
endpoints (`/distributivo/ciclos`, `/distributivo?ciclo=...` con 2 cuentas de prueba distintas).
Sin commitear.

### `horario-docente` — completo (2026-09-17)
2 objetos (D4, D5 — ver [[00_Indice_Docentes]]). Re-auditados primero contra el código real: el plan
maestro clasificaba las 2 consultas como V2 (mencionaba `ROW_NUMBER()`, que no existe en el archivo
actual) — en realidad son **V1**, filtro directo por `DOCENTE_CEDULA` sin subconsulta ni reescritura
`user.cuenta`, así que no hace falta el JOIN a `INS_TAB_USUARIOS`). D5 es un `UNION` de horario
modular/no modular — se mantuvo la estructura tal cual, solo se sacó el bind del `WHERE` y se expuso
`DOCENTE_CEDULA`/`CICLO_ACAD_CODIGO` como columnas filtrables. Validados con MINUS bidireccional por
MCP (0 filas los 4). Código migrado en los 2 `.query.ts`, build limpio, curl confirma ciclo
`1021-1099` y 2 bloques de horario agrupados (lunes, jueves) desde las 4 filas crudas ya verificadas
en Oracle. **Nota de método:** para este módulo no se capturó el curl "antes" (se editó el código
antes de pensar en el baseline) — la confirmación se hizo cruzando el JSON final contra los datos
crudos de Oracle inspeccionados previamente. Para el resto de módulos, capturar el baseline antes de
tocar el `.ts`, como sí se hizo en `distributivo-docente`. Sin commitear.

### `calendario-general` — completo (2026-09-17)
2 objetos (D6, D7 — ver [[00_Indice_Docentes]]). **El plan maestro solo catalogaba 2 sentencias para
este módulo; el código real tiene una tercera** (`CALENDARIO_GENERAL_LIMITES_QUERY`, endpoint
omisión de la auditoría original, no un cambio reciente. D6 es una sola vista que sirve tanto al
detalle (`CALENDARIO_GENERAL_QUERY`, filtro `FECHA_FIN BETWEEN`) como a los límites
(`CALENDARIO_GENERAL_LIMITES_QUERY`, `MIN/MAX(FECHA_FIN)`) — mismos JOIN/WHERE en ambas, solo cambia
cómo se consume desde el `.ts`. D7 reemplaza `MATERIAL_ID_CURSO_QUERY`, una consulta grande con
muchas funciones PL/SQL en la proyección (porcentajes, número de estudiantes, estado de aula
virtual) pero ninguna con bind dentro — igual V1. Ambas validadas con MINUS por MCP (0 filas) y
`MIN/MAX` idéntico para los límites. Baseline capturado **antes** de tocar el `.ts` (cédula
`<cedula>`, curso `54443`, con 189 actividades reales en 2 cursos) — curl idéntico en los 3
endpoints antes/después. Sin commitear.

**Total acumulado: 8 objetos (D1-D8), 3 módulos completos** (`distributivo-docente`,
`horario-docente`, `calendario-general`).

### `foro_online` — completo (2026-09-17)

Los 8 objetos (7 ya existían desde el 2026-09-16 + D8 nueva) ya estaban creados y validados en
Oracle desde la sesión anterior — ver detalle de esa verificación en [[00_Indice_Docentes]]. Esta
sesión migró los `.ts` y probó todo end-to-end.

**Migrados 10 de los 12 archivos** de `foro_online/repository/consultas/`:
- Vistas (`SELECT` directo, solo cambia la tabla de origen): `tipo_foro.query.ts` →
  `MVL_VIEW_FORO_TIPO`; `validar_actividad.query.ts` → `MVL_VIEW_FORO_ACT_ESTADO`;
  `autores_foro.query.ts` → `MVL_VIEW_FORO_AUTORES`; `get_instrucciones_actividad.query.ts` →
  `MVL_VIEW_ACTIVIDAD_INSTRUC_DOCENTE` (D8).
- Funciones `SYS_REFCURSOR`: `foro_general.query.ts` → `MVL_FUN_FORO_GENERAL(:1..:11)`;
  `foro_actividad.query.ts` → `MVL_FUN_FORO_ACTIVIDAD(:1,:2)`. Repositorio adaptado para
  desempaquetar la columna `FILAS` (`resultados[0]?.FILAS ?? []`), patrón idéntico al de
  estudiante — ver §4 de esta nota.
- Procedimientos (bloque `BEGIN ... END;`): `crear_respuesta_general.query.ts` →
  `MVL_PRC_FORO_CREAR_RESPUESTA_GENERAL` (14 params, sin duplicar `materiaCodigo`);
  `crear_respuesta_actividad.query.ts` → `MVL_PRC_FORO_CREAR_RESPUESTA_ACTIVIDAD` (5 params, sin
  duplicar `idActividad`); `actualizar_foro.query.ts` → `MVL_PRC_FORO_ACTUALIZAR`;
  `eliminar_foro.query.ts` → `MVL_PRC_FORO_ELIMINAR`. El repositorio original pasaba binds
  repetidos (`idActividad` dos veces, `materiaCodigo` dos veces) porque el `INSERT` crudo los
  reusaba en dos columnas distintas — los procedimientos ya resuelven ese reuso internamente, así
  que se quitaron los duplicados del arreglo de binds al migrar (se verificó orden y cantidad
  exacta contra `ALL_ARGUMENTS` antes de tocar el `.ts`, no solo contra el nombre).
- **No migrados a propósito** (código muerto, sin `import` en `foro_online.repository.ts` ni en
  `foro_online.service.ts`): `estado_actividad.query.ts` y `fecha_fin_actividad.query.ts`. Mismo
  criterio que se aplicó en estudiante — quedaron con el SQL crudo original tal cual.

**Verificación end-to-end (cuenta `<cuenta-de-prueba>`, curso `54443`/`CAPRU-MATPRU`):**
  contra el `SELECT` original ejecutado directo por MCP con los mismos binds: 33 filas totales, de
  las cuales 6 con `ESTADO='I'` — 33-6=27, coincide exacto. El Golden Master de `Documentado.md`
  §15.1 solo muestra 2 de esos 27 como extracto — no es una regresión, es un recorte de
  documentación, no una foto completa.
  instrucciones desde D8.
  (`DESCRIPCION` actualizada, `ESTADO='I'` tras el DELETE).
  verificada e igualmente borrada (soft-delete) al terminar la prueba.
- `pnpm run build`: limpio, sin errores de TypeScript.

**Pendiente sin resolver, no bloqueante:** `MVL_PRC_FORO_MARCAR_ACTIVIDAD_ENTREGADA` sigue sin
`.ts` que lo use — no se tocó, no confirmado para qué es.

**Total acumulado: 8 objetos (D1-D8), 4 módulos completos** (`distributivo-docente`,
`horario-docente`, `calendario-general`, `foro_online`). Todo sin commitear en
`practicas-preprofesionales`.

### `registro-academico` — completo (2026-09-17)

7 objetos (D9-D15 — ver [[00_Indice_Docentes]]). Clasificación re-auditada contra el código real (no
contra el plan maestro, que solo listaba fragmentos sin clasificar V1/V2). Dos hallazgos de método
reutilizables:

- **D13** (`NOTAS_GENERAL_ESTUDIANTES_QUERY`): el `IN (SELECT ... WHERE col = :bind)` de la
  subconsulta usaba los mismos nombres de bind que ya filtraban la tabla externa por fuera → los dos
  lados exigen el mismo valor, así que la subconsulta es equivalente a un `EXISTS` autocorrelacionado
  contra las columnas de la propia fila externa. Se reescribió así, sin binds, y valida limpio.
- **D14** (`MATERIAS_REGISTRO_ACADEMICO_QUERY`): `CICLO_ACAD_CODIGO IN (SELECT CODIGO FROM
  ACA_TAB_CICLOS_ACADEMICOS WHERE CODIGO = :bind)` no es una igualdad simple — es (igualdad al bind)
  **y** (el código existe en esa tabla). Se separó: la igualdad queda en el `WHERE` externo del
  `.ts`, la existencia se autocorrelaciona dentro de la vista. Patrón a repetir si aparece este mismo
  idioma `IN (SELECT PK FROM tabla WHERE PK = :bind)` en otros módulos.

Todas las tablas/funciones/paquetes referenciados sin prefijo en el `.ts` original (`ACA_TAB_*`,
`RHU_TAB_PERSONAS`, `FUN_OBTENER`, `INS_PCK_GENERAL`, `ACA_PCK_ACADEMICO`, etc.) se confirmaron en
`UTNDB` vía `ALL_OBJECTS` antes de escribir el DDL — MOVIL_UTN no tiene sinónimos propios para ellos.

Excluidos de la migración: `validar-materia-activa.query.ts`, `validar_acceso_asistencias.query.ts`,
`validar_visibilidad_porcentajes.query.ts` (T, triviales) y `documento-notas-estudiantes.query.ts`

Validación: los 7 objetos compilaron `VALID` en Toad y se corrió MINUS bidireccional por MCP contra
docente `<cedula>`, ciclo `1021-1099`, materia `CAPRU-MATPRU` — 0 filas en los 14 sentidos.
Migrados los 7 `.ts`, `pnpm run build` limpio, y probados por `curl` real 6 de los 7 endpoints
(`/ciclos`, `/` con ciclo, `/estudiantes`, `/estudiantes-foto`, `/notas`, `/detalle-materia-notas`),
todos devolviendo los mismos estudiantes/materia de referencia (`idCurso` 54443, cédulas
`<cedula>`/`1050XXXXXX`/`1004XXXXXX`) que documenta `Salidas-Docente/Documentado.md` §9. **D15
(`validarEstadoAulaVirtual`) no se probó por curl**: su único invocador es `POST
/registro-academico/crear-aula-virtual`, un endpoint de escritura, y no se ejecutó para no crear un
aula virtual real — quedó validado solo por MINUS contra Oracle.

**Total acumulado: 15 objetos (D1-D15), 5 módulos completos** (`distributivo-docente`,
`horario-docente`, `calendario-general`, `foro_online`, `registro-academico`). Sin commitear en
`practicas-preprofesionales`.


### `actividad` — en curso (2026-09-17), módulo bastante más complejo que los anteriores

30 archivos (~50 sentencias), el de mayor prioridad en [[00_Indice_Docentes]] que seguía sin
empezar. **Auditarlo tomó mucho más tiempo que `registro-academico`** — no es lentitud, es que este
módulo tiene sorpresas reales que solo aparecen leyendo cada `.ts` completo:

- **Dos flujos de escritura ya estaban migrados sin que quedara registrado en ningún lado**:
  `crear-actividad-query.ts` y `actulizar_actividad.query.ts` ya llaman a
  `MOVIL_UTN.MVL_PRC_CREAR_ACTIVIDAD` / `MVL_PRC_ACTUALIZAR_ACTIVIDAD` (con soporte de `BLOB`). Sus
  contrapartes "sin adjunto" (`crear-actividad-sin-adjunto.query.ts`,
  `actualizar_actividad_sinadjunto.query.ts`) siguen en `INSERT`/`UPDATE` crudo — son las que faltan
  migrar, y deberían poder reusar/envolver los mismos procedimientos (o uno análogo sin los
  parámetros de blob) en vez de crear lógica duplicada.
- **`validar-crear-actividad.query.ts` tiene una rama muerta**: compara contra
  `wwv_flow_custom_auth_std.get_username`, paquete de **Oracle APEX** (`APEX_200200`/`APEX_240200`
  en `ALL_OBJECTS`). Fuera de una sesión APEX (o sea, siempre, porque este backend es NestJS puro)
  esa función devuelve `NULL`, así que la rama `UNION` nunca aporta filas en la práctica. No se
  "arregla" — es candidata a T (trivial, además de muerta) y no se migra.
- **`politicas-evaluacion.query.ts`** mete el bind `:CODIGO_PARCIAL` dentro del propio `CASE` que
  arma el texto de salida (`TE.DESCRIPCION || ' (' || PE.PORCENTAJE_Nx || '%)'`), no solo en el
  `WHERE`. No es "exponer columna y filtrar afuera": hay que exponer `PORCENTAJE_N1..N5` crudos y
  mover el armado del string al `.ts`. Pendiente de diseño.
- **El clúster de "preguntas de evaluación" (~8 sentencias)** tiene pinta de tener una versión vieja
  con fragmentos de filtro concatenados dinámicamente (`FILTRO_CONTENIDO_QUERY`,
  `FILTRO_DIFICULTAD_QUERY`, etc. pegados al `BASE_PREGUNTAS_A_AGREGAR_EVALUACION_QUERY`) y una
  versión más nueva ya separada en dos consultas fijas (`BASE_PREGUNTAS_YA_AGREGADAS_QUERY` /
  `BASE_PREGUNTAS_DISPONIBLES_QUERY`). Falta confirmar contra `actividad.repository.ts` y el
  service cuál de las dos sigue realmente enchufada antes de migrar cualquiera — no vale la pena
  crear una vista para código ya muerto.
- **`PREGUNTAS_EVALUACION_ESTUDIANTES_QUERY`** arma el `IN (...)` pegando cédulas directo en el
  string (`cedulas.map(c => '${c}').join(', ')`) en vez de bind — hay que resolverlo con
  `TABLE(SYS.ODCIVARCHAR2LIST(...))` o similar al migrar, no es un cambio mecánico de "quitar bind,
  exponer columna".

**Avance real validado (2026-09-17):** 4 vistas creadas y validadas por MINUS (0/0), contra docente
`<cedula>` / curso `54443` / actividad `627018`:
- **D16** `MVL_VIEW_ACTIVIDAD_DOCENTE` — reemplaza `ACTIVIDAD_DOCENTE_QUERY` (`actividad.query.ts`). V1.
- **D17** `MVL_VIEW_CONTENIDOS_ACTIVIDAD` — reemplaza `CONTENIDOS_QUERY`. V1.
- **D18** `MVL_VIEW_TIPOS_ACTIVIDAD` — reemplaza `TIPOS_ACTIVIDAD_QUERY`. Passthrough puro de
  `LMS_TAB_TIPO_ACTIVIDAD` (`DESCRIPCION, CODIGO, ESTADO, POLITICA_EVAL_CODIGO`) — el `WHERE`/`UNION`
  con la lógica de negocio original (bind mezclado con `OR`/`AND` sin paréntesis, hay que preservarlo
  tal cual, hasta con su ambigüedad de precedencia) se reconstruye completo en el `.ts` contra la
  vista, no se tocó la lógica.
- **D19** `MVL_VIEW_PARCIALES_ACTIVIDAD` — reemplaza `PARCIALES_QUERY`. V2: el original mezcla en un
  mismo `UNION` dos filas siempre presentes (`Primera Parcial`, `Todo`, sin filtro de curso) con tres
  filas condicionadas a `AV.ID_CURSO = :bind`. Se resolvió agregando una columna `ID_CURSO` con
  `CAST(NULL AS NUMBER)` en las ramas incondicionales, y filtrando afuera con
  `WHERE ID_CURSO = :cursoId OR ID_CURSO IS NULL` — patrón reutilizable para cualquier otro `UNION`
  con ramas de distinta dependencia del bind.

**Migrados a T (trivial, sin JOIN, lookup por PK o `DUAL`) — no se crean vistas:**
`curso-actividad.query.ts`, `fecha_de_creacion_actividad.query.ts`,
`validar-actividad-activa.query.ts`, `validar-cuestionario-respuestas-estudiante.query.ts`,
`validar-evaluacion-ya-sorteada.query.ts`, `evaluacion/num-preguntas-evaluacion.query.ts` (cuenta
sobre una vista `LMS_VIEW_*` ya existente, además → también YA),
`evaluacion/preguntas-evaluacion.query.ts#COUNT_PREGUNTAS_ASIGNADAS_EVALUACION_QUERY`,
`validar-editar-actividad-query.ts`, `validar-parcial-activo-query.ts`,
`validar-crear-actividad.query.ts` (T + rama muerta APEX, ver arriba).

**Pendiente de este módulo, en este orden:** (1) confirmar contra el repository/service cuáles
consultas del clúster de preguntas siguen vivas, (2) diseñar D20 (`politicas-evaluacion`, requiere
mover el `CASE` al `.ts`), (3) diseñar las vistas del clúster de estudiantes-evaluación (N1/N2 y
N3/N4, con paginación `OFFSET/FETCH` que se queda fuera de la vista igual que siempre), (4) resolver
`PREGUNTAS_EVALUACION_ESTUDIANTES_QUERY` con `TABLE(SYS.ODCIVARCHAR2LIST(...))`, (5) diseñar los
procedimientos "sin adjunto" reusando el patrón de `MVL_PRC_CREAR_ACTIVIDAD`/`_ACTUALIZAR_ACTIVIDAD`
ya existentes, (6) recién ahí migrar los `.ts` y probar end-to-end. No commiteado nada de código
todavía para este módulo (solo las 4 vistas en Oracle).

---

## 2026-09-22 — Restauración del respaldo y trabajo por tandas




**Nuevo ritmo:** tandas de ~5 objetos. Los DDL van en `%USERPROFILE%\<escritorio>/DDL-DOCENTE-DDTI\` (un `.sql` por tanda, sin comentarios, abrir en Toad con File → Open).

### Tanda 1 — `actividad`, lecturas con vista ya existente (sin DDL) ✅
Migrados `actividad.query.ts` → `MVL_VIEW_ACTIVIDAD_DOCENTE` (D16), `contenidos.query.ts` → `MVL_VIEW_CONTENIDOS_ACTIVIDAD` (D17), `tipos-actividad-query.ts` → `MVL_VIEW_TIPOS_ACTIVIDAD` (D18, misma lógica `WHERE`/`UNION` del original, ahora sobre la vista), `parciales.query.ts` → `MVL_VIEW_PARCIALES_ACTIVIDAD` (D19, `WHERE ID_CURSO = :bind OR ID_CURSO IS NULL` + `ORDER BY D, R` para conservar el orden implícito del `UNION`). MINUS repetido el 22-09 con datos actuales: 0/0 (292, 10 y 10 filas). Curl antes/después: 16/16 idénticos byte a byte.

Clasificados **M (muertos)**, sin migrar: `validar_fecha_fin_clase_sincrona.query.ts` y `PREGUNTAS_EVALUACION_ESTUDIANTE_QUERY` (sin invocadores).


### Tanda 2 — `actividad`, escrituras de evaluación (DDL entregado)
`tanda-02-evaluacion-escrituras.sql`: `MVL_PRC_EVAL_ELIMINAR_CUESTIONARIO`, `MVL_PRC_EVAL_RESETEAR_TIEMPO`, `MVL_PRC_EVAL_AGREGAR_PREGUNTAS`, `MVL_PRC_EVAL_ELIMINAR_PREGUNTAS`. Las dos últimas reciben `SYS.ODCINUMBERLIST`: el `.ts` arma `SYS.ODCINUMBERLIST(:c0, :c1, ...)` con binds, lo que además elimina la concatenación directa de `codigosPreguntas` en el SQL. Sortear y agregar-intento ya llaman a procedimientos de `UTNDB` → YA.
