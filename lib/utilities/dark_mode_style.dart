import 'package:flutter/material.dart';

class Styles{
  static CustomThemeData themeData(bool isDarkMode, BuildContext context) {
    return CustomThemeData(
      color1: isDarkMode? Colors.black: Colors.white,
    );
  }
}

class CustomThemeData{
  Color color1;
  CustomThemeData({this.color1});
}