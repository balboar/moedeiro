import 'package:flutter/material.dart';

Future<dynamic> showCustomModalBottomSheet(BuildContext context, Widget page,
    {bool isScrollControlled = true, bool enableDrag = true}) {
  return showModalBottomSheet(
      enableDrag: false,
      context: context,
      isScrollControlled: isScrollControlled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return page;
      });
}
