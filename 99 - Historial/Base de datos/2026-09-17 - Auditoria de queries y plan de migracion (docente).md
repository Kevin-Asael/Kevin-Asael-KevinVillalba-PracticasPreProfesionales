# Auditoría de queries y plan de migración (portafolio docente)

**Fecha:** 2026-09-16 (auditoría) / 2026-09-17 (continuidad)
**Repo:** `utn-movil-portafolio-docentes`
**Estado:** Auditoría completa, migración **pendiente de iniciar**

---

## 1. Resumen

Se auditaron **242 consultas/bloques SQL** distribuidas en **21 módulos** del backend de
docentes. Cada una fue clasificada por tipo (V1/V2/F/P/T/YA/M/W) y se elaboró el plan
completo de migración, siguiendo la misma metodología probada con éxito en el piloto de
estudiantes (`foro_online`).

---

## 2. Hallazgo de seguridad (bloquea 7 puntos de la migración)


Detalle completo:

> [!IMPORTANT]
> **Regla para la migración de queries:**
> 

---

## 3. Documentación generada

| Documento | Ubicación |
|---|---|
| Plan maestro (242 queries clasificadas) | `Backup-Planes/2026-09-16 - Plan completo migracion queries a vistas y procedimientos (portafolio-docentes).md` |
| Nota de continuidad | `07 - Documentacion/2026-09-17 - Como trabajamos la migracion de queries (continuidad-docentes).md` |
| Correcciones a la auditoría | `Descubrimientos queries/2026-09-17 - Correcciones a la auditoria inicial de docentes.md` |
| Índice de objetos | `00_Indices/00_Indice_Docentes` |

---

## 4. Diferencias con la migración de estudiante

- **Escala:** 242 queries (docentes) vs ~150 (estudiante)
- **21 módulos** vs ~15 en estudiante
- Misma metodología (Toad + MINUS bidireccional + curl antes/después)
