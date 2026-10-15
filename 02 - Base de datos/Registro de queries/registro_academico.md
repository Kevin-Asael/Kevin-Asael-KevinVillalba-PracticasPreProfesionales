
# Módulo: portafolio-estudiante/registro_academico

*Fecha de auditoría: 2026-09-09T14:35:27.174Z*

## Archivo: /src/modules/registro_academico/repository/consultas/aulas_virtuales_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     TAB_MAT_PENSUM.FECHA_INICIO || ' - ' || TAB_MAT_PENSUM.FECHA_FIN AS FECHAS,
     TAB_MATERIAS.CODIGO AS CODIGO_MATERIA,
     TAB_MATERIAS.DESCRIPCION || (
         SELECT
             DE...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/registro_academico/repository/consultas/ciclos_aula_virtual_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     DESCRIPCION,
     CICLO_ACAD_CODIGO
 FROM
 (
     SELECT
         CICLO.DESCRIPCION,
         MATRICULAS.CICLO_ACAD_CODIGO,
         CICLO.FECHA_FIN
     FROM
         UTNDB.ACA_TAB_MATR...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

