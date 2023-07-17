import 'package:flutter/material.dart';

mixin ThemePage<T extends StatefulWidget> on State<T> {
  ThemeData get theme => Theme.of(context);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;
}
