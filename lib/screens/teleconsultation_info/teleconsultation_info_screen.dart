import 'dart:io';

import 'package:appmedicolaluz/components/default_appbar.dart';
import 'package:appmedicolaluz/components/default_button.dart';
import 'package:appmedicolaluz/components/text_input_small_style.dart';
import 'package:appmedicolaluz/models/ArchivoTeleconsulta.dart';
import 'package:appmedicolaluz/models/Teleconsulta.dart';
import 'package:appmedicolaluz/providers/teleconsulta_provider.dart';
import 'package:appmedicolaluz/screens/teleconsultation_info/history_paciente_screen.dart';
import 'package:appmedicolaluz/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/files_list_section.dart';
import 'components/receta_section.dart';

class TeleconsultationInfoScreen extends StatefulWidget {
  static String routeName = "/teleconsultation_info_screen";

  @override
  _TeleconsultationInfoScreenState createState() =>
      _TeleconsultationInfoScreenState();
}

class _TeleconsultationInfoScreenState
    extends State<TeleconsultationInfoScreen> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final formKey = GlobalKey<FormState>();
  File selectedfile;
  String progress;
  String meetUrl;
  final provider = TeleconsultaProvider();
  bool urlDataValidator = false;

  @override
  Widget build(BuildContext context) {
    Teleconsulta teleconsulta = ModalRoute.of(context).settings.arguments;

    Future<void> _uploadFile(BuildContext context) async {
      Dialogs.showLoadingDialog(context, _keyLoader, 'Subiendo Archivo');
      FilePickerResult result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path);

        String resp =
            await provider.uploadFile(teleconsulta.idTeleconsulta, file);
        if (resp == "success") {
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(
              context, TeleconsultationInfoScreen.routeName,
              arguments: teleconsulta);
        } else {
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          showAlertWithTitle(
              context,
              'No pudimos subir tu archivo, por favor intentalo mas tarde',
              'Error');
        }
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        showAlertWithTitle(
            context,
            'Por favor selecciona un archivo para subir',
            'No se encontro un archivo');
      }
    }

    Future<void> _validate(
        BuildContext context, Teleconsulta teleconsulta) async {
      Dialogs.showLoadingDialog(context, _keyLoader, 'Validando Datos');
      String response =
          await provider.uploadUrl(meetUrl, teleconsulta.idTeleconsulta);
      if (response != 'success') {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        showAlert(context, response);
      } else {
        Navigator.of(context).pop();
        Navigator.pushReplacementNamed(
            context, TeleconsultationInfoScreen.routeName,
            arguments: teleconsulta);
      }
    }

    meetForm(Teleconsulta teleconsulta) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 280.0,
            child: Form(
              key: formKey,
              child: TextFormField(
                initialValue: meetUrl,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    color: kTextColor),
                decoration: CommonStyle.textFieldStyle(
                    labelTextStr: "Enlace de Meet", hintTextStr: "meet.com"),
                textCapitalization: TextCapitalization.sentences,
                onSaved: (value) {
                  meetUrl = value;
                },
                validator: (value) {
                  if (value.length == 0) {
                    return 'Ingrese un dato correcto';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          SizedBox(
            // width: _screenSize.width * 0.2,
            width: 80.0,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              color: kPrimaryColor,
              padding: EdgeInsets.all(1.0),
              onPressed: () {
                if (!formKey.currentState.validate()) {
                  urlDataValidator = false;
                  return;
                }

                formKey.currentState.save();

                _validate(context, teleconsulta);
              },
              child: Icon(Icons.save, color: Colors.white, size: 30.0),
            ),
          ),
        ],
      );
    }

    Future<void> _uploadRecipe(BuildContext context) async {
      Dialogs.showLoadingDialog(context, _keyLoader, 'Subiendo Receta');
      FilePickerResult result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path);

        String resp =
            await provider.uploadRecipe(teleconsulta.idTeleconsulta, file);
        if (resp == "success") {
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(
              context, TeleconsultationInfoScreen.routeName,
              arguments: teleconsulta);
        } else {
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          showAlertWithTitle(
              context,
              'No pudimos subir tu receta, por favor intentalo mas tarde',
              'Error');
        }
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        showAlertWithTitle(context, 'Por favor selecciona un receta para subir',
            'No se encontro un archivo');
      }
    }

    List<Widget> filesSection(List<ArchivoTeleconsulta> data) {
      String receta =
          (data.isEmpty) ? teleconsulta.receta : data[0].teleconsulta.receta;
      meetUrl =
          (data.isEmpty) ? teleconsulta.enlace : data[0].teleconsulta.enlace;
      print(data.length);
      return [
        meetForm(teleconsulta),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Archivos Adjuntos',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 15.0,
                  letterSpacing: 5.0,
                  fontWeight: FontWeight.w900),
            ),
            Icon(
              Icons.file_copy,
              color: kPrimaryColor,
              size: 20.0,
            ),
          ],
        ),
        Divider(
          color: kPrimaryColor,
          thickness: 0.3,
        ),
        Container(
          height: 70.0,
          child: fileListSection(data),
        ),
        SizedBox(
          height: 10.0,
        ),
        TextButton(
          onPressed: () {
            _uploadFile(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.upload_file,
                color: Colors.white,
              ),
              Text('Subir Archivo'),
            ],
          ),
          style: TextButton.styleFrom(
            shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            primary: Colors.white,
            elevation: 3.0,
            backgroundColor: kPrimaryColor,
            onSurface: Colors.grey,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Receta Medica',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 15.0,
                  letterSpacing: 5.0,
                  fontWeight: FontWeight.w900),
            ),
            Icon(
              Icons.description,
              color: kPrimaryColor,
              size: 20.0,
            ),
          ],
        ),
        Divider(
          color: kPrimaryColor,
          thickness: 0.3,
        ),
        recetaMedica(receta),
        TextButton(
          onPressed: () {
            _uploadRecipe(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.upload_file,
                color: Colors.white,
              ),
              Text('Subir Receta'),
            ],
          ),
          style: TextButton.styleFrom(
            shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            primary: Colors.white,
            elevation: 3.0,
            backgroundColor: kPrimaryColor,
            onSurface: Colors.grey,
          ),
        ),
      ];
    }

    bottomAppBar() {
      return BottomAppBar(
        child: Container(
          // color: Colors.grey[200],
          width: double.infinity,
          // height: _screenSize.height * 0.09,
          height: getProportionateScreenHeight(80.0),
          decoration: BoxDecoration(
              color: kPrimaryColor,
              image: DecorationImage(
                image: AssetImage("assets/images/backinfoteleconsulta.png"),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ]),
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: SizedBox(
              // width: _screenSize.width * 0.65,
              width: getProportionateScreenWidth(300.0),
              child: Builder(builder: (BuildContext context) {
                return DefaultIconButton(
                  icon: Icons.check_circle_outline,
                  press: () {
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
                          height: 250,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Finalizar Teleconsulta',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 20.0,
                                        letterSpacing: 5.0,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Icon(
                                    Icons.check_circle,
                                    size: 60.0,
                                    color: kPrimaryColor,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    '¿Seguro que deseas finalizar esta teleconsulta?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: ButtonTheme(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary:
                                                  kPrimaryColor, // background
                                              onPrimary:
                                                  Colors.white, // foreground
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                    Icons.check_circle_outline),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  'Finalizar',
                                                  style:
                                                      TextStyle(fontSize: 20.0),
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              showEndTeleconsultationModal(
                                                  context,
                                                  provider,
                                                  teleconsulta);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  text: 'Finalizar Teleconsulta',
                );
              }),
            ),
          ),
        ),
      );
    }

    return Scaffold(
        bottomNavigationBar: bottomAppBar(),
        appBar: defaultAppBar(),
        body: Container(
          child: ListView(
            children: [
              Stack(children: [
                Positioned(
                    child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/backinfoteleconsulta.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30))),
                  height: 200,
                )),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                teleconsulta.foto,
                                height: 200.0,
                                width: 140.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    (teleconsulta.estadoConsulta == '1')
                                        ? Icons.pending_actions_sharp
                                        : Icons.check,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    (teleconsulta.estadoConsulta == '1')
                                        ? 'Pendiente'
                                        : 'Finalizada',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                '${teleconsulta.nombresPaciente} ${teleconsulta.apellidosPaciente}',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                'Paciente',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    teleconsulta.fecha,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(25.0),
                                  ),
                                  FloatingActionButton(
                                      heroTag: 'comment',
                                      mini: true,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.article,
                                        size: 20.0,
                                        color: kPrimaryColor,
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(context,HistoryPacienteTeleconsultation.routeName,  arguments: teleconsulta.idPaciente);
                                      }),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.watch_later_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    teleconsulta.hora,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      FutureBuilder(
                        future: provider.getArchivosTeleconsulta(
                            teleconsulta.idTeleconsulta),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ArchivoTeleconsulta>> snapshot) {
                          if (snapshot.data == null)
                            return Container(
                              height: 300.0,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                          return Column(
                            children: filesSection(snapshot.data),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ));
  }
}
