import 'package:appmedicolaluz/constants.dart';
import 'package:flutter/material.dart';

class CommonStyle {
  static InputDecoration textFieldStyle(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(18.0),
      prefixIcon: Icon(
        Icons.video_call,
        color: kPrimaryColor,
      ),
      labelText: labelTextStr,
      hintText: hintTextStr,
      hintStyle: TextStyle(fontSize: 10.0),
      labelStyle: TextStyle(
          color: kPrimaryColor,
          fontSize: 15.0,
          letterSpacing: 5.0,
          fontWeight: FontWeight.w900),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
