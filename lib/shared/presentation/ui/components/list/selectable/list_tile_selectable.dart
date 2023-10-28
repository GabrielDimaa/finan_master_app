import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/list_view_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/mode_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/item_selectable.dart';
import 'package:flutter/material.dart';

class ListTileSelectable extends StatelessWidget {
  final ItemSelectable value;

  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ListTileSelectable({
    Key? key,
    required this.value,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ModeSelectable? modeSelection = ModeSelectable.of(context);
    final ListViewModeSelection? listViewModeSelection = ListViewModeSelection.of(context);

    return ListTile(
      leading: value.selected ? const CircleAvatar(child: Icon(Icons.check_outlined)) : leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: modeSelection?.active == true ? () => update(context) : onTap,
      onLongPress: listViewModeSelection != null ? () => update(context) : null,
    );
  }

  void update(BuildContext context) {
    value.selected = !value.selected;
    ListViewModeSelection.of(context)?.update();
  }
}
