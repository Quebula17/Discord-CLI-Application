import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/direct_message.dart' as direct_message;
import 'package:dart_discord/login_user_db.dart' as login_user_db;

bool isInServer(String userName, String serverName) {
  bool inServer = false;
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  final usersInServer = servers[serverIndex]['usersList'];
  final userInServerIndex =
      usersInServer.indexWhere((user) => user == userName);

  if (direct_message.inDatabase(userName) == true && userInServerIndex != -1) {
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
    final servers = database.readServerDatabase();
    final serverIndex =
        servers.indexWhere((server) => server['serverName'] == serverName);
    final server = servers[serverIndex];

    final categoryUsersList = server['categoryToUsers'][categoryName];
    final categoryUserIndex =
        categoryUsersList.indexWhere((user) => user == username);

    if (categoryUserIndex != 1) {
      userInCategory = true;
      return userInCategory;
    } else {
      return userInCategory;
    }
  } else {
    print("The user is not in the server");
    return false;
  }
}
