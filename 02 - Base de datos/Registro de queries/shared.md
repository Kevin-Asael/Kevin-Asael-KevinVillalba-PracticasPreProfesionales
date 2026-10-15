
# Módulo: portafolio-docentes/shared

*Fecha de auditoría: 2026-09-09T14:35:27.061Z*

## Archivo: /src/modules/shared/queries/foto-persona.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         FOTO
     FROM
         UTNDB.RHU_TAB_PERSONAS
     WHERE
         CEDULA = :cedula
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/shared/queries/horas-modulares.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COUNT(MO.PLAN_HORAS_NUMERO) AS TOTAL
 FROM ACA_TAB_DETAL_HORARIO_MODULOS MO
 INNER JOIN ACA_TAB_CALENDARIOS_MAT_PENSUM MP ON
     MP.CICLO_ACAD_CODIGO = MO.CICLO_ACAD_CODIGO AND
     MP.DEPEN...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/shared/queries/horas-no-modulares.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COUNT(PLAN_HORAS_NUMERO) AS TOTAL
 FROM ACA_TAB_DETALLES_HORARIOS
 WHERE INST_CODIGO = :inst_codigo
     AND DEPEN_CODIGO = :depen_codigo
     AND MODA_ESTUD_CODIGO = :moda_estud_codigo
     ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.



---

## Actualización (Repositorio portafolio-estudiante)


# Módulo: portafolio-estudiante/shared

*Fecha de auditoría: 2026-09-09T14:35:27.178Z*

## Archivo: /src/modules/shared/queries/foto-persona.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
     SELECT
         FOTO
     FROM
         UTNDB.RHU_TAB_PERSONAS
     WHERE
         CEDULA = :cedula
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

