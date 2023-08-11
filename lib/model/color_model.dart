import 'package:flutter/material.dart';

class ColorModel {
  List<Color> colors = <Color>[
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.lightGreen,
    Colors.yellow,
    Colors.teal,
    Colors.pink,
    Colors.cyan,
    Colors.amber,
    Colors.indigo,
    Colors.deepOrangeAccent,
    Colors.lightBlueAccent,
    Colors.limeAccent,
    Colors.deepPurpleAccent,
    Colors.amberAccent,
    Colors.cyanAccent,
    Colors.lime,
    Colors.indigoAccent,
    Colors.yellowAccent,
    Colors.pinkAccent,
    Colors.tealAccent,
    Colors.grey,
    Colors.brown,
    Colors.black,
    Colors.black87,
    Colors.deepPurple,
    Colors.teal.shade200,
    Colors.amber.shade200,
  ];

  Color primaryColor = Colors.red;

  String getColorName(Color color) {
    if (color == Colors.red) {
      return 'Red';
    } else if (color == Colors.blue) {
      return 'Blue';
    } else if (color == Colors.green) {
      return 'Green';
    } else if (color == Colors.purple) {
      return 'Purple';
    } else if (color == Colors.orange) {
      return 'Orange';
    } else if (color == Colors.lightGreen) {
      return 'Light Green';
    } else if (color == Colors.yellow) {
      return 'Yellow';
    } else if (color == Colors.teal) {
      return 'Teal';
    } else if (color == Colors.pink) {
      return 'Pink';
    } else if (color == Colors.cyan) {
      return 'Cyan';
    } else if (color == Colors.amber) {
      return 'Amber';
    } else if (color == Colors.indigo) {
      return 'Indigo';
    } else if (color == Colors.deepOrangeAccent) {
      return 'Deep Orange Accent';
    } else if (color == Colors.lightBlueAccent) {
      return 'Light Blue Accent';
    } else if (color == Colors.limeAccent) {
      return 'Lime Accent';
    } else if (color == Colors.deepPurpleAccent) {
      return 'Deep Purple Accent';
    } else if (color == Colors.amberAccent) {
      return 'Amber Accent';
    } else if (color == Colors.cyanAccent) {
      return 'Cyan Accent';
    } else if (color == Colors.lime) {
      return 'Lime';
    } else if (color == Colors.indigoAccent) {
      return 'Indigo Accent';
    } else if (color == Colors.yellowAccent) {
      return 'Yellow Accent';
    } else if (color == Colors.pinkAccent) {
      return 'Pink Accent';
    } else if (color == Colors.tealAccent) {
      return 'Teal Accent';
    } else if (color == Colors.grey) {
      return 'Grey';
    } else if (color == Colors.brown) {
      return 'Brown';
    } else if (color == Colors.black) {
      return 'Black';
    } else if (color == Colors.black87) {
      return 'Black 87';
    } else if (color == Colors.deepPurple) {
      return 'Deep Purple';
    } else if (color == Colors.teal.shade200) {
      return 'Teal Shade 200';
    } else if (color == Colors.amber.shade200) {
      return 'Amber Shade 200';
    } else {
      return 'Unknown';
    }
  }
}