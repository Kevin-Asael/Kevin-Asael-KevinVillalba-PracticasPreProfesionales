# CREA-05 — Intentos permitidos fuera de rango

**Fecha:** 2026-09-08 · **Tipo:** Creación / Validación · **Severidad:** Media
**Dónde:** Portafolio Docente (`utn-movil-portafolio-docentes`)

## Precondiciones

- Un curso y parcial activo.

## Pasos

1. Crear una evaluación en línea con **intentos permitidos = 0**. Guardar y observar.
2. Crear otra con **intentos permitidos = 7**. Guardar y observar.
3. Crear otra con **intentos permitidos = 6** (el máximo permitido). Guardar y observar.
4. Crear una actividad de tipo **7 (Clase Virtual Síncrona)** con cualquier valor de intentos
   (por ejemplo 5) y observar qué queda guardado realmente.

## Resultado según el código

`actividad.service.ts:159-167`:

```ts
if (tipoActividadNumber === 7) {
  intentosPermitidosNumber = 1;
} else {
  this.validateNumeroInRange(intentosPermitidosNumber, 1, 6, 'intentosPermitidos',
    'El número de intentos permitidos debe ser mayor a cero y menor o igual a 6');
}
```

- **`0`** → rechazado (fuera del rango 1-6).
- **`7`** → rechazado.
- **`6`** → aceptado (límite superior inclusive).
- **Tipo 7** → el valor que el docente haya puesto **se ignora por completo** y se fuerza a `1`,
  sin ningún aviso al respecto en la respuesta. Si el formulario del cliente muestra el campo de
  intentos para el tipo 7, lo que el docente vea ahí después de guardar puede no coincidir con lo
  que realmente quedó en base — vale la pena confirmar si la UI oculta ese campo para tipo 7 o si
  engaña mostrando el valor que el docente tecleó.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con el código
- [ ] No coincide

## Relacionado

[[CREA-06 - Agregar intento extra sin tope superior]]
