import 'package:dartson/dartson.dart';
import 'package:sqlite/sqlite.dart';

import '../schemas/payee.dart';

Payee rowToPayee(Row row) {
  Payee payee = new Payee()
    ..id = row.PAYEEID
    ..name = row.PAYEENAME
    ..categoryId = row.CATEGID
    ..subCategoryId = row.SUBCATEGID;
  return payee;
}

List payeeToRow(Payee payee) {
  return [payee.name, payee.categoryId, payee.subCategoryId];
}

Payee jsonToPayee(String json) {
  var dson = new Dartson.JSON();
  return dson.decode(json, new Payee());
}

String payeeToJson(Payee payee) {
  var dson = new Dartson.JSON();
  return dson.encode(payee);
}
