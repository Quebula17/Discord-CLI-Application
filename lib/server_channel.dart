import 'dart:io';
import 'dart:convert';

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
  List<dynamic> servers = [];
  final file = File('servers.json');

  if (file.existsSync()) {
    final jsonString = file.readAsStringSync();
    servers = jsonDecode(jsonString) as List<dynamic>;
  }

  servers.add(server.serverObject());
  final jsonString = jsonEncode(servers);
  file.writeAsStringSync(jsonString);
}

void addChannel(serverName, channelName) {
  final channel = Channel(channelName);
  List<dynamic> servers = [];
  final file = File('servers.json');

  if (file.existsSync()) {
    final jsonString = file.readAsStringSync();
    servers = jsonDecode(jsonString) as List<dynamic>;
  }

  final serverIndex =
      servers.indexWhere((server) => server['serverName'] == serverName);

  if (serverIndex != -1) {
    servers[serverIndex]['channels'].add(channel.channelObject());
  } else {
    print("The server with the given name does not exist");
  }
}

void addMod(moderatorName, serverName, channelName) {
  List<dynamic> servers = [];
  final file = File('servers.json');

  if (file.existsSync()) {
    final jsonString = file.readAsStringSync();
    servers = jsonDecode(jsonString) as List<dynamic>;
  }

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

//Join server, Send Message on Channel, Print Messages, write the main script and make it a package

void joinServer(String serverName, String userName) {
  List<dynamic> servers = [];
  final file = File('servers.json');

  if (file.existsSync()) {
    final jsonString = file.readAsStringSync();
    servers = jsonDecode(jsonString) as List<dynamic>;
  }

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

  List<dynamic> servers = [];
  final file = File('servers.json');

  if (file.existsSync()) {
    final jsonString = file.readAsStringSync();
    servers = jsonDecode(jsonString) as List<dynamic>;
  }

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
  List<dynamic> servers = [];
  final file = File('servers.json');

  if (file.existsSync()) {
    final jsonString = file.readAsStringSync();
    servers = jsonDecode(jsonString) as List<dynamic>;
  }

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
