# TIEM-02 — Medir en vivo el desfase de 5 horas de Oracle

**Fecha:** 2026-09-08 · **Tipo:** Cronómetro / Verificación en base · **Severidad:** Alta
**Dónde:** Oracle (réplica de desarrollo) + backend estudiante

Reproduce la medición ya hecha una vez (`07 - Documentacion/2026-09-07 - Investigacion abierta -
reloj de Oracle en evaluacion online.md`), para confirmarla de nuevo con datos frescos y dejar
evidencia asociada a este caso concreto.

## Precondiciones

- Acceso de consulta directa a Oracle (réplica de desarrollo), o pedirle a quien tenga acceso que
  corra las consultas de este caso.
- Una actividad de evaluación en línea de prueba, recién creada.

## Pasos

1. Anotar la **hora real** (reloj de pared, ej. del celular) en el instante exacto de crear la
   actividad.
2. Como estudiante, abrir el intento (iniciar el examen) e inmediatamente anotar la **hora real**
   otra vez.
3. Correr contra Oracle:
   ```sql
   SELECT SYSDATE AS "SYSDATE_ORACLE", CURRENT_DATE AS "CURRENT_DATE_SESION"
   FROM DUAL;
   ```
4. Correr también:
   ```sql
   SELECT FECHA_INICIO_EA
   FROM UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
   WHERE ID_ACTIVIDAD_ALUMNO = <id del intento recién abierto>;
   ```
5. Comparar las cuatro horas: la real anotada a mano, `SYSDATE`, `CURRENT_DATE` y
   `FECHA_INICIO_EA`.

## Resultado según el código

`SYSTIMESTAMP`/`SYSDATE` en esta instancia de Oracle devuelven la hora del sistema operativo
donde arrancó la instancia (UTC, `DBTIMEZONE = +00:00`), mientras que `CURRENT_DATE` sí refleja la
zona de sesión (`-05:00`, hora de Ecuador). `ALTER SESSION SET TIME_ZONE` no corrige `SYSDATE` —
esa función no obedece a la sesión.

`FECHA_INICIO_EA` se fija con `SET FECHA_INICIO_EA = SYSDATE`
(`evaluacion_online.queries.ts:123`), así que hereda directamente la hora UTC de Oracle.

**Predicción (ya confirmada una vez, se repite aquí para verificar que sigue igual):**

| Campo | Debería salir |
|---|---|
| `SYSDATE` | ~5 horas por delante de la hora real anotada a mano |
| `CURRENT_DATE` | igual (o muy cerca) de la hora real anotada a mano |
| `FECHA_INICIO_EA` | igual a `SYSDATE` en el momento de abrir el intento — **no** a `CURRENT_DATE` |

Si el desfase sigue siendo de exactamente 5 horas, confirma que la instancia de Oracle no ha
cambiado desde la medición anterior. Si el desfase cambió (más, menos, o desapareció), es un
hallazgo nuevo que vale la pena anotar aparte — podría indicar que alguien ajustó la zona horaria
del host de Oracle.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con el código
- [ ] No coincide

## Relacionado

[[TIEM-01 - Pasan los 5 minutos configurados]] ·
`07 - Documentacion/2026-09-07 - Investigacion abierta - reloj de Oracle en evaluacion online.md`
(la investigación original, con más detalle e hipótesis abiertas)
