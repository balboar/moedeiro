import 'package:flutter/material.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/models/settings.dart';
import 'package:provider/provider.dart';

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
  FocusNode? focusNode;
  String firstPassword = '';
  String secondPassword = '';
  String? pinText;

  @override
  void initState() {
    focusNode = FocusNode();
    focusNode!.requestFocus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _submitForm() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        if (firstPassword.length > 0) {
          firstPassword = _controller.text;
          _controller.clear();
          setState(() {
            pinText = S.of(context).confirmPin;
          });
        } else
          secondPassword = _controller.text;
        if (firstPassword == secondPassword) {
          Provider.of<SettingsModel>(context, listen: false).pin =
              firstPassword;
          Navigator.pop(context);
        }
      }
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.only(
                right: 20.0,
                left: 20,
                top: 5,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: space,
                ),
                Text(
                  pinText ?? S.of(context).pin,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _controller,
                          textAlign: TextAlign.center,
                          // autovalidateMode: AutovalidateMode.,
                          focusNode: focusNode,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          validator: (value) {
                            {
                              var pin = int.tryParse(value!);
                              if (pin == null) {
                                return S.of(context).pinError;
                              } else if (value.length != 4) {
                                return S.of(context).pinErrorLenght;
                              } else
                                return null;
                            }
                          },
                          onSaved: (String? value) {},
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 30,
                        ),
                        onPressed: _submitForm,
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
