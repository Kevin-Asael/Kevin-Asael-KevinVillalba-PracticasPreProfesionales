# FINAL-08 — Suite Maestra Automatizada Frontend y Backend

**Fecha:** 2026-09-10
**Módulos:** `utn_movil_app` (Flutter) + `utn-movil-portafolio-estudiante` (NestJS)
**Estado:** ✅ **Completado (91/91 pruebas exitosas, 0 fallos)** — cifras verificadas corriendo los comandos reales, no estimadas.

> Registro histórico de resultados del 2026-09-10. Las cifras corresponden a esa ejecución y no certifican la versión actual.

---

## Objetivo

Validar correcciones de concurrencia al finalizar y permitir pruebas controladas del cronómetro de Flutter. El mecanismo de control de evaluación ya existía; su suite de backend se reutilizó sin cambios. Se añadieron dos pruebas de concurrencia y una batería de cliente.

## 📊 Resumen Ejecutivo de Resultados

| Componente / Suite | Archivo | Tests | Resultado |
| :--- | :--- | :---: | :---: |
| Backend — `evaluacion_online.service.spec.ts` | incluye 63 tests preexistentes + 2 nuevos (INT-04a/b, candado de concurrencia) | **65 / 65** | ✅ |
| Backend — `anticopia.service.spec.ts` | preexistente, sin cambios | **13 / 13** | ✅ |
| **Backend — Total** | `pnpm test evaluacion_online` | **78 / 78** | ✅ 2 test suites |
| Flutter — `cronometro_bateria_test.dart` | CRON-01 a CRON-05 (nuevo) | **5 / 5** | ✅ |
| Flutter — `respuestas_bateria_test.dart` | RESP-01, RESP-02, RESP-04 + error de red (nuevo) | **4 / 4** | ✅ |
| Flutter — `anticopia_bateria_test.dart` | COPIA-01 a COPIA-04 (nuevo) | **4 / 4** | ✅ |
| **Flutter — Total** | `flutter test test/portafolio_estudiante/` | **13 / 13** | ✅ |
| Flutter — Análisis estático | `flutter analyze lib/.../evaluacion_online/ test/...` | — | ✅ 0 issues |
| Flutter — Suite completa del repo | `flutter test` (todo el proyecto) | **304 / 304** | ✅ sin regresiones |
| **TOTAL (backend + batería Flutter nueva)** | | **91 / 91** | ✅ |

---

## 🔒 Backend — candado de concurrencia (`evaluacion_online.service.ts`)

Se agregó `private readonly finalizacionesEnCurso = new Set<number>();` y se usa en:
- **`finalizarEvaluacion`** (pública): si el id ya está en el Set, lanza `ForbiddenException`
  ("Ya existe una finalización en curso..."); si no, lo agrega, ejecuta, y lo libera en `finally`
  (obligatorio, incluso si Oracle falla).
- Las demás vías de cierre del servicio comparten la protección de concurrencia descrita para esta versión.

**Tests nuevos (dentro de `describe('finalizarEvaluacion')`, no en archivo aparte — el repo separa
specs por clase bajo prueba, no por escenario):**
- **INT-04a** (secuencial): tras una finalización exitosa el candado se libera; una segunda llamada
  con la evaluación ya entregada según Oracle cae en la regla de negocio normal, no en el candado.
- **INT-04b** (concurrente, con `Promise.all`/promesa diferida): de dos finalizaciones simultáneas,
  solo una llega a Oracle (`finalizarEvaluacion` del repositorio llamado exactamente 1 vez), la
  otra recibe 403 de inmediato, y el candado queda libre para una tercera llamada legítima.

---

## ⏱️ Flutter — reloj de pared inyectable (`evaluacion_online_provider.dart`)

Se agregó `final DateTime Function() _relojParedBase;` (parámetro opcional `relojPared` en el
constructor, por defecto el tear-off `DateTime.now`) y se reemplazaron los 3 usos directos de
`DateTime.now()` en `_sembrarRelojExamen` y en el getter `_tiempoRestanteActual`. Sin impacto en el
comportamiento real del teléfono; se verificó que el único call-site de producción
(`dependencias_evaluacion_online.dart`) no se rompe (usa solo el parámetro posicional).

---

## 🧪 Desglose de la batería Flutter nueva (`test/portafolio_estudiante/evaluacion_online/bateria/`)

Greenfield total: el módulo no tenía ningún test previo. Stubs a mano (sin `mockito`/`mocktail`,
que no están en `pubspec.yaml` y no se agregaron), siguiendo el patrón de `test/modulo_eventos/`.

- **CRON-01:** siembra el cronómetro contra `horaServidorISO`, no contra el reloj del teléfono
  (verificado con un desfase de 3h entre ambos).
- **CRON-02:** atrasar el reloj de pared no regala tiempo — gana el reloj monotónico.
- **CRON-03:** adelantar el reloj de pared agota el tiempo y dispara auto-finalización — gana el
  máximo de ambos relojes.
- **CRON-04:** al llegar a 0 finaliza exactamente 1 vez, sin reintentos.
- **CRON-05:** un fallo de red al finalizar manualmente muestra `AppSnackBar` y reactiva el timer de
  UI sin resetear el cronómetro a los minutos iniciales.
- **RESP-01/02/04:** lógica pura de `EvaluacionOnlineFormHandler` — tipo 1 desmarca las demás
  alternativas, tipo 2 hace toggle sin afectar otras, tipo 6 actualiza un ítem de emparejamiento sin
  alterar los demás pares.
- **Error de red al responder:** se propaga de forma controlada, muestra `AppSnackBar`, la pantalla
  sigue interactiva (`AbsorbPointer` no bloquea) y no queda una respuesta "fantasma" marcada
  localmente (no hay cola offline: si falla la red, no se actualiza el estado local).
- **COPIA-01 a COPIA-04:** pruebas de integración del control existente con respuestas simuladas del backend y persistencia del estado del cliente. No validan la temporización real del mecanismo.

---

## 🛠️ Comandos de reproducción

```powershell
# Backend
pnpm test evaluacion_online
# → Test Suites: 2 passed, 2 total · Tests: 78 passed, 78 total

# Flutter
flutter analyze lib/apps/portafolio_estudiante/evaluacion_online/ test/portafolio_estudiante/
flutter test test/portafolio_estudiante/
# → No issues found · 13 tests passed
```

---

## 🧹 Limpieza

Por política del repo `utn_movil_app` (no dejar archivos de test sin commitear que no formen parte
del alcance del commit de producción), la carpeta
`test/portafolio_estudiante/evaluacion_online/bateria/` se eliminó del working tree tras validar que
todo pasaba. El código fuente de los 6 archivos (3 de test + 3 fakes) queda respaldado en
`codigo_tests/` junto a esta documentación, por si se decide reincorporarlos al repo más
adelante. Los tests de Jest del backend (INT-04a/b) sí se conservan en el repo.
