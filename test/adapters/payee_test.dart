import 'package:test/test.dart';

import '../../src/schemas/payee.dart';
import '../../src/adapters/payee.dart';

void main() {
  group('.payeeToRow()', () {
    test('with all fields', () {
      Payee payee = new Payee()
        ..id = 1
        ..name = 'Test'
        ..categoryId = 1
        ..subCategoryId = 2;
      expect(payeeToRow(payee), equals(['Test', 1, 2]));
    });

    test('with all null', () {
      Payee payee = new Payee();
      expect(payeeToRow(payee), equals([null, null, null]));
    });
  });
}
