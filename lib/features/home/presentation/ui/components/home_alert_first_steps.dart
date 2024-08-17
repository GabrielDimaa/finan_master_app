import 'package:finan_master_app/features/first_steps/presentation/notifiers/first_steps_notifier.dart';
import 'package:finan_master_app/features/first_steps/presentation/ui/first_steps_page.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeAlertFirstSteps extends StatefulWidget {
  final FirstStepsNotifier notifier;

  const HomeAlertFirstSteps({super.key, required this.notifier});

  @override
  State<HomeAlertFirstSteps> createState() => _HomeAlertFirstStepsState();
}

class _HomeAlertFirstStepsState extends State<HomeAlertFirstSteps> with ThemeContext {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.notifier,
      builder: (_, __, ___) {
        if (widget.notifier.value.done) return const SizedBox.shrink();

        return InkWell(
          onTap: goFirstSteps,
          child: Ink(
            color: colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.verified_outlined, color: colorScheme.onPrimary),
                  const Spacing.x(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(strings.firstSteps, style: textTheme.titleSmall?.copyWith(color: colorScheme.onPrimary)),
                        Text('${(widget.notifier.value.totalStepsDone() / widget.notifier.value.totalSteps() * 100).round()}% ${strings.completed.toLowerCase()}', style: textTheme.bodySmall?.copyWith(color: colorScheme.onPrimary)),
                      ],
                    ),
                  ),
                  const Spacing.x(),
                  Text(strings.see, style: textTheme.titleSmall?.copyWith(color: colorScheme.onPrimary)),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  void goFirstSteps() => context.pushNamed(FirstStepsPage.route, extra: false);
}
