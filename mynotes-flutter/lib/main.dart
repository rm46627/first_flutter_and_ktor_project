import 'package:flutter/material.dart';
import 'package:mynotes/secure_storage.dart';
import 'package:mynotes/views/homePage.dart';
import 'package:mynotes/views/loginView.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getAuthToken(),
      builder: (BuildContext context, AsyncSnapshot<String?> tokenSnapshot) {
        if (tokenSnapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            title: 'MyApp',
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          final token = tokenSnapshot.data;
          if (token == null) {
            return const MaterialApp(
              title: 'MyApp',
              home: LoginView(),
            );
          } else {
            return const MaterialApp(
              title: 'MyApp',
              home: HomePage(),
            );
          }
        }
      },
    );
  }
}
