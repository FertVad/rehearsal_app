import 'package:drift/drift.dart';
import 'package:drift/native.dart';

DatabaseConnection testConnection() {
  return DatabaseConnection(NativeDatabase.memory());
}
