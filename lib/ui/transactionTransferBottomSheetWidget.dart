import 'package:flutter/material.dart';
import 'package:moedeiro/dataModels/transaction.dart';
import 'package:moedeiro/dataModels/transfer.dart';
import 'package:moedeiro/ui/moedeiro_widgets.dart';
import 'package:moedeiro/ui/transactions/transactionBottomSheetWidget.dart';
import 'package:moedeiro/ui/transfers/transferBottomSheetWidget.dart';

class TransactionTransferBottomSheet extends StatefulWidget {
  Transaction transaction;
  Transfer transfer;
  TransactionTransferBottomSheet({this.transaction, this.transfer});
  @override
  State<StatefulWidget> createState() {
    return _TransactionTransferBottomSheetState();
  }
}

class _TransactionTransferBottomSheetState
    extends State<TransactionTransferBottomSheet>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TabController _tabController;

  final controller = PageController(viewportFraction: 1);
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
            bottom: MediaQuery.of(context).viewInsets.bottom, top: 10.0),
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
              height: 420,
            ),
          ],
        ),
      ),
    );
  }
}
