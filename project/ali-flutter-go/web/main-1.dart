// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter_web_ui/ui.dart' as ui;
import 'package:flutter_go/main.dart' as app;

import 'package:flutter_go/routers/fluro/fluro.dart';
import 'package:flutter_go/routers/routers.dart';
import 'package:flutter_go/routers/application.dart';

main() async {

  final router = new Router();
  Routes.configureRoutes(router);
  Application.router = router;

  await ui.webOnlyInitializePlatform();
  app.main();
}
