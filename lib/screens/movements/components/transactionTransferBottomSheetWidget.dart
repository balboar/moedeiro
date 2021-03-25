import 'package:flutter/material.dart';
import 'package:moedeiro/components/moedeiroWidgets.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/models/transfer.dart';
import 'package:moedeiro/screens/movements/components/transactionBottomSheet.dart';
import 'package:moedeiro/screens/movements/components/transferBottomSheetWidget.dart';

class TransactionTransferBottomSheet extends StatefulWidget {
  final Transaction? transaction;
  final Transfer? transfer;
  TransactionTransferBottomSheet({this.transaction, this.transfer});
  @override
  State<StatefulWidget> createState() {
    return _TransactionTransferBottomSheetState();
  }
}

class _TransactionTransferBottomSheetState
    extends State<TransactionTransferBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final controller = PageController(
    viewportFraction: 1,
  );
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 10.0,
        ),
        child: Column(
          children: <Widget>[
            MoedeiroTransactionTransferButtons(controller),
            Container(
              child: PageView(
                controller: controller,
                children: [
                  TransactionBottomSheet(widget.transaction ??
                      Transaction(
                          timestamp: DateTime.now().millisecondsSinceEpoch)),
                  TransferBottomSheet(widget.transfer ??
                      Transfer(
                          timestamp: DateTime.now().millisecondsSinceEpoch))
                ],
              ),
              height: 380,
            ),
          ],
        ),
      ),
    );
  }
}
