import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/entity/alternativa_entity.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/entity/anticopia_estado_entity.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/entity/formulario_entity.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/entity/info_evaluacion_entity.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/entity/item_emparejar_entity.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/entity/pregunta_entity.dart';
import 'package:utn_movil_app/config/theme/app_theme.dart';

FormularioEntity formularioFixture({
  String? horaServidorISO,
  required String fechaInicioISO,
  required String fechaFinISO,
  Map<String, PreguntaEntity>? preguntas,
  AntiCopiaEstadoEntity? antiCopia,
  String descripcion = '',
}) {
  return FormularioEntity(
    info: InfoEvaluacionEntity(
      titulo: 'Evaluación de prueba',
      descripcion: descripcion,
      fechaInicioISO: fechaInicioISO,
      fechaFinISO: fechaFinISO,
      horaServidorISO: horaServidorISO,
      antiCopia: antiCopia,
    ),
    preguntas: preguntas ?? {},
  );
}

PreguntaEntity preguntaOpcionUnicaFixture({
  int codigoPregunta = 1,
  required List<AlternativaEntity> alternativas,
}) =>
    PreguntaEntity(
      codigoPregunta: codigoPregunta,
      pregunta: '¿Pregunta de opción única?',
      tipoPregunta: 1,
      alternativas: alternativas,
    );

PreguntaEntity preguntaOpcionMultipleFixture({
  int codigoPregunta = 2,
  required List<AlternativaEntity> alternativas,
}) =>
    PreguntaEntity(
      codigoPregunta: codigoPregunta,
      pregunta: '¿Pregunta de opción múltiple?',
      tipoPregunta: 2,
      alternativas: alternativas,
    );

PreguntaEntity preguntaEmparejamientoFixture({
  int codigoPregunta = 6,
  required List<ItemEmparejarEntity> items,
}) =>
    PreguntaEntity(
      codigoPregunta: codigoPregunta,
      pregunta: '¿Pregunta de emparejamiento?',
      tipoPregunta: 6,
      itemsParaEmparejar: items,
    );

/// `MaterialApp` con tema real (`ThemeExtension<AppColors>`, necesario para
/// `AppSnackBar`) y un `GoRouter` mínimo (necesario porque
/// `finalizarEvaluacion` navega con `context.go(...)` al terminar con éxito).
Widget wrapConRouterYTema(Widget child) {
  return MaterialApp.router(
    theme: AppTheme().getTheme(),
    routerConfig: GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => Scaffold(body: child)),
        GoRoute(
          path: '/estudiante/evaluacion-online/resultado',
          builder: (_, __) => const SizedBox(),
        ),
      ],
    ),
  );
}
