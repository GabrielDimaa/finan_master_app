import 'package:flutter/material.dart';

class ModeSelectable extends InheritedWidget {
  final int countSelected;
  final void Function(int) update;

  const ModeSelectable({super.key, required this.countSelected, required this.update, required super.child});

  bool get active => countSelected > 0;

  @override
  bool updateShouldNotify(ModeSelectable oldWidget) => countSelected != oldWidget.countSelected;

  static ModeSelectable? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<ModeSelectable>();
}
