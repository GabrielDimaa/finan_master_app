import 'package:flutter/material.dart';

class LabelValueTransactionDetailsSheet extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment crossAxisAlignment;

  const LabelValueTransactionDetailsSheet({super.key, required this.label, required this.value, this.crossAxisAlignment = CrossAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }
}
