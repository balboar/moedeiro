import 'package:flutter/material.dart';

class OptionsCard extends StatelessWidget {
  final IconData icon;
  final MaterialColor color;
  final Function onTap;
  final String label;
  const OptionsCard(this.icon, this.color, this.onTap, this.label, {Key key})
      : assert(icon != null),
        assert(onTap != null),
        assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(
            //   side: BorderSide(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Icon(
            icon,
            size: 40.0,
          ),
        ),
        width: 85,
      ),
      onTap: onTap,
    );
  }
}

class MainPageSectionStateless extends StatelessWidget {
  final Function onTap;
  final String label;
  final IconData icon;

  const MainPageSectionStateless(this.label, this.onTap, this.icon, {Key key})
      : assert(onTap != null),
        assert(label != null),
        assert(icon != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 10.0,
          top: 30.0,
          bottom: 15.0,
        ),
        child: Row(
          children: [
            // Icon(icon),
            // Divider(
            //   indent: 10.0,
            // ),
            Text(
              label,
              style: TextStyle(fontSize: 20.0),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_forward),
              ),
            )
          ],
        ),
      ),
    );
  }
}
