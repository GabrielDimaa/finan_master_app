import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

mixin ThemePage<T extends StatefulWidget> on State<T> {
  ThemeData get theme => Theme.of(context);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  AppLocalizations get strings => AppLocalizations.of(context)!;
}
