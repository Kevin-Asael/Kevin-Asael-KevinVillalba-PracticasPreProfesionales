# Migración de queries hardcodeadas a vistas y funciones Oracle (estudiante)

**Fecha:** 2026-09-14 (inicio piloto) — en curso
**Repo:** `utn-movil-portafolio-estudiante`
**Rama:** `refactor/migracion-queries-vistas` (derivada de `practicas-preprofesionales`)
**Commits:** `8855b02` (refactor en rama), `18138f6` (merge a `practicas-preprofesionales`)

---

## 1. El problema

El repo tenía **~150 sentencias SQL escritas literalmente** (`hardcoded`) en archivos `.ts` de
repositorios y queries. Si el DBA cambia una tabla o columna en Oracle (`UTNDB`), el código
no se entera hasta que explota en runtime — sin error de compilación, sin warning.

Auditoría original: `Queries Encontradas/00_Indice_Resumen.md` (índice de ~125 queries
identificadas, luego refinado a 150 en el plan completo).

---

## 2. Solución

Encapsular la lógica relacional en **objetos de Oracle** del esquema `MOVIL_UTN`:

| Categoría | Objeto Oracle | Cuándo |
|---|---|---|
| **V1 — Vista directa** | `MVL_VIEW_*` | Los binds solo filtran en el `WHERE` externo |
| **V2 — Vista reescrita** | `MVL_VIEW_*` | Requiere reescritura de SQL |
| **F — Función cursor** | `MVL_FUN_*` | Binds dentro de proyección, subquery, agregado o paginación — devuelve `SYS_REFCURSOR` |
| **P/W — Procedimiento** | `MVL_PRC_*` | Escrituras (`INSERT`/`UPDATE`/`DELETE`/`MERGE`) |

Excluidos: triviales (`SELECT 1 FROM DUAL`), ya migrados (`LMS_VIEW_*`, paquetes PL/SQL), código muerto.

---

## 3. Metodología de validación

1. Claude prepara **un objeto a la vez** con DDL completo
2. El usuario lo ejecuta en **Toad** conectado como `MOVIL_UTN` en la réplica de dev
3. Validación con **MINUS bidireccional** (0 filas en ambos sentidos)
4. Funciones: bloque anónimo con `DBMS_SQL.RETURN_RESULT(cursor)`, comparación fila a fila
5. Solo cuando **toda la tanda del módulo** está validada en Oracle, se cambia el código `.ts`
6. Verificación final: `pnpm run build` + `curl` antes/después contra servicio local

Detalle completo del ritual en:
`07 - Documentacion/2026-09-14 - Como trabajamos la migracion de queries a vistas (continuidad).md`

---

## 4. Estado por módulo

**Piloto completado:** `foro_online` — 6 objetos Oracle (vistas + funciones) creados, validados
con MINUS bidireccional, código `.ts` actualizado, `pnpm build` limpio, respuesta JSON idéntica
antes/después vía `curl`.

**Plan completo (inventario de las 150 sentencias):**
`Backup-Planes/2026-09-14 - Plan completo migracion SELECT a vistas (portafolio-estudiante).md`

---

## 5. Hallazgos durante la migración

- `foro_online.service.spec` ya estaba roto antes de migrar — documentado en
  `Descubrimientos queries/2026-09-14 - foro_online.service.spec ya estaba roto antes de migrar.md`
  (mismo patrón que en docentes, ver nota separada)
