import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(BuildContext context, double amount) {
  Locale locale = Localizations.localeOf(context);
  var format = NumberFormat.simpleCurrency(locale: locale.toString());
  return format.format(amount);
}
