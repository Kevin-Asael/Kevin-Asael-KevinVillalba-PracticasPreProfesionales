# Migración a vistas de proyectos y producción científica perdida en un merge (docentes)

- **Fecha:** 2026-10-13
- **Repo:** `utn-movil-portafolio-docentes`
- **Estado:** hallazgo verificado; **pendiente de decisión del equipo responsable**. No se tocó nada de esos dos módulos.
- Relacionada: [[2026-10-13 - Migracion de SELECT a vistas en docentes (fase 2)]]

## Qué se encontró

Las consultas de `proyectos-investigacion` y `produccion-cientifica` ya se habían migrado a vistas en febrero de 2026. Las vistas siguen creadas en `MOVIL_UTN`, pero el código que las usaba no está ni en `main` ni en `practicas-preprofesionales`: hoy esos dos módulos leen las tablas directamente.

Por eso, al preparar la fase 2 se estuvo a punto de crear 33 vistas nuevas que duplicaban 31 que ya existen.

## Evidencia

**Las vistas existen en la base** (leídas con el MCP de estructura, `obtener_ddl`):

- Producción científica: `MVL_VIEW_ARTICULOS`, `MVL_VIEW_LIBROS`, `MVL_VIEW_CAPITULOS_LIBRO`, `MVL_VIEW_PONENCIAS`, `MVL_VIEW_OBRAS_ARTISTICAS`, `MVL_VIEW_DETALLE_ARTICULO`, `MVL_VIEW_DETALLE_LIBRO`, `MVL_VIEW_DETALLE_CAP_LIBRO`, `MVL_VIEW_DETALLE_PONENCIA`, `MVL_VIEW_DETALLE_OBRA_ARTISTICA`, `MVL_VIEW_AUTORES_OBRA`, `MVL_VIEW_BD_INDEXADAS`, `MVL_VIEW_CONTEO_BD_INDEXADA`, `MVL_VIEW_CONTEO_TIPOS_OBRA`.
- Proyectos: `MVL_VIEW_PROYECTOS_INVESTIGACION`, `MVL_VIEW_CONVOCATORIAS`, `MVL_VIEW_DATOS_PROYECTO`, `MVL_VIEW_AREAS_INVESTIGACION_PROYECTO`, `MVL_VIEW_BENEFICIARIOS_PROYECTO`, `MVL_VIEW_EJES_INTEGRADORES_PROYECTO`, `MVL_VIEW_EQUIPO_TRABAJO_PROYECTO`, `MVL_VIEW_ESTRATEGIAS_PRODUCCION_PROYECTO`, `MVL_VIEW_ESTRATEGIAS_RESULTADOS_PROYECTO`, `MVL_VIEW_INFRAESTRUCTURA_PROYECTO`, `MVL_VIEW_INSTITUCIONES_ASOC_PROYECTO`, `MVL_VIEW_LINEA_INVESTIGACION_PROYECTO`, `MVL_VIEW_SECTORES_IMPACTO_PROYECTO`, `MVL_VIEW_DOCUMENTOS_RESPALDO_PROYECTO`, `MVL_VIEW_DOC_PRESUPUESTO_PROYECTO`, `MVL_VIEW_DOC_PROYECTO_PROYECTO`, `MVL_VIEW_DOC_RESOLUCION_PROYECTO`.

**El código que las usa está en la rama `beta`** (según el historial de Git):

| Commit | Fecha | Mensaje |
|---|---|---|
| `4122951` | 2026-02-24 | feat(proyectos-investigacion): utilizar nueva vista MVL_VIEW_CONVOCATORIAS |
| `205ae91` | 2026-02-24 | feat(proyectos-investigacion): utilizar nueva vista MVL_VIEW_PROYECTOS_INVESTIGACION |
| `3171201` | 2026-02-24 | refactor(proyectos-investigacion): migrar queries a vistas MVL_VIEW |
| `cc0713c` | 2026-02-25 | refactor(produccion-cientifica): migrar queries a vistas MVL_VIEW |
| `a751026` | 2026-02-25 | refactor(produccion-cientifica): migrar queries a vistas MVL_VIEW |

**Dónde se perdió.** `beta` es ancestro de `practicas-preprofesionales`, pero el contenido no llegó. En estos dos merges, uno de los padres usaba `MVL_VIEW_ARTICULOS` y el resultado no:

| Merge | Fecha | Autor | Mensaje |
|---|---|---|---|
| `58ff533` | 2026-03-12 | Equipo de desarrollo | Merge branch 'main' of …/utn-movil-portafolio-docentes |
| `67c35c7` | 2026-03-14 | Equipo de desarrollo | Merge branch 'beta' |

Comando para repetir la comprobación en cada merge:

```bash
git grep -l 'MVL_VIEW_ARTICULOS' <merge> -- src      # 0 archivos
git grep -l 'MVL_VIEW_ARTICULOS' <merge>^2 -- src    # 1 archivo
```

**Tamaño de la diferencia.** `git diff --stat origin/beta HEAD -- src/modules/proyectos-investigacion src/modules/produccion-cientifica` da 37 archivos. No son solo las consultas: en `beta` también están refactorizados el repositorio y el servicio de los dos módulos (`ea68af3`, `8b78987`), y hay arreglos posteriores (`82f2562` conteo de proyectos por convocatoria, `a63d5a3` orden del equipo de trabajo).

## Lo que no se sabe

Si los merges se quedaron con la versión vieja **por accidente** al resolver conflictos, o **a propósito** como marcha atrás. Solo lo puede confirmar el equipo responsable. ⚠ Sin verificar.

## Por qué importa

- Son 49 consultas que ya tienen vista hecha y probada; rehacerlas duplicaría objetos en la base.
- Si la pérdida fue accidental, puede que también se hayan perdido arreglos de comportamiento, no solo la migración.
- Las vistas siguen en la base sin que nadie las use: pueden haberse quedado atrás respecto al código actual.

## Qué corresponde

1. Preguntar al equipo responsable si lo de `beta` se descartó a propósito.
2. Si no: recuperar esos dos módulos desde `beta` en vez de reescribir las consultas, y validar con MINUS la consulta actual contra cada vista existente.
3. Si sí: decidir si las 31 vistas se actualizan y se usan, o se eliminan.

Las especificaciones que se habían preparado para estos dos módulos quedaron guardadas en `<escritorio>/DDL-DOCENTE-DDTI\generador\en_espera\`, por si sirven de base para las pruebas.
