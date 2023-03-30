import 'package:flutter/cupertino.dart';

@immutable
class AuthenticationResponse {
  final String token;
  final int userId;
  final String username;
  final String email;
  final String role;
  const AuthenticationResponse(
      {required this.token,
      required this.userId,
      required this.username,
      required this.email,
      required this.role});

  AuthenticationResponse.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        userId = json['userId'],
        username = json['username'],
        email = json['email'],
        role = json['role'];
}
