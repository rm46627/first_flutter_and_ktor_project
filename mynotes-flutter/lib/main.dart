import 'package:flutter/material.dart';
import 'package:mynotes/assets/constants.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'MyNotesFlutter',
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.rest().checkIfTokenIsValid(),
      builder: (BuildContext context, AsyncSnapshot<bool> validSnapshot) {
        if (validSnapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final valid = validSnapshot.data ?? false;
          return valid == true ? const NotesView() : const LoginView();
        }
      },
    );
  }
}
