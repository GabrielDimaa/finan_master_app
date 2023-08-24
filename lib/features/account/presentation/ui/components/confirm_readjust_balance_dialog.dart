import 'package:finan_master_app/features/account/domain/enums/adjustment_option_enum.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmReadjustBalanceDialog extends StatefulWidget {
  final double value;
  final ReadjustmentOptionEnum option;

  const ConfirmReadjustBalanceDialog({Key? key, required this.value, required this.option}) : super(key: key);

  static Future<bool> show({required BuildContext context, required double value, required ReadjustmentOptionEnum option}) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmReadjustBalanceDialog(value: value, option: option),
    ) ?? false;
  }

  @override
  State<ConfirmReadjustBalanceDialog> createState() => _ConfirmReadjustBalanceDialogState();
}

class _ConfirmReadjustBalanceDialogState extends State<ConfirmReadjustBalanceDialog> with ThemeContext {
  String get message => widget.option == ReadjustmentOptionEnum.changeInitialValue ? strings.changeInitialValueConfirmation : strings.createTransactionConfirmation;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.priority_high_outlined),
      title: Text(widget.value.money),
      content: Text(message, textAlign: TextAlign.center),
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
