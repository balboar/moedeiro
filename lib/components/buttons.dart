import 'package:flutter/material.dart';
import 'package:moedeiro/generated/l10n.dart';

class MainButtonMoedeiro extends StatelessWidget {
  final Function? onPressed;
  final String? label;
  const MainButtonMoedeiro({Key? key, this.label, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        label ?? S.of(context).save,
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        primary: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onSurface: Colors.grey,
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 30,
        ),
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}

class SecondaryButtonMoedeiro extends StatelessWidget {
  final Function? onPressed;
  final String? label;
  const SecondaryButtonMoedeiro({Key? key, this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(
        label ?? S.of(context).delete,
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        // primary: Colors.white,
        //   backgroundColor: Theme.of(context).colorScheme.secondary,
        onSurface: Colors.grey,
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 30,
        ),
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}

class TextButtonMoedeiro extends StatelessWidget {
  final Function? onPressed;
  final String label;
  const TextButtonMoedeiro(this.label, {Key? key, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(label),
      onPressed: onPressed as void Function()?,
    );
  }
}
