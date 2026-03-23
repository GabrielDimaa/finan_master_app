import 'package:finan_master_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class ActionsTransactionDetailsSheet extends StatelessWidget {
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final List<Widget> children;

  const ActionsTransactionDetailsSheet({super.key, required this.onEditPressed, required this.onDeletePressed, this.children = const []});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filledTonal(
          tooltip: AppLocalizations.of(context)!.edit,
          icon: const Icon(Icons.edit_outlined),
          style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.surfaceDim),
          onPressed: onEditPressed,
        ),
        IconButton.filledTonal(
          tooltip: AppLocalizations.of(context)!.delete,
          icon: const Icon(Icons.delete_outlined),
          style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.surfaceDim),
          onPressed: onDeletePressed,
        ),
        ...children
      ],
    );
  }
}
