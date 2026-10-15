# CREA-10 — Resetear tiempo afecta a todos los alumnos, no solo a uno

**Fecha:** 2026-09-08 · **Tipo:** Regla de negocio · **Severidad:** Crítica
**Dónde:** Portafolio Docente (`utn-movil-portafolio-docentes`) → app estudiante

## Precondiciones

- Una evaluación en línea con **al menos dos estudiantes** que hayan iniciado su intento (o uno
  que ya haya rendido y otro que esté en curso ahora mismo).

## Pasos

1. Confirmar que el Estudiante A ya inició su examen (tiene `FECHA_INICIO_EA` fijada) — puede
   estar respondiendo en este momento o haber ya finalizado.
2. Confirmar que el Estudiante B **no ha iniciado todavía** su intento.
3. Como docente, tocar **"Resetear Tiempo de Evaluación"** sobre esa actividad — pensando (como
   sería intuitivo) que sirve para darle una segunda oportunidad a un estudiante puntual.
4. Revisar en base o en la app qué pasó con el intento del Estudiante A (el que ya estaba en
   curso o ya había terminado).

## Resultado según el código

**No hay forma de resetear el tiempo de un solo estudiante — el endpoint resetea a todos los que
tienen la actividad asignada, sin filtro ni parámetro de alumno:**

```sql
-- resetear-tiempo-evaluacion.query.ts
UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
   SET FECHA_INICIO_EA = NULL
 WHERE ID_ACTIVIDAD = :idActividad
```

El `WHERE` sólo filtra por `ID_ACTIVIDAD` — no hay `CEDULA_INTEGRANTE` ni `ID_ACTIVIDAD_ALUMNO`
en la cláusula. `resetearTiempoEvaluacion` (`actividad.service.ts:959-971`) tampoco añade ningún
filtro antes de llamar al repositorio, y **no valida nada** (ni siquiera "parcial activo", a
diferencia de `agregarIntentoEvaluacion`).

**Consecuencia para el Estudiante A, que no pidió nada:** su `FECHA_INICIO_EA` se pone en `NULL`
— exactamente el mismo estado que "examen no iniciado". Si estaba respondiendo en ese momento, la
próxima vez que su app pida reglas (`GET_REGLAS_EVALUACION`), `alu.FECHA_INICIO_EA IS NULL` hace
que `FECHAFINISO` salga `NULL` también (`evaluacion_online.queries.ts:157`) — sin cronómetro, sin
límite de tiempo aparente. Y si vuelve a interactuar con el formulario, `INICIAR_CRONOMETRO_EVALUACION`
(guardado por `FECHA_INICIO_EA IS NULL`) puede volver a fijar `SYSDATE` como nuevo inicio,
**regalándole tiempo extra** sin que lo haya pedido — o, si ya había finalizado (`ENTREGADO='SI'`),
este reset no toca `ENTREGADO` ni `CALIFICACION`, así que su nota ya calculada debería
sobrevivir intacta, pero su fecha de inicio queda borrada de todos modos.

Este es el mismo botón que usa la colección Postman del repo (`docs/Crear Evaluacion Online -
Portafolio Docente.postman_collection.json`, paso 5) para "resetear tiempo de evaluación" en
pruebas — pensado como herramienta de testing, con el mismo efecto de barrido total si se usa en
un curso real con alumnos ya en curso.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con el código
- [ ] No coincide

## Relacionado

[[CREA-07 - Editar evaluacion con examen en curso]] · [[CREA-06 - Agregar intento extra sin tope superior]]
