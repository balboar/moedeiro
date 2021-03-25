import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(BuildContext context, double amount) {
  Locale locale = Localizations.localeOf(context);
  var format = NumberFormat.simpleCurrency(locale: locale.toString());
  return format.format(amount);
}

String formatHiddenCurrency(BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  var format = NumberFormat.simpleCurrency(locale: locale.toString());
  return '${format.positivePrefix}*****${format.positiveSuffix}';
}

class LanguageValue {
  final String key;
  final String value;
  LanguageValue(this.key, this.value);
}

List<LanguageValue> languageOptions = [
  LanguageValue('default', 'Usar idioma del sistema'),
  LanguageValue('en', 'English'),
  LanguageValue('es', 'Español')
];

class AppThemeValue {
  final String key;
  final String value;
  AppThemeValue(this.key, this.value);
}

List<AppThemeValue> themeOptions = [
  AppThemeValue('default', 'Usar tema del sistema'),
  AppThemeValue('light', 'Light'),
  AppThemeValue('dark', 'Dark')
];
