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
          color: color[100],
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Replace with a Row for horizontal icon + text
            children: <Widget>[
              Icon(
                icon,
                size: 40.0,
                color: color[800],
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: color[800],
                ),
              )
            ],
          ),
        ),
        width: 90,
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
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          child: Row(
            children: [
              Icon(icon),
              Divider(
                indent: 10.0,
              ),
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
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        ),
      ),
    );
  }
}
