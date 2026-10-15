# TIEM-05 — Subir mucho el límite de tiempo cierra el examen recién iniciado

**Fecha:** 2026-09-08 · **Tipo:** Cronómetro / Misterio sin explicar · **Severidad:** Alta
**Dónde:** app estudiante + backend `utn-movil-portafolio-estudiante`

⚠ **Este caso no tiene predicción firme.** Es el único síntoma de la tanda de pruebas del
2026-09-07 que quedó **sin explicación ni siquiera con una hipótesis fuerte**
(`07 - Documentacion/2026-09-07 - Investigacion abierta - reloj de Oracle...`, tabla §3, fila #4:
*"No encaja con el mecanismo [del desfase de 5h] en la dirección que predice"*). Se documenta
aquí como caso a reproducir, no como algo ya entendido.

## Precondiciones

- Poder crear una evaluación con un límite de tiempo **bastante más alto** de lo normal (por
  ejemplo, varias horas o el máximo de 24h + 59min permitido, ver
  [[CREA-01 - Crear con 0 horas 0 minutos]] para los rangos válidos).

## Pasos

1. Crear la evaluación con un límite de tiempo **alto** (ejemplo: `limTiempoHoras = 20`,
   `limiteTiempo = 0`).
2. Como estudiante, iniciar el examen.
3. Observar qué pasa **inmediatamente** después de iniciar — no esperar minutos, mirar en los
   primeros segundos.
4. **Muy importante para la investigación:** si el examen se cierra solo, anotar de inmediato el
   `idActividadAlumno` del intento (visible en los logs de red de la app) para poder correr la
   consulta SQL de verificación mientras el dato sigue fresco.

## Qué se sabe hasta ahora

Reproducido una vez con síntoma consistente: al subir bastante el límite de tiempo, **el examen
se cierra solo, recién empezado** — lo contrario de lo esperado (más margen, no menos).

Se descartó ya una hipótesis: que el problema fuera cómo el docente guarda la `FECHA_FIN` de la
actividad. Se revisó `formulario_editar_activiadad_docente_provider.dart:214,220` — la fecha se
formatea y envía en hora local tal cual, sin conversión a UTC de por medio. El desfase de Oracle
nace del lado del intento (`FECHA_INICIO_EA` vía `SYSDATE`), no de la actividad en sí — pero eso
no explica por qué un límite **alto** cerraría el examen **antes** que uno bajo.

**Hipótesis sin confirmar, a investigar si se reproduce:** en `GET_REGLAS_EVALUACION`
(`evaluacion_online.queries.ts:156-163`), `FECHAFINISO` se calcula con:

```sql
LEAST(act.FECHA_FIN, alu.FECHA_INICIO_EA + (LIM_TIEMPO_HORAS/24) + (LIMITE_TIEMPO/1440))
```

Con un límite de tiempo lo bastante alto, `alu.FECHA_INICIO_EA + límite` podría superar
`act.FECHA_FIN` (la fecha de cierre general de la actividad, fijada por el docente) — y
`LEAST()` elegiría **`act.FECHA_FIN`** en vez de la suma. Si `act.FECHA_FIN` resulta ser una
fecha ya pasada o muy próxima (por ejemplo, si el docente configuró una ventana general corta sin
darse cuenta de que el límite de tiempo del intento la iba a superar), el examen se cerraría de
inmediato — no por el límite de tiempo del intento, sino por el plazo general de la actividad.
**Esto es una hipótesis, no una confirmación** — falta correlacionar `act.FECHA_FIN` real de la
actividad de prueba contra el `FECHAFINISO` calculado del intento afectado.

## Pasos de verificación si se reproduce

```sql
SELECT act.FECHA_INICIO, act.FECHA_FIN, act.LIM_TIEMPO_HORAS, act.LIMITE_TIEMPO,
       alu.FECHA_INICIO_EA
FROM UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA act
JOIN UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS alu ON act.ID_ACTIVIDAD = alu.ID_ACTIVIDAD
WHERE alu.ID_ACTIVIDAD_ALUMNO = <id anotado en el paso 4>;
```

Comparar `act.FECHA_FIN` contra `alu.FECHA_INICIO_EA + límite` a mano: si `act.FECHA_FIN` es la
menor de las dos, confirma la hipótesis del `LEAST()`.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con la hipótesis
- [ ] No coincide / sigue sin explicación

## Relacionado

[[TIEM-01 - Pasan los 5 minutos configurados]] ·
`07 - Documentacion/2026-09-07 - Investigacion abierta - reloj de Oracle en evaluacion online.md`
(§3 fila #4, §5 punto 1 — el mismo caso, ahí queda como el frente abierto más urgente)
