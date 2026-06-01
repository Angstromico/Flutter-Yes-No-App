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
  final int colorIndex;

  AppTheme({required this.colorIndex})
      : assert(colorIndex >= 0, 'colorIndex must be a non-negative integer'),
        assert(colorIndex < _colorList.length, 'colorIndex must be less than ${_colorList.length}');

  ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: _colorList[colorIndex % _colorList.length],
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: _colorList[colorIndex % _colorList.length],
    );
  }

  ThemeData theme() {
    return lightTheme();
  }
}
