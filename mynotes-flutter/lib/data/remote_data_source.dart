import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mynotes/assets/constants.dart' as constants;

import '../services/auth/auth_service.dart';
import 'database.dart';

class RemoteDataSource {
  Future<List<Note>> selectNotesByUserId(int userId) async {
    final url = Uri.parse(constants.API_GET_NOTES);
    final token = await AuthService.rest().getAuthToken();
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      log('notes response: $jsonData');
      return jsonData;
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<void> syncNotes(List<Note> notes) async {
    final url = Uri.parse(constants.API_SYNC_NOTES);
    final token = await AuthService.rest().getAuthToken();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final jsonNotes = notes.map((note) => note.toJson()).toList();
    final body = json.encode({
      'userId': AuthService.rest().currentUser.id,
      'notes': jsonNotes,
    });

    print(body);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      log('Notes sent successfully!');
    } else {
      log('Error sending notes. Status code: ${response.statusCode}');
    }
  }
}
