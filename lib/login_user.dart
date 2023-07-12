import 'dart:convert';
import 'dart:io';
import 'package:dart_discord/register_user.dart' as register_user;

Map<String, dynamic> concernedUser = {};

List<Map<String, dynamic>> readUsers() {
  final file = File('users.json');
  if (!file.existsSync()) {
    return [];
  }
  final jsonString = file.readAsStringSync();
  final jsonData = jsonDecode(jsonString) as List<dynamic>;

  return jsonData.cast<Map<String, dynamic>>();
}

bool inDatabase(String? userName) {
  bool isInDatabase = false;

  final users = readUsers();
  for (final user in users) {
    if (user['username'] == userName) {
      isInDatabase = true;
      concernedUser = user;
      break;
    }
  }

  return isInDatabase;
}

bool isCorrectPassword(String? password) {
  bool isCorrect = false;
  final hashedPassword = register_user.hashPassword(password);
  if (concernedUser['password'] == hashedPassword) {
    isCorrect = true;
  }

  concernedUser = {};
  return isCorrect;
}
