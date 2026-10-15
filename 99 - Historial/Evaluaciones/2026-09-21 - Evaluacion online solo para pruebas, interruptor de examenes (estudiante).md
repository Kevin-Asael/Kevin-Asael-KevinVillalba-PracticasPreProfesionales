# Evaluación online solo para pruebas — interruptor de exámenes (estudiante) — 2026-09-21

**Estado:** implementado en el working tree de `utn-movil-portafolio-estudiante` (rama
`practicas-preprofesionales`), **sin commitear ni pushear**. Verificado en vivo contra Oracle de dev.

## Qué cambió

Por indicación recibida el 2026-09-21, la evaluación online debe usarse **solo para pruebas**, no para
exámenes, porque lo hecho todavía no está suficientemente validado. Se añadió la variable
`EVALUACION_ONLINE_EXAMENES_HABILITADO`:

| Valor | Efecto |
|---|---|
| ausente, vacío o `false` (**por defecto**) | los exámenes se rechazan con `403` |
| `true` o `1` | los exámenes se rinden como cualquier otra evaluación |


## Qué es un "examen"

Códigos de `UTNDB.ACA_TAB_TIPOS_PORCENTAJE_EVAL` (`CODIGO_TIPO_EVAL` de la actividad):
`01` Exámenes, `25` Evaluación escrita, práctica o final, `27` Examen Supletorio, `45` Examen Final.
Lista en `src/modules/evaluacion_online/constants/evaluacion.constants.ts` (`CODIGOS_TIPO_EVAL_EXAMEN`).

`25` se bloquea por decisión del usuario (2026-09-21): es un tipo casi exclusivo de la Facultad de
Posgrado (126 de 130 cursos) con peso alto (~26% de la nota), equivalente en la práctica a un examen.
Solo tiene 84 actividades online frente a 15.240 del `01`. `20` "Pruebas parciales" y `34` "Pruebas"
siguen permitidos.

## Dónde se aplica

  «Los exámenes no se rinden por la evaluación online. Consulta con tu docente cómo se realizará.»
  `responder` también, porque no exige que el cronómetro haya arrancado y dejaría una puerta abierta.
  debe poder cerrarse y calificarse.
- Para saber el tipo se añadió `act.CODIGO_TIPO_EVAL AS "CODIGOTIPOEVAL"` a `GET_REGLAS_EVALUACION` y
  `GET_REGLAS_EVALUACION_RESPONDER` (`evaluacion_online.queries.ts`). Es una columna extra, no
  desplaza binds.

## Verificación

- Tests del módulo: 118/118 (103 previos + 15 nuevos del interruptor). `tsc` con `tsconfig.build.json`
  limpio.
- En vivo (backend local, cuenta `<cuenta-de-prueba>`, actividad de prueba 627146 / idActividadAlumno 18517823):
  - tipo `01`, variable sin definir → `403` en formulario y en responder; en Oracle no cambió nada
    (`FECHA_INICIO_EA` sigue `NULL`, intentos intactos).
  - tipo `01`, variable `true` → ya no responde el mensaje de examen (respondió la regla normal de
    fechas, porque la actividad empieza mañana).
  - tipo `34`, variable sin definir → no bloqueado por el interruptor.
- **No probado en vivo:** el flujo completo de rendir un examen con el interruptor encendido (depende

## Pendiente / a tener en cuenta

- **Cliente Flutter no cambió.** Un examen bloqueado le llega a la app como error `403` con ese
  mensaje; no se oculta el botón "Iniciar Evaluación". Si se quiere una mejor UX, hay que exponer el
  estado desde el backend o decidirlo en el cliente.
- **Docentes no cambió.** Un docente puede seguir creando un examen con `tipoActividad = 2`
  (evaluación online); el estudiante simplemente no podrá abrirlo.
- Un intento de examen ya abierto antes de activar el bloqueo no puede seguir guardando respuestas
  (`responder` se rechaza); su cierre lo hace `finalizar` o el job de auto-calificación.
  valor por defecto ya bloquea), solo para dejarlo explícito o para encenderlo.
- La actividad de prueba **627146** ("ZZ-PRUEBA-MERGE-MAIN editada (borrar)") sigue en dev; se cambió a
  tipo `01` y se devolvió a `34`. Pendiente que el usuario la borre.
