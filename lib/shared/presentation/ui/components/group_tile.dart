import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatelessWidget {
  final String title;
  final Widget tile;
  final VoidCallback? onTap;

  const GroupTile({
    Key? key,
    required this.title,
    required this.tile,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: Spacing.space),
            child: Text(title, style: Theme.of(context).textTheme.bodySmall),
          ),
          tile,
        ],
      ),
    );
  }
}
