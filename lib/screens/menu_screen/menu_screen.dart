import 'package:appmedicolaluz/constants.dart';
import 'package:appmedicolaluz/providers/medico_provider.dart';
//import 'package:appmedicolaluz/screens/asistente/asistente.dart';
import 'package:appmedicolaluz/screens/home_screen/home_screen.dart';
import 'package:appmedicolaluz/screens/pending_teleconsultation/pending_teleconsultation_screen.dart';
//import 'package:appmedicolaluz/screens/payment_screen/confirm_payment.dart';
//import 'package:appmedicolaluz/screens/payment_screen/payment_screen.dart';
import 'package:appmedicolaluz/screens/splash/splash_screen.dart';
import 'package:appmedicolaluz/utils/utils.dart';
import 'package:drawerbehavior/drawer_scaffold.dart';
import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import '../../size_config.dart';
import 'components/menu_items.dart';

class MenuScreen extends StatefulWidget {
  static String routeName = "/menu_screen";
  @override
  _DrawerScaleIconState createState() => _DrawerScaleIconState();
}

class _DrawerScaleIconState extends State<MenuScreen> {
  int selectedMenuItemId;
  int _currentIndex = 0;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final medicosProvider = new MedicoProvider();

  @override
  void initState() {
    selectedMenuItemId = menuWithIcon.items[0].id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // call it on your starting screen
    SizeConfig().init(context);
    return DrawerScaffold(
      appBar: AppBar(
          elevation: 5.0,
          title: Image.asset(
            "assets/images/logoclinicalaluz.png",
            fit: BoxFit.contain,
            height: getProportionateScreenHeight(35),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                      context, PendingTeleconsultationScreen.routeName);
                })
          ]),
      drawers: [
        SideDrawer(
          selectorColor: Colors.white70,
          percentage: 0.6,
          menu: menuWithIcon,
          animation: true,
          color: kPrimaryColor,
          selectedItemId: selectedMenuItemId,
          onMenuItemSelected: (itemId) {
            if (itemId == 5) _logout(medicosProvider, context);
            setState(() {
              selectedMenuItemId = itemId;
            });
          },
        )
      ],
      builder: (context, id) => IndexedStack(
        index: id,
        children: menu.items.map<Widget>((e) {
          switch (id) {
            case 0:
              {
                return HomeScreen();
              }
              break;

            case 1:
              {
                return HomeScreen();
              }
              break;
            case 2:
              {
                return HomeScreen();
              }
              break;
            case 3:
              {
                return HomeScreen();
              }
              break;
            case 4:
              {
                return HomeScreen();
              }
              break;

            default:
              {
                return HomeScreen();
              }
              break;
          }
        }).toList(),
      ),
    );
  }

  Future<void> _logout(MedicoProvider provider, BuildContext context) async {
    Dialogs.showLoadingDialog(context, _keyLoader, 'Cerrando Sesion');
    bool response = await medicosProvider.logout();
    if (response) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Navigator.pushReplacementNamed(context, SplashScreen.routeName);
    } else {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      showAlert(context, 'Ocurrio un error, Intentalo mas tarde');
    }
  }
}
