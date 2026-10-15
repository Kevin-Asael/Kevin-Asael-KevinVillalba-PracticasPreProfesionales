# Investigación abierta: ¿por qué el reloj de Oracle rompe los tiempos de evaluación online?

**Estado:** sin resolver — documento de trabajo para quien retome la investigación
**Fecha:** 2026-09-07
**Repo:** `utn-movil-portafolio-estudiante` (módulo `evaluacion_online`)
**Antecedente:** notas de trabajo en bruto en `DocBreve/2026-09-07 - Prueba offline evaluacion online y bug de hora Oracle.md`
**Relacionado:** `07 - Documentacion/2026-09-07 - Conectividad en Evaluacion Online.md` (el buffer offline y el fix de idempotencia que se estaban probando cuando apareció esto)

> **Para quien retome esto:** esto **no es exclusivo de evaluación online**. El mismo patrón
> (`SYSDATE` sin convertir de zona horaria) aparece en 45 sitios de 21 ficheros de este repo —
> becas, comunicados, horarios, calendario de actividades también lo usan para comparar
> ventanas de tiempo. Lo de aquí es el caso donde se pudo medir y reproducir en vivo; el
> alcance real en los otros módulos no se ha revisado todavía.

---

## 1. El hecho a explicar

Se configuró una evaluación con límite de tiempo de **15 minutos**. Al abrir el intento en el
celular, la app mostró un tiempo restante de **~5 horas**.

Medido en vivo, con una consulta SQL directa contra la réplica de desarrollo:

| Campo | Valor medido |
|---|---|
| `SYSDATE` (reloj de Oracle) | 21:14:39 |
| `CURRENT_DATE` (zona de sesión, `-05:00`) | 16:14:39 |
| Hora real en que se creó la actividad (escrita por el docente) | 16:13:00 |
| Hora real en que se abrió el intento (~1 minuto después) | ~16:14 |
| Hora que quedó **guardada** como inicio del intento (`FECHA_INICIO_EA`) | 21:14:11 |

Dos eventos que en la realidad ocurrieron con 1 minuto de diferencia quedaron guardados en la
base separados por **5 horas exactas**.

---

## 2. Mecanismo — confirmado ✅

`SYSDATE`/`SYSTIMESTAMP` en esta instancia de Oracle devuelven la hora del sistema operativo
donde arrancó la instancia, que es **UTC** (`DBTIMEZONE = +00:00`). `ALTER SESSION SET
TIME_ZONE` no lo corrige: `SESSIONTIMEZONE` ya está en `-05:00` y `SYSDATE` sigue saliendo en
UTC de todos modos — esa función no obedece a la sesión, sólo a la zona con la que arrancó la
instancia.

Las fechas de negocio (`FECHA_INICIO`, `FECHA_FIN` de la actividad) las escribe el docente vía
`TO_DATE(:pFechaFin, 'DD/MM/YYYY HH24:MI:SS')` — en **hora de Ecuador**, tal cual la tecleó.
Verificado que el cliente Flutter tampoco convierte a UTC antes de mandarla:
`formulario_editar_activiadad_docente_provider.dart:214,220` usa
`DateFormat("dd/MM/yyyy HH:mm:ss").format(fecha)` sobre la hora local sin tocarla.

El punto donde arranca el error, en código:

```
INICIAR_CRONOMETRO_EVALUACION → SET FECHA_INICIO_EA = SYSDATE
-- evaluacion_online.queries.ts:123
```

`GET_REGLAS_EVALUACION` calcula después:

```sql
FECHAFINISO = LEAST(act.FECHA_FIN, alu.FECHA_INICIO_EA + LIM_TIEMPO_HORAS/24 + LIMITE_TIEMPO/1440)
```

Como `FECHA_INICIO_EA` quedó con la hora en UTC (5 horas adelantada respecto a la real), toda
esta cuenta hereda el mismo desfase.

---

## 3. Consecuencias observadas — algunas explicadas, otras no

| # | Qué se probó | Qué se esperaba | Qué pasó | ¿Explicado por el mecanismo de §2? |
|---|---|---|---|---|
| 1 | Límite = 15 min | Cronómetro de 15 min | La app mostró ~5 horas restantes | ✅ Sí — `FECHA_INICIO_EA` adelantada 5h infla el cálculo |
| 2 | Límite = 0h 10min | Que cierre a los 10 min reales | Pasan los 10 min y sigue abierto | ✅ Sí — mismo mecanismo, la cuenta sale tan inflada que 10 min reales no alcanzan |
| 3 | Límite = 0h 0min | — | El intento queda con fecha fin = su propio inicio | ✅ Sí — con límite 0, `FECHA_INICIO_EA + 0` es la propia fecha inflada |
| 4 | Subir bastante el límite de tiempo | Más margen de examen | El examen se cierra solo, recién empezado | 🎯 **No** — no encaja con el mecanismo de §2 en la dirección que predice (ver §4) |
| 5 | Calificar una pregunta | Que valga lo configurado | Sale como si siempre valiera 1 punto | 🎯 **No investigado** — la calificación la hace `LMS_PRC_CALIFICAR_EVALUACION`, un procedimiento dentro de Oracle (esquema `UTNDB`), sin copia de su fuente en este repo. Puede o no estar relacionado con el reloj — no hay evidencia todavía en ningún sentido |

---

## 4. Qué NO es el problema (ya descartado)

- **No es que el docente guarde mal la fecha de fin de la actividad.** Se revisó
  `formulario_editar_activiadad_docente_provider.dart` — la fecha se formatea y envía en hora
  local tal cual, sin ninguna conversión a UTC de por medio. El desfase nace únicamente del
  lado del intento (`FECHA_INICIO_EA` vía `SYSDATE`), no de la actividad en sí.
- **No es un problema de configuración de sesión/conexión.** `ALTER SESSION SET TIME_ZONE` y
  variables de entorno como `TZ` no tienen efecto sobre `SYSDATE` — está confirmado en la
  documentación de plataforma (`utn-practicas-contexto-claude/plataforma/infraestructura.md`)
  y no se intentó de nuevo aquí porque ya se sabe que no sirve.

---

## 5. Pendiente / próximos pasos sugeridos

1. **Punto #4 de la tabla — el más raro y sin ninguna hipótesis todavía.** Para investigarlo,
   la próxima vez que pase hay que anotar el `idActividadAlumno` del intento y correr contra
   Oracle la misma consulta usada en §1, con esos valores reales, para ver si `LEAST()` está
   escogiendo `act.FECHA_FIN` en vez de la suma del límite (que es lo único que cambiaría
   entre un límite chico y uno grande) y por qué eso resultaría en un cierre inmediato.
2. **Punto #5 — revisar `LMS_PRC_CALIFICAR_EVALUACION` directo en Oracle** (por ejemplo con
   `SELECT text FROM all_source WHERE name = 'LMS_PRC_CALIFICAR_EVALUACION' ORDER BY line`
   desde SQL Developer) para saber si de verdad ignora la calificación configurada por
   pregunta.
3. **Mapear los 45 usos de `SYSDATE`** en los 21 ficheros del repo — separar los que
   **comparan** ventanas de tiempo (peligrosos, pueden reproducir este mismo bug en otro
   módulo) de los que sólo **estampan** auditoría (inofensivos).
4. El arreglo puntual conocido, para cuando se decida aplicarlo consulta por consulta:
   ```sql
   CAST(SYSTIMESTAMP AT TIME ZONE 'America/Guayaquil' AS DATE)
   ```
   No hay arreglo de una sola vez a nivel de conexión — `SYSDATE` no obedece a `ALTER SESSION`
   ni a `TZ` del entorno, y la instancia es compartida por toda la plataforma (reiniciarla no
   es decisión de un practicante).
5. Decidir si esto se convierte en tarea de corrección real o se documenta como hallazgo
   conocido sin corregir por ahora, igual que ya está anotado el hallazgo de las 5 horas a
   nivel de plataforma.

---

## 6. Registro de hallazgos — 2026-09-07

- Medido en vivo el desfase de 5 horas entre `SYSDATE` y `CURRENT_DATE` en la réplica de
  desarrollo, con datos reales de un intento (evidencia en §1).
- Confirmado en código que `INICIAR_CRONOMETRO_EVALUACION` es el punto donde se contamina
  `FECHA_INICIO_EA` (`evaluacion_online.queries.ts:123`).
- Descartado que el bug esté también del lado de cómo el docente guarda `FECHA_FIN` de la
  actividad (§4).
- Reproducidos en vivo los síntomas #1, #2 y #3 de la tabla de §3 — todos explicados por el
  mismo mecanismo.
- Reportados #4 y #5 de la tabla de §3, sin diagnosticar — quedan como los dos frentes abiertos
  más urgentes.

---

## 7. Mitigaciones implementadas — 2026-09-11 (actualización 2026-09-17)

> ⚠ **El root cause (SYSDATE devuelve UTC) NO se corrigió.** Lo que sigue son mitigaciones que
> reducen el impacto en el módulo de evaluación online, sin tocar la causa de fondo.

Commits, verificados en git:

**Backend (`utn-movil-portafolio-estudiante`, rama `feature/anticopia-backend`):**
- `88daab1` — `fix(evaluacion_online): guardas NVL en FECHAFINISO y correccion de fechas de intento`
  Agrega `NVL()` a la expresión `FECHAFINISO` en las queries para evitar que campos nulos
  propaguen `NULL` en toda la cuenta de tiempo restante.
- `427d3f4` — `fix(evaluacion_online): auto-cierre de intento zombi, tolerancia NFF/NLT y calculo de retroalimentacion en servidor`
  El cálculo de si mostrar retroalimentación pasa a hacerse en el servidor (mismas fechas que
  Oracle usó para la evaluación), no en el cliente (que dependía de su reloj local).

**App (`utn_movil_app`, rama `feature/anticopia-evaluacion-online`):**
- `e6dcc27` — `fix(evaluacion_online): valida visualizacion de retroalimentacion desde el servidor y no reloj local`
  La app ya no compara fechas localmente para decidir si muestra retroalimentación — le pregunta
  al servidor, eliminando el desfase visible para el estudiante en ese flujo concreto.
- `864f16c` — `feat(evaluacion_online): reactiva modulo con anti-copia centralizado en backend y reloj monotonico`
  El cronómetro visible usa un **reloj monótono** (`Stopwatch` de Dart), no `DateTime.now()`.
  Esto no arregla el desfase en Oracle, pero evita que ajustes de hora del dispositivo alteren
  el tiempo restante que ve el estudiante.

**Alcance de estas mitigaciones:** cubren los síntomas #1 y #2 de la tabla de §3 (cronómetro
inflado) reduciendo el impacto visible. El síntoma #4 (cierre inesperado) y el #5 (calificación)
**siguen sin diagnosticar** — ver §5.

Ver detalle completo de estos commits en:
`DocOficial/2026-09-17 - Anti-copia y evaluacion online - implementacion y mejoras de estabilidad.md`
