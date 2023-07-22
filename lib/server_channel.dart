import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/login_user_db.dart' as login_user_db;
import 'package:dart_discord/server_utilities.dart' as server_utilities;
import 'package:dart_discord/login_user.dart' as login_user;
import 'package:dart_discord/moderator.dart' as moderator;

class ServerMessage {
  String messageContents;
  String? dateTime;
  String sentBy;

  ServerMessage(this.messageContents, this.sentBy) {
    dateTime = DateTime.now().toString().substring(0, 19);
  }

  Map<String, dynamic> messageObject() {
    return {
      "messageContents": messageContents,
      "dateTime": dateTime,
      "sentBy": sentBy,
    };
  }
}

class Channel {
  String channelName;
  List<dynamic> messageLog = [];
  String channelCategory;
  bool onlyModAccess;
  String channelType;

  Channel(this.channelName, this.channelCategory, this.onlyModAccess,
      this.channelType);

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

class Server {
  String serverName;
  String ownerUsername;
  List<String> moderatorList = [];
  List<String> usersList = [];
  List<dynamic> channels = [];
  Map<String, List<String>> categoryToUsers = {};
  Map<String, List<String>> categoryToChannels = {};

  Server(this.serverName, this.ownerUsername);

  Map<String, dynamic> serverObject() {
    return {
      "serverName": serverName,
      "ownerUsername": ownerUsername,
      "usersList": usersList,
      "channels": channels,
      "moderatorList": moderatorList,
      "categoryToUsers": categoryToUsers,
      "categoryToChannels": categoryToChannels,
    };
  }
}

void createServer(serverName) {
  try {
    final ownerUsername = login_user_db.loggedInUser()['username'];
    final server = Server(serverName, ownerUsername);
    final servers = database.readServerDatabase();
    servers.add(server.serverObject());
    database.writeServerDatabase(servers);
    print("The server $serverName was created!");
  } catch (e) {
    print("You need to login to create a server");
  }
}

void addChannel(
    serverName, channelName, categoryName, onlyModAccess, channelType) {
  final channel =
      Channel(channelName, categoryName, onlyModAccess, channelType);
  final servers = database.readServerDatabase();

  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);
  final server = servers[serverIndex];

  if (serverIndex != -1 &&
      server['ownerUsername'] == login_user_db.loggedInUser()['username']) {
    server['channels'].add(channel.channelObject());
    server['categoryToChannels'][categoryName].add(channelName);
    database.writeServerDatabase(servers);
  } else {
    print("The server with the given name does not exist");
  }
}

void joinServer(String serverName) {
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  try {
    final userName = login_user_db.loggedInUser()['username'];

    if (serverIndex != -1 &&
        server_utilities.isInServer(userName, serverName) == false) {
      servers[serverIndex]['usersList'].add(userName);
      database.writeServerDatabase(servers);
      print("Sever was joined successfully!");
    } else {
      if (serverIndex == -1) {
        print("The server with the given name does not exist");
      } else {
        if (login_user.inDatabase(userName) != true) {
          print("The user does not exist");
        } else {
          print("You are already in this server");
        }
      }
    }
  } catch (e) {
    print("login in order to join a server");
  }
}

void sendMessageOnChannel(String channelName, String messageContents,
    String serverName, String categoryName) {
  final message =
      ServerMessage(messageContents, login_user_db.loggedInUser()['username']);
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
            isModOnly == false ||
        moderator.isModerator(username, serverName)) {
      channelsInServer[channelIndex]['messageLog'].add(message.messageObject());
      database.writeServerDatabase(servers);
      print("Message sent successfully!");
    }
  } else {
    print("Either the server or the channel doesn't exist");
  }
}

void printMessages(String serverName, String channelName) {
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  List<dynamic> channelsInServer = servers[serverIndex]['channels'];
  final channelIndex = channelsInServer
      .indexWhere((channel) => channel['channelName'] == channelName);

  for (final message in channelsInServer[channelIndex]['messageLog']) {
    print("Sender's Username: ${message['sentBy']}\n"
        "Time: ${message['dateTime']}\n"
        "Message: ${message['messageContents']}\n");
  }
}

void printServer(String serverName) {
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  if (serverIndex != -1 &&
      server_utilities.isInServer(
          login_user_db.loggedInUser()['username'], serverName)) {
    for (final user in servers[serverIndex]['userList']) {
      print("$user\n");
    }
  } else {
    if (serverIndex == -1) {
      print("The server does not exist");
    } else {
      print("login and join server in order to view");
    }
  }
}

void joinCategory(String categoryName, String serverName) {
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  final username = login_user_db.loggedInUser()['username'];

  if (server_utilities.isInServer(username, serverName)) {
    final server = servers[serverIndex];
    server['categoryToUsers'][categoryName].add(username);
    database.writeServerDatabase(servers);
  } else {
    print("join server in order to join categories");
  }
}
