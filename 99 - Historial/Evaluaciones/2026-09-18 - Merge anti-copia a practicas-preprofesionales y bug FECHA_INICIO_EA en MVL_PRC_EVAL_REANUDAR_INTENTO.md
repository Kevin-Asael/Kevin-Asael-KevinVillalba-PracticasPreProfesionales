# 2026-09-18 — Merge de anti-copia a practicas-preprofesionales + bug en MVL_PRC_EVAL_REANUDAR_INTENTO

## Qué cambió

`utn-movil-portafolio-estudiante`: se fusionó `feature/anticopia-backend` (5 commits,
anti-copia en servidor + auto-cierre de intentos zombis + guardas NVL) dentro de
`practicas-preprofesionales`. Commit de merge: `bcacc09`.

Resultado:
- `EvaluacionOnlineModule` reactivado en `src/app.module.ts` (estaba comentado desde que se
  decidió sacar "Evaluación en Línea" de esta versión mientras se endurecía seguridad).
- Nueva query/método `VERIFICAR_PERTENENCIA_ACTIVIDAD_ALUMNO` / `verificarPertenencia()` —
  antes cualquier estudiante autenticado podía gastarle las alertas de anti-copia a otro
  cambiando el `idActividadAlumno` en la URL (esas rutas no cruzaban cédula).
- Guardas `NVL()` agregadas a `GET_FORMULARIO_BASE` y `GET_REGLAS_EVALUACION` en
  `evaluacion_online.queries.ts` — sin esto, una actividad con `LIM_TIEMPO_HORAS`/`LIMITE_TIEMPO`
  en `NULL` devolvía `FECHAFINISO = NULL`, la app nunca arrancaba el cronómetro, pero
  `/responder` sí empezaba a rechazar respuestas con 403 EXPIRADO (esa consulta ya tenía la
  guarda desde antes).
- Se conservaron (no se pisaron) las llamadas a los procedimientos PL/SQL ya migrados
  (`MOVIL_UTN.MVL_PRC_EVAL_*`) en vez de volver al SQL crudo que traía la rama de anti-copia,
  que había partido antes de esa migración.

Verificado tras el merge: `pnpm run build` limpio, `pnpm test -- evaluacion_online` → 91/91.

## El bug (verificado en vivo contra Oracle Dev)

`MOVIL_UTN.MVL_PRC_EVAL_REANUDAR_INTENTO` (el procedimiento que ya corre en
`practicas-preprofesionales` para `REANUDAR_INTENTO_ENTREGADO`) no resetea `FECHA_INICIO_EA`:

```sql
UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
SET ENTREGADO = 'NO', FECHA_FIN_EA = NULL, CALIFICACION = NULL,
    USUARIO_ACTUALIZACION = p_cuenta
WHERE ID_ACTIVIDAD_ALUMNO = p_id_actividad_alumno
  AND CEDULA_INTEGRANTE = p_cedula AND ENTREGADO = 'SI';
```

Consecuencia: al reanudar un intento, el nuevo intento hereda la hora de inicio del intento
anterior. Como `INICIAR_CRONOMETRO_EVALUACION` sólo corre cuando `FECHA_INICIO_EA IS NULL`, el
cronómetro nunca se reinicia — el intento nuevo nace con el límite de tiempo ya vencido (o casi),
y el estudiante puede recibir "el límite de tiempo ha expirado" antes de llegar a ver el
formulario.

Ya se había corregido exactamente este mismo bug en la versión SQL cruda equivalente (commit
`88daab1` de `feature/anticopia-backend`), pero el procedimiento PL/SQL en Oracle (que es lo que
corre hoy en `practicas-preprofesionales`, migrado por separado) no tenía el fix.

DDL preparado para aplicar en Toad, conectado a `MOVIL_UTN`:

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

procedimientos de escritura del módulo (`MVL_PRC_EVAL_INICIAR_CRONOMETRO`,
`MVL_PRC_EVAL_GUARDAR_RESPUESTA`, `MVL_PRC_EVAL_GUARDAR_RESPUESTA_EMPAREJAR`,
`MVL_PRC_EVAL_TOGGLE_RESPUESTA_MULTIPLE`) — los cuatro ya implementan correctamente el patrón
idempotente (desactivar fila `'A'` previa antes de insertar). Solo `REANUDAR_INTENTO` tenía el bug.

## Impacto

Bloquea a cualquier estudiante que reanude un intento de evaluación en línea — recibe el error de
tiempo expirado sin haber llegado a responder nada.

## Estado

**Pendiente.** El código ya está fusionado y committeado (`bcacc09`, sin push). Falta que el
usuario corra el `CREATE OR REPLACE PROCEDURE` de arriba en Toad — Claude no tiene permiso de
escritura en Oracle (el MCP de lectura solo admite `SELECT`/`WITH`).
