import 'package:mynotes/services/auth/auth_service.dart';

import 'database.dart';
import 'notes_dao.dart';

class LocalDataSource extends NotesDao {
  // final database = getIt.get<Database>();
  final database = Database.get();

  @override
  Future<Note> createNote(String text) async =>
      await database.into(database.notes).insertReturning(NotesCompanion.insert(
          content: text, userId: AuthService.rest().currentUser.id, isSynced: false));

  @override
  Future<void> removeNote(Note note) async =>
      await database.delete(database.notes).delete(note);

  @override
  Future<List<Note>> selectNotesByUserId(int userId) async =>
      await database.select(database.notes).get();

  @override
  Future<void> updateNote(Note note) async =>
      await database.update(database.notes).replace(note);
}
