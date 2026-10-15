
# Módulo: portafolio-docentes/horario-docente

*Fecha de auditoría: 2026-09-09T14:35:27.007Z*

## Archivo: /src/modules/horario-docente/repository/queries/ciclo-academico.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DESCRIPCION,CODIGO FROM(
 SELECT DISTINCT CIC.DESCRIPCION,CIC.CODIGO,CIC.FECHA_INICIO,CIC.FECHA_FIN
     FROM ACA_TAB_CICLOS_ACADEMICOS CIC
     INNER JOIN UTNDB.ACA_TAB_DISTRIBUTIVOS DIS ON(...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/horario-docente/repository/queries/horario.query.ts
- **Línea aprox:** 2
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT
     FECHA_INICIO,
     FECHA_FIN,
     CASE WHEN LENGTH(INICIO_HORA) = 4 THEN '0' || INICIO_HORA ELSE INICIO_HORA END AS INICIO_HORA,
     CASE WHEN LENGTH(FIN_HORA) = 4 THEN '0' || FIN_HORA...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

