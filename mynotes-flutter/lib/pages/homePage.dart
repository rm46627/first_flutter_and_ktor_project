import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mynotes/assets/constants.dart' as constants;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController username;
  late final TextEditingController email;
  late final TextEditingController password;

  @override
  void initState() {
    username = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Column(
        children: [
          TextField(
            controller: username,
            decoration: const InputDecoration(hintText: 'Enter your username'),
          ),
          TextField(
            controller: email,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          TextField(
            controller: password,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          TextButton(
              onPressed: () async {
                registerUser();
              },
              child: const Text('Register')),
        ],
      ),
    );
  }

  Future<void> registerUser() async {
    Map data = {
      'username': username.text,
      'email': email.text,
      'password': password.text
    };
    var uri = Uri.parse(constants.API_REGISTER_URL);
    var body = json.encode(data);

    var response = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
