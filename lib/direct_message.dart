import 'package:dart_discord/login_user.dart' as login_user;
import 'dart:io';
import 'dart:convert';

class Message {
  String messageContents;
  String? dateTime;
  String sentBy;
  String receivedBy;

  Message(this.messageContents, this.sentBy, this.receivedBy) {
    dateTime = DateTime.now().toString().substring(0, 19);
  }

  Map<String, dynamic> messageObject() {
    return {
      "messageContents": messageContents,
      "dateTime": dateTime,
      "sentBy": sentBy,
      "receivedBy": receivedBy,
    };
  }
}

bool inDatabase(String? userName) {
  bool isInDatabase = false;

  final users = login_user.readUsers();
  for (final user in users) {
    if (user['username'] == userName) {
      isInDatabase = true;
      break;
    }
  }

  return isInDatabase;
}

void sendMessage(
    String senderUsername, String receiverUsername, String messageString) {
  if (inDatabase(senderUsername) == true &&
      messageString.isNotEmpty &&
      senderUsername != receiverUsername) {
    final message = Message(messageString, senderUsername, receiverUsername);
    List<dynamic> users = [];
    final file = File('users.json');

    if (file.existsSync()) {
      final jsonString = file.readAsStringSync();
      users = jsonDecode(jsonString) as List<dynamic>;
    }

    final senderIndex =
        users.indexWhere((user) => user['username'] == senderUsername);
    users[senderIndex]['sentMessages'].add(message.messageObject());

    final receiverIndex =
        users.indexWhere((user) => user['username'] == receiverUsername);
    users[receiverIndex]['receivedMessages'].add(message.messageObject());

    final jsonString = jsonEncode(users);
    file.writeAsStringSync(jsonString);
  }
}

void printReceivedMessages(String receiverUsername) {
  List<dynamic> users = [];
  final file = File('users.json');

  if (file.existsSync()) {
    final jsonString = file.readAsStringSync();
    users = jsonDecode(jsonString) as List<dynamic>;
  }

  final receiverIndex =
      users.indexWhere((user) => user['username'] == receiverUsername);

  for (final message in users[receiverIndex]['receivedMessages']) {
    print("Sender's Username: ${message['sentBy']}\n"
        "Time: ${message['dateTime']}\n"
        "Message: ${message['messageContents']}\n");
  }
}

void printSentMessages(String senderUsername) {
  List<dynamic> users = [];
  final file = File('users.json');

  if (file.existsSync()) {
    final jsonString = file.readAsStringSync();
    users = jsonDecode(jsonString) as List<dynamic>;
  }

  final senderIndex =
      users.indexWhere((user) => user['username'] == senderUsername);

  for (final message in users[senderIndex]['sentMessages']) {
    print("Receiver's Username: ${message['receivedBy']}\n"
        "Time: ${message['dateTime']}\n"
        "Message: ${message['messageContents']}\n");
  }
}
