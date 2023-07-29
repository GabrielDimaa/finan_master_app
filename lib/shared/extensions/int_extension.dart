import 'package:flutter/widgets.dart';

extension IntExtension on int {
  IconData parseIconData() => IconData(this, fontFamily: 'MaterialIcons');
}
