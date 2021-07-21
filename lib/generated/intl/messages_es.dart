// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("Cuenta"),
        "accountName":
            MessageLookupByLibrary.simpleMessage("Nombre de la cuenta"),
        "accountSelectError":
            MessageLookupByLibrary.simpleMessage("Selecciona una cuenta"),
        "accountsTitle": MessageLookupByLibrary.simpleMessage("Cuentas"),
        "allSet": MessageLookupByLibrary.simpleMessage("Bienvenido a Moedeiro"),
        "amount": MessageLookupByLibrary.simpleMessage("Importe"),
        "amountError": MessageLookupByLibrary.simpleMessage(
            "La cantidad tiene que ser mayor a 0"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Moedeiro"),
        "authenticateLabel": MessageLookupByLibrary.simpleMessage(
            "Inicia sesión para ver los datos"),
        "balance": MessageLookupByLibrary.simpleMessage("Balance"),
        "budgetsTitle": MessageLookupByLibrary.simpleMessage("Presupuestos"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "categories": MessageLookupByLibrary.simpleMessage("Categorías"),
        "categoryError":
            MessageLookupByLibrary.simpleMessage("Selecciona una categoria"),
        "categoryTitle": MessageLookupByLibrary.simpleMessage("Categoría"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Cambiar contraseña"),
        "common": MessageLookupByLibrary.simpleMessage("Generales"),
        "confirmPin": MessageLookupByLibrary.simpleMessage("Confirma el PIN"),
        "createAccountError": MessageLookupByLibrary.simpleMessage(
            "Es necesario crear una cuenta"),
        "createAccountSuccess": MessageLookupByLibrary.simpleMessage(
            "Cuenta creada, puedes crear otra o continuar"),
        "createAccountText":
            MessageLookupByLibrary.simpleMessage("Crea tu primera cuenta"),
        "data": MessageLookupByLibrary.simpleMessage("Datos"),
        "date": MessageLookupByLibrary.simpleMessage("Fecha"),
        "defaultAccount":
            MessageLookupByLibrary.simpleMessage("Cuenta por defecto"),
        "delete": MessageLookupByLibrary.simpleMessage("Eliminar"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("¿Borrar cuenta?"),
        "deleteAccountDescription": MessageLookupByLibrary.simpleMessage(
            "Se va a borrar la cuenta, ¿estás seguro?"),
        "deleteCategory":
            MessageLookupByLibrary.simpleMessage("¿Borrar categoría?"),
        "deleteCategoryError": MessageLookupByLibrary.simpleMessage(
            "No se puede borrar la categoría"),
        "deleteCategorytDescriptionError": MessageLookupByLibrary.simpleMessage(
            "Esta categoría tiene transacciones, borrar o moverlas primero"),
        "deleteMovement":
            MessageLookupByLibrary.simpleMessage("¿Borrar movimiento?"),
        "deleteMovementDescription": MessageLookupByLibrary.simpleMessage(
            "Se va a borrar un movimiento, ¿estás seguro?"),
        "description": MessageLookupByLibrary.simpleMessage("Descripción"),
        "discreetMode": MessageLookupByLibrary.simpleMessage("Modo discreto"),
        "discreetModeExplanation": MessageLookupByLibrary.simpleMessage(
            "El modo discreto oculta los importes"),
        "errorText":
            MessageLookupByLibrary.simpleMessage("Se ha producido un error"),
        "expense": MessageLookupByLibrary.simpleMessage("Gasto"),
        "expenses": MessageLookupByLibrary.simpleMessage("Gastos"),
        "expensesMonth": MessageLookupByLibrary.simpleMessage("Gastos mes"),
        "exportDb":
            MessageLookupByLibrary.simpleMessage("Exportar base de datos"),
        "finishText": MessageLookupByLibrary.simpleMessage("TERMINADO"),
        "from": MessageLookupByLibrary.simpleMessage("De"),
        "importCSV": MessageLookupByLibrary.simpleMessage("Importar desde CSV"),
        "importDb":
            MessageLookupByLibrary.simpleMessage("Importar base de datos"),
        "income": MessageLookupByLibrary.simpleMessage("Ingreso"),
        "incomes": MessageLookupByLibrary.simpleMessage("Ingresos"),
        "initialAmount":
            MessageLookupByLibrary.simpleMessage("Cantidad inicial"),
        "initialAmountError": MessageLookupByLibrary.simpleMessage(
            "La cantidad no puede estar vacia"),
        "language": MessageLookupByLibrary.simpleMessage("Idioma"),
        "lockAppInBackGround": MessageLookupByLibrary.simpleMessage(
            "Bloquear aplicación en segundo plano"),
        "lockScreenPrompt":
            MessageLookupByLibrary.simpleMessage("Iniciar sesión con huella"),
        "movementsTitle": MessageLookupByLibrary.simpleMessage("Movimientos"),
        "name": MessageLookupByLibrary.simpleMessage("Nombre"),
        "nameError": MessageLookupByLibrary.simpleMessage(
            "El nombre no puede estar vacio"),
        "next": MessageLookupByLibrary.simpleMessage("SIGUIENTE"),
        "noDataLabel": MessageLookupByLibrary.simpleMessage("Sin datos"),
        "ofText": MessageLookupByLibrary.simpleMessage("DE"),
        "pin": MessageLookupByLibrary.simpleMessage("PIN"),
        "pinEmpty":
            MessageLookupByLibrary.simpleMessage("El PIN no puede estar vacio"),
        "pinError": MessageLookupByLibrary.simpleMessage(
            "El PIN tiene que ser un valor numérico"),
        "pinErrorLenght": MessageLookupByLibrary.simpleMessage(
            "El PIN tiene que tener 4 numeros"),
        "prev": MessageLookupByLibrary.simpleMessage("ANTERIOR"),
        "restartMoedeiro": MessageLookupByLibrary.simpleMessage(
            "Importado, reinicia Moedeiro"),
        "save": MessageLookupByLibrary.simpleMessage("Guardar"),
        "search": MessageLookupByLibrary.simpleMessage("Buscar.."),
        "security": MessageLookupByLibrary.simpleMessage("Seguridad"),
        "setUpMoedeiro":
            MessageLookupByLibrary.simpleMessage("Configuremos Moedeiro"),
        "settings": MessageLookupByLibrary.simpleMessage("Ajustes"),
        "step": MessageLookupByLibrary.simpleMessage("PASO"),
        "systemDefaultTitle":
            MessageLookupByLibrary.simpleMessage("Por defecto del sistema"),
        "theme": MessageLookupByLibrary.simpleMessage("Tema"),
        "time": MessageLookupByLibrary.simpleMessage("Hora"),
        "to": MessageLookupByLibrary.simpleMessage("A"),
        "transaction": MessageLookupByLibrary.simpleMessage("Transaccion"),
        "transactions": MessageLookupByLibrary.simpleMessage("Transacciones"),
        "transactionsTitle":
            MessageLookupByLibrary.simpleMessage("Ultimas transacciones"),
        "transfer": MessageLookupByLibrary.simpleMessage("Transferencia"),
        "transfers": MessageLookupByLibrary.simpleMessage("Transferencias"),
        "useFingerprint": MessageLookupByLibrary.simpleMessage("Usar huella"),
        "version": MessageLookupByLibrary.simpleMessage("Versión")
      };
}
