import 'package:flutter/material.dart';
import 'package:mynotes/assets/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

import '../../assets/constants.dart';
import '../../data/database.dart';
import '../../data/repository.dart';
import '../../services/auth/auth_service.dart';

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
                        onTap: () async {
                          await Future.delayed(const Duration(milliseconds: 100));
                          handleLogout(context);
                        }),
                    PopupMenuItem(
                        child: const Text("Sync Notes"),
                        onTap: () async {
                          Repository.get().syncNotes();
                        }),
                    PopupMenuItem(`
                        child: const Text("Get notes from remote"),
                        onTap: () async {
                          Repository.get().getNotesFromRemote();
                        }),
                    PopupMenuItem(
                        child: const Text("Remove all notes"),
                        onTap: () async {
                          Repository.get().removeAllNotes();
                        }),
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
                          return NotesListView(
                            notes: notes.reversed.toList(),
                            onDeleteNote: (note) async {
                              await Repository.get().removeNote(note);
                            },
                            onTap: (Note note) {
                              Navigator.of(context)
                                  .pushNamed(newEditNoteRoute, arguments: note);
                            },
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                        break;
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
          Navigator.of(context).pushNamed(newEditNoteRoute);
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
      ),
    );
  }

  void handleLogout(BuildContext context) async {
    final logoutChoice = await showLogoutDialog(context);
    if (logoutChoice) {
      AuthService.rest().logOut();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
      }
    }
  }
}
