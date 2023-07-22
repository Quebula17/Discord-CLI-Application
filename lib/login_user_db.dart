import 'dart:io';
import 'dart:convert';

Map<String, dynamic> loggedInUser() {
  Map<String, dynamic> loggedUser = {};
  final file = File('loggedUser.json');

  if (file.existsSync()) {
    final jsonString = file.readAsStringSync();
    loggedUser = jsonDecode(jsonString) as Map<String, dynamic>;
  } else {
    loggedUser = {};
  }

  return loggedUser;
}

void logInUser(Map<String, dynamic> user) {
  final file = File('loggedUser.json');
  final jsonString = jsonEncode(user);
  file.writeAsStringSync(jsonString);
}

void logOutUser() {
  final file = File('loggedUser.json');
  Map<dynamic, dynamic> jsonString = {};
  file.writeAsStringSync(jsonString.toString());
}
