# CREA-07 — Editar evaluación con examen en curso

**Fecha:** 2026-09-08 · **Tipo:** Regla de negocio · **Severidad:** Crítica
**Dónde:** Portafolio Docente (`utn-movil-portafolio-docentes`) → app estudiante

## Precondiciones

- Una evaluación en línea con ventana de tiempo amplia (por ejemplo 30-60 minutos) para tener
  margen de maniobra.
- Un estudiante (u otra cuenta) que inicie el examen y quede **a mitad de responder**, con el
  cronómetro corriendo.

## Pasos

1. Iniciar el examen como estudiante. Confirmar que el cronómetro arrancó y responder 2-3
   preguntas.
2. **Sin que el estudiante finalice**, como docente editar esa misma actividad y **acortar** el
   límite de tiempo (por ejemplo, de 60 minutos a 5 minutos) o adelantar la `fechaFin`.
3. Guardar la edición.
4. Volver a la app del estudiante (sin cerrar el examen) y observar qué pasa con el cronómetro y
   con el intento de responder una pregunta más.

## Resultado según el código

**La única condición para poder editar es que el parcial esté activo — no importan los intentos
en curso:**

```sql
-- validar-editar-actividad-query.ts
SELECT 'T' AS RES FROM DUAL
WHERE UTNDB.LMS_FUN_PARCIAL_ACTIVA (:P316_ID_CURSO,:P316_CODIGO_PARCIAL) ='T'
  AND :P316_ID_ACTIVIDAD IS NOT NULL
```

No hay ninguna comprobación de si hay estudiantes respondiendo en ese momento. El `UPDATE` que
aplica la edición (`actualizar_actividad_sinadjunto.query.ts`) pisa directamente
`FECHA_INICIO`, `FECHA_FIN`, `LIMITE_TIEMPO`, `LIM_TIEMPO_HORAS`, `INTENTOS_PERMITIDOS` y
`EVAL_AUTO` sobre `LMS_TAB_ACTIVIDAD_ACADEMICA`, **sin tocar** `LMS_TAB_ACTIVIDADES_ALUMNOS` (la
tabla donde vive el intento del estudiante, con su `FECHA_INICIO_EA` ya fijada).

Como la fecha límite del alumno se recalcula al vuelo cada vez que pide reglas
(`FECHA_INICIO_EA + LIM_TIEMPO_HORAS/24 + LIMITE_TIEMPO/1440`, ver
[[CREA-01 - Crear con 0 horas 0 minutos]]), acortar el límite de tiempo **expira el intento
el nuevo límite, mucho más corto que el que ya llevaba corriendo, y puede devolver el examen como
ya expirado sin que nadie se lo haya avisado en el momento del cambio.

**Del lado del cliente:** el cronómetro del estudiante (`RelojExamen`, ver COPIA-10) no vuelve a
consultar al servidor entre ticks — sólo recalcula localmente contra `fechaFinISO`, que ya trajo
al cargar el formulario. El cambio del docente **no se refleja en el cronómetro visible** hasta
que el cliente vuelva a pedir el formulario (por ejemplo, al intentar responder una pregunta y
recibir un 403, o al reabrir la pantalla). Es decir: visualmente el estudiante puede seguir viendo
tiempo restante mientras, del lado del servidor, su examen ya está expirado.

**Consecuencia adicional que vale la pena confirmar:** ¿qué pasa con las respuestas que el
estudiante intenta enviar después del recorte pero antes de darse cuenta? Deberían fallar con
`403 EXPIRADO` (mismo mecanismo que el bug de NVL en CREA-01) y quedar en el buffer offline local
sin llegar nunca al servidor — habría que confirmarlo con el buffer offline real.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con el código
- [ ] No coincide

## Relacionado

[[CREA-01 - Crear con 0 horas 0 minutos]] · [[CREA-10 - Resetear tiempo afecta a todos los alumnos]]
· [[Nivel 9 - Flujos de Negocio y Edge Cases]] (NEG-04, cierre anticipado por fecha fin)
