import 'package:http/http.dart' as http;
import 'package:mynotes/services/auth/AuthProvider.dart';
import 'package:mynotes/services/auth/User.dart';
import 'package:mynotes/services/auth/restAuthProvider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.build() => AuthService(RestAuthProvider());

  @override
  Future<http.Response> activate(
          {required String usernameOrEmail,
          required String password,
          required String code}) =>
      provider.activate(usernameOrEmail: usernameOrEmail, password: password, code: code);

  @override
  Future<http.Response> createUser(
          {required String username, required String email, required String password}) =>
      provider.createUser(username: username, email: email, password: password);

  @override
  User? get currentUser => provider.currentUser;

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<http.Response> logIn({required String username, required String password}) =>
      provider.logIn(username: username, password: password);

  @override
  Future<void> logOut() => provider.logOut();
}
