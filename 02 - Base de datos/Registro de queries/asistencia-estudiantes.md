
# Módulo: portafolio-docentes/asistencia-estudiantes

*Fecha de auditoría: 2026-09-09T14:35:26.918Z*

## Archivo: /src/modules/asistencia-estudiantes/repository/queries/asistencia-docentes.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT
     EST.ESTUDIANTE_CEDULA AS cedula,
     P.PRIMER_APELLIDO || ' ' || P.SEGUNDO_APELLIDO AS apellidos,
     P.PRIMER_NOMBRE  || ' ' || P.SEGUNDO_NOMBRE   AS nombres,
     EST.NUMERO_MATRICUL...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/asistencia-estudiantes/repository/queries/asistencias-modular.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT
     EST.ESTUDIANTE_CEDULA AS cedula,
     P.PRIMER_APELLIDO || ' ' || P.SEGUNDO_APELLIDO AS apellidos,
     P.PRIMER_NOMBRE || ' ' || P.SEGUNDO_NOMBRE AS nombres,
     EST.NUMERO_MATRICULA A...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/asistencia-estudiantes/repository/queries/asistencias-registradas.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT A.FECHA_ASISTENCIA 
 FROM UTNDB.LMS_VIEW_ASISTENCIA_ESTUDIANTE A
 WHERE A.INST_CODIGO = :P38_INST_CODIGO
     AND A.DEPEN_CODIGO = :P38_DEPEN_CODIGO
     AND A.MODA_ESTUD_CODIGO =:P3...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/asistencia-estudiantes/repository/queries/calendario-asistencia.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     TAE.FECHA_ASISTENCIA AS fecha,
     JSON_ARRAYAGG(
         JSON_OBJECT(
             'idAsistencia' VALUE ROWNUM,
             'numEstudiantes' VALUE TAE.ESTUDIANTES,
             'esta...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/asistencia-estudiantes/repository/queries/datos-materia.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
     TAB_MATERIAS.DESCRIPCION AS MATERIA,
     FUN_OBTENER('ACA_TAB_NIVELES', 'DESCRIPCION', TAB_DISTRIBUTIVOS.NIVEL_CODIGO, NULL, NULL) AS "NIVEL",
     FUN_OBTENER('ACA_TAB_PARALEL...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/asistencia-estudiantes/repository/queries/fecha-minima-asistencia.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT UTNDB.LMS_FUN_FECHA_AVANCE_ACTIVA(:P38_CICLO_ACAD_CODIGO, 
                                          :P38_MATERIA_CODIGO, 
                                          :P38_DOCENTE_CEDULA, 
    ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/asistencia-estudiantes/repository/queries/horas-modulares.query.ts
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

## Archivo: /src/modules/asistencia-estudiantes/repository/queries/horas-no-modulares.query.ts
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

## Archivo: /src/modules/asistencia-estudiantes/repository/queries/lista-estudiantes-ver.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT A.CEDULA,NOMBRES(A.CEDULA) AS "NOMBRES",A.NUMERO_MATRICULA,A.ASISTENCIA ||'h' AS "ASISTENCIA"
 FROM UTNDB.LMS_VIEW_ASISTENCIA_ESTUDIANTE A
 INNER JOIN RHU_TAB_PERSONAS P ON(P.CEDULA=A.CEDULA)...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/asistencia-estudiantes/repository/queries/PL-SQL/consultar-asistencias.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 DECLARE
    v_horasNoModulares NUMBER := :horasNoModulares;  -- Se recibe desde el binding
    v_horasModulares   NUMBER := :horasModulares;    -- Se recibe desde el binding
    v_instCodigo       V...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/asistencia-estudiantes/repository/queries/validar-ciclo-actual.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT CODIGO FROM UTNDB.ACA_TAB_CICLOS_ACADEMICOS 
 WHERE CODIGO = :P38_CICLO_ACAD_CODIGO 
 AND ESTADO = 'A'
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/asistencia-estudiantes/repository/queries/validar-ciclo-inactivo.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT CODIGO FROM ACA_TAB_CICLOS_ACADEMICOS 
 WHERE CODIGO = :P38_CICLO_ACAD_CODIGO AND ESTADO <> 'A'
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/asistencia-estudiantes/repository/queries/validar-feriado.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT COUNT(*) AS TOTAL
 FROM ACA_TAB_CALENDARIOS
 WHERE DEPEN_CODIGO = '00000'
     AND TO_DATE(:fechaAsistencia, 'DD/MM/YYYY') BETWEEN FECHA_INICIO AND FECHA_FIN
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/asistencia-estudiantes/repository/queries/validar-listado-asistencias.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT ROWNUM
      FROM ACA_TAB_ASISTENCIAS_ESTUDIANTE
     WHERE :P38_FECHA_ASIS_ESTU IS NOT NULL    
           AND INST_CODIGO = :P38_INST_CODIGO
           AND DEPEN_CODIGO = :P38_DEPEN_CODIGO
...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/asistencia-estudiantes/repository/queries/validar-seleccion-fecha.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 select 1 from dual where LMS_FUN_HABILITA_CREAR_AULA(:P38_DOCENTE_CEDULA      ,
                                    :P38_DEPEN_CODIGO        ,
                                    :P38_CICLO_ACAD_COD...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

