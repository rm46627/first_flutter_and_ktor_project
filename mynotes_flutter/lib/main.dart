import 'package:flutter/material.dart';
import 'package:mynotes/assets/constants.dart';
import 'package:mynotes/services/auth/secure_storage.dart';
import 'package:mynotes/views/loginView.dart';
import 'package:mynotes/views/notesView.dart';
import 'package:mynotes/views/registerView.dart';

void main() {
  runApp(MaterialApp(
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
    return FutureBuilder<String?>(
      future: getAuthToken(),
      builder: (BuildContext context, AsyncSnapshot<String?> tokenSnapshot) {
        if (tokenSnapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final token = tokenSnapshot.data;
          if (token == null) {
            return const LoginView();
          } else {
            return const HomePage();
          }
        }
      },
    );
  }
}
