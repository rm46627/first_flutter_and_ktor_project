import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mynotes/assets/constants.dart' as constants;
import 'package:mynotes/secure_storage.dart';
import 'package:mynotes/views/loginView.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [const PopupMenuItem(value: 0, child: Text("Logout"))];
              },
              onSelected: (value) {
                if (value == 0) {
                  deleteAuthToken();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()),
                      (r) => false);
                }
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    deleteAuthToken();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()),
                        (r) => false);
                  },
                  child: const Text('Logout'))
            ],
          ),
        ));
  }

  Future<Map<String, dynamic>> _getNotes(String token) async {
    final url = Uri.parse(constants.API_NOTES_CHECK);
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to load notes');
    }
  }
}
