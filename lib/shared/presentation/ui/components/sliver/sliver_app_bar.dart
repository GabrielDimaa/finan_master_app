import 'package:finan_master_app/shared/presentation/ui/components/linear_progress_indicator_app_bar.dart';
import 'package:flutter/material.dart';

class SliverAppBarMedium extends StatelessWidget {
  final Widget title;
  final bool? centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool? loading;

  const SliverAppBarMedium({
    super.key,
    required this.title,
    this.centerTitle,
    this.actions,
    this.leading,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.medium(
      title: title,
      centerTitle: centerTitle,
      actions: [
        ...?actions,
        const Padding(padding: EdgeInsets.only(right: 8)),
      ],
      leading: leading ?? const BackButton(),
      scrolledUnderElevation: 0,
      bottom: loading == true ? const LinearProgressIndicatorAppBar() : null,
    );
  }
}
