import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/server_utilities.dart' as server_utilities;
import 'package:dart_discord/login_user_db.dart' as login_user_db;

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
    print("$moderatorName was made moderator successfully");
  } else {
    if (serverIndex == -1) {
      print("The server with the given name does not exist");
    } else if (server_utilities.isInServer(moderatorName, serverName) != true) {
      print("the user is not currently a part of the server");
    } else {
      print("only the owner can assign mod roles");
    }
  }
}

List<String> printModerators(String serverName) {
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);
  final moderatorList = servers[serverIndex]['moderatorList'];
  return moderatorList;
}

bool isModerator(String userName, String serverName) {
  bool isMod = false;
  final moderatorList = printModerators(serverName);
  final moderatorIndex = moderatorList.indexWhere((user) => user == userName);

  if (moderatorIndex != -1) {
    isMod = true;
    return isMod;
  } else {
    return isMod;
  }
}
