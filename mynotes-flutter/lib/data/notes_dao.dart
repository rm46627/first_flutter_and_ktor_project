import 'database.dart';

abstract class NotesDao {
  Future<Note> createNote(String text);
  Future<void> updateNote(Note note);
  Future<void> removeNote(Note note);
  Future<List<Note>> selectNotesByUserId(int userId);
}
