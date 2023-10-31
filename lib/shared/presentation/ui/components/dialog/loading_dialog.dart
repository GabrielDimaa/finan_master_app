import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingDialog extends StatelessWidget {
  final BuildContext context;
  final String message;

  const LoadingDialog({
    Key? key,
    required this.context,
    required this.message,
  }) : super(key: key);

  static Future<void> show({
    required BuildContext context,
    required String message,
    required Function onAction,
  }) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(context: context, message: message),
      );

      await onAction.call();
    } finally {
      if (context.mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const Spacing.y(2),
          Text(message),
        ],
      ),
    );
  }
}