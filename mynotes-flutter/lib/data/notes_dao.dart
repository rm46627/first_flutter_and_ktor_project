import 'database.dart';

abstract class NotesDao {
  Future<void> createNote(String text);
  Future<void> updateNote(Note note);
  Future<void> removeNote(Note note);
  Future<List<Note>> selectUserNotes(int userId);
}
