import 'package:flutter/material.dart';
import 'package:moedeiro/generated/l10n.dart';

class InfoDialog extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? subtitle;
  const InfoDialog({Key? key, this.icon, this.title, this.subtitle})
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
            "🙀",
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
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
        ButtonBar(
          // crossAxisAlignment: CrossAxisAlignment.start,
          alignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.transparent,
                  onPrimary: Theme.of(context).textTheme.bodyText1!.color),
              icon: Icon(Icons.cancel_outlined),
              label: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        )
      ],
    );
  }
}
