import 'dart:ui';

extension LocaleExtension on Locale {
  String getDisplayLanguage() {
    return switch (toString()) {
      'en' => 'English',
      'pt' => 'Português',
      _ => throw Exception('Locale not found'),
    };
  }
}
