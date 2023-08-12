import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmDialog extends StatefulWidget {
  final String? title;
  final String message;

  const ConfirmDialog({Key? key, this.title, required this.message}) : super(key: key);

  static Future<bool> show({required BuildContext context, String? title, required String message}) async {
    return await showDialog<bool?>(
          context: context,
          builder: (_) => ConfirmDialog(title: title, message: message),
        ) ??
        false;
  }

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> with ThemeContext {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title != null ? Text(widget.title ?? '') : null,
      content: Padding(
        padding: widget.title != null ? EdgeInsets.zero : const EdgeInsets.only(top: 16),
        child: Text(widget.message),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(strings.cancel),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          child: Text(strings.confirm),
        ),
      ],
    );
  }
}
