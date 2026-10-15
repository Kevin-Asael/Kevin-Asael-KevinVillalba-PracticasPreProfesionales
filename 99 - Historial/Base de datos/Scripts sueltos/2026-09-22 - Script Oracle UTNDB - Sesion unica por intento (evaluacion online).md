# Script Oracle UTNDB — sesión única por intento (evaluación online) — 2026-09-22

**Estado:** pendiente de que el DBA lo aplique. Backend (`utn-movil-portafolio-estudiante`) ya
implementado en el working tree contra este contrato, **sin commitear ni pushear** — ver
la nota del backend de sesión única (no se llegó a crear) (nota de implementación,
crear si no existe todavía en `07 - Documentacion`).

## Por qué

Si un estudiante abre una evaluación online en la web (Oracle APEX, app 109) y luego la abre en la
app móvil, hoy las dos pueden responder a la vez: comparten la misma fila de
`UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS` y las mismas respuestas en `LMS_TAB_RESPUESTAS_ESTUDIANTE`, sin
ningún control. Decisión del usuario: columnas en `LMS_TAB_ACTIVIDADES_ALUMNOS` (idea original del
falta ventana de tolerancia ni decidir empates de segundo).

Diseño completo (incluye la especificación para APEX, que no se implementa desde aquí — no hay
acceso de edición a la app 109) en la sesión que originó este cambio.

## El script

```sql
ALTER TABLE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
    ADD (SESION_EA_TOKEN VARCHAR2(64), SESION_EA_FECHA DATE);

CREATE OR REPLACE PROCEDURE UTNDB.LMS_PRC_EVAL_TOMAR_SESION(
    p_id_actividad_alumno IN  NUMBER,
    p_cedula              IN  VARCHAR2,
    p_canal               IN  VARCHAR2,
    p_cuenta              IN  VARCHAR2,
    p_token               OUT VARCHAR2
) AS
BEGIN
    p_token := p_canal || '-' || SYS_GUID();

    UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
       SET SESION_EA_TOKEN = p_token,
           SESION_EA_FECHA = SYSDATE,
           USUARIO_ACTUALIZACION = p_cuenta
     WHERE ID_ACTIVIDAD_ALUMNO = p_id_actividad_alumno
       AND CEDULA_INTEGRANTE = p_cedula;
END LMS_PRC_EVAL_TOMAR_SESION;
/

```

justamente para que los dos formen el mismo formato y el backend pueda derivar el canal leyendo el
prefijo (`canalDeToken()` en `evaluacion_online.service.ts`), sin columna aparte.

El orden de los parámetros IN coincide exactamente con el bind posicional que ya usa el backend
(`TOMAR_SESION_EVALUACION` en `evaluacion_online.queries.ts`): idActividadAlumno, cédula, canal,
backend rompe en silencio (bind posicional, no por nombre — ver el invariante de la plataforma).

## Antes de correrlo — verificar

- **Confirmar con el el ingeniero página de APEX 109 también pasa por procedimientos de `UTNDB` para
  escribir en esta tabla** (igual que hace con la calificación). No se verificó leyendo su código —
  sin acceso de edición a esa app ni a su metadata de páginas desde el MCP de solo lectura.
- Revisar que `LMS_TRG_ACTIVIDADES_ALUMNOS` no se dispare por estas dos columnas nuevas — el trigger
  existente sólo mira `CALIFICACION`/`DESCRIPCION`/`URL`/`ADJUNTO`/`ID_DOCUMENTO`, así que en
  principio no debería afectar intentos, pero conviene que el DBA lo confirme en el objeto real.
  sobre `LMS_PRC_CALIFICAR_EVALUACION`) — si ya existe, es un no-op.

## Verificación después de aplicarlo

1. `describir_tabla` (MCP de solo lectura) confirma las dos columnas nuevas.
2. `ALL_SOURCE`/`listar_objetos` confirma el procedimiento y su firma.
3. Secuencia de prueba con cuenta estándar `<cuenta-de-prueba>`: abrir dos veces seguidas la misma
   evaluación (simulando dos canales) y comprobar en Oracle que `SESION_EA_TOKEN` y
   `SESION_EA_FECHA` cambian con cada apertura, y solo con eso — ninguna otra escritura (guardar
   respuesta, finalizar, el auto-cierre de zombis) debe tocarlas.

## Pendiente

- Aplicar en la réplica de dev primero. Producción no se toca (regla de la plataforma).
- Cliente Flutter (`utn_movil_app`) y la especificación de APEX quedaron fuera de este script — son
  cambios aparte, todavía no implementados.
