import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/server_utilities.dart' as server_utilities;
import 'package:dart_discord/login_user_db.dart' as login_user_db;

final red = '\u001b[31m';
final green = '\u001b[32m';
final reset = '\u001b[0m';

class Category {
  String categoryName;
  List<String> channelsInCategory = [];
  List<String> usersInCategory = [];

  Category(this.categoryName);

  Map<String, dynamic> categoryObject() {
    return {
      "categoryName": categoryName,
      "channelsInCategory": channelsInCategory,
      "usersInCategory": usersInCategory,
    };
  }
}

bool categoryExists(String serverName, String categoryName) {
  bool categoryExists = false;
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  final categoriesInServer = servers[serverIndex]['categories'];
  final categoryIndex = categoriesInServer
      .indexWhere((category) => category['categoryName'] == categoryName);

  if (categoryIndex != -1) {
    categoryExists = true;
    return categoryExists;
  } else {
    return categoryExists;
  }
}

Map<String, dynamic> returnCategoryInServer(
    String serverName, String categoryName) {
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  final categoriesInServer = servers[serverIndex]['categories'];
  final categoryIndex = categoriesInServer
      .indexWhere((category) => category['categoryName'] == categoryName);

  return categoriesInServer[categoryIndex];
}

void joinCategory(String categoryName, String serverName) {
  final servers = database.readServerDatabase();
  final username = login_user_db.loggedInUser()['username'];

  if (server_utilities.isInServer(username, serverName) &&
      categoryExists(serverName, categoryName)) {
    final category = returnCategoryInServer(serverName, categoryName);
    category['usersInCategory'].add(username);
    database.writeServerDatabase(servers);
    print("${green}Joined category $categoryName successfully$reset");
  } else {
    print("${red}Join server in order to join categories$reset");
  }
}
