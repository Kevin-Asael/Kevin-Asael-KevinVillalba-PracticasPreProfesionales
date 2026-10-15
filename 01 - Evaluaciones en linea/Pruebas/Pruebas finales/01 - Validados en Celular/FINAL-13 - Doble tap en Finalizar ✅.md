# FINAL-13 — Doble tap en "Finalizar" (candado de concurrencia)

**Fecha:** 2026-09-11 · **Tipo:** Concurrencia / Backend · **Severidad:** Alta
**Dónde:** backend NestJS (`utn-movil-portafolio-estudiante`) + app Flutter (`utn_movil_app`)

Verifica que dos peticiones de finalización casi simultáneas (doble tap, o un reintento de red
mientras la primera sigue en vuelo) no ejecuten dos veces el procedimiento de calificación en
Oracle.

## Precondiciones

- Examen activo, o a punto de expirar (para poder provocar el doble tap con margen).
- Ideal: conexión algo lenta o inestable (WiFi débil) para que la primera respuesta tarde y el
  doble tap sea más fácil de lograr.

## Pasos

1. Con el examen activo, tocar el botón **"Finalizar"** dos veces muy rápido (o una vez y, si
   tarda, tocarlo de nuevo antes de que responda).
2. Observar el comportamiento de la pantalla.

## Resultado según el código

1. Backend (`evaluacion_online.service.ts:50`): `finalizacionesEnCurso = new Set<number>()`, en
   memoria del proceso.
2. `finalizarEvaluacion` (línea 350-390): tras `validarAcceso`, si el `idActividadAlumno` ya está
   en el Set, lanza `ForbiddenException('Ya existe una finalización en curso para esta evaluación.
   Intenta de nuevo en unos segundos.')` (línea 367-371) — mensaje **distinto** al de "ya fue
   finalizada", para no confundir un candado momentáneo con la regla de negocio real.
3. Si no estaba en curso, se agrega al Set (línea 372), se ejecuta la finalización real, y se quita
   del Set en un bloque `finally` (línea 387) — **siempre**, incluso si Oracle falla.
4. En Flutter, `finalizarEvaluacion` del provider ya se protege contra doble tap por su cuenta
   (`if (_finalizando) return;`, `evaluacion_online_provider.dart`) — así que en la práctica lograr
   que lleguen dos peticiones reales al backend requiere que la UI no alcance a deshabilitar el
   botón a tiempo, o forzarlo con mala conexión.

**Puntos clave a comprobar:**
- [x] Solo se procesa una finalización real (revisar que la nota final no cambie entre reintentos,
      o que no aparezca un error de "actividad ya calificada dos veces").
- [x] No queda la pantalla colgada ni un error confuso visible — en el peor caso, un
      `AppSnackBar` de "no se pudo finalizar, intenta de nuevo" y el examen sigue interactivo.

## Observación — qué pasó de verdad

> Pasa bien tal como se comprobo en puntos clave

## Estado

✅ Coincide con el código (validado).


## Relacionado

 ·
[[FINAL-02 - Pasan los 5 minutos y autofinaliza por tiempo ✅]]
