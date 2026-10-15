# Revisión de tablas Oracle — ¿puede leerlas el MCP?

Origen: `Downloads
evision_tablas.csv` · 508 tablas · 2026-10-01

## Qué se está decidiendo

Para **cada tabla** hay que decidir una sola cosa: ¿el MCP de lectura puede devolver sus filas?
Mira las **columnas visibles** (las que el MCP mostraría) y aplica esta regla:

| Lo que ves en las columnas visibles | Decisión |
|---|---|
| Códigos, nombres de catálogo, fechas, estados, porcentajes, configuración, estructura académica | `permitir` |
| Cédula, nombres de personas, correo, teléfono, dirección, notas, pagos, sueldos, salud, trámites o filas que "son de alguien" | `excluir` |
| Texto libre largo (observaciones, comentarios, mensajes, conclusiones) donde alguien podría escribir datos personales | `excluir` (salvo que sea claramente un catálogo) |
| Dudas | `excluir` y apuntar la duda en notas |

La columna **Decisión** se rellena solo con `permitir` o `excluir`.

## Qué significa cada grupo

| Grupo                        | Estado hoy    | `permitir`       | `excluir`          |
| ---------------------------- | ------------- | ---------------- | ------------------ |
| **A** — permitida, a revisar | se puede leer | se queda legible | se bloquea         |
| **B** — excluida, rescatable | bloqueada     | se abre          | se queda bloqueada |
|                              |               |                  |                    |

Las tablas del grupo B están bloqueadas por una de dos razones, y por eso van en secciones separadas:
- **Por el nombre** (sección 4): el nombre sugiere que guardan personas o hechos de ellas. Lo normal es `excluir`; solo se rescata una si ves que sus columnas son claramente un catálogo.
- **Por tamaño** (sección 5): son grandes o no tienen estadísticas. No hay señal de datos personales; solo abre las que de verdad necesiten estudiante, docentes o la app.

## Cómo leer las etiquetas de "Por qué salió"

Son pistas de un chequeo automático, **no son la decisión**. Muchas son falsas alarmas.

| Etiqueta | Qué significa | Cuánto pesa |
|---|---|---|
| 🔴 nombre indica personas | el nombre de la tabla sugiere que guarda personas o hechos de ellas (USUARIOS, NOMINA, PAGO, NOTAS, TOKENS…) | alta: casi siempre `excluir` |
| 🔴 parámetros con VALOR | tabla de parámetros con columna `VALOR` visible | alta: mira si hay claves |
| 🟠 dominio | pertenece a un área sensible (talento humano, salud, bienestar, nómina, recaudación…) | media: mira las columnas |
| 🟡 texto libre | tiene columnas de texto visibles | baja: depende de qué texto sea |
| 🟡 columna de persona ya oculta | tenía una columna que apunta a una persona (típicamente quién creó el registro); **ya está oculta** | baja: falsa alarma casi siempre |
| ⚪ sin estadísticas / grande | motivo del bloqueo automático por tamaño | ninguna sobre privacidad |

## Resumen y orden sugerido

| Sección | Tablas | Qué esperar |
|---|--:|---|
| 2. Grupo A, dominio sensible 🟠 | 293 | mirar columnas una por una |
| 3. Grupo A, solo 🟡 | 38 | casi todas `permitir` |
| 4. Grupo B, bloqueadas por nombre 🔴 | 109 | casi todas `excluir` |
| 5. Grupo B, bloqueadas por tamaño ⚪ | 61 | `excluir` salvo las que necesites |

Empieza por la 1, sigue con la 3 (rápida), luego la 2. Las secciones 4 y 5 solo si necesitas alguna tabla concreta.

---

## 1. Grupo A — parámetros con VALOR 🔴

#### ACA (2)

| Tabla                        | Filas | Por qué salió                                                                         | Columnas visibles (en **negrita** las que piden ojo)            | Decisión  |
| ---------------------------- | ----: | ------------------------------------------------------------------------------------- | --------------------------------------------------------------- | --------- |

#### BLC (1)

| Tabla                     | Filas | Por qué salió                                                                                           | Columnas visibles (en **negrita** las que piden ojo) | Decisión                                                                                                                                               |
| ------------------------- | ----: | ------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |

#### CXP (1)

| Tabla                        | Filas | Por qué salió                                                                                                 | Columnas visibles (en **negrita** las que piden ojo) | Decisión                                                                                         |
| ---------------------------- | ----: | ------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- | ------------------------------------------------------------------------------------------------ |

#### INS (1)

| Tabla                | Filas | Por qué salió                                                        | Columnas visibles (en **negrita** las que piden ojo) | Decisión                                                              |
| -------------------- | ----: | -------------------------------------------------------------------- | ---------------------------------------------------- | --------------------------------------------------------------------- |

#### MVL (1)

| Tabla                          | Filas | Por qué salió                                                                             | Columnas visibles (en **negrita** las que piden ojo)                               | Decisión                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ------------------------------ | ----: | ----------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

#### REC (1)

| Tabla                | Filas | Por qué salió                                                                                                | Columnas visibles (en **negrita** las que piden ojo) | Decisión  |
| -------------------- | ----: | ------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------- | --------- |

---

## 2. Grupo A — dominio sensible 🟠

#### BLC (4)

| Tabla                      | Filas | Por qué salió                                                            | Columnas visibles (en **negrita** las que piden ojo)                        | Decisión                                                |
| -------------------------- | ----: | ------------------------------------------------------------------------ | --------------------------------------------------------------------------- | ------------------------------------------------------- |
| `BLC_TAB_GRUPO_EXAMEN`     |    12 | 🟠 dominio: laboratorio clínico<br>🟡 texto libre: DESCRIPCION_GRUPO     | ID_GRUPO_EXAMEN DESCRIPCION_GRUPO                                           | Permitido. Catalogo de que se hizo.                     |
| `BLC_TAB_PARAMETRO_EX_LAB` |   211 | 🟠 dominio: laboratorio clínico<br>🟡 texto libre: DESCRIPCION_PARAMETRO | ID_PARAMETRO DESCRIPCION_PARAMETRO UNIDAD_MEDIDA RANGOS TIPO_PARAMETRO      | Permitido. Es para unidades de medida de cosas medicas. |
| `BLC_TAB_SUB_GRUPO_EXAMEN` |    16 | 🟠 dominio: laboratorio clínico<br>🟡 texto libre: DESCRIPCION_SUB_GRUPO | ID_SUB_GRUPO_EXAMEN DESCRIPCION_SUB_GRUPO                                   | Permitido                                               |
| `BLC_TAB_TIPO_EXAMEN`      |    67 | 🟠 dominio: laboratorio clínico<br>🟡 texto libre: DESCRIPCION_EXAMEN    | DESCRIPCION_EXAMEN ID_CONCEPTO_EXAMEN ORDEN_EXAMEN TIPO_EXAMEN TIPO_EXAMEN1 | Permitido. Solo es un catalogo de examenes              |

#### BME (35)

| Tabla                            | Filas | Por qué salió                                                                                               | Columnas visibles (en **negrita** las que piden ojo)                                                                                                                  | Decisión                                                                                                                 |
| -------------------------------- | ----: | ----------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `BME_TAB_ACTIVIDADES_ENFERMERIA` |     8 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION                                                                                                                                                    | Excluido                                                                                                                 |
| `BME_TAB_ANTECEDENTES_FRECUENTE` |    10 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION ESTADO                                                                                                                                             | Permitido.                                                                                                               |
| `BME_TAB_AREAS`                  |     3 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION                                                                                                                                                    | Permitido                                                                                                                |
| `BME_TAB_BIOTIPOS`               |     5 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION ESTADO                                                                                                                                             | Permitido                                                                                                                |
| `BME_TAB_CLASES_TIPO_CONSULTA`   |     2 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION                                                                                                                                                    | Permitido                                                                                                                |
| `BME_TAB_DEPORTES`               |    69 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION                                                                                                                                                    | Permitido                                                                                                                |
| `BME_TAB_DIAS_MES`               |    31 | 🟠 dominio: bienestar / salud                                                                               | CODIGO                                                                                                                                                                | Permitido                                                                                                                |
| `BME_TAB_ENFERMEDADES_GRUPOS`    | 14541 | 🟠 dominio: bienestar / salud<br>⚪ muchas filas para catálogo (~14541)<br>🟡 texto libre: DESCRIPCION_GRUPO | CODIGO DESCRIPCION_GRUPO                                                                                                                                              | Excluido. No tiene valor es un catalogo de enfermedades                                                                  |
| `BME_TAB_ESPE_MEDICAS_NIVELES`   |    32 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION ESPECIALIDAD_NIVEL ESTADO                                                                                                                          | Permitido                                                                                                                |
| `BME_TAB_ESTADOS_GENERALES`      |     3 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION                                                                                                                                                    | Permitido                                                                                                                |
| `BME_TAB_FRECUENCIA`             |    15 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION TIPO                                                                                                                                               | Permitido                                                                                                                |
| `BME_TAB_GRUPOS_ENFERMEDAD`      |  2036 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION_GRUPO                                          | CODIGO CODIGO_GRUPO DESCRIPCION_GRUPO                                                                                                                                 | Excluido. Puro codigo sin nada mas. No aporta valor solo con ver las columnas sin ver el dato basta.                     |
| `BME_TAB_GRUPOS_IMAGENES`        |    11 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION ESTADO                                                                                                                                             | Excluido. Solo tiene Ecografia, radiografia, rx, asi la tabla esta con esas cosas.                                       |
| `BME_TAB_METODO_ANTICONCEPCION`  |    31 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION ESTADO                                                                                                                                             | Permitido                                                                                                                |
| `BME_TAB_OPERACIONES`            |   179 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION ESTADO                                                                                                                                             | Permitido.                                                                                                               |
| `BME_TAB_PARAMETROS_RECETAS`     |     0 | 🟠 dominio: bienestar / salud                                                                               | CODIGO SIMBOLOGIA SIGNIFICADO0                                                                                                                                        | Excluido. No tiene valores de datos. Solo con leer la estructura y como se conecta o sea solo estructura tocaria intuir. |
| `BME_TAB_PARTES_CUERPO`          |   130 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION PARTCUERP_CODIGO                                                                                                                                   | Excluir. Solo lista partes del cuerpo                                                                                    |
| `BME_TAB_PEDIDO_COMPLEMENTARIOS` |     1 | 🟠 dominio: bienestar / salud                                                                               | ID_PEDIDO ID_CONCEPTO_EXAMEN ANAMNESIS EXAMEN_FISICO ANTECEDENTES PEDIDO_IESS URGENTE MOVILIZARSE QUITARSE_VENDAJES_APOSITOS MEDICO_PRESENTE_EN_EXAMEN EXAMEN_EN_CAMA | Excluir. Puede llenarse de algun dato personal si se junta con algun otra tabla.                                         |
| `BME_TAB_PERIODOS_CONTROL_MEDIC` |     7 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION ESTADO                                                                                                                                             | Permitir                                                                                                                 |
| `BME_TAB_RESULT_PRUEBAS_COMPLEM` |    14 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION PRUEBA_PERTENECE                                                                                                                                   | Excluir. Describe resultados de examenes medicos y conjunto a otra tabla pueden salir datos personales.                  |
| `BME_TAB_SIGNOS_VITALES`         |    10 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION                                                                                                                                                    | Permitir.                                                                                                                |
| `BME_TAB_TIPOS_ALERGIAS`         |     4 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION ESTADO                                                                                                                                             | Permitir                                                                                                                 |
| `BME_TAB_TIPOS_ALIMENTO`         |    13 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION                                                                                                                                                    | Permitir. Aunque solo guarda unos tipos de alimento                                                                      |
| `BME_TAB_TIPOS_ANTECEDENTE`      |     8 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION                                                                                                                                                    | Permitir.                                                                                                                |
| `BME_TAB_TIPOS_CANTIDAD`         |     5 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION                                                                                                                                                    | Permitir                                                                                                                 |
| `BME_TAB_TIPOS_CERTIFICADO`      |     3 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION                                                                                                                                                    | Permitir                                                                                                                 |
| `BME_TAB_TIPOS_CONSULTAS`        |    20 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION CLASE_CODIGO                                                                                                                                       | Permitir                                                                                                                 |
| `BME_TAB_TIPOS_DIAGNOSTICOS`     |    23 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION CLASIFICACION_TIPO ESTADO                                                                                                                          | Permitir                                                                                                                 |
| `BME_TAB_TIPOS_EXAMEN_FISICO`    |     3 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION                                                                                                                                                    | Permitir                                                                                                                 |
| `BME_TAB_TIPOS_IMAGENES`         |    56 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION ESTADO GRUPIMAGEN_CODIGO                                                                                                                           | Permitir                                                                                                                 |
| `BME_TAB_TIPOS_PACIENTES`        |     4 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION ESTADO                                                                                                                                             | Permitir                                                                                                                 |
| `BME_TAB_TIPOS_PULSOS`           |     3 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION ESTADO                                                                                                                                             | Permitir                                                                                                                 |
| `BME_TAB_TURNOS_GRUPO_HORA`      |     4 | 🟡 columna de persona ya oculta<br>🟠 dominio: bienestar / salud                                            | GRUPO_HORA_CODIGO AREA_CODIGO FECHA ESTADO                                                                                                                            | Excluir. Datos personales                                                                                                |
| `BME_TAB_VACUNAS`                |    24 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION SISTEMATICA_NO_SISTEMATICA ESTADO                                                                                                                  | Permitir                                                                                                                 |
| `BME_TAB_VALORES_PARAMETROS_EXA` |    94 | 🟠 dominio: bienestar / salud<br>🟡 texto libre: DESCRIPCION                                                | CODIGO DESCRIPCION ESTADO                                                                                                                                             | Permitir                                                                                                                 |

#### BOD (8)

| Tabla                        | Filas | Por qué salió                                                   | Columnas visibles (en **negrita** las que piden ojo)                                                                                      | Decisión                                              |
| ---------------------------- | ----: | --------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| `BOD_TAB_CARA_PIEZA_DENTAL`  |     8 | 🟠 dominio: odontología<br>🟡 texto libre: NOMBRE_CARA          | ID_CARA NOMBRE_CARA                                                                                                                       | Permitir                                              |
| `BOD_TAB_CATEGORIA`          |    83 | 🟠 dominio: odontología<br>🟡 texto libre: NOMBRE_CATEGORIA     | ID_CATEGORIA NOMBRE_CATEGORIA ESTADO                                                                                                      | Permitir                                              |
| `BOD_TAB_ESTADO_CITA_ODONT`  |     9 | 🟠 dominio: odontología                                         | ID_ESTADO ESTADO                                                                                                                          | Permitir                                              |
| `BOD_TAB_OCLUSION`           |     0 | 🟠 dominio: odontología                                         | COD_OCLUSION TIPO_OCLUSION                                                                                                                | Permitir. Aunque vacio puede leer solo la estructura  |
| `BOD_TAB_PIEZA_DENTAL`       |    67 | 🟠 dominio: odontología<br>🟡 texto libre: NOMBRE_PIEZA         | COD_PIEZA NOMBRE_PIEZA                                                                                                                    | Permitir. Pero muchos datos vacios                    |
| `BOD_TAB_PREGUNTA_ANAMNESIS` |    58 | 🟠 dominio: odontología                                         | ID_PREGUNTA PREGUNTA ALARMA                                                                                                               | Permitir                                              |
| `BOD_TAB_PROCEDIMIENTO`      |   977 | 🟠 dominio: odontología<br>🟡 texto libre: NOMBRE_PROCEDIMIENTO | ID_PROCEDIMIENTO ID_CATEGORIA NOMBRE_PROCEDIMIENTO ICONO_PROCEDIMIENTO AREA_OCUPA CODIGO_CIE10 ESTADO CARAS                               | Permitido. Pero Tiene muchos datos de procedimientos. |
| `BOD_TAB_TERCIOS_DENTALES`   |   268 | 🟠 dominio: odontología                                         | ID_TERCIOS_DENTALES TERCIO_UNO TERCIO_DOS TERCIO_TRES TERCIO_CUATRO TERCIO_QUINTO TERCIO_SEXTO TERCIO_SEPTIMO TERCIO_OCTAVO TERCIO_NOVENO | Permitido.                                            |
|                              |       |                                                                 |                                                                                                                                           |                                                       |

#### BSE (4)

| Tabla                         | Filas | Por qué salió                                          | Columnas visibles (en **negrita** las que piden ojo)                                                                                                       | Decisión                 |
| ----------------------------- | ----: | ------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `BSE_TAB_ENVIO_ASEGURADORA`   |    42 | 🟠 dominio: becas<br>🟡 texto libre: DESCRIPCION_GRUPO | ID_ENVIO FECHA_DESDE FECHA_HASTA FECHA_ENVIO PC_CREA US_CREA FECHA_CREA PC_MODIFICA US_MODIFICA FECHA_MODIFICA PER_SEG_ID_PERIODO_SEGURO DESCRIPCION_GRUPO | Permitir                 |
| `BSE_TAB_PERIODO_SEGURO`      |    13 | 🟠 dominio: becas<br>🟡 texto libre: VALOR_ANUAL       | ID_PERIODO_SEGURO FECHA_INICIO FECHA_FIN DESC_ASEGURADORA ESTADO TIPO_ASEGURADO **VALOR_ANUAL** PER_ACAD_CODIGO                                            | Excluir. Datos de pagos. |
| `BSE_TAB_TIPO_ASEGURADO`      |     2 | 🟠 dominio: becas<br>🟡 texto libre: DESCRIPCION       | ID_TIPO_ESEGURADO DESCRIPCION                                                                                                                              | Permitir                 |
| `BSE_TAB_TIPO_SOLICITUD_BECA` |    12 | 🟠 dominio: becas<br>🟡 texto libre: DESCRIPCION       | CODIGO DESCRIPCION ESTADO                                                                                                                                  | Permitir                 |

#### CXC (1)

| Tabla                      | Filas | Por qué salió                                                 | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
| -------------------------- | ----: | ------------------------------------------------------------- | ---------------------------------------------------- | -------- |
| `CXC_TAB_TIPOS_FORMA_PAGO` |     4 | 🟠 dominio: cuentas por cobrar<br>🟡 texto libre: DESCRIPCION | CODIGO DESCRIPCION ESTADO                            | Permitir |

#### CXP (6)

| Tabla                           | Filas | Por qué salió                                                | Columnas visibles (en **negrita** las que piden ojo)                                                                                                | Decisión                                   |
| ------------------------------- | ----: | ------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| `CXP_TAB_ACTIVIDADES_PROVEEDOR` |     2 | 🟠 dominio: cuentas por pagar<br>🟡 texto libre: DESCRIPCION | CODIGO DESCRIPCION ESTADO                                                                                                                           | Permitir                                   |
| `CXP_TAB_CLASES_PROVEEDORES`    |     2 | 🟠 dominio: cuentas por pagar<br>🟡 texto libre: DESCRIPCION | CODIGO DESCRIPCION ESTADO                                                                                                                           | Permitir                                   |
| `CXP_TAB_DOCUMENTOS`            |     0 | 🟠 dominio: cuentas por pagar<br>🟡 texto libre: NOMBRE      | CODIGO NOMBRE DOC_FINANCIERO ESTADO SIGNO ABONO                                                                                                     | Excluir. Seria solo estructura como max    |
| `CXP_TAB_ESTADOS_CXP`           |     0 | 🟠 dominio: cuentas por pagar<br>🟡 texto libre: DESCRIPCION | CODIGO DESCRIPCION                                                                                                                                  | Excluir. seria de observar solo estructura |
| `CXP_TAB_IMPUESTO_COMPRA`       |     0 | 🟠 dominio: cuentas por pagar                                | COMPRA_NUMERO_COMPROBANTE AUTORIZACION PUNT_EMISION COD_ESTABLEC IMPUESTO_CODIGO PORCENTAJE TOTAL_IMPUESTO ITEM_CODIGO UNIDAD_MEDIDA TIPO_OPERACION | Excluir. Solo maximo estructura            |
| `CXP_TAB_TIPO_COMPROB_COMPRA`   |     1 | 🟠 dominio: cuentas por pagar<br>🟡 texto libre: DESCRIPCION | CODIGO DESCRIPCION ESTADO                                                                                                                           | Permitir                                   |

#### DBU (24)

| Tabla                           | Filas | Por qué salió                                                      | Columnas visibles (en **negrita** las que piden ojo)                             | Decisión                                           |
| ------------------------------- | ----: | ------------------------------------------------------------------ | -------------------------------------------------------------------------------- | -------------------------------------------------- |
| `DBU_TAB_ACTIVIDAD_LABORAL`     |     6 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_ACTIVIDAD_LABORAL DESCRIPCION                                                | Excluir                                            |
| `DBU_TAB_ADAPTACION_CURRICULAR` |     8 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_ADAPTACION DESCRIPCION                                                       | Excluir                                            |
| `DBU_TAB_ALMUERZO`              |     4 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_ALMUERZO DESCRIPCION                                                         | Excluir                                            |
| `DBU_TAB_APOYO_TECNOLOGICO`     |    15 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_APOYO DESCRIPCION                                                            | Excluir. Solo tiene tipos de apoyo                 |
| `DBU_TAB_AREA_CONOCIMIENTO`     |     3 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_AREA DESCRIPCION                                                             | Excluir                                            |
| `DBU_TAB_AREA_EMPLEO`           |    28 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_AREA_EMPLEO DESCRIPCION                                                      | Excluir                                            |
| `DBU_TAB_CARRERAS_SENESCYT`     |   256 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | CODIGO DESCRIPCION                                                               | Excluir                                            |
| `DBU_TAB_CONSTRUCCION_VIVIENDA` |     5 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_CONSTRUCCION DESCRIPCION ESTADO                                              | Excluir                                            |
| `DBU_TAB_EMPLEO`                |    93 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_EMPLEO DESCRIPCION                                                           | Excluir                                            |
| `DBU_TAB_ESTRUCTURA_VIVIENDA`   |     7 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_ESTRUCTURA DESCRIPCION ESTADO                                                | Excluir. Solo son tipos de estructura de vivienda. |
| `DBU_TAB_HORARIO_TRABAJO`       |     4 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_HORARIO DESCRIPCION ESTADO                                                   | Excluir                                            |
| `DBU_TAB_INGRESO_MENSUAL`       |    34 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_ING_MENSUAL DESCRIPCION RANGO1 RANGO2 GRUPO COD_GRUPO CATEGORIZACION_INGRESO | Excluir                                            |
| `DBU_TAB_NIVEL_EDUCACION`       |     7 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_NIVEL_EDUCACION DESCRIPCION NIVEL_SIIES                                      | Excluir. Catalogo de niveles de ed.                |
| `DBU_TAB_ORIENTACION_SEXUAL`    |     3 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_ORIENTACION_SEXUAL DESCRIPCION                                               | Excluir                                            |
| `DBU_TAB_PARENTESCO`            |    22 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_PARENTESCO DESCRIPCION ORIGEN_RECURSOS_ESTUDIOS ORIGEN_RECURSOS_ANALISIS     | Excluir. Catalogo                                  |
| `DBU_TAB_PREGUNTAS_AFECTIVAS`   |     5 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_PREGUNTA DESCRIPCION ESTADO                                                  | Excluir                                            |
| `DBU_TAB_RETIRO_UNIVERSITARIO`  |     7 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_RETIRO DESCRIPCION                                                           | Excluir. Catalogo                                  |
| `DBU_TAB_SECTOR_EMPLEO`         |     5 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_SECTOR_EMPLEO DESCRIPCION                                                    | Excluir                                            |
| `DBU_TAB_SERVICIO`              |     6 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_SERVICIO DESCRIPCION ESTADO                                                  | Excluir                                            |
| `DBU_TAB_SNNA_ASPEC_PREG`       |     9 | 🟠 dominio: bienestar universitario                                | CODIGO ASPECTO ESTADO                                                            | Excluir                                            |
| `DBU_TAB_TERRENO`               |     5 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_TERRENO DESCRIPCION                                                          | Excluir                                            |
| `DBU_TAB_TIEMPO_LIBRE`          |     9 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_TIEMPO_LIBRE DESCRIPCION                                                     | Excluir                                            |
| `DBU_TAB_TIPOS_VIVIENDA`        |     7 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_VIVIENDA DESCRIPCION TIPO_VIVIENDA_SIIES                                     | Excluir                                            |
| `DBU_TAB_VEHICULO`              |     7 | 🟠 dominio: bienestar universitario<br>🟡 texto libre: DESCRIPCION | COD_VEHICULO DESCRIPCION                                                         | Excluir                                            |
De este apartado tengo una pregunta porq son todas de catalogo pero si sabes los codigos no podrias saberlo de otro lado si es que hay una fk. si es asi entonces de DBU (24) no deberia ir ninguna.
#### NOM (3)

| Tabla                   | Filas | Por qué salió                                             | Columnas visibles (en **negrita** las que piden ojo)                                  | Decisión |
| ----------------------- | ----: | --------------------------------------------------------- | ------------------------------------------------------------------------------------- | -------- |
| `NOM_TAB_DEDICACION_C`  |     7 | 🟠 dominio: nómina<br>🟡 texto libre: NOMBRE_DEDICACION   | CODIGO_DEDICACION NOMBRE_DEDICACION ABREBIATURA NUMERO_HORAS ESTADO CODIGO_DEDICA_ACA | Excluir  |
| `NOM_TAB_DESIGNACION_C` |    16 | 🟠 dominio: nómina<br>🟡 texto libre: NOMBRE_DESIGNACION  | CODIGO_DESIGNACION NOMBRE_DESIGNACION ABREVIATURA                                     | Excluir  |
| `NOM_TAB_REGIMEN_C`     |    15 | 🟠 dominio: nómina<br>🟡 texto libre: NOMBRE, DESCRIPCION | CODIGO NOMBRE DESCRIPCION CODIGO_LEY                                                  | Excluir  |

#### REC (23)

| Tabla                         | Filas | Por qué salió                                                                   | Columnas visibles (en **negrita** las que piden ojo)                                                                                                                                                                                                                                                                                       | Decisión                                                   |
| ----------------------------- | ----: | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------- |
| `REC_CONCEPTOS_AGROIN`        |     4 | 🟠 dominio: recaudación<br>🟡 texto libre: NOMBRE, VALOR_CONCEPTO               | ID_CONCEPTO NOMBRE **VALOR_CONCEPTO** GRAVA_IVA                                                                                                                                                                                                                                                                                            | Excluir                                                    |
| `REC_TAB_CIERRES_EFECTIVOS`   |  3977 | 🟠 dominio: recaudación                                                         | ID_CIERRE ORDEN FECHA_DESDE FECHA_HASTA TOTAL_CIERRE PC_CREA US_CREA FECHA_CREA PC_MODIFICA US_MODIFICA FECHA_MODIFICA RTEP_ID_ESTADO_PROCESO CUBA_ID_CUENTA NRO_COMPROBANTE                                                                                                                                                               | Excluir                                                    |
| `REC_TAB_CONCEPTOS`           |  1150 | 🟠 dominio: recaudación<br>🟡 texto libre: DESCRIPCION_CONCEPTO, VALOR_CONCEPTO | ID_CONCEPTO DESCRIPCION_CONCEPTO ACTIVO PC_CREA US_CREA FECHA_CREA PC_MODIFICA US_MODIFICA FECHA_MODIFICA CUBA_ID_CUENTA TCON_ID_TIPO_CONCEPTO GRCON_ID_GRUPO_CONCEPTO PART_CODIGO_PARTIDA **VALOR_CONCEPTO** GRABA_IVA CONSIGNACION EXONERAR GRATUIDAD SUPRIMIR EDUCACION DESCUENTO EXISTENCIA GRUPO_CONEA RESOLUCION_HCU CUENTA_CONCEPTO | Excluir                                                    |
| `REC_TAB_CONCEPTOS_PROCESOS`  |   554 | 🟠 dominio: recaudación                                                         | ORG_PROC_ID CONC_ID_CONCEPTO RTS_CODIGO PARA_NRO_MATRICULA DIFERENCIADA NIVEL_INICIO NIVEL_FIN ACTIVADO CANTIDAD ORDEN                                                                                                                                                                                                                     | Excluir. Muchos codigos que no se entienden que significan |
| `REC_TAB_CUENTAS_CONCEPTOS`   |     9 | 🟠 dominio: recaudación<br>🟡 texto libre: DESCRIPCION                          | CUENTA DESCRIPCION ESTADO                                                                                                                                                                                                                                                                                                                  | Excluir                                                    |
| `REC_TAB_ENVIOS_BANCO`        |   280 | 🟠 dominio: recaudación                                                         | NRO_ENVIO FECHA_DESDE FECHA_HASTA FECHA_ENVIO PROCESADO US_CREA                                                                                                                                                                                                                                                                            | Excluir                                                    |
| `REC_TAB_ESTADO_PROCESOS`     |     8 | 🟠 dominio: recaudación<br>🟡 texto libre: DESCRIPCION_ESTADO                   | ID_ESTADO_PROCESO DESCRIPCION_ESTADO                                                                                                                                                                                                                                                                                                       | Permitir                                                   |
| `REC_TAB_GRUPOS_CONCEPTOS`    |    30 | 🟠 dominio: recaudación<br>🟡 texto libre: DESCRIPCION_GRUPO                    | ID_GRUPO_CONCEPTO DESCRIPCION_GRUPO                                                                                                                                                                                                                                                                                                        | Permitir                                                   |
| `REC_TAB_GRUPO_CONEA`         |    13 | 🟠 dominio: recaudación<br>🟡 texto libre: DESCRIPCION                          | CODIGO DESCRIPCION ESTADO                                                                                                                                                                                                                                                                                                                  | Permitir                                                   |
| `REC_TAB_MODO_OPERACION_FACT` |     2 | 🟠 dominio: recaudación                                                         | CODIGO OPERACION                                                                                                                                                                                                                                                                                                                           | Permitir                                                   |
| `REC_TAB_ORGANIZAR_PROCESOS`  |   570 | 🟠 dominio: recaudación                                                         | ID TPROC_COD_PROCESO ESQ_ESTUD_DEPEN_CODIGO ESQ_ESTUD_DEPEN_INST_CODIGO ESQ_ESTUD_TFINANCIA_CODIGO ESQ_ESTUD_MODA_ESTUD_CODIGO ESQ_ESTUD_TCICLOACAD_CODIGO ESQ_ESTUD_SIST_ESTUD_CODIGO NIVEL_INICIO NIVEL_FIN                                                                                                                              | Permitir, son puro codigos nada de cedulas nombres etc     |
| `REC_TAB_PORCENTAJES_IVA`     |    10 | 🟠 dominio: recaudación<br>🟡 texto libre: DESCRIPCION_PORCE_IVA                | CODIGO CODIGO_IVA_FACT_ELECT PORCENTAJE_IVA_FACT_EL CODIGO_PORCENT_IVA FECHA_DESDE FECHA_HASTA DESCRIPCION_PORCE_IVA ESTADO PARA_RECAUDACIONES                                                                                                                                                                                             | Permitir                                                   |
| `REC_TAB_RANGOS`              |     2 | 🟠 dominio: recaudación                                                         | DESDE HASTA FORMA_PAGO                                                                                                                                                                                                                                                                                                                     | Permitir                                                   |
| `REC_TAB_SECTOR`              |     3 | 🟠 dominio: recaudación<br>🟡 texto libre: DESCRIPCION                          | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                                         | Permitir                                                   |
| `REC_TAB_SECUENCIAS_PTO_VTA`  |     7 | 🟠 dominio: recaudación                                                         | CODIGO PUNTO_VENTA SECUENCIA                                                                                                                                                                                                                                                                                                               | Permitir                                                   |
| `REC_TAB_TIPOS_CONCEPTOS`     |    31 | 🟠 dominio: recaudación<br>🟡 texto libre: DESCRIPCION_TIPO                     | ID_TIPO_CONCEPTO DESCRIPCION_TIPO                                                                                                                                                                                                                                                                                                          | Permitir                                                   |
| `REC_TAB_TIPOS_DOCUMENTOS`    |     3 | 🟠 dominio: recaudación                                                         | COD_DOCUMENTO DOCUMENTO                                                                                                                                                                                                                                                                                                                    | Permitir                                                   |
| `REC_TAB_TIPOS_PROCESOS`      |    14 | 🟠 dominio: recaudación                                                         | COD_PROCESO PROCESO                                                                                                                                                                                                                                                                                                                        | Permitir                                                   |
| `REC_TAB_TIPOS_TRANSACCION`   |     3 | 🟠 dominio: recaudación                                                         | CODIGO TIPO_TRANSACCION OPERACION                                                                                                                                                                                                                                                                                                          | Permitir                                                   |
| `REC_TAB_TIPO_DECLARACION`    |     3 | 🟠 dominio: recaudación<br>🟡 texto libre: DESCRIPCION                          | COD_TIPO_DECLARA DESCRIPCION                                                                                                                                                                                                                                                                                                               | Permitir                                                   |
| `REC_TEM_CONCEPTOS`           |   391 | 🟠 dominio: recaudación<br>🟡 texto libre: DESCRIPCION_CONCEPTO, VALOR_CONCEPTO | ID_CONCEPTO DESCRIPCION_CONCEPTO ACTIVO CUBA_ID_CUENTA GRCON_ID_GRUPO_CONCEPTO **VALOR_CONCEPTO** GRATUIDAD GRUPO_CONEA PRUEBA                                                                                                                                                                                                             | Excluir. Por codigo se puede ver gratuidad                 |
| `REC_TEM_DEPENDENCIAS`        |    98 | 🟠 dominio: recaudación<br>🟡 texto libre: NOMBRE                               | CODIGO NOMBRE DEPEN_CODIGO ESTADO                                                                                                                                                                                                                                                                                                          | Excluyo                                                    |
| `REC_TEM_INGRESOS_GRUPOS`     |  1593 | 🟠 dominio: recaudación<br>🟡 texto libre: VALOR_CONCEPTO                       | ANIO ID_CONCEPTO CODIGO_ESPECIALIDAD **VALOR_CONCEPTO** CANTIDAD SUBTOTAL ESTADO PROCESADO                                                                                                                                                                                                                                                 | Excluir. Detalles de pagos                                 |

#### RHC (13)

| Tabla                           | Filas | Por qué salió                                                                                            | Columnas visibles (en **negrita** las que piden ojo)                                                                                                                                                                                                                                        | Decisión                                                                                                                 |
| ------------------------------- | ----: | -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `RHC_TAB_CONSEJOS`              |    28 | 🟠 dominio: consejos / resoluciones<br>🟡 texto libre: DESCRIPCION                                       | CODIGO DEPEN_CODIGO INST_CODIGO TCONSEJO_CODIGO ESTADO CONSEJO_CODIGO DESCRIPCION SECUENCIA                                                                                                                                                                                                 | Permitir                                                                                                                 |
| `RHC_TAB_CONTENIDO_DOCUMENTOS`  |  5304 | 🟠 dominio: consejos / resoluciones<br>⚪ muchas filas para catálogo (~5304)<br>🟡 texto libre: CONTENIDO | CODIGO CONTENIDO FUNCION PER_ACAD_CODIGO DOCLEGAL_CODIGO CONTDOC_PER_ACAD_CODIGO DOCLEGAL_PADRE_CODIGO CONTDOC_CODIGO TCONTDOC_CODIGO CONTDOC_TCONTDOC_CODIGO ITEM SECUENCIA_1 SECUENCIA_2 SECUENCIA_3 SECUENCIA_4 SECUENCIA_5 SECUENCIA_6 SECUENCIA_7 SECUENCIA_8 SECUENCIA_9 SECUENCIA_10 | Excluir muchas filas. Son de documentos legales                                                                          |
| `RHC_TAB_DETALLERESOL_MATERIAS` |     2 | 🟠 dominio: consejos / resoluciones                                                                      | RESOLUCION_NUMERO PTORDEN_NUMERO SESION_FECHA PERCONSEJO_FECHA_INICIO CONSEJO_CODIGO TSESION_CODIGO PRIMERA_PARCIAL SEGUNDA_PARCIAL TERCERA_PARCIAL SUPLETORIO NIVEL_CODIGO MATERIA_CODIGO                                                                                                  | Excluir debido a que hay una columna que dice descripcion y esta en ninguna siempre pero no se como se llene normalmente |
| `RHC_TAB_DOCUMENTOS_LEGALES`    |    46 | 🟠 dominio: consejos / resoluciones<br>🟡 texto libre: NOMBRE, DESCRIPCION                               | CODIGO NOMBRE DESCRIPCION FECHA_CREACION ESTADO PER_ACAD_CODIGO INST_CODIGO DEPEN_CODIGO                                                                                                                                                                                                    | Permitir                                                                                                                 |
| `RHC_TAB_ESTADO_RESOLUCION`     |     4 | 🟠 dominio: consejos / resoluciones<br>🟡 texto libre: DESCRIPCION                                       | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                          | Vacio. Excluir solo estructura.                                                                                          |
| `RHC_TAB_PERIODOS_CONSEJOS`     |     9 | 🟠 dominio: consejos / resoluciones                                                                      | FECHA_INICIO FECHA_FIN ESTADO CONSEJO_CODIGO                                                                                                                                                                                                                                                | Permitir                                                                                                                 |
| `RHC_TAB_TCONTENIDO_DOCUMENTOS` |   141 | 🟠 dominio: consejos / resoluciones<br>🟡 texto libre: DESCRIPCION                                       | CODIGO DESCRIPCION TCONTDOC_CODIGO                                                                                                                                                                                                                                                          | Excluir. No se que contiene widememo                                                                                     |
| `RHC_TAB_TIPOS_CONSEJOS`        |     9 | 🟠 dominio: consejos / resoluciones<br>🟡 texto libre: NOMBRE, DESCRIPCION                               | CODIGO NOMBRE DESCRIPCION SIGLAS TCONSEJO_CODIGO                                                                                                                                                                                                                                            | Permitir                                                                                                                 |
| `RHC_TAB_TIPOS_DETALLE_DOCENTE` |     6 | 🟠 dominio: consejos / resoluciones<br>🟡 texto libre: DESCRIPCION                                       | CODIGO DESCRIPCION ESTADO OBSEVACION TIPO                                                                                                                                                                                                                                                   | Permitir                                                                                                                 |
| `RHC_TAB_TIPOS_DOC_RESPALDOS`   |     6 | 🟠 dominio: consejos / resoluciones<br>🟡 texto libre: NOMBRE, DESCRIPCION                               | CODIGO NOMBRE DESCRIPCION                                                                                                                                                                                                                                                                   | Excluir. Parece una tabla normal pero no puedo ver que dice widememo si no puede acceder ni tu metelo nomas              |
| `RHC_TAB_TIPOS_RESOLUCIONES`    |    87 | 🟠 dominio: consejos / resoluciones<br>🟡 texto libre: DESCRIPCION                                       | CODIGO DESCRIPCION TPUNTORD_CODIGO TCONSEJO_CODIGO                                                                                                                                                                                                                                          | Permitir                                                                                                                 |
| `RHC_TAB_TIPO_PUNTO_ORDEN`      |     4 | 🟠 dominio: consejos / resoluciones<br>🟡 texto libre: DESCRIPCION                                       | CODIGO DESCRIPCION SIGLAS                                                                                                                                                                                                                                                                   | Excluir. No puedo leer widememo                                                                                          |
| `RHC_TAB_TIPO_SESION`           |     3 | 🟠 dominio: consejos / resoluciones<br>🟡 texto libre: DESCRIPCION                                       | CODIGO DESCRIPCION SIGLAS                                                                                                                                                                                                                                                                   | Excluir. No puedo leer widememo                                                                                          |

#### RHU (63)

| Tabla                            | Filas | Por qué salió                                                                                                                    | Columnas visibles (en **negrita** las que piden ojo)                                                                                                                                                                                                                                                                         | Decisión                                               |
| -------------------------------- | ----: | -------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| `RHU_TAB_ABREVIATURAS`           |    25 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION NIVEL FECHA_CREACION FECHA_ACTUALIZACION ESTADO                                                                                                                                                                                                                                                           | Excluir                                                |
| `RHU_TAB_BITMPDEPENDENCIA`       |   209 | 🟠 dominio: talento humano<br>🟡 texto libre: NOMBRE_UNIVERSIDAD, NOMBRE_FACULTAD, NOMBRE_CARRERA                                | CODIGO_UNIVERSIDAD NOMBRE_UNIVERSIDAD SIGLAS_UNIVERSIDAD CODIGO_FACULTAD NOMBRE_FACULTAD SIGLAS_FACULTAD CODIGO_CARRERA NOMBRE_CARRERA SIGLAS_CARRERA                                                                                                                                                                        | Permitir                                               |
| `RHU_TAB_BITMPPUESTOS`           |   619 | 🟠 dominio: talento humano<br>🟡 texto libre: NOMBRE_PUESTO                                                                      | CODIGO_PUESTO NOMBRE_PUESTO                                                                                                                                                                                                                                                                                                  | Excluir                                                |
| `RHU_TAB_BITMPREGIMEN`           |    17 | 🟠 dominio: talento humano<br>🟡 texto libre: NOMBRE_AREA, NOMBRE_LEY, NOMBRE_REGIMEN                                            | CODIGO_AREA NOMBRE_AREA CODIGO_LEY NOMBRE_LEY CODIGO_REGIMEN NOMBRE_REGIMEN                                                                                                                                                                                                                                                  | Excluir                                                |
| `RHU_TAB_CAMPO_AMPLIO`           |   113 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | IDCAMPO IDCAMPOP DESCRIPCION                                                                                                                                                                                                                                                                                                 | Permitir                                               |
| `RHU_TAB_CARGOS_ACTIVIDADES`     |  1715 | 🟡 columna de persona ya oculta<br>🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION_ACTIVIDAD, DESCRIPCION_CONOCIMIENTO | CODIGO_ACTIVIDAD CODIGO_CARGO DESCRIPCION_ACTIVIDAD DESCRIPCION_CONOCIMIENTO ESTADO FECHA_CREACION FECHA_ACTUALIZACION                                                                                                                                                                                                       | Excluir                                                |
| `RHU_TAB_CARGOS_COMPET_OBSERVAB` |   126 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION_COMP_OBSERVAB                                                          | CODIGO_COMP_OBSERVAB CODIGO_COMPETENCIA CODIGO_COMP_NIVEL DESCRIPCION_COMP_OBSERVAB ESTADO                                                                                                                                                                                                                                   | Excluir                                                |
| `RHU_TAB_CARGOS_COMPET_TECNICAS` |    42 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION_DENOMINACION, DESCRIPCION_DEFINICION                                   | CODIGO_COMPETENCIA DESCRIPCION_DENOMINACION DESCRIPCION_DEFINICION ESTADO                                                                                                                                                                                                                                                    | Permitir                                               |
| `RHU_TAB_CARGOS_COMPET_TEC_COND` |  1036 | 🟠 dominio: talento humano                                                                                                       | CODIGO CODIGO_CARGO CODIGO_COMP_OBSERVAB ESTADO                                                                                                                                                                                                                                                                              | Excluir                                                |
| `RHU_TAB_CARGOS_GRUPO_OCUPACIO`  |    21 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | GRUPO_OCU_CODIGO DESCRIPCION ESTADO GRADO RMU                                                                                                                                                                                                                                                                                | Excluir                                                |
| `RHU_TAB_CARGOS_INSTRUC_FORMAL`  |     8 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | INSTRUCCION_CODIGO DESCRIPCION ESTADO ORDEN                                                                                                                                                                                                                                                                                  | Permitir                                               |
| `RHU_TAB_CARGOS_NIVEL_OCUPACIO`  |    11 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION_NIVEL_OCU                                                              | CODIGO_NIVEL_OCU DESCRIPCION_NIVEL_OCU CODIGO_GRUPO_NIVEL_OCU ESTADO REGIMEN_CODIGO                                                                                                                                                                                                                                          | Permitir                                               |
| `RHU_TAB_CARGOS_PROCESOS`        |     6 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | PROCESO_CODIGO DESCRIPCION ESTADO PROCESO_COD_PADRE FUNCION DEPEN_CODIGO INST_CODIGO                                                                                                                                                                                                                                         | Excluir                                                |
| `RHU_TAB_CARGOS_ROL`             |     8 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION, NIVEL_NOMBRE                                                          | ROL_CODIGO DESCRIPCION ESTADO NIVEL NIVEL_NOMBRE                                                                                                                                                                                                                                                                             | Permitir                                               |
| `RHU_TAB_DEDICACION`             |     5 | 🟠 dominio: talento humano<br>🟡 texto libre: NOMBRE_DEDICACION                                                                  | CODIGO_DEDICACION NOMBRE_DEDICACION ABREBIATURA NUMERO_HORAS ESTADO CODIGO_DEDICA_ACA                                                                                                                                                                                                                                        | Permitir                                               |
| `RHU_TAB_DEPENDENCIAS_ORG`       |    72 | 🟠 dominio: talento humano<br>🟡 texto libre: NOMBRE, DESCRIPCION                                                                | CODIGO NOMBRE TDEPEN_CODIGO FUNCION DEPEN_CODIGO DESCRIPCION SIGLAS CODIGO_EQUIVALENTE PADRE_EQUIVALENTE                                                                                                                                                                                                                     | Permitir                                               |
| `RHU_TAB_DEPENDENCIAS_ORGANIGR`  |   455 | 🟠 dominio: talento humano<br>🟡 texto libre: NOMBRE, DESCRIPCION                                                                | CODIGO NOMBRE TDEPEN_CODIGO FUNCION DEPEN_CODIGO DESCRIPCION SIGLAS ORGANICO_CODIGO                                                                                                                                                                                                                                          | Permitir                                               |
| `RHU_TAB_DESIGNACION`            |    20 | 🟠 dominio: talento humano<br>🟡 texto libre: NOMBRE_DESIGNACION                                                                 | CODIGO_DESIGNACION NOMBRE_DESIGNACION ABREVIATURA                                                                                                                                                                                                                                                                            | Permitir                                               |
| `RHU_TAB_DETALLES_ESCALAFONES`   |   269 | 🟡 columna de persona ya oculta<br>🟠 dominio: talento humano                                                                    | ESCALAFONES_ANIO REF_ESCALAFONES_CODIGO PUNTAJE                                                                                                                                                                                                                                                                              | Excluir                                                |
| `RHU_TAB_DETALLE_COMBUSTIBLE`    |  7386 | 🟠 dominio: talento humano<br>⚪ muchas filas para catálogo (~7386)<br>🟡 texto libre: VALOR                                      | CODIGO_ORDEN CODIGO_T_COMBUSTIBLE UNIDAD **VALOR**                                                                                                                                                                                                                                                                           | Excluir                                                |
| `RHU_TAB_DETALLE_ESTIMATIVO`     |     0 | 🟠 dominio: talento humano<br>🟡 texto libre: VALOR                                                                              | CODIGO_ESTIMATIVO FECHA RECORRIDO KILOMETROS CONSUMO_GASOLINA **VALOR** CODIGO                                                                                                                                                                                                                                               | Excluir                                                |
| `RHU_TAB_DETALLE_HORARIOS`       |     6 | 🟠 dominio: talento humano                                                                                                       | HORA_ENTRADA1 HORA_SALIDA1 HORA_ENTRADA2 HORA_SALIDA2 HORA_ENTRADA3 HORA_SALIDA3 HORA_ENTRADA4 HORA_SALIDA4 HORARIO_CODIGO DIA_CODIGO                                                                                                                                                                                        | Permitir                                               |
| `RHU_TAB_DETALLE_MANTE_VEHICULO` |     0 | 🟠 dominio: talento humano<br>🟡 texto libre: DETALLE_MANTENIMIENTO, CODIGO_DETALLE                                              | CODIGO_MANTENIMIENTO DETALLE_MANTENIMIENTO CODIGO_DETALLE                                                                                                                                                                                                                                                                    | Excluir                                                |
| `RHU_TAB_DIAS_SEMANA`            |     7 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Permitir                                               |
| `RHU_TAB_ESCALA_OCUPACIONAL`     |    36 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION NIVEL_OCUPACIONAL REGIMEN_LABORAL ESTADO FECHA_CREACION FECHA_ACTUALIZACION                                                                                                                                                                                                                               | Excluir                                                |
| `RHU_TAB_ESTADOS_LABORALES`      |     6 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Permitir                                               |
| `RHU_TAB_ESTIMATIVO_COMBUSTIBLE` |     0 | 🟡 columna de persona ya oculta<br>🟠 dominio: talento humano<br>🟡 texto libre: NOTA                                            | CODIGO DEPENDENCIA CODIGO_VEHICULO FECHA_ACTUAL NOTA                                                                                                                                                                                                                                                                         | Excluir. Vacio pero posiblemente llene un usuario real |
| `RHU_TAB_FECHA`                  |     5 | 🟠 dominio: talento humano                                                                                                       | FECHA                                                                                                                                                                                                                                                                                                                        | Permitir                                               |
| `RHU_TAB_FORMACION_EDUCATIVA`    |    19 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION, DESCRIPCION_SENESCYT                                                  | CODIGO DESCRIPCION PUNTAJE DESCRIPCION_SENESCYT NIVEL ORDEN_JERARQUICO VALIDADO                                                                                                                                                                                                                                              | Permitir                                               |
| `RHU_TAB_GRUPOS_ESCALAFON`       |    15 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Permitir                                               |
| `RHU_TAB_HORARIOS`               |     4 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION HORA_ENTRADA HORA_SALIDA SIGUIENTE_DIA THORARIO_CODIGO ESTADO                                                                                                                                                                                                                                             | Excluir                                                |
| `RHU_TAB_IDIOMAS`                |    46 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Permitir                                               |
| `RHU_TAB_LEYES_ORGANICAS`        |     4 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION_LEY                                                                    | CODIGO_LEY DESCRIPCION_LEY CODIGO_AREA                                                                                                                                                                                                                                                                                       | Permitir                                               |
| `RHU_TAB_MANTENIMIENTO_VEHICULO` |     0 | 🟠 dominio: talento humano                                                                                                       | CODIGO_MANTENIMIENTO CODIGO_VEHICULO FECHA_MANTENIMIENTO KILOMETRAJE MECANICA NRO_FACTURA                                                                                                                                                                                                                                    | Excluir                                                |
| `RHU_TAB_MESES`                  |    12 | 🟠 dominio: talento humano<br>🟡 texto libre: DETALLE                                                                            | CODIGO DETALLE                                                                                                                                                                                                                                                                                                               | Permitir                                               |
| `RHU_TAB_MOTIVOS`                |   389 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION FECHA_CREACION FECHA_ACTUALIZACION ESTADO CODIGO_PADRE NECESARIO FUNCION                                                                                                                                                                                                                                  | Excluir                                                |
| `RHU_TAB_NRO_DOC_CARRERA_PENSUM` |   187 | 🟠 dominio: talento humano                                                                                                       | CARRERA_CODIGO PERIODO RELACION_LABORAL TIEMPO_COMPLETO TC_PORCENTAJE MEDIO_TIEMPO MT_PORCENTAJE TIEMPO_PARCIAL TP_PORCENTAJE AUXILIAR AUX_PORCENTAJE AGREGADO AGR_PORCENTAJE PRINCIPAL PRI_PORCENTAJE SERVICIOS_OCASIONALES SERV_OCAS_PORCENTAJE SERVICIOS_PROFESIONALES SERV_PROF_PORCENTAJE MODALIDAD ORDEN PENSUM_CODIGO | Excluir                                                |
| `RHU_TAB_NRO_DOC_PENSUM_DICTA`   |   174 | 🟠 dominio: talento humano                                                                                                       | CARRERA_CODIGO PERIODO RELACION_LABORAL TIEMPO_COMPLETO TC_PORCENTAJE MEDIO_TIEMPO MT_PORCENTAJE TIEMPO_PARCIAL TP_PORCENTAJE AUXILIAR AUX_PORCENTAJE AGREGADO AGR_PORCENTAJE PRINCIPAL PRI_PORCENTAJE SERVICIOS_OCASIONALES SERV_OCAS_PORCENTAJE SERVICIOS_PROFESIONALES SERV_PROF_PORCENTAJE MODALIDAD ORDEN PENSUM_CODIGO | Excluir                                                |
| `RHU_TAB_PAGINAS_OBRAS`          |     5 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Permitir                                               |
| `RHU_TAB_PROCESO_CONTRATOS_FIN`  |  1096 | 🟡 columna de persona ya oculta<br>🟠 dominio: talento humano                                                                    | FECHA_REGISTRO CONTRATOS_FINALIZADOS                                                                                                                                                                                                                                                                                         | Excluir                                                |
| `RHU_TAB_REF_ESCALAFONES`        |    11 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Permitir                                               |
| `RHU_TAB_REGIMEN_LABORAL`        |    18 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION ESTADO FECHA_CREACION FECHA_ACTUALIZACION                                                                                                                                                                                                                                                                 | Excluir                                                |
| `RHU_TAB_RELACIONES_FUNCIONALES` |     4 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Permitir                                               |
| `RHU_TAB_RELACIONES_LABORALES`   |     6 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Permitir                                               |
| `RHU_TAB_TIPOS_AUTORIDADES`      |   111 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION, NOMBRE_ROL                                                            | CODIGO DESCRIPCION ESTADO JERARQUIA AREA NOMBRE_ROL FECHA_CREACION FECHA_ACTUALIZACION                                                                                                                                                                                                                                       | Excluir                                                |
| `RHU_TAB_TIPOS_CAPACITACION`     |    16 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Permitir                                               |
| `RHU_TAB_TIPOS_COMBUSTIBLE`      |     5 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Excluir                                                |
| `RHU_TAB_TIPOS_CONTRATOS`        |    39 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION, NOMBRE_CONTRATO, TITULO_CONTRATO, VALOR_HORA                          | CODIGO DESCRIPCION TCONTR_CODIGO ESTADO FUNCION NOMBRE_CONTRATO TITULO_CONTRATO REGIMEN_LABORAL **VALOR_HORA** TIPO_SERVICIO                                                                                                                                                                                                 | Excluir                                                |
| `RHU_TAB_TIPOS_DEPENDENCIAS`     |    10 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION FUNCION TDEPEN_CODIGO                                                                                                                                                                                                                                                                                     | Permitir                                               |
| `RHU_TAB_TIPOS_EMPLEADOS`        |     6 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Permitir                                               |
| `RHU_TAB_TIPOS_ESCALAFONES`      |     9 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION FECHA_CREACION FECHA_ACTUALIZACION ESTADO REGIMEN                                                                                                                                                                                                                                                         | Excluir                                                |
| `RHU_TAB_TIPOS_FONDOS`           |    10 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Excluir                                                |
| `RHU_TAB_TIPOS_FORMACION`        |     3 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Excluir                                                |
| `RHU_TAB_TIPOS_HORAEXTRAS`       |     3 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION, VALOR                                                                 | CODIGO DESCRIPCION **VALOR** ESTADO PORCENTAJE                                                                                                                                                                                                                                                                               | Excluir                                                |
| `RHU_TAB_TIPOS_HORARIOS`         |     6 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION ESTADO                                                                                                                                                                                                                                                                                                    | Excluir                                                |
| `RHU_TAB_TIPOS_INF_ADICIONAL`    |     6 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION ESTADO                                                                                                                                                                                                                                                                                                    | Excluir                                                |
| `RHU_TAB_TIPOS_NOVEDADES`        |     3 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Excluir                                                |
| `RHU_TAB_TIPOS_PERSONAS`         |     4 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Permitir                                               |
| `RHU_TAB_TIPOS_PERS_CONTACTO`    |    15 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION ESTADO ORDEN                                                                                                                                                                                                                                                                                              | Excluir                                                |
| `RHU_TAB_TIPOS_SERVICIOS`        |    50 | 🟠 dominio: talento humano<br>🟡 texto libre: DETALLE                                                                            | CODIGO DETALLE PUNTAJE                                                                                                                                                                                                                                                                                                       | Excluir                                                |
| `RHU_TAB_TIPO_CARGA_FAMILIAR`    |     0 | 🟠 dominio: talento humano<br>🟡 texto libre: NOMBRE, DESCRIPCION                                                                | CODIGO NOMBRE DESCRIPCION ESTADO                                                                                                                                                                                                                                                                                             | Excluir                                                |
| `RHU_TAB_TIPO_EDUCACION`         |     5 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Permitir                                               |
| `RHU_TAB_TIPO_SANCION`           |     2 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION                                                                        | CODIGO DESCRIPCION                                                                                                                                                                                                                                                                                                           | Excluir                                                |

#### SOC (52)

| Tabla                            | Filas | Por qué salió                                                                                                           | Columnas visibles (en **negrita** las que piden ojo)                                                                                                                                  | Decisión                                                  |
| -------------------------------- | ----: | ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| `SOC_TAB_ACCIONES_CORRECTIVAS`   |     4 | 🟡 columna de persona ya oculta<br>🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION, MOTIVO_ACCION_REALIZAR | CODIGO DESCRIPCION GRUPO_OBJETIVO FECHA_PROPUEST_EJECUCION_DESDE FECHA_EJECUCION_DESDE MOTIVO_ACCION_REALIZAR PRIORIDAD_CODIGO FECHA_PROPUEST_EJECUCION_HASTA FECHA_EJECUCION_HASTA   | Excluir                                                   |
| `SOC_TAB_ACTIVIDADES_EXTRALABO`  |    14 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             | Excluir                                                   |
| `SOC_TAB_ANIMALES_DOMESTICOS`    |    12 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             | Excluir                                                   |
| `SOC_TAB_APTITUDES_LABORALES`    |     7 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             | Excluir                                                   |
| `SOC_TAB_ARTICULOS`              |   715 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION, VALOR_MAXIMO, VALOR_MINIMO                                | CODIGO DESCRIPCION **VALOR_MAXIMO** **VALOR_MINIMO** FECHA_CADUCIDAD TIPO ESTADO PRESENTMED_CODIGO AREA_CODIGO REACCION                                                               | Excluir                                                   |
| `SOC_TAB_CARGOS_TAREAS`          |     3 | 🟠 dominio: salud ocupacional                                                                                           | CODIGO CARGO_CODIGO CARGO_AUTORIDAD_CODIGO TAREA_CODIGO PORCENTAJE_TIEMPO_TAREA                                                                                                       | Excluir                                                   |
| `SOC_TAB_CARGOS_TAREAS_RIESGOS`  |     2 | 🟠 dominio: salud ocupacional                                                                                           | FECHA_DETECCION FUENTES EFECTOS TIEMPO_EXPOSICION_DIA CARGO_TAREA_CODIGO SUBRIESGO_CODIGO FRECUENCIA_CODIGO NIVELRIESG_CODIGO NUM_HOMBRES_EXPUESTOS_RIESG NUM_MUJERES_EXPUESTAS_RIESG | Excluir                                                   |
| `SOC_TAB_CARG_TAR_RIES_ACCION`   |     0 | 🟠 dominio: salud ocupacional                                                                                           | CARGO_TAREA_CODIGO SUBRIESGO_CODIGO ACCCORRPRE_CODIGO                                                                                                                                 | Excluir. Vacio                                            |
| `SOC_TAB_CICLOS_TRABAJOS`        |     3 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION                                                                                                                                                                    | Excluir                                                   |
| `SOC_TAB_EQUIPOS_PROTECCION`     |    40 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION                                                                                                                                                                    | Excluir. Catalogo de instrumentos de proteccion           |
| `SOC_TAB_EXIGENCIAS_CARGOS`      |     9 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             | Excluir                                                   |
| `SOC_TAB_FRECUENCIA`             |     9 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             | Excluir                                                   |
| `SOC_TAB_GRADOS_INCAPACIDAD`     |    25 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             | Excluir                                                   |
| `SOC_TAB_GRADOS_VALORACION_PRO`  |     6 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION                                                                                                                                                                    | Excluir a descrecion tuya. No se entiende bien de que va. |
| `SOC_TAB_GRUPOS_FUNCIONES`       |     4 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             | Excluir a descrecion tuya. No se entiende bien de que va. |
| `SOC_TAB_GRUPOS_HERRAMIENTAS`    |    22 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             | Excluir a descrecion tuya. No se entiende bien de que va. |
| `SOC_TAB_GRUPOS_RIESGOS`         |     8 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             | Excluir a descrecion tuya. No se entiende bien de que va. |
| `SOC_TAB_HERRAMIENTAS`           |   168 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO GRUPHERRAM_CODIGO                                                                                                                                           | Excluir                                                   |
| `SOC_TAB_HORAS_LABORABLES`       |     9 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_LEYES_DOCUMENTOS`       |     4 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_LISTADO_PROTOCOLOS`     |    15 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION TIPO                                                                                                                                                               |                                                           |
| `SOC_TAB_MANIPULACION_CARGAS`    |     2 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION                                                                                                                                                                    |                                                           |
| `SOC_TAB_MATERIALES`             |    24 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION CORRESPONDE ESTADO                                                                                                                                                 |                                                           |
| `SOC_TAB_MEDFUNCIONES_RIESGOS`   |     1 | 🟠 dominio: salud ocupacional                                                                                           | MEDFUNC_CODIGO SUBRIESGO_CODIGO                                                                                                                                                       |                                                           |
| `SOC_TAB_MEDFUNCIONES_UNIDADES`  |     5 | 🟠 dominio: salud ocupacional                                                                                           | MEDFUNC_CODIGO UNIDAD_LABORAL                                                                                                                                                         |                                                           |
| `SOC_TAB_MEDICOS_FUNC_MED_OCUP`  |     6 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: LUGAR, DESCRIPCION                                                     | CODIGO TEMA NUMERO_ASISTENTES FECHA LUGAR TIEMPO_DURACION_MIN INTRAMURAL_EXTRAMURAL DESCRIPCION AVAL OTFUNMOCUP_CODIGO NUM_CUESTIONARIO_EVIDENCIA_RI                                  |                                                           |
| `SOC_TAB_NIVELES_RIESGO`         |     4 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_OTRAS_FUNC_MEDIC_OCUP`  |    28 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION GRUPFUNCION_CODIGO ESTADO                                                                                                                                          |                                                           |
| `SOC_TAB_POSICIONES`             |     5 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_PREGUNTAS`              |   457 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION PREGUN_CODIGO ESTADO                                                                                                                                               |                                                           |
| `SOC_TAB_PRESENTACION_DOSIS`     |     6 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_PRESENTACION_MEDICAMEN` |    18 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_PRIORIDADES`            |     3 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION                                                                                                                                                                    |                                                           |
| `SOC_TAB_PROTOCOLOS_CONCEPTOS_L` |     0 | 🟠 dominio: salud ocupacional                                                                                           | LISTPROTOC_CODIGO TIPEXAMENL_ID                                                                                                                                                       |                                                           |
| `SOC_TAB_PROTOCOLOS_IMAGENES`    |     0 | 🟠 dominio: salud ocupacional                                                                                           | TIPOIMAGEN_CODIGO LISTPROTOC_CODIGO                                                                                                                                                   |                                                           |
| `SOC_TAB_PROTOCOLOS_RIESGOS`     |     0 | 🟠 dominio: salud ocupacional                                                                                           | LISTPROTOC_CODIGO SUBRIESGO_CODIGO                                                                                                                                                    |                                                           |
| `SOC_TAB_PROTOCOLO_PARTE_CUERP`  |     0 | 🟠 dominio: salud ocupacional                                                                                           | LISTPROTOC_CODIGO PARTCUERP_CODIGO                                                                                                                                                    |                                                           |
| `SOC_TAB_RIESGOS_NIVELES_RIESG`  |     0 | 🟠 dominio: salud ocupacional                                                                                           | DETERMINADAS_CONDICIONES MEDIDAS_PREVENTIVAS NIVELRIESG_CODIGO SUBRIESGO_CODIGO                                                                                                       |                                                           |
| `SOC_TAB_SEGURIDAD_LABORAL_EMP`  |     6 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_SERVICIOS`              |    15 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_SERVICIOS_BASICOS`      |     9 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_SUBGRUPOS_RIESGOS`      |    91 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION TIEMPO_EXPOSICION_PERMITIDO ESTADO GRUPRIESGO_CODIGO                                                                                                               |                                                           |
| `SOC_TAB_TAREAS`                 |   152 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_TIEMPO_INCAPACIDADES`   |     2 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_TIPOS_ACCIDENTES_LABO`  |     2 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_TIPOS_CONDICIONES`      |     4 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION                                                                                                                                                                    |                                                           |
| `SOC_TAB_TIPOS_HORARIOS`         |     0 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_TIPOS_LABOR`            |     3 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_TIPOS_RELACIONES_SOCI`  |     5 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION                                                                                                                                                                    |                                                           |
| `SOC_TAB_TIPOS_SALARIOS`         |     0 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_TRANSPORTES`            |     6 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |
| `SOC_TAB_VIAS_ADMINISTRACION`    |    10 | 🟠 dominio: salud ocupacional<br>🟡 texto libre: DESCRIPCION                                                            | CODIGO DESCRIPCION ESTADO                                                                                                                                                             |                                                           |

#### SST (37)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `SST_TAB_ACCINC_ACCSUB` | 0 | 🟠 dominio: seguridad y salud ocupacional | CODIGO_INVESTIGA CODIGO_ACCSUB NUM_ACCSUB | |
| `SST_TAB_ACCINC_CONSECUE_ACCI` | 0 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE, DESCRIPCION | CODIGO NOMBRE DESCRIPCION ESTADO | |
| `SST_TAB_ACCINC_CONSUB` | 0 | 🟠 dominio: seguridad y salud ocupacional | CODIGO_INVESTIGA CODIGO_CONSUB NUM_CONSUB | |
| `SST_TAB_ACCINC_DESCRIP_ACCI` | 0 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: DESCRIPCION_DETALLADA | CODIGO_INVESTIGA ACTIVIDA_RALIZADA DESCRIPCION_DETALLADA ELEMETO_LESONIANTE OCURRIDO | |
| `SST_TAB_ACCINC_FACPER` | 0 | 🟠 dominio: seguridad y salud ocupacional | CODIGO_INVESTIGA CODIGO_FACPER NUM_FACPER | |
| `SST_TAB_ACCINC_FACTRA` | 0 | 🟠 dominio: seguridad y salud ocupacional | CODIGO_INVESTIGA CODIGO_FACTRA NUM_FACTRA | |
| `SST_TAB_ACCINC_INFORMA_ACCIDEN` | 0 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: LUGAR_ACCIDENTE | CODIGO_INVESTIGA FECHA_ACCIDENTE LUGAR_ACCIDENTE HORAS_TRABAJADAS CONSECUE_EVENTO DIA_ACCIDENTE | |
| `SST_TAB_ACCINC_MED_COR` | 0 | 🟡 columna de persona ya oculta<br>🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: DESCRIPCION | CODIGO_INVESTIGA NUM_MEDIDA DESCRIPCION FECHA_LIMITE_CUM | |
| `SST_TAB_ACCINC_PAR_LECION` | 0 | 🟠 dominio: seguridad y salud ocupacional | CODIGO_INVESTIGA NUMERO_PAR_LECIONA CODIGO_PARTE_LECIONADA | |
| `SST_TAB_ACCINC_TIPO_ACCIDENTE` | 0 | 🟠 dominio: seguridad y salud ocupacional | CODIGO_INVESTIGA CODIGO_ACCIDENTE NUM_TIPO_ACCI | |
| `SST_TAB_ACCIONES_SUBESTANDAR` | 0 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE, DESCRIPCION | CODIGO NOMBRE DESCRIPCION ESTADO | |
| `SST_TAB_ACT_ACTA` | 7 | 🟠 dominio: seguridad y salud ocupacional | CODIGO_ACT TIPO_REU NUM_ACT CODIGO_COM FECHA_ACT HORA_INI HORA_FIN ESTADO_FIN | |
| `SST_TAB_ACT_ASUNTRA` | 7 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NUM_ASUNTO, DESCRIPCION | CODIGO_ACT NUM_ASUNTO DESCRIPCION | |
| `SST_TAB_ADM_AREA` | 0 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE_ARE | CODIGO_ARE NOMBRE_ARE DESACRIPCION_ARE ESTADO_ARE | |
| `SST_TAB_APTITU_MIN_EXI` | 22 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE | CODIGO NOMBRE ESTADO | |
| `SST_TAB_BIRGADAS` | 1 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE_BRI, DESCRIPCION_BRI | CODIGO_BRI NOMBRE_BRI DESCRIPCION_BRI ACTIVIDAD_BRI ESTADO_BRI | |
| `SST_TAB_CAR_BRIGADA` | 2 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: DESCRIPCION_CAR_BRI, NOMBRE_CAR_BRI | CODIGO_CAR_BRI DESCRIPCION_CAR_BRI ESTADO_CAR_BRI NOMBRE_CAR_BRI | |
| `SST_TAB_COM_CARGOCOMITE` | 7 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE_CARGO, DESCRIPCION_CARGO | CODIGO_CARGO NOMBRE_CARGO DESCRIPCION_CARGO ESTADO_CARGO | |
| `SST_TAB_COM_COMITES` | 7 | 🟠 dominio: seguridad y salud ocupacional | CODIGO_COM CODIGO_TIP FECHA_INI FECHA_FIN ESTADO_COM | |
| `SST_TAB_COM_TIPOS` | 8 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE_TIP, DESCRIPCION_TIP | CODIGO_TIP NOMBRE_TIP DESCRIPCION_TIP ESTADO_TIP | |
| `SST_TAB_CONDICION_SUBESTANDAR` | 0 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE, DESCRIPCION | CODIGO NOMBRE DESCRIPCION ESTADO | |
| `SST_TAB_EEP_CARGO` | 3 | 🟠 dominio: seguridad y salud ocupacional | CODIGO_CARGO CODIGO_INV | |
| `SST_TAB_EPP_INVENTARIO` | 24 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE_INV, DESCRIPCION_EPP | CODIGO_INV NOMBRE_INV CODIGO_UNI CARACTERISTICAS_EPP DESCRIPCION_EPP ESTADO_EPP | |
| `SST_TAB_EPP_ITEM` | 7 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: VALOR_ITE | CODIGO_INV CODIGO_TN CANTIDA_ITE **VALOR_ITE** NUM_ITE ESTADO_ITE | |
| `SST_TAB_EPP_MOTIDOTA` | 5 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE_MD, DESCRIPCION_MD | CODIGO_MD NOMBRE_MD DESCRIPCION_MD ESTADO_MD | |
| `SST_TAB_EPP_TALNUM` | 12 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE_TN, DESCRIPCION_TN | CODIGO_TN NOMBRE_TN DESCRIPCION_TN ESTADO_TN | |
| `SST_TAB_EPP_UNIDAD` | 8 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE_UNI, DESCRIPCION_UNI | CODIGO_UNI NOMBRE_UNI DESCRIPCION_UNI ESTADO_UNI | |
| `SST_TAB_EVA_EXI_PSI_PT` | 14 | 🟠 dominio: seguridad y salud ocupacional | CODIGO_EXI_PSI CODIGO_APT_MIN EXI_PSI_NOM EXI_PSI_VAL | |
| `SST_TAB_EVA_INICIAL` | 6 | 🟡 columna de persona ya oculta<br>🟠 dominio: seguridad y salud ocupacional | CODIGO CODIFICACION FECHA_ELABORACION FECHA_REVICION FECHA_APROBACION CODIGO_ARE CODIGO_CARGO NUM_TRABAJADORES TIEMPO_EXPOSICION PROCESO SUBPROCESO | |
| `SST_TAB_EXI_PSI_PT` | 7 | 🟡 columna de persona ya oculta<br>🟠 dominio: seguridad y salud ocupacional | CODIGO FECHA_REA CODIGO_CARGO | |
| `SST_TAB_FACTOR_PERSONAL` | 0 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE, DESCRIPCION | CODIGO NOMBRE DESCRIPCION ESTADO FACT_PERS_CODIGO | |
| `SST_TAB_FACTOR_TRABAJO` | 0 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE, DESCRIPCION | CODIGO NOMBRE DESCRIPCION ESTADO FACT_TRAB_CODIGO | |
| `SST_TAB_INS_CONCLUCIONES` | 6 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: DESCRIPCION_CONCLU | CODIGO_INS NUM_CONCLUCIONES DESCRIPCION_CONCLU | |
| `SST_TAB_INS_CONDI_ENCON` | 9 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: DESCRIPCION_COND_INS | CODIGO_INS NUM_CONDI_INS DESCRIPCION_COND_INS | |
| `SST_TAB_RIE_FACTORES` | 63 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE_FAC, DESCRIPCION_FAC | CODIGO_FAC NOMBRE_FAC DESCRIPCION_FAC LIMITE_INFERIOR_FAC LIMITE_INTERMEDIO_FAC LIMITE_SUPERIOR_FAC LIMITE_NOPERMITIDO_FAC ESTADO_FAC COD_FAC_PADRE | |
| `SST_TAB_RIE_INICIAL` | 11 | 🟠 dominio: seguridad y salud ocupacional | CODIGO_EVA_INI CODIGO_FAC PROBABILIDAD CONSECUENCIA ESTIMACION_RIE ESTIMACION_RIE_VAL | |
| `SST_TAB_TIPOS_ACCIDENTES` | 0 | 🟠 dominio: seguridad y salud ocupacional<br>🟡 texto libre: NOMBRE, DESCRIPCION | CODIGO NOMBRE DESCRIPCION ESTADO | |

#### THU (20)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `THU_TAB_CARGO_COMPETENCIAS` | 8 | 🟠 dominio: talento humano | CARGO_CODIGO COMP_CODIGO TNCOM_CODIGO PERFIL_IDEAL COMPORTAMIENTO_OBSERVABLE | |
| `THU_TAB_CARGO_FUNCIONES` | 277 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION | CODIGO CARGO_CODIGO DESCRIPCION TTFUN_CODIGO SECUENCIA | |
| `THU_TAB_CARGO_REQUISITOS` | 4 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION | TCAR_CODIGO TFVAL_CODIGO DESCRIPCION | |
| `THU_TAB_COMPETENCIAS` | 9 | 🟠 dominio: talento humano<br>🟡 texto libre: NOMBRE | CODIGO TTCOM_CODIGO NOMBRE DEFINICION | |
| `THU_TAB_FACTOR_CRITERIO_VALOR` | 47 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION | TFVAL_CODIGO TNREF_CODIGO DESCRIPCION | |
| `THU_TAB_FACTOR_VALORATIVO` | 17 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION, NOMBRE | CODIGO DESCRIPCION NOMBRE FACTOR_CODIGO TTFV_CODIGO PONDERACION ANIOS_EXPERIENCIA | |
| `THU_TAB_FUNCIONES_PROCESOS` | 154 | 🟠 dominio: talento humano | TCFUN_CODIGO BPROC_CODIGO | |
| `THU_TAB_FUNCIONES_PROCESOS_AU` | 154 | 🟠 dominio: talento humano | TCFUN_CODIGO BPROC_CODIGO PROCESO | |
| `THU_TAB_GRUPO_OCUPACIONAL` | 30 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION | GRADO_CODIGO DESCRIPCION RMU TROL_CODIGO PONDERACION_MAX PONDERACION_MIN | |
| `THU_TAB_NIVELES_REFERENCIAS` | 34 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION | CODIGO NIVEL DESCRIPCION PONDERACION TREF_CODIGO TTESC_CODIGO | |
| `THU_TAB_NIVEL_ROL` | 4 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION | CODIGO DESCRIPCION | |
| `THU_TAB_REFERENCIAS` | 2 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION | CODIGO DESCRIPCION | |
| `THU_TAB_ROLES` | 9 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION | CODIGO TNROL_CODIGO DESCRIPCION | |
| `THU_TAB_ROL_CARGOS` | 15 | 🟠 dominio: talento humano<br>🟡 texto libre: NOMBRE_ROL | NOMBRE_ROL CODIGO_CARGO | |
| `THU_TAB_TIPO_COMPETENCIA` | 2 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION | CODIGO DESCRIPCION | |
| `THU_TAB_TIPO_ESCALA` | 4 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION | CODIGO DESCRIPCION | |
| `THU_TAB_TIPO_FACTOR_VALORATIVO` | 2 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION | CODIGO DESCRIPCION | |
| `THU_TAB_TIPO_FUNCION` | 5 | 🟠 dominio: talento humano<br>🟡 texto libre: DESCRIPCION | CODIGO PRIORIDAD DESCRIPCION | |
| `THU_TAB_VALORACION_CARGO_CAB` | 1 | 🟠 dominio: talento humano | NRO_FORMULARIO TCAR_CODIGO FECHA | |
| `THU_TAB_VALORACION_CARGO_DET` | 8 | 🟠 dominio: talento humano | NRO_FORMULARIO TFVAL_CODIGO TNREF_CODIGO PONDERACION | |

---

## 3. Grupo A — solo señal 🟡

#### ACA (12)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `ACA_TAB_BIBLIOG_RECOMENDADAS` | 8564 | ⚪ muchas filas para catálogo (~8564) | BIBLIOGRAFIA_RECOMENDADA MATERIA_CODIGO INST_CODIGO MODA_ESTUD_CODIGO SIST_ESTUD_CODIGO TCICLOACAD_CODIGO TFINANCIA_CODIGO DEPEN_CODIGO CICLO_ACAD_CODIGO NIVEL_CODIGO | |
| `ACA_TAB_CARRERAS_EXTERNAS` | 5513 | ⚪ muchas filas para catálogo (~5513)<br>🟡 texto libre: NOMBRE | CODIGO LOCALIDAD_CODIGO MODA_ESTUD_CODIGO NIVEL_FORM_CODIGO UNIV_CODIGO NOMBRE | |
| `ACA_TAB_CICLOS_ACADEMICOS` | 569 | 🟡 columna de persona ya oculta<br>🟡 texto libre: DESCRIPCION | CODIGO PER_ACAD_CODIGO DESCRIPCION FECHA_INICIO FECHA_FIN ESTADO ORDEN TCICLOACAD_CODIGO ANIO PORCENTAJE_PRIMERA_MATRICULA PORCENTAJE_SEGUNDA_MATRICULA PORCENTAJE_TERCERA_MATRICULA PORCENTAJE_GASTOS_ADM PORCENTAJE_SEGUNDA_PRORROGA | |
| `ACA_TAB_HORARIOS_DEPENDENCIAS` | 9723 | ⚪ muchas filas para catálogo (~9723) | DIA_SEMANA_CODIGO GRUPO_HORA_CODIGO PLAN_HORAS_NUMERO CODIGO DEPEN_CODIGO INST_CODIGO MODA_ESTUD_CODIGO SIST_ESTUD_CODIGO TCICLOACAD_CODIGO TFINANCIA_CODIGO CICLO_ACAD_CODIGO ESTADO | |
| `ACA_TAB_HORARIO_CAI` | 1728 | 🟡 columna de persona ya oculta<br>🟡 texto libre: DESCRIPCION | CODIGO DEPEN_CODIGO INST_CODIGO MATERIA_CODIGO NIVEL_CODIGO DESCRIPCION CAPACIDAD CUPO HORA_INICIO HORA_FIN PARALELO_CODIGO DIA_SEMANA CICLO_ACAD_CODIGO CARRERA MODA_ESTUD_CODIGO | |
| `ACA_TAB_MALLAS_ACADEMICAS` | 5961 | ⚪ muchas filas para catálogo (~5961) | INST_CODIGO MODA_ESTUD_CODIGO SIST_ESTUD_CODIGO TCICLOACAD_CODIGO TFINANCIA_CODIGO CICLO_ACAD_CODIGO DEPEN_CODIGO MATERIA_CODIGO NIVEL_CODIGO FECHA_INGRESO ESTUDIANTES_APROXIMADOS NUMERO_PARALELOS ESTUDIANTES_PARALELO ESTADO CREDITOS HORAS_SEMANALES HORAS_LABORATORIO MINIMO_CREDITOS PENSUM_CODIGO | |
| `ACA_TAB_MATERIAS_PENSUMS` | 11240 | ⚪ muchas filas para catálogo (~11240) | INST_CODIGO MODA_ESTUD_CODIGO SIST_ESTUD_CODIGO TCICLOACAD_CODIGO TFINANCIA_CODIGO CICLO_ACAD_CODIGO DEPEN_CODIGO MATERIA_CODIGO NIVEL_CODIGO FECHA_INGRESO ESTUDIANTES_APROXIMADOS NUMERO_PARALELOS ESTUDIANTES_PARALELO ESTADO CREDITOS HORAS_SEMANALES HORAS_LABORATORIO MINIMO_CREDITOS PENSUM_CODIGO HORAS_TEORIA HORAS_AUTONOMAS APERTURA RESOLUCION OBLIGATORIA ORGANIZACION_CURRICULAR FORMACION_CURRICULAR INTRODUCCION CONTRIBUCION COORDENADA_X COORDENADA_Y HORAS_X_SEMANA | |
| `ACA_TAB_MAT_COMPROMISO` | 11830 | ⚪ muchas filas para catálogo (~11830) | MATERIA_CODIGO INST_CODIGO MODA_ESTUD_CODIGO SIST_ESTUD_CODIGO TCICLOACAD_CODIGO TFINANCIA_CODIGO DEPEN_CODIGO CICLO_ACAD_CODIGO NIVEL_CODIGO COMPROMISO ESTADO | |
| `ACA_TAB_PARALELOS_MATERIAS` | 12371 | ⚪ muchas filas para catálogo (~12371) | INST_CODIGO MODA_ESTUD_CODIGO SIST_ESTUD_CODIGO TCICLOACAD_CODIGO TFINANCIA_CODIGO DEPEN_CODIGO CICLO_ACAD_CODIGO MATERIA_CODIGO NIVEL_CODIGO PARALELO_CODIGO ESTADO PENSUM_CODIGO | |
| `ACA_TAB_PORCENTAJES_EVAL` | 7605 | ⚪ muchas filas para catálogo (~7605) | TIPO_EVAL_CODIGO PORCENTAJE_N1 PORCENTAJE_N2 PORCENTAJE_N3 PORCENTAJE_N4 PORCENTAJE_N5 MATERIA_CODIGO INST_CODIGO MODA_ESTUD_CODIGO SIST_ESTUD_CODIGO TCICLOACAD_CODIGO TFINANCIA_CODIGO DEPEN_CODIGO CICLO_ACAD_CODIGO NIVEL_CODIGO RESULTADO_APREND_MAT | |
| `ACA_TAB_RELACION_CARRERA_MAT` | 15309 | ⚪ muchas filas para catálogo (~15309) | CODIGO_RESULTADO_CARRERA INST_CODIGO MODA_ESTUD_CODIGO SIST_ESTUD_CODIGO TCICLOACAD_CODIGO TFINANCIA_CODIGO DEPEN_CODIGO CICLO_ACAD_CODIGO PENSUM_CODIGO MATERIA_CODIGO NIVEL_CODIGO CONTRIBUCION EVIDENCIA_APRENDIZAJE ESTADO | |
| `ACA_TAB_RESULT_APRENDI_CAR_MAT` | 16302 | ⚪ muchas filas para catálogo (~16302) | RA_CAR_CODIGO RA_MAT_CODIGO MATERIA_CODIGO INST_CODIGO MODA_ESTUD_CODIGO SIST_ESTUD_CODIGO TCICLOACAD_CODIGO TFINANCIA_CODIGO DEPEN_CODIGO CICLO_ACAD_CODIGO NIVEL_CODIGO ESTADO | |

#### ACT (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `ACT_TAB_ACTIVOS_SUBIDOS` | 17344 | ⚪ muchas filas para catálogo (~17344) | CODIGO_ACTIVO | |
| `ACT_TAB_ACTIVOS_VALIDADOS` | 17164 | ⚪ muchas filas para catálogo (~17164) | CODIGO_ACTIVO | |

#### BIB (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `BIB_TAB_DESCRIPTORES_MATERIA` | 10109 | ⚪ muchas filas para catálogo (~10109) | COD_MATERIA COD_NIVEL COD_DESCRIPTORES | |
| `BIB_TAB_EDITORIALES_BIBLIOGRAF` | 5458 | ⚪ muchas filas para catálogo (~5458)<br>🟡 texto libre: NOMBRE | CODIGO NOMBRE CIUDAD_CODIGO | |

#### CEI (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `CEI_TAB_EVENTOS` | 148 | 🟡 columna de persona ya oculta<br>🟡 texto libre: LUGAR, NOMBRE_EVENTO | CODIGO ENCABEZADO_CODIGO NUMERO_INFORME DEPEN_CODIGO MODA_ESTUD_CODIGO TIPO ALCANCE LUGAR FECHA_INICIO FECHA_FIN NUMERO_HORAS NUM_PONENTES_UTN NUM_PONENTES_NACIONALES NUM_PONENTES_INTERNACIONALE NUM_PARTICIP_UTN_PROFESORES NUM_PARTICIP_UTN_ESTUDIANTES NUM_PARTICIPANTES_EXTERNOS INSTITUCIONES_PARTICIPANTES CANALES_DIFUSION PRODUCTO OBJETIVO_GENERAL OBJETIVO_ESPECIFICO1 OBJETIVO_ESPECIFICO2 OBJETIVO_ESPECIFICO3 NOMBRE_EVENTO FECHA_ULTIMA_MOD OTRO_TIPO OTRO_CANAL OTRO_PRODUCTO AGENDA_MIMETYPE **CONCLUSION1** **CONCLUSION2** **CONCLUSION3** **RECOMENDACION1** **RECOMENDACION2** **RECOMENDACION3** | |

#### EVA (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `EVA_TAB_CAPACITACION_DOC` | 1 | 🟡 columna de persona ya oculta<br>🟡 texto libre: DESCRIPCION | COD_CAPACITACION DESCRIPCION ESTADO | |
| `EVA_TAB_PREG_ALTERNATIVA` | 6943 | ⚪ muchas filas para catálogo (~6943)<br>🟡 texto libre: VALOR | CODIGO_PREGUNTA CODIGO_ALTERNATIVA PREG_CODIGO_EVALUA **VALOR** ESTADO | |

#### INV (4)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `INV_ARTICULOS` | 6 | 🟡 columna de persona ya oculta<br>🟡 texto libre: NOMBRE | ID UNIDAD NOMBRE TIPO ESTADO PORCENTAJE_IVA | |
| `INV_TAB_CODIGOS_BARRAS_ITEMS` | 9598 | ⚪ muchas filas para catálogo (~9598) | ESTADO ITEM_CODIGO FECHA | |
| `INV_TAB_DETALLES_TRANSACC1` | 6767 | ⚪ muchas filas para catálogo (~6767)<br>🟡 texto libre: ITEM_DETALLE | NUMERO_LINEA CANTIDAD COSTO ESTADO FACTURADO TRANSACCIO_NUMERO_TRANSACCION ITEM_UMED_UNIDAD_MED_CODIGO ITEM_UMED_ITEM_CODIGO DTORD_CMP_ORD_COMPRA_NUMERO DTORD_CMP_NRO_LINEA DTORD_CMP_ITEMS_PART_ITEM_COD DTORD_CMP_PART_PART_PRESU_COD CARACTERISTICA ITEM_DETALLE CUENTA_CON_CODIGO | |
| `INV_TAB_UNIDADES_MEDIDA` | 170 | 🟡 columna de persona ya oculta<br>🟡 texto libre: NOMBRE, DESCRIPCION | CODIGO NOMBRE ABREVIATURA DESCRIPCION ESTADO TUNIDADMED_CODIGO PORTAL FECHA_CREACION FECHA_ACTUALIZACION | |

#### LMS (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `LMS_TAB_PERFIL_DEPENDENCIA` | 784 | 🟡 columna de persona ya oculta | ID_PERFIL INST_CODIGO DEPEN_CODIGO ESTADO FECHA TIPO_CODIGO | |

#### MEI (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `MEI_TAB_EVIDENCIAS` | 281 | 🟡 columna de persona ya oculta<br>🟡 texto libre: DESCRIPCION | CODIGO DESCRIPCION NUM INFORMACION_SIIES CONTROL_CAMBIOS PROPORCIONAN_INSUMOS | |
| `MEI_TAB_EVIDENCIA_INS` | 185 | 🟡 columna de persona ya oculta<br>🟡 texto libre: DESCRIPCION_DOCUMENTO | CODIGO CODIGO_EVIDENCIA CICLO_ACADEMICO DEPENDENCIA MIMETYPE LAST_UPDATE LINK DESCRIPCION_DOCUMENTO CALIFICACION **VALORACION** INDICADOR_CODIGO | |

#### MGI (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `MGI_TAB_CONTENIDO_EVENTO` | 0 | 🟡 columna de persona ya oculta<br>🟡 texto libre: DESCRIPCION | ESTADO CODIGO NUMERO DESCRIPCION DURACION FECHA EVENTO_CODIGO FACILITADOR_CODIGO | |
| `MGI_TAB_CONVOCATORIA` | 30 | 🟡 columna de persona ya oculta<br>🟡 texto libre: DESCRIPCION, LUGAR | ESTADO CODIGO TEMA DESCRIPCION FECHA_INICIAL FECHA_FINAL LUGAR VIGENCIA_CODIGO FORMATO_CODIGO TIPO_CONV_CODIGO TIPO_FORM_CODIGO PER_ACAD_CODIGO | |

#### ORI (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `ORI_CONVENIO_COMPROMISOS` | 10539 | ⚪ muchas filas para catálogo (~10539)<br>🟡 texto libre: DESCRIPCION | CODIGO_CONVENIO CODIGO_COMPROMISO ESTADO DESCRIPCION | |

#### PEI (3)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `PEI_TAB_PACALIDAD_EVIDENCIAS` | 1916 | 🟡 columna de persona ya oculta<br>🟡 texto libre: DESCRIPCION | ID_EVIDENCIA ID_SEGUIMIENTO DESCRIPCION EVIDENCIA_MIMETYPE EVIDENCIA_FECHA ESTADO VALIDADO FECHA_REVISION TIPO_FTE_VERIFICACION | |
| `PEI_TAB_PACALIDAD_TAREAS` | 746 | 🟡 columna de persona ya oculta<br>🟡 texto libre: DESCRIPCION | CODIGO COD_ACTIVIDAD DESCRIPCION ESTADO PERIODICIDAD_EJEC | |
| `PEI_TAB_TRANSFERENCIA_SIGESPRE` | 18972 | ⚪ muchas filas para catálogo (~18972)<br>🟡 texto libre: DESCRIPCION_ITEM | PLANEAMIENTO_CODIGO PRESUPUESTO_CODIGO DETALLEPRES_CODIGO ITEM_CODIGO DESCRIPCION_ITEM PARTIDA_PRES_CODIGO CANTIDAD_APROBADA PRECIO_REFERENCIAL PRE_ANIO MES_INICIAL TEMAESTRATEGICO_CODIGO TEMAESTRATEGICO TFINAN_CODIGO POAPROY_CODIGO ACTIVIDAD_CODIGO CENTRO_COS_CODIGO PRIORIDAD PAC FECHA ESTADO | |

#### PRE (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `PRE_TAB_TEM_ITEMS_PROYECT` | 5131 | ⚪ muchas filas para catálogo (~5131) | CODIGO COD_CENTRO_COSTO COD_PROY_POA COD_ACTIV_PRO COD_PEGRESO COD_DPLAN_CMP COD_PART_PRESU COD_ITEM NOM_ITEM DESCRIP_ITEM CANTIDAD PRECIO DISPONIBLE PARTIDA PLAN_CMP PAC NOM_PROYECTO NOM_ACTIVIDAD PROY_INSCODIGO SOLICITUD_CODIGO NUMERO_LINEA | |

#### REF (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `REF_TAB_RESERVACIONES` | 12 | 🟡 columna de persona ya oculta<br>🟡 texto libre: DESCRIPCION | CODIGO EVENTO UBICACION FECHA_RESERVACION FECHA_INICIO FECHA_FIN DESCRIPCION APROBADO | |

#### SEG (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|

#### SGE (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `SGE_TAB_PREGUNTAS` | 287 | 🟡 columna de persona ya oculta<br>🟡 texto libre: NOMBRE, DESCRIPCION | ESTADO CODIGO NOMBRE PESO DESCRIPCION SGE_PRE_CODIGO SGE_TIPREG_CODIGO SGE_INDENC_SGE_IND_CODIGO SGE_INDENC_SGE_ENC_CODIGO SECUENCIA1 SECUENCIA2 SECUENCIA3 SECUENCIA4 NUMERACION INSTRUCCION_PREGUNTA | |

#### SRI (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `SRI_DETALLES_AUTO` | 1 | 🟡 columna de persona ya oculta | ID CODIGO_DOCUMENTO ESTABLECIMIENTO PUNTO_EMISION SECUENCIAL_INICIAL SECUENCIAL_ACTUAL SECUENCIAL_FINAL FECHA_INICIAL_VALIDEZ FECHA_FINAL_VALIDEZ AUTORIZACION ESTADO | |

#### UEP (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `UEP_TAB_TALLER` | 73 | 🟡 columna de persona ya oculta<br>🟡 texto libre: NOMBRE_TALLER, VALOR | ID_TALLER NOMBRE_TALLER **VALOR** ID_EVENTO CUPO | |

---

## 4. Grupo B — bloqueadas por el nombre 🔴

#### ACA (4)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `ACA_TAB_CARPETA_ESTUDIANTE` | 14 | 🔴 nombre indica personas (ESTUDIANTE) |  | |
| `ACA_TAB_NOTAS_CUALITATIVAS` | 10 | 🔴 nombre indica personas (NOTAS) |  | |
| `ACA_TAB_REGLAS_NOTAS` | 235 | 🔴 nombre indica personas (NOTAS) |  | |
| `ACA_TAB_USUARIOS_ESQUEMAS` | 88896 | 🔴 nombre indica personas (USUARIOS)<br>⚪ grande ~88896 filas |  | |

#### ACT (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `ACT_TAB_DEPRECIACIONES_RESP` | 10168 | 🔴 nombre indica personas (RESP) |  | |

#### AUD (28)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `AUD_ACA_TAB_CONTENI` | 970880 | 🔴 nombre indica personas (AUD)<br>⚪ grande ~970880 filas |  | |
| `AUD_ACA_TAB_MATERIA` | 65464 | 🔴 nombre indica personas (AUD)<br>⚪ grande ~65464 filas |  | |
| `AUD_ACA_TAB_MATERIAS_EQUIVA` | 4799 | 🔴 nombre indica personas (AUD) |  | |
| `AUD_ACT_TAB_DET_TRANSACCION` | 52336 | 🔴 nombre indica personas (AUD)<br>⚪ grande ~52336 filas |  | |
| `AUD_BME_TAB_CONSULTAS_MEDICAS` | 92784 | 🔴 nombre indica personas (AUD)<br>⚪ grande ~92784 filas |  | |
| `AUD_EVA_TAB_PREGUNTAS` | 2938 | 🔴 nombre indica personas (AUD) |  | |
| `AUD_EVA_TAB_PREG_ALTERNATIVA` | 3324 | 🔴 nombre indica personas (AUD) |  | |
| `AUD_INS_TAB_CALENDA` | 162 | 🔴 nombre indica personas (AUD) |  | |
| `AUD_INV_TAB_DET_TRANSACCIONES` | 27854 | 🔴 nombre indica personas (AUD)<br>⚪ grande ~27854 filas |  | |
| `AUD_NOM_TAB_PARAM_R` |  | 🔴 nombre indica personas (AUD)<br>⚪ sin estadísticas |  | |
| `AUD_NOM_TAB_TABLA_I` | 27 | 🔴 nombre indica personas (AUD) |  | |
| `AUD_PEI_TAB_ACTIVID` |  | 🔴 nombre indica personas (AUD)<br>⚪ sin estadísticas |  | |
| `AUD_PEI_TAB_ACTIVIDES_ITEMS` |  | 🔴 nombre indica personas (AUD)<br>⚪ sin estadísticas |  | |
| `AUD_PEI_TAB_AVANCE_` | 27956 | 🔴 nombre indica personas (AUD)<br>⚪ grande ~27956 filas |  | |
| `AUD_PEI_TAB_AVANCE_EVID` | 8993 | 🔴 nombre indica personas (AUD) |  | |
| `AUD_PEI_TAB_TRANSFE` |  | 🔴 nombre indica personas (AUD)<br>⚪ sin estadísticas |  | |
| `AUD_PRE_TAB_EJECUC_` |  | 🔴 nombre indica personas (AUD)<br>⚪ sin estadísticas |  | |
| `AUD_RHU_TAB_TITULOS` | 7599 | 🔴 nombre indica personas (AUD) |  | |
| `AUD_SEG_TAB_MENUS` |  | 🔴 nombre indica personas (AUD)<br>⚪ sin estadísticas |  | |
| `AUD_SEG_TAB_USUARIO` |  | 🔴 nombre indica personas (USUARIO)<br>🔴 nombre indica personas (AUD)<br>⚪ sin estadísticas |  | |
| `AUD_SOC_TAB_ARTICULOS` | 3592 | 🔴 nombre indica personas (AUD) |  | |
| `AUD_SOC_TAB_KARDEX` | 3605 | 🔴 nombre indica personas (AUD) |  | |
| `AUD_TAB_CALENDARIOS_MAT_PENSUM` | 370 | 🔴 nombre indica personas (AUD) |  | |
| `AUD_TAB_MATERIAS_PREREQUISITOS` | 3109 | 🔴 nombre indica personas (AUD) |  | |
| `AUD_TAB_USUARIOS_ESQUEMAS` |  | 🔴 nombre indica personas (USUARIOS)<br>🔴 nombre indica personas (AUD)<br>⚪ sin estadísticas |  | |
| `AUD_TAB_USUARIOS_ROLES` |  | 🔴 nombre indica personas (USUARIOS)<br>🔴 nombre indica personas (AUD)<br>⚪ sin estadísticas |  | |
| `AUD_VIN_TAB_EXTENSION` | 5432 | 🔴 nombre indica personas (AUD) |  | |
| `AUD_VIN_TAB_NOTAS` | 72904 | 🔴 nombre indica personas (AUD)<br>⚪ grande ~72904 filas |  | |

#### BIB (4)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `BIB_TAB_CENTROS_PARTICIPANTES` | 1 | 🔴 nombre indica personas (PARTICIPANTES) |  | |
| `BIB_TAB_MULTAS` | 1 | 🔴 nombre indica personas (MULTAS) |  | |
| `BIB_TAB_PARAMETROS_PRESTAMOS` | 1 | 🔴 nombre indica personas (PRESTAMOS) |  | |
| `BIB_TAB_SUSCRIPCIONES_BIBLIOGR` | 4 | 🔴 nombre indica personas (SUSCRIPCIONES) |  | |

#### BLC (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `BLC_TAB_EXAMEN_PARAMETRO` | 153 | 🔴 nombre indica personas (EXAMEN) |  | |
| `BLC_TAB_ORGANIZAR_EXAMEN` | 47 | 🔴 nombre indica personas (EXAMEN) |  | |

#### BME (4)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `BME_TAB_BENEFICIARIOS_IESS` | 9 | 🔴 nombre indica personas (BENEFICIARIOS) |  | |
| `BME_TAB_CERTIFICADOS` | 9 | 🔴 nombre indica personas (CERTIFICADOS) |  | |
| `BME_TAB_PARTES_CONSULTAS` | 0 | 🔴 nombre indica personas (CONSULTAS) |  | |
| `BME_TAB_SUCESIONES_CONSULTAS` | 2 | 🔴 nombre indica personas (CONSULTAS) |  | |

#### BOD (5)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `BOD_TAB_CERTIFICADO_PACIENTE` |  | 🔴 nombre indica personas (CERTIFICADO)<br>⚪ sin estadísticas |  | |
| `BOD_TAB_EXAMEN_BUCAL` | 14 | 🔴 nombre indica personas (EXAMEN) |  | |
| `BOD_TAB_HORARIO_CITA` | 0 | 🔴 nombre indica personas (CITA) |  | |
| `BOD_TAB_TIPO_CERTIFICADO` |  | 🔴 nombre indica personas (CERTIFICADO)<br>⚪ sin estadísticas |  | |
| `BOD_TAB_TIPO_CONSULTA` |  | 🔴 nombre indica personas (CONSULTA)<br>⚪ sin estadísticas |  | |

#### BSA (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `BSA_TAB_CERTIFICADO` | 0 | 🔴 nombre indica personas (CERTIFICADO) |  | |
| `BSA_TAB_CERTIFICADO_PACIENTE` | 0 | 🔴 nombre indica personas (CERTIFICADO) |  | |

#### CLB (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `CLB_TAB_ARCHIVOS` | 46 | 🔴 nombre indica personas (ARCHIVOS) |  | |

#### DBU (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `DBU_TAB_RESPUESTAS_AFECTIVAS` | 5 | 🔴 nombre indica personas (RESPUESTAS) |  | |
| `DBU_TAB_SNNA_ASPEC_RESP` | 3 | 🔴 nombre indica personas (RESP) |  | |

#### ENC (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `ENC_TAB_PRUEBAS_USUARIO` | 28 | 🔴 nombre indica personas (USUARIO) |  | |
| `ENC_TAB_RESPUESTAS` | 6 | 🔴 nombre indica personas (RESPUESTAS) |  | |

#### EVA (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `EVA_TAB_EVALUACION` | 308 | 🔴 nombre indica personas (EVALUACION) |  | |

#### EVAL (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `EVAL_TAB_EVALUACIONES_INSTITUC` | 3 | 🔴 nombre indica personas (EVALUACIONES) |  | |

#### LMS (7)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `LMS_RESP_ACTIVIDAD_ACADEMICA` | 588012 | 🔴 nombre indica personas (RESP)<br>⚪ grande ~588012 filas |  | |
| `LMS_RESP_RECURSOS` | 468583 | 🔴 nombre indica personas (RESP)<br>⚪ grande ~468583 filas |  | |
| `LMS_TAB_ADJUNTO_PREGUNTAS` | 1 | 🔴 nombre indica personas (ADJUNTO) |  | |
| `LMS_TAB_GEOLOCALIZACION` | 6697984 | 🔴 nombre indica personas (GEOLOCALIZACION)<br>⚪ grande ~6697984 filas |  | |
| `LMS_TAB_METODO_CALIFICACION` | 2 | 🔴 nombre indica personas (CALIFICACION) |  | |
| `LMS_TAB_RESPUESTAS` | 2569852 | 🔴 nombre indica personas (RESPUESTAS)<br>⚪ grande ~2569852 filas |  | |
| `LMS_TAB_USUARIOS_BLOQ_APP` | 12 | 🔴 nombre indica personas (USUARIOS) |  | |

#### MCO (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `MCO_TAB_USUARIO` | 2 | 🔴 nombre indica personas (USUARIO) |  | |

#### MGI (7)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `MGI_TAB_CONV_AREA_INV` | 29 | 🔴 nombre indica personas (CONV) |  | |
| `MGI_TAB_CONV_POL_INV` | 30 | 🔴 nombre indica personas (CONV) |  | |
| `MGI_TAB_PARAMETROS_EVALUACION` | 17 | 🔴 nombre indica personas (EVALUACION) |  | |
| `MGI_TAB_PI_SOLICITUDES` | 2 | 🔴 nombre indica personas (SOLICITUDES) |  | |
| `MGI_TAB_PORCENTAJE_EVALUACION` | 4 | 🔴 nombre indica personas (EVALUACION) |  | |
| `MGI_TAB_PROCEDIMIENTO_CONV` | 1 | 🔴 nombre indica personas (CONV) |  | |
| `MGI_TAB_USUARIOS` | 6 | 🔴 nombre indica personas (USUARIOS) |  | |

#### MVL (6)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `MVL_MCO_TAB_USUARIO` | 13 | 🔴 nombre indica personas (USUARIO) |  | |
| `MVL_TAB_ARCHIVOS` | 359 | 🔴 nombre indica personas (ARCHIVOS) |  | |
| `MVL_TAB_CONV_GRUPALES` | 33 | 🔴 nombre indica personas (CONV) |  | |
| `MVL_TAB_SILENCIO_CONVERSACION` | 0 | 🔴 nombre indica personas (CONVERSACION) |  | |
| `MVL_TAB_TOPICS_FCM` | 23460 | 🔴 nombre indica personas (FCM)<br>⚪ grande ~23460 filas |  | |
| `MVL_TAB_USUARIO_TOKENS_BK_PREPKCE` | 0 | 🔴 nombre indica personas (USUARIO)<br>🔴 nombre indica personas (TOKENS) |  | |

#### ORI (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `ORI_TAB_BENEFICIARIOS_CONVENIO` | 1140 | 🔴 nombre indica personas (BENEFICIARIOS) |  | |

#### PRE (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `PRE_TAB_PLANIFICACION_NOMINA` | 284 | 🔴 nombre indica personas (NOMINA) |  | |

#### REC (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `REC_TAB_FORMAS_PAGO` | 5 | 🔴 nombre indica personas (PAGO) |  | |
| `REC_TAB_OPCIONES_PAGO_POSG` | 13 | 🔴 nombre indica personas (PAGO) |  | |

#### RED (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `RED_TAB_SUELDOS` | 9 | 🔴 nombre indica personas (SUELDOS) |  | |

#### RHC (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `RHC_TAB_SESION` | 79 | 🔴 nombre indica personas (SESION) |  | |
| `RHC_TAB_USUARIOS_CONSEJOS` | 29 | 🔴 nombre indica personas (USUARIOS) |  | |

#### RHU (5)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `RHU_AUD_OBRA_ACTUALIZACIONES` |  | 🔴 nombre indica personas (AUD)<br>⚪ sin estadísticas |  | |
| `RHU_TAB_ASISTENCIAS` | 172 | 🔴 nombre indica personas (ASISTENCIAS) |  | |
| `RHU_TAB_CARPETA_EMPLEADO` | 22 | 🔴 nombre indica personas (EMPLEADO) |  | |
| `RHU_TAB_NRO_DOCENTES_CARRERA` | 6 | 🔴 nombre indica personas (DOCENTES) |  | |
| `RHU_TAB_VALORES_VIATICOS` | 6 | 🔴 nombre indica personas (VIATICOS) |  | |

#### RJU (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `RJU_TAB_FORMAS_PAGO` |  | 🔴 nombre indica personas (PAGO)<br>⚪ sin estadísticas |  | |

#### SEG (3)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `SEG_TAB_TABLAS_MOD_USUARIO` | 0 | 🔴 nombre indica personas (USUARIO) |  | |
| `SEG_TAB_USUARIOS_MODULOS` | 90064 | 🔴 nombre indica personas (USUARIOS)<br>⚪ grande ~90064 filas |  | |
| `SEG_TAB_USUARIOS_ROLES` | 96112 | 🔴 nombre indica personas (USUARIOS)<br>⚪ grande ~96112 filas |  | |

#### SNI (7)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `SNI_TAB_DOCENTES_2015` | 903 | 🔴 nombre indica personas (DOCENTES) |  | |
| `SNI_TAB_DOCENTES_2016` | 687 | 🔴 nombre indica personas (DOCENTES) |  | |
| `SNI_TAB_DOCENTES_FACTURA` | 421 | 🔴 nombre indica personas (DOCENTES)<br>🔴 nombre indica personas (FACTURA) |  | |
| `SNI_TAB_DOCENTES_FACTURA1` | 421 | 🔴 nombre indica personas (DOCENTES) |  | |
| `SNI_TAB_DOCENTES_FALTAN_2016` | 218 | 🔴 nombre indica personas (DOCENTES) |  | |
| `SNI_TAB_DOCENTES_NOMINA` | 903 | 🔴 nombre indica personas (DOCENTES)<br>🔴 nombre indica personas (NOMINA) |  | |
| `SNI_TAB_DOCENTES_NOMINA1` | 623 | 🔴 nombre indica personas (DOCENTES) |  | |

#### SNIESE (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `SNIESE_ESCALAFON_DOCENTE` | 6 | 🔴 nombre indica personas (DOCENTE) |  | |
| `SNIESE_FINANCIAM_BECA_ID` | 5 | 🔴 nombre indica personas (BECA) |  | |

#### SOC (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `SOC_TAB_KARDEX` | 43642 | 🔴 nombre indica personas (KARDEX)<br>⚪ grande ~43642 filas |  | |
| `SOC_TAB_RESPUESTAS` | 82 | 🔴 nombre indica personas (RESPUESTAS) |  | |

#### SST (3)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `SST_TAB_AUD_IESS_EVA` | 5 | 🔴 nombre indica personas (AUD) |  | |
| `SST_TAB_AUD_RIE_IESS` | 201 | 🔴 nombre indica personas (AUD) |  | |
| `SST_TAB_EVA_AUD_IESS` | 3 | 🔴 nombre indica personas (AUD) |  | |

#### VIN (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `VIN_TAB_NOTAS` | 24410 | 🔴 nombre indica personas (NOTAS)<br>⚪ grande ~24410 filas |  | |

---

## 5. Grupo B — bloqueadas por tamaño ⚪

#### ACA (15)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `ACA_TAB_AMBIENTE_CONTENIDOS` | 139024 | ⚪ grande ~139024 filas |  | |
| `ACA_TAB_CICLO_INCRIP_MAESTRIA` |  | ⚪ sin estadísticas |  | |
| `ACA_TAB_CONTENIDOS_MATERIAS` | 236112 | ⚪ grande ~236112 filas |  | |
| `ACA_TAB_COSTO_OPTIMO_GRUPOS_2025_MARZO` |  | ⚪ sin estadísticas |  | |
| `ACA_TAB_FECHAS_COMPLET_CICL` |  | ⚪ sin estadísticas |  | |
| `ACA_TAB_HORARIOS` | 29531 | ⚪ grande ~29531 filas |  | |
| `ACA_TAB_INDICADOR_DESERCION` |  | ⚪ sin estadísticas |  | |
| `ACA_TAB_MATERIAS` | 26212 | ⚪ grande ~26212 filas |  | |
| `ACA_TAB_METODO_CONTENIDOS` | 138928 | ⚪ grande ~138928 filas |  | |
| `ACA_TAB_MOTIVOS_RETIROS` |  | ⚪ sin estadísticas |  | |
| `ACA_TAB_OBJETIVOS_MATERIAS` | 63412 | ⚪ grande ~63412 filas |  | |
| `ACA_TAB_RECURSO_DID_CONTENIDOS` | 138512 | ⚪ grande ~138512 filas |  | |
| `ACA_TAB_RESULT_APRENDIZAJE_MAT` | 74496 | ⚪ grande ~74496 filas |  | |
| `ACA_TAB_RESULT_MAT_CONTENIDOS` | 62532 | ⚪ grande ~62532 filas |  | |
| `ACA_TAB_TICS_CONTENIDOS` | 133968 | ⚪ grande ~133968 filas |  | |

#### BDE (9)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `BDE_TAB_CATEGORIA_PROFESIONAL` |  | ⚪ sin estadísticas |  | |
| `BDE_TAB_CATEGORIA_PROFESIONAL_ADICIONALES` |  | ⚪ sin estadísticas |  | |
| `BDE_TAB_CATEGORIA_SOFT_SKILLS` |  | ⚪ sin estadísticas |  | |
| `BDE_TAB_CLASIFICACION_IDIOMAS` |  | ⚪ sin estadísticas |  | |
| `BDE_TAB_IDIOMAS_COMPLETOS` |  | ⚪ sin estadísticas |  | |
| `BDE_TAB_IDIOMAS_DISPONIBLES` |  | ⚪ sin estadísticas |  | |
| `BDE_TAB_SOFT_SKILLS` |  | ⚪ sin estadísticas |  | |
| `BDE_TAB_VALORACIONES_CSAT` |  | ⚪ sin estadísticas |  | |
| `BDE_TAB_VALORACIONES_NPS` |  | ⚪ sin estadísticas |  | |

#### BIB (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `BIB_TAB_DESCRIPTORES` | 24316 | ⚪ grande ~24316 filas |  | |
| `BIB_TAB_PROPUESTA_EDITORIALES` | 99487 | ⚪ grande ~99487 filas |  | |

#### BME (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `BME_TAB_CENTROS_DE_SALUD` |  | ⚪ sin estadísticas |  | |

#### CACES (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `CACES_TAB_CRITERIO` |  | ⚪ sin estadísticas |  | |
| `CACES_TAB_SUBCRITERIO` |  | ⚪ sin estadísticas |  | |

#### DOC (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `DOC_TAB_RECURSO_DOCE_DOCUMENTO` | 307428 | ⚪ grande ~307428 filas |  | |
| `DOC_TAB_TAREA_DOCE_DOCUMENTO` | 84741 | ⚪ grande ~84741 filas |  | |

#### INV (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `INV_TAB_TEM_ITEMS` | 28778 | ⚪ grande ~28778 filas |  | |

#### LMS (3)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `LMS_TAB_ACTIVIDAD_ACADEMICA` | 589817 | ⚪ grande ~589817 filas |  | |
| `LMS_TAB_PREGUNTAS` | 711797 | ⚪ grande ~711797 filas |  | |
| `LMS_TAB_RECURSOS` | 469836 | ⚪ grande ~469836 filas |  | |

#### MGI (4)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `MGI_TAB_EJES_INTE_GRUPOS` |  | ⚪ sin estadísticas |  | |
| `MGI_TAB_ESTADO_EVAL` |  | ⚪ sin estadísticas |  | |
| `MGI_TAB_PRO_VINCU_INVE` |  | ⚪ sin estadísticas |  | |
| `MGI_TAB_REDES_GR` |  | ⚪ sin estadísticas |  | |

#### MVL (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `MVL_TAB_MARCA_EVENTOS` |  | ⚪ sin estadísticas |  | |
| `MVL_TAB_REUNION_AVISO` |  | ⚪ sin estadísticas |  | |

#### NOT (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `NOT_TAB_TOPICS` |  | ⚪ sin estadísticas |  | |

#### PRE (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `PRE_TAB_ITEMS_PARTIDAS` | 61372 | ⚪ grande ~61372 filas |  | |

#### REC (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `REC_TAB_ENTREGA_STOCK_FACU` |  | ⚪ sin estadísticas |  | |
| `REC_TEM_XML` | 185616 | ⚪ grande ~185616 filas |  | |

#### RHU (2)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `RHU_TAB_CLUBS_VINCULACION` |  | ⚪ sin estadísticas |  | |
| `RHU_TAB_DATOS_RELOJ` |  | ⚪ sin estadísticas |  | |

#### RJU (9)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `RJU_TAB_BIENES_REMATES` |  | ⚪ sin estadísticas |  | |
| `RJU_TAB_CARACTERISTICAS_BIENES` |  | ⚪ sin estadísticas |  | |
| `RJU_TAB_ESTADOS_REMATES` |  | ⚪ sin estadísticas |  | |
| `RJU_TAB_REMATES_JUDICIALES` |  | ⚪ sin estadísticas |  | |
| `RJU_TAB_TIPOS_BIENES` |  | ⚪ sin estadísticas |  | |
| `RJU_TAB_TIPOS_CARACTERISTICAS` |  | ⚪ sin estadísticas |  | |
| `RJU_TAB_TIPOS_IDENTIFICACION` |  | ⚪ sin estadísticas |  | |
| `RJU_TAB_TIPOS_POSTORES` |  | ⚪ sin estadísticas |  | |
| `RJU_TAB_TIPOS_TRANSACCIONES` |  | ⚪ sin estadísticas |  | |

#### SEG (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|

#### UEP (1)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `UEP_TAB_TIPOS_ACTIVIDAD` |  | ⚪ sin estadísticas |  | |

#### WEB (3)

| Tabla | Filas | Por qué salió | Columnas visibles (en **negrita** las que piden ojo) | Decisión |
|---|--:|---|---|---|
| `WEB_FILOSOFIA_INSTITUCIONAL` |  | ⚪ sin estadísticas |  | |
| `WEB_NUESTROS_SIMBOLOS` |  | ⚪ sin estadísticas |  | |
| `WEB_RESENIA_HISTORICA` |  | ⚪ sin estadísticas |  | |
