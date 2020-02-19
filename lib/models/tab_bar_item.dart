import 'package:flutter/material.dart';

enum TabBarItemType { all, movie, tv, person }

class TabBarItem {
  const TabBarItem({
    @required this.text,
    @required this.iconData,
    @required this.type,
  });

  final String text;
  final IconData iconData;
  final TabBarItemType type;
}
