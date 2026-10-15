# TIEM-04 — Atrasar el reloj del celular durante el examen

**Fecha:** 2026-09-08 · **Tipo:** Cronómetro / Anti-trampa · **Severidad:** Media
**Dónde:** app Flutter, pantalla de evaluación en línea

Complemento de [[TIEM-03 - Adelantar el reloj del celular durante el examen]]: la variante donde
el estudiante intenta "ganar tiempo" en vez de perderlo.

## Precondiciones

- Evaluación en curso con tiempo restante visible.
- Acceso a Ajustes → Fecha y hora del dispositivo.

## Pasos

1. Iniciar el examen y anotar el tiempo restante mostrado.
2. **Atrasar el reloj del celular** varios minutos (por ejemplo, -20 minutos).
4. Dejar pasar tiempo real (varios minutos) con el reloj todavía atrasado, y observar si el

## Resultado según el código

Mismo mecanismo que TIEM-03, pero en la dirección contraria. `RelojExamen.tick()`
(`reloj_examen.dart:70-84`) toma el **mayor** entre el tiempo transcurrido de pared y el
monotónico. Al atrasar el reloj, `transcurridoPared` se vuelve **menor** que antes (o incluso
negativo respecto al ancla), pero el monotónico **sigue corriendo normal**, sin verse afectado
por el cambio de hora del sistema. Como se toma el mayor de los dos, el monotónico "gana" y el
cronómetro **no se congela ni retrocede** — sigue descontando tiempo real con normalidad, como si
el atraso nunca hubiera pasado.

**Predicción concreta:**

- Debería seguir bajando al ritmo real (1 segundo por segundo real transcurrido), tal como lo
  marca el reloj monotónico, sin importar cuánto se haya atrasado el reloj de pared.
- Coincide con lo que ya se había leído en el código sin probarlo (`DocBreve/2026-09-07 - Prueba
  offline evaluacion online...`): *"Si atrasas el reloj del celular para 'ganar tiempo' → no
  sirve de nada, el cronómetro le cree al otro reloj."*

**Punto a verificar:** el reloj monotónico se detiene durante una suspensión profunda de la app
(ver comentario de la clase, `reloj_examen.dart:31-33`). Si el atraso del reloj coincide con la
app en segundo plano por un rato largo, el resultado podría mezclarse con el caso de
[[TIEM-06 - App suspendida mas de 8 horas en segundo plano]] — conviene hacer esta prueba con la
app siempre en primer plano para aislar el efecto.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con el código
- [ ] No coincide

## Relacionado

[[TIEM-03 - Adelantar el reloj del celular durante el examen]]
