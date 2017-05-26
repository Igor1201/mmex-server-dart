// Copyright (c) 2017, Igor Borges <igor@borges.me>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:logging_handlers/logging_handlers_shared.dart';
import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

void main(List<String> args) {
  startQuickLogging();

  var parser = new ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8080');

  var result = parser.parse(args);

  var port = int.parse(result['port'], onError: (val) {
    warn('Could not parse port value "$val" into a number.');
    exit(1);
  });

  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests(logger: logShelf))
      .addHandler(_echoRequest);

  io.serve(handler, '0.0.0.0', port).then((server) {
    info('Serving at http://${server.address.host}:${server.port}');
  });
}

void logShelf(String message, bool isError) {
  if (isError) error(message);
  else info(message);
}

shelf.Response _echoRequest(shelf.Request request) {
  return new shelf.Response.ok('Request for "${request.url}"');
}
