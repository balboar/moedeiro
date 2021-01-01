import 'package:flutter/material.dart';

class NoDataWidgetVertical extends StatelessWidget {
  const NoDataWidgetVertical({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50.0,
        ),
        Image(
          image: AssetImage('lib/assets/icons/not-found.png'),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'No data',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class NoDataWidgetHorizontal extends StatelessWidget {
  const NoDataWidgetHorizontal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage('lib/assets/icons/not-found.png'),
        ),
        SizedBox(
          width: 20.0,
        ),
        Text(
          'No data',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class NavigationPillWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
          Container(
              child: Center(
                  child: Wrap(children: <Widget>[
            Container(
                width: 50,
                margin: EdgeInsets.only(top: 10, bottom: 10),
                height: 5,
                decoration: new BoxDecoration(
                  color: Theme.of(context).accentColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                )),
          ]))),
        ]));
  }
}
