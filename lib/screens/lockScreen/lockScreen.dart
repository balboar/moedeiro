import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:moedeiro/models/theme.dart';
import 'package:moedeiro/screens/lockScreen/components/DotSecretUI.dart';
import 'package:moedeiro/screens/lockScreen/components/lockScreenButton.dart';
import 'package:provider/provider.dart';

class LockScreen extends StatefulWidget {
  final String correctString;
  final String title;
  final String confirmTitle;
  final bool confirmMode;
  final Widget rightSideButton;
  final int digits;
  final DotSecretConfig dotSecretConfig;
  final InputButtonConfig circleInputButtonConfig;
  final bool canCancel;
  final String cancelText;
  final String deleteText;
  final Widget biometricButton;
  final void Function(BuildContext, String) onCompleted;
  final bool canBiometric;
  final bool showBiometricFirst;
  @Deprecated('use biometricAuthenticate.')
  final Color backgroundColor;
  final double backgroundColorOpacity;
  final void Function() onUnlocked;

  LockScreen({
    this.correctString,
    this.title = 'Please enter passcode.',
    this.confirmTitle = 'Please enter confirm passcode.',
    this.confirmMode = false,
    this.digits = 4,
    this.dotSecretConfig = const DotSecretConfig(),
    this.circleInputButtonConfig = const InputButtonConfig(),
    this.rightSideButton,
    this.canCancel = true,
    this.cancelText = 'Cancel',
    this.deleteText = 'Delete',
    this.biometricButton = const Icon(Icons.fingerprint),
    this.onCompleted,
    this.canBiometric = true,
    this.showBiometricFirst = true,
    this.backgroundColor = Colors.white,
    this.backgroundColorOpacity = 0.5,
    this.onUnlocked,
  });

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  // receive from circle input button
  final StreamController<String> enteredStream = StreamController<String>();
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final StreamController<void> removedStreamController =
      StreamController<void>();
  final StreamController<int> enteredLengthStream =
      StreamController<int>.broadcast();
  final StreamController<bool> validateStreamController =
      StreamController<bool>();

  // control for Android back button
  bool _needClose = false;

  // confirm flag
  bool _isConfirmation = false;

  // confirm verify passcode
  String _verifyConfirmPasscode = '';

  List<String> enteredValues = <String>[];

  @override
  void initState() {
    super.initState();

    if (widget.showBiometricFirst) {
      _authenticate();
    }
  }

  // Process of authentication user using
  // biometrics.
  Future<void> _authenticate() async {
    if (await _isBiometricAvailable()) {
      await _getListOfBiometricTypes();

      bool isAuthenticated = false;
      try {
        isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
          localizedReason: 'Authenticate to show data',
          stickyAuth: true,
        );
      } on PlatformException catch (e) {
        print(e);
      }

      if (!mounted) return;

      if (isAuthenticated) {
        if (Navigator.canPop(context))
          Navigator.of(context).pop();
        else
          Navigator.pushReplacementNamed(
            context,
            '/',
          );
      }
    }
  }

  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return isAvailable;

    return isAvailable;
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    print(listOfBiometrics);
  }

  void _removedStreamListener() {
    if (removedStreamController.hasListener) {
      return;
    }

    removedStreamController.stream.listen((_) {
      if (enteredValues.isNotEmpty) {
        enteredValues.removeLast();
      }

      enteredLengthStream.add(enteredValues.length);
    });
  }

  void _enteredStreamListener() {
    if (enteredStream.hasListener) {
      return;
    }

    enteredStream.stream.listen((value) {
      // add list entered value
      enteredValues.add(value);
      enteredLengthStream.add(enteredValues.length);

      // the same number of digits was entered.
      if (enteredValues.length == widget.digits) {
        var buffer = StringBuffer();
        enteredValues.forEach((value) {
          buffer.write(value);
        });
        _verifyCorrectString(buffer.toString());
      }
    });
  }

  void _verifyCorrectString(String enteredValue) {
    Future.delayed(Duration(milliseconds: 150), () {
      var _verifyPasscode = widget.correctString;

      if (widget.confirmMode) {
        if (_isConfirmation == false) {
          _verifyConfirmPasscode = enteredValue;
          enteredValues.clear();
          enteredLengthStream.add(enteredValues.length);
          _isConfirmation = true;
          setState(() {});
          return;
        }
        _verifyPasscode = _verifyConfirmPasscode;
      }

      if (enteredValue == _verifyPasscode) {
        // send valid status to DotSecretUI
        validateStreamController.add(true);
        enteredValues.clear();
        enteredLengthStream.add(enteredValues.length);

        if (widget.onCompleted != null) {
          // call user function
          widget.onCompleted(context, enteredValue);
        } else {
          _needClose = true;
          Navigator.of(context).maybePop();
        }

        if (widget.onUnlocked != null) {
          widget.onUnlocked();
        }

        if (Navigator.canPop(context))
          Navigator.of(context).pop();
        else
          Navigator.pushReplacementNamed(
            context,
            '/',
          );
      } else {
        // send invalid status to DotSecretUI
        validateStreamController.add(false);
        enteredValues.clear();
        enteredLengthStream.add(enteredValues.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _enteredStreamListener();
    _removedStreamListener();
    var _rowMarginSize = MediaQuery.of(context).size.width * 0.0005;
    var _columnMarginSize = MediaQuery.of(context).size.width * 0.065;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
    ));

    return WillPopScope(
      onWillPop: () async {
        if (_needClose || widget.canCancel) {
          return true;
        }

        return false;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
          statusBarIconBrightness:
              Provider.of<ThemeModel>(context, listen: false).getThemeMode() ==
                      ThemeMode.dark
                  ? Brightness.light
                  : Brightness.dark,
          systemNavigationBarIconBrightness:
              Provider.of<ThemeModel>(context, listen: false).getThemeMode() ==
                      ThemeMode.dark
                  ? Brightness.light
                  : Brightness.dark,
        ),
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Image(
                  image: AssetImage(
                    'lib/assets/icon.png',
                  ),
                  height: 100,
                  width: 100,
                ),
                _buildTitle(),
                Spacer(),
                _buildSubtitle(),
                DotSecretUI(
                  validateStream: validateStreamController.stream,
                  dots: widget.digits,
                  config: widget.dotSecretConfig,
                  enteredLengthStream: enteredLengthStream.stream,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _columnMarginSize,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: _rowMarginSize),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildNumberTextButton(context, '1'),
                            _buildNumberTextButton(context, '2'),
                            _buildNumberTextButton(context, '3'),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: _rowMarginSize),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildNumberTextButton(context, '4'),
                            _buildNumberTextButton(context, '5'),
                            _buildNumberTextButton(context, '6'),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: _rowMarginSize),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildNumberTextButton(context, '7'),
                            _buildNumberTextButton(context, '8'),
                            _buildNumberTextButton(context, '9'),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(top: _rowMarginSize, bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildBothSidesButton(context, _biometricButton()),
                            _buildNumberTextButton(context, '0'),
                            _buildBothSidesButton(context, _rightSideButton()),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberTextButton(
    BuildContext context,
    String number,
  ) {
    final buttonSize = MediaQuery.of(context).size.width * 0.200;
    return Container(
      width: buttonSize,
      height: buttonSize,
      child: InputButton(
        enteredSink: enteredStream.sink,
        text: number,
        config: widget.circleInputButtonConfig,
      ),
    );
  }

  Widget _buildBothSidesButton(BuildContext context, Widget button) {
    final buttonSize = MediaQuery.of(context).size.width * 0.215;
    return Container(
      width: buttonSize,
      height: buttonSize,
      child: button,
    );
  }

  Widget _buildTitle() {
    return Container(
      //    margin: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'Moedeiro.',
        style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        _isConfirmation ? widget.confirmTitle : widget.title,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget _biometricButton() {
    if (!widget.canBiometric) return Container();

    return FlatButton(
      padding: EdgeInsets.all(0.0),
      child: widget.biometricButton,
      onPressed: () {
        _authenticate();
      },
      shape: CircleBorder(
        side: BorderSide(
          color: Colors.transparent,
          style: BorderStyle.solid,
        ),
      ),
      color: Colors.transparent,
    );
  }

  Widget _rightSideButton() {
    if (widget.rightSideButton != null) return widget.rightSideButton;

    return StreamBuilder<int>(
        stream: enteredLengthStream.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == 0) {
            return Container();
          }

          return FlatButton(
            padding: EdgeInsets.all(0),
            child: Icon(Icons.backspace),
            onPressed: () {
              if (snapshot.hasData && snapshot.data > 0) {
                removedStreamController.sink.add(null);
              } else {
                if (widget.canCancel) {
                  _needClose = true;
                  Navigator.of(context).maybePop();
                }
              }
            },
            shape: CircleBorder(
              side: BorderSide(
                color: Colors.transparent,
                style: BorderStyle.solid,
              ),
            ),
            color: Colors.transparent,
          );
        });
  }

  @override
  void dispose() {
    enteredStream.close();
    enteredLengthStream.close();
    validateStreamController.close();
    removedStreamController.close();

    // restore orientation.

    super.dispose();
  }
}
