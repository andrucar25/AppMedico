import 'package:flutter/material.dart';
import 'components/body.dart';
import 'package:appmedicolaluz/theme.dart';



class PendingTeleconsultationScreen extends StatelessWidget {
  static String routeName = "/pending_teleconsultation_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TeleconsultaPendiente(),
    );
  }
}
