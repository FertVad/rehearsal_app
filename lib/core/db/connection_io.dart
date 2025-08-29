import 'dart:io' show File, Platform;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final dir = (Platform.isIOS || Platform.isMacOS)
        ? await getLibraryDirectory()
        : await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}
