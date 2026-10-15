# CREA-01 — Crear con 0 horas 0 minutos

**Fecha:** 2026-09-08 · **Tipo:** Creación / Validación · **Severidad:** Crítica
**Dónde:** Portafolio Docente (`utn-movil-portafolio-docentes`) → app Flutter, lado estudiante

Comprueba la configuración de una evaluación con duración cero. El caso de cinco minutos está en [[TIEM-01 - Pasan los 5 minutos configurados]].

## Precondiciones

- Un curso y un parcial activo (`LMS_FUN_PARCIAL_ACTIVA = 'T'`) donde se pueda crear una
  actividad de prueba.

## Pasos

1. Como docente, crear una nueva actividad tipo **Evaluación en Línea** (`tipoActividad = 2`).
2. Completar los campos obligatorios normales (nombre, fechas, parcial, tipo de evaluación).
3. En **Límite de tiempo**, dejar explícitamente **0 horas** y **0 minutos**.
4. Guardar. Observar si la actividad se crea sin errores.
5. Sortear o asignar al menos una pregunta.
6. Como estudiante, entrar a rendir esa evaluación y observar el cronómetro.

## Resultado según el código

**Se acepta sin ningún error.** `limiteTiempo` y `limTiempoHoras` sólo son obligatorios como
*string no vacío* — el `@IsNotEmpty` de ambos campos está **comentado** en el DTO
(`crear-actividad.request.ts`: `// @IsNotEmpty(...) limiteTiempo` y lo mismo para
`limTiempoHoras`, quedan como `@IsOptional`). El rango sí se valida
(`actividad.service.ts:455-483`, `validateNumeroInRange`), pero el mínimo permitido es **0** en
ambos: `0 y 59` para minutos, `0 y 24` para horas. `"0"` pasa las dos comprobaciones sin problema.

**Consecuencia del lado del estudiante — bug ya documentado en el propio código del backend
estudiante:**

```
// evaluacion_online.queries.ts:140-147 (comentario TODO del propio repo)
```
`GET_REGLAS_EVALUACION` y `GET_FORMULARIO_BASE` calculan `FECHAFINISO` **sin** guarda `NVL`
(`:156-163`), a diferencia de `GET_REGLAS_EVALUACION_RESPONDER`, que sí la tiene
(`:182-189`, con la guarda explícita `WHEN NVL(LIM_TIEMPO_HORAS,0)=0 AND
NVL(LIMITE_TIEMPO,0)=0 THEN act.FECHA_FIN`). Con `0` en ambos campos, en Oracle
que en teoría no debería dispararse el bug del `NVL`... pero conviene confirmar en vivo qué valor
llega realmente: si el backend guarda `0` como número o como `NULL` cuando el campo llega vacío
en algún punto del flujo es lo que hay que verificar, porque el comentario del propio código
advierte del caso `NULL`, no necesariamente del caso `0` explícito.

**Lo que sí se puede predecir con más seguridad:** con el límite en 0, `FECHA_INICIO_EA + 0 + 0 =
FECHA_INICIO_EA` — la fecha límite calculada es *igual* a la fecha de inicio. El cronómetro en el
restante ≈ 0 desde el primer tick y auto-finalizar casi de inmediato.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con el código
- [ ] No coincide

## Relacionado

[[TIEM-01 - Pasan los 5 minutos configurados]] (lote 3, mismo mecanismo con un valor distinto de
cero) · [[CREA-02 - FechaFin igual o anterior a FechaInicio]]
