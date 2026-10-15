# Prueba offline de evaluación online — bug de hora en Oracle (2026-09-07)

> ⚠️ **Borrador, sin terminar.** Esto es contar en orden qué se fue haciendo y qué se fue
> encontrando, para no perder el hilo. Cuando el tema quede cerrado de verdad, se reescribe
> bonito en `07 - Documentacion`.

## La historia, en orden

Se armó una evaluación de prueba desde el portafolio docente ("MATERIA DE PRUEBA") para
probar en el celular que, si se corta la red a mitad de examen, las respuestas no se pierden
(el buffer offline del cliente) y que el backend no las duplica si el celular reintenta
enviarlas (el fix que se acababa de hacer).

Se puso un límite de **15 minutos** para el intento. Se abrió el examen en el celular.

**(IMPORTANTE) La app mostró que quedaban casi 5 horas, no 15 minutos.** Ahí se dejó la
sentido seguir — cualquier resultado de la prueba offline iba a ser dudoso.

Se armaron un par de consultas SQL directas contra la base para ver qué hora tenía guardada
cada cosa. Con eso salió esto:

**(IMPORTANTE) Oracle tiene su reloj interno en hora UTC, no en hora de Ecuador — y nadie
se lo dijo a la parte del código que abre el cronómetro del examen.** Cuando el estudiante
inicia el intento, el backend le pide a Oracle "guárdame la hora de ahora" (`SYSDATE`), y
Oracle contesta con la hora de Londres, no la de Ibarra. Como Ecuador está 5 horas detrás de
UTC, cada vez que se arranca un examen, la hora que queda guardada está **5 horas adelantada**
respecto a la hora real.

Se comprobó en vivo: se creó la actividad y un minuto después se abrió el intento — en la
base, esos dos eventos quedaron separados por 5 horas exactas en vez de 1 minuto.

Como el límite del examen se calcula sumando minutos a esa hora de inicio ya adelantada, el
resultado también sale adelantado — y por eso la app mostraba "5 horas" en vez de "15
minutos": esas 5 horas de más **son el error, no tiempo de examen real**.

👉 **Para la próxima vez que se quiera probar algo con tiempos en este módulo:** no fiarse del
qué se compare, podría estar quitando tiempo — no se puede saber sin mirar directo en la base
qué hora quedó guardada.

## De paso, otra pregunta que se resolvió leyendo el código (sin probarla a mano todavía)

Se preguntó: *si en vez de tener un reloj mal calculado, uno adelanta a propósito el reloj
del celular durante el examen (como quien quiere hacer trampa para tener más tiempo), ¿qué
pasa?*

**Es justo lo contrario de lo que uno esperaría, y es a propósito.** El cronómetro del examen
en el celular corre dos relojes al mismo tiempo: uno que nadie puede tocar, y el reloj normal
del sistema (el que se puede cambiar a mano). El cronómetro siempre le cree al que diga que
ha pasado **más** tiempo. Entonces:

- Si atrasas el reloj del celular para "ganar tiempo" → no sirve de nada, el cronómetro le
  cree al otro reloj.
- **Si adelantas el reloj del celular** → el cronómetro sí le cree, piensa que ya pasó más
  tiempo del real, **y cierra el examen antes de tiempo** — aunque la hora real sea otra.

O sea: tocar el reloj del celular hacia adelante te perjudica a ti mismo. Está pensado así
para que no sirva de nada como trampa. (Esto todavía no se probó cambiando el reloj del
celular a mano — se sacó de leer el código, que lo explica bastante claro en un comentario.)

## Y la otra pregunta: ¿qué pasa con las respuestas offline si le doy "Finalizar" antes de tiempo?

Se revisó el código para responder esto con certeza, paso a paso, tal como reacciona la app:

1. Tocas **"Finalizar"**. Antes de hacer cualquier otra cosa, la app intenta mandar de una
   vez todas las respuestas que se quedaron pendientes por falta de red.
2. Si sigue sin haber red (o el servidor no contesta), ese intento falla y quedan respuestas
   sin enviar. Si son una o más, **te sale un aviso**:

   > **"Respuestas sin enviar"**
   > "Tienes N respuestas sin enviar. Si finalizas ahora se perderán."
   > Botones: **"Seguir intentando"** o **"Finalizar de todos modos"**

3. Si tocas **"Seguir intentando"**: no pasa nada raro, el examen sigue abierto, las
   respuestas se quedan guardadas esperando a que vuelva la red.
4. **(IMPORTANTE) Si tocas "Finalizar de todos modos"**: la app le avisa al servidor que el
   examen quedó entregado, y **al toque borra del celular todas esas respuestas pendientes**
   — sin importar si de verdad llegaron a guardarse en la base o no. Es decir: si nunca
   llegaron, en ese momento se pierden para siempre. Sí hay aviso antes (el texto de arriba),
   así que no es que desaparezcan sin decir nada — pero una vez que confirmas, no hay vuelta
   atrás.
5. **Un caso aparte, más delicado:** cuando el examen se cierra solo porque se acabó el
   tiempo (o por otra vía de cierre automático), **no
   hay ningún aviso posible** — no hay a quién preguntarle, el examen se tiene que entregar
   sí o sí. Ahí también se borran las respuestas que no se alcanzaron a enviar, pero sin que
   nadie se entere en el momento.

## Más cosas raras que aparecieron siguiendo probando (sin diagnosticar todavía)

Notas tal como se escribieron mientras se probaba, sin retocar:

> CALIFICA MAL. AGARRA LA CALIFICACION SIEMPRE LE PONE QUE VALE 1 PUNTO.
> NO AGARRA LA HORA. SI PONGO 0 HORAS 10 MINUTOS PASAN ESOS 10 MINUTOS Y NO SE ACABA.
> SI SUBO EL TIEMPO MUCHO SE TERMINA LA PRUEBA A PESAR QUE RECIÉN HAYA INICIADO.

Y esto es lo que se sabe de cada una hasta ahora, en formato tabla para verlo rápido (igual
que las consultas SQL de arriba):

| # | Qué se probó | Qué se esperaba | Qué pasó | ¿Ya se sabe por qué? |
|---|---|---|---|---|
| 1 | Calificar una pregunta | Que valga lo que está configurado | Siempre sale como si valiera **1 punto** | 🎯 No — quien califica de verdad es `LMS_PRC_CALIFICAR_EVALUACION`, un procedimiento **dentro de Oracle** (esquema viejo `UTNDB`). No hay copia de su código en ningún archivo de este repo; para verlo hay que abrirlo directo en Oracle (SQL Developer → buscar su fuente) |
| 2 | Límite = 0 horas 10 minutos | Que corte a los 10 minutos reales | Pasan los 10 minutos y el examen sigue abierto | ✅ Sí — es el mismo Hallazgo 1 de arriba (el reloj de Oracle adelantado 5 horas). Con un límite tan chico, la cuenta sale tan inflada que 10 minutos reales nunca alcanzan |
| 3 | Subir bastante el límite de tiempo | Que dé más margen | El examen se cierra solo, recién empezado | 🎯 No — se descartó que fuera la fecha de fin de la actividad guardada mal (`formulario_editar_activiadad_docente_provider.dart:214,220` la guarda en hora local tal cual, sin conversión rara). Falta anotar el `idActividadAlumno` la próxima vez que pase y correr la misma consulta SQL de arriba con esos valores |

## Pendiente, para cuando se retome el tema de la hora

- Falta ver si en algún otro punto del sistema este mismo error de reloj hace que un examen
  **se cierre antes de tiempo** en vez de regalar horas de más, como pasó aquí — depende de
  qué fecha se compara contra cuál, y no se ha revisado caso por caso.
- Falta entender por qué subir mucho el límite de tiempo cierra el examen de inmediato (punto
  3 de arriba) — no tiene explicación todavía, ni siquiera una hipótesis fuerte.
- Falta revisar en Oracle qué hace `LMS_PRC_CALIFICAR_EVALUACION` para saber por qué la
  calificación sale como si todo valiera 1 punto (punto 1 de arriba).
- El mismo problema de reloj (Oracle en UTC vs. todo lo demás en hora de Ecuador) aparece en
  más de 40 lugares del código de este repo, no solo en evaluación online — becas,
  comunicados, horarios, calendario de actividades. No se ha revisado cuáles de esos sí
  importan de verdad.
- No se puede arreglar de un solo golpe cambiando una configuración: hay que corregirlo
  consulta por consulta donde se compare una fecha contra la hora actual.
- Falta probar en vivo lo de adelantar el reloj del celular a mano (por ahora solo se
  confirmó leyendo el código).
- Decidir si esto se convierte en una tarea de verdad para corregir, o se deja anotado como
  algo ya conocido y aceptado por ahora.

## Estado

**Sin terminar.** Van saliendo más cosas de las que se esperaban (calificación, límite de
tiempo que no cierra o que cierra de más) — todavía falta completar la prueba offline en el
celular en sí, que era el plan original antes de toparse con todo esto del reloj.


CALIFICA MAL . AGARRA LA CALIFICACION SIEMPRE LE PONER QUE VALE 1 PUNTO
NO AGARRA LA HORA. SI PONGO 0 HORAS 10 MINUTOS PASAN ESOS 10 MINUTOS Y NO SE ACABA.
SI  SUBO EL TIEMPO MUCHO SE TERMINA LA PRUEBA A PESAR QUE RECIEN HAYA INICIADO.



Comportamiento de copia.
// 2do Offline.


Mensaje diferente por cada caso. 5s por caso. maximo 10s


Crear una rama por cada fix etc