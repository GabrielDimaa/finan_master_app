import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/linear_progress_indicator_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/list_mode_selectable.dart';
import 'package:flutter/material.dart';

class AppBarCustom extends StatefulWidget implements PreferredSizeWidget {
  final Widget title;
  final bool? centerTitle;
  final List<Widget>? actions;
  final List<Widget>? actionsInModeSelection;
  final Widget? leading;
  final bool? loading;

  const AppBarCustom({
    Key? key,
    required this.title,
    this.centerTitle,
    this.actions,
    this.actionsInModeSelection,
    this.leading,
    this.loading,
  }) : super(key: key);

  @override
  State<AppBarCustom> createState() => _AppBarCustomState();

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class _AppBarCustomState extends State<AppBarCustom> with ThemeContext {
  bool animated = false;

  @override
  Widget build(BuildContext context) {
    final ListModeSelectable? modeSelectable = ListModeSelectable.of(context);

    if (modeSelectable?.active == true) {
      return AppBar(
        title: Text(strings.nSelected(modeSelectable?.list.length ?? 0)),
        actions: [
          ...?widget.actionsInModeSelection,
          const Padding(padding: EdgeInsets.only(right: 8)),
        ],
        leading: IconButton(
          onPressed: () => modeSelectable?.updateList([]),
          icon: Builder(
            builder: (context) {
              if (!animated) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  setState(() => animated = true);
                });
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: animated ? Tween<double>(begin: 1, end: 0.75).animate(anim) : Tween<double>(begin: 0.75, end: 1).animate(anim),
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: animated ? const Icon(Icons.close) : const SizedBox(width: 24),
              );
            },
          ),
        ),
      );
    } else {
      animated = false;

      return AppBar(
        title: widget.title,
        centerTitle: widget.centerTitle,
        actions: [
          ...?widget.actions,
          const Padding(padding: EdgeInsets.only(right: 8)),
        ],
        leading: widget.leading ?? const BackButton(),
        bottom: widget.loading == true ? const LinearProgressIndicatorAppBar() : null,
      );
    }
  }
}
