import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/services/reloj_monotonico.dart';

/// Reloj monotónico controlable a mano para tests — nunca usa tiempo real.
class RelojMonotonicoFalso implements RelojMonotonico {
  Duration _transcurrido = Duration.zero;

  @override
  void iniciar() => _transcurrido = Duration.zero;

  @override
  Duration get transcurrido => _transcurrido;

  /// Sólo para tests: simula el paso de tiempo monotónico.
  void avanzar(Duration d) => _transcurrido += d;
}
