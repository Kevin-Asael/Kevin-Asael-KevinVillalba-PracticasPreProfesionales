# FINAL-14 — Intento zombi con y sin intentos de sobra

> ⚠️ **Corrección 2026-09-18 — 📦 Histórico, comportamiento SUPERADO.** Esta nota describía y daba
> por bueno que, tras auto-cerrar un intento zombi, `getFormulario` **reanudara solo en la misma
> petición** (parte A: "entra a la rama de reanudación... cronómetro fresco"). Eso resultó ser el
> plantaba uno nuevo sin que el estudiante lo pidiera. Diagnóstico completo, con evidencia de log,
> en `07 - Documentacion/2026-09-18 - Intentos fantasma en evaluacion online - diagnostico
> verificado y plan de corrección.md`.
>
> También era **falsa** la premisa del punto 1 de "Resultado según el código": `INTENTOS_DISPONIBLES`
> **no** baja al arrancar el cronómetro — sólo baja al ENTREGAR, en el mismo `UPDATE` de
> `UTNDB.LMS_PRC_CALIFICAR_EVALUACION:55` que pone `ENTREGADO='SI'`. Verificado leyendo el
> `ALL_SOURCE` real.
>
> **Comportamiento corregido hoy** (`evaluacion_online.service.ts`, mismo repo): cerrar el zombi
> ahora **corta ahí** — responde `403` ("el intento anterior se cerró por tiempo... vuelve a
> ingresar") y NO reanuda en la misma petición. La parte B (sin intentos de sobra) sigue
> terminando en `403`, pero ahora con ese mismo mensaje de corte, no con "sin intentos disponibles"
> (ese mensaje sólo aparece si, en una petición posterior, el estudiante pide explícitamente
> `?reanudar=true` y ya no le quedan). Los pasos de reproducción de abajo siguen sirviendo para
> confirmar el auto-cierre; el **resultado esperado en el paso 4 cambió** (ver nota de arriba).

**Fecha:** 2026-09-11 · **Tipo:** Multi-intento / Backend · **Severidad:** Crítica
**Dónde:** backend NestJS (`utn-movil-portafolio-estudiante`) + app Flutter (`utn_movil_app`)

Verifica que un intento que se quedó "zombi" (el cronómetro venció pero nunca se marcó como
entregado — crash, cierre forzado, fallo de red al finalizar) se cierre solo y deje al estudiante
seguir, en vez de bloquearlo para siempre con el mensaje confuso de "tiempo expirado".

> ✅ **Ya verificado en vivo el 2026-09-11** contra `idActividadAlumno: 18516376` — con
> `entregado='NO'` y `estadoActividad='NLT'` de un intento vencido sin cerrar, `GET
> /evaluacion-online/:id/formulario` pasó de `403` a `200 OK` con cronómetro fresco tras el fix.
> Esta nota queda para que quede el registro y cualquiera pueda repetirlo desde cero en el
> celular.

## Precondiciones — parte A (con intentos de sobra)

- Evaluación con **2 o más intentos permitidos**.

## Pasos — parte A

1. Iniciar el intento 1, responder algo, y **matar la app** (quitarla de recientes, no tocar
   "Finalizar") — simula un crash real.
2. Esperar a que pase el tiempo límite del intento sin reabrir la app.
3. Reabrir la app y volver a entrar a la misma evaluación.
4. **Esperado:** debe dejar iniciar el **intento 2** con el cronómetro completo — NO debe
   bloquear con *"El límite de tiempo ha expirado. Usted inició esta actividad el..."*.

## Precondiciones — parte B (sin intentos de sobra)

- Evaluación con **1 solo intento permitido**.

## Pasos — parte B

5. Repetir el mismo crash (iniciar, responder algo, matar la app, esperar a que venza).
6. Reabrir y volver a entrar.
7. **Esperado:** debe bloquear, pero con el mensaje claro **"No tienes más intentos disponibles
   para esta evaluación."** — no con el mensaje confuso de tiempo expirado.

## Resultado según el código

Dos fixes encadenados, ambos en `getFormulario` (`evaluacion_online.service.ts`):

1. **Auto-cierre del zombi** (líneas 73-105): si `entregado !== 'SI'`, `fechaInicioEA !== null`, y
   `fechaFinISO` ya venció, llama a `this.finalizarEvaluacion(...)` (reutiliza el candado de
   concurrencia de [[FINAL-13 - Doble tap en Finalizar ✅]]) y vuelve a leer las reglas frescas.
   ya baja a 0 apenas arranca el cronómetro, así que exigirlo dejaba el zombi atascado para
   siempre.
2. **`permitirTiempoExpirado` al reanudar** (línea 128): tras cerrar el zombi, Oracle
   (`LMS_FUN_ACTIVIDAD_ACTIVA`) puede seguir reportando `estadoActividad='NLT'` para la fila
   vieja — sin este flag, `validarAcceso` bloqueaba la reanudación con el mismo mensaje confuso
   aunque el estudiante ya tenía vía libre. Sólo perdona el código `'NLT'` específicamente; otros
   bloqueos (reprobado por faltas, etc.) siguen intactos.
3. En la parte A, tras el auto-cierre, `reglas.entregado` pasa a `'SI'` → entra a la rama de
   reanudación (`reanudarIntento` + `antiCopiaService.limpiar` + `iniciarCronometro`) → cronómetro
   fresco.
4. En la parte B, tras el auto-cierre, `validarAcceso` con `esEntradaPrincipal` revisa
   `intentosDisponibles <= 0` (que ya sería el caso) y bloquea con el mensaje correcto — sin llegar
   nunca a intentar reanudar.

**Puntos clave a comprobar:**
- [x] Parte A: intento 2 arranca limpio, con el cronómetro completo.
- [x] Parte B: bloquea con "No tienes más intentos disponibles", no con "tiempo ha expirado".

## Observación — qué pasó de verdad

> Ahora si coincide los intentos.

## Estado

✅ Coincide con el código (validado).


## Relacionado

[[FINAL-07 - Segundo intento de evaluacion limpia (Multi-intento) ✅]] ·
[[FINAL-13 - Doble tap en Finalizar ✅]]
