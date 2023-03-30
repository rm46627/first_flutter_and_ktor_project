import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Notes extends Table {
  IntColumn get id => integer().unique().autoIncrement()();
  IntColumn get userId => integer().references(User, #id)();
  TextColumn get content => text()();
  BoolColumn get isSynced => boolean()();
}

class User extends Table {
  IntColumn get id => integer().unique()();
  TextColumn get email => text().unique()();
  TextColumn get username => text().unique()();
  TextColumn get role => text()();
}

@DriftDatabase(tables: [Notes, User])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 2;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
