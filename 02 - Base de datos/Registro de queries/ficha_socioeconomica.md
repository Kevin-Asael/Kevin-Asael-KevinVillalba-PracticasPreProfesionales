
# Módulo: portafolio-estudiante/ficha_socioeconomica

*Fecha de auditoría: 2026-09-09T14:35:27.142Z*

- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
 FROM
    DBU_TAB_FICHA_SOCIOEC FS,
    ACA_TAB_MATRICULAS M
 WHERE
    FS.CI_PASAPORTE = M.ESTUDIANTE_CEDULA
    AND FS.COD_MATRICULA = M.CODIGO
    AND M....`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/ficha_socioeconomica/repository/consultas/info_ficha_consulta_dto.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
    CICLO,
    DEPEN_CODIGO,
    FECHA_MATRICULA AS lvarc3Ciclo,
    DEPEN_CODIGO AS lvarc2Dependencia,
    FECHA_MATRICULA AS lvarc2Fecha
 FROM
    (
         SELECT
             M.CICLO_ACA...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

