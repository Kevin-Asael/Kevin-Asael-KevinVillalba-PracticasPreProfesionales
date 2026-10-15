# Dashboard Maestro — Plan de Pruebas Finales (Evaluaciones en Línea)

**Fecha:** 2026-09-21 · **Módulos:** `utn_movil_app` (Flutter) + `utn-movil-portafolio-estudiante` (NestJS)  
**Entorno de validación:** teléfono Android 14 (Samsung Galaxy S24 FE) y backend local  
**Estado General:** 🟢 **100% Completado en Dispositivo (15/15 validados)** · 🟢 **100% Automatizado (91/91 pruebas pasadas)**

---

## 🏆 1. Casos Validados en Celular con Evidencia Real (15/15 Aprobados)

Todos estos casos fueron ejecutados en la app compilada en el teléfono físico y **coinciden al 100% con la lógica esperada**:

| Caso | Qué Valida | Estado | Observación / Evidencia Registrada en el Dispositivo |
| :--- | :--- | :---: | :--- |
| [[FINAL-02 - Pasan los 5 minutos y autofinaliza por tiempo ✅\|FINAL-02]] | **Expiración natural** | [x] Coincide | *"Paso exactamente lo del código."* (Al llegar a 00:00:00 entrega solo y redirige a resultados). |
| [[FINAL-03 - Atrasar el reloj del celular durante el examen ✅\|FINAL-03]] | **Anti-trampa atraso reloj** | [x] Coincide | *"Cuando se terminan los minutos lo que pasa es que alerta que 5 respuestas no se pudieron enviar."* (403 Forbidden en servidor). |
| [[FINAL-04 - Adelantar el reloj del celular durante el examen ✅\|FINAL-04]] | **Adelanto de reloj** | [x] Coincide | *"Se finaliza automáticamente la prueba. Tal cual"* (Reloj dual detecta tiempo agotado de inmediato). |
| [[FINAL-07 - Segundo intento de evaluacion limpia (Multi-intento) ✅\|FINAL-07]] | **Segundo intento limpio** | [x] Coincide | *"Tal cual como describe los puntos a comprobar"* (Arranca con los 5 min completos y sin estado sucio del intento 1). |
|  | **Expulsión por alertas agotadas** | [x] Coincide | *"Se muestra tal cual la pantalla de 'Evaluación finalizada'"* (Navega a resultados con nota real). |
| [[FINAL-13 - Doble tap en Finalizar ✅\|FINAL-13]] | **Concurrencia backend** | [x] Coincide | *"Pasa bien tal como se comprobo en puntos clave"* (Candado in-memory evita duplicar envío a Oracle). |
| [[FINAL-14 - Intento zombi con y sin intentos de sobra ✅\|FINAL-14]] | **Auto-cierre intento zombi** | [x] Coincide | *"Ahora si coincide los intentos."* (Zombi se auto-cierra; permite reanudar o bloquea según intentos disponibles). |
| [[FINAL-15 - La retroalimentacion no se desbloquea adelantando el reloj ✅\|FINAL-15]] | **Seguridad clave de respuestas** | [x] Coincide | *"Se elevo el tiempo en retroalimentacion y funciono tal cual como el codigo. Ademas previo a que cierre salio sin respuestas."* |
| [[FINAL-16 - Auto-finalizar en el limite exacto no debe dejarte sin salida ✅\|FINAL-16]] | **Resiliencia UI en auto-finalización** | [x] Coincide | Parte A validada. Parte B: al expirar con WiFi apagado, muestra overlay con "Reintentar" y "Volver" (sin spinner infinito). Al reactivar WiFi y reintentar, entrega con éxito. |
|  | **Aislamiento anti-copia** | [x] Coincide | *"Se detecta la salida. se mandan las respuestas tal como deberia."* (Marca vieja de salida no auto-finaliza el intento nuevo). |
| [[FINAL-18 - Intentos restantes no se refresca al volver del formulario ✅\|FINAL-18]] | **Refresco de estado al hacer Back** | [x] Coincide | Al finalizar intento y volver a la tarjeta de actividad con Back, el texto "Intentos restantes" se decrementa inmediatamente (3->2, 2->1, 1->0) sin recarga manual. |

---

## 🤖 2. Suite Automatizada y Contexto Técnico

| Componente | Detalle / Archivo | Pruebas | Resultado |
| :--- | :--- | :---: | :---: |
| **Backend (NestJS)** | `src/modules/evaluacion_online/tests/evaluacion_online.service.spec.ts` + `anticopia.service.spec.ts` | **78 / 78** | ✅ Aprobado |
| **Frontend (Flutter)** | Baterías in-memory en `codigo_tests/` (`cronometro_bateria_test.dart`, `respuestas_bateria_test.dart`, `anticopia_bateria_test.dart`) | **13 / 13** | ✅ Aprobado |
| **Suite Completa Repo** | `flutter test` (todo el proyecto móvil) | **304 / 304** | ✅ Sin regresiones |
| **Reporte Detallado** | [[FINAL-08 - Suite Maestra Automatizada Frontend y Backend ✅\|FINAL-08]] | **91 / 91** | ✅ Completado |

---
