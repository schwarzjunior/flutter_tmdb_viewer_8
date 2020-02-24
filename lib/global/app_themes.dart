import 'package:flutter/material.dart';

part 'app_themes_base_part.dart';

final ThemeData theme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  primaryColor: Colors.blue,
  textTheme: TextTheme(
    body1: _body1.merge(TextStyle(color: const Color(0x00000000).withOpacity(_body1.color.opacity))),
    body2: _body2.merge(TextStyle(color: const Color(0x00000000).withOpacity(_body2.color.opacity))),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.red,
  primaryColor: Colors.red,
  textTheme: TextTheme(
    body1: _body1.merge(TextStyle(color: const Color(0xffffffff).withOpacity(_body1.color.opacity))),
    body2: _body2.merge(TextStyle(color: const Color(0xffffffff).withOpacity(_body2.color.opacity))),
  ),
);
