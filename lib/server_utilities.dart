import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/login_user_db.dart' as login_user_db;
import 'package:dart_discord/categories.dart' as categories;
import 'package:dart_discord/moderator.dart' as moderator;
import 'package:dart_discord/login_user.dart' as login_user;

bool isInServer(String userName, String serverName) {
  bool inServer = false;
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  final usersInServer = servers[serverIndex]['usersList'];
  final userInServerIndex =
      usersInServer.indexWhere((user) => user == userName);

  if (login_user.inDatabase(userName) == true && userInServerIndex != -1 ||
      servers[serverIndex]['ownerUsername'] == userName) {
    inServer = true;
    return inServer;
  } else {
    return inServer;
  }
}

bool userIsInCategory(String categoryName, String serverName) {
  bool userInCategory = false;
  final username = login_user_db.loggedInUser()['username'];
  if (isInServer(username, serverName)) {
    final category =
        categories.returnCategoryInServer(serverName, categoryName);
    final usersList = category['usersInCategory'];
    final userIndex = usersList.indexWhere((user) => user == serverName);

    if (userIndex != 1) {
      userInCategory = true;
      return userInCategory;
    } else {
      print("The user is not in the category");
      return userInCategory;
    }
  } else {
    print("The user is not in the server");
    return false;
  }
}

void exitServer(String serverName) {
  final userName = login_user_db.loggedInUser()['username'];
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);
  if (login_user_db.loggedInUser()['username'] != null &&
      serverIndex != -1 &&
      isInServer(userName, serverName) == true) {
    servers[serverIndex]['usersList'].remove(userName);
    if (moderator.isModerator(userName, serverName)) {
      servers[serverIndex]['moderatorList'].remove(userName);
    }
    database.writeServerDatabase(servers);
    print("Left server $serverName successfully");
  } else {
    if (login_user_db.loggedInUser()['username'] == null) {
      print("You are currently logged out");
    } else if (serverIndex == -1) {
      print("The server $serverName does not exist");
    } else {
      print("You aren't a member of the server");
    }
  }
}
