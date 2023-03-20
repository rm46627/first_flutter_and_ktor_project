import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> saveAuthToken(String token) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: 'auth_token', value: token);
}

Future<String?> getAuthToken() async {
  const storage = FlutterSecureStorage();
  return storage.read(key: 'auth_token');
}

Future<void> deleteAuthToken() async {
  const storage = FlutterSecureStorage();
  return storage.delete(key: 'auth_token');
}
