import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/server_utilities.dart' as server_utilities;
import 'package:dart_discord/login_user_db.dart' as login_user_db;

final red = '\u001b[31m';
final green = '\u001b[32m';
final reset = '\u001b[0m';
final yellow = '\u001b[33m';

void addMod(moderatorName, serverName) {
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  if (serverIndex != -1 &&
      server_utilities.isInServer(moderatorName, serverName) == true &&
      login_user_db.loggedInUser()['username'] ==
          servers[serverIndex]['ownerUsername']) {
    servers[serverIndex]['moderatorList'].add(moderatorName);
    database.writeServerDatabase(servers);
    print("$green$moderatorName was made moderator successfully!$reset");
  } else {
    if (serverIndex == -1) {
      print("${red}The server with the given name does not exist$reset");
    } else if (server_utilities.isInServer(moderatorName, serverName) != true) {
      print("${red}The user is not currently a part of the server$reset");
    } else {
      print("${red}Only the owner can assign mod roles$reset");
    }
  }
}

List<dynamic> returnModerators(String serverName) {
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);
  final moderatorList = servers[serverIndex]['moderatorList'];
  return moderatorList;
}

bool isModerator(String userName, String serverName) {
  bool isMod = false;
  final moderatorList = returnModerators(serverName);
  final moderatorIndex = moderatorList.indexWhere((user) => user == userName);

  if (moderatorIndex != -1) {
    isMod = true;
    return isMod;
  } else {
    return isMod;
  }
}

void printModerators(String serverName) async {
  final userName = login_user_db.loggedInUser()['username'];
  if (userName != null) {
    if (server_utilities.isInServer(userName, serverName)) {
      print("Printing moderators in server $serverName");
      final moderatorList = returnModerators(serverName);
      if (moderatorList.isNotEmpty) {
        for (final moderator in moderatorList) {
          print("$yellow$moderator$reset");
          await Future.delayed(Duration(seconds: 2));
        }
      } else {
        print("${red}No moderators in the server $serverName currently$reset");
      }
    }
  }
}

void removeMod(moderatorName, serverName) {
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  if (serverIndex != -1 &&
      isModerator(moderatorName, serverName) == true &&
      login_user_db.loggedInUser()['username'] ==
          servers[serverIndex]['ownerUsername']) {
    servers[serverIndex]['moderatorList'].remove(moderatorName);
    database.writeServerDatabase(servers);
    print("$green$moderatorName was removed as moderator successfully$reset");
  } else {
    if (serverIndex == -1) {
      print("${red}The server with the given name does not exist$reset");
    } else if (server_utilities.isInServer(moderatorName, serverName) != true) {
      print("${red}The user is not currently a part of the server$reset");
    } else if (isModerator(moderatorName, serverName) != true) {
      print(
          "${red}The user $moderatorName is not a moderator in $serverName$reset");
    } else {
      print("${red}Only the owner can remove mod roles$reset");
    }
  }
}
