# 2026-09-18 — Tests preexistentes rotos en foro_online (utn-movil-portafolio-estudiante)

## Qué se encontró

Al correr la suite completa (`pnpm test`, no solo la de `evaluacion_online`) en
`practicas-preprofesionales` tras el merge de anti-copia (ver nota del mismo día sobre ese merge),
aparecen **7 suites / 20 tests fallando**, todos dentro de
`src/modules/foro_online/tests/foro_online.service.spec.ts`:

- `TS2345`: se pasa un `string` (`'90569'`) donde el tipo espera `number`.
- `TS2339`: se accede a `result.autores['A123456789'].foto`, propiedad que ya no existe en
  `AutorForoDto`.

## Por qué no es del merge de anti-copia

`git diff --stat 18138f6 bcacc09 -- src/modules/foro_online` no devuelve nada — el merge no tocó
ni un archivo de `foro_online`. Los tests ya estaban rotos en el commit previo al merge
(`18138f6`, el de la migración de queries a vistas/procedimientos).

## Hipótesis sin confirmar

Probablemente relacionado con la migración de queries a vistas del módulo `foro_online` (ver
pudo haber cambiado el tipo de algún ID o el shape de `AutorForoDto` sin actualizar los tests.
Sin verificar contra el código todavía — queda pendiente investigar la causa raíz.

## Estado

**Pendiente de investigar.** No bloquea el trabajo de anti-copia/evaluación, pero la suite
completa de `practicas-preprofesionales` no está en verde por esta razón, aparte del bug de Oracle
documentado en la otra nota de hoy.

---

## Corrección 2026-09-23 (verificado contra el código)

Dos cosas de arriba estaban mal:
1. **No son todos de `foro_online`.** Los 20 tests fallidos están repartidos en 7 suites: `foro_online` (1 suite), `documentos` (4), `becas` (1) y `evaluacion_docentes` (1).
2. **No los rompió la migración de queries.** Los mismos 7 suites / 20 tests fallan en `origin/main` (código extraído con `git archive` y `jest` corrido aparte). Son tests viejos que quedaron desactualizados cuando alguien cambió el código y no actualizó el test:

| Suite | Por qué falla | Commit que lo desactualizó |
|---|---|---|
| `foro_online.service.spec.ts` | Ni compila: el test pasa `'90569'` (texto) donde ahora se espera un número, y lee `autores[...].foto`, que ya no existe. | `29d4b66` (Jordan, 2025-10-06): cambió los tipos de los parámetros. |
| `documentos.service.*.spec.ts` (4) | `DocumentosService` ahora necesita `DocumentosDirectorioService` y el módulo de test no lo provee (`Nest can't resolve dependencies`). | `b033904` (Jordan, 2025-08-31) |
| `becas.service.spec.ts` | El mock de `DocumentosService` solo tiene `generarCertificado`; el servicio llama además a `generarCertificadoHistorialAcademicoBecas`. | `06d0d66` (Jordan, 2026-03-03) |
| `evaluacion_docentes.service.spec.ts` | Se cambiaron textos de mensajes ("docentes pendientes de evaluación", "Preguntas respondidas: …") y la firma de `contarPreguntasTotales`; el test sigue esperando lo viejo. El módulo además está comentado en `app.module.ts`. | `777fb53` (Jordan, 2026-02-26) y otros |

**Estado:** causa conocida. No afectan el funcionamiento de la app (son los tests los que están desactualizados, no el código). Arreglarlos es opcional y no es parte de la auditoría de ramas.

## ✅ Resuelto 2026-09-23 (sin commitear, working tree de `practicas-preprofesionales`)

Resultado: `pnpm test` pasa **39/39 suites, 403/403 tests** (antes 32/39 y 354/374). El build está limpio. Solo cambiaron archivos `*.spec.ts`; el código de la app no se tocó.

| Archivo | Qué se actualizó |
|---|---|
| `foro_online/tests/foro_online.service.spec.ts` | IDs como número (`idCurso`, `idActividad`, `idPadre`, `idForo`). Se agregó el mock del `Logger` de nestjs-pino y de `getAutoresForo`/`validarActividad`/`obtenerTipoForo`. Los autores se esperan con `fotoUrl` (`/shared/foto-persona/<cédula>?thumbnail=true`) en lugar de `foto` en base64. **9 tests nuevos** para las reglas actuales: no se puede editar un comentario con respuestas, los eliminados sin hilo se ocultan, no se puede editar ni eliminar en una actividad vencida o inactiva, BadRequest si el foro no existe, Conflict al responder en una actividad vencida. |
| `documentos/tests/documentos.service.get{CertificadoEvento,HistorialCertificados,DocumentosElectronicosPersonales,LinkCarnetEstudiante}.spec.ts` | Se agregó el mock de `DocumentosDirectorioService` (la nueva dependencia de `DocumentosService`). |
| `becas/tests/becas.service.spec.ts` | El mock de `DocumentosService` ahora incluye `generarCertificadoHistorialAcademicoBecas` y `generarCertificadoNotasBeca`. `generarCertificado` se espera **3** veces (no 4) y se verifica la llamada a los dos métodos nuevos. |
| `evaluacion_docentes/tests/evaluacion_docentes.service.spec.ts` | Textos de error actualizados ("docentes pendientes de evaluación", "Preguntas respondidas: X de Y"). `contarPreguntasTotales` ahora recibe el contexto completo, no solo el código. |
