import 'package:flutter/material.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moedeiro/generated/l10n.dart';

class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      title: Text(S.of(context).language),
      contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
      content: SingleChildScrollView(
        child: RadioButtons(),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 5.0),
      buttonPadding: EdgeInsets.symmetric(horizontal: 5.0),
      actions: <Widget>[
        TextButton(
          child: Text(S.of(context).cancel),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}

class RadioButtons extends StatefulWidget {
  RadioButtons({Key key}) : super(key: key);

  @override
  _RadioButtonsState createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {
  String _selectedValue = 'default';

  @override
  void initState() {
    getLocale();
    super.initState();
  }

  void getLocale() async {
    var prefs = await SharedPreferences.getInstance();
    var locale = prefs.getString('locale');
    setState(() {
      _selectedValue = locale ?? 'default';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: languageOptions
          .map(
            (LanguageValue e) => RadioListTile(
              title: Text(e.value),
              value: e.key,
              groupValue: _selectedValue,
              onChanged: (val) async {
                var prefs = await SharedPreferences.getInstance();
                prefs.setString('locale', val.toString());
                setState(() {
                  _selectedValue = val;
                });
                Navigator.of(context).pop(true);
              },
            ),
          )
          .toList(),
    );
  }
}