import 'package:flutter/material.dart';
import 'package:appmedicolaluz/screens/splash/components/body.dart';
import 'package:appmedicolaluz/size_config.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/backsplash.png"),
            fit: BoxFit.cover,
          )),
          child: Body()),
    );
  }
}
