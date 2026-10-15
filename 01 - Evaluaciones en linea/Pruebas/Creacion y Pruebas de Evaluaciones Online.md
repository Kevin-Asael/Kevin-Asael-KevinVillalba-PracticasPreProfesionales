# 🧪 Creación y Pruebas de Evaluaciones Online (Docente y Estudiante)

Guía técnica rápida con las reglas de negocio, parámetros obligatorios y causas raíz aprendidas al probar el módulo de **Evaluación Online** en los microservicios de Portafolio Docente y Portafolio Estudiante.

---

## 📌 1. Datos Maestros de Prueba (Sandbox / Laboratorio)

| Parámetro | Valor | Descripción / Contexto |
| :--- | :--- | :--- |
| **Cuenta Docente** | `<cuenta-de-prueba>` | Docente de prueba en desarrollo |
| **Cuenta Estudiante** | `<cuenta-de-prueba>` | Estudiante de prueba |
| **Cédula Estudiante** | `<cedula>` | Integrante matriculado en curso |
| **ID Curso** | `54443` | Curso de pruebas activas |
| **Materia** | `CAPRU-MATPRU` | Materia de prueba |
| **Ciclo Académico** | `1021-1099` | Período académico activo |
| **Parcial** | `N1` | Primer Parcial |
| **Código Contenido** | `<cedula>` | **CONTENIDO 1.1** (Tema de silabo en Oracle) |
| **Inst Código** | `001` | Código institucional UTN |
| **Modalidad** | `01` | Presencial / Estándar |
| **Sistema Estudio** | `02` | Semestral |
| **Tipo Ciclo Acad** | `02` | Ciclo regular |
| **Tipo Financia** | `01` | Fiscal / Regular |
| **Dependencia** | `99999` | Dependencia académica |
| **Nivel Código** | `01` | Primer nivel |

---

## 🚨 2. Reglas Críticas para que la Evaluación aparezca en la App Móvil

### A. El Campo `estado` debe ser `'A'` (NO `'1'`)
- **Problema encontrado:** Si se envía `"estado": "1"` al crear la actividad, la base de datos la guarda con valor literal `'1'`.
- **Impacto:** La consulta SQL que ejecuta la app móvil (`ACTIVIDADES_QUERY` en docente y `LISTA_ACTIVIDADES_Y_RECURSOS_CONSULTA` en estudiante) contiene:
  ```sql
  WHERE VW.ID_CURSO = :P110_ID_CURSO 
    AND TAB.ESTADO LIKE :P110_ESTADO   -- La app envía 'A'
    AND VW.TEMA_CODIGO = :P110_CODIGO_CONTENIDO 
    AND VW.CODIGO_PARCIAL LIKE :P110_PARCIAL
  ```
- **Solución:** Enviar siempre **`"estado": "A"`** (Activo).

---

### B. Categoría de Evaluación (`codigoTipoEval`)
En el curso `54443`, las políticas de porcentaje de evaluación disponibles son:

| Código (`codigoTipoEval`) | Nombre en App | Peso / Porcentaje | ¿Aparece en Pruebas? |
| :---: | :--- | :---: | :---: |
| **`34`** | **Pruebas** | **30%** | **✅ SÍ (Aquí debe ir)** |
| **`01`** | **Exámenes** | **30%** | No (va a Exámenes) |
| **`35`** | **Clase Virtual Síncrona** | **0%** | ❌ No (aparece como clase síncrona) |
| **`33`** | **Trabajos** | **30%** | No (va a Trabajos) |
| **`26`** | **Participación en foros** | **10%** | No (va a Foros) |

> [!IMPORTANT]
> Para que una evaluación en línea aparezca bajo la pestaña **Pruebas**, se debe enviar:
> - `codigoTipoEval`: `"34"`
> - `tipoActividad`: `"2"` (Evaluación Online dentro de plataforma)
> - `evalAuto`: `"S"` (Evaluación automática con sorteo)

---

### C. Código de Contenido (`codigoContenido`)
- No se debe enviar el código de materia como contenido (ej. no enviar `CAPRU-MATPRU`).
- Se debe enviar el ID numérico de 10 dígitos del tema de contenidos en Oracle: **`<cedula>`** (`CONTENIDO 1.1`).

---

## 🔄 3. Flujo Completo de Prueba (Docente ➡️ Estudiante)


### Detalle de Peticiones:

- **Body (form-data):**
  - `idCurso`: `54443`
  - `codigoContenido`: `<cedula>`
  - `materiaCodigo`: `CAPRU-MATPRU`
  - `codigoParcial`: `N1`
  - `codigoTipoEval`: `34`
  - `tipoActividad`: `2`
  - `estado`: `A`
  - `intentosPermitidos`: `1`
  - `limiteTiempo`: `15`
  - `limTiempoHoras`: `0`
  - `evalAuto`: `S`
  - `fechaInicio`: `DD/MM/YYYY HH:mm:ss` (Fecha actual)
  - `fechaFin`: `DD/MM/YYYY HH:mm:ss` (+6 horas)
  - `nombreCorto`: `Evaluacion Online Test <timestamp>`

- **Body (JSON):**
  ```json
  {
    "numPreguntas": 5,
    "codContenido": "<cedula>",
    "difMinima": 1,
    "difMaxima": 10,
    "esCuestionarioDiferente": "N"
  }
  ```
- Ejecuta en base de datos: `UTNDB.LMS_PRC_SORTEAR_PREGUNTASv2`.

- En el array `calificaciones`, filtrar por `cedulaIntegrante === "<cedula>"` para obtener el `idActividadAlumno`.

  ```json
  {
    "idPregunta": 10000389327,
    "idAlternativa": 1202244,
    "tipoPregunta": 1
  }
  ```

---

## 🛠️ 4. Endpoints de Utilidad para Reintentar Pruebas

Si una prueba se queda sin tiempo o se requiere reintentar sin borrar todo:

1. **Resetear Temporizador:**
2. **Agregar Intento Extra:**
3. **Validar si ya está Sorteada:**
4. **Eliminar Cuestionario Sorteado:**

---

## 📂 5. Ubicación de la Colección de Postman

Para no ensuciar el repositorio Git, la colección completa y automatizada con scripts pre-request y tests se almacena fuera del proyecto en:
`%USERPROFILE%\Downloads\Crear Evaluacion Online - Portafolio Docente.postman_collection.json`
