import 'dart:io';
import 'dart:convert';

List<dynamic> readUserDatabase() {
  List<dynamic> users = [];
  final file = File('users.db');

  if (file.existsSync()) {
    final jsonString = file.readAsStringSync();
    users = jsonDecode(jsonString) as List<dynamic>;
  }

  return users;
}

void writeUserDatabase(List<dynamic> users) {
  final file = File('users.db');
  final jsonString = jsonEncode(users);
  file.writeAsStringSync(jsonString);
}

List<dynamic> readServerDatabase() {
  List<dynamic> servers = [];
  final file = File('servers.db');

  if (file.existsSync()) {
    final jsonString = file.readAsStringSync();
    servers = jsonDecode(jsonString) as List<dynamic>;
  }

  return servers;
}

void writeServerDatabase(List<dynamic> servers) {
  final file = File('servers.db');
  final jsonString = jsonEncode(servers);
  file.writeAsStringSync(jsonString);
}

int returnUserIndex(String userName) {
  final users = readUserDatabase();
  final userIndex = users.indexWhere((user) => user['username'] == userName);

  return userIndex;
}

int returnServerIndex(String serverName) {
  final servers = readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);
  return serverIndex;
}
