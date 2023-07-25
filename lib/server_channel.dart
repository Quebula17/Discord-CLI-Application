import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/login_user_db.dart' as login_user_db;
import 'package:dart_discord/server_utilities.dart' as server_utilities;
import 'package:dart_discord/login_user.dart' as login_user;
import 'package:dart_discord/channels.dart' as channels;

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

class Server {
  String serverName;
  String ownerUsername;
  List<String> moderatorList = [];
  List<String> usersList = [];
  List<dynamic> channels = [];
  List<dynamic> categories = [];

  Server(this.serverName, this.ownerUsername);

  Map<String, dynamic> serverObject() {
    return {
      "serverName": serverName,
      "ownerUsername": ownerUsername,
      "usersList": usersList,
      "channels": channels,
      "moderatorList": moderatorList,
      "categories": categories,
    };
  }
}

void createServer(serverName) {
  try {
    final ownerUsername = login_user_db.loggedInUser()['username'];
    final server = Server(serverName, ownerUsername);

    final servers = database.readServerDatabase();
    final users = database.readUserDatabase();
    final userIndex = database.returnUserIndex(ownerUsername);

    servers.add(server.serverObject());
    database.writeServerDatabase(servers);

    users[userIndex]['serversJoined'].add(serverName);
    database.writeUserDatabase(users);
    print("The server $serverName was created!");
  } catch (e) {
    print("You need to login to create a server");
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

      final users = database.readUserDatabase();
      final userIndex = database.returnUserIndex(userName);

      users[userIndex]['serversJoined'].add(serverName);
      database.writeUserDatabase(users);
      print("Sever $serverName was joined successfully!");
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

void printMessages(String serverName, String channelName) {
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  if (serverIndex != -1) {
    List<dynamic> channelsInServer = servers[serverIndex]['channels'];
    final channelIndex = channelsInServer
        .indexWhere((channel) => channel['channelName'] == channelName);

    if (channelIndex != -1) {
      for (final message in channelsInServer[channelIndex]['messageLog']) {
        print("Sender's Username: ${message['sentBy']}\n"
            "Time: ${message['dateTime']}\n"
            "Message: ${message['messageContents']}\n"
            "Channel Type: ${channels.returnChannelType(serverName, channelName)}");
      }
    } else {
      print(
          "The channel $channelName does not exits in the server $serverName");
    }
  } else {
    print("The server $serverName does not exist");
  }
}

void printServer(String serverName) async {
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  if (serverIndex != -1 &&
      server_utilities.isInServer(
          login_user_db.loggedInUser()['username'], serverName)) {
    print("Printing users in server $serverName...");
    for (final user in servers[serverIndex]['usersList']) {
      print("$user");
      await Future.delayed(Duration(seconds: 2));
    }
  } else {
    if (serverIndex == -1) {
      print("The server does not exist");
    } else {
      print("login and join server in order to view");
    }
  }
}
