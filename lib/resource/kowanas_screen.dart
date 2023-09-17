import 'package:flutter/material.dart';

class KowanasScreen{
  late Size size;
  late double width;
  late double height;

  KowanasScreen(context){
    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
  }

  double vsize(double rate) => height*rate;
  double hsize(double rate) => width*rate;
}