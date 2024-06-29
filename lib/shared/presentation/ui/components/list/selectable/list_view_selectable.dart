import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/item_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/list_mode_selectable.dart';
import 'package:flutter/material.dart';

class ListViewSelectable<T> extends StatefulWidget {
  final List<T> list;
  final Widget Function(ItemSelectable<T>) itemBuilder;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsets? padding;

  final bool separated;

  const ListViewSelectable.builder({super.key, required this.list, required this.itemBuilder, this.physics, this.shrinkWrap = false, this.padding}) : separated = false;

  const ListViewSelectable.separated({super.key, required this.list, required this.itemBuilder, this.physics, this.shrinkWrap = false, this.padding}) : separated = true;

  @override
  State<ListViewSelectable<T>> createState() => _ListViewSelectableState<T>();
}

class _ListViewSelectableState<T> extends State<ListViewSelectable<T>> {
  late List<ItemSelectable<T>> listSelectable;

  @override
  void initState() {
    super.initState();
    listSelectable = widget.list.map((e) => ItemSelectable(value: e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListViewModeSelection(
      update: () => ListModeSelectable.of(context)?.updateList(listSelectable.where((e) => e.selected).map((e) => e.value).toList()),
      child: Builder(
        builder: (_) {
          if (ListModeSelectable.of(context)?.active != true) {
            for (var e in listSelectable) {
              e.selected = false;
            }
          }

          if (widget.separated) {
            return ListView.separated(
              physics: widget.physics,
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              itemCount: listSelectable.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) => widget.itemBuilder(listSelectable[index]),
            );
          }

          return ListView.builder(
            physics: widget.physics,
            shrinkWrap: widget.shrinkWrap,
            padding: widget.padding,
            itemCount: listSelectable.length,
            itemBuilder: (_, index) => widget.itemBuilder(listSelectable[index]),
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
