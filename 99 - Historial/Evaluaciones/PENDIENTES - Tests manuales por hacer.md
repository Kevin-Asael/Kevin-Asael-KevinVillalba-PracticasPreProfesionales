# Pendientes — Tests manuales por hacer en el celular

**Fecha:** 2026-09-11 · Checklist de todo lo que falta probar a mano en la app compilada.
Lo automatizado ya está cubierto — ver [[FINAL-08 - Suite Maestra Automatizada Frontend y Backend ✅]].
Esto es solo lo que **no** se puede probar con mocks y necesita un teléfono real.

> Actualización 2026-09-11: los casos 06-12 ya tienen su propia nota `FINAL-XX` con el mismo
> formato que los demás (precondiciones, pasos, resultado según el código, checkboxes). Este
> archivo queda solo como índice — el detalle vive en cada nota. Ver también el índice completo en
> [[../README - Plan de Pruebas Finales|README]].

## Checklist completo

| # | Caso | Qué valida |
| :-- | :-- | :-- |
| [ ] | [[../FINAL-02 - Pasan los 5 minutos y autofinaliza por tiempo ✅]] | Al llegar a 0 auto-finaliza solo y navega a resultados. |
| [ ] | [[../FINAL-07 - Segundo intento de evaluacion limpia (Multi-intento) ✅]] | El intento 2 arranca limpio, sin heredar nada del intento 1. |
| [ ] | [[../FINAL-04 - Adelantar el reloj del celular durante el examen ✅]] | Adelantar la hora del teléfono fuerza auto-finalización. |
| [ ] | [[../FINAL-03 - Atrasar el reloj del celular durante el examen ✅]] | Atrasar la hora no engaña al servidor: respuestas fuera de tiempo se rechazan. |
| [ ] |  | Agotar las alertas finaliza automáticamente y navega a resultados. |
| [ ] | [[../FINAL-13 - Doble tap en Finalizar ✅]] | Dos finalizaciones casi simultáneas no duplican la calificación. |
| [ ] | [[../FINAL-14 - Intento zombi con y sin intentos de sobra ✅]] | Un intento vencido sin entregar se auto-cierra (nuevo 11-sep). |
| [ ] | [[../FINAL-15 - La retroalimentacion no se desbloquea adelantando el reloj ✅]] | Adelantar la hora ya no desbloquea la clave de respuestas (nuevo 11-sep). |

## Al terminar

Actualiza el estado de cada casilla en su propia nota (sección "Estado" + "Observación — qué pasó
de verdad") y avísame si algo no coincide con lo esperado para revisarlo contra el código.
