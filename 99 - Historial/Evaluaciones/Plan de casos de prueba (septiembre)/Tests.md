# Tests y Matriz de Evaluaciones (Docente + Estudiante)

Registro central y seguimiento de pruebas para el modulo de Evaluaciones y Banco de Preguntas en **UTN Movil**. Niveles 1-9: lado docente (gestion, banco de preguntas, calificacion). Niveles 10-11 (nuevos): lado estudiante rindiendo el examen — la mitad que faltaba, cubre perdida de conexion, temporizador y finalizacion.

Hub: [[Tests]]

---

## Modulos de Prueba por Nivel

| Modulo / Nivel | Archivo | Casos | Estado |
| :--- | :--- | :---: | :---: |
| **Nivel 1** | [[Nivel 1 - Banco de Preguntas CRUD]] | 12 | [ ] Pendiente |
| **Nivel 2** | [[Nivel 2 - Importacion de Preguntas]] | 8 | [ ] Pendiente |
| **Nivel 3** | [[Nivel 3 - Creacion de Evaluaciones]] | 14 | [ ] Pendiente |
| **Nivel 4** | [[Nivel 4 - Sorteo Automatico]] | 12 | [ ] Pendiente |
| **Nivel 5** | [[Nivel 5 - Asignacion Manual]] | 9 | [ ] Pendiente |
| **Nivel 6** | [[Nivel 6 - Calificacion y Revision]] | 16 | [ ] Pendiente |
| **Nivel 7** | [[Nivel 7 - Resiliencia y Red]] | 10 | [ ] Pendiente |
| **Nivel 8** | [[Nivel 8 - Seguridad y Permisos]] | 11 | [ ] Pendiente |
| **Nivel 9** | [[Nivel 9 - Flujos de Negocio y Edge Cases]] | 10 | [ ] Pendiente |
| **Nivel 10 (nuevo)** | [[Nivel 10 - Rendir Evaluacion (Estudiante)]] | 16 | [ ] Pendiente |
| **Nivel 11 (nuevo)** | [[Nivel 11 - Resiliencia y Red (Estudiante)]] | 12 | [ ] Pendiente |
| **COMPORTAMIENTO** | `COMPORTAMIENTO/` (un archivo por caso, lote 1: COPIA-01 a COPIA-12; lote 2: CREA-01 a CREA-10; lote 3: TIEM-01 a TIEM-07) | 29 | [ ] Pendiente |
| **PRUEBAS FINALES** | [[README - Plan de Pruebas Finales|Batería Final (13 Validados ✅ / 2 Pendientes)]] | 15 | [x] 13/15 Coincide |
| **CONSULTAS SQL** | [[00_Indice_Resumen|Índice de Consultas Oracle SQL]] | 41 | [x] Referencia BDD |

Casos nuevos añadidos a Niveles 3/4/5/6/8/9 marcados con IDs consecutivos a los ya existentes (ej.
`ACT-10` en adelante); no se modifico ni renumero ningun caso previo, solo se agregaron anotaciones
⚠ donde el codigo real sugiere que un caso ya escrito probablemente **Falla** (ver especialmente
Nivel 8: [SEG-02] y [SEG-10]) o donde el resultado esperado depende de un procedimiento PL/SQL que
no es verificable desde el codigo (Nivel 9: [NEG-06]).

---

## Modulos Verificados en Dispositivo Real (Estado Actual)

- [x] **Banco de Preguntas** (`/banco-preguntas/aula/95149`, `/contenidos`, `/parciales-activas`): **HTTP 200 OK**
- [x] **Recursos de Aula** (`/aula-virtual/recursos?idCurso=95149`): **HTTP 200 OK**
- [x] **Foro Online** (`/foro-online/general`): **HTTP 200 OK**
- [x] **Registro Academico Notas** (`/registro-academico/notas`): **HTTP 200 OK**
- [ ] **Actividades de Aula Virtual**: **HTTP 500 (Ver [BUG-01])**
- [ ] **Notas Estudiantes de Aula Virtual**: **HTTP 500 (Ver [BUG-02])**

---

## Registro de Hallazgos y Bugs Criticos


El límite de 2000 caracteres en `nombre` de cada alternativa SÍ existe y SÍ se dispara. El bug es
que `CustomErrorResponse.fromValidationException` (custom_error_response.ts:35) no sabe leer
errores de validación anidados (`@ValidateNested` en `respuestas[]`) — hace
`Object.values(error.constraints)` sobre un ValidationError cuyo error real vive en `.children`,
no en `.constraints`, y explota con TypeError → 500. Afecta a cualquier error de validación dentro
de una alternativa, no solo el límite de caracteres.

[BUG-04] Error de ui al ingresar al modulo de banco de preguntas no existe el icono de basurero sobre el menu de limpieza 





El refresh del registro academico no esta 

Revisar la validación del tamaño de las alternativas y el tratamiento del error de servidor.

Se esta demorando mucho en ingresar a revisar la nota desde docente

Revisar la continuidad y el estado de finalización de la evaluación.

En la evaluacion online si funciona lo de cerrar 

No hace refresh el calendario bonito parece que agarra el div de abajo y se sobrepone

No se pudo guardar la pregunta tal

Preguntas en offline tendria que compararse con las que estan en el buffer porq 

UI DE RESPUESTAS SIN ENVIAR dice que si finalizas se perderan. Deberia decir otra.
