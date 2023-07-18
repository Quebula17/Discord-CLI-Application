import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';
// import 'package:dart_discord/direct_message.dart' as direct_message;

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
  final file = File('users.json');
  List<dynamic> users = [];

  if (file.existsSync()) {
    final jsonString = file.readAsStringSync();
    users = jsonDecode(jsonString) as List<dynamic>;
  }

  users.add(user.userObject());
  final jsonString = jsonEncode(users);
  file.writeAsStringSync(jsonString);
}
