import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/item_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/list_mode_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/list_view_selectable.dart';
import 'package:flutter/material.dart';

class ListTileSelectable<T> extends StatelessWidget {
  final ItemSelectable<T> value;

  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;

  const ListTileSelectable({
    Key? key,
    required this.value,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ListModeSelectable? modeSelection = ListModeSelectable.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final ListViewModeSelection? listViewModeSelection = ListViewModeSelection.of(context);

    return ListTile(
      leading: value.selected
          ? CircleAvatar(
              backgroundColor: colorScheme.primary,
              child: Icon(
                Icons.check_outlined,
                color: colorScheme.onPrimary,
              ),
            )
          : leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      tileColor: value.selected ? colorScheme.secondaryContainer : null,
      onTap: modeSelection?.active == true ? () => update(context) : onTap,
      onLongPress: listViewModeSelection != null ? () => update(context) : null,
      contentPadding: contentPadding,
    );
  }

  void update(BuildContext context) {
    value.selected = !value.selected;
    ListViewModeSelection.of(context)?.update();
  }
}
