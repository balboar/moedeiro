import 'package:flutter/material.dart';
import 'package:moedeiro/generated/l10n.dart';

class SaveButton extends StatelessWidget {
  final Function onPressed;
  const SaveButton(this.onPressed, {Key key})
      : assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        S.of(context).save,
      ),
      onPressed: onPressed,
    );
  }
}

class DeleteButton extends StatelessWidget {
  final Function onPressed;
  const DeleteButton(this.onPressed, {Key key})
      : assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        S.of(context).delete,
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
