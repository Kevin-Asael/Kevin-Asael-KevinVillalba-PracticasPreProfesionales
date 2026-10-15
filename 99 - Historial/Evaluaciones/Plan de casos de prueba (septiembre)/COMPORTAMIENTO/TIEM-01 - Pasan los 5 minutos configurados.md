# TIEM-01 — Pasan los 5 minutos configurados (el caso literal)

**Fecha:** 2026-09-08 · **Tipo:** Cronómetro / Bug confirmado · **Severidad:** Crítica
**Dónde:** app estudiante + backend `utn-movil-portafolio-estudiante` + Oracle

Comprueba que, al vencer el límite configurado, el servidor rechace nuevas respuestas y modificaciones.

## Precondiciones

- Crear una evaluación con **límite de tiempo = 0 horas, 5 minutos** (siguiendo
  [[CREA-01 - Crear con 0 horas 0 minutos]] pero con 5 minutos en vez de 0).
- Un reloj o cronómetro externo (el del propio celular sirve) para medir los 5 minutos reales sin

## Pasos

1. Como estudiante, iniciar el examen. Anotar la hora real exacta de inicio.
3. Dejar pasar **5 minutos reales** (con el reloj externo, no el de la app).
4. Al llegar a los 5 minutos reales, intentar **responder una pregunta nueva**.
5. Intentar **cambiar una respuesta ya marcada**.

## Resultado según el código

**Se espera que la app NO respete los 5 minutos reales — por el mismo bug de reloj de Oracle ya
documentado en `07 - Documentacion/2026-09-07 - Investigacion abierta - reloj de Oracle en
evaluacion online.md`.**

El mecanismo, verificado en el código de este backend:

1. Al iniciar el intento, `INICIAR_CRONOMETRO_EVALUACION` guarda `FECHA_INICIO_EA = SYSDATE`
   (`evaluacion_online.queries.ts:121-127`). `SYSDATE` en esta instancia de Oracle devuelve la
   hora en **UTC**, 5 horas por delante de la hora real de Ecuador.
2. El límite se calcula sumando los 5 minutos configurados a esa hora ya inflada:
   `GET_REGLAS_EVALUACION_RESPONDER` (`:172-197`, la que valida cada `/responder`).
3. La comparación contra "ahora" en el backend usa `new Date()` de Node
   (`evaluacion_online.service.ts:618, 678`) — la hora real del servidor, sin el desfase de
   Oracle.
4. Como el límite calculado está adelantado ~5 horas respecto a la hora real, la comparación
   `ahora > fechaFinISO` (`verificarIntentoActivoLigero`, `:684`) sigue dando **falso** durante
   varias horas después de que pasen los 5 minutos "reales".

**Predicción concreta para cada paso:**

  síntoma medido en la investigación previa con un límite de 15 minutos).
- Paso 4 (responder tras 5 min reales): **debería aceptarse igual**, sin ningún 403 — el servidor
  todavía no considera expirado el intento.
- Paso 5 (cambiar una respuesta): mismo mecanismo, **debería aceptarse igual** — no hay ninguna
  regla adicional que impida cambiar una respuesta ya marcada mientras el intento siga `ACTIVO`.
  `evaluacion_online_provider.dart:92-119`) sólo dispara cuando su propio cálculo llega a cero —
  que, con el mismo desfase, también tardará ~5 horas en vez de 5 minutos.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con el código
- [ ] No coincide

## Relacionado

[[TIEM-02 - Medir en vivo el desfase de 5 horas de Oracle]] ·
[[TIEM-07 - Finalizar manualmente con el tiempo ya vencido]] · [[CREA-01 - Crear con 0 horas 0 minutos]]
