# Bug latente en `lista-recursos` de aula virtual (no activo hoy) — 2026-09-23

> ⚠ **Corrección del mismo día:** esta nota decía originalmente que el endpoint "devuelve
> siempre una lista vacía" y que afecta a "todos los estudiantes hoy". Es **incorrecto** — se
> verificó después con la app real (producción) que la pantalla de Recursos funciona bien y
> permite descargar. La causa técnica de más abajo es real y sigue sin arreglar, pero es un bug
> **latente**, no activo: con cómo el cliente usa el endpoint hoy, no se manifiesta. Ver
> "Por qué no se manifiesta hoy" más abajo — léelo antes que el resto.

## Causa técnica (real, verificada, pero no activa hoy)

`aula_virtual_repository.ts:getListaRecursos` (repo `utn-movil-portafolio-estudiante`, rama
`practicas-preprofesionales`) arma la consulta `LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA` con **16
valores posicionales para 14 binds únicos** — repite `nivelCodigo` y `codigoContenido` (con un
comentario `// :nivelCodigo (repetido)` que sugiere que se hizo creyendo que hacía falta un valor
por cada aparición textual del bind). En Oracle, en el modo que usa este servicio (*thick mode*,
confirmado en `CLAUDE.md` del repo), los binds se resuelven por nombre único, no por cuántas veces
aparece cada uno en el texto — así que el arreglo con valores de más puede desalinear el resto.

## Por qué no se manifiesta hoy

Verificado en el cliente Flutter (`recursos_aula_virtual_page.dart` → `aula_virtual_service.dart:64`):
la pantalla de Recursos **siempre** llama al endpoint con `codigoContenido = aulaVirtual.materiaCodigo`
— nunca un código de "tema"/nodo específico del árbol de contenidos. El mecanismo para filtrar por
tema existe a medias en el dominio (`RecursoQuery.codigoContenido` es nullable, hay un provider que
lo acepta), pero **no está cableado en esta pantalla** — se usa en otra (`DistribucionMateriaProvider`).

Con `codigoContenido = materiaCodigo`, la condición final de la consulta
(`R.MATERIA_CODIGO = :codigoContenido OR CONTENIDO IN (... CONNECT BY ...)`) ya selecciona casi
todos los recursos del curso solo por la primera mitad del `OR`, sin depender de la jerarquía de
contenidos ni de qué tan bien alineados estén el resto de los binds — y como `materiaCodigo` y
`codigoContenido` son literalmente el mismo string en 3 de las 16 posiciones del arreglo, cualquier
desalineo entre binds termina sin importar en la práctica.

**Confirmado con datos reales** (réplica de dev, cédula `1004XXXXXX`, curso `90198`, 28 recursos
reales en `LMS_TAB_RECURSOS`):
- Con `codigoContenido` = un código de tema específico del árbol (`<cedula>`, un valor que la
  app **nunca envía hoy** para esta pantalla): el endpoint devuelve `[]`. Así fue como se detectó
  el desalineo de binds — probando un caso que el código sí contempla pero el cliente no usa.
- Con `codigoContenido = materiaCodigo` (`'CIDES-POO'`, el valor real que manda la app): el
  endpoint devuelve **27 filas correctas** — coincide con lo que el usuario confirmó viendo y
  descargando recursos reales en producción.

## Por qué sigue valiendo la pena arreglarlo

Es un bug dormido, no uno activo — pero si en algún momento se termina de conectar el filtro por
tema/carpeta en la pantalla de Recursos (la funcionalidad ya existe en el dominio de la app, solo
falta la UI), en ese momento el bug de binds sí empezaría a afectar a los estudiantes. Vale la pena
documentarlo y arreglarlo con calma, sin la urgencia que se le dio inicialmente.

## Intento de arreglo (2026-09-23, revertido — sigue siendo válido para cuando se retome)

Se preparó una función Oracle (`MVL_FUN_LISTA_ACTIVIDADES_Y_RECURSOS`) con los 14 parámetros
correctos (sin duplicados), y se migró el código para usarla. El arreglo del desalineo de binds
funcionó para el caso de tema específico (pasó de `[]` a devolver datos reales).

Pero apareció un **segundo problema, distinto**: tanto la función (probada vía Oracle
directamente) como el endpoint ya corregido devolvían de forma consistente solo **12 de las 27**
filas esperadas cuando se probó con `codigoContenido = materiaCodigo` — sin que se haya
identificado la causa todavía. Se descartó que fuera el `fetch` del MCP de validación
(`max_filas`) o el propio fix de binds (la consulta plana con literales, sin pasar por la
función, sí daba las 27 filas completas).

Por precaución, **se revirtió todo el código a su estado original** (con el bug de binds tal cual
estaba) para no dejar el endpoint en un estado peor que antes. Falta correr en Toad:
`DROP FUNCTION MOVIL_UTN.MVL_FUN_LISTA_ACTIVIDADES_Y_RECURSOS;` (el objeto quedó creado en dev,
sin usarse).

## Estado

**Pendiente, sin urgencia** (bug latente, no activo). Antes de reintentar el arreglo, entender por
qué el `SYS_REFCURSOR` de la función solo entrega 12 de 27 filas (candidatos sin probar: algo
específico de la combinación `UNION` + `CONNECT BY` con variables PL/SQL en vez de literales en el
`START WITH`, o un límite de `fetchArraySize`/prefetch de `oracledb` para cursores anidados
grandes).

Detalle completo del método y las pruebas, en la nota de continuidad de la migración:
[[2026-09-14 - Como trabajamos la migracion de queries a vistas (continuidad)]].
