import 'package:crypt/crypt.dart';
import 'package:dart_discord/register_user.dart' as register_user;
import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/login_user_db.dart' as login_user_db;

Map<String, dynamic> concernedUser = {};

bool inDatabase(String userName) {
  bool isInDatabase = false;
  final users = database.readUserDatabase();
  final userIndex = database.returnUserIndex(userName);

  if (userIndex != -1) {
    isInDatabase = true;
    concernedUser = users[userIndex];
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
      login_user_db.loggedInUser()['username'] != userName) {
    login_user_db.logInUser(
        register_user.User(userName, register_user.hashPassword(password))
            .userObject());
    return true;
  } else {
    if (inDatabase(userName) == false) {
      print("the user does not exist");
    } else if (isCorrectPassword(userName, password) == false) {
      print("incorrect password entered");
    } else if (login_user_db.loggedInUser()['username'] == userName) {
      print("you are already logged in");
    } else {
      print("you need to logout before you can login with another account");
    }
    return false;
  }
}

void logOut() {
  final loggedInUser = login_user_db.loggedInUser();
  if (loggedInUser != {}) {
    login_user_db.logOutUser();
    print("User logged out successfully");
  } else {
    print("You aren't logged in");
  }
}
