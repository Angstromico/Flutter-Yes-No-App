import 'package:flutter/material.dart';

const Color _customColor = Color(0xFF123456);

const List<Color> _colorList = [
  _customColor,
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.pink,
  Colors.brown,
  Colors.cyan,
  Colors.indigo,
];

class AppTheme {
  final int colorIndex = 0;

  AppTheme({required int colorIndex}) : assert(colorIndex >= 0, 'colorIndex must be a non-negative integer and color must be between 0 and ${_colorList.length - 1}'), assert(colorIndex < _colorList.length, 'colorIndex must be less than ${_colorList.length}');

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorList[colorIndex % _colorList.length],
    );
  }
}