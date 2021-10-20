import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:moedeiro/components/buttons.dart';
import 'package:moedeiro/components/dialogs/InfoDialog.dart';
import 'package:moedeiro/components/dialogs/confirmDeleteDialog.dart';
import 'package:moedeiro/models/accounts.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:moedeiro/generated/l10n.dart';

class AccountBottomSheet extends StatefulWidget {
  final Account? activeAccount;

  AccountBottomSheet(this.activeAccount);
  @override
  State<StatefulWidget> createState() {
    return _AccountBottomSheetState();
  }
}

class _AccountBottomSheetState extends State<AccountBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Account activeAccount;
  late File _image;
  String? _imagePath;
  double _space = 7.0;

  @override
  void initState() {
    activeAccount = widget.activeAccount ?? Account(initialAmount: 0.00);
    checkIcon();
    super.initState();
  }

  void checkIcon() async {
    if (activeAccount.icon != null) {
      var file = await File(activeAccount.icon!).exists();
      if (!file) {
        activeAccount.icon = null;
      }
    }
  }

  Future getImageFromFile() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    Directory _destination = await getApplicationDocumentsDirectory();
    if (pickedFile != null) {
      _image = File(pickedFile.files.single.path!);
      _imagePath = _destination.path +
          '/${activeAccount.uuid}${p.extension(pickedFile.files.single.path!)}';
      _image.copy(_imagePath!);
    }

    setState(
      () {
        if (_imagePath != null) {
          activeAccount.icon = _imagePath;
        }
      },
    );
  }

  Future<bool?> _showMyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ComfirmDeleteDialog(
          icon: Icons.account_balance_wallet_outlined,
          title: S.of(context).deleteAccount,
          subtitle: S.of(context).deleteAccountDescription,
        );
      },
    );
  }

  Future<bool?> _showAccountNotEmptyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return InfoDialog(
          icon: Icons.error_outline,
          title: S.of(context).deleteAccountError,
          subtitle: S.of(context).deleteAccountDescriptionError,
        );
      },
    );
  }

  void deleteAccount(AccountModel model) {
    List<Transaction> accountTransactions =
        Provider.of<TransactionModel>(context, listen: false)
            .getAccountTransactions(activeAccount.uuid);
    if (accountTransactions.length > 0)
      _showAccountNotEmptyDialog().then((value) => Navigator.pop(context));
    else if (activeAccount.uuid != null) {
      _showMyDialog().then((value) {
        if (value!) {
          model.deleteAccount(activeAccount.uuid!);
          Navigator.pop(context);
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void _submitForm(Function insertAccount) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        insertAccount(activeAccount);
        Navigator.pop(context, true);
      }
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(
              right: 20.0,
              left: 20.0,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: CircleAvatar(
                  backgroundImage: activeAccount.icon != null
                      ? FileImage(
                          File(activeAccount.icon!),
                        )
                      : null,
                  backgroundColor: Theme.of(context).dialogBackgroundColor,
                  child: activeAccount.icon != null ? null : Icon(Icons.add),
                  radius: 40,
                ),
                onTap: getImageFromFile,
              ),
              SizedBox(
                height: _space * 3,
              ),
              TextFormField(
                initialValue: activeAccount.name,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  prefixIcon: Icon(Icons.account_balance_wallet),
                  labelStyle: TextStyle(fontSize: 20.0),
                  // icon: Icon(Icons.account_balance_wallet),
                  labelText: S.of(context).accountName,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return S.of(context).accountName;
                  }
                  return null;
                },
                onSaved: (String? value) {
                  activeAccount.name = value;
                },
              ),
              SizedBox(
                height: _space,
              ),
              TextFormField(
                initialValue: activeAccount.initialAmount.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  prefixIcon: Icon(Icons.euro),
                  // icon: Icon(Icons.euro),
                  labelText: S.of(context).initialAmount,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return S.of(context).initialAmountError;
                  }
                  return null;
                },
                onSaved: (String? value) {
                  activeAccount.initialAmount = double.parse(value!);
                },
              ),
              Consumer<AccountModel>(
                builder:
                    (BuildContext context, AccountModel model, Widget? widget) {
                  return ButtonBar(
                    buttonHeight: 40.0,
                    buttonMinWidth: 140.0,
                    alignment: MainAxisAlignment.spaceAround,
                    children: [
                      Visibility(
                        child: DeleteButton(() {
                          deleteAccount(model);
                        }),
                        visible: activeAccount.uuid != null,
                      ),
                      SaveButton(() {
                        _submitForm(model.insertAccountIntoDb);
                      }),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
