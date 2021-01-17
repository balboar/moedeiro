import 'package:flutter/material.dart';

class ComfirmDeleteDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const ComfirmDeleteDialog({Key key, this.icon, this.title, this.subtitle})
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
        child: Icon(
          icon ?? Icons.euro,
          size: 70,
        ),
        height: 110,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Center(
              child: Text(
                title ?? 'Delete movement?',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              subtitle ?? 'A movement is going to be deleted, are you sure?',
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
          alignment: MainAxisAlignment.center,
          children: [
            RaisedButton.icon(
              color: Theme.of(context).dialogBackgroundColor,
              elevation: 0,
              icon: Icon(Icons.cancel_outlined),
              label: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            RaisedButton.icon(
              icon: Icon(Icons.delete_outline_outlined),
              color: Theme.of(context).accentColor,
              label: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        )
      ],
    );
  }
}
