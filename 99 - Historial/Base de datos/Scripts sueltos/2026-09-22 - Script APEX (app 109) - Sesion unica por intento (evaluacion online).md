# Script APEX (app 109) — sesión única por intento (evaluación online) — 2026-09-22

**Estado:** especificación para el ing/DDTI. **No implementado desde acá** — no hay acceso de
edición a la app 109 ni se pudo leer su metadata de páginas desde el MCP de solo lectura.
Complementa [[2026-09-22 - Script Oracle UTNDB - Sesion unica por intento (evaluacion online)]],
que sí es un script para el DBA.

## Contexto

Mismo hallazgo y diseño que la nota del script de Oracle: web (APEX) y app móvil comparten la misma
fila de `UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS` sin ningún control de sesión. El backend móvil
(`utn-movil-portafolio-estudiante`) ya está implementado contra `UTNDB.LMS_PRC_EVAL_TOMAR_SESION`
(el procedimiento del script de Oracle). Falta este lado — sin él, la sesión única sólo funciona en
una dirección.

**⚠ Supuesto sin verificar, condiciona todo lo de abajo:** que la página de APEX 109 ya escribe en
`LMS_TAB_ACTIVIDADES_ALUMNOS` a través de procedimientos de `UTNDB` (igual que hace para calificar),
no con DML directo desde la página. Confirmar con el equipo responsable dar esto por sentado.

## Las tres piezas (página de "rendir evaluación", app 109)

### 1. Tomar la sesión al entrar

Page Process, punto **"After Header"** (página ya cargada, antes de pintar las preguntas), PL/SQL:

```plsql
UTNDB.LMS_PRC_EVAL_TOMAR_SESION(
    p_id_actividad_alumno => :P_ID_ACTIVIDAD_ALUMNO,
    p_cedula              => :P_CEDULA,
    p_canal               => 'WEB',
    p_cuenta              => :APP_USER,
    p_token               => :P_SESION_TOKEN
);
```

`:P_SESION_TOKEN` debe ser un **Page Item** con *session state protected* — si no, se pierde en el
siguiente postback y la página se invalidaría a sí misma en cada guardado.

### 2. Chequear antes de cada guardado

Al principio de los procesos que ya existen para guardar una respuesta y para finalizar (antes de
su lógica actual):

```plsql
DECLARE
  v_token UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS.SESION_EA_TOKEN%TYPE;
BEGIN
  SELECT SESION_EA_TOKEN INTO v_token
    FROM UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
   WHERE ID_ACTIVIDAD_ALUMNO = :P_ID_ACTIVIDAD_ALUMNO;

  IF v_token IS NOT NULL AND v_token != :P_SESION_TOKEN THEN
    RAISE_APPLICATION_ERROR(-20201, 'Esta evaluación se abrió en otro dispositivo.');
  END IF;
END;
```

Un `RAISE_APPLICATION_ERROR` en un Page Process de APEX ya interrumpe el guardado y lo muestra como
error de página — no hace falta nada más para bloquear.

### 3. Cerrar la pantalla sin esperar al siguiente guardado (recomendado, no imprescindible)

Dynamic Action con Timer cada ~15-20 s que dispare una PL/SQL Ajax Callback con el mismo `SELECT`
de arriba; si no coincide, `apex.navigation.redirect` a la lista. Sin esto, la pantalla desplazada
queda visible sin funcionar hasta el próximo intento de guardado, en vez de cerrarse sola.

## Qué pasa si esto NO se implementa

Sólo funciona la dirección app→web: abrir en el celular saca a la web en su siguiente guardado,

## Pendiente

- Confirmar con el equipo responsable de arriba (procedimientos de `UTNDB` vs. DML directo).
- Coordinar con el DBA que `UTNDB.LMS_PRC_EVAL_TOMAR_SESION` ya exista (script de Oracle) antes de
  que APEX intente llamarlo.
- No probado en vivo: el log de acceso de APEX en la réplica de dev está congelado desde
  2026-01-30, no hay web viva contra la que probar esto en el entorno actual.
