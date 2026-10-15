import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/infrastructure/model/resultado_evaluacion_model.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/infrastructure/evaluacion_salida_local_storage.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/presentation/provider/evaluacion_online_provider.dart';

import 'fakes/builders.dart';
import 'fakes/servicio_evaluacion_online_falso.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FINAL-15: Retroalimentación protegida por el backend', () {
    test('ResultadoEvaluacionModel mapea puedeVerRetroalimentacion false sin depender de reloj local', () {
      final json = {
        'notaFinal': 8.5,
        'totalPreguntas': 10,
        'preguntasRespondidas': 10,
        'puedeVerRetroalimentacion': false,
        'detalle': [],
      };

      final model = ResultadoEvaluacionModel.fromJson(json);

      expect(model.puedeVerRetroalimentacion, isFalse);
      expect(model.notaFinal, 8.5);
    });

    test('ResultadoEvaluacionModel mapea puedeVerRetroalimentacion true cuando el backend lo autoriza', () {
      final json = {
        'notaFinal': 10.0,
        'totalPreguntas': 10,
        'preguntasRespondidas': 10,
        'puedeVerRetroalimentacion': true,
        'detalle': [],
      };

      final model = ResultadoEvaluacionModel.fromJson(json);

      expect(model.puedeVerRetroalimentacion, isTrue);
      expect(model.notaFinal, 10.0);
    });
  });

  group('FINAL-16: autoFinalizarFallo activa botones de escape sin quedarse colgado', () {
    testWidgets('error en auto-finalizar marca autoFinalizarFallo = true', (tester) async {
      final servicio = ServicioEvaluacionOnlineFalso();
      servicio.getFormularioImpl = (_) async {
        return formularioFixture(
          fechaInicioISO: '2026-09-11T10:00:00.000Z',
          fechaFinISO: '2026-09-11T10:15:00.000Z',
        );
      };
      servicio.finalizarEvaluacionImpl = (_) async {
        throw Exception('403 Forbidden: tiempo expirado o error de red');
      };

      final provider = EvaluacionOnlineProvider(servicio);
      expect(provider.autoFinalizarFallo, isFalse);

      await tester.pumpWidget(wrapConRouterYTema(
        Builder(builder: (context) {
          return const SizedBox();
        }),
      ));

      final element = tester.element(find.byType(SizedBox));

      // Disparar auto-finalizar que falla
      await provider.finalizarEvaluacion(
        element,
        100,
        esAutoFinalizar: true,
      );

      expect(provider.autoFinalizarFallo, isTrue);
      expect(provider.finalizando, isFalse);

      provider.dispose();
    });
  });

  group('FINAL-17: Marcas de salida de intentos viejos se descartan', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('marca de salida con timestamp anterior a fechaInicio del nuevo intento debe ser limpiada', () async {
      final storage = EvaluacionSalidaLocalStorage();
      const idActividad = 200;

      // Salida ocurrida a las 10:00 (intento 1)
      final salidaVieja = DateTime.parse('2026-09-11T10:00:00.000Z');
      await storage.marcarSalidaEnCurso(idActividad, salidaVieja.toIso8601String());

      // El nuevo intento arrancó a las 10:20 (intento 2)
      final fechaInicioIntentoNuevo = DateTime.parse('2026-09-11T10:20:00.000Z');

      // Leer la marca
      final isoLeido = await storage.leerSalidaEnCurso(idActividad);
      expect(isoLeido, isNotNull);

      final fechaLeida = DateTime.parse(isoLeido!);
      final esVieja = fechaLeida.isBefore(fechaInicioIntentoNuevo);

      expect(esVieja, isTrue);

      if (esVieja) {
        await storage.limpiarSalidaEnCurso(idActividad);
      }

      // Debe quedar limpia
      expect(await storage.leerSalidaEnCurso(idActividad), isNull);
    });
  });
}
