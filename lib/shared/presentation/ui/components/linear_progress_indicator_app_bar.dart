import 'package:flutter/material.dart';

class LinearProgressIndicatorAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool show;

  const LinearProgressIndicatorAppBar({super.key, this.show = true});

  @override
  Size get preferredSize => const Size(double.infinity, 4);

  @override
  Widget build(BuildContext context) => show ? const LinearProgressIndicator(minHeight: 4) : const SizedBox.shrink();
}
