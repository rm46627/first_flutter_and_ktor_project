import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mynotes/assets/constants.dart' as constants;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _password;

  var isLoading = false;

  String _hintTextHolder = "Fill all the information's.";

  changeHintText(int status) {
    setState(() {
      switch (status) {
        case 409:
          _hintTextHolder = "Username or email already taken!";
          break;
        case 403:
          _hintTextHolder = "Registration data must not be blank!";
          break;
        case 200:
          _hintTextHolder =
              "Registered successfully! \nCheck your email for activation code.";
          break;
        default:
          _hintTextHolder = "Fill all the information's.";
      }
    });
  }

  @override
  void initState() {
    _username = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              _hintTextHolder,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            TextField(
              controller: _username,
              decoration:
                  const InputDecoration(hintText: 'Enter your username'),
            ),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: const InputDecoration(hintText: 'Enter your email'),
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
            Builder(builder: (context) {
              return buildRegisterButton();
            }),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildRegisterButton() {
    return SizedBox(
      height: 35.0,
      width: 100.0,
      child: ElevatedButton(
        onPressed: () {
          FutureBuilder(
              future: registerUser(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator(
                      backgroundColor: Colors.blue);
                }
                return Container();
              });
        },
        child: isLoading
            ? const SizedBox(
                height: 25.0,
                width: 25.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : const Text("Register"),
      ),
    );
  }

  Future<http.Response> registerUser() async {
    setState(() => isLoading = true);
    Map data = {
      'username': _username.text,
      'email': _email.text,
      'password': _password.text
    };
    var uri = Uri.parse(constants.API_REGISTER_URL);
    var body = json.encode(data);
    var response = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    changeHintText(response.statusCode);
    print(response.statusCode);
    setState(() => isLoading = false);
    return response;
  }
}
