import 'package:diacritic/diacritic.dart';
import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/config/presentation/notifiers/locale_notifier.dart';
import 'package:finan_master_app/shared/extensions/locale_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/draggable_bottom_sheet.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class Languages extends StatefulWidget {
  const Languages({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => const Languages(),
    );
  }

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> with ThemeContext {
  final LocaleNotifier notifier = DI.get<LocaleNotifier>();

  final List<Locale> locales = AppLocalizations.supportedLocales.toList()..sort((a, b) => removeDiacritics(a.getDisplayLanguage()).compareTo(removeDiacritics(b.getDisplayLanguage())));

  @override
  Widget build(BuildContext context) {
    return DraggableBottomSheet(
      builder: (scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(strings.languages, style: textTheme.titleMedium),
            ),
            const Spacing.y(1.5),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemCount: locales.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  final Locale locale = locales[index];
                  return RadioListTile<Locale>(
                    title: Text(locale.getDisplayLanguage()),
                    controlAffinity: ListTileControlAffinity.trailing,
                    toggleable: true,
                    value: locale,
                    groupValue: AppLocalizations.of(context)?.localeName == locale.languageCode ? locale : null,
                    onChanged: (_) {
                      notifier.changeAndSave(locale);
                      context.pop(locale);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
