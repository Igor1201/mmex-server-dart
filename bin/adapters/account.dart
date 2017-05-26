import 'package:dartson/dartson.dart';
import 'package:sqlite/sqlite.dart';

import '../schemas/account.dart';

Account rowToAccount(Row row) {
  Account account = new Account()
    ..id = row.ACCOUNTID
    ..name = row.ACCOUNTNAME
    ..type = row.ACCOUNTTYPE
    ..status = row.STATUS
    ..favorite = (row.FAVORITEACCT == 'TRUE');
  return account;
}

String accountToJson(Account account) {
  var dson = new Dartson.JSON();
  return dson.encode(account);
}
