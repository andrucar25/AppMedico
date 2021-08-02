import 'package:rxdart/rxdart.dart';

import 'package:appmedicolaluz/models/Medico.dart';
import 'package:appmedicolaluz/providers/medico_provider.dart';

class MedicoBloc {
  final medicoController = new BehaviorSubject<Medico>();
  final _loadingController = new BehaviorSubject<bool>();

  final _medicoProvider = new MedicoProvider();

  Stream<Medico> get medicoStream => medicoController.stream;
  Stream<bool> get loading => _loadingController.stream;

  Future getMedicoData() async {
    final medico = await _medicoProvider.getMedicoData();
    medicoController.sink.add(medico);
    return true;
  }

  dispose() {
    medicoController?.close();
    _loadingController?.close();
  }
}
