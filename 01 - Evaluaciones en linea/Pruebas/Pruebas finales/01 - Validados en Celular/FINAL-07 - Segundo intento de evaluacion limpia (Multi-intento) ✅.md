# FINAL-07 — Segundo intento de evaluación limpia (Multi-intento)

**Fecha:** 2026-09-10 · **Tipo:** Multi-intento / Reanudación · **Severidad:** Alta
**Dónde:** backend NestJS (`utn-movil-portafolio-estudiante`) + app Flutter

Verifica que cuando una evaluación permite múltiples intentos (por ejemplo, 2 intentos), una vez finalizado el Intento 1, el estudiante pueda iniciar el Intento 2 y este arranque con el cronómetro completamente fresco (5 minutos completos), sin heredar la fecha de inicio del intento anterior ni estados pendientes del intento anterior.

## Precondiciones

- Actividad creada con **Intentos permitidos = 2** (o más) y límite de tiempo de 5 minutos.
- El estudiante ya rindió y finalizó el Intento 1 (en Oracle `ENTREGADO = 'SI'`, `INTENTOS_DISPONIBLES = 1`).

## Pasos

1. Desde la pantalla de resultados del Intento 1, volver a la ficha de la materia.
2. Tocar nuevamente la evaluación.
3. Verificar que el botón muestre opción de nuevo intento (o Iniciar Evaluación) y que indique intentos restantes.
4. Tocar **Iniciar Evaluación** para comenzar el Intento 2.
5. Observar el cronómetro apenas carguen las preguntas.
6. Responder una pregunta y finalizar el segundo intento.

## Resultado según el código

1. En el backend (`evaluacion_online.service.ts:95-125`):
   - Detecta `reglas.entregado === 'SI'` y `reglas.intentosDisponibles > 0`.
   - Ejecuta `REANUDAR_INTENTO_ENTREGADO`:
     ```sql
     UPDATE UTNDB.LMS_TAB_ACTIVIDADES_ALUMNOS
     SET ENTREGADO = 'NO',
         FECHA_FIN_EA = NULL,
         FECHA_INICIO_EA = NULL,  -- ¡Limpieza crítica para reiniciar cronómetro!
         CALIFICACION = NULL
     WHERE ID_ACTIVIDAD_ALUMNO = :2
     ```
   - Limpia el estado del intento anterior (`antiCopiaService.limpiar(idActividadAlumno)`).
   - Como `FECHA_INICIO_EA` quedó en NULL, el nuevo llamado a `iniciarCronometro` establece un nuevo `SYSDATE`.
2. En Flutter:
   - El cronómetro arranca nuevamente desde **00:05:00**.
   - No sale de inmediato con *"Tiempo expirado"*.
   - El estudiante dispone de sus 5 minutos completos para el segundo intento.

**Puntos clave a comprobar:**
- [x] El segundo intento arranca en `00:05:00` y no en `00:00:00`.
- [x] No aparece mensaje de tiempo expirado al cargar el formulario.
- [x] Permite responder y califica el segundo intento.

## Observación — qué pasó de verdad

> Tal cual como describe los puntos a comprobar

## Estado

✅ Coincide con el código (validado).


## Relacionado

[[FINAL-02 - Pasan los 5 minutos y autofinaliza por tiempo ✅]]
