import 'package:finan_master_app/shared/presentation/ui/components/fab/expandable_fab_child.dart';
import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  final List<ExpandableFabChild> children;
  final bool initialOpen;
  final Widget? iconOpen;
  final Widget? iconClose;

  const ExpandableFab({
    Key? key,
    required this.children,
    this.initialOpen = false,
    this.iconOpen,
    this.iconClose,
  }) : super(key: key);

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> expandAnimation;

  bool open = false;

  ///[40] - FAB small size.
  ///[16] - Gap between FAB.
  static const double spacing = 40 + 16;
  static const double spacingInitial = 80;

  @override
  void initState() {
    super.initState();
    open = widget.initialOpen;

    controller = AnimationController(value: open ? 1.0 : 0.0, duration: const Duration(milliseconds: 250), vsync: this);
    expandAnimation = CurvedAnimation(curve: Curves.fastOutSlowIn, reverseCurve: Curves.easeOutQuad, parent: controller);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _CloseFab(
            open: open,
            child: FloatingActionButton(
              onPressed: toggle,
              child: widget.iconClose ?? const Icon(Icons.close_outlined),
            ),
          ),
          ...buildExpandingActionButtons(),
          _OpenFab(
            open: open,
            child: FloatingActionButton(
              onPressed: toggle,
              child: widget.iconOpen,
            ),
          ),
        ],
      ),
    );
  }

  Widget fabSmall(int index) {
    return AnimatedBuilder(
      animation: expandAnimation,
      builder: (_, child) {
        final offset = Offset(0, (spacingInitial + (spacing * index)) * expandAnimation.value);
        return Positioned(
          right: 8.0,
          bottom: offset.dy,
          child: child!,
        );
      },
      child: FadeTransition(
        opacity: expandAnimation,
        child: widget.children[0],
      ),
    );
  }

  List<Widget> buildExpandingActionButtons() {
    final children = <Widget>[];

    for (int index = 0; index < widget.children.length; index++) {
      children.add(fabSmall(index));
    }

    return children;
  }

  void toggle() {
    setState(() {
      open = !open;
      open ? controller.forward() : controller.reverse();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _OpenFab extends StatelessWidget {
  final bool open;
  final Widget child;

  const _OpenFab({Key? key, required this.open, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(open ? 0.7 : 1, open ? 0.7 : 1, 1),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: open ? 0 : 1,
          curve: const Interval(0.25, 1, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: child,
        ),
      ),
    );
  }
}

class _CloseFab extends StatelessWidget {
  final bool open;
  final Widget child;

  const _CloseFab({Key? key, required this.open, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transformAlignment: Alignment.center,
      transform: Matrix4.diagonal3Values(open ? 1 : 0.7, open ? 1 : 0.7, 1),
      duration: const Duration(milliseconds: 250),
      curve: const Interval(0, 0.5, curve: Curves.easeOut),
      child: AnimatedOpacity(
        opacity: open ? 1 : 0,
        curve: const Interval(0.25, 1, curve: Curves.easeInOut),
        duration: const Duration(milliseconds: 250),
        child: child,
      ),
    );
  }
}
