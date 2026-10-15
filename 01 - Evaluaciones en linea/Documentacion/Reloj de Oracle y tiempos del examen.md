# Reloj de Oracle y tiempos del examen

Módulo `evaluacion_online` · backend `utn-movil-portafolio-estudiante`

## Lo que se midió (2026-09-07)

En la réplica de desarrollo, `SYSDATE` devuelve la hora en **UTC**, 5 horas por delante de Ecuador:

| Medición | Valor |
|---|---|
| `SYSDATE` | 21:14:39 |
| `CURRENT_DATE` (sesión en `-05:00`) | 16:14:39 |
| Inicio del intento guardado (`FECHA_INICIO_EA`) | 21:14:11, abierto realmente a las ~16:14 |

`ALTER SESSION SET TIME_ZONE` no lo cambia: `SYSDATE` sigue la zona con la que arrancó la instancia.

## Dónde entra en la evaluación

- `MVL_PRC_EVAL_INICIAR_CRONOMETRO` guarda `FECHA_INICIO_EA = SYSDATE`.
- La hora de fin del intento se calcula como `LEAST(FECHA_FIN de la actividad, FECHA_INICIO_EA + límite)`.
- Las fechas de la actividad las escribe el docente en hora de Ecuador; la app no las convierte.

Con el inicio en UTC y la ventana de la actividad en hora local, la cuenta del tiempo mezclaba dos relojes. En las primeras pruebas, el cronómetro de un examen de 15 minutos mostraba ~5 horas.

## Qué se hizo

| Cambio | Efecto |
|---|---|
| El servidor envía su hora en el formulario (`horaServidorISO`) y la app calcula el tiempo restante contra ella | el cronómetro no depende del reloj del teléfono |
| Cronómetro con reloj monotónico y de pared, el mayor de los dos (`864f16c`) | adelantar o atrasar la hora del teléfono no da ni quita tiempo |
| La retroalimentación la decide el servidor (`427d3f4`, `e6dcc27`) | mismo reloj que usa para calificar |
| Guardas `NVL` en la hora de fin (`88daab1`) | un límite vacío no deja el intento sin hora de fin |

## Comprobado

- En celular: adelantar y atrasar el reloj del teléfono durante el examen no cambia el tiempo real (`FINAL-03`, `FINAL-04`), y la retroalimentación no se desbloquea adelantando el reloj (`FINAL-15`).
- En dev, el 2026-10-13 y 14: en evaluaciones de 1 minuto, el cronómetro de la app, el cierre automático y el job del servidor (programado a fin + 1 min) coincidieron con el límite configurado.

## Mejora posible

La causa sigue en la base: `SYSDATE` en UTC. Afecta también a otros módulos que comparan fechas con `SYSDATE`. El arreglo que no depende del servidor es usar `CAST(SYSTIMESTAMP AT TIME ZONE 'America/Guayaquil' AS DATE)` en las consultas que comparan ventanas de tiempo; aplicarlo es una decisión de plataforma, con el DBA.
