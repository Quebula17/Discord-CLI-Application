import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/login_user_db.dart' as login_user_db;

class Message {
  String messageContents;
  String? dateTime;
  String sentBy;
  String receivedBy;
  bool isRead = false;

  Message(this.messageContents, this.sentBy, this.receivedBy) {
    dateTime = DateTime.now().toString().substring(0, 19);
  }

  Map<String, dynamic> messageObject() {
    return {
      "messageContents": messageContents,
      "dateTime": dateTime,
      "sentBy": sentBy,
      "receivedBy": receivedBy,
      "isRead": isRead,
    };
  }
}

bool inDatabase(String userName) {
  bool isInDatabase = false;
  final userIndex = database.returnUserIndex(userName);

  if (userIndex != -1) {
    isInDatabase = true;
    return isInDatabase;
  } else {
    return isInDatabase;
  }
}

void sendMessage(String receiverUsername, String messageString) {
  final senderUsername = login_user_db.loggedInUser()['username'];
  if (inDatabase(receiverUsername) == true &&
      senderUsername != receiverUsername) {
    final message = Message(messageString, senderUsername, receiverUsername);
    final users = database.readUserDatabase();

    final senderIndex = database.returnUserIndex(senderUsername);
    users[senderIndex]['sentMessages'].add(message.messageObject());
    final receiverIndex = database.returnUserIndex(receiverUsername);
    users[receiverIndex]['receivedMessages'].add(message.messageObject());

    database.writeUserDatabase(users);
    print("Message sent to $receiverUsername successfully!");
  } else {
    if (senderUsername == receiverUsername) {
      print("You cannot send message to yourself!");
    } else {
      print("User with given username doesn't exist");
    }
  }
}

void printReceivedMessages() {
  final users = database.readUserDatabase();
  final receiverIndex =
      database.returnUserIndex(login_user_db.loggedInUser()['username']);

  if (users[receiverIndex]['receivedMessages'] != []) {
    for (final message in users[receiverIndex]['receivedMessages']) {
      print("Sender's Username: ${message['sentBy']}\n"
          "Time: ${message['dateTime']}\n"
          "Message: ${message['messageContents']}\n");
    }
  } else {
    print("No messages to show");
  }
}

void printSentMessages() {
  final users = database.readUserDatabase();
  final senderIndex =
      database.returnUserIndex(login_user_db.loggedInUser()['username']);

  if (users[senderIndex]['sentMessages'] != []) {
    for (final message in users[senderIndex]['sentMessages']) {
      print("Receiver's Username: ${message['receivedBy']}\n"
          "Time: ${message['dateTime']}\n"
          "Message: ${message['messageContents']}\n");
    }
  } else {
    print("No messages to show");
  }
}
