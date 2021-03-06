import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/models/settings.dart';
import 'package:provider/provider.dart';

String formatCurrency(BuildContext context, double amount) {
  var _discreetMode =
      Provider.of<SettingsModel>(context, listen: false).discreetMode;
  if (_discreetMode)
    return _formatHiddenCurrency(context);
  else
    return _formatVisibleCurrency(context, amount);
}

String _formatVisibleCurrency(BuildContext context, double amount) {
  Locale locale = Localizations.localeOf(context);
  var format = NumberFormat.simpleCurrency(locale: locale.toString());
  return format.format(amount);
}

String _formatHiddenCurrency(BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  var format = NumberFormat.simpleCurrency(locale: locale.toString());
  return '${format.positivePrefix}*****${format.positiveSuffix}';
}

String getLocaleLabel(BuildContext context, String locale) {
  if (locale == 'system') {
    return S.of(context).systemDefaultTitle;
  } else {
    var activeLocale =
        languageOptions.firstWhere((element) => element.key == locale);
    return activeLocale.value;
  }
}

class LanguageValue {
  final String key;
  final String value;
  LanguageValue(this.key, this.value);
}

List<LanguageValue> languageOptions = [
  LanguageValue('system', 'Usar idioma del sistema'),
  LanguageValue('en', 'English'),
  LanguageValue('es', 'Español')
];

class AppThemeValue {
  final String key;
  final String value;
  AppThemeValue(this.key, this.value);
}

List<AppThemeValue> themeOptionsEng = [
  AppThemeValue('system', 'System default'),
  AppThemeValue('light', 'Light'),
  AppThemeValue('dark', 'Dark')
];

List<AppThemeValue> themeOptionsEsp = [
  AppThemeValue('system', 'Usar tema del sistema'),
  AppThemeValue('light', 'Claro'),
  AppThemeValue('dark', 'Oscuro')
];

List<AppThemeValue> themeOptions(
  BuildContext context,
) {
  Locale locale = Localizations.localeOf(context);
  switch (locale.languageCode) {
    case 'es':
      return themeOptionsEsp;

    default:
      return themeOptionsEng;
  }
}
