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
  late final TextEditingController _code;

  String _hintTextHolder = "Fill all the information's.";
  String _hintAlert = 'Activate your account';

  changeHintText(int status) {
    setState(() {
      switch (status) {
        case 419:
          _hintTextHolder = "Need to activate your account first!";
          break;
        case 403:
          _hintTextHolder = "Wrong username or password!";
          break;
        case 200:
          _hintTextHolder = "Logged in successfully!";
          break;
        default:
          _hintTextHolder = "Fill all the information's.";
      }
    });
  }

  changeAlertText(String text) {
    setState(() {
      _hintAlert = text;
    });
  }

  @override
  void initState() {
    _username = TextEditingController();
    _password = TextEditingController();
    _code = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              _hintTextHolder,
              style: const TextStyle(color: Colors.blueGrey),
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
              height: 16,
            ),
            SizedBox(
              height: 35.0,
              width: 75.0,
              child: ElevatedButton(
                  onPressed: () async {
                    clickLoginBtn(context);
                  },
                  child: const Text("Login")),
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                },
                child: const Text(
                  "Sign up here!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }

  void clickLoginBtn(BuildContext context) {
    loginUser().then((value) => {
          if (value.statusCode == 200)
            {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/notes', (route) => false)
            }
          else if (value.statusCode == 419)
            showCodeDialog(context)
        });
  }

  Future<dynamic> showCodeDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => ScaffoldMessenger(
        child: Builder(builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: AlertDialog(
              title: const Text("Activate your account"),
              content: TextField(
                controller: _code,
                decoration: const InputDecoration(
                    hintText: 'Enter special code from email message'),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back')),
                ElevatedButton(
                    onPressed: () {
                      activateUser().then((value) => {
                            if (value.statusCode == 200)
                              {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/notes', (route) => false)
                              }
                            else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text("Wrong code")))
                              }
                          });
                    },
                    child: const Text('Check'))
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<http.Response> loginUser() async {
    Map data = {'usernameOrEmail': _username.text, 'password': _password.text};
    var uri = Uri.parse(constants.API_LOGIN_URL);
    var body = json.encode(data);
    var response = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    changeHintText(response.statusCode);
    auth.saveAuthToken(response.body);
    print(response.statusCode);
    return response;
  }

  Future<http.Response> activateUser() async {
    Map data = {'usernameOrEmail': _username.text, 'password': _password.text};
    var uri = Uri.parse(constants.API_ACTIVATE_URL + _code.text);
    var body = json.encode(data);
    var response = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    changeHintText(response.statusCode);
    auth.saveAuthToken(response.body);
    print(response.statusCode);
    return response;
  }
}
