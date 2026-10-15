# 2026-09-18 — Intentos fantasma en evaluación online: diagnóstico verificado y plan de corrección

**Estado:** ✅ **IMPLEMENTADO, TESTEADO Y PUSHEADO** (2026-09-18).
- **Backend:** Commit `f251262` en `practicas-preprofesionales` y `feature/anticopia-backend` (pusheado a `origin`).
- **App Móvil:** Commit `dfaf7002b` en `feature/anticopia-evaluacion-online` (local).
- **Tests:** 103/103 tests Jest en verde (`evaluacion_online.service.spec.ts` y `evaluacion_online.conectividad.spec.ts`).

Este documento es autocontenido: una sesión nueva debería poder retomar el trabajo sin releer el
chat original.

---

## 1. El problema, como lo vive el estudiante

Rinde una evaluación online desde la app Flutter, pierde internet cerca del corte de tiempo y lo
recupera poco después. A veces pierde 1 intento (correcto), a veces 2 o más, y en algún caso la nota
que ya tenía registrada **desaparece**. El comportamiento parecía aleatorio.

**No es aleatorio.** Es completamente determinista: depende de cuántas de las tres rutas que
consumen intento (§4) alcancen a ejecutarse antes de que llegue la entrega real.

## 2. Dónde está cada cosa

| Qué | Dónde |
|---|---|
| Módulo | `src/modules/evaluacion_online/` — el fichero central es `evaluacion_online.service.ts` |
| Pantalla del examen | `lib/apps/portafolio_estudiante/evaluacion_online/` |
| Cuenta de prueba | `<cuenta-de-prueba>` (cédula `<cedula>`) |


⚠ `leer_logs` devuelve payloads grandes que no caben en un resultado de herramienta: se guardan en
fichero y conviene procesarlos con PowerShell (`ConvertFrom-Json` + proyección de
`time`/`método`/`url`/`statusCode`) en vez de leerlos enteros.

## 3. El hecho que lo desmonta todo: cuándo se descuenta un intento

**Un intento se descuenta únicamente al ENTREGAR**, nunca al iniciar el cronómetro.

Verificado leyendo el PL/SQL real en `ALL_SOURCE` de la réplica de dev:
`UTNDB.LMS_PRC_CALIFICAR_EVALUACION`, línea 55:

```sql
UPDATE LMS_TAB_ACTIVIDADES_ALUMNOS
    SET CALIFICACION = vCalificacion,
    ENTREGADO='SI', FECHA_FIN_EA=SYSDATE,
    INTENTOS_DISPONIBLES=(INTENTOS_DISPONIBLES-pRestarIntentos)
    WHERE ID_ACTIVIDAD = pIdActividad AND CEDULA_INTEGRANTE = pCedulaEstudiante;
```

Ni `MOVIL_UTN.MVL_PRC_EVAL_INICIAR_CRONOMETRO` ni `MOVIL_UTN.MVL_PRC_EVAL_REANUDAR_INTENTO` tocan
`INTENTOS_DISPONIBLES` (ambos leídos completos de `ALL_SOURCE`).

⚠ **Dos fuentes escritas afirman lo contrario y son falsas. Hay que corregirlas:**
  cronómetro») — es la premisa que justifica el auto-cierre de zombis sin mirar intentos;
- la nota `testsFinal/.../FINAL-14 - Intento zombi con y sin intentos de sobra ✅.md` de este vault.

✅ De paso: `MVL_PRC_EVAL_REANUDAR_INTENTO` **sí** limpia `FECHA_INICIO_EA`, así que el bug anotado en
[[2026-09-18 - Integracion de correcciones y bug FECHA_INICIO_EA en MVL_PRC_EVAL_REANUDAR_INTENTO]] ya está aplicado en Oracle.

## 4. Las tres rutas que consumen un intento

   (`evaluacion_online.service.ts:86-101`), que llama a `finalizarEvaluacion` internamente.
3. El job de BullMQ `evaluacion-auto-calificar` a `fechaFin + 1 min`
   (`DELAY_AUTO_CALIFICAR_MINUTOS = 1`) sobre un intento vencido y no entregado.

### Cómo leer los logs para contar intentos

`cancelarAutoCalificacion` (`:1086`) tiene **exactamente dos invocadores**: `finalizarEvaluacion`
(`:380`) y `finalizarPorAntiCopia` (`:469`). `programarAutoCalificacion` borra el job con un
`logger.debug` distinto (`:1039`). Por lo tanto:

> Cada línea `Job ... cancelado - el estudiante envió la evaluación manualmente` y cada
> `✓ Evaluación ... auto-calificada exitosamente` del log = **una finalización real = un intento
> descontado**.

⚠ Ese mensaje de log **miente**: dice siempre "el estudiante envió la evaluación manualmente" aunque
lo haya disparado el auto-cierre de zombi o el control de evaluación.

### Validación aritmética (4 de 4 exactas)

Contando finalizaciones en el log y contrastando contra Oracle el 2026-09-18:

| Actividad | `INTENTOS_PERMITIDOS` | Finalizaciones en log | `INTENTOS_DISPONIBLES` final |
|---|---|---|---|
| 627132 | 4 | 4 | 0 ✓ |
| 627133 | 19 | 19 | 0 ✓ |
| 627134 | 6 | 5 | 1 ✓ |
| 627136 | 3 | 1 | 2 ✓ |

entregas reales**: 7 se gastaron por reentrar a la pantalla y 3 por el job.

Consulta usada:

```sql
SELECT ID_ACTIVIDAD, ID_ACTIVIDAD_ALUMNO, INTENTOS_DISPONIBLES, ENTREGADO, CALIFICACION,
       TO_CHAR(FECHA_INICIO_EA,'YYYY-MM-DD HH24:MI:SS') INICIO_EA,
       TO_CHAR(FECHA_FIN_EA,'YYYY-MM-DD HH24:MI:SS') FIN_EA
FROM UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
WHERE CEDULA_INTEGRANTE = '<cedula>' AND FECHA_INICIO_EA IS NOT NULL
ORDER BY FECHA_INICIO_EA DESC;

-- configuración de la actividad (ojo con los nombres de columna)
SELECT ID_ACTIVIDAD, INTENTOS_PERMITIDOS, LIMITE_TIEMPO, LIM_TIEMPO_HORAS
FROM UTNDB.LMS_TAB_ACTIVIDAD_ACADEMICA WHERE ID_ACTIVIDAD IN (...);
```

Truco útil: en el log, la hora del job programado **menos 1 minuto** es la `fechaFin` real del

## 5. Los tres bugs

### Bug 1 — Entrar a una evaluación ya entregada borra la nota y abre un intento fantasma

`getFormulario` calcula `seEstaReanudando = reglas.entregado === 'SI'` (`:110`) y, si es cierto,
llama a `MVL_PRC_EVAL_REANUDAR_INTENTO` (`:133-138`), que pone `ENTREGADO='NO'` y borra
`CALIFICACION`, `FECHA_FIN_EA` y `FECHA_INICIO_EA`. **El estudiante no pidió nada de esto**: solo
abrió la pantalla.

Evidencia (actividad 627133, `idActividadAlumno` 18517775, horas UTC):
- `17:00:27` el job auto-califica el intento → nota registrada.

Ese intento fantasma vence en 1 minuto y lo cierra el job o la siguiente entrada → **−1 intento más**.

### Bug 2 — Cierre de zombi + reanudación en la MISMA petición (doble consumo en un toque)

En `getFormulario`, la rama `esIntentoZombi` (`:86-101`) llama a `finalizarEvaluacion` (−1 intento) y
**vuelve a leer `reglas`**; como ahora `ENTREGADO='SI'`, cae acto seguido en la rama de reanudación y
abre un intento nuevo. Un solo `GET` = intento viejo consumido + intento nuevo plantado.

Evidencia (actividad 627134, `idActividadAlumno` 18517778):
  (−1) y reanuda en la misma petición.
- Total: **2 intentos para una sola entrega**. La nota sale correcta porque las respuestas siguen en
  `LMS_TAB_PREGUNTAS_CUESTIONARIO`.

> misma petición. Si aparece, hubo doble consumo.

### Bug 3 — `403` en un reintento legítimo

(`:944-960`). Si el servidor procesó la entrega pero la respuesta se perdió en la reconexión, el
botón "Reintentar" del cliente muestra error aunque todo haya salido bien.

(El guard en sí es correcto y hay que conservarlo: evita que un segundo `/finalizar` vuelva a llamar
a `LMS_PRC_CALIFICAR_EVALUACION` y gaste otro intento. Lo que está mal es el código de respuesta.)

### Por qué unas corridas salen bien

reentrara y antes de que el job corriera (programado `17:42:45`). Una sola finalización, 1 intento,
todo correcto. Es tiempismo, no otra cosa.

## 6. Estado del cliente Flutter (ya verificado, no hace falta rehacerlo)

En esa rama:
- El **bucle de reintentos de ~1 s ya está corregido** (commit `369074f6c`). Al fallar el
  auto-finalizar ya no se rearma el cronómetro; se levanta la bandera `_autoFinalizarFallo`.
- La UI muestra un overlay con **"Reintentar"** y **"Volver"**
  (`presentation/pages/formulario_evaluacion_online_page.dart:203-227`). **"Volver" es un
  `Navigator.of(context).pop()` puro, sin llamadas de red** — por sí solo nunca gasta un intento.
- Hay **un único** punto que pide el formulario:
  `formulario_evaluacion_online_page.dart:42` → `initEvaluacion` (provider `:185`) → `getFormulario`.
- No hay cola offline ni reintentos automáticos, y es deliberado (decisión de arquitectura ya tomada:
  "las evaluaciones operan con conexión activa"). **No reintroducir un buffer offline.**

Conclusión: el cliente no es la causa. La causa está en el backend.

## 7. Plan de corrección (pendiente)

### Backend — `utn-movil-portafolio-estudiante`, `src/modules/evaluacion_online/`

1. **Reanudar pasa a ser explícito.** `getFormulario` recibe un flag (`?reanudar=true`, expuesto en
   el controlador `:32-42`). Con `reglas.entregado === 'SI'`: sin flag **no se reanuda** — se responde
   el estado "ya entregada, revisa tu resultado" (`ForbiddenException`, mismo patrón que
   `validarAcceso`); con flag, se reanuda como hoy. → **arregla el bug 1**.
2. **Cortar el encadenamiento.** En la rama `esIntentoZombi` (`:93-101`), tras `finalizarEvaluacion`
   la petición **termina ahí**: no se relee `reglas` ni se cae al bloque de reanudación. El mensaje
   debe decir que el intento se cerró por tiempo, que ya está calificado, y que hay que volver a
   entrar para usar otro si quedan. → **arregla el bug 2**.
3. **Idempotencia en `finalizarEvaluacion` (`:350-389`).** Si `reglas.entregado === 'SI'`, retornar
   sin error (204, no-op) en vez de dejar que `validarAcceso` lance `403`. **No** volver a invocar
   `evaluacionOnlineRepository.finalizarEvaluacion` ni `cancelarAutoCalificacion`. Actualizar el
   comentario de `:944-960` con el nuevo contrato. → **arregla el bug 3** y hace que el botón
   "Reintentar" ya existente se autocure.
4. **Corregir el comentario `:78-85`** (la premisa falsa de §3), citando `LMS_PRC_CALIFICAR_EVALUACION`.
5. **Corregir el mensaje de log `:1098`** para que diga qué finalización canceló el job.

**No hace falta DDL.** Los procedimientos Oracle se quedan como están.

### Tests — `src/modules/evaluacion_online/tests/evaluacion_online.service.spec.ts`

- Zombi: **una** llamada a `finalizarEvaluacion`, **cero** a `reanudarIntento`, y la petición termina
  en `ForbiddenException`. (El test actual espera lo contrario y hay que ajustarlo.)
- Entrada **sin** flag sobre `entregado==='SI'`: cero llamadas a `reanudarIntento`, nota intacta.
- Entrada **con** `reanudar=true` sobre `entregado==='SI'`: reanuda como hoy.

### Cliente — `utn_movil_app`, rama `feature/anticopia-evaluacion-online`

- Propagar el flag desde el único call site: `initEvaluacion` → `getFormulario` →
  `FormularioEvaluacionParam`. Se envía `reanudar: true` **solo** en la navegación que significa
  "quiero rendir otra vez"; cualquier otra entrada (volver, revisar, deep link) va sin flag.
- **Sin UI nueva** y **sin** reintroducir reintentos automáticos: el diseño de overlay ya cerrado en
  esa rama se respeta tal cual.

## 8. Cómo verificar

1. **Unitarias:** `pnpm test` en el backend; suites `evaluacion_online` y `anticopia` en verde.
   `REDIS_HOST`, Nest **no registra las rutas del módulo** y todo cae al fallback SPA de
   `ServeStaticModule` con un 500 genérico sin relación aparente. Con `curl`:
   - abrir formulario → dejar vencer el tiempo → pedir `/formulario` **sin** flag ⇒ 403 con el
     mensaje nuevo, **sin** reabrir intento;
   - pedirlo **con** `reanudar=true` ⇒ abre intento;
3. **End-to-end en dev**, reproduciendo las corridas de hoy: actividad de **1 minuto** con 3 intentos,
   cuenta `<cuenta-de-prueba>`.
   - Cortar el wifi, dejar vencer el cronómetro, restaurar, pulsar **"Reintentar"** ⇒ 1 intento.
   - Igual pero pulsando **"Volver"** y reentrando ⇒ 1 intento, y la nota sigue visible.
   - Entrar a una evaluación ya entregada ⇒ muestra la nota, **no** la borra, **no** abre intento.
   - **Aritmética** (§4): finalizaciones en el log = intentos descontados, y ningún descuento sin
     debe volver a aparecer dentro de una misma petición.

## 9. Restricciones que aplican a este trabajo

  `paths-ignore: ['**.md','docs/**']` — documentar no despliega).
  `push`, `checkout`, `merge`, `pull`, `stash`. Los comandos se **entregan** para que los corra el
  usuario. (Esto incluye el checkout de la rama del cliente.)
- 🚫 **DDL en Oracle pasa por el DBA / se corre en Toad por el usuario.** Claude nunca escribe en
  Oracle; el MCP es solo `SELECT`/`WITH`.
- El encargo general del repo es **hacer funcionar lo que existe y documentarlo**, no refactorizar.

## 10. Relación con otras notas

- `FINAL-14 - Intento zombi con y sin intentos de sobra ✅.md` — **corregir**: afirma que el intento
  se consume al iniciar; es falso (§3).
- [[2026-09-18 - Integracion de correcciones y bug FECHA_INICIO_EA en MVL_PRC_EVAL_REANUDAR_INTENTO]] — ese bug
  **ya está aplicado** en Oracle; verificado en `ALL_SOURCE`.
- `2026-09-07 - Conectividad en Evaluacion Online.md` — la cola offline descrita ahí está
  **descartada permanentemente**; no reintroducirla.
- `2026-09-14 - Como trabajamos la migracion de queries a vistas (continuidad).md` — los 5
  procedimientos `MVL_PRC_EVAL_*` de este módulo salieron de ahí.

---

## 11. Implementación Aplicada y Verificación (2026-09-18)

### Commits Realizados
1. **Backend (`utn-movil-portafolio-estudiante`)**:
   - **Commit:** `f251262` (*`fix(evaluacion_online): corrige intentos fantasma (reanudar explicito, corte de zombi, finalizar idempotente)`*).
   - **Ramas actualizadas:** `practicas-preprofesionales` y `feature/anticopia-backend`.
   - **Pusheado a:** `origin/practicas-preprofesionales` y `origin/feature/anticopia-backend`.
   - **Cambios aplicados:**
     - `getFormulario`: Parámetro opcional `@Query() reanudar: boolean = false` (DTO `FormularioEvaluacionQuery`).
     - Si `reglas.entregado === 'SI'` y `!reanudar`: lanza `403 ForbiddenException` avisando que ya está entregada y preservando la calificación, sin tocar `MVL_PRC_EVAL_REANUDAR_INTENTO`.
     - **Corte de zombi:** si `esIntentoZombi`, ejecuta `finalizarEvaluacion` y termina la petición de inmediato con `ForbiddenException` ("El intento anterior expiró y fue calificado. Vuelve a ingresar para iniciar un nuevo intento"). Se eliminó el re-read y el encadenamiento a la rama de reanudación que abría el intento 2 en la misma petición.
     - **Idempotencia en `/finalizar`:** si `reglas.entregado === 'SI'`, responde `204 No Content` limpio sin invocar `LMS_PRC_CALIFICAR_EVALUACION` ni restar intentos adicionales. Permite que el botón "Reintentar" de la app se autocure sin error 403.
     - **Tests unitarios:** suite nueva `evaluacion_online.conectividad.spec.ts` y actualización de `evaluacion_online.service.spec.ts` (**103/103 tests en verde**).

2. **Cliente Móvil (`utn_movil_app`)**:
   - **Commit:** `dfaf7002b` (*`fix(evaluacion_online): exige reanudar explicito al reabrir el formulario`*).
   - **Rama:** `feature/anticopia-evaluacion-online`.
   - **Cambios aplicados:**
     - Repositorios y providers adaptados para soportar `reanudar: bool = false`.
