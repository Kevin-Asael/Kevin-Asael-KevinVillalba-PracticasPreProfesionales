# FINAL-15 — La retroalimentación no se desbloquea adelantando el reloj

**Fecha:** 2026-09-11 · **Tipo:** Seguridad / Backend + Frontend · **Severidad:** Crítica
**Dónde:** app Flutter (`utn_movil_app`) + backend NestJS (`utn-movil-portafolio-estudiante`)

Verifica que la clave de respuestas (qué alternativa era correcta, retroalimentación) no se pueda
ver antes de que cierre el plazo general de la actividad — ni siquiera adelantando la hora del
teléfono, que era exactamente el hueco que se cerró hoy.

> ⚠️ **Antes de hoy** el cliente decidía esto comparando `fechaFin` contra `DateTime.now()` del
> propio teléfono — adelantar la hora en Ajustes desbloqueaba el detalle antes de tiempo, sin que
> el backend lo supiera ni lo impidiera.

## Precondiciones

- Un examen ya finalizado, **antes** de que cierre el plazo general de la actividad en el aula
  virtual (o sea, mientras otros compañeros todavía podrían estar rindiéndolo).

## Pasos — parte A (mientras el plazo general sigue abierto)

1. Ir a la pantalla de resultados / "Detalle por Pregunta" de ese examen.
2. **Esperado:** se ve la nota y qué respondiste, pero NO cuáles alternativas eran correctas ni
   retroalimentación.
3. Ir a Ajustes del teléfono y **adelantar la hora manualmente** más allá de la fecha de cierre
   general de la actividad.
4. Volver a abrir (o refrescar) la pantalla de resultados.
5. **Esperado:** sigue SIN mostrar la clave de respuestas — adelantar la hora del teléfono ya no
   cambia nada.

## Pasos — parte B (control: sí se ve cuando corresponde)

6. Probar contra una actividad cuyo plazo general **ya cerró de verdad** (o esperar a que cierre
   la de la parte A).
7. **Esperado:** ahí sí aparece completa: alternativa correcta, retroalimentación.

## Resultado según el código

1. Backend (`evaluacion_online.service.ts:695`, método `getResultado`):
   ```ts
   const puedeVerRetroalimentacion = fechaFin === null || new Date() >= fechaFin;
   ```
   `new Date()` es el reloj del **servidor**, nunca el del cliente. Si `!puedeVerRetroalimentacion`,
   `detalle` pasa por `sanitizarDetalleSinRetroalimentacion` (mismo archivo) antes de salir: quita
   `esCorrecta`, `claveCorrectaDisponible`, pone `nota: 0` (revela lo mismo que `esCorrecta` si se
   dejara pasar), y en cada alternativa/emparejamiento quita `correcta`, `esCorrectaAlternativa`,
   `calificacionAlternativa`, `retroalimentacion`, `respuestaCorrectaCodigo`,
   `respuestaCorrectaTexto` — conserva el resto (texto de la pregunta, qué marcaste) para que la
   pantalla no se rompa.
2. El DTO (`dto/resultado_evaluacion.dto.ts:15`) expone `puedeVerRetroalimentacion: boolean`
   explícito en la respuesta.
3. Flutter (`resultado_evaluacion_entity.dart`, `resultado_evaluacion_model.dart`): el campo se
   mapea directo del JSON del backend — ya no hay ningún cálculo con `DateTime.now()` en el
   cliente.

**Puntos clave a comprobar:**
- [x] Parte A paso 2: sin clave de respuestas.
- [x] Parte A paso 5 (tras adelantar el reloj): sigue sin clave de respuestas.
- [x] Parte B: con el plazo general ya cerrado, sí aparece completa.

## Observación — qué pasó de verdad

>Se elevo el tiempo en retroalimentacion y funciono tal cual como el codigo. Ademas cuando se estaba en el tiempo anterior a que cierre la evaluacion me salio bien sin las respuestas previo a que cierre.

## Estado

✅ Coincide con el código (validado).


## Relacionado

[[FINAL-08 - Suite Maestra Automatizada Frontend y Backend ✅]] ·
[[FINAL-03 - Atrasar el reloj del celular durante el examen ✅]]
