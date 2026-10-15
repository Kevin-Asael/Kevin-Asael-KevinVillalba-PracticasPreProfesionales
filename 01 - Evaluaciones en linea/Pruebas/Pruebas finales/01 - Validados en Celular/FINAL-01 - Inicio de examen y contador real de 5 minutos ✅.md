
**Fecha:** 2026-09-10 · **Tipo:** Cronómetro / Corrección de tiempo · **Severidad:** Crítica
**Dónde:** app Flutter (`utn_movil_app`) + backend NestJS (`utn-movil-portafolio-estudiante`)

Verifica que el cronómetro flotante en la pantalla del examen inicie en **00:05:00** (o 00:04:59) y no en **05:04:59**, confirmando que el desfase de 5 horas (UTC vs Hora Ecuador) fue eliminado al retirar `horaServidorISO` y restaurar el cálculo estándar de producción.

## Precondiciones

- Actividad de evaluación online creada con:
  - **Límite de tiempo:** 0 horas, 5 minutos (`LIMITE_TIEMPO = 5`, `LIM_TIEMPO_HORAS = 0`).
  - **Intentos permitidos:** al menos 1 intento disponible.
  - Preguntas ya agregadas y sorteadas.
- El estudiante no ha iniciado este intento (o se limpió el intento anterior).

## Pasos

1. Iniciar sesión en la app móvil como estudiante.
2. Ir a la materia y seleccionar la evaluación configurada con 5 minutos.
3. Tocar **Iniciar Evaluación**.
4. Aceptar el diálogo modal de indicaciones iniciales.
6. Monitorear el cronómetro durante 15 a 30 segundos continuos.

## Resultado según el código

Al cargar el formulario:
1. El backend (`evaluacion_online.service.ts`) consulta `GET_FORMULARIO_BASE` en Oracle.
2. Oracle calcula `FECHAFINISO = FECHA_INICIO_EA + (5 / 1440)` con `SYSDATE` (hora de Ecuador).
3. El backend serializa la respuesta **sin** `horaServidorISO`.
   ```dart
   final fin = fechaFin; // Parseado a hora local de Ecuador
   final ahora = DateTime.now(); // Hora local del dispositivo en Ecuador
   final nuevoTiempoRestante = fin.difference(ahora);
   ```
5. La resta `fin.difference(ahora)` debe dar exactamente **00:05:00** (o 00:04:59 por el segundo de carga).
6. Cada segundo el timer descuenta 1 segundo limpiamente: `00:04:58`, `00:04:57`...

**Puntos clave a comprobar:**
- [x] No hay saltos bruscos ni intermitencias en la cuenta regresiva.

## Observación — qué pasó de verdad


## Estado

✅ Coincide con el código (validado).


## Relacionado

[[FINAL-02 - Pasan los 5 minutos y autofinaliza por tiempo ✅]] ·
[[FINAL-04 - Adelantar el reloj del celular durante el examen ✅]]
