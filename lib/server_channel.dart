import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/login_user_db.dart' as login_user_db;
import 'package:dart_discord/server_utilities.dart' as server_utilities;
import 'package:dart_discord/login_user.dart' as login_user;
import 'package:dart_discord/channels.dart' as channels;

final red = '\u001b[31m';
final green = '\u001b[32m';
final reset = '\u001b[0m';
final yellow = '\u001b[33m';

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
    print("${green}The server $serverName was created!$reset");
  } catch (e) {
    print("${red}You need to login to create a server$reset");
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
      print("${green}Sever $serverName was joined successfully!$reset");
    } else {
      if (serverIndex == -1) {
        print("${red}The server with the given name does not exist$reset");
      } else {
        if (login_user.inDatabase(userName) != true) {
          print("${red}The user does not exist$reset");
        } else {
          print("${red}You are already in this server$reset");
        }
      }
    }
  } catch (e) {
    print("${red}Login in order to join a server$reset");
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
        print("${yellow}Sender's Username: ${message['sentBy']}\n"
            "Time: ${message['dateTime']}\n"
            "Message: ${message['messageContents']}\n"
            "Channel Type: ${channels.returnChannelType(serverName, channelName)}$reset");
      }
    } else {
      print(
          "${red}The channel $channelName does not exits in the server $serverName$reset");
    }
  } else {
    print("${red}The server $serverName does not exist$reset");
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
      print("$yellow$user$reset");
      await Future.delayed(Duration(seconds: 2));
    }
  } else {
    if (serverIndex == -1) {
      print("${red}The server does not exist$reset");
    } else {
      print("${red}Login and join server in order to view$reset");
    }
  }
}
