import 'package:crypt/crypt.dart';
import 'package:dart_discord/direct_message.dart' as direct_message;
import 'package:dart_discord/database.dart' as database;

class User {
  String userName;
  String passwordHash;

  List<dynamic> sentMessageLog = [];
  List<dynamic> receivedMessageLog = [];

  User(this.userName, this.passwordHash);

  Map<String, dynamic> userObject() {
    return {
      "username": userName,
      "password": passwordHash,
      "sentMessages": sentMessageLog,
      "receivedMessages": receivedMessageLog,
    };
  }
}

String hashPassword(String password) {
  final hashedPassword = Crypt.sha256(password).toString();
  return hashedPassword;
}

void saveUser(String userName, String password) {
  if (direct_message.inDatabase(userName) == false) {
    final user = User(userName, hashPassword(password));
    final users = database.readUserDatabase();
    users.add(user.userObject());
    database.writeUserDatabase(users);
    print("Registered successfully!\n"
        "Login to start messaging!");
  } else {
    print("Username taken, enter another username");
  }
}
