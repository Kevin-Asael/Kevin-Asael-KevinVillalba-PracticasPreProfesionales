import 'package:utn_movil_app/apps/auth/auth_aux/domain/services/token_service.dart';
import 'package:utn_movil_app/apps/auth/auth_aux/domain/token_repository.dart';
import 'package:utn_movil_app/apps/auth/login/domain/entities/token_entity.dart';
import 'package:utn_movil_app/apps/auth/login/domain/entities/token_payload_entity.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/entity/anticopia_estado_entity.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/entity/formulario_entity.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/entity/resultado_evaluacion_entity.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/evaluacion_online_repository.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/evaluacion_online_service.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/query/anticopia_salida_body.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/query/formulario_evaluacion_param.dart';
import 'package:utn_movil_app/apps/portafolio_estudiante/evaluacion_online/domain/query/responder_pregunta_body.dart';

/// Nunca se invoca de verdad: [ServicioEvaluacionOnlineFalso] sobreescribe
/// todos los métodos públicos de [EvaluacionOnlineService], así que esta
/// dependencia sólo existe para satisfacer el constructor real.
class _DummyRepo implements EvaluacionOnlineRepository {
  @override
  Future<FormularioEntity> getFormulario(
    String token,
    FormularioEvaluacionParam param,
  ) =>
      throw UnimplementedError();

  @override
  Future<void> responderPregunta(
    String token,
    FormularioEvaluacionParam param,
    ResponderPreguntaBody body,
  ) =>
      throw UnimplementedError();

  @override
  Future<void> finalizarEvaluacion(
    String token,
    FormularioEvaluacionParam param,
  ) =>
      throw UnimplementedError();

  @override
  Future<ResultadoEvaluacionEntity> getResultado(
    String token,
    FormularioEvaluacionParam param,
  ) =>
      throw UnimplementedError();

  @override
  Future<AntiCopiaEstadoEntity> registrarSalidaAntiCopia(
    String token,
    FormularioEvaluacionParam param,
    AntiCopiaSalidaBody body,
  ) =>
      throw UnimplementedError();
}

class _DummyTokenRepository implements TokenRepository {
  @override
  Future<TokenPyloadEntity> extractPayload(String token) =>
      throw UnimplementedError();

  @override
  Future<bool> validateToken(String token) => throw UnimplementedError();

  @override
  Future<TokenEntity> refreshToken(String refreshToken) =>
      throw UnimplementedError();
}

/// Fake a mano de [EvaluacionOnlineService]: extiende la clase real (el
/// provider depende del tipo concreto, no de una interfaz) pero
/// sobreescribe los 5 métodos públicos como campos función configurables
/// por test — nunca toca red, token ni storage real.
class ServicioEvaluacionOnlineFalso extends EvaluacionOnlineService {
  ServicioEvaluacionOnlineFalso()
      : super(_DummyRepo(), TokenService(_DummyTokenRepository()));

  Future<FormularioEntity> Function(int idActividadAlumno)? getFormularioImpl;

  Future<void> Function(int idActividadAlumno, ResponderPreguntaBody body)?
      responderPreguntaImpl;

  Future<void> Function(int idActividadAlumno)? finalizarEvaluacionImpl;
  int finalizarEvaluacionLlamadas = 0;

  Future<ResultadoEvaluacionEntity> Function(int idActividadAlumno)?
      getResultadoImpl;

  Future<AntiCopiaEstadoEntity> Function(
    int idActividadAlumno,
    AntiCopiaSalidaBody body,
  )? registrarSalidaAntiCopiaImpl;

  @override
  Future<FormularioEntity> getFormulario(int idActividadAlumno) =>
      getFormularioImpl!(idActividadAlumno);

  @override
  Future<void> responderPregunta(
    int idActividadAlumno,
    ResponderPreguntaBody body,
  ) =>
      responderPreguntaImpl!(idActividadAlumno, body);

  @override
  Future<void> finalizarEvaluacion(int idActividadAlumno) {
    finalizarEvaluacionLlamadas++;
    return finalizarEvaluacionImpl!(idActividadAlumno);
  }

  @override
  Future<ResultadoEvaluacionEntity> getResultado(int idActividadAlumno) =>
      getResultadoImpl!(idActividadAlumno);

  @override
  Future<AntiCopiaEstadoEntity> registrarSalidaAntiCopia(
    int idActividadAlumno,
    AntiCopiaSalidaBody body,
  ) =>
      registrarSalidaAntiCopiaImpl!(idActividadAlumno, body);
}
