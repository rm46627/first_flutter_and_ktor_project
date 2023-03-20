class AuthService {
  String _token;

  Future<void> saveAuthToken(String token) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getAuthToken() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: 'auth_token');
  }

  Future<void> deleteAuthToken() async {
    final storage = FlutterSecureStorage();
    return storage.delete(key: 'auth_token');
  }
}
