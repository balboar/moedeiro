// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Moedeiro`
  String get appTitle {
    return Intl.message(
      'Moedeiro',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Accounts`
  String get accountsTitle {
    return Intl.message(
      'Accounts',
      name: 'accountsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get categoryTitle {
    return Intl.message(
      'Category',
      name: 'categoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Budget`
  String get budgetsTitle {
    return Intl.message(
      'Budget',
      name: 'budgetsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Movements`
  String get movementsTitle {
    return Intl.message(
      'Movements',
      name: 'movementsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Recent transactions`
  String get transactionsTitle {
    return Intl.message(
      'Recent transactions',
      name: 'transactionsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Use system default`
  String get systemDefaultTitle {
    return Intl.message(
      'Use system default',
      name: 'systemDefaultTitle',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get noDataLabel {
    return Intl.message(
      'No data',
      name: 'noDataLabel',
      desc: '',
      args: [],
    );
  }

  /// `Transaction`
  String get transaction {
    return Intl.message(
      'Transaction',
      name: 'transaction',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get transfer {
    return Intl.message(
      'Transfer',
      name: 'transfer',
      desc: '',
      args: [],
    );
  }

  /// `Transactions`
  String get transactions {
    return Intl.message(
      'Transactions',
      name: 'transactions',
      desc: '',
      args: [],
    );
  }

  /// `Transfers`
  String get transfers {
    return Intl.message(
      'Transfers',
      name: 'transfers',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Amount should be greater than 0`
  String get amountError {
    return Intl.message(
      'Amount should be greater than 0',
      name: 'amountError',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `Select an account`
  String get accountSelectError {
    return Intl.message(
      'Select an account',
      name: 'accountSelectError',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Incomes`
  String get incomes {
    return Intl.message(
      'Incomes',
      name: 'incomes',
      desc: '',
      args: [],
    );
  }

  /// `Expenses`
  String get expenses {
    return Intl.message(
      'Expenses',
      name: 'expenses',
      desc: '',
      args: [],
    );
  }

  /// `Income`
  String get income {
    return Intl.message(
      'Income',
      name: 'income',
      desc: '',
      args: [],
    );
  }

  /// `Expense`
  String get expense {
    return Intl.message(
      'Expense',
      name: 'expense',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Security`
  String get security {
    return Intl.message(
      'Security',
      name: 'security',
      desc: '',
      args: [],
    );
  }

  /// `Use fingerprint`
  String get useFingerprint {
    return Intl.message(
      'Use fingerprint',
      name: 'useFingerprint',
      desc: '',
      args: [],
    );
  }

  /// `Lock app in background`
  String get lockAppInBackGround {
    return Intl.message(
      'Lock app in background',
      name: 'lockAppInBackGround',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Data`
  String get data {
    return Intl.message(
      'Data',
      name: 'data',
      desc: '',
      args: [],
    );
  }

  /// `Import from CSV`
  String get importCSV {
    return Intl.message(
      'Import from CSV',
      name: 'importCSV',
      desc: '',
      args: [],
    );
  }

  /// `Import database`
  String get importDb {
    return Intl.message(
      'Import database',
      name: 'importDb',
      desc: '',
      args: [],
    );
  }

  /// `Export database`
  String get exportDb {
    return Intl.message(
      'Export database',
      name: 'exportDb',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Common`
  String get common {
    return Intl.message(
      'Common',
      name: 'common',
      desc: '',
      args: [],
    );
  }

  /// `Delete account?`
  String get deleteAccount {
    return Intl.message(
      'Delete account?',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `An account is going to be deleted, are you sure?`
  String get deleteAccountDescription {
    return Intl.message(
      'An account is going to be deleted, are you sure?',
      name: 'deleteAccountDescription',
      desc: '',
      args: [],
    );
  }

  /// `Delete movement?`
  String get deleteMovement {
    return Intl.message(
      'Delete movement?',
      name: 'deleteMovement',
      desc: '',
      args: [],
    );
  }

  /// `A movement is going to be deleted, are you sure?`
  String get deleteMovementDescription {
    return Intl.message(
      'A movement is going to be deleted, are you sure?',
      name: 'deleteMovementDescription',
      desc: '',
      args: [],
    );
  }

  /// `Account name`
  String get accountName {
    return Intl.message(
      'Account name',
      name: 'accountName',
      desc: '',
      args: [],
    );
  }

  /// `Name can not be empty`
  String get nameError {
    return Intl.message(
      'Name can not be empty',
      name: 'nameError',
      desc: '',
      args: [],
    );
  }

  /// `Initial amount`
  String get initialAmount {
    return Intl.message(
      'Initial amount',
      name: 'initialAmount',
      desc: '',
      args: [],
    );
  }

  /// `Amount must be a number`
  String get initialAmountError {
    return Intl.message(
      'Amount must be a number',
      name: 'initialAmountError',
      desc: '',
      args: [],
    );
  }

  /// `Expenses month`
  String get expensesMonth {
    return Intl.message(
      'Expenses month',
      name: 'expensesMonth',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Select a category`
  String get categoryError {
    return Intl.message(
      'Select a category',
      name: 'categoryError',
      desc: '',
      args: [],
    );
  }

  /// `Please authenticate to show data`
  String get authenticateLabel {
    return Intl.message(
      'Please authenticate to show data',
      name: 'authenticateLabel',
      desc: '',
      args: [],
    );
  }

  /// `PIN`
  String get pin {
    return Intl.message(
      'PIN',
      name: 'pin',
      desc: '',
      args: [],
    );
  }

  /// `PIN must be a numeric value`
  String get pinError {
    return Intl.message(
      'PIN must be a numeric value',
      name: 'pinError',
      desc: '',
      args: [],
    );
  }

  /// `PIN can not be empty`
  String get pinEmpty {
    return Intl.message(
      'PIN can not be empty',
      name: 'pinEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Confirm PIN`
  String get confirmPin {
    return Intl.message(
      'Confirm PIN',
      name: 'confirmPin',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message(
      'Balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `PIN must have four numbers`
  String get pinErrorLenght {
    return Intl.message(
      'PIN must have four numbers',
      name: 'pinErrorLenght',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Delete category?`
  String get deleteCategory {
    return Intl.message(
      'Delete category?',
      name: 'deleteCategory',
      desc: '',
      args: [],
    );
  }

  /// `A category is going to be deleted, are you sure?`
  String get deleteCategorytDescription {
    return Intl.message(
      'A category is going to be deleted, are you sure?',
      name: 'deleteCategorytDescription',
      desc: '',
      args: [],
    );
  }

  /// `Can't delete category`
  String get deleteCategoryError {
    return Intl.message(
      'Can\'t delete category',
      name: 'deleteCategoryError',
      desc: '',
      args: [],
    );
  }

  /// `This category has transactions, remove or move those transactions first`
  String get deleteCategorytDescriptionError {
    return Intl.message(
      'This category has transactions, remove or move those transactions first',
      name: 'deleteCategorytDescriptionError',
      desc: '',
      args: [],
    );
  }

  /// `Search..`
  String get search {
    return Intl.message(
      'Search..',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Discreet mode`
  String get discreetMode {
    return Intl.message(
      'Discreet mode',
      name: 'discreetMode',
      desc: '',
      args: [],
    );
  }

  /// `Discreet mode hides the amounts`
  String get discreetModeExplanation {
    return Intl.message(
      'Discreet mode hides the amounts',
      name: 'discreetModeExplanation',
      desc: '',
      args: [],
    );
  }

  /// `Default Account`
  String get defaultAccount {
    return Intl.message(
      'Default Account',
      name: 'defaultAccount',
      desc: '',
      args: [],
    );
  }

  /// `Log in with fingerprint`
  String get lockScreenPrompt {
    return Intl.message(
      'Log in with fingerprint',
      name: 'lockScreenPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Imported, restart Moedeiro`
  String get restartMoedeiro {
    return Intl.message(
      'Imported, restart Moedeiro',
      name: 'restartMoedeiro',
      desc: '',
      args: [],
    );
  }

  /// `Exported`
  String get Exported {
    return Intl.message(
      'Exported',
      name: 'Exported',
      desc: '',
      args: [],
    );
  }

  /// `There's been an error`
  String get errorText {
    return Intl.message(
      'There\'s been an error',
      name: 'errorText',
      desc: '',
      args: [],
    );
  }

  /// `Let's set up your first account`
  String get setUpMoedeiro {
    return Intl.message(
      'Let\'s set up your first account',
      name: 'setUpMoedeiro',
      desc: '',
      args: [],
    );
  }

  /// `Let's create your first account`
  String get createAccountText {
    return Intl.message(
      'Let\'s create your first account',
      name: 'createAccountText',
      desc: '',
      args: [],
    );
  }

  /// `It's mandatory to create an account`
  String get createAccountError {
    return Intl.message(
      'It\'s mandatory to create an account',
      name: 'createAccountError',
      desc: '',
      args: [],
    );
  }

  /// `Create another account`
  String get createAccountSuccess {
    return Intl.message(
      'Create another account',
      name: 'createAccountSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Moedeiro`
  String get allSet {
    return Intl.message(
      'Welcome to Moedeiro',
      name: 'allSet',
      desc: '',
      args: [],
    );
  }

  /// `NEXT`
  String get next {
    return Intl.message(
      'NEXT',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `PREV`
  String get prev {
    return Intl.message(
      'PREV',
      name: 'prev',
      desc: '',
      args: [],
    );
  }

  /// `STEP`
  String get step {
    return Intl.message(
      'STEP',
      name: 'step',
      desc: '',
      args: [],
    );
  }

  /// `OF`
  String get ofText {
    return Intl.message(
      'OF',
      name: 'ofText',
      desc: '',
      args: [],
    );
  }

  /// `FINISH`
  String get finishText {
    return Intl.message(
      'FINISH',
      name: 'finishText',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get acceptButtonText {
    return Intl.message(
      'Continue',
      name: 'acceptButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Group by`
  String get groupby {
    return Intl.message(
      'Group by',
      name: 'groupby',
      desc: '',
      args: [],
    );
  }

  /// `Group`
  String get group {
    return Intl.message(
      'Group',
      name: 'group',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get daily {
    return Intl.message(
      'Daily',
      name: 'daily',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get weekly {
    return Intl.message(
      'Weekly',
      name: 'weekly',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get monthly {
    return Intl.message(
      'Monthly',
      name: 'monthly',
      desc: '',
      args: [],
    );
  }

  /// `Yearly`
  String get yearly {
    return Intl.message(
      'Yearly',
      name: 'yearly',
      desc: '',
      args: [],
    );
  }

  /// `Custom range`
  String get customRange {
    return Intl.message(
      'Custom range',
      name: 'customRange',
      desc: '',
      args: [],
    );
  }

  /// `Net income`
  String get netIncome {
    return Intl.message(
      'Net income',
      name: 'netIncome',
      desc: '',
      args: [],
    );
  }

  /// `Can't delete account`
  String get deleteAccountError {
    return Intl.message(
      'Can\'t delete account',
      name: 'deleteAccountError',
      desc: '',
      args: [],
    );
  }

  /// `This account has transactions, remove or move those transactions first`
  String get deleteAccountDescriptionError {
    return Intl.message(
      'This account has transactions, remove or move those transactions first',
      name: 'deleteAccountDescriptionError',
      desc: '',
      args: [],
    );
  }

  /// `Analytics`
  String get analytics {
    return Intl.message(
      'Analytics',
      name: 'analytics',
      desc: '',
      args: [],
    );
  }

  /// `Recurrent transactions`
  String get recurrences {
    return Intl.message(
      'Recurrent transactions',
      name: 'recurrences',
      desc: '',
      args: [],
    );
  }

  /// `every`
  String get every {
    return Intl.message(
      'every',
      name: 'every',
      desc: '',
      args: [],
    );
  }

  /// `Repeat...`
  String get repeat {
    return Intl.message(
      'Repeat...',
      name: 'repeat',
      desc: '',
      args: [],
    );
  }

  /// `Frequency`
  String get frequency {
    return Intl.message(
      'Frequency',
      name: 'frequency',
      desc: '',
      args: [],
    );
  }

  /// `Next event on`
  String get nextEvent {
    return Intl.message(
      'Next event on',
      name: 'nextEvent',
      desc: '',
      args: [],
    );
  }

  /// `on`
  String get on {
    return Intl.message(
      'on',
      name: 'on',
      desc: '',
      args: [],
    );
  }

  /// `Expenses & Analytics`
  String get expensesAndAnalytics {
    return Intl.message(
      'Expenses & Analytics',
      name: 'expensesAndAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Execute now`
  String get executeNow {
    return Intl.message(
      'Execute now',
      name: 'executeNow',
      desc: '',
      args: [],
    );
  }

  /// `Execute`
  String get execute {
    return Intl.message(
      'Execute',
      name: 'execute',
      desc: '',
      args: [],
    );
  }

  /// `Execute transaction?`
  String get executeTransaction {
    return Intl.message(
      'Execute transaction?',
      name: 'executeTransaction',
      desc: '',
      args: [],
    );
  }

  /// `A new transaction is going to be created with today's date`
  String get executeTransactionDescription {
    return Intl.message(
      'A new transaction is going to be created with today\'s date',
      name: 'executeTransactionDescription',
      desc: '',
      args: [],
    );
  }

  /// `Transfer created`
  String get transferCreated {
    return Intl.message(
      'Transfer created',
      name: 'transferCreated',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back`
  String get welcomeBack {
    return Intl.message(
      'Welcome back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Select language for Moedeiro`
  String get selectLanguage {
    return Intl.message(
      'Select language for Moedeiro',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Select your country`
  String get selectCountry {
    return Intl.message(
      'Select your country',
      name: 'selectCountry',
      desc: '',
      args: [],
    );
  }

  /// `This is just for formatting purposes, so Moedeiro can show you your regional formats`
  String get selectCountryDisclaimer {
    return Intl.message(
      'This is just for formatting purposes, so Moedeiro can show you your regional formats',
      name: 'selectCountryDisclaimer',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'messages'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
