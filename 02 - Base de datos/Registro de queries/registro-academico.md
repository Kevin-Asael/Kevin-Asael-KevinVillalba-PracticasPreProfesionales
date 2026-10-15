
# Módulo: portafolio-docentes/registro-academico

*Fecha de auditoría: 2026-09-09T14:35:27.047Z*

## Archivo: /src/modules/registro-academico/repository/queries/ciclo-academico-registro-academico.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DESCRIPCION,CODIGO FROM(
     SELECT DISTINCT DESCRIPCION,CODIGO,FECHA_INICIO,FECHA_FIN FROM(
 SELECT DISTINCT CIC.DESCRIPCION,CIC.CODIGO,CIC.FECHA_INICIO,CIC.FECHA_FIN
     FROM ACA_TAB_CICL...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/registro-academico/repository/queries/detalle-materia-notas.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT
          TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
          INS_PCK_GENERAL.FUN_NOMBRES_PERSONA(TAB_DISTRIBUTIVOS.DOCENTE_CEDULA) AS "NOMBRES",
          FUN_OBTENER('ACA_TAB_CICLOS_ACADEM...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/registro-academico/repository/queries/documento-notas-estudiantes.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     (SELECT SUBSTR(valor, 1, LENGTH(valor) - 1) || '?' 
      FROM INS_TAB_PARAMETROS 
      WHERE CODIGO = '00002') 
      || ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/registro-academico/repository/queries/estudiantes-materia.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     (P.PRIMER_APELLIDO || ' ' || P.SEGUNDO_APELLIDO) AS APELLIDOS,
     (P.PRIMER_NOMBRE   || ' ' || P.SEGUNDO_NOMBRE)  AS NOMBRES,
     P.EMAIL,
     CI.CORREO_INSTITUCIONAL,
     P.CELULA...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/registro-academico/repository/queries/lista-estudiantes-foto.query.ts
- **Línea aprox:** 8
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     P.CEDULA AS "CEDULA",
     INS_PCK_GENERAL.FUN_NOMBRES_PERSONA(P.CEDULA) AS "NOMBRES",
     CASE WHEN P.FOTO IS NOT NULL AND DBMS_LOB.GETLENGTH(P.FOTO) > 0
          THEN 1 ELSE 0 END AS...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/registro-academico/repository/queries/notas-general-estudiantes.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     ACA_TAB_NOTAS.ESTUDIANTE_CEDULA AS CEDULA,
     (TAB_PERSONAS.PRIMER_APELLIDO || ' ' || TAB_PERSONAS.SEGUNDO_APELLIDO) AS APELLIDOS,
     (TAB_PERSONAS.PRIMER_NOMBRE || ' ' || TAB_PERSO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/registro-academico/repository/queries/registro-academico.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
   SELECT DISTINCT
     TAB_AULAS.ID_CURSO,
     TAB_DISTRIBUTIVOS.DOCENTE_CEDULA,
     TAB_DISTRIBUTIVOS.INST_CODIGO,
     TAB_DISTRIBUTIVOS.MODA_ESTUD_CODIGO,
     TAB_DISTRIBUTIVOS.SIST_ESTUD_CODI...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/registro-academico/repository/queries/validar-estado-aula-virtual.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT 
         CASE  
             WHEN TAB_AULAS.ID_CURSO IS NULL OR TAB_AULAS.ID_CURSO = '' THEN    
                 CASE 
                     WHEN UTNDB.LMS_FUN_HABILITA_CREAR_AULA(
     ...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/registro-academico/repository/queries/validar-materia-activa.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
     SELECT CODIGO FROM UTNDB.ACA_TAB_MATERIAS
     WHERE CODIGO = :codigo_materia
     AND ESTADO = 'A'
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/registro-academico/repository/queries/validar_acceso_asistencias.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT * FROM DUAL WHERE :P12_CICLO_ACADEMICO1 LIKE '%V'
 OR :P12_CICLO_ACADEMICO2 in ('0320-0820','0420-0820')
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/registro-academico/repository/queries/validar_visibilidad_porcentajes.query.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
   SELECT 1 
   FROM DUAL
   WHERE :cicloAcademico1 LIKE '%V'
   OR :cicloAcademico2 IN ('0320-0820', '0420-0820')
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

