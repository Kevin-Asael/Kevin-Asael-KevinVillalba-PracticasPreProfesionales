import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/presentation/provider/evaluacion_online_provider.dart';

import 'fakes/builders.dart';
import 'fakes/reloj_monotonico_falso.dart';
import 'fakes/servicio_evaluacion_online_falso.dart';

void main() {
  late ServicioEvaluacionOnlineFalso servicio;
  late RelojMonotonicoFalso relojMonotonico;
  late DateTime paredActual;
  late EvaluacionOnlineProvider provider;

  DateTime relojParedFalso() => paredActual;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    servicio = ServicioEvaluacionOnlineFalso();
    relojMonotonico = RelojMonotonicoFalso();
    paredActual = DateTime(2026, 1, 1, 10, 0, 0);
    provider = EvaluacionOnlineProvider(
      servicio,
      relojExamen: relojMonotonico,
      relojPared: relojParedFalso,
    );
  });

  // El binding de test verifica que no queden timers pendientes apenas
  // termina el CUERPO del `testWidgets` — antes de que un
  // `tearDown()`/`addTearDown()` normal llegue a correr. Por eso
  // `provider.dispose()` va inline, como última línea de cada test.
  Future<BuildContext> montar(WidgetTester tester) async {
    late BuildContext capturado;
    await tester.pumpWidget(
      wrapConRouterYTema(
        ChangeNotifierProvider.value(
          value: provider,
          child: Builder(builder: (context) {
            capturado = context;
            return const SizedBox();
          }),
        ),
      ),
    );
    return capturado;
  }

  testWidgets(
      'CRON-01: siembra el cronómetro contra la hora del servidor, no la del teléfono',
      (tester) async {
    final context = await montar(tester);

    servicio.getFormularioImpl = (_) async => formularioFixture(
          horaServidorISO: DateTime(2026, 1, 1, 7, 0, 0).toIso8601String(),
          fechaInicioISO: DateTime(2026, 1, 1, 6, 0, 0).toIso8601String(),
          fechaFinISO: DateTime(2026, 1, 1, 9, 0, 0).toIso8601String(),
        );

    await provider.initEvaluacion(context, 1);

    // Si hubiera usado el reloj del teléfono (10:00, ya pasada fechaFin=09:00)
    // el restante sería 0. Contra el servidor (07:00) quedan 2h exactas.
    expect(provider.tiempoRestante, const Duration(hours: 2));
    provider.dispose();
  });

  testWidgets(
      'CRON-02: atrasar el reloj de pared no regala tiempo — gana el monotónico',
      (tester) async {
    final context = await montar(tester);
    servicio.getFormularioImpl = (_) async => formularioFixture(
          horaServidorISO: paredActual.toIso8601String(),
          fechaInicioISO:
              paredActual.subtract(const Duration(hours: 1)).toIso8601String(),
          fechaFinISO:
              paredActual.add(const Duration(hours: 1)).toIso8601String(),
        );

    await provider.initEvaluacion(context, 1);
    expect(provider.tiempoRestante, const Duration(hours: 1));

    relojMonotonico.avanzar(const Duration(seconds: 30));
    paredActual = paredActual.subtract(const Duration(hours: 1)); // atrasa 1h

    await tester.pump(const Duration(seconds: 1));

    expect(
      provider.tiempoRestante,
      const Duration(hours: 1) - const Duration(seconds: 30),
    );
    provider.dispose();
  });

  testWidgets(
      'CRON-03: adelantar el reloj de pared agota el tiempo y dispara auto-finalización (gana el máximo)',
      (tester) async {
    final context = await montar(tester);
    servicio.getFormularioImpl = (_) async => formularioFixture(
          horaServidorISO: paredActual.toIso8601String(),
          fechaInicioISO:
              paredActual.subtract(const Duration(hours: 1)).toIso8601String(),
          fechaFinISO:
              paredActual.add(const Duration(minutes: 5)).toIso8601String(),
        );
    servicio.finalizarEvaluacionImpl = (_) async {};

    await provider.initEvaluacion(context, 1);
    expect(provider.tiempoRestante, const Duration(minutes: 5));

    relojMonotonico.avanzar(const Duration(seconds: 30));
    paredActual = paredActual.add(const Duration(hours: 1)); // adelanta 1h

    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    await tester.pump();

    expect(provider.tiempoRestante, Duration.zero);
    expect(servicio.finalizarEvaluacionLlamadas, 1);
    provider.dispose();
  });

  testWidgets(
      'CRON-04: al llegar a 0 finaliza exactamente una vez, sin reintentos',
      (tester) async {
    final context = await montar(tester);
    servicio.getFormularioImpl = (_) async => formularioFixture(
          horaServidorISO: paredActual.toIso8601String(),
          fechaInicioISO:
              paredActual.subtract(const Duration(hours: 1)).toIso8601String(),
          fechaFinISO:
              paredActual.add(const Duration(seconds: 2)).toIso8601String(),
        );
    servicio.finalizarEvaluacionImpl = (_) async {};

    await provider.initEvaluacion(context, 1);

    for (var i = 0; i < 5; i++) {
      relojMonotonico.avanzar(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
    }
    await tester.pump();
    await tester.pump();

    expect(servicio.finalizarEvaluacionLlamadas, 1);
    provider.dispose();
  });

  testWidgets(
      'CRON-05: fallo de red al finalizar manualmente muestra AppSnackBar y reanuda el timer sin resetear el cronómetro',
      (tester) async {
    final context = await montar(tester);
    servicio.getFormularioImpl = (_) async => formularioFixture(
          horaServidorISO: paredActual.toIso8601String(),
          fechaInicioISO:
              paredActual.subtract(const Duration(hours: 1)).toIso8601String(),
          fechaFinISO:
              paredActual.add(const Duration(minutes: 10)).toIso8601String(),
        );
    servicio.finalizarEvaluacionImpl = (_) async {
      throw Exception('sin conexión');
    };

    await provider.initEvaluacion(context, 1);

    relojMonotonico.avanzar(const Duration(seconds: 30));
    await tester.pump(const Duration(seconds: 1));
    final restanteAntes = provider.tiempoRestante;
    expect(restanteAntes, lessThan(const Duration(minutes: 10)));

    await provider.finalizarEvaluacion(context, 1);
    await tester.pump();
    await tester.pump();

    expect(
      find.text(
        'No se pudo finalizar la evaluación. Verifique su conexión e intente nuevamente.',
      ),
      findsOneWidget,
    );
    // No se reseteó a los minutos iniciales: sigue cerca de donde iba.
    expect(provider.tiempoRestante, lessThanOrEqualTo(restanteAntes));
    expect(provider.tiempoRestante, isNot(const Duration(minutes: 10)));

    // El timer se reactivó sin resembrar: sigue bajando en el siguiente tick.
    relojMonotonico.avanzar(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(provider.tiempoRestante, lessThan(restanteAntes));
    provider.dispose();
  });
}
