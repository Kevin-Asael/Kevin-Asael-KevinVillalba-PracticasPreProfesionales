# FINAL-03 — Atrasar el reloj del celular durante el examen

**Fecha:** 2026-09-10 · **Tipo:** Seguridad / Anti-trampa reloj · **Severidad:** Alta
**Dónde:** app Flutter + backend NestJS + Oracle DB

Verifica qué sucede si un estudiante intenta obtener más tiempo atrasando manualmente el reloj de su dispositivo Android (por ejemplo, retrasando la hora 30 minutos o 1 hora). Demuestra que el backend rechaza cualquier respuesta enviada fuera del tiempo real.

## Precondiciones

- Examen de 5 minutos en curso.
- En el teléfono: Ajustes → Sistema → Fecha y hora → Desactivar "Ajustar hora automáticamente".

## Pasos

1. Iniciar la evaluación y verificar que quedan aproximadamente 3 o 4 minutos.
2. Responder la primera pregunta normalmente.
3. Ir a Ajustes de Android y **retrasar la hora del teléfono 1 hora hacia el pasado** (por ejemplo: si son las 11:30, cambiar a 10:30).
4. Volver a la aplicación móvil.
6. Esperar a que pase el tiempo real del examen (los 5 minutos reales contados con un reloj externo).
7. Cuando en la hora real ya hayan pasado los 5 minutos, intentar marcar o enviar una nueva respuesta.

## Resultado según el código

2. **En el backend (el control real):**
   - El backend consulta `GET_REGLAS_EVALUACION_RESPONDER` en Oracle.
   - Oracle calcula el límite contra `SYSDATE` (reloj oficial del servidor, que nunca cambió).
   - En `evaluacion_online.service.ts:validarAcceso`:
     ```typescript
     if (config.validarTiempo && reglas.estadoActividad === 'EXPIRADO') {
       throw new ForbiddenException('El límite de tiempo para esta evaluación ha expirado.');
     }
     ```
   - El backend devuelve código **403 Forbidden**.
   - La respuesta **NO** se guarda en Oracle.
3. En el móvil, la app muestra un snackbar o aviso indicando que el tiempo expiró o que no se pudo registrar la respuesta.

**Puntos clave a comprobar:**
- [x] Aunque el celular tenga la hora atrasada, después de los 5 minutos reales ninguna respuesta es aceptada por el servidor.

## Observación — qué pasó de verdad

>  Cuando se terminan los minutos lo que pasa es que alerta que 5 respuestas no se pudieron enviar.
## Estado

✅ Coincide con el código (validado).


## Relacionado

[[FINAL-04 - Adelantar el reloj del celular durante el examen ✅]]
