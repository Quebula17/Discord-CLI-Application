import 'dart:io';
import 'dart:convert';

List<dynamic> readUserDatabase() {
  List<dynamic> users = [];
  final file = File('users.json');

  if (file.existsSync()) {
    final jsonString = file.readAsStringSync();
    users = jsonDecode(jsonString) as List<dynamic>;
  }

  return users;
}

void writeUserDatabase(List<dynamic> users) {
  final file = File('users.json');
  final jsonString = jsonEncode(users);
  file.writeAsStringSync(jsonString);
}

List<dynamic> readServerDatabase() {
  List<dynamic> servers = [];
  final file = File('servers.json');

  if (file.existsSync()) {
    final jsonString = file.readAsStringSync();
    servers = jsonDecode(jsonString) as List<dynamic>;
  }

  return servers;
}

void writeServerDatabase(List<dynamic> servers) {
  final file = File('servers.json');
  final jsonString = jsonEncode(servers);
  file.writeAsStringSync(jsonString);
}

int returnUserIndex(String userName) {
  final users = readUserDatabase();
  final userIndex = users.indexWhere((user) => user['username'] == userName);

  return userIndex;
}
