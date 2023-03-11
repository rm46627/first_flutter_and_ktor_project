import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mynotes/assets/constants.dart' as constants;
import 'package:mynotes/secure_storage.dart';
import 'package:mynotes/views/homePage.dart';
import 'package:mynotes/views/loginView.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            return FutureBuilder<Map<String, dynamic>>(
              future: _getNotes(token),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return MaterialApp(
                      title: 'MyApp',
                      home: HomePage(snapshot.data),
                    );
                  } else {
                    return const MaterialApp(
                      title: 'MyApp',
                      home: LoginView(),
                    );
                  }
                } else {
                  return const MaterialApp(
                    title: 'MyApp',
                    home: Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
              },
            );
          }
        }
      },
    );
  }
}
