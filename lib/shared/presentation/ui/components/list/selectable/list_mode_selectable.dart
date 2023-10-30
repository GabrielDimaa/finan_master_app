import 'package:flutter/material.dart';

class ListModeSelectable extends InheritedWidget {
  final List list;
  final void Function(List) updateList;

  const ListModeSelectable({super.key, required this.list, required this.updateList, required super.child});

  bool get active => list.isNotEmpty;

  @override
  bool updateShouldNotify(ListModeSelectable oldWidget) => true;

  static ListModeSelectable? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<ListModeSelectable>();
}
