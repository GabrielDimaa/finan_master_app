import 'package:flutter/material.dart';

class SliverAppBarSmall extends SliverAppBar {
  const SliverAppBarSmall({super.key, super.title, super.centerTitle, super.actions, super.leading = const BackButton()}) : super(scrolledUnderElevation: 0);
}

class SliverAppBarMedium extends StatelessWidget {
  final Widget title;
  final bool? centerTitle;
  final List<Widget>? actions;
  final Widget? leading;

  const SliverAppBarMedium({super.key, required this.title, this.centerTitle, this.actions, this.leading});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.medium(
      title: title,
      centerTitle: centerTitle,
      actions: actions,
      leading: leading ?? const BackButton(),
      scrolledUnderElevation: 0,
    );
  }
}

class SliverAppBarLarge extends StatelessWidget {
  final Widget title;
  final bool? centerTitle;
  final List<Widget>? actions;
  final Widget? leading;

  const SliverAppBarLarge({super.key, required this.title, this.centerTitle, this.actions, this.leading});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.large(
      title: title,
      centerTitle: centerTitle,
      actions: actions,
      leading: leading ?? const BackButton(),
      scrolledUnderElevation: 0,
    );
  }
}
