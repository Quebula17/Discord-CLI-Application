// import 'package:dart_discord/server_channel.dart' as server_channel;
import 'package:dart_discord/database.dart' as database;

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
