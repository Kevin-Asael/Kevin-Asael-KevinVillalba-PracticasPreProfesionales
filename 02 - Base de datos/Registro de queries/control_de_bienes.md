
# Módulo: portafolio-docentes/control_de_bienes

*Fecha de auditoría: 2026-09-09T14:35:26.979Z*

## Archivo: /src/modules/control_de_bienes/repository/queries/foto-activo.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT FOTOGRAFIA, MIME, FILENAME FROM UTNDB.ACT_TAB_ACTIVOS
 WHERE CODIGO = :codActivo
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/control_de_bienes/repository/queries/lista-activos.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     ACTIVO_CODIGO,
     ACTIVO_NOMBRE,
     ACTIVO_OBSERVACION,
     ACTIVO_PRECIO_COMPRA,
     ACTIVO_FECHA_COMPRA,
     ACTIVO_CC_CODIGO,
     ACTIVO_CC_NOMBRE,
     ACTIVO_CEDULA_RESPONSA...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 38
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COUNT(*) AS TOTAL
 FROM MVL_VIEW_ACTIVOS_RESPONSABLE
 WHERE CUENTA_USUARIO = :cuenta
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

