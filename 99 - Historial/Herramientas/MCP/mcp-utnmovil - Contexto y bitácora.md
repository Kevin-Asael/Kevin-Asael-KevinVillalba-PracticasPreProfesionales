# Contexto: MCP de pruebas ADB para UTN Móvil (handoff 2026-09-24)

## Objetivo
Un MCP propio que haga pruebas en el celular con el mínimo de tokens y lo más rápido posible. Primer caso: **crear actividades del docente** de punta a punta, con una sola llamada.
Plan original: `%USERPROFILE%\<escritorio>/PLAN-MCP-PRUEBAS-ADB.md` (modos A/B/C, 8 herramientas, fases F0–F5).
Plan de pruebas de referencia: `Obsidian Vault\07 - Documentacion\Resumen de ramas\app\2026-09-23 - Plan de pruebas app con ADB (Antigravity).md`.

## Dónde vive
- `src/agente.ts` + `agente/Agente.java` → **agente persistente** en el teléfono (`app_process` con `uiautomator.jar`, usa `UiAutomationShellWrapper`):
  - responde por stdin/stdout;
  - `d` = volcado (~5–13 ms, contra 2.300 ms de `uiautomator dump`);
  - `t x y` = toque (~40 ms);
  - `s x1 y1 x2 y2 ms` = deslizamiento; mantiene el dedo quieto 80 ms antes de soltar para evitar el fling;
  - `k code` = tecla;
  - `v _` = "ok" si hay teclado (ventana IME vía getWindows, ~20 ms; reemplaza `dumpsys input_method` de ~280 ms);
  - `w x y texto` = `ACTION_SET_TEXT` (**Flutter solo lo acepta si el campo tiene foco**: primero tocar).
  - Se sube solo como `/data/local/tmp/agente-<tamaño>.jar`, se cierra tras 60 s sin uso y, si falla, se vuelve a `uiautomator dump` / `input`.
  - Compilar el jar: `javac -source 11 -target 11 -cp android-36/android.jar` → `d8 --min-api 26` → `jar cf agente.jar classes.dex` (SDK en `%LOCALAPPDATA%\Android\Sdk`).
- `src/ui.ts`: `Pantalla` (volcar, tocar, deslizar, tecla, fijarTexto, escribir, esperar, `esperarCambio(antes, ms, quietoMs)`), `compactar` (`*texto@x,y`, `[x]` = marcado, `✎` = campo de texto), `buscar` (exacto > empieza por > contiene, sin tildes), `diff`.
- `src/macros.ts`: `crearActividadDocente` + `completarPreguntas`.
- `src/semillas.ts`: acciones metódicas con coordenadas aprendidas en `semillas-cache.json`.
- `src/red.ts`: cortar/restaurar la red con **restauración automática garantizada** (tope 120 s, y también al cerrar el servidor).
- Scripts de depuración: `probar.mjs <tool> '<json>'` (mide bytes y ms) y `explorar.mjs "tTexto" "s600" b v` (tocar/desplazar/atrás/ver).

## Herramientas (13)
- `movil_crear_actividad_docente`:
  - Parámetros: materia, titulo, politica, tipo, instrucciones, intentos, url, seleccion (**def. sorteo**), plataforma, horas/minutos (**def. 0 h 1 min**), preguntas (def. true), **ensayo** (llena y cancela sin guardar), verificar_bd.
  - Arranca desde cualquier pantalla (inicio / materias / aula / formulario sucio → Cancelar / pantalla desconocida → Regresar).
  - Si aparece «Error al cargar la actividad», toca «Reintentar» hasta 2 veces.
  - Un título que empieza con `RASTRO ` imprime los campos por stderr (depuración).
- `movil_leer_pantalla` (compacto, `filtro`, `json` antiguo) y `movil_tocar_texto` (devuelve un diff, o «pantalla nueva»).
- Heredadas de Antigravity: movil_dispositivos, capturar, tocar, deslizar, escribir, tecla, controlar_red (ahora con restauración automática y sin modo avión), abrir_app (detecta la build Dev/Beta), ejecutar_secuencia.

## Restricciones (pedidas por el usuario)
- Solo **MATERIA DE PRUEBA**; cuentas **<cuenta-de-prueba> / <cuenta-de-prueba>**. La macro rechaza cualquier otra. Oracle: solo lectura.
- **No crear actividades sin permiso explícito** (la BD de dev se está llenando). Para medir, usar `ensayo:true`.
- **No tocar wifi/datos sin permiso**, y si se tocan, restaurarlos en el mismo paso. (Ya pasó una vez que el wifi quedó apagado.)

## Mapa de la app (docente)
- Inicio «Aplicaciones disponibles» → «Portafolio Docente» → lista de materias → «Aula Virtual» de la tarjeta → aula (botón «Crear» en 900,2174) → formulario por tarjetas (barra fija Cancelar/Crear en y≈2225; sube si el teclado está abierto).
- Políticas: Exámenes, Pruebas, Clase Virtual Síncrona, Trabajos, Participación en foros. Las opciones de la hoja aparecen **después** de la animación: hay que esperar la opción concreta.
- Tipos (Exámenes/Pruebas/Trabajos/Foros): Respuesta con Adjunto (1), Evaluación Online Dentro de la Plataforma (2), Microsoft Forms 365 (3), Otras Plataformas (4). Clase Virtual: Clase Sincrónica (7), Consulta (41).
- «Dentro de la Plataforma» muestra «Cómo se rinde»: Manual/Sorteo, Portafolio web/App móvil, tiempo en h y min.
  - Al crearla, la app abre sola **«Sortear Preguntas»** (sorteo) o **«Agregar Preguntas»** (manual).
  - En Agregar Preguntas: «Preguntas Disponibles» viene plegado → tocarlo → casillas en x≈146. Al marcar la primera aparece «N seleccionadas» y la lista baja ~150 px. Luego «Agregar (N)» → diálogo «Se agregarán N preguntas» → «Agregar».
  - Posible bug de la app, sin verificar: después de agregar la pantalla seguía mostrando «5 seleccionadas».
- Tipos con URL (3, 4, 7, …): `EditText` sin etiqueta debajo del campo Tipo.

## Mediciones
- Modo A (XML crudo): ~69k tokens por creación. Primera prueba paso a paso (modo B): ~29k tokens de sesión. MCP: 1 llamada, ~40 tokens de respuesta más ~2,5k del esquema.
- Tiempo, del primer MCP a ahora: 38,5 s → 8,3 s → 7,1 s → **5,3–5,5 s hasta antes de Crear** («Dentro» completo, 3/3 estables); Forms ~4,3 s. Guardar ≈ 1 s; la verificación en BD bajó de 2,5 s a 0,3 s porque Oracle se precalienta en paralelo al iniciar la macro.
- Por fase («Dentro»): aula 0,5 · contenido 0,8 · política 1,1 · tipo 1,0 · cómo se rinde 1,4 · intentos 0,1.
- Optimizaciones ya aplicadas: escribir = tocar + `ACTION_SET_TEXT` con reintento hasta verlo escrito; desplazar la distancia exacta hasta y≈750 (evita un segundo desplazamiento para Tipo), swipe de 180 ms con el dedo quieto al final y estabilidad de 80 ms; teclado detectado por el agente.
- Trampa resuelta: el texto se fija antes de que abra el teclado; si no se espera a que aparezca para cerrarlo, los swipes caen sobre el teclado y escriben basura («RASTRO dentro6656»).
- Lo que queda es sobre todo animación de Flutter (hojas de opciones ~250 ms en abrir y ~300 ms en cerrar; teclado ~0,7 s por cada campo escrito) y carga del backend.

## Hallazgos del sistema
1. **Bug de URL (backend de docentes)**, documentado en `Obsidian 07 - Documentacion/2026-09-24 - Bug URL descartada al crear actividad en docentes.md`:
   - `actividad.service.ts:213-214` y `:364-365` tienen `tiposSinUrl=[3,4,6,7,21,22]` y descartan la URL justo en los tipos donde el cliente la muestra (`tipos_actividad_provider.dart:35`). El error viene del commit 55c48dd8.
   - Los datos históricos confirman que la lista del backend está invertida.
   - No se corrigió.
2. La descripción escrita con `adb input text` se guarda con `&nbsp;` (`<p>Creada&nbsp;por…</p>`). Sin verificar si pasa también al escribir a mano.
3. «Error al cargar la actividad» intermitente al abrir el formulario (backend lento).

## Datos de prueba en la réplica de dev
- 627168–627180: actividades de prueba. El usuario tiene el SQL para borrarlas (bloque PL/SQL que borra primero LMS_TAB_ACTIVIDADES_ALUMNOS y verifica 39/13).
- **627181** «MCP Eval 3 intentos» (Pruebas, Dentro de la Plataforma, 3 intentos, 0 h 1 min, WEB, 24/09 16:20 → 01/10 16:20, 5 preguntas = 15 filas en `LMS_TAB_PREGUNTAS_CUESTIONARIO` con `CUESTIONARIO_CODIGO`). Pedida por el usuario; no borrar sin preguntar.

## Pendientes / siguiente paso
- Optimización hecha (ver Mediciones). Si se quiere más: escribir todos los campos de texto seguidos y cerrar el teclado una sola vez; la BD tras Crear sigue sin medirse de punta a punta con el precalentado.
- Sin probar de punta a punta: `agregar_preguntas` / `sortear_preguntas` (necesitan crear una evaluación; pedir permiso) y las semillas de red (piden permiso para cortar la red).
- `iniciar_evaluacion` / `finalizar_evaluacion` necesitan sesión de <cuenta-de-prueba> y una evaluación abierta.
- La macro todavía no cambia fechas (los selectores de fecha y hora son diálogos).
- Esquema de las 13 herramientas: ~2,5k tokens. Las heredadas de Antigravity son verbosas; recortarlas solo con permiso.

## Semillas del estudiante (handoff 2026-09-25)

### Qué hay (en `src/semillas.ts`, parámetros nuevos `titulo`, `texto`, `ensayo` en `herramientas.ts`)
- `abrir_evaluacion` (titulo): desde cualquier pantalla. Si la app no está al frente (launcher de Android) la relanza con monkey en vez de pulsar BACK. Si la tarjeta está en el calendario del día la toca directo; si no, «Buscar actividad» → resultado → calendario de ese día → baja la lista hasta la tarjeta (días con 14 actividades). Título **exacto** («MCP Dentro» ≠ «MCP Dentro manual»). Rechaza si no es MATERIA DE PRUEBA.
- `iniciar_evaluacion`: «Evaluación» (barra inferior) → «Indicaciones» → desplaza → casilla «He leído y acepto» → espera «Comenzar» habilitado → toca. `ensayo:true` cancela sin gastar intento. Solo WEB → «Entendido» + falla. «No se han registrado preguntas» → «Regresar» + falla (no gasta intento).
- `responder_evaluacion` (texto): recorre el formulario; EditText vacío → tocar + ACTION_SET_TEXT; opción → toca el primer botón sin texto con x<220 de cada tarjeta «Pregunta N» (asignación por bounds de la tarjeta); «Seleccione una opción...» → lista, una opción distinta por lista en la misma pregunta. Cierra teclado SOLO si está abierto (un BACK de más saca de la evaluación). Fin = pantalla igual sin contar el cronómetro.
- `finalizar_evaluacion`, `rendir_evaluacion` (todo junto, tiempo por fase).

### Resultados (<cuenta-de-prueba>)
| Evaluación | Resultado |
|---|---|
| MCP Eval 3 intentos (627181) | solo WEB, la app la bloquea bien. No rendida. |
| APP-B Control de evaluación | Se registraron pruebas del flujo existente; este resumen omite sus reglas internas. |
| PLAT-MOVIL prueba | rendida 10,5 s, nota 3.3, quedan 2. |
| MCP Dentro | 1.º intento: sin preguntas (no gastó). Tras cargarlas: rendida 6,2 s pero **«Respondió 0», nota 0.0** aunque la semilla marcó 1 opción. Quedan 2. |

### Pendiente inmediato
1. **Bug «Respondió 0» en MCP Dentro** (sin diagnosticar). Hipótesis: (a) el botón x<220 sin texto no era la opción (otro tipo de pregunta: V/F, casilla múltiple, icono); (b) finalizó antes de que se guardara la respuesta. Plan pedido al usuario (sin respuesta aún): gastar 1 intento, iniciar, **leer la pantalla sin tocar**, responder a mano y corregir la semilla. Consultar en Oracle cómo se guarda la respuesta si hace falta.

### Trampas
- Tampoco Claude Code y Antigravity a la vez sobre el celular.
- «device unauthorized» al empezar el día → aceptar la depuración USB en el celular.
- Un intento nuevo trae precargadas las respuestas del anterior → responder hace 0 acciones; para probar respuestas hace falta una evaluación sin intentos previos.
- `movil_escribir` con x,y no escribe en Flutter: tocar primero.
- Respaldo previo a los cambios: scratchpad de la sesión c829dc85 (`semillas.ts.bak`, `herramientas.ts.bak`).

## Estado 2026-09-25 (tarde) — Antigravity probando
**Antigravity está rompiendo evaluaciones en el celular por su cuenta.** Mientras corra, Claude NO usa el celular (chocan los agentes). Sus hallazgos llegan a `Obsidian Vault\000_MejorasMCP\` (una nota por mejora + `YYYY-MM-DD - Resumen pruebas.md`). Siguiente paso para Claude: leer esa carpeta, verificar cada propuesta contra `mcp-utnmovil/src` y, con permiso, implementarlas.

- Al primer `movil_*` la conversación queda en candado: solo MCP, lecturas, git de lectura y escribir en `000_MejorasMCP`. Log: `hooks/solo-lectura.log` → revisar que los nombres reales de herramientas coincidan (supuestos: run_command, view_file, write_to_file, mcp_*).
- `toolPermission: always-proceed` sigue puesto. Pendiente: quitar la entrada duplicada `utn-movil` de los mcp_config de Antigravity (pedir permiso).

- Con respuestas → 22/09 08:00–23/09 22:00: 627151, 627154, 627155, 627156, 627159, 627161 (ip 10→6), 627164, 627172.
- Hoy (25/09 00:00–23:59) SOLO queda 627177 «MCP Dentro sorteo» (MOVIL, 5 intentos). Las no MOVIL (627121, 627157, 627162 con plataforma null; 627163, 627175, 627180, 627181 WEB) se pasaron a 22–23/09 con 5 intentos cada una. El cliente trata null como «ambas» (actividad_entity.dart:22), pero el docente solo elige WEB/MOVIL.
- Script: scratchpad de la sesión c829dc85 `mover-evaluaciones.mjs` (en seco por defecto, `--real` escribe).
- Sin verificar: si esas 8 tienen preguntas cargadas.

### Pendientes de Claude
1. Bug «Respondió 0» (MCP Dentro) — ver arriba; quizá Antigravity lo reproduzca.
2. Implementar mejoras de `000_MejorasMCP` tras revisarlas.

## Mejoras tras la prueba de Antigravity (2026-09-25, Claude)
Causas verificadas y arreglos (respaldo del agente previo: scratchpad sesión 9257f7ad `Agente.java.bak`, `agente.jar.bak`):
- **Tildes**: `adb shell input text` no acepta no-ASCII (NPE en InputShellCommand; el `%!s(MISSING)` es solo cómo lo imprime Antigravity). Agente: `c texto` = portapapeles vía IClipboard (como com.android.shell), `V _` = Ctrl+V inyectado (KEYCODE_PASTE 279 NO pega en Flutter), `f texto` = ACTION_SET_TEXT al nodo con foco (no sirve en Quill: no expone nodo editable). `Pantalla.escribir` pega si hay no-ASCII o >60 chars; `movil_escribir` lo usa.
- **Quill**: con el teclado abierto el editor queda tapado y NO sale en el volcado → pegar una sola vez, cerrar teclado y verificar.
- **`movil_tecla OCULTAR_TECLADO`**: BACK solo si el teclado está visible.
- **Nueva `movil_crear_pregunta_banco`** (src/banco.ts): tipo unica/multiple/ensayo/emparejamiento, alternativas+correctas (1-based) o pares {a,b}, contenido (def. UNIDAD 1), ensayo. Agrega/elimina tarjetas (única trae 2, múltiple y emparejamiento 4). Ensayo medido: ensayo 3,0 s · única 3 alt 10 s · emparejamiento 2 pares 11 s · múltiple 5 alt 21 s. Enunciado `RASTRO …` + ensayo deja el formulario lleno sin cancelar. **Guardar sin probar** (crearía datos).
  - La barra de pestañas del aula NO está en el árbol de accesibilidad: flecha derecha (1030,500) y luego Banco Preguntas (530,500).
  - Por tarjeta: radio/casilla «Correcta» sin texto en x≈742–754; Eliminar en 877; EditText Respuesta+Retro (emparejamiento A, B, Retro). El teclado mueve el formulario: cerrar teclado y recolocar la tarjeta antes de cada campo (si no, el texto cae en otra tarjeta).
- **`agregar_preguntas`**: el bug real era que marcaba casillas de «Preguntas Agregadas» (tarjetas «Agregada …», x=146 igual que las disponibles) y que la lista está paginada («Cargar más»). Ahora: sube hasta «Preguntas Disponibles», solo marca disponibles, pagina, `texto` filtra (p. ej. "MCP -"), `ensayo` marca y Limpia; si hay menos, agrega las que haya. Peor caso (filtro al final de 114) ~29 s; 3 sin filtro ~10 s. «Filtrar» no busca por texto (solo contenido/dificultad).
- Ruta a «Agregar Preguntas» de una evaluación: Calendario → Buscar actividad → resultado → tarjeta → OPCIONES DE ACTIVIDAD → Agregar Preguntas (icono en 540,1901).
- Cierre 2026-09-25: creada pregunta real «MCP - ¿Cuál es la capital de Ecuador?» (Quito; banco 118→119). Preguntas por evaluación: E03 y E05–E09 = 5, **E04 = 8** (un intento fallido agregó de más; todas MCP), E01 = 4, E02 = 3.
- `agregar_preguntas` corregido otra vez: el botón flotante de tema (luna, 90,2129) pasaba como casilla → casillas solo con y<1980; la barra fija «Agregar (N)» tapa el inicio de la lista → casillas solo debajo de ella; se cuenta solo con «N seleccionadas» confirmado; espera la carga SIN desplazar (antes hacía scroll infinito buscando la cabecera) y tope de 8 desplazamientos + 2 «Cargar más». Ahora ~12–15 s por evaluación con navegación.
- Script de navegación + semilla: scratchpad sesión 9257f7ad `completar.mjs MCP-E0x …` (Calendario → Buscar actividad → tarjeta → Agregar Preguntas).
- `movil_crear_pregunta_banco`: desde Calendario/Horario/Más usa la pestaña Registro y un desplazamiento corto (Flutter no publica la semántica de la lista al volver a la pestaña).

## Iteración 2026-09-25 (tarde) — pruebas de falla en evaluación online + mejora del MCP
### Qué se aprendió del uso real
- El tiempo NO se va en el teléfono (toque ~40 ms, volcado ~10 ms) sino en las **vueltas al modelo**: ~60 llamadas sueltas para un solo intento, cada una de varios segundos. Lo mismo concluyen Maestro MCP / mobile-mcp: árbol de accesibilidad (ya lo usamos) + flujos declarativos en una llamada.
- Coordenadas viejas = toques equivocados (se tocó Guayaquil creyendo tocar el título). Siempre volcar justo antes de tocar.
### Cambios (respaldo previo: scratchpad sesión 0e74d884 `respaldo-mcp/`)
- **Nueva `movil_guion`** (`src/guion.ts`): lista de pasos en UNA llamada — tocar/elegir/escribir/esperar/verificar/desplazar/red/tecla/oracle/leer — con ms y ✓/✗ por paso, se detiene en el primer ✗, restaura la red en `finally`. `escribir` va como usuario (foco → teclado → pegar por IME) y falla si el campo no abre teclado. `verificar{marcado}` mira el radio/casilla de la fila.
- `semillas.ts` `llenarCampo`: verificaba «algún EditText con ese texto» → tras el 1.º ensayo los demás «pasaban» sin escribirse («54 texto» en 63,8 s). Ahora verifica ESE campo.
- `abrir_evaluacion`: pasa «¡Bienvenido/a! → Continuar»; si pide huella/patrón falla al instante con mensaje claro (antes: 12,6 s y «no llegué al portafolio»).
- `leer_pantalla`: `json:true` por el agente (el dump viejo chocaba); el filtro también ve `[x]`/`✎`. `capturar` avisa de la pantalla negra.
- Esquema total ahora ~3,4k tokens (15 tools).
### Resultados de la app (intento A, MCP-E05 627186 / 18517954, inicio 11:36:17, sin entregar → se cerrará como zombi)
- C1 opción única sin red: **falla real** — queda [x], snackbar de error, retocar la misma opción no reenvía (pregunta_opcion_online_widget.dart:41/:47). Oracle sin fila hasta elegir otra opción.
- C1 emparejamiento sin red: se recupera al volver a elegir (el usuario dice que basta con que al final se mande bien).
- Overlay «Sin conexión» se queda tras volver la red (usuario: no importa).
- C0 ensayos: texto visible pero sin fila en Oracle — **no concluyente** (el campo no tomaba foco por toque; repetir con `movil_guion` + `escribir`).

### Corrección 2026-09-25 12:10 — causa real de «Respondió 0» / «54 texto» / ensayos sin fila: el MCP, NO la app
- Prueba en E06 (627187): ensayos llenados por la semilla visibles pero sin fila en Oracle → al finalizar «Respondió 1» (solo Quito). El usuario repitió a mano (tocar ensayo, escribir, cerrar teclado, finalizar): «Lol» guardado 12:06:18, finalizado 12:06:21 → **la app envía bien**. FINALIZAR se oculta con el teclado abierto (diseño, formulario_evaluacion_online_page.dart:138); cerrarlo dispara el guardado.
- Causa: el toque del agente (`t x y`) inyectaba el UP al instante con hora +40 ms → los botones reaccionan pero el TextField de Flutter NO toma foco. La semilla metía el texto con ACTION_SET_TEXT sin foco: visible, pero la app nunca lo envía, y como no «cuajaba» lo reescribía hasta el tope (54).
- Arreglo: `Agente.java` baja, duerme 60 ms reales y suelta (respaldo del jar previo: scratchpad sesión 0e74d884 `respaldo-mcp/`). `llenarCampo` ahora escribe como persona: tocar → esperar teclado (≤1,5 s, si no, falla clara) → pegar por IME. Verificado: el buscador toma foco (escribir 660 ms) y `abrir_evaluacion` OK 8,7 s.
- Pendiente: confirmarlo en un examen real (gasta 1 intento; E07 tiene 3). `banco.ts:193` y `macros.ts:140` (docente) siguen con fijarTexto; allí la BD sí confirmaba lo guardado.

## 2026-09-25 (15:00) — ensayos de evaluación online: foco y estado (Claude)
- `Agente.java` vuelca también `getHintText()` (6.ª columna). Flutter fusiona la tarjeta del ensayo (enunciado + chip «Guardando…/Guardado/Sin conexión: no guardado aún…») en el hint del EditText. `leer` lo muestra como `✎texto «etiqueta»`; filtro, `buscar`, `esperar{texto}` y `escribir{campo}` también lo miran (p. ej. `campo:"7 multiplicado"`, `esperar{texto:"no guardado"}`).
- `enfocarCampo` (ui.ts): cierra el teclado si ya estaba abierto, prueba varios puntos de abajo hacia arriba (borde−175, −110, −240, −60, −310, −380) hasta que abre el teclado, y descarta los que caen sobre otro tocable (la barra FINALIZAR tapaba la última caja). Lo usan guion y semillas.
- `escribir{mantener_foco:true}` no cierra el teclado: reproduce «escribe sin tocar fuera y se va la red».
- `volcar`: reintenta si el agente recién arrancado devuelve el árbol vacío.
- Sin red, el overlay global de la app tapa todo: no se puede enfocar ni tocar FINALIZAR (ni el MCP ni un usuario).
- Guion probado en emulator-5554 (MCP-E09): escribir(mantener_foco) → cortar → «no guardado» 1,9 s → sin «Error al guardar» → restaurar → «Guardado» y fila en Oracle.

## 2026-09-29 — emulador (1080x2424, hw.keyboard=yes)
- Teclado: con teclado físico Gboard deja una ventana IME casi sin altura. El agente la contaba como «teclado abierto» → el BACK «para cerrarlo» sacaba de la búsqueda (y alteraba el flujo de evaluación). Arreglo: `v` en Agente.java exige alto > 300 px. jar nuevo = agente-5530.jar; respaldo del anterior en scratchpad sesión 7c785f16 `agente.jar.bak`.
- Tras `pkill -f app_process` a veces la app Flutter deja de exponer accesibilidad («null root node», también con `uiautomator dump`). HOME/reabrir no basta: `am force-stop` + relanzar lo arregla.
- `show_ime_with_hard_keyboard=1` no hizo aparecer el teclado en este AVD (quedó puesto).

## 2026-09-29 (tarde) — doble toque en Finalizar + arreglo de `desplazar`
- Bug del MCP: `guion desplazar{hasta}` exigía y < ABAJO-150 y no encontraba barras fijas (FINALIZAR y=2267): 8 swipes inútiles, ~8 s y falla. Ahora corta cuando el árbol no cambia tras un swipe (fin de lista) y da por visible el elemento si existe (src/guion.ts, respaldo `guion.ts.bak` en scratchpad sesión b836cae5). Compilado; sin probar en vivo (necesita un intento nuevo en el formulario). Reiniciar Claude Code para cargar el dist.
