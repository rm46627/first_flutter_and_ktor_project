import 'package:flutter/foundation.dart';

@immutable
class User {
  final int id;
  final String username;
  final String email;
  final String role;
  const User(
      {required this.id,
      required this.username,
      required this.email,
      required this.role});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        email = json['email'],
        role = json['role'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'username': username, 'email': email, 'role': role};
}
