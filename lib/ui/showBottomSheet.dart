import 'package:flutter/material.dart';

Future<String> showCustomModalBottomSheet(BuildContext context, Widget page) {
  return showModalBottomSheet(
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (BuildContext context) {
        return page;
      });
}
