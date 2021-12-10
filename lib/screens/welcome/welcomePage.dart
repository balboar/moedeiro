import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter/material.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/database/database.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/models/settings.dart';
import 'package:moedeiro/screens/accounts/components/AccountsBottomSheetWidget.dart';
import 'package:moedeiro/screens/settings/components/languageSelectionDialog.dart';
import 'package:moedeiro/util/countries.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:moedeiro/generated/l10n.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({
    Key? key,
  }) : super(key: key);

  final String? title = 'aaaa';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedRole = 'Writer';
  String _errorText = '';
  String _successText = '';
  bool _accountCreated = false;

  String _localeLabel = '';

  String _localeString = '';

  @override
  void initState() {
    // _successText = S.of(context).createAccountText;
    _localeString = 'system';
    super.initState();
  }

  Future<bool?> _showLanguageDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return LanguageSelectionDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _localeLabel = getLocaleLabel(context, _localeString);
    final steps = [
      CoolStep(
        title: '',
        isHeaderEnabled: false,
        subtitle: '',
        content: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              S.of(context).allSet,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              S.of(context).createAccountText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 100,
            ),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  primary: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onSurface: Colors.grey,
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 30,
                  ),
                ),
                onPressed: () {
                  showCustomModalBottomSheet(context, AccountBottomSheet(null),
                          enableDrag: false)
                      .then((value) {
                    _accountCreated = value ?? false;
                    if (!_accountCreated)
                      setState(() {
                        _errorText = S.of(context).createAccountError;
                      });
                    else
                      setState(() {
                        _errorText = '';
                        _successText = S.of(context).createAccountSuccess;
                      });
                  });
                },
                child: Text(_accountCreated
                    ? S.of(context).createAccountSuccess
                    : S.of(context).createAccountText),
              ),
            ),
          ],
        ),
        validation: () {
          if (!_accountCreated) {
            setState(() {
              _errorText = S.of(context).createAccountError;
            });
            return _errorText;
          } else {
            return null;
          }
        },
      ),
      CoolStep(
        title: '',
        isHeaderEnabled: false,
        subtitle: '',
        content: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Center(
                child: Icon(
              Icons.language,
              size: 40,
            )),
            Center(
              child: Text(
                S.of(context).selectLanguage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  primary: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onSurface: Colors.grey,
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 30,
                  ),
                ),
                onPressed: () async {
                  await _showLanguageDialog();
                  _localeString =
                      Provider.of<SettingsModel>(context, listen: false)
                          .localeString;
                  setState(() {
                    _localeLabel = getLocaleLabel(context, _localeString);
                  });
                },
                child: Text(S.of(context).language),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                _localeLabel,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
        validation: () {
          return null;
        },
      ),
      // CoolStep(
      //   title: '',
      //   isHeaderEnabled: false,
      //   subtitle: '',
      //   content: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       SizedBox(
      //         height: 100,
      //       ),
      //       Center(
      //         child: Text(
      //           '🗺️',
      //           style: TextStyle(fontSize: 50),
      //         ),
      //       ),
      //       Center(
      //         child: Text(
      //           S.of(context).selectCountry,
      //           textAlign: TextAlign.center,
      //           style: Theme.of(context).textTheme.headline4,
      //         ),
      //       ),
      //       SizedBox(
      //         height: 15,
      //       ),
      //       Text(
      //         S.of(context).selectCountryDisclaimer,
      //         textAlign: TextAlign.center,
      //         style: Theme.of(context).textTheme.bodyText2,
      //       ),
      //       SizedBox(
      //         height: 75,
      //       ),
      //       Center(
      //         child: TextButton(
      //           style: TextButton.styleFrom(
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(20.0),
      //             ),
      //             primary: Colors.white,
      //             backgroundColor: Theme.of(context).colorScheme.secondary,
      //             onSurface: Colors.grey,
      //             padding: EdgeInsets.symmetric(
      //               vertical: 12,
      //               horizontal: 30,
      //             ),
      //           ),
      //           onPressed: () async {
      //             await _showLanguageDialog();
      //             _localeString =
      //                 Provider.of<SettingsModel>(context, listen: false)
      //                     .localeString;
      //             setState(() {
      //               _localeLabel = getLocaleLabel(context, _localeString);
      //             });
      //           },
      //           child: Text(S.of(context).selectCountry),
      //         ),
      //       ),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       Center(
      //         child: Text(
      //           _localeLabel,
      //           textAlign: TextAlign.center,
      //           style: Theme.of(context).textTheme.bodyText2,
      //         ),
      //       ),
      //       // Container(
      //       //   height: MediaQuery.of(context).size.height - 400,
      //       //   child: ListView.builder(
      //       //     //     primary: true,
      //       //     shrinkWrap: true,
      //       //     itemBuilder: (context, index) {
      //       //       return ListTile(
      //       //         title: Text(countryList[index].name),
      //       //       );
      //       //     },
      //       //     itemCount: countryList.length,
      //       //     itemExtent: 40,
      //       //   ),
      //       // ),
      //     ],
      //   ),
      //   validation: () {
      //     return null;
      //   },
      // ),
      CoolStep(
        title: '',
        subtitle: '',
        isHeaderEnabled: false,
        content: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 150,
              ),
              Center(
                child: Text(
                  '👋',
                  style: TextStyle(fontSize: 50),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  S.of(context).allSet,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ],
          ),
        ),
        validation: () {
          return null;
        },
      ),
    ];

    final stepper = CoolStepper(
      showErrorSnackbar: true,
      onCompleted: () {
        if (_localeString == 'system') {
          Locale myLocale = Localizations.localeOf(context);
          _localeString = myLocale.languageCode;
        }
        switch (_localeString) {
          case 'en':
            DB.createCategoriesEnglish();
            break;
          case 'es':
            DB.createCategoriesSpanish();
            break;
          default:
        }
        Provider.of<SettingsModel>(context, listen: false).firstTime = false;
        Navigator.pushReplacementNamed(
          context,
          '/',
        );
      },
      steps: steps,
      config: CoolStepperConfig(
        finalText: S.of(context).finishText,
        stepText: S.of(context).step,
        ofText: S.of(context).ofText,
        nextText: S.of(context).next,
        backText: S.of(context).prev,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: stepper,
      ),
    );
  }
}
