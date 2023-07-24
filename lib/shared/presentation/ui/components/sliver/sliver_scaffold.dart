import 'package:flutter/material.dart';

class SliverScaffold extends StatelessWidget {
  final Widget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? drawer;

  const SliverScaffold({
    Key? key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.drawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      body: CustomScrollView(
        slivers: [
          SliverVisibility(
            visible: appBar != null,
            sliver: appBar ?? const SizedBox(),
          ),
          SliverToBoxAdapter(
            child: body,
          ),
        ],
      ),
    );
  }
}
