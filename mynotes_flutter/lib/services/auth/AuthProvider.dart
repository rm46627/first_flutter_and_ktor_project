import 'package:http/http.dart' as http;

import 'User.dart';

abstract class AuthProvider {
  Future<void> initialize();

  User? get currentUser;

  Future<http.Response> logIn({
    required String username,
    required String password,
  });

  Future<http.Response> createUser({
    required String username,
    required String email,
    required String password,
  });

  Future<http.Response> activate({required String usernameOrEmail, required String password, required String code});

  Future<void> logOut();
}
