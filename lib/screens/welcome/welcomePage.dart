import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter/material.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/models/settings.dart';
import 'package:moedeiro/screens/accounts/components/AccountsBottomSheetWidget.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    // _successText = S.of(context).createAccountText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      CoolStep(
        title: '',
        subtitle: '',
        isHeaderEnabled: false,
        content: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
            ),
            Text(
              S.of(context).allSet,
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              S.of(context).setUpMoedeiro,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        validation: () {
          return null;
        },
      ),
      CoolStep(
        title: '',
        isHeaderEnabled: false,
        subtitle: '',
        content: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            Text(
              S.of(context).createAccountText,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 100,
            ),
            Center(
              child: TextButton.icon(
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
                icon: Icon(Icons.account_balance),
                label: Text(_accountCreated
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
                  '🤗',
                  style: TextStyle(fontSize: 50),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  S.of(context).allSet,
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
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
