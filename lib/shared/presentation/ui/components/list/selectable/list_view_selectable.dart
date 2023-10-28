import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/list_tile_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/mode_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/item_selectable.dart';
import 'package:flutter/material.dart';

class ListViewSelectable<T> extends StatelessWidget {
  final List<ItemSelectable<T>> list;
  final ListTileSelectable Function(ItemSelectable<T>) itemBuilder;

  final ScrollPhysics? physics;
  final bool shrinkWrap;

  final bool separated;

  const ListViewSelectable.builder({super.key, required this.list, required this.itemBuilder, this.physics, this.shrinkWrap = false}) : separated = false;

  const ListViewSelectable.separated({super.key, required this.list, required this.itemBuilder, this.physics, this.shrinkWrap = false}) : separated = true;

  @override
  Widget build(BuildContext context) {
    return ListViewModeSelection(
      update: () => ModeSelectable.of(context)?.update(list.where((e) => e.selected).length),
      child: Builder(
        builder: (_) {
          if (ModeSelectable.of(context)?.active != true) {
            for (var e in list) {
              e.selected = false;
            }
          }

          if (separated) {
            return ListView.separated(
              physics: physics,
              shrinkWrap: shrinkWrap,
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) => itemBuilder(list[index]),
            );
          }

          return ListView.builder(
            physics: physics,
            shrinkWrap: shrinkWrap,
            itemCount: list.length,
            itemBuilder: (_, index) => itemBuilder(list[index]),
          );
        },
      ),
    );
  }
}

class ListViewModeSelection extends InheritedWidget {
  final void Function() update;

  const ListViewModeSelection({super.key, required this.update, required super.child});

  @override
  bool updateShouldNotify(ListViewModeSelection oldWidget) => true;

  static ListViewModeSelection? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<ListViewModeSelection>();
}
