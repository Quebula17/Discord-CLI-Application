import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/direct_message.dart' as direct_message;
import 'package:dart_discord/login_user_db.dart' as login_user_db;
import 'package:dart_discord/categories.dart' as categories;

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
