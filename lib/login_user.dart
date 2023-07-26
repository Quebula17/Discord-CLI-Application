import 'package:crypt/crypt.dart';
import 'package:dart_discord/register_user.dart' as register_user;
import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/login_user_db.dart' as login_user_db;

final red = '\u001b[31m';
final green = '\u001b[32m';
final reset = '\u001b[0m';

bool inDatabase(String userName) {
  bool isInDatabase = false;
  final userIndex = database.returnUserIndex(userName);

  if (userIndex != -1) {
    isInDatabase = true;
  }
  return isInDatabase;
}

bool isCorrectPassword(String userName, String password) {
  final users = database.readUserDatabase();
  final userIndex = users.indexWhere((user) => user['username'] == userName);
  final isCorrect = Crypt(users[userIndex]['password']).match(password);
  return isCorrect;
}

bool logIn(String userName, String password) {
  if (inDatabase(userName) == true &&
      isCorrectPassword(userName, password) == true &&
      login_user_db.loggedInUser()['username'] == null) {
    login_user_db.logInUser(
        register_user.User(userName, register_user.hashPassword(password))
            .userObject());
    return true;
  } else {
    if (inDatabase(userName) == false) {
      print("${red}The user $userName does not exist$reset");
    } else if (isCorrectPassword(userName, password) == false) {
      print("${red}Incorrect password entered$reset");
    } else if (login_user_db.loggedInUser()['username'] == userName) {
      print("${red}You are already logged in$reset");
    } else {
      print(
          "${red}You need to logout before you can login with another account$reset");
    }
    return false;
  }
}

void logOut() {
  final loggedInUser = login_user_db.loggedInUser();
  if (loggedInUser != {}) {
    login_user_db.logOutUser();
    print("${green}Logged out successfully$reset");
  } else {
    print("${red}You aren't logged in$reset");
  }
}
