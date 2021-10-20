import 'package:flutter/material.dart';
import 'package:moedeiro/generated/l10n.dart';

class NoDataWidgetVertical extends StatelessWidget {
  const NoDataWidgetVertical({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 35.0,
        ),
        Text(
          '🤷‍♂️',
          style: TextStyle(fontSize: 90),
        ),
        SizedBox(
          height: 35.0,
        ),
        Text(
          S.of(context).noDataLabel,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class OptionsCard extends StatelessWidget {
  final IconData icon;
  final MaterialColor color;
  final Function onTap;
  final String label;
  const OptionsCard(this.icon, this.color, this.onTap, this.label, {Key? key})
      : super(key: key);

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
      onTap: onTap as void Function()?,
    );
  }
}

class MainPageSectionStateless extends StatelessWidget {
  final Function onTap;
  final String title;
  final String? subtitle;
  final EdgeInsetsGeometry? padding;

  const MainPageSectionStateless(this.title, this.onTap,
      {this.subtitle, this.padding, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap as void Function()?,
        child: Card(
          child: Container(
            padding: padding ??
                EdgeInsets.only(
                    left: 20.0, right: 10.0, top: 20.0, bottom: 20.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight:
                              FontWeight.normal), //TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      subtitle ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .headline6, //TextStyle(fontSize: 20.0),
                    ),
                  ],
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
          color: Colors.transparent,
          elevation: 0.0,
          margin: EdgeInsets.zero,
        ));
  }
}

class NoDataWidgetHorizontal extends StatelessWidget {
  const NoDataWidgetHorizontal({Key? key}) : super(key: key);

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
                width: 40,
                margin: EdgeInsets.only(top: 10, bottom: 10),
                height: 3,
                decoration: new BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                )),
          ]))),
        ]));
  }
}

class MoedeiroTransactionTransferButtons extends StatefulWidget {
  final PageController tabController;
  MoedeiroTransactionTransferButtons(
    this.tabController, {
    Key? key,
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

class _MoedeiroTransactionTransferButtonsState
    extends State<MoedeiroTransactionTransferButtons> {
  late double xAlign;
  Color? transactionColor;
  Color? transferColor;

  Color selectedColor = Colors.black;
  Color normalColor = Colors.black;

  @override
  void initState() {
    xAlign = transactionAlign;

    widget.tabController.addListener(() {
      setState(() {
        xAlign = -1 + widget.tabController.page! * 2;

        if (widget.tabController.page! < 0.5) {
          transactionColor = selectedColor;
          transferColor = normalColor;
        } else if (widget.tabController.page! > 0.5) {
          transferColor = selectedColor;
          transactionColor = normalColor;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedColor = Theme.of(context).scaffoldBackgroundColor;
    normalColor = Theme.of(context).colorScheme.secondary;
    transferColor = transferColor ?? normalColor;
    transactionColor = transactionColor ?? selectedColor;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
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
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.tabController.jumpToPage(
                0,
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
              widget.tabController.jumpToPage(
                1,
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
