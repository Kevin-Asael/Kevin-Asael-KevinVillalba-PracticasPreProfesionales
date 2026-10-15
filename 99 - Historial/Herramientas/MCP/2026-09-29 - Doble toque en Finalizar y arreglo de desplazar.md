# 2026-09-29 — Doble toque en Finalizar y arreglo de `desplazar`


## Prueba: doble toque rápido en «Finalizar»
- Emulador emulator-5554, <cuenta-de-prueba>, MCP-E04 (actividad 627185, ID_ACTIVIDAD_ALUMNO 18517951).
- Dos toques de 20–30 ms sobre FINALIZAR y otros dos sobre el «Finalizar» del diálogo.

## Bug del MCP: `movil_guion desplazar{hasta}`
- `src/guion.ts`: exigía `y < ABAJO-150` (1980) para dar por visible el elemento. La barra FINALIZAR está fija en y=2267, así que nunca cumplía: 8 swipes inútiles (~8 s) y falla.
- Arreglo: tras cada swipe compara la firma del árbol; si no cambió (fin de lista) da por visible el elemento si existe, o falla al instante. Respaldo: `guion.ts.bak` (scratchpad sesión b836cae5).

## Trampas aprendidas
- Mapeo real: MCP-E01..E09 = ID_ACTIVIDAD 627182..627190 (E04 = 627185). Consultar Oracle con cédula sin la «E» (`<cedula>`).
- `abrir_evaluacion` tarda ~13 s: siguiente candidato a optimizar.

## Pendientes
1. Validar el arreglo de `desplazar` en vivo.
2. Acelerar `abrir_evaluacion`.
3. Prueba de rotación de pantalla durante una evaluación.
