import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> saveAuthToken(String token) async {
  final storage = FlutterSecureStorage();
  await storage.write(key: 'auth_token', value: token);
}

Future<String?> getAuthToken() async {
  final storage = FlutterSecureStorage();
  return storage.read(key: 'auth_token');
}
