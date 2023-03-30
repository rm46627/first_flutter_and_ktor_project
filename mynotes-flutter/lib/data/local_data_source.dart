import 'package:mynotes/services/auth/auth_service.dart';

import '../assets/service_locator.dart';
import 'database.dart';
import 'notes_dao.dart';

class LocalDataSource extends NotesDao {
  final database = getIt.get<Database>();

  @override
  Future<void> createNote(String text) async =>
      await database.into(database.notes).insert(NotesCompanion.insert(
          content: text, userId: AuthService.rest().currentUser.id, isSynced: false));

  @override
  Future<void> removeNote(Note note) async =>
      await database.delete(database.notes).delete(note);

  @override
  Future<List<Note>> selectUserNotes(int userId) async =>
      await database.select(database.notes).get();

  @override
  Future<void> updateNote(Note note) async =>
      await database.update(database.notes).replace(note);
}