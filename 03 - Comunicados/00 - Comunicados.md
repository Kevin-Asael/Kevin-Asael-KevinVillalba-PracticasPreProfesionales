# Comunicados

Servicio de comunicados de UTN Móvil: el micro `utn-movil-comunicados` (NestJS), la app `utn_movil_app` (módulo `comunicados`) y el hub web donde se publican. La documentación completa del servicio (requisitos, diseño y el registro de cambios de base con su estado por entorno) está en el propio repo: `utn-movil-comunicados/docs/`.

## Cambios documentados

### Micro (`utn-movil-comunicados`, rama `practicas-preprofesionales`)

| Commit | Qué hace |
|---|---|
| `cedff92` | Swagger en local y dev, con pruebas de contrato |
| `36343de` | orden de la lista: primero lo que pide acción, luego lo no leído y al final lo atendido |
| `d0721f6` | bloqueo total: un rojo dirigido a toda la universidad bloquea todo; lo ya cumplido va al final de la lista |
| `9dc94a4`, `8adbee7` | documentación: lista de 10 en 10, «Saltar todo» y carrusel del modal |

### Cambios de base (scripts en `docs/db-scripts/cambios/`)

| Cambio | Qué hace | En desarrollo |
|---|---|---|
| `024_orden_lista_comunicados` | nuevo orden de `MVL_FUN_COMUNICADOS_LISTAR` | aplicado 2026-10-08 |
| `025_bloqueo_total_toda_la_utn` | inicio y detalle devuelven `ES_TODA_LA_UTN` | aplicado 2026-10-08 |
| `026_cumplidos_al_final` | lo ya cumplido pasa a un cuarto grupo, al final de la lista | aplicado: comprobado el 2026-10-14 leyendo la función en la base |

Cada script tiene su `_ROLLBACK`. Los cuatro están pendientes en producción, igual que el resto de cambios del servicio.

### App (`utn_movil_app`, rama `feature/comunicados-app`, subida)

- Carrusel del modal con flechas, puntos con visto y «Saltar todo»; deslizar hacia arriba marca como visto.
- Límites de aparición del modal por comunicado, y los comunicados «siempre» en cada apertura.
- El rojo bloquea solo el portafolio del rol alcanzado, con el mensaje correcto; «Volver» regresa al Home.
- Bloqueo total para los rojos dirigidos a toda la universidad.
- Encuestas ya respondidas marcadas con visto; aviso «Lectura confirmada» al confirmar desde la lista.
- Lista de 10 en 10, sin «Comunicados» duplicado en el menú, y aviso breve cuando el Home no tiene comunicados.

## Mejora posible

- Actualizar en el `README` de `docs/db-scripts` el estado del cambio `026` en desarrollo: figura como pendiente, pero ya está aplicado.
