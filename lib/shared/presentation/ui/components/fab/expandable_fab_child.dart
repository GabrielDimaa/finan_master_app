import 'package:flutter/material.dart';

class ExpandableFabChild extends StatelessWidget {
  final Widget? label;
  final Widget icon;
  final VoidCallback? onPressed;

  const ExpandableFabChild({super.key, this.label, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        label ?? const SizedBox(),
        FloatingActionButton.small(
          onPressed: onPressed,
          child: icon,
        ),
      ],
    );
  }
}
