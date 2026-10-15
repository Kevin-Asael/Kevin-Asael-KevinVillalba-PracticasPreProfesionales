
# Módulo: portafolio-docentes/documentos_directorio

*Fecha de auditoría: 2026-09-09T14:35:26.988Z*

## Archivo: /src/modules/documentos_directorio/repository/consulta/informacion_documento_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     NOMBRE_UNICO, 
     DIRECTORIO, 
     MIME_TYPE, 
     NOMBRE_ARCHIVO 
 FROM 
     UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO 
 WHERE 
     ID_DOCUMENTO_DIRECTORIO = :P272_ID_DOCUMENTO_DIRECTO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos_directorio/repository/consulta/obtener_archivo_blob_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     NOMBRE_UNICO, 
     DIRECTORIO, 
     MIME_TYPE, 
     NOMBRE_ARCHIVO, 
     MOVIL_UTN.MVL_FUN_OBTENER_DOC_DIR(DIRECTORIO, NOMBRE_UNICO) AS CONTENIDO_ARCHIVO
 FROM 
     UTNDB.DOC_TAB_D...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.



---

## Actualización (Repositorio portafolio-estudiante)


# Módulo: portafolio-estudiante/documentos_directorio

*Fecha de auditoría: 2026-09-09T14:35:27.123Z*

## Archivo: /src/modules/documentos_directorio/repository/consulta/informacion_documento_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     NOMBRE_UNICO, 
     DIRECTORIO, 
     MIME_TYPE, 
     NOMBRE_ARCHIVO 
 FROM 
     UTNDB.DOC_TAB_DOCUMENTOS_DIRECTORIO 
 WHERE 
     ID_DOCUMENTO_DIRECTORIO = :P272_ID_DOCUMENTO_DIRECTO...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

## Archivo: /src/modules/documentos_directorio/repository/consulta/obtener_archivo_blob_consulta.ts
- **Línea aprox:** 1
- **Tipo de operación:** SELECT
- **Fragmento:** `
 SELECT 
     NOMBRE_UNICO, 
     DIRECTORIO, 
     MIME_TYPE, 
     NOMBRE_ARCHIVO, 
     MVL_FUN_OBTENER_DOC_DIR(DIRECTORIO, NOMBRE_UNICO) AS CONTENIDO_ARCHIVO
 FROM 
     UTNDB.DOC_TAB_DOCUMENTOS_...`
- **Tablas/Vistas involucradas:** (Identificar según fragmento)
- **Contexto:** Posible query quemada (hardcoded) para revisión.

