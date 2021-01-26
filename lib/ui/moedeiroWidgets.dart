import 'package:flutter/material.dart';
import 'package:moedeiro/generated/l10n.dart';

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
          S.of(context).noDataLabel,
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
          S.of(context).noDataLabel,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class NavigationPillWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

class MoedeiroTransactionTransferButtons extends StatefulWidget {
  PageController tabController;
  MoedeiroTransactionTransferButtons(
    this.tabController, {
    Key key,
  }) : super(key: key);

  @override
  _MoedeiroTransactionTransferButtonsState createState() =>
      _MoedeiroTransactionTransferButtonsState();
}

const double width = 300.0;
const double height = 40.0;
const double borderRadius = 10.0;
const double transactionAlign = -1;
const double transferAlign = 1;
const Color selectedColor = Colors.black;
const Color normalColor = Colors.black;

class _MoedeiroTransactionTransferButtonsState
    extends State<MoedeiroTransactionTransferButtons> {
  double xAlign;
  Color transactionColor;
  Color transferColor;

  @override
  void initState() {
    super.initState();
    xAlign = transactionAlign;
    transactionColor = selectedColor;
    transferColor = normalColor;
    widget.tabController.addListener(() {
      setState(() {
        xAlign = -1 + (widget.tabController.page) * 2;
        if (widget.tabController.page == 0) {
          transactionColor = selectedColor;
          transferColor = normalColor;
        } else if (widget.tabController.page == 1) {
          transferColor = selectedColor;
          transactionColor = normalColor;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(xAlign, 0),
            duration: Duration(milliseconds: 1),
            child: Container(
              width: width * 0.5,
              height: height,
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
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.tabController.animateToPage(
                0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
              );

              setState(() {
                xAlign = transactionAlign;

                transferColor = normalColor;
                transactionColor = selectedColor;
              });
            },
            child: Align(
              alignment: Alignment(-1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  S.of(context).transaction,
                  style: TextStyle(
                    color: transactionColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.tabController.animateToPage(
                1,
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
              );

              setState(() {
                xAlign = transferAlign;

                transactionColor = normalColor;
                transferColor = selectedColor;
              });
            },
            child: Align(
              alignment: Alignment(1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  S.of(context).transfer,
                  style: TextStyle(
                    color: transferColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
