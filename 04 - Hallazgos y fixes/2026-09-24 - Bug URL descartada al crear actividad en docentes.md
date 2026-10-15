# Bug: la URL de la actividad se descarta al crearla (docentes)

**Fecha:** 2026-09-24
**Estado:** 🎯 pendiente. Solo diagnosticado, sin corregir.
**Repo:** `utn-movil-portafolio-docentes` (backend) frente a `utn_movil_app` (cliente)

## Qué pasa
Al crear una actividad de tipo **Microsoft Forms 365 (3)**, **Otras Plataformas (4)** o **Clase Sincrónica (7)**, el docente llena el campo URL en la app, pero en Oracle `LMS_TAB_ACTIVIDAD_ACADEMICA.URL` queda en `NULL`.

## Causa (verificada contra el código)
Las dos listas de tipos están al revés una respecto de la otra:

- **Cliente**, `lib/apps/portafolio_docentes/actividad_docente/presentation/providers/tipos_actividad_provider.dart:35`: `urlCodigos = ['3','4','6','7','21','22']` → **muestra** el campo URL para esos tipos.
- **Backend**, `src/modules/actividad/actividad.service.ts:213-214` (crear) y `:364-365` (actualizar): `tiposSinUrl = [3, 4, 6, 7, 21, 22]` → **descarta** la URL para esos mismos tipos. El comentario dice que en APEX se oculta el campo para esos tipos.
- Origen: commit `55c48dd8` (2026-03-12).
- El procedimiento nuevo `db/cambios/003_mvl_prc_guardar_actividad_docente.sql` sí recibe y guarda `pUrl`. El problema es solo el filtro del servicio.

## Evidencia de que el backend está invertido
Datos históricos en la réplica de desarrollo (`COUNT(URL)` por tipo):

| Tipo | Total | Con URL |
|---|---|---|
| 1 Respuesta con Adjunto | 408.226 | 7.543 (2 %) |
| 2 Dentro de la Plataforma | 41.871 | 395 (1 %) |
| 3 Microsoft Forms | 15.124 | 10.793 (71 %) |
| 4 Otras Plataformas | 6.585 | 2.573 |
| 6 | 4.214 | 3.293 |
| 7 Clase Sincrónica | 56.199 | 49.573 (88 %) |
| 21 | 10.537 | 2.545 |
| 22 | 13.654 | 3.865 |

Actividades de prueba creadas con la macro del MCP que quedaron con `URL = NULL` pese a enviarla: 627173 (tipo 4), 627176 (tipo 3) y 627179 (tipo 7).

## Impacto
Las evaluaciones en Forms u otras plataformas y las clases sincrónicas creadas desde la app quedan **sin enlace**, y el estudiante no tiene dónde entrar.

## Arreglo propuesto (sin aplicar)
Invertir la condición en los dos puntos del servicio: guardar la URL **solo** para `[3, 4, 6, 7, 21, 22]` y poner `null` para los demás. También corregir el comentario.
