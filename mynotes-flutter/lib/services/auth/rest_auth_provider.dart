import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mynotes/assets/constants.dart' as constants;
import 'package:mynotes/services/auth/AuthenticationResponse.dart';
import 'package:mynotes/services/auth/user.dart';

import 'auth_provider.dart';

class RestAuthProvider implements AuthProvider {
  final _storage = const FlutterSecureStorage();
  User? user;

  @override
  User get currentUser => user ?? const User(id: 0, username: "0", email: "0", role: "0");

  @override
  Future<void> initialize() async {}

  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getAuthToken() async {
    return _storage.read(key: 'auth_token');
  }

  Future<void> deleteAuthToken() async {
    await _storage.delete(key: 'auth_token');
    return;
  }

  @override
  Future<http.Response> createUser(
      {required String username, required String email, required String password}) async {
    Map data = {'username': username, 'email': email, 'password': password};
    var uri = Uri.parse(constants.API_REGISTER_URL);
    var body = json.encode(data);
    var response =
        await http.post(uri, headers: {"Content-Type": "application/json"}, body: body);
    return response;
  }

  @override
  Future<http.Response> logIn({
    required String username,
    required String password,
  }) async {
    Map data = {'usernameOrEmail': username, 'password': password};
    var uri = Uri.parse(constants.API_LOGIN_URL);
    var body = json.encode(data);
    var response =
        await http.post(uri, headers: {"Content-Type": "application/json"}, body: body);
    saveUserAndToken(response);
    return response;
  }

  @override
  Future<void> logOut() async {
    return deleteAuthToken();
  }

  @override
  Future<http.Response> activate(
      {required String usernameOrEmail,
      required String password,
      required String code}) async {
    Map data = {'usernameOrEmail': usernameOrEmail, 'password': password};
    var uri = Uri.parse(constants.API_ACTIVATE_URL + code);
    var body = json.encode(data);
    var response =
        await http.post(uri, headers: {"Content-Type": "application/json"}, body: body);
    saveUserAndToken(response);
    return response;
  }

  void saveUserAndToken(http.Response response) {
    var authResponse =
        AuthenticationResponse.fromJson(response.body as Map<String, dynamic>);
    saveAuthToken(authResponse.token);
    user = User(
        id: authResponse.userId,
        username: authResponse.username,
        email: authResponse.email,
        role: authResponse.role);
  }

  @override
  Future<bool> checkIfTokenIsValid() async {
    final url = Uri.parse(constants.API_TOKEN_CHECK);
    final token = await getAuthToken();
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200 ? true : false;
  }
}
