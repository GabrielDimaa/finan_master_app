import 'package:flutter/material.dart';

typedef DraggableBottomSheetBuilder = Widget Function(ScrollController scrollController);

class DraggableBottomSheet extends StatelessWidget {
  final DraggableBottomSheetBuilder builder;
  final double? initialChildSize;

  const DraggableBottomSheet({Key? key, required this.builder, this.initialChildSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: initialChildSize ?? 0.5,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, ScrollController scrollController) => builder(scrollController),
      ),
    );
  }
}
