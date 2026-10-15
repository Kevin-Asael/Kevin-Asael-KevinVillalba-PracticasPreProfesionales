# CREA-06 — Agregar intento extra sin tope superior

**Fecha:** 2026-09-08 · **Tipo:** Regla de negocio · **Severidad:** Media
**Dónde:** Portafolio Docente (`utn-movil-portafolio-docentes`)

Distinto de [[CREA-05 - Intentos permitidos fuera de rango]]: aquel valida el valor **al crear**
la actividad; este caso es el botón **"Agregar intento extra"**, que existe precisamente para
saltarse esa validación después de creada — es el endpoint que usa
NEG-03 (caso no documentado) del Nivel 9, aquí verificado a fondo.

## Precondiciones

- Una evaluación en línea ya creada, con `intentosPermitidos` en el máximo normal (6, ver
  CREA-05) o en cualquier valor conocido.

## Pasos

1. Anotar el valor actual de `intentosPermitidos` de la actividad.
2. Tocar **"Agregar intento extra"** una vez. Confirmar que sube en 1.
3. Repetirlo **varias veces seguidas** (5-10 veces) sobre la misma actividad.
4. Revisar el valor final de `intentosPermitidos` en la base o en la vista de calificaciones.

## Resultado según el código

`agregarIntentoEvaluacion` (`actividad.service.ts:830-848`) sólo exige que el parcial esté activo
(`:832-835`) y llama al procedimiento:

```sql
-- agregar-intento-evaluacion.query.ts
BEGIN
    UTNDB.LMS_PRC_MODIFICAR_INTENTOS(:idActividad, 1);
END;
```

**Sin ningún tope superior en el código de este repo.** A diferencia de la creación
(rango 1-6, `actividad.service.ts:160-167`), este endpoint no vuelve a comprobar el límite antes
ni después de sumar — cada llamada suma 1, indefinidamente. Si `LMS_PRC_MODIFICAR_INTENTOS` (PL/SQL,
sin código visible en ningún repo) tampoco tiene un tope interno, se puede llevar
`intentosPermitidos` mucho más allá del máximo de 6 que rige al crear la actividad.

**Punto a verificar:** si el procedimiento PL/SQL sí aplica un tope interno que este repo no
conoce, el caso sirve igual para documentarlo — confirmar en la base cuál es el valor real tras
varias llamadas seguidas.

## Observación — qué pasó de verdad

>

## Estado

- [ ] Pendiente
- [ ] Coincide con el código
- [ ] No coincide

## Relacionado

[[CREA-05 - Intentos permitidos fuera de rango]] · [[Nivel 9 - Flujos de Negocio y Edge Cases]]
(NEG-03, mismo endpoint desde otro ángulo)
