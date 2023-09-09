import 'package:flutter/material.dart';

class ExpandableFabChild {
  final Widget? label;
  final Widget icon;
  final VoidCallback? onPressed;

  const ExpandableFabChild({this.label, required this.icon, this.onPressed});
}
