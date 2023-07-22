import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/login_user.dart';
import 'package:dart_discord/login_user_db.dart' as login_user_db;

void deleteUserAccount(String password) {
  final users = database.readUserDatabase();
  int userIndex =
      database.returnUserIndex(login_user_db.loggedInUser()['username']);

  if (isCorrectPassword(users[userIndex]['username'], password)) {
    users.removeAt(userIndex);
    database.writeUserDatabase(users);

    print("Your account was successfully deleted");
  } else {
    print("Incorrect password");
  }
}

void messagesRead() {
  final username = login_user_db.loggedInUser()['username'];
  final userIndex = database.returnUserIndex(username);

  final users = database.readUserDatabase();
  for (final message in users[userIndex]['receivedMessages']) {
    message['isRead'] == true;
  }
  database.writeUserDatabase(users);
}

int totalUnreadMessages() {
  int counter = 0;
  final username = login_user_db.loggedInUser()['username'];
  final userIndex = database.returnUserIndex(username);

  final users = database.readUserDatabase();
  for (final message in users[userIndex]['receivedMessages']) {
    if (message['isRead'] == false) {
      counter++;
    }
  }
  return counter;
}
