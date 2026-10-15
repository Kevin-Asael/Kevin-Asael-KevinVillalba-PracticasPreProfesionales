
# Módulo: portafolio-docentes/validacion_acceso

*Fecha de auditoría: 2026-09-09T14:35:27.072Z*

## Archivo: /src/modules/validacion_acceso/repository/consultas/validar_cedula_digital.consulta.ts
- **Línea aprox:** 17
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT TIENE_PENDIENTE 
 FROM MOVIL_UTN.MVL_VIEW_VALIDAR_CEDULA_DOC
 WHERE CEDULA = :cedula
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/validacion_acceso/repository/consultas/validar_foto_digital.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT TIENE_PENDIENTE
 FROM MOVIL_UTN.MVL_VW_VALIDAR_ACCESO_FOTO
 WHERE CEDULA = :1
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.



---

## Actualización (Repositorio portafolio-estudiante)


# Módulo: portafolio-estudiante/validacion_acceso

*Fecha de auditoría: 2026-09-09T14:35:27.185Z*

## Archivo: /src/modules/validacion_acceso/repository/consultas/validar_admision.consulta.ts
- **Línea aprox:** 15
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT CEDULA, FECHA_INICIO, FECHA_ACTUAL
 FROM MOVIL_UTN.MVL_VIEW_VALIDAR_ADMISION
 WHERE CEDULA = :cedula
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/validacion_acceso/repository/consultas/validar_cedula_digital.consulta.ts
- **Línea aprox:** 17
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT CEDULA 
 FROM MOVIL_UTN.MVL_VIEW_VALIDAR_ACCESO
 WHERE CEDULA = :cedula
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/validacion_acceso/repository/consultas/validar_documentos_pendientes.consulta.ts
- **Línea aprox:** 20
- **Tipo de operación:** OTRO
- **Fragmento:** `
 SELECT
     CEDULA,
     TIENE_PENDIENTE,
     CODIGO_PENDIENTE
 FROM MOVIL_UTN.MVL_VIEW_VALIDAR_DOCS_PEND
 WHERE CEDULA = :cedula
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/validacion_acceso/repository/consultas/validar_evaluacion_docente.consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT CUENTA, ES_EVALUADOR
   FROM MOVIL_UTN.MVL_VIEW_VALIDAR_EVA_DOC
  WHERE UPPER(CUENTA) = UPPER(:cuenta)
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/validacion_acceso/repository/consultas/validar_examen.consulta.ts
- **Línea aprox:** 15
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT CEDULA, TIENE_ACCESO
 FROM MOVIL_UTN.MVL_VIEW_VALIDAR_EXAMEN
 WHERE CEDULA = :cedula
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/validacion_acceso/repository/consultas/validar_facultad_postgrado.consulta.ts
- **Línea aprox:** 21
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT DISTINCT FAC.SIGLAS
 FROM ACA_TAB_MATRICULAS MATR
 INNER JOIN ACA_TAB_CICLOS_ACADEMICOS CA ON(CA.CODIGO=MATR.CICLO_ACAD_CODIGO)
 INNER JOIN ACA_TAB_DEPENDENCIAS CAR ON(CAR.CODIGO=MATR.DEPEN_C...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/validacion_acceso/repository/consultas/validar_ficha_socioeconomica.consulta.ts
- **Línea aprox:** 15
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     CEDULA, 
     TIENE_PENDIENTE
 FROM MOVIL_UTN.MVL_VIEW_VALIDAR_FICHA_SOCIO
 WHERE CEDULA = :cedula
 `
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

