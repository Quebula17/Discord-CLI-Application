import 'package:crypt/crypt.dart';
import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/login_user.dart' as login_user;

final red = '\u001b[31m';
final green = '\u001b[32m';
final reset = '\u001b[0m';

class User {
  String userName;
  String passwordHash;

  List<dynamic> sentMessageLog = [];
  List<dynamic> receivedMessageLog = [];
  List<dynamic> serversJoined = [];

  User(this.userName, this.passwordHash);

  Map<String, dynamic> userObject() {
    return {
      "username": userName,
      "password": passwordHash,
      "sentMessages": sentMessageLog,
      "receivedMessages": receivedMessageLog,
      "serversJoined": serversJoined,
    };
  }
}

String hashPassword(String password) {
  final hashedPassword = Crypt.sha256(password).toString();
  return hashedPassword;
}

void saveUser(String userName, String password) {
  if (login_user.inDatabase(userName) == false) {
    final user = User(userName, hashPassword(password));
    final users = database.readUserDatabase();
    users.add(user.userObject());
    database.writeUserDatabase(users);
    print("${green}Registered successfully\nLogin to start messaging!$reset");
  } else {
    print("${red}Username taken, enter another username$reset");
  }
}
