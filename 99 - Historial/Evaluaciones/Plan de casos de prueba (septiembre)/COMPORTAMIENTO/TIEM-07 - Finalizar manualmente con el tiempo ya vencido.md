# TIEM-07 — Finalizar manualmente con el tiempo ya vencido

**Fecha:** 2026-09-08 · **Tipo:** Cronómetro / Contraste de reglas · **Severidad:** Media
**Dónde:** backend `utn-movil-portafolio-estudiante`

Contraste directo con `/responder`: mientras que responder una pregunta con el tiempo vencido se
rechaza, **finalizar el examen a mano no se bloquea nunca por tiempo** — es una decisión explícita
del código, no un descuido.

## Precondiciones

- Un examen con el intento ya vencido (tiempo agotado), pero donde el cliente todavía no haya
  auto-finalizado — por ejemplo, aprovechando el bug de reloj de
  [[TIEM-01 - Pasan los 5 minutos configurados]], o forzándolo manualmente si hay forma de
  simularlo.
- Alternativa más simple: usar un examen con límite de tiempo corto y esperar a que
  **legítimamente** expire del lado del servidor (más de 5 horas después de iniciado, por el
  desfase de Oracle) mientras el estudiante sigue con la pantalla abierta.

## Pasos

1. Con el intento ya vencido del lado del servidor (confirmar con la consulta SQL de
   [[TIEM-02 - Medir en vivo el desfase de 5 horas de Oracle]] si hace falta), intentar
   **responder una pregunta**. Confirmar que se rechaza.
2. Sin cerrar la app, tocar **Finalizar** y confirmar el diálogo.
3. Observar si el servidor acepta la finalización o la rechaza también.

## Resultado según el código

`/responder` sí valida tiempo y rechaza con 403 (`verificarIntentoActivoLigero`,
`evaluacion_online.service.ts:684-686`, mensaje *"El tiempo para realizar este intento ha
expirado. No se pueden guardar más respuestas."*).

`/finalizar`, en cambio, llama a `validarAcceso` **sin pasar `validarTiempo`**:

```ts
// evaluacion_online.service.ts:274-277
this.validarAcceso(reglas, {
  validarEntrega: true,
  permitirTiempoExpirado: true,
});
```

Como el bloque de validación de tiempo dentro de `validarAcceso` sólo se ejecuta si
`config.validarTiempo` es verdadero (`:639`), y aquí nunca se pasa, **el tiempo no se comprueba en
absoluto al finalizar** — ni siquiera hace falta el `permitirTiempoExpirado: true` explícito para
que pase, aunque el código lo deja ahí como intención clara. Sólo se valida `validarEntrega`
(`:658-664`): que no esté ya entregado con cero intentos restantes.

**Resultado esperado:** el paso 1 (responder) debe rechazarse con 403; el paso 2 (finalizar) debe
**aceptarse sin problema**, entregando el examen con lo que se alcanzó a responder hasta el
momento. Esto es coherente con el diseño: una vez que el tiempo se agotó, no tiene sentido seguir
bloqueando la única acción que cierra el intento — bloquear también `/finalizar` dejaría el
examen en un limbo sin forma de cerrarlo desde el cliente.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con el código
- [ ] No coincide

## Relacionado

[[TIEM-01 - Pasan los 5 minutos configurados]] · [[Nivel 11 - Resiliencia y Red (Estudiante)]]
(RSE-07/RSE-08, auto-finalizar por tiempo)
