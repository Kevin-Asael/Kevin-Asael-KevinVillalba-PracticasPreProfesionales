
# Módulo: portafolio-estudiante/aula_virtual

*Fecha de auditoría: 2026-09-09T14:35:27.081Z*

## Archivo: /src/modules/aula_virtual/respository/aula_virtual_repository.ts
- **Línea aprox:** 36
- **Tipo de operación:** SELECT
- **Fragmento:** `SELECT UTNDB.LMS_FUN_PARCIAL_ACTIVA(:P110_ID_CURSO, :PARCIAL) AS ACTIVA FROM DUAL`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula_virtual/respository/consultas/asistencias_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT A.FECHA_ASISTENCIA, A.ASISTENCIA ||'h' AS "ASISTENCIA"
 FROM UTNDB.LMS_VIEW_ASISTENCIA_ESTUDIANTE A
 WHERE A.CICLO_ACAD_CODIGO =:P19_CICLO_ACAD_CODIGO
     AND A.MATERIA_CODIGO = :P19_MATERIA...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula_virtual/respository/consultas/avance_materia_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     ROUND(
         UTNDB.LMS_FUN_PORCENTAJE_EJECUTADO (
             :DOCENTE_CEDULA,
             :DEPEN_CODIGO,
             :CICLO_ACAD_CODIGO,
             :NIVEL_CODIGO,
             ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula_virtual/respository/consultas/calendario_actividades_aula_virtual_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     DISTINCT ACTIVIDAD.ID_ACTIVIDAD,
     ACTIVIDAD.NOMBRE_CORTO,
     ACTIVIDAD.FECHA_FIN,
     MATERIA.DESCRIPCION "MATERIA",
     ACT_ALUMNO.ENTREGADO,
     (
         CASE
             W...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula_virtual/respository/consultas/contenido_materia_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     LEVEL,
     CONTENIDO AS title,
     "CODIGO" AS VALUE
 FROM
     (
         SELECT
             DISTINCT TAB_TIPOS_CONTENIDOS.DESCRIPCION || ' ' || TAB_CONTENIDOS_MATERIAS.ITEM || '. ' ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula_virtual/respository/consultas/detalles_notas_parcial_1_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** UPDATE
- **Fragmento:** `
 SELECT
     LMS_TAB_ACTIVIDAD_ACADEMICA.ID_ACTIVIDAD,
     ACA_TAB_TIPOS_PORCENTAJE_EVAL.DESCRIPCION AS TIPO_ACTIVIDAD,
     LMS_TAB_ACTIVIDAD_ACADEMICA.NOMBRE_CORTO,
     LMS_TAB_ACTIVIDAD_ACADEMIC...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula_virtual/respository/consultas/detalles_notas_parcial_2_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** UPDATE
- **Fragmento:** `
 SELECT
     LMS_TAB_ACTIVIDAD_ACADEMICA.ID_ACTIVIDAD,
     ACA_TAB_TIPOS_PORCENTAJE_EVAL.DESCRIPCION AS TIPO_ACTIVIDAD,
     LMS_TAB_ACTIVIDAD_ACADEMICA.NOMBRE_CORTO,
     LMS_TAB_ACTIVIDAD_ACADEMIC...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula_virtual/respository/consultas/detalles_notas_parcial_3_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** UPDATE
- **Fragmento:** `
 SELECT
     LMS_TAB_ACTIVIDAD_ACADEMICA.ID_ACTIVIDAD,
     ACA_TAB_TIPOS_PORCENTAJE_EVAL.DESCRIPCION AS TIPO_ACTIVIDAD,
     LMS_TAB_ACTIVIDAD_ACADEMICA.NOMBRE_CORTO,
     LMS_TAB_ACTIVIDAD_ACADEMIC...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula_virtual/respository/consultas/distribucion_materia_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT CONTENIDO AS TEMA, PORCENTAJE_ITEM
   FROM (SELECT DISTINCT
                   TAB_TIPOS_CONTENIDOS.DESCRIPCION
                || ' '
                || TAB_CONTENIDOS_MATERIAS.ITEM...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula_virtual/respository/consultas/inasistencia_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     UTNDB.FUN_PORCENTAJE_INASISTENCIA(
         :DEPEN_CODIGO,
         :MATERIA_CODIGO,
         :NIVEL_CODIGO,
         :PARALELO_CODIGO,
         :CICLO_ACAD_CODIGO,
         :MODA_ESTUD...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula_virtual/respository/consultas/lista_actividades_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** UPDATE
- **Fragmento:** `
 SELECT
     LMS_TAB_ACTIVIDAD_ACADEMICA.ID_ACTIVIDAD,
     ACA_TAB_TIPOS_PORCENTAJE_EVAL.DESCRIPCION AS TIPO_ACTIVIDAD,
     LMS_TAB_ACTIVIDAD_ACADEMICA.NOMBRE_CORTO,
     LMS_TAB_ACTIVIDAD_ACADEMIC...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula_virtual/respository/consultas/lista_actividades_y_recursos_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** UPDATE
- **Fragmento:** `
 SELECT
     C.DESCRIPCION AS TEMA,
     ID_RECURSO,
     ID_ACTIVIDAD,
     TIPO_VISTA,
     FECHA,
     TIPO,
     R.DESCRIPCION,
     ID_CURSO,
     CONTENIDO,
     R.MATERIA_CODIGO,
     RESPONDE...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula_virtual/respository/consultas/nota_parcial_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     UTNDB.LMS_FUN_CALCULAR_PARCIAL(
         :idCurso,
         :cedula,
         :codigoParcial
     ) AS nota
 FROM
     DUAL
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/aula_virtual/respository/consultas/silabo_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
    (
       SELECT
          SUBSTR(valor, 1, LENGTH(valor) - 1) || '?'
       FROM
          INS_TAB_PARAMETROS
       WHERE
          CODIGO = '00002'
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

