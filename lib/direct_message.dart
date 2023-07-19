import 'package:dart_discord/database.dart' as database;

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

  final users = database.readUserDatabase();
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
    final users = database.readUserDatabase();

    final senderIndex =
        users.indexWhere((user) => user['username'] == senderUsername);
    users[senderIndex]['sentMessages'].add(message.messageObject());

    final receiverIndex =
        users.indexWhere((user) => user['username'] == receiverUsername);
    users[receiverIndex]['receivedMessages'].add(message.messageObject());
    database.writeUserDatabase(users);
  }
}

void printReceivedMessages(String receiverUsername) {
  final users = database.readUserDatabase();
  final receiverIndex =
      users.indexWhere((user) => user['username'] == receiverUsername);

  if (receiverIndex != -1) {
    for (final message in users[receiverIndex]['receivedMessages']) {
      print("Sender's Username: ${message['sentBy']}\n"
          "Time: ${message['dateTime']}\n"
          "Message: ${message['messageContents']}\n");
    }
  } else {
    print("Enter a valid username");
  }
}

void printSentMessages(String senderUsername) {
  final users = database.readUserDatabase();

  final senderIndex =
      users.indexWhere((user) => user['username'] == senderUsername);

  for (final message in users[senderIndex]['sentMessages']) {
    print("Receiver's Username: ${message['receivedBy']}\n"
        "Time: ${message['dateTime']}\n"
        "Message: ${message['messageContents']}\n");
  }
}
