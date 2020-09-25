import 'package:flutter/cupertino.dart';

final gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [
      0.1,
      0.9
    ],
    colors: [
      Color(0xffC36DD7).withOpacity(0.8),
      Color(0xff254bc8).withOpacity(0.7)
    ]);
final Shader linearGradient =
    gradient.createShader(Rect.fromLTWH(0.0, 0.0, 99.68, 70));
TextStyle kDrawerTextStyle = TextStyle(
  foreground: Paint()..shader = linearGradient,
  fontSize: 18.0,
  fontWeight: FontWeight.w500,
);

TextStyle textStyle = TextStyle(
  foreground: Paint()..shader = linearGradient,
  fontWeight: FontWeight.w500,
);
//linear-gradient(99.68deg, #C36DD7 -205.43%, #254BC8 133.09%);
