import 'package:flutter/material.dart';
import 'package:moedeiro/components/buttons.dart';
import 'package:moedeiro/generated/l10n.dart';

class ComfirmDeleteDialog extends StatelessWidget {
  final String icon;
  final String? title;
  final String? subtitle;
  final String? confirmationLabel;
  const ComfirmDeleteDialog(this.icon,
      {Key? key, this.title, this.subtitle, this.confirmationLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      title: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), topRight: Radius.circular(7.0)),
        ),
        child: Center(
            child: Text(
          icon,
          style: TextStyle(fontSize: 70),
        )),
        height: 110,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Center(
              child: Text(
                title ?? S.of(context).deleteMovement,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              subtitle ?? S.of(context).deleteMovementDescription,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 5.0),
      buttonPadding: EdgeInsets.symmetric(horizontal: 5.0),
      actions: <Widget>[
        TextButtonMoedeiro(
          S.of(context).cancel,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButtonMoedeiro(
          confirmationLabel ?? S.of(context).delete,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
