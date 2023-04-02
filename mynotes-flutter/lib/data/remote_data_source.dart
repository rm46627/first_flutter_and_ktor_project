import 'package:mynotes/data/database.dart';
import 'package:mynotes/data/notes_dao.dart';

class RemoteDataSource extends NotesDao {
  @override
  Future<Note> createNote(String text) {
    // TODO: implement createNote
    throw UnimplementedError();
  }

  @override
  Future<void> removeNote(Note note) {
    // TODO: implement removeNote
    throw UnimplementedError();
  }

  @override
  Future<List<Note>> selectNotesByUserId(int userId) async {
    // final url = Uri.parse(constants.API_NOTES_CHECK);
    // final response = await http.get(
    //   url,
    //   headers: {'Authorization': 'Bearer $token'},
    // );
    // if (response.statusCode == 200) {
    //   final jsonData = json.decode(response.body);
    //   log('notes response: $jsonData');
    //   return jsonData;
    // } else {
    //   throw Exception('Failed to load notes');
    // }
    throw UnimplementedError();
  }

  @override
  Future<void> updateNote(Note note) {
    // TODO: implement updateNote
    throw UnimplementedError();
  }
}
