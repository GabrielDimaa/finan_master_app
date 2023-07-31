import 'package:flutter/material.dart';

class LinearProgressIndicatorAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LinearProgressIndicatorAppBar({super.key});

  @override
  Widget build(BuildContext context) => const LinearProgressIndicator();

  @override
  Size get preferredSize => const Size(double.infinity, 1);
}
