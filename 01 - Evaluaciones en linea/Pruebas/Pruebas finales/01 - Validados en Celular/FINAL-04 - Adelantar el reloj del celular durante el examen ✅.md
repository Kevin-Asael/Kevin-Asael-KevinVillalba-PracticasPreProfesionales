# FINAL-04 — Adelantar el reloj del celular durante el examen

**Fecha:** 2026-09-10 · **Tipo:** Cronómetro / Manipulación de reloj · **Severidad:** Media
**Dónde:** app Flutter (`utn_movil_app`)

Verifica qué sucede cuando se adelanta manualmente el reloj del teléfono durante el examen por encima de la hora de finalización. Demuestra que la app interpreta que el tiempo expiró y procede a auto-finalizar.

## Precondiciones

- Examen de 5 minutos en curso con preguntas cargadas.
- En el teléfono: Ajustes → Sistema → Fecha y hora → Desactivar "Ajustar hora automáticamente".

## Pasos

1. Iniciar la evaluación y marcar 1 pregunta.
2. Salir a Ajustes de Android y **adelantar la hora del teléfono 15 minutos hacia el futuro** (por encima de los 5 minutos del examen).
3. Volver de inmediato a la aplicación móvil.
4. Observar el comportamiento del temporizador y de la pantalla.

## Resultado según el código

1. En Flutter (`evaluacion_online_provider.dart:120-137`):
   ```dart
   final ahora = DateTime.now(); // Ahora es +15 minutos
   final nuevoTiempoRestante = fin.difference(ahora); // Da negativo
   if (nuevoTiempoRestante.isNegative || nuevoTiempoRestante.inSeconds <= 0) {
     _tiempoRestante = Duration.zero;
     timer.cancel();
     finalizarEvaluacion(..., esAutoFinalizar: true);
   }
   ```
2. Al detectar que `nuevoTiempoRestante.isNegative` es verdadero:
   - Se activa la auto-finalización inmediata.
   - Se envía la evaluación al servidor y se redirige a la pantalla de resultados.

**Puntos clave a comprobar:**
- [x] Al adelantar la hora por encima del fin, la app no se queda congelada.
- [x] Auto-finaliza y muestra la pantalla de resultados con la pregunta marcada calificada.

## Observación — qué pasó de verdad

> Se finaliza automáticamente la prueba. Tal cual

## Estado

✅ Coincide con el código (validado).


## Relacionado

[[FINAL-03 - Atrasar el reloj del celular durante el examen ✅]]


