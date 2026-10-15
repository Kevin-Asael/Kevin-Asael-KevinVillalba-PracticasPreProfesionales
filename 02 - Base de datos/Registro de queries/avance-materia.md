
# Módulo: portafolio-docentes/avance-materia

*Fecha de auditoría: 2026-09-09T14:35:26.950Z*

## Archivo: /src/modules/avance-materia/repository/queries/avance-select-query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT
     LEVEL,
     CASE 
         WHEN LEVEL = 1 THEN 'MATERIA' 
         WHEN LEVEL = 2 THEN 'UNIDAD' 
         WHEN LEVEL = 3 THEN 'CONTENIDO' 
     END AS TIPO_NODO,
     CONTENIDO AS NOMBRE...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/avance-materia/repository/queries/calendario-avance-query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT FECHA_CLASE,
        HORAS_DICTADAS
 FROM (
     SELECT FECHA_CLASE, 
            SUM(HORAS_DICTADAS) AS HORAS_DICTADAS
     FROM ACA_TAB_AVANCES_CURRICULARES
     WHERE INST_CODIGO = '001' 
...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/avance-materia/repository/queries/eliminar-avance-query.ts
- **Línea aprox:** 1
- **Tipo de operación:** DELETE
- **Fragmento:** `
 DELETE FROM ACA_TAB_AVANCES_CURRICULARES WHERE ROWID = :id
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/avance-materia/repository/queries/fecha-minima-registro-academico-query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT UTNDB.LMS_FUN_FECHA_AVANCE_ACTIVA(:P24_CICLO_ACAD_CODIGO, 
                                          :P24_MATERIA_CODIGO, 
                                          :P24_DOCENTE_CEDULA, 
    ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/avance-materia/repository/queries/horas-dictadas-hoy-query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
 UTNDB.LMS_FUN_HORAS_MATERIA_DIA(:P24_CICLO_ACAD_CODIGO,  :P24_MATERIA_CODIGO ,:P24_DEPEN_CODIGO,:P24_DOCENTE_CEDULA,
             '001',:P24_MODA_ESTUD_CODIGO,:P24_NIVEL_CODIGO,:P24_SIST_ES...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/avance-materia/repository/queries/procentajes_materia_query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     /* Porcentaje Planificado */
     CASE 
         WHEN TAB_DISTRIBUTIVOS.SIST_ESTUD_CODIGO NOT IN ('03')
          AND TAB_DISTRIBUTIVOS.NIVEL_CODIGO NOT IN ('NI')
          AND TAB_DIST...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/avance-materia/repository/queries/registro-avances-matera-query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
     AVA.ROWID AS ROWID_ELIMINAR,  
     AVA.CONTE_MATE_CODIGO,
     CON.ITEM || ' ' || CON.DESCRIPCION || ' (' || CON.HORAS_ITEM || 'h planificadas ' || CON.PORCENTAJE_ITEM || '%)' ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/avance-materia/repository/queries/seleccion-contenido.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
     AVA.ROWID AS ROWID_ELIMINAR,  -- Identificador único para eliminar
     AVA.CONTE_MATE_CODIGO,
     CON.ITEM || ' ' || CON.DESCRIPCION || ' (' || CON.HORAS_ITEM || 'h planificad...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/avance-materia/repository/queries/validar-avance-ciclo-query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT FECHA_FIN FROM ACA_TAB_CICLOS_ACADEMICOS WHERE CODIGO = :P24_CICLO_ACAD_CODIGO
  AND TO_DATE(:P24_FECHA_MINIMA, 'DD/MM/YYYY') BETWEEN FECHA_INICIO AND FECHA_FIN
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/avance-materia/repository/queries/validar-fecha-avance.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
   SELECT COUNT(*) as cantidad
   FROM ACA_TAB_DETALLES_HORARIOS
   WHERE INST_CODIGO = :INST_CODIGO
     AND DEPEN_CODIGO = :DEPEN_CODIGO
     AND MODA_ESTUD_CODIGO = :MODA_ESTUD_CODIGO
     AND SIS...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

- **Línea aprox:** 18
- **Tipo de operación:** SELECT
- **Fragmento:** `
   SELECT COUNT(*) as cantidad
   FROM ACA_TAB_DETAL_HORARIO_MODULOS
   WHERE INST_CODIGO = :INST_CODIGO
     AND DEPEN_CODIGO = :DEPEN_CODIGO
     AND MODA_ESTUD_CODIGO = :MODA_ESTUD_CODIGO
     AND...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

