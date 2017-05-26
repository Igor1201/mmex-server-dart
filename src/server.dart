// Copyright (c) 2017, Igor Borges <igor@borges.me>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';
import 'package:args/args.dart';
import 'package:shelf/shelf.dart';
import 'package:mojito/mojito.dart';
import 'package:sqlite/sqlite.dart';

import 'adapters/payee.dart' as a_pay;
import 'adapters/account.dart' as a_acc;
import 'schemas/payee.dart';
import 'schemas/account.dart';

void main(List<String> args) {
  Logger.root.level = Level.ALL;
  startQuickLogging();

  final parser = new ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8080');
  final result = parser.parse(args);

  final int port = int.parse(result['port'], onError: (val) {
    error('Could not parse port value "$val" into a number.');
    exit(1);
  });

  final app = init(isDevMode: () => true);
  app.router
    ..addAll(new PayeeResource(), path: '/api/v1/payees')
    ..addAll(new SqliteResource(), path: '/api/v1');
  app.start(port: port);
}

final db = new Database('/Users/igor/Dropbox/Apps/MoneyManagerEx Mobile/new.mmb');

class SqliteResource {
  call(Router r) => r
    ..get('/account/{id}', (Request request) async {
      final int id = int.parse(getPathParameter(request, 'id'));
      final Account account = await getAccountFromId(id, db);
      if (account == null) return new Response.notFound('{}');
      return new Response.ok(a_acc.accountToJson(account));
    })
    ..post('/echo', (Request request) async {
      final String body = await request.readAsString();
      return new Response.ok(body);
    });
}

class PayeeResource {
  call(Router r) => r
    ..post('/', (Request request) async {
      final String body = await request.readAsString();
      final Payee payee = a_pay.jsonToPayee(body);
      insertPayee(payee, db);
      return new Response(202);
    })
    ..get('/{id}', (Request request) async {
      final int id = int.parse(getPathParameter(request, 'id'));
      final Payee payee = await getPayeeFromId(id, db);
      if (payee == null) return new Response.notFound('{}');
      return new Response.ok(a_pay.payeeToJson(payee));
    });
}

Future<Account> getAccountFromId(int id, Database db) async {
  return await db
    .query('SELECT * FROM ACCOUNTLIST_V1 WHERE ACCOUNTID = $id')
    .map(a_acc.rowToAccount)
    .single
    .catchError((Error e) => error(e.toString()));
}

Future<Payee> getPayeeFromId(int id, Database db) async {
  return await db
    .query('SELECT * FROM PAYEE_V1 WHERE PAYEEID = $id')
    .map(a_pay.rowToPayee)
    .single
    .catchError((Error e) => error(e.toString()));
}

Future insertPayee(Payee payee, Database db) async {
  await db
    .execute('INSERT INTO PAYEE_V1 (PAYEENAME, CATEGID, SUBCATEGID) VALUES (?, ?, ?)', params: a_pay.payeeToRow(payee))
    .catchError((Error e) => error(e.toString()));
}
