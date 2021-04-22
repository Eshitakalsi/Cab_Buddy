import 'package:flutter/material.dart';

class AppCommons {
  static _Colors colors = _Colors();
  static _Dimens dimens = _Dimens();
}

class _Colors {
  final Color backgroundColor = Color(0xFF1b1a17);
  final Color primaryColor = Color(0xff1b1a17);
  final Color accentColor = Color(0xff1b1a17);
}

class _Dimens {
  final double radiusBorderValue = 20.0;
  final double activeTabIconSize = 30.0;
  final double activeTabTextSize = 18.0;
}
