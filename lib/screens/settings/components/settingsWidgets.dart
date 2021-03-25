

import 'package:flutter/material.dart';

class SectionName extends StatelessWidget {
  final String title;

  const SectionName(
    this.title, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(
            left: 15.0, right: 15.0, bottom: 6.0, top: 10.0),
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
