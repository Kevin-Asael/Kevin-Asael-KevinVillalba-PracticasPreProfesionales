# CREA-02 — FechaFin igual o anterior a FechaInicio

**Fecha:** 2026-09-08 · **Tipo:** Creación / Validación · **Severidad:** Media
**Dónde:** Portafolio Docente (`utn-movil-portafolio-docentes`)

## Precondiciones

- Un curso y parcial activo para crear la actividad de prueba.

## Pasos

1. Crear una nueva evaluación en línea.
2. Poner **fechaFin igual a fechaInicio** (mismo día y misma hora exacta). Guardar y observar.
3. Repetir, esta vez con **fechaFin un segundo antes** de fechaInicio. Guardar y observar.
4. Repetir una tercera vez con **fechaFin un segundo después** de fechaInicio (el margen mínimo
   posible). Guardar y observar.

## Resultado según el código

`validateFechas` (`actividad.service.ts:541-552`):

```ts
private validateFechas(fechaInicio: Date, fechaFin: Date, msgini): void {
  if (fechaFin <= fechaInicio) {
    throw new ValidationException([...]);
  }
}
```

- **`fechaFin == fechaInicio`** → rechazada (la comparación es `<=`, no `<`).
- **`fechaFin` anterior** → rechazada.
- **`fechaFin` un segundo después** → **aceptada**, sin ningún mínimo de duración exigido. Una
  evaluación de 1 segundo de ventana de fechas es válida para el backend — el único límite de
  duración real del examen lo pone el límite de tiempo (`limiteTiempo`/`limTiempoHoras`), no la
  ventana de fechas en sí.

⚠ No hay validación de que `fechaInicio` no esté en el pasado — se puede crear una evaluación
cuya ventana ya haya empezado o incluso terminado en el momento de guardarla. No forma parte de
este caso puntual pero es una consecuencia observable si se prueba con fechas ya vencidas.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con el código
- [ ] No coincide

## Relacionado

[[CREA-01 - Crear con 0 horas 0 minutos]] · [[CREA-07 - Editar evaluacion con examen en curso]]
