import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../../assets/constants.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notes"),
          actions: [
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text("Logout"),
                        onTap: () {
                          Future.delayed(Duration.zero, () => showLogoutDialog(context));
                        },
                      )
                    ])
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [],
          ),
        ));
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sign out"),
            content: const Text("Are you sure?"),
            actions: [
              TextButton(
                  onPressed: () {
                    AuthService.rest().logOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  },
                  child: const Text("Log out")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Back"))
            ],
          );
        });
  }

  // Future<Map<String, dynamic>> _getNotes(String token) async {
  //   final url = Uri.parse(constants.API_NOTES_CHECK);
  //   final response = await http.get(
  //     url,
  //     headers: {'Authorization': 'Bearer $token'},
  //   );
  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     log('notes response: $jsonData');
  //     return jsonData;
  //   } else {
  //     throw Exception('Failed to load notes');
  //   }
  // }
}
