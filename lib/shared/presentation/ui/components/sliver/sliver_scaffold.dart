import 'package:flutter/material.dart';

class SliverScaffold extends StatefulWidget {
  final Widget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const SliverScaffold({
    Key? key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.drawer,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  State<SliverScaffold> createState() => _SliverScaffoldState();
}

class _SliverScaffoldState extends State<SliverScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      drawer: widget.drawer,
      floatingActionButton: widget.floatingActionButton,
      body: CustomScrollView(
        slivers: [
          SliverVisibility(
            visible: widget.appBar != null,
            sliver: widget.appBar ?? const SizedBox(),
          ),
          SliverToBoxAdapter(child: widget.body),
        ],
      ),
    );
  }
}
