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
  Widget build(BuildContext context) {
    final steps = [
      CoolStep(
        title: '',
        isHeaderEnabled: false,
        subtitle: '',
        content: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Text(
              S.of(context).setUpMoedeiro,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 120,
            ),
            Center(
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Theme.of(context).accentColor,
                  onSurface: Colors.grey,
                  padding: EdgeInsets.symmetric(
                    vertical: 5,
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
                label: Text(S.of(context).createAccountText),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              _errorText,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            Text(
              _successText,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        validation: () {
          if (!_accountCreated) {
            setState(() {
              _errorText = S.of(context).createAccountError;
            });
            return 'Error';
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
                height: 60,
              ),
              Center(
                child: Text(
                  S.of(context).allSet,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Image(
                height: 250,
                image: AssetImage('lib/assets/icons/successBlack.png'),
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
      showErrorSnackbar: false,
      onCompleted: () {
        Provider.of<SettingsModel>(context, listen: false).firstTime = false;
        Navigator.pushNamed(
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
      body: Container(
        child: stepper,
      ),
    );
  }
}
