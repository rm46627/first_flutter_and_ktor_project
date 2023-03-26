import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mynotes/assets/constants.dart' as constants;

import 'authProvider.dart';

class RestAuthProvider implements AuthProvider {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> initialize() async {}

  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getAuthToken() async {
    return _storage.read(key: 'auth_token');
  }

  Future<void> deleteAuthToken() async {
    return _storage.delete(key: 'auth_token');
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
    var token = response.body;
    saveAuthToken(response.body);
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
    saveAuthToken(response.body);
    return response;
  }

  @override
  Future<String?> getCurrentUserToken() {
    return getAuthToken();
  }
}
