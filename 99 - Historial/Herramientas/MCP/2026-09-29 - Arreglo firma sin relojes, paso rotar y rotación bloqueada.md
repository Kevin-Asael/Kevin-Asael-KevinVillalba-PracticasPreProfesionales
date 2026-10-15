# 2026-09-29 — `desplazar` con firma sin relojes, paso `rotar` y rotación bloqueada por la app

**MCP:** mcp-utnmovil · **Estado:** resuelto y validado en el emulador (emulator-5554, <cuenta-de-prueba>, MCP-E06 = actividad 627187).

## 1. `desplazar{hasta}` de verdad arreglado
- El primer arreglo (nota «Doble toque en Finalizar…») no se activaba: el cronómetro de la evaluación («Tiempo: 00:14:xx») cambia el texto cada segundo, así que el árbol nunca parecía igual tras un swipe.
- Nueva `firmaEstable` en `src/ui.ts` (quita `hh:mm[:ss]`), usada por `esperarCambio` y por `desplazar`. Respaldo: `ui.ts.bak` en scratchpad sesión b836cae5.
- Medido con la evaluación abierta: `desplazar hasta FINALIZAR` **~8 s y falla → 1,5 s ✓**; texto inexistente **~8 s → 1,0 s ✗ con mensaje claro** («la lista no se movió»).

## 2. Nuevo paso `rotar{orientacion:horizontal|vertical}` en `movil_guion`
- `src/guion.ts`: fija `accelerometer_rotation=0` + `user_rotation`, y **siempre vuelve a vertical y restaura el valor original al cerrar el guion** (igual que la red).
- Devuelve la rotación real del sistema (`dumpsys window displays`) y el x máximo del árbol, para no dar por hecho que giró.
- Esquema del guion ahora ~3,4k tokens.

## 3. Hallazgo: la app no rota
- Tras pedir horizontal, el sistema reporta 0° y las coordenadas no cambian.
- Causa: `utn_movil_app/lib/main.dart:98-100` fija `SystemChrome.setPreferredOrientations([portraitUp, portraitDown])`.
- Conclusión: **la prueba «rotar durante la evaluación» no aplica** — la app no puede girar. Respuestas y cronómetro no se alteraron.

## 4. Prueba en E06 (gastó el último intento)

## Trampas
- Mapeo real: **MCP-E0N = ID_ACTIVIDAD 627181+N** (E04=627185, E06=627187). Verificado con logs de `finalizar` (id 18517957 ↔ 627187).
- Consultas a Oracle y curl: solo con filtro de cédula `<cedula>` / `<cedula>` (pedido explícito del usuario).
- `consultar` y una llamada de la app en paralelo se pisan: la lectura puede adelantarse a la escritura.

## Pendientes
1. Acelerar `abrir_evaluacion` (13–15 s, el paso más lento).
