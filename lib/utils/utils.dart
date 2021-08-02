import 'dart:math';
import 'package:appmedicolaluz/constants.dart';
import 'package:appmedicolaluz/models/Teleconsulta.dart';
import 'package:appmedicolaluz/providers/teleconsulta_provider.dart';
import 'package:appmedicolaluz/screens/menu_screen/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

double roundDouble(double value, int places) {
  double mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

Future<void> launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
    );
  } else {
    throw 'Could not launch $url';
  }
}

void showEndTeleconsultationModal(BuildContext context,
    TeleconsultaProvider provider, Teleconsulta teleconsulta) {
  final formKey = GlobalKey<FormState>();
  String diagnostico = '';
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  bool isSaving = false;
  Future<void> _endTeleconsultation() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    isSaving = true;
    Dialogs.showLoadingDialog(context, _keyLoader, 'Finalizando Teleconsulta');

    String resp = await provider.endTeleconsultation(
        teleconsulta.idTeleconsulta, diagnostico);
    if (resp == "success") {
      Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, MenuScreen.routeName);
    } else {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      showAlertWithTitle(
          context,
          'No pudimos finalizar la teleconsulta, por favor intentalo mas tarde',
          'Error');
    }
  }

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Form(
                key: formKey,
                child: Container(
                  height: 350.0,
                  width: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 40.0,
                            color: kPrimaryColor,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Diagnostico Teleconsulta',
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Diagnostico',
                          counterText: '*Maximo de 200 caracteres',
                        ),
                        onSaved: (value) {
                          diagnostico = value;
                        },
                        validator: (value) {
                          if (value.length > 200 || value.length == 0) {
                            return 'Ingrese un diagnostico valido';
                          } else {
                            return null;
                          }
                        },
                      ),
                      ButtonTheme(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: kPrimaryColor, // background
                            onPrimary: Colors.grey, // foreground
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_rounded,
                                  color: Colors.white),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Finalizar teleconsulta',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () =>
                              (isSaving) ? null : _endTeleconsultation(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

void showAlertWithTitle(BuildContext context, String message, String title) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            title,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
        ),
        content: Container(
          height: 200.0,
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Icon(
              Icons.error,
              size: 70.0,
              color: kPrimaryColor,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              message,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 250.0,
              height: 40.0,
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                textColor: Colors.white,
                color: kPrimaryColor,
                label: Text(
                  'Aceptar',
                ),
                icon: Icon(Icons.check),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          ]),
        ),
      );
    },
  );
}

void showModalMessage(
    BuildContext context, String message, IconData icon, String title) {
  showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icon, size: 40.0),
                Text(
                  title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
                ButtonTheme(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black, // background
                      onPrimary: Colors.grey, // foreground
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text('Regresar'),
                      ],
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

void showAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Informacion incorrecta',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
        ),
        content: Container(
          height: 200.0,
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Icon(
              Icons.error,
              size: 70.0,
              color: kPrimaryColor,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              message,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 250.0,
              height: 40.0,
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                textColor: Colors.white,
                color: kPrimaryColor,
                label: Text(
                  'Aceptar',
                ),
                icon: Icon(Icons.check),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          ]),
        ),
      );
    },
  );
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, String message) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  key: key,
                  backgroundColor: Colors.white,
                  contentPadding: EdgeInsets.all(20.0),
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(kPrimaryColor),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          message,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.grey[600]),
                        )
                      ]),
                    )
                  ]));
        });
  }
}

void showAlertCulqiTarjeta(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Error de validación',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
        ),
        content: Container(
          height: 300.0,
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Icon(
              Icons.error,
              size: 70.0,
              color: kPrimaryColor,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              message,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 250.0,
              height: 40.0,
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                textColor: Colors.white,
                color: kPrimaryColor,
                label: Text(
                  'Aceptar',
                ),
                icon: Icon(Icons.check),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          ]),
        ),
      );
    },
  );
}

void showAlertPago(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Error en la transacción',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
        ),
        content: Container(
          height: 300.0,
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Icon(
              Icons.error,
              size: 70.0,
              color: kPrimaryColor,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              message,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 250.0,
              height: 40.0,
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                textColor: Colors.white,
                color: kPrimaryColor,
                label: Text(
                  'Aceptar',
                ),
                icon: Icon(Icons.check),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          ]),
        ),
      );
    },
  );
}

void showAlertTeleconsultaPendiente(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'No hay teleconsulta aún!',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
        ),
        content: Container(
          height: 200.0,
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Icon(
              Icons.error,
              size: 70.0,
              color: kPrimaryColor,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              message,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 250.0,
              height: 40.0,
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                textColor: Colors.white,
                color: kPrimaryColor,
                label: Text(
                  'Aceptar',
                ),
                icon: Icon(Icons.check),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          ]),
        ),
      );
    },
  );
}
String getEspecialidadName(int index) {
  switch (index) {
    case 1:
      return 'Reumatologia';
      break;
    case 2:
      return 'Cardiologia';
      break;
    case 3:
      return 'Fisiatria';
      break;
    case 4:
      return 'Neumologia';
      break;
    case 5:
      return 'Oftalmologia';
      break;
    case 6:
      return 'Gastroenterologia';
      break;
    default:
      return 'Sin nombre';
  }
}

