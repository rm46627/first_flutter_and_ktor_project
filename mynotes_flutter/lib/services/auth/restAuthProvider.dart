import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mynotes/assets/constants.dart' as constants;

import 'AuthProvider.dart';
import 'User.dart';
import 'secure_storage.dart' as sec;

class RestAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {}

  @override
  Future<http.Response> createUser(
      {required String username, required String email, required String password}) async {
    Map data = {'username': username, 'email': email, 'password': password};
    var uri = Uri.parse(constants.API_REGISTER_URL);
    var body = json.encode(data);
    var response =
        await http.post(uri, headers: {"Content-Type": "application/json"}, body: body);
    log('register response: $response.statusCode');
    return response;
  }

  @override
  User? get currentUser {
    // TODO: implement get user request
    return null;
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
    sec.saveAuthToken(response.body);
    log('login response: $response.statusCode');
    return response;
  }

  @override
  Future<void> logOut() async {
    sec.deleteAuthToken();
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
    sec.saveAuthToken(response.body);
    log('activate response: $response.statusCode');
    return response;
  }
}
