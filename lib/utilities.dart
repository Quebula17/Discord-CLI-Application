import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/login_user.dart';
import 'package:dart_discord/login_user_db.dart' as login_user_db;
import 'dart:io';
import 'dart:math';
import 'package:dart_discord/server_utilities.dart' as server_utilities;

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

      print("Your account was successfully deleted");
    } else {
      print("Incorrect password entered");
    }
  } else {
    print("You are currently logged out");
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
  stdout.write(prompt);
  stdin.echoMode = false;
  final password = stdin.readLineSync();
  stdin.echoMode = true;
  stdout.write("\n");

  return password;
}

void showCommands() {
  print("discord register <username> <password>\n");
  print('discord login <username> <password>\n');
  print('discord login <username> <password>\n');
  print("discord send <receiver's username>\n");
  print("discord logout\n");
  print("discord print received and discord print sent\n");
  print("discord showserver <server name>\n");
  print("discord createserver <server name>\n");
  print("discord joinserver <server name>\n");
  print("discord addmod <moderator username> <server name>\n");
  print("discord message <channel name> <category name> <server name>\n");
  print(
      "discord createchannel <channel name> <category name> <server name> <onlyMod access> <channel type>\n");
}
