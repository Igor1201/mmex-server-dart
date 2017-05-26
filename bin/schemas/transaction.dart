import 'package:dartson/dartson.dart';

@Entity()
class Transaction {
  int id;
  int accountId;
  int toAccountId;
  int payeeId;
  String code;
  double amount;
  String status;
  int categoryId;
  int subCategoryId;
  DateTime date;
}
