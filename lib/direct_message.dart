import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/login_user_db.dart' as login_user_db;
import 'package:dart_discord/utilities.dart' as utilities;
import 'package:dart_discord/login_user.dart' as login_user;

final red = '\u001b[31m';
final green = '\u001b[32m';
final reset = '\u001b[0m';
final yellow = '\u001b[33m';

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

void sendMessage(String receiverUsername, String messageString) {
  final senderUsername = login_user_db.loggedInUser()['username'];
  if (login_user.inDatabase(receiverUsername) == true &&
      senderUsername != receiverUsername) {
    final message = Message(messageString, senderUsername, receiverUsername);
    final users = database.readUserDatabase();

    final senderIndex = database.returnUserIndex(senderUsername);
    users[senderIndex]['sentMessages'].add(message.messageObject());
    final receiverIndex = database.returnUserIndex(receiverUsername);
    users[receiverIndex]['receivedMessages'].add(message.messageObject());

    database.writeUserDatabase(users);
    print("${green}Message sent to $receiverUsername successfully!$reset");
  } else {
    if (senderUsername == receiverUsername) {
      print("${red}You cannot send message to yourself$reset");
    } else {
      print("${red}User with given username doesn't exist$reset");
    }
  }
}

void printReceivedMessages() {
  final users = database.readUserDatabase();
  final receiverIndex =
      database.returnUserIndex(login_user_db.loggedInUser()['username']);

  if (users[receiverIndex]['receivedMessages'] != []) {
    for (final message in users[receiverIndex]['receivedMessages']) {
      print("${yellow}Sender's Username: ${message['sentBy']}\n"
          "Time: ${message['dateTime']}\n"
          "Message: ${message['messageContents']}\n$reset");
    }
    utilities.messagesRead();
  } else {
    print("${red}No messages to show on terminal$reset");
  }
}

void printSentMessages() {
  final users = database.readUserDatabase();
  final senderIndex =
      database.returnUserIndex(login_user_db.loggedInUser()['username']);

  if (users[senderIndex]['sentMessages'] != []) {
    for (final message in users[senderIndex]['sentMessages']) {
      print("${yellow}Receiver's Username: ${message['receivedBy']}\n"
          "Time: ${message['dateTime']}\n"
          "Message: ${message['messageContents']}\n$reset");
    }
  } else {
    print("${red}No messages to show$reset");
  }
}
