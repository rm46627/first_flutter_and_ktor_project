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

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticationResponse(
      token: json['token'] as String,
      userId: json['userId'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }
}
