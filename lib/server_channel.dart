import 'package:dart_discord/database.dart' as database;

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
  String? channelName;
  List<String> moderatorList = [];
  List<dynamic> messageLog = [];

  Channel(this.channelName);

  Map<String, dynamic> channelObject() {
    return {
      "moderatorList": moderatorList,
      "messageLog": messageLog,
    };
  }
}

class Server {
  String serverName;
  String ownerUsername;
  List<String> usersJoinedList = [];
  List<dynamic> channels = [];

  Server(this.serverName, this.ownerUsername);

  Map<String, dynamic> serverObject() {
    return {
      "serverName": serverName,
      "ownerUsername": ownerUsername,
      "usersJoinedList": usersJoinedList,
      "channels": channels,
    };
  }
}

void createServer(serverName, ownerUsername) {
  final server = Server(serverName, ownerUsername);
  final servers = database.readServerDatabase();
  servers.add(server.serverObject());
  database.writeServerDatabase(servers);
}

void addChannel(serverName, channelName) {
  final channel = Channel(channelName);
  final servers = database.readServerDatabase();

  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  if (serverIndex != -1) {
    servers[serverIndex]['channels'].add(channel.channelObject());
  } else {
    print("The server with the given name does not exist");
  }
}

void addMod(moderatorName, serverName, channelName) {
  final servers = database.readServerDatabase();
  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  List<dynamic> channelsInServer = servers[serverIndex]['channels'];
  final channelIndex = channelsInServer
      .indexWhere((channel) => channel['channelName'] == channelName);

  if (serverIndex != -1 && channelIndex != -1) {
    channelsInServer[channelIndex]['moderatorList'].add(moderatorName);
  } else {
    print("Either the server or the channel doesn't exist");
  }
}

void joinServer(String serverName, String userName) {
  final servers = database.readServerDatabase();

  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  if (serverIndex != -1) {
    servers[serverIndex]['usersJoinedList'].add(userName);
  } else {
    print("The server with the given name does not exist");
  }
}

void sendMessageOnChannel(String channelName, String messageContents,
    String senderName, String serverName) {
  final message = ServerMessage(messageContents, senderName);
  final servers = database.readServerDatabase();

  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  List<dynamic> channelsInServer = servers[serverIndex]['channels'];
  final channelIndex = channelsInServer
      .indexWhere((channel) => channel['channelName'] == channelName);

  if (serverIndex != -1 && channelIndex != -1) {
    channelsInServer[channelIndex]['messageLog'].add(message.messageObject());
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
