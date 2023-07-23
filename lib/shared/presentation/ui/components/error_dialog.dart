import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorDialog extends StatefulWidget {
  final String message;

  const ErrorDialog({Key? key, required this.message}) : super(key: key);

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();

  static Future<void> show(BuildContext context, String mensagem) async {
    await showDialog(context: context, builder: (context) => ErrorDialog(message: mensagem));
  }
}

class _ErrorDialogState extends State<ErrorDialog> with ThemeContext {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ops'),
      content: Text(widget.message.replaceAll('Exception:', '').trim()),
      actions: [
        TextButton(
          onPressed: context.pop,
          child: Text(strings.close),
        ),
      ],
    );
  }
}
