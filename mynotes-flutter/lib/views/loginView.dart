import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mynotes/assets/constants.dart' as constants;

import '../secure_storage.dart' as auth;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _username;
  late final TextEditingController _password;

  String _hintTextHolder = "Fill all the information's.";

  changeHintText(int status) {
    setState(() {
      switch (status) {
        case 409:
          _hintTextHolder = "Wrong username or password!";
          break;
        case 403:
          _hintTextHolder = "Login data must not be blank!";
          break;
        case 200:
          _hintTextHolder = "Logged in successfully!";
          break;
        default:
          _hintTextHolder = "Fill all the information's.";
      }
    });
  }

  @override
  void initState() {
    _username = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              _hintTextHolder,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            TextField(
              controller: _username,
              decoration: const InputDecoration(
                  hintText: 'Enter your username or email'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: 'Enter your password'),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
                onPressed: () {
                  loginUser();
                },
                child: const Text("Login"))
          ],
        ),
      ),
    );
  }

  Future<http.Response> loginUser() async {
    Map data = {'username': _username.text, 'password': _password.text};
    var uri = Uri.parse(constants.API_LOGIN_URL);
    var body = json.encode(data);
    var response = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    changeHintText(response.statusCode);
    auth.saveAuthToken(response.body);
    print(auth.getAuthToken());
    return response;
  }
}
