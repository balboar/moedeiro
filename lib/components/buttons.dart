import 'package:flutter/material.dart';
import 'package:moedeiro/generated/l10n.dart';

class SaveButton extends StatelessWidget {
  final Function onPressed;
  final String? label;
  const SaveButton(this.onPressed, {Key? key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        label ?? S.of(context).save,
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}

class DeleteButton extends StatelessWidget {
  final Function onPressed;
  const DeleteButton(this.onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        S.of(context).delete,
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}
