import 'package:dart_discord/login_user_db.dart' as login_user_db;
import 'package:dart_discord/categories.dart' as categories;
import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/moderator.dart' as moderator;
import 'package:dart_discord/server_utilities.dart' as server_utilities;
import 'package:dart_discord/server_channel.dart' as server_channel;

enum ChannelType { text, voice, stage, rules, announcement }

final red = '\u001b[31m';
final green = '\u001b[32m';
final reset = '\u001b[0m';

class Channel {
  String channelName;
  List<dynamic> messageLog = [];
  String channelCategory;
  String? onlyModAccess;
  String channelType;

  Channel(this.channelName, this.channelCategory, this.channelType) {
    if (channelType == ChannelType.text.name ||
        channelType == ChannelType.announcement.name) {
      onlyModAccess = "false";
    } else {
      onlyModAccess = "true";
    }
  }

  Map<String, dynamic> channelObject() {
    return {
      "channelName": channelName,
      "messageLog": messageLog,
      "channelCategory": channelCategory,
      "onlyModAccess": onlyModAccess,
      "channelType": channelType,
    };
  }
}

void addChannel(serverName, channelName, categoryName, channelType) {
  final channel = Channel(channelName, categoryName, channelType);
  final servers = database.readServerDatabase();

  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  if (serverIndex != -1) {
    final server = servers[serverIndex];
    if (serverIndex != -1 &&
        server['ownerUsername'] == login_user_db.loggedInUser()['username']) {
      server['channels'].add(channel.channelObject());

      if (categories.categoryExists(serverName, categoryName) == true) {
        final category =
            categories.returnCategoryInServer(serverName, categoryName);
        category['channelsInCategory'].add(categoryName);
      } else {
        final newCategory = categories.Category(categoryName);
        newCategory.channelsInCategory.add(channelName);
        server['categories'].add(newCategory.categoryObject());
      }

      database.writeServerDatabase(servers);
      print(
          "${green}Channel $channelName in $categoryName was created successfully!$reset");
    } else {
      print(
          "${red}Only the owner of the server could create a new channel$reset");
    }
  } else {
    print("${red}The server with the given name does not exist$reset");
  }
}

void sendMessageOnChannel(String channelName, String messageContents,
    String serverName, String categoryName) {
  final message = server_channel.ServerMessage(
      messageContents, login_user_db.loggedInUser()['username']);
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  final channelsInServer = servers[serverIndex]['channels'];
  final channelIndex = channelsInServer
      .indexWhere((channel) => channel['channelName'] == channelName);

  final username = login_user_db.loggedInUser()['username'];

  final isModOnly = channelsInServer[channelIndex]['onlyModAccess'];

  if (serverIndex != -1 && channelIndex != -1) {
    if (server_utilities.userIsInCategory(categoryName, serverName) == true &&
            isModOnly == "false" ||
        servers[serverIndex]['ownerUsername'] == username ||
        moderator.isModerator(username, serverName)) {
      channelsInServer[channelIndex]['messageLog'].add(message.messageObject());
      database.writeServerDatabase(servers);
      print("${green}Message sent successfully!$reset");
    } else {
      print(
          "${red}You don't have the access to send messages on the channel $channelName$reset");
    }
  } else {
    print("${red}Either the server or the channel doesn't exist$reset");
  }
}

String returnChannelType(String serverName, String channelName) {
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  List<dynamic> channelsInServer = servers[serverIndex]['channels'];
  final channelIndex = channelsInServer
      .indexWhere((channel) => channel['channelName'] == channelName);

  final channelType = channelsInServer[channelIndex]['channelType'];
  return channelType;
}
