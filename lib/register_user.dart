import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:dart_discord/database.dart' as database;

class User {
  String userName;
  String passwordHash;

  List<dynamic> sentMessageLog = [];
  List<dynamic> receivedMessageLog = [];

  User(this.userName, this.passwordHash);

  Map<String, dynamic> userObject() {
    return {
      "username": userName,
      "password": passwordHash,
      "sentMessages": sentMessageLog,
      "receivedMessages": receivedMessageLog,
    };
  }
}

String hashPassword(String? password) {
  final bytes = utf8.encode(password!);
  final hashedBytes = sha256.convert(bytes);

  final hashedPassword = hashedBytes.toString();
  return hashedPassword;
}

void saveUser(User user) {
  final users = database.readUserDatabase();
  users.add(user.userObject());
  database.writeUserDatabase(users);
}
