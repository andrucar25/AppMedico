import 'package:appmedicolaluz/models/Medico.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:appmedicolaluz/utils/config.dart';
import 'package:appmedicolaluz/user_preferences/user_preferences.dart';

class MedicoProvider {
  final _prefs = new UserPreferences();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {'email': email, 'password': password};
    final url = Uri.https(urlApi, '$versionApi/auth/medicos');
    final resp = await http.post(url,
        body: json.encode(authData),
        headers: {"Content-Type": "application/json"});

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('token')) {
      _prefs.token = decodedResp['token'];
      print(decodedResp['token']);
      return {'ok': true, 'token': decodedResp['token']};
    } else {
      return {'ok': false, 'message': decodedResp['message']};
    }
  }

  Future<Medico> getMedicoData() async {
    final prefs = new UserPreferences();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${prefs.token}'
    };
    final url = Uri.https(urlApi, '$versionApi/utils/medicos');
    final resp = await http.get(url, headers: requestHeaders);
    final decodedData = json.decode(resp.body);

    final medico = new Medico.fromJsonMap(decodedData);

    return medico;
  }

  Future<bool> logout() async {
    final prefs = new UserPreferences();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${prefs.token}'
    };
    try {
      final url = Uri.https(urlApi, '$versionApi/auth/medicos/logout');
      final resp = await http.post(url, headers: requestHeaders);
      final decodedData = json.decode(resp.body);
      print(decodedData);
      prefs.token = '';
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changuePassword(String currentPass, String newPass) async {
    final newPassData = {
      'current_password': currentPass,
      'new_password': newPass
    };
    final prefs = new UserPreferences();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${prefs.token}'
    };

    try {
      final url = Uri.https(urlApi, '$versionApi/auth/medicos/change-password');
      final resp = await http.post(url,
          body: json.encode(newPassData), headers: requestHeaders);
      final decodedData = json.decode(resp.body);
      print(decodedData);
      Map<String, dynamic> decodedResp = json.decode(resp.body);
      print(decodedResp['status'] == 'failed');
      if (decodedResp['status'] == 'failed') {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(
      String nombres,
      String apellidos,
      String email,
      String password,
      String cv,
      String foto,
      String estado,
      String idEspecialidad) async {
    final newMedicoData = {
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'password': password,
      'cv': cv,
      'foto': foto,
      'estado': estado,
      'idEspecialidad': idEspecialidad
    };
    final prefs = new UserPreferences();
    final url = Uri.https(urlApi, '$versionApi/auth/medicos/register');

    final resp = await http.post(url,
        body: json.encode(newMedicoData),
        headers: {"Content-Type": "application/json"});
    Map<String, dynamic> decodedResp = json.decode(resp.body);
    if (!decodedResp.containsKey('token')) {
      return false;
    } else {
      prefs.token = decodedResp['token'];
      return true;
    }
  }
}
