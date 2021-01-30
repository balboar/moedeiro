import 'package:flutter/material.dart';
import 'package:moedeiro/ui/widgets/buttons.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordBottomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PasswordBottomSheetState();
  }
}

class _PasswordBottomSheetState extends State<PasswordBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  double space = 7.0;
  FocusNode focusNode;
  String firstPassword;
  String secondPassword;
  String pinText;

  @override
  void initState() {
    focusNode = FocusNode();
    focusNode.requestFocus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _submitForm() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        if (firstPassword == null) {
          firstPassword = _controller.text;
          _controller.clear();
          setState(() {
            pinText = S.of(context).confirmPin;
          });
        } else
          secondPassword = _controller.text;
        if (firstPassword == secondPassword) {
          Navigator.pop(context);
          var prefs = await SharedPreferences.getInstance();
          prefs.setString('PIN', firstPassword);
        }
      }
    }

    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Padding(
              padding:
                  EdgeInsets.only(right: 20.0, left: 20, top: 5, bottom: 5.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: space,
                  ),
                  Text(
                    pinText ?? S.of(context).pin,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  TextFormField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    // autovalidateMode: AutovalidateMode.,
                    focusNode: focusNode,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false),
                    validator: (value) {
                      // if (value.isEmpty) {
                      //   return S.of(context).pinEmpty;
                      // } else
                      {
                        var pin = int.tryParse(value);
                        if (pin == null) {
                          return S.of(context).pinError;
                        } else
                          return null;
                      }
                    },
                    onSaved: (String value) {},
                  ),
                  SaveButton(() {
                    _submitForm();
                  }),
                ],
              )),
        ),
      ),
    );
  }
}
