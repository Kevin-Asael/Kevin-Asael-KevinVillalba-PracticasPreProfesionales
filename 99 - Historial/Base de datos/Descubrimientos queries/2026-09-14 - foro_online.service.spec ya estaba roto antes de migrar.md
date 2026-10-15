# `foro_online.service.spec.ts` ya estaba roto — no lo rompió la migración a vistas

**Fecha:** 2026-09-14
**Repo:** `utn-movil-portafolio-estudiante`
**Archivo:** `src/modules/foro_online/tests/foro_online.service.spec.ts`
**Contexto:** apareció al correr `pnpm test`/`npx jest foro_online` como verificación de
[[2026-09-14 - Como trabajamos la migracion de queries a vistas (continuidad)|la migración del
piloto foro_online]] a vistas/funciones Oracle.

## Qué se encontró

El *test suite* completo falla en **compilación de TypeScript** (0 tests corren, falla antes de
ejecutar nada). Son 3 tipos de error, todos por desajuste entre el spec y los tipos reales del
código — no son fallos de lógica de negocio:

1. **`idActividad`/`idForo` pasados como `string` donde el tipo real es `number`.**
   Ejemplos: `service.eliminarForo(cedulaMock, idForoMock)` con `idForoMock` de tipo `string`;
   un objeto con `idActividad: '10'` (string) donde `CrearForoActividadBody.idActividad` es
   `number`; también pasa con `'90569'` como argumento.
2. **Uso de una propiedad `foto` que no existe en `AutorForoDto`.**
   `result.autores['A123456789'].foto` — el DTO real (`src/modules/foro_online/dto/autor_foro.dto.ts`)
   tiene `nombre`, `fotoUrl`, `genero`. No hay `foto`.

## Cómo se verificó que no es por la migración

Con el permiso puntual del usuario (2026-09-14, uso **exclusivo** para comparar, nunca para cambiar
de rama ni traer remoto), se guardaron los 7 archivos modificados de la migración con `git stash`,
se corrió `npx jest foro_online` sobre el código **tal cual estaba antes de tocar nada**, y falló
con los mismos errores exactos. Luego `git stash pop` restauró los cambios sin pérdidas
(`git status` idéntico antes/después). O sea: el spec ya estaba desactualizado respecto al código
real desde antes — probablemente alguien cambió las firmas de `eliminarForo`/`CrearForoActividadBody`
o el DTO `AutorForoDto` y no actualizó este archivo de test.

## Impacto

- No bloquea la migración a vistas/funciones: el código de producción compila y corre bien
  (`pnpm run build` pendiente de confirmar, pero el servicio local arrancó y respondió igual antes y
  después del cambio).
- Si sigue así, **no hay cobertura de test automatizada para `foro_online`** — cualquier regresión
  futura en ese módulo no la va a atrapar `pnpm test`.

## Estado

**Pendiente** — no se arregló, porque no era parte del encargo de esta sesión (migrar `SELECT` a
vistas). Queda para quien lleve `foro_online` decidir si corrige el spec (ajustar los tipos de los
mocks y quitar/corregir la referencia a `foto`) o lo reemplaza.
