
# Módulo: portafolio-docentes/pagos

*Fecha de auditoría: 2026-09-09T14:35:27.010Z*

## Archivo: /src/modules/pagos/repository/queries/pagos-por-transacciones.query.ts
- **Línea aprox:** 3
- **Tipo de operación:** SELECT
- **Fragmento:** `
 WITH transacciones_pag AS (
     SELECT DISTINCT NRO_TRANSACCION, FECHA_EMITE
     FROM MVL_VIEW_PAGOS_TRANSACCIONES
     WHERE PERSONA_CEDULA = :cedula
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 22
- **Tipo de operación:** OTRO
- **Fragmento:** `
     ORDER BY FECHA_EMITE DESC
     OFFSET :skip ROWS FETCH NEXT :limit ROWS ONLY
 )
 SELECT
     V.FECHA_EMITE,
     V.FECHA_CANJEA,
     V.NRO_DOCUMENTO,
     V.DESCRIPCION_ESTADO,
     V.DESCRIPCI...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 45
- **Tipo de operación:** OTRO
- **Fragmento:** `
     ORDER BY FECHA_EMITE ASC
     OFFSET :skip ROWS FETCH NEXT :limit ROWS ONLY
 )
 SELECT
     V.FECHA_EMITE,
     V.FECHA_CANJEA,
     V.NRO_DOCUMENTO,
     V.DESCRIPCION_ESTADO,
     V.DESCRIPCIO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 70
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COUNT(DISTINCT NRO_TRANSACCION) AS TOTAL
 FROM MVL_VIEW_PAGOS_TRANSACCIONES
 WHERE PERSONA_CEDULA = :cedula
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/pagos/repository/queries/pagos.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
     V.FECHA_EMITE,
     V.FECHA_CANJEA,
     V.NRO_DOCUMENTO,
     V.DESCRIPCION_ESTADO,
     V.DESCRIPCION_CONCEPTO,
     V.CANTIDAD,
     V.VALOR_CONCEPTO,
     V.SUBTOTAL,
     V...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.



---

## Actualización (Repositorio portafolio-estudiante)


# Módulo: portafolio-estudiante/pagos

*Fecha de auditoría: 2026-09-09T14:35:27.168Z*

## Archivo: /src/modules/pagos/repository/consultas/get_pagos_estudiante_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 WITH transacciones_agrupadas AS (
     SELECT
         V.NRO_TRANSACCION,
         MAX(V.FECHA_EMITE) as FECHA_EMITE,
         MAX(V.FECHA_CANJEA) as FECHA_CANJEA,
         MAX(V.NRO_DOCUMENTO) as N...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

