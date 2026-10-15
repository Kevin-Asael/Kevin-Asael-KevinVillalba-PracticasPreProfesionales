import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/entity/alternativa_entity.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/entity/item_emparejar_entity.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/presentation/helpers/evaluacion_online_form_handler.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/presentation/provider/evaluacion_online_provider.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/presentation/widgets/formulario_evaluacion_online_content_widget.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/presentation/widgets/pregunta_dinamica_online_widget.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/query/responder_pregunta_body.dart';

import 'fakes/builders.dart';
import 'fakes/reloj_monotonico_falso.dart';
import 'fakes/servicio_evaluacion_online_falso.dart';

void main() {
  group('EvaluacionOnlineFormHandler (lógica pura, sin widgets)', () {
    test(
        'RESP-01: Tipo 1 (opción única) — seleccionar una alternativa desmarca las demás',
        () {
      final formulario = formularioFixture(
        fechaInicioISO: DateTime(2026, 1, 1).toIso8601String(),
        fechaFinISO: DateTime(2026, 1, 1, 1).toIso8601String(),
        preguntas: {
          'q1': preguntaOpcionUnicaFixture(
            codigoPregunta: 1,
            alternativas: [
              AlternativaEntity(codigo: 1, texto: 'A', seleccionada: true),
              AlternativaEntity(codigo: 2, texto: 'B', seleccionada: false),
              AlternativaEntity(codigo: 3, texto: 'C', seleccionada: false),
            ],
          ),
        },
      );
      final handler = EvaluacionOnlineFormHandler(formulario);

      handler.actualizarRespuestaLocal(
        codigoPregunta: 1,
        tipoPregunta: 1,
        codigoAlternativa: 2,
      );

      final alternativas = formulario.preguntas['q1']!.alternativas!;
      expect(alternativas.firstWhere((a) => a.codigo == 1).seleccionada, isFalse);
      expect(alternativas.firstWhere((a) => a.codigo == 2).seleccionada, isTrue);
      expect(alternativas.firstWhere((a) => a.codigo == 3).seleccionada, isFalse);
    });

    test(
        'RESP-02: Tipo 2 (opción múltiple) — toggle marca y luego desmarca sin afectar las demás',
        () {
      final formulario = formularioFixture(
        fechaInicioISO: DateTime(2026, 1, 1).toIso8601String(),
        fechaFinISO: DateTime(2026, 1, 1, 1).toIso8601String(),
        preguntas: {
          'q2': preguntaOpcionMultipleFixture(
            codigoPregunta: 2,
            alternativas: [
              AlternativaEntity(codigo: 1, texto: 'A', seleccionada: false),
              AlternativaEntity(codigo: 2, texto: 'B', seleccionada: false),
            ],
          ),
        },
      );
      final handler = EvaluacionOnlineFormHandler(formulario);

      handler.actualizarRespuestaLocal(
        codigoPregunta: 2,
        tipoPregunta: 2,
        codigoAlternativa: 1,
      );
      var alternativas = formulario.preguntas['q2']!.alternativas!;
      expect(alternativas.firstWhere((a) => a.codigo == 1).seleccionada, isTrue);
      expect(alternativas.firstWhere((a) => a.codigo == 2).seleccionada, isFalse);

      handler.actualizarRespuestaLocal(
        codigoPregunta: 2,
        tipoPregunta: 2,
        codigoAlternativa: 1,
      );
      alternativas = formulario.preguntas['q2']!.alternativas!;
      expect(alternativas.firstWhere((a) => a.codigo == 1).seleccionada, isFalse);
      expect(alternativas.firstWhere((a) => a.codigo == 2).seleccionada, isFalse);
    });

    test(
        'RESP-04: Tipo 6 (emparejamiento) — actualiza un ítem sin alterar los demás pares',
        () {
      final formulario = formularioFixture(
        fechaInicioISO: DateTime(2026, 1, 1).toIso8601String(),
        fechaFinISO: DateTime(2026, 1, 1, 1).toIso8601String(),
        preguntas: {
          'q6': preguntaEmparejamientoFixture(
            codigoPregunta: 6,
            items: [
              ItemEmparejarEntity(codigo: 100, texto: 'Item 1'),
              ItemEmparejarEntity(
                  codigo: 101, texto: 'Item 2', respuestaSeleccionada: 9),
              ItemEmparejarEntity(codigo: 102, texto: 'Item 3'),
            ],
          ),
        },
      );
      final handler = EvaluacionOnlineFormHandler(formulario);

      handler.actualizarRespuestaLocal(
        codigoPregunta: 6,
        tipoPregunta: 6,
        idItemEmparejar: 101,
        idOpcionEmparejar: 5,
      );

      final items = formulario.preguntas['q6']!.itemsParaEmparejar!;
      expect(items.firstWhere((i) => i.codigo == 100).respuestaSeleccionada,
          isNull);
      expect(
          items.firstWhere((i) => i.codigo == 101).respuestaSeleccionada, 5);
      expect(items.firstWhere((i) => i.codigo == 102).respuestaSeleccionada,
          isNull);
    });
  });

  group('Error de red al responder (widget)', () {
    late ServicioEvaluacionOnlineFalso servicio;
    late EvaluacionOnlineProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      servicio = ServicioEvaluacionOnlineFalso();
      provider = EvaluacionOnlineProvider(
        servicio,
        relojExamen: RelojMonotonicoFalso(),
        relojPared: () => DateTime(2026, 1, 1, 10, 0, 0),
      );
    });

    testWidgets(
        'propaga el fallo de conexión de forma controlada, muestra AppSnackBar y mantiene la pantalla interactiva',
        (tester) async {
      servicio.getFormularioImpl = (_) async => formularioFixture(
            horaServidorISO: DateTime(2026, 1, 1, 10, 0, 0).toIso8601String(),
            fechaInicioISO: DateTime(2026, 1, 1, 9, 0, 0).toIso8601String(),
            fechaFinISO: DateTime(2026, 1, 1, 11, 0, 0).toIso8601String(),
            preguntas: {
              'q1': preguntaOpcionUnicaFixture(
                codigoPregunta: 1,
                alternativas: [
                  AlternativaEntity(
                      codigo: 1, texto: 'A', seleccionada: false),
                  AlternativaEntity(
                      codigo: 2, texto: 'B', seleccionada: false),
                ],
              ),
            },
          );

      late BuildContext contextoInicial;
      await tester.pumpWidget(
        wrapConRouterYTema(
          ChangeNotifierProvider.value(
            value: provider,
            child: Builder(builder: (context) {
              contextoInicial = context;
              return const SizedBox();
            }),
          ),
        ),
      );
      await provider.initEvaluacion(contextoInicial, 1);

      await tester.pumpWidget(
        wrapConRouterYTema(
          ChangeNotifierProvider.value(
            value: provider,
            child: const FormularioEvaluacionOnlineContentWidget(
              idActividadAlumno: 1,
            ),
          ),
        ),
      );
      await tester.pump();

      servicio.responderPreguntaImpl = (_, __) async {
        throw Exception('sin conexión');
      };

      final preguntaWidget = tester.widget<PreguntaDinamicaOnlineWidget>(
        find.byType(PreguntaDinamicaOnlineWidget),
      );
      preguntaWidget.onRespuestaChanged!(
        ResponderPreguntaBody(idPregunta: 1, tipoPregunta: 1, idAlternativa: 2),
      );

      await tester.pump();
      await tester.pump();

      expect(
        find.textContaining('Error al guardar respuesta de la pregunta'),
        findsOneWidget,
      );

      // Pantalla sigue interactiva: sin loader/absorción bloqueando el tap.
      final absorb =
          tester.widget<AbsorbPointer>(find.byType(AbsorbPointer).first);
      expect(absorb.absorbing, isFalse);

      // Sin cola offline: al fallar antes de actualizar el estado local, no
      // queda una respuesta "fantasma" marcada.
      final alternativas = provider.formularioEntity!.preguntas['q1']!.alternativas!;
      expect(
        alternativas.firstWhere((a) => a.codigo == 2).seleccionada,
        isFalse,
      );
      // El binding de test verifica timers pendientes apenas termina el
      // cuerpo del testWidgets, antes de que un tearDown() normal corra.
      provider.dispose();
    });
  });
}
