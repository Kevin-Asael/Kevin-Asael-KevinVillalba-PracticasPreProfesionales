
# Módulo: portafolio-docentes/distributivo-docente

*Fecha de auditoría: 2026-09-09T14:35:26.984Z*

## Archivo: /src/modules/distributivo-docente/repository/queries/ciclo-academico-distributivo.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
        (SELECT C.DESCRIPCION
                   FROM ACA_TAB_CICLOS_ACADEMICOS C
                  WHERE C.CODIGO = TAB_DISTRIBUTIVOS.CICLO_ACAD_CODIGO) AS DESCRIPCION,
        TAB_...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/distributivo-docente/repository/queries/distributivo-academico.dto.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT CODIGO,
        DEPENDENCIA,
        CICLO AS "CICLO",
        DESCRIPCION,
        MATERIA,
        PARALELO_CODIGO,
        MODALIDAD,
        OBSERVACION as "HORAS"
   FROM (SELECT DISTINC...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/distributivo-docente/repository/queries/distributivo-personal.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DEPENDENCIA,CICLO,DESCRIPCION,HORAS,OBSERVACION FROM(
 SELECT ACA_TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
         ACA_TAB_DISTRIBUTIVOS.ESTADO DIST_ESTADO,
         ACA_TAB_CICLOS_ACADEMICOS.ESTAD...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

