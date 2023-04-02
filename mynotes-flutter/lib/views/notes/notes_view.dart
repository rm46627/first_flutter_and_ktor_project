import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../../assets/constants.dart';
import '../../data/database.dart';
import '../../data/repository.dart';

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
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: Repository.get().allNotes,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final notes = snapshot.data as List<Note>;
                          // print(notes);
                          return ListView.builder(
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              final note = notes[index];
                              return ListTile(
                                title: Text(note.content),
                              );
                            },
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                ),
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(newNoteRoute);
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
      ),
    );
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
}
