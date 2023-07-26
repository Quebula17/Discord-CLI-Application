import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/login_user.dart';
import 'package:dart_discord/login_user_db.dart' as login_user_db;
import 'dart:io';
import 'dart:math';
import 'package:dart_discord/server_utilities.dart' as server_utilities;

final red = '\u001b[31m';
final green = '\u001b[32m';
final reset = '\u001b[0m';
final blue = '\u001b[34m';
final yellow = '\u001b[33m';

void deleteUserAccount() {
  final users = database.readUserDatabase();
  final username = login_user_db.loggedInUser()['username'];

  final servers = database.readServerDatabase();

  if (username != null) {
    final userIndex = database.returnUserIndex(username);
    final password = promptForPassword("Enter Password: ");

    if (isCorrectPassword(username, password!)) {
      if (users[userIndex]['serversJoined'] != []) {
        for (final server in users[userIndex]['serversJoined']) {
          final serverIndex = database.returnServerIndex(server);
          server_utilities.exitServer(server);

          if (servers[serverIndex]['ownerUsername'] == username) {
            if (servers[serverIndex]['usersList'].length != 0) {
              var randomIndex =
                  Random().nextInt(servers[serverIndex]['usersList'].length);
              servers[serverIndex]['ownerUsername'] =
                  servers[serverIndex]['usersList'][randomIndex];
              database.writeServerDatabase(servers);
            } else {
              servers.removeAt(serverIndex);
              database.writeServerDatabase(servers);
            }
          }
        }
      }

      users.removeAt(userIndex);
      login_user_db.logOutUser();
      database.writeUserDatabase(users);

      print("${yellow}Your account was successfully deleted$reset");
    } else {
      print("${red}Incorrect password entered$reset");
    }
  } else {
    print("${red}You are currently logged out$reset");
  }
}

void messagesRead() {
  final username = login_user_db.loggedInUser()['username'];
  final userIndex = database.returnUserIndex(username);

  final users = database.readUserDatabase();
  for (final message in users[userIndex]['receivedMessages']) {
    message['isRead'] == true;
  }
  database.writeUserDatabase(users);
}

int totalUnreadMessages() {
  int counter = 0;
  final username = login_user_db.loggedInUser()['username'];
  final userIndex = database.returnUserIndex(username);

  final users = database.readUserDatabase();
  for (final message in users[userIndex]['receivedMessages']) {
    if (message['isRead'] == false) {
      counter++;
    }
  }
  return counter;
}

String? promptForPassword(String prompt) {
  stdout.write("$blue$prompt$reset");
  stdin.echoMode = false;
  final password = stdin.readLineSync();
  stdin.echoMode = true;
  stdout.write("\n");

  return password;
}
