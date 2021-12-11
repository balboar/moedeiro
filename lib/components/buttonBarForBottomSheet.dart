import 'package:flutter/material.dart';
import 'package:moedeiro/components/buttons.dart';
import 'package:moedeiro/generated/l10n.dart';

class ButtonBarMoedeiro extends StatefulWidget {
  final bool oneButtonOnly;
  final Function? onPressedButton1;
  final Function? onPressedButton2;
  ButtonBarMoedeiro(this.oneButtonOnly,
      {Key? key, this.onPressedButton1, this.onPressedButton2})
      : super(key: key);

  @override
  _ButtonBarMoedeiroState createState() => _ButtonBarMoedeiroState();
}

class _ButtonBarMoedeiroState extends State<ButtonBarMoedeiro> {
  @override
  Widget build(BuildContext context) {
    return widget.oneButtonOnly
        ? Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              height: 40.0,
              width: MediaQuery.of(context).size.width - 50,
              child: MainButtonMoedeiro(
                onPressed: widget.onPressedButton1,
                label: S.of(context).save,
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ButtonBar(
              children: [
                SecondaryButtonMoedeiro(onPressed: widget.onPressedButton2),
                MainButtonMoedeiro(
                  onPressed: widget.onPressedButton1,
                ),
              ],
            ),
          );
  }
}
