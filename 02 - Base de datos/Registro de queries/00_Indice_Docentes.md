# Índice de Queries — Portafolio Docente

Hubs:  · [[00_Indice_Resumen]] ·  · [[2026-09-17 - Como trabajamos la migracion de queries (continuidad-docentes)|Guía de Continuidad Docentes]] · [[2026-09-16 - Plan completo migracion queries a vistas y procedimientos (portafolio-docentes)|Plan Completo Docentes]]

- **Repositorio:** `utn-movil-portafolio-docentes`
- **Módulos de negocio en `src/modules`:** 21 módulos
- **Archivos de queries identificados:** ~242 archivos
- **Sentencias SQL totales estimadas:** >242 sentencias (múltiples constantes en módulos como `actividad`)
- **Nomenclatura de objetos creados:** Prefijo `D1, D2, D3...` (para diferenciar de `Q1–Q53` de estudiante)

---

## 📋 Módulos con Queries (Prioridad de Migración)

Módulos ordenados por volumen y criticidad para la migración:

- [[actividad]] — `portafolio-docentes/actividad` (30 archivos, ~50 sentencias SQL)
- [[banco-preguntas]] — `portafolio-docentes/banco-preguntas` (33 sentencias)
- [[aula-virtual]] — `portafolio-docentes/aula-virtual` (27 sentencias)
- [[produccion-cientifica]] — `portafolio-docentes/produccion-cientifica` (23 sentencias)
- [[proyectos-investigacion]] — `portafolio-docentes/proyectos-investigacion` (22 sentencias)
- [[asistencia-estudiantes]] — `portafolio-docentes/asistencia-estudiantes` (19 sentencias)
- [[revision-respuestas]] — `portafolio-docentes/revision-respuestas` (13 sentencias)
- [[avance-materia]] — `portafolio-docentes/avance-materia` (13 sentencias)
- [[registro-academico]] — `portafolio-docentes/registro-academico` (12 sentencias)
- [[foro_online]] — `portafolio-docentes/foro_online` (10 sentencias)
- [[foro-online-old]] — `portafolio-docentes/foro-online-old` (10 sentencias — código muerto/descartado)
- [[perfil-docente]] — `portafolio-docentes/perfil-docente` (7 sentencias)
- [[shared]] — `portafolio-docentes/shared` (4 sentencias)
- [[control_de_bienes]] — `portafolio-docentes/control_de_bienes` (3 sentencias)
- [[distributivo-docente]] — `portafolio-docentes/distributivo-docente` (3 sentencias)
- [[calendario-general]] — `portafolio-docentes/calendario-general` (2 sentencias)
- [[documentos_directorio]] — `portafolio-docentes/documentos_directorio` (2 sentencias)
- [[horario-docente]] — `portafolio-docentes/horario-docente` (2 sentencias)
- [[pagos]] — `portafolio-docentes/pagos` (2 sentencias)
- [[validacion_acceso]] — `portafolio-docentes/validacion_acceso` (2 sentencias)
- (nota interna, no publicada) — `portafolio-docentes/parametros-servidor-reportes` (1 sentencia)

> [!NOTE]
> Los directorios `config/` y `health/` se encuentran en la raíz de `src/` y no constituyen módulos funcionales de negocio en `src/modules/`. Contienen verificaciones técnicas del sistema (`SELECT 1 FROM DUAL`).

---

## 📊 Balance Inicial de Clasificación

Aplicando el criterio de filtrado estricto (acordado en estudiante y confirmado para docentes):

| Categoría | Descripción | Sentencias aprox. | Acción en Migración |
|---|---|:---:|---|
| **V1** | Vista directa sin transformación | 72 | Se crea `MOVIL_UTN.MVL_VIEW_*` |
| **V2** | Vista con reescritura técnica | 29 | Se reescribe y crea `MOVIL_UTN.MVL_VIEW_*` |
| **F** | Función con `SYS_REFCURSOR` | 16 | Se crea `MOVIL_UTN.MVL_FUN_*` |
| **P / W** | Procedimiento de escritura (`INSERT`/`UPDATE`/`DELETE`/bloques) | 29 | Se crea `MOVIL_UTN.MVL_PRC_*` |
| **T** | Trivial (`SELECT 1`, lookup simple 1 col PK) | 42 | **No se migra** (se mantiene en código) |
| **YA** | Ya resuelto (usa vistas u objetos existentes) | 39 | **No se migra** (ya consume objetos) |
| **M** | Código muerto (constantes sin llamador) | 15 | **No se migra** (se ignora) |

- **Total a migrar en fase lectura (V1 + V2 + F):** ~117 sentencias
- **Total a migrar en fase escritura (P):** ~29 sentencias
- **Total excluido sin cambios (T + YA + M):** ~96 sentencias

---



---

## 🛠️ Objetos creados (D1, D2, D3...)

> [!NOTE]
> Registro cronológico de objetos Oracle (`MOVIL_UTN`) creados y validados para `utn-movil-portafolio-docentes`.

- **D1** `MOVIL_UTN.MVL_VIEW_CICLOS_DISTRIBUTIVO` — reemplaza `CICLO_ACADEMICO_DISTRIBUTIVO_QUERY` (`distributivo-docente`). V2, subconsulta cuenta→cédula reescrita a JOIN con `INS_TAB_USUARIOS`. Validada (MINUS 0 en los 2 sentidos), curl idéntico.
- **D2** `MOVIL_UTN.MVL_VIEW_DISTRIBUTIVO_ACADEMICO` — reemplaza `DISTRIBUTIVO_ACADEMICO_QUERY`. V2, `LMS_FUN_CEDULA_USUARIO(:bind)` reescrito a JOIN. Validada, curl idéntico.
- **D3** `MOVIL_UTN.MVL_VIEW_DISTRIBUTIVO_PERSONAL` — reemplaza `DISTRIBUTIVO_PERSONAL_QUERY`. V2, mismo patrón, **sin DISTINCT** (el original no lo lleva; confirmado con datos reales que hay filas duplicadas legítimas que se suman en el backend). Validada (MINUS + COUNT(*) 2=2), curl idéntico.

**Módulo `distributivo-docente`: completo (3/3).** `utn-movil-portafolio-docentes/practicas-preprofesionales`, sin commitear.

- **D4** `MOVIL_UTN.MVL_VIEW_CICLOS_HORARIO_DOCENTE` — reemplaza `CICLO_ACADEMICO_QUERY` (`horario-docente`). **V1** (el plan maestro la clasificaba V2 con `ROW_NUMBER()`, dato desactualizado — el archivo real es un filtro directo por cédula). Validada (MINUS 0 en los 2 sentidos).
- **D5** `MOVIL_UTN.MVL_VIEW_HORARIO_DOCENTE` — reemplaza `HORARIO_DOCENTE_QUERIES` (`UNION` de horario modular/no modular). **V1**, mismo motivo. Validada (MINUS 0 en los 2 sentidos), curl confirma 2 bloques agrupados desde 4 filas crudas.


- **D6** `MOVIL_UTN.MVL_VIEW_CALENDARIO_GENERAL_DOCENTE` — reemplaza `CALENDARIO_GENERAL_QUERY` y `CALENDARIO_GENERAL_LIMITES_QUERY` (`calendario-general`). V1. Una sola vista sirve a las dos consultas (detalle con `FECHA_FIN BETWEEN`, límites con `MIN/MAX`). `CALENDARIO_GENERAL_LIMITES_QUERY` no estaba en el plan maestro (omisión del audit original). Validada (MINUS 0 + límites idénticos).
- **D7** `MOVIL_UTN.MVL_VIEW_MATERIA_ID_CURSO_DOCENTE` — reemplaza `MATERIAL_ID_CURSO_QUERY`. V1. Validada (MINUS 0 en los 2 sentidos).

**Módulo `calendario-general`: completo (3/3 consultas reales, plan maestro solo tenía 2 catalogadas).**

- **D8** `MOVIL_UTN.MVL_VIEW_ACTIVIDAD_INSTRUC_DOCENTE` — nueva, para `get_instrucciones_actividad.query.ts` (`foro_online`). Pasthrough simple de `LMS_TAB_ACTIVIDAD_ACADEMICA` (`ID_ACTIVIDAD, NOMBRE_CORTO, FECHA_INICIO, FECHA_FIN, DESCRIPCION`), sin filtro embebido. **No reutilizar `MVL_VIEW_FORO_INSTRUC_ACT`** (la de estudiante): hace `JOIN` a `LMS_TAB_ACTIVIDADES_ALUMNOS` y fuerza `ESTADO='A'`, produciría filas duplicadas por estudiante inscrito — el docente solo necesita 1 fila por `ID_ACTIVIDAD`. Validada (MINUS 0, `DESCRIPCION` es CLOB, envuelta con `DBMS_LOB.SUBSTR`).

**Módulo `foro_online` — completo (2026-09-17).** Los otros 7 objetos que necesitaba
**ya existían** en Oracle (creados 2026-09-16, aparentemente ya preparados para este módulo — nombres
reales distintos a los que decía el plan maestro, verificados texto a texto contra `ALL_SOURCE`, no
solo por nombre):

| Archivo `.ts` en `foro_online/repository/consultas/` | Objeto Oracle |
|---|---|
| `tipo_foro.query.ts` | `MVL_VIEW_FORO_TIPO` |
| `estado_actividad.query.ts`, `validar_actividad.query.ts`, `fecha_fin_actividad.query.ts` (3→1) | `MVL_VIEW_FORO_ACT_ESTADO` |
| `autores_foro.query.ts` | `MVL_VIEW_FORO_AUTORES` |
| `get_instrucciones_actividad.query.ts` | `MVL_VIEW_ACTIVIDAD_INSTRUC_DOCENTE` (D8, nueva) |
| `foro_general.query.ts` | `MVL_FUN_FORO_GENERAL` |
| `foro_actividad.query.ts` | `MVL_FUN_FORO_ACTIVIDAD` |
| `crear_respuesta_general.query.ts` | `MVL_PRC_FORO_CREAR_RESPUESTA_GENERAL` |
| `crear_respuesta_actividad.query.ts` | `MVL_PRC_FORO_CREAR_RESPUESTA_ACTIVIDAD` |
| `actualizar_foro.query.ts` | `MVL_PRC_FORO_ACTUALIZAR` |
| `eliminar_foro.query.ts` | `MVL_PRC_FORO_ELIMINAR` |

**Los 10 archivos `.ts` de arriba migrados y probados end-to-end** (GET general/actividad, POST
general/actividad, PATCH y DELETE — los 6 con curl real contra `<cuenta-de-prueba>`, cruzado contra Oracle
antes/después). `estado_actividad.query.ts` y `fecha_fin_actividad.query.ts` quedaron **sin migrar a
propósito**: son código muerto dentro del propio `foro_online` (ningún `import` en
`foro_online.repository.ts`/`.service.ts`), mismo criterio que en estudiante. Detalle completo de la
migración y las pruebas en la nota de continuidad, §7 `foro_online`.

**Módulo `foro_online`: completo.** Hay un 5º procedimiento ya creado,
`MVL_PRC_FORO_MARCAR_ACTIVIDAD_ENTREGADA(P_ID_ACTIVIDAD, P_CEDULA)`, que no tiene archivo `.ts`
correspondiente entre los que se auditaron — no usar sin confirmar antes para qué es.

- **D09** `MOVIL_UTN.MVL_VIEW_CICLOS_REGISTRO_ACADEMICO` — reemplaza `CICLO_ACADEMICO_REGISTRO_ACADEMICO_QUERY`. V1. Validada (MINUS 0/0), curl real.
- **D11** `MOVIL_UTN.MVL_VIEW_ESTUDIANTES_MATERIA_DOCENTE` — reemplaza `ESTUDIANTES_POR_MATERIA_QUERY`. V1. Validada (MINUS 0/0), curl real.
- **D12** `MOVIL_UTN.MVL_VIEW_LISTA_ESTUDIANTES_FOTO_DOCENTE` — reemplaza `LISTA_ESTUDIANTES_FOTO_QUERY`. V1, no expone el BLOB `FOTO` (igual que el original). Validada (MINUS 0/0), curl real.
- **D13** `MOVIL_UTN.MVL_VIEW_NOTAS_GENERAL_ESTUDIANTES_DOCENTE` — reemplaza `NOTAS_GENERAL_ESTUDIANTES_QUERY`. V2, el `IN` original filtraba `ACA_TAB_DETALLE_MATRICULAS` por los mismos binds que ya filtraban la tabla externa (mismo nombre reusado) → se reescribió como `EXISTS` autocorrelacionado sin binds. Validada (MINUS 0/0), curl real.
- **D14** `MOVIL_UTN.MVL_VIEW_MATERIAS_REGISTRO_ACADEMICO_DOCENTE` — reemplaza `MATERIAS_REGISTRO_ACADEMICO_QUERY`. V2, `CICLO_ACAD_CODIGO IN (SELECT...WHERE CODIGO=:bind)` se separó en igualdad externa + `EXISTS` de integridad autocorrelacionado. Validada (MINUS 0/0), curl real.
- **D15** `MOVIL_UTN.MVL_VIEW_ESTADO_AULA_VIRTUAL_DOCENTE` — reemplaza `VALIDAR_ESTADO_AULA_VIRTUAL_QUERY`. V1, `ROWNUM=1` movido al `.ts` (no puede vivir en la vista). Validada por MINUS (0/0) contra Oracle; **no probada por curl** porque su único invocador es `crearAulaVirtual` (POST de escritura, no se ejecutó para no crear un aula virtual real).

**Módulo `registro-academico`: completo (7/7).** Excluidos de la migración (igual criterio que otros
módulos): `validar-materia-activa.query.ts`, `validar_acceso_asistencias.query.ts`,
`validar_visibilidad_porcentajes.query.ts` (T, triviales) y `documento-notas-estudiantes.query.ts`

**Total acumulado: 15 objetos (D1-D15), 5 módulos completos** (`distributivo-docente`,
`horario-docente`, `calendario-general`, `foro_online`, `registro-academico`).

### `actividad` — en curso, módulo más grande y más enredado de lo que parecía (30 archivos)

- **D16** `MOVIL_UTN.MVL_VIEW_ACTIVIDAD_DOCENTE` — reemplaza `ACTIVIDAD_DOCENTE_QUERY`. V1. Validada (MINUS 0/0).
- **D17** `MOVIL_UTN.MVL_VIEW_CONTENIDOS_ACTIVIDAD` — reemplaza `CONTENIDOS_QUERY`. V1. Validada (MINUS 0/0).
- **D18** `MOVIL_UTN.MVL_VIEW_TIPOS_ACTIVIDAD` — reemplaza `TIPOS_ACTIVIDAD_QUERY`. Passthrough de `LMS_TAB_TIPO_ACTIVIDAD`; la lógica de negocio del `WHERE`/`UNION` original se reconstruye en el `.ts`. Validada (MINUS 0/0).
- **D19** `MOVIL_UTN.MVL_VIEW_PARCIALES_ACTIVIDAD` — reemplaza `PARCIALES_QUERY`. V2, técnica de columna `NULL` para ramas de `UNION` con distinta dependencia del bind (ver nota de continuidad). Validada (MINUS 0/0).

Hallazgos que cambian el resto del plan de este módulo (detalle completo en la nota de continuidad,
§`actividad`): dos procedimientos de escritura (`MVL_PRC_CREAR_ACTIVIDAD`/`_ACTUALIZAR_ACTIVIDAD`) ya
existían sin que quedara registrado; `validar-crear-actividad.query.ts` tiene una rama muerta que
depende de Oracle APEX; `politicas-evaluacion.query.ts` necesita mover un `CASE` dependiente del bind
al `.ts`; el clúster de "preguntas de evaluación" (~8 sentencias) puede tener versiones ya
supersedidas — pendiente confirmar contra el repository antes de migrar. Clasificadas como T
(triviales, sin vista): `curso-actividad`, `fecha_de_creacion_actividad`, `validar-actividad-activa`,
`validar-cuestionario-respuestas-estudiante`, `validar-evaluacion-ya-sorteada`,
`num-preguntas-evaluacion` (también YA, ya usa `LMS_VIEW_PREGUNTAS_CONTENIDO`),
`COUNT_PREGUNTAS_ASIGNADAS_EVALUACION_QUERY`, `validar-editar-actividad`, `validar-parcial-activo`,
`validar-crear-actividad`.

**Total acumulado: 19 objetos (D1-D19), 5 módulos completos + `actividad` en curso.**
