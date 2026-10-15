# TIEM-03 — Adelantar el reloj del celular durante el examen

**Fecha:** 2026-09-08 · **Tipo:** Cronómetro / Anti-trampa · **Severidad:** Alta
**Dónde:** app Flutter, pantalla de evaluación en línea

Responde la pregunta que quedó anotada en el borrador de trabajo (`DocBreve/2026-09-07 - Prueba
offline evaluacion online...`): *«si en vez de tener un reloj mal calculado, uno adelanta a
propósito el reloj del celular durante el examen (como quien quiere hacer trampa para tener más
tiempo), ¿qué pasa?»* — ahí se dejó explícito que **no se había probado a mano todavía**, sólo
leído del código. Este caso es esa prueba pendiente.

## Precondiciones

- Evaluación en curso con tiempo restante amplio (para tener margen de maniobra al adelantar el
  reloj).
- Acceso a Ajustes → Fecha y hora del dispositivo para cambiarla manualmente (desactivar "hora
  automática" primero).

## Pasos

2. Ir a Ajustes del sistema y **adelantar el reloj del celular** varios minutos (por ejemplo, +20
   minutos) mientras la app sigue en primer plano o recién se vuelve a ella.
4. Intentar responder una pregunta justo después del salto.

## Resultado según el código

`RelojExamen` (`reloj_examen.dart`) combina dos relojes y se queda con el que marque **más**
tiempo transcurrido:

```dart
// reloj_examen.dart:76-84
final transcurridoPared =
    _dateTimeAppService.getCurrentDateTime().difference(paredAlIniciar);
final transcurridoMonotonico = _monotonico.transcurrido;

final transcurrido = transcurridoMonotonico > transcurridoPared
    ? transcurridoMonotonico
    : transcurridoPared;
```

El reloj **monotónico** (`RelojMonotonicoReal`) no se ve afectado por cambiar la hora del sistema
— sigue midiendo tiempo real transcurrido internamente. El reloj **de pared** sí se ve afectado:
si se adelanta 20 minutos, `transcurridoPared` salta esos 20 minutos de golpe.

Como la fórmula toma el **mayor** de los dos, adelantar el reloj hace que `transcurrido` salte
también — el cronómetro **descuenta esos 20 minutos del tiempo restante de inmediato**, tal como
predice la tabla del propio comentario de la clase:

```
| Adelantar el reloj | pared | perjudica a quien lo hizo |
```

vuelva a la app. Si el salto consume todo el tiempo restante, debería auto-finalizar
(`evaluacion_online_provider.dart:102-113`) casi de inmediato. Además, se registra en el log un
logs de la app, no en pantalla.

Del lado del servidor, esto no cambia nada por sí solo: el backend nunca confía en el reloj del
cliente para decidir si un intento expiró (usa su propio `new Date()`, ver
[[TIEM-01 - Pasan los 5 minutos configurados]]). El adelanto del reloj sólo afecta lo que **la
app** cree que queda de tiempo, no lo que el servidor acepta.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con el código
- [ ] No coincide

## Relacionado

[[TIEM-04 - Atrasar el reloj del celular durante el examen]] ·
[[TIEM-01 - Pasan los 5 minutos configurados]]
