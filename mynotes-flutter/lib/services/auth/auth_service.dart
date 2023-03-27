import 'package:http/http.dart' as http;
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/rest_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider _provider;
  const AuthService(this._provider);

  factory AuthService.rest() => AuthService(RestAuthProvider());

  @override
  Future<http.Response> activate(
          {required String usernameOrEmail,
          required String password,
          required String code}) =>
      _provider.activate(
          usernameOrEmail: usernameOrEmail, password: password, code: code);

  @override
  Future<http.Response> createUser(
          {required String username, required String email, required String password}) =>
      _provider.createUser(username: username, email: email, password: password);

  @override
  Future<void> initialize() => _provider.initialize();

  @override
  Future<http.Response> logIn({required String username, required String password}) =>
      _provider.logIn(username: username, password: password);

  @override
  Future<void> logOut() => _provider.logOut();

  @override
  Future<bool> checkIfTokenIsValid() => _provider.checkIfTokenIsValid();
}
