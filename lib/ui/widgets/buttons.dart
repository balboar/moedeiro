import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final Function onPressed;
  const SaveButton(this.onPressed, {Key key})
      : assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(217, 81, 157, 1),
            Color.fromRGBO(237, 135, 112, 1)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: FlatButton(
        child: Text(
          'Guardar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPressed,
      ),
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
        'Eliminar',
        style: TextStyle(
          color: Colors.grey[500],
        ),
      ),
      onPressed: onPressed,
    );
  }
}
