import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';

class MessageErrorWidget extends StatelessWidget {
  final String message;

  const MessageErrorWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_outlined, size: 56),
          const Spacing.y(2),
          Text(message.replaceAll('Exception:', '').trim()),
        ],
      ),
    );
  }
}
