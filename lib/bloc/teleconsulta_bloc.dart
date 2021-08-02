import 'package:rxdart/rxdart.dart';

import 'package:appmedicolaluz/models/Teleconsulta.dart';
import 'package:appmedicolaluz/providers/teleconsulta_provider.dart';

class TeleconsultaBloc {
  final teleconsultaController = new BehaviorSubject<List<Teleconsulta>>();
  final _loadingController = new BehaviorSubject<bool>();
  final _teleconsultaProvider = new TeleconsultaProvider();

  Stream<List<Teleconsulta>> get teleconsultaStream => teleconsultaController.stream;
  Stream<bool> get loading => _loadingController.stream;

  Future getTeleconsultasPendientes() async {
    final teleconsultasPendientes = await _teleconsultaProvider.getTeleconsultaPendiente();
    teleconsultaController.sink.add(teleconsultasPendientes);
    return true;
  }

    Future getTeleconsultaHistorialPaciente(int idPaciente) async {
    final teleconsultaPacienteHistorial = await _teleconsultaProvider.getTeleconsultaHistorialPaciente(idPaciente);
    teleconsultaController.sink.add(teleconsultaPacienteHistorial);
    return true;
  }



  dispose() {
    teleconsultaController?.close();
    _loadingController?.close();
  }
}
