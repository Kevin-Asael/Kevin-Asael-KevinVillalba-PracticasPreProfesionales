# Conectividad en Evaluación en Línea — aviso no bloqueante y cola offline pendiente

**Fecha:** 2026-09-07
**Repo:** `utn_movil_app`
**Estado del cambio:** sin commitear en el working tree al momento de escribir esta nota.

---

## 1. El hallazgo

Antes de este cambio, `ConnectivityWrapper` (global, envuelve toda la app) mostraba un
**overlay bloqueante** (`NoInternetOverlay`) apenas se perdía la conexión, sin importar en
qué pantalla estuviera el usuario — incluida una evaluación en línea en curso.

El problema de fondo: si el estudiante pierde señal **mientras responde un examen**, la
según , es donde se guarda el "Estado de Examen en Vivo"). No es que

Overlay bloqueante global + examen con cronómetro corriendo = el estudiante queda atrapado
sin poder seguir respondiendo justo cuando más le urge el tiempo.

---

## 2. Cambio de interfaz aplicado (verificado línea por línea en el diff)

Archivos nuevos:
- `lib/apps/auth/auth_aux/domain/services/conectividad_overlay_controlador.dart`
- `lib/apps/portafolio_estudiante/evaluacion_online/presentation/widgets/evaluacion_online_conectividad_wrapper.dart`
- `lib/apps/portafolio_estudiante/evaluacion_online/presentation/widgets/aviso_sin_conexion_evaluacion_widget.dart`
- `lib/apps/portafolio_estudiante/evaluacion_online/presentation/widgets/franja_sin_conexion_widget.dart`

Archivos modificados:
- `lib/apps/auth/auth_aux/presentation/widgets/connectivity_wrapper.dart`
- `lib/apps/auth/auth_aux/domain/services/conectivity_service.dart`
- `lib/apps/portafolio_estudiante/evaluacion_online/presentation/pages/formulario_evaluacion_online_page.dart`
- `lib/apps/auth/auth_aux/dependencias_auth_aux.dart` (registro DI)

**Qué hace:**

1. `ConectividadOverlayControlador` — nuevo singleton (`get_it`) con un
   `ValueNotifier<bool> overlayGlobalActivo`. Permite que una pantalla puntual "suprima" el
   overlay bloqueante global sin tocar el árbol de widgets del resto de la app — evita
   desmontar/remontar toda la app en cada cambio de conectividad (`ConnectivityWrapper`
   vive por encima del `Navigator`).
2. `EvaluacionOnlineConectividadWrapper` — envuelve la pantalla de evaluación en línea. Al
   montarse llama `overlayControlador.suprimir()`; al desmontarse, `restaurar()`. Escucha
   el stream de `ConnectivityService` y, en vez del overlay global, muestra
   `AvisoSinConexionEvaluacionWidget`: un modal que el estudiante puede cerrar ("Continuar
   con la evaluación") y que además se auto-cierra solo en cuanto vuelve la red.
3. `FranjaSinConexionWidget` — franja de una línea ("Sin conexión") en el encabezado de la
   evaluación, visible mientras no hay red, desaparece sola al reconectar.
4. Resultado: el estudiante ya no queda bloqueado por el overlay global durante un examen
   si pierde señal momentáneamente. Ve un aviso, lo cierra, y sigue respondiendo con el
   cronómetro corriendo, conservando los controles existentes de la evaluación.

---

## 3. Lo que este cambio NO resuelve (dicho explícitamente en el propio código)

`evaluacion_online_conectividad_wrapper.dart`, comentario de la clase:

> "No resuelve la pérdida de respuestas sin conexión (eso lo hace la cola offline,
> pendiente); solo evita que la pantalla quede bloqueada."

O sea: si el estudiante responde una pregunta estando sin conexión, esa respuesta se puede
perder igual. Este cambio solo mejora la experiencia del aviso, no la persistencia del dato.

---

## 4. Buffer/cola offline — 🚫 DESCARTADO PERMANENTEMENTE (Corrección 2026-09-17)

> [!WARNING]
> **Corrección y Fe de Erratas (2026-09-17):**
> La implementación del buffer/cola offline (`ColaRespuestasStorage` / `SincronizadorRespuestas`) descrita a continuación fue un experimento exploratorio en el *working tree* que **se descartó de forma permanente** en las sesiones del 2026-09-10/11 y **NUNCA fue commiteada ni integrada** en ninguna rama de `utn_movil_app`.

---

### Registro del diseño exploratorio (No commiteado / Descartado):

**Cómo funciona, verificado en el código:**

- `ColaRespuestasStorage` / `ColaRespuestasStoragePrefs` — la cola vive en `SharedPreferences`
  (no en Drift, como se especulaba antes). Cada respuesta se guarda ahí **antes** de intentar
  la llamada de red (`evaluacion_online_provider.dart`, `responderPreguntaSinLoading`), así
  que aunque el POST falle, la respuesta ya quedó a salvo en el celular.
- `SincronizadorRespuestas` — vacía la cola contra el servidor. Se dispara por dos vías: (1)
  al detectar que volvió la conexión, con 3 segundos de espera para no reintentar contra una
  de servidor caído con WiFi intacto (que no dispara ningún evento de conectividad). El
  vaciado es secuencial: si una respuesta falla por red, se aborta el resto hasta el próximo
  intento; si falla con un error 4xx del servidor (ej. el examen ya expiró), esa respuesta se
  marca como fallida definitiva y no se reintenta más.
- `FranjaSinConexionWidget` — el punto de enganche visual que se había reservado ya se usa: la
  franja ahora muestra "Sin conexión — N respuestas se enviarán al reconectar" y, al volver la
  red, "Enviando N respuestas…" hasta que la cola queda en cero.

**Las tres preguntas abiertas de la versión anterior de esta nota, resueltas:**

- *¿Dónde vive la cola?* → `SharedPreferences`, no Drift.
- *¿Qué pasa si el examen se cierra con respuestas aún sin sincronizar?* → Depende de cómo se
  cierre, verificado paso a paso en `evaluacion_online_provider.dart`, método
  `finalizarEvaluacion` (líneas 235-274):

  1. Al tocar **"Finalizar"** a mano, el provider primero intenta vaciar el buffer
     (`_sincronizadorRespuestas.vaciar(...)`, línea 253) — un último intento antes de seguir.
  2. Si quedan respuestas pendientes tras eso, se muestra un aviso explícito (texto exacto en
     líneas 341-354): *"Tienes N respuestas sin enviar. Si finalizas ahora se perderán."*, con
     botones **"Seguir intentando"** / **"Finalizar de todos modos"**.
  3. Si el estudiante toca **"Finalizar de todos modos"**, el provider marca la evaluación como
     entregada en el servidor (línea 265) y **acto seguido borra el buffer local completo**
     (`_colaRespuestasStorage.limpiar(...)`, línea 273) — sin importar si esas respuestas
     llegaron a guardarse en Oracle o no. Si nunca llegaron, en ese momento se pierden para
     siempre. Hay aviso previo, así que no es una pérdida silenciosa, pero sí es irreversible
     una vez confirmado.
  4. Si el cierre es **automático** (tiempo agotado o control de evaluación, rama `esAutoFinalizar=true`,
     líneas 266-270) **no hay ningún aviso posible** — el comentario del propio código dice "no
     hay a quién preguntarle". Se reintenta la llamada de finalizar hasta 5 veces con backoff
     (`_finalizarConBackoff`, líneas 319-332), pero no las respuestas individuales pendientes:
     el buffer se borra igual al terminar (línea 273 corre para los dos casos).

- *¿Cómo se reconcilia con el temporizador del backend si el examen ya cerró?* → Aquí entra un
  hallazgo nuevo y **todavía sin resolver**: el backend calcula la hora de fin del examen
  usando el reloj de Oracle, que tiene un desfase de 5 horas respecto a la hora real de Ecuador
  (`SYSDATE` devuelve UTC). Investigación completa, con hipótesis y pendientes, en
  `07 - Documentacion/2026-09-07 - Investigacion abierta - reloj de Oracle en evaluacion online.md`.

---


Aparte del buffer del cliente, hacía falta un cambio en el backend (`utn-movil-portafolio-estudiante`)
para que tolerara los reintentos que ese buffer produce.

**El problema:** `toggleRespuestaMultiple` (preguntas de opción múltiple, `tipoPregunta=2`)
hacía un `INSERT` directo al marcar una alternativa, sin desactivar la fila anterior. Si el
buffer offline reintentaba el mismo envío (porque el celular nunca llegó a ver el 204 de
confirmación, aunque el servidor sí hubiera guardado la respuesta), el segundo intento
duplicaba la fila `ESTADO='A'` en `LMS_TAB_RESPUESTAS_ESTUDIANTE`.

**El fix:** `src/modules/evaluacion_online/repository/evaluacion_online.repository.ts`, rama
`marcado=true` de `toggleRespuestaMultiple` — ahora corre dentro de una transacción que
desactiva la fila previa (`UPDATE ... SET ESTADO='I'`) antes de insertar la nueva, igual que
ya hacía `guardarRespuestaEmparejar`.

**Verificación end-to-end, hecha en esta sesión:**
   devolvieron 204.
2. Consulta directa a Oracle (`SELECT COUNT(*) WHERE ESTADO='A'`) → dio **1**, no 2. Confirma
   que el fix funciona de verdad, no solo que no da error.

**Estado:** commiteado (`26db164`) y pusheado a `practicas-preprofesionales`, lo que dispara
vivo ahí.

---

## 6. Estado

| Ítem | Estado |
|---|---|
| Aviso no bloqueante en evaluación online | ✅ Implementado (sin commitear en `utn_movil_app`, 2026-09-07) |
| Cola/buffer offline en el cliente (`SincronizadorRespuestas` + `ColaRespuestasStorage`) | 🚫 Descartado permanentemente (nunca commiteado en `utn_movil_app`) |
| Bug de reloj de Oracle (`SYSDATE` en UTC vs. hora de Ecuador) | 🎯 Pendiente — investigación propia: `07 - Documentacion/2026-09-07 - Investigacion abierta - reloj de Oracle en evaluacion online.md` |
