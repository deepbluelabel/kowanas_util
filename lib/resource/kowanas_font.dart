import 'package:flutter/material.dart';

class KowanasFont{
  KowanasFont._internal();
  static final _instance = KowanasFont._internal();

  factory KowanasFont() => _instance;

  double _getSize(size){
    switch(size){
      case 0: return 14.0;
      case 1: return 18.0;
      case 2: return 20.0;
      case 3: return 24.0;
      case 4: return 28.0;
      case 5: return 32.0;
      case 6: return 36.0;
      case 7: return 48.0;
      case 8: return 64.0;
      case 9: return 80.0;
    }
    return 20.0;
  }

  _getWeight(weight){
    switch(weight){
      case 100: return FontWeight.w100;
      case 200: return FontWeight.w200;
      case 300: return FontWeight.w300;
      case 400: return FontWeight.w400;
      case 500: return FontWeight.w500;
      case 600: return FontWeight.w600;
      case 700: return FontWeight.w700;
      case 800: return FontWeight.w800;
      case 900: return FontWeight.w900;
    }
  }

  style({size = 5, weight = 500, color = Colors.black, underline = false}) {
    final decoration = (underline)
        ? TextDecoration.underline
        : TextDecoration.none;
    return TextStyle(fontSize: _getSize(size), fontWeight: _getWeight(weight),
        color: color, decoration: decoration);
  }
}
