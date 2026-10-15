# 2026-09-18 — Integración de correcciones y reanudación de intentos

El mecanismo de anti-copia ya existía con anterioridad. Este registro histórico describe correcciones de bugs durante el traslado de su control al backend y la integración con los procedimientos de evaluación existentes.

## Cambios registrados

Se integraron correcciones de validación de acceso, tratamiento de fechas nulas y cierre de intentos vencidos. Se conservaron las llamadas a los procedimientos PL/SQL ya migrados. El registro original informa un build correcto y **91/91** pruebas del módulo tras la integración.

## Error de reanudación

El procedimiento `MOVIL_UTN.MVL_PRC_EVAL_REANUDAR_INTENTO` no restablecía `FECHA_INICIO_EA`. El intento siguiente heredaba la hora inicial del anterior y podía aparecer vencido antes de responder.

Fragmento documentado del procedimiento anterior:

```sql
UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
SET ENTREGADO = 'NO', FECHA_FIN_EA = NULL, CALIFICACION = NULL,
    USUARIO_ACTUALIZACION = p_cuenta
WHERE ID_ACTIVIDAD_ALUMNO = p_id_actividad_alumno
  AND CEDULA_INTEGRANTE = p_cedula AND ENTREGADO = 'SI';
```

## Script de corrección preparado

El cambio añade el restablecimiento de la fecha de inicio. El script se conserva completo:

```sql
CREATE OR REPLACE PROCEDURE MOVIL_UTN.MVL_PRC_EVAL_REANUDAR_INTENTO (
    p_cuenta               IN VARCHAR2,
    p_id_actividad_alumno  IN NUMBER,
    p_cedula               IN VARCHAR2
) AS
BEGIN
    UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
    SET ENTREGADO = 'NO',
        FECHA_FIN_EA = NULL,
        FECHA_INICIO_EA = NULL,
        CALIFICACION = NULL,
        USUARIO_ACTUALIZACION = p_cuenta
    WHERE ID_ACTIVIDAD_ALUMNO = p_id_actividad_alumno
      AND CEDULA_INTEGRANTE = p_cedula
      AND ENTREGADO = 'SI';
END;
/
```

## Estado a la fecha del registro

El script estaba preparado y pendiente de aplicación por el responsable de base de datos. Esta nota conserva ese estado histórico; no acredita por sí sola el estado actual de Oracle ni de producción.
