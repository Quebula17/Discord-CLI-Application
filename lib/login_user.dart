import 'package:dart_discord/register_user.dart' as register_user;
import 'package:dart_discord/database.dart' as database;
import 'package:dart_discord/login_user_db.dart' as login_user_db;

Map<String, dynamic> concernedUser = {};

bool inDatabase(String userName) {
  bool isInDatabase = false;

  final users = database.readUserDatabase();
  for (final user in users) {
    if (user['username'] == userName) {
      isInDatabase = true;
      concernedUser = user;
      break;
    }
  }

  return isInDatabase;
}

bool isCorrectPassword(String password) {
  bool isCorrect = false;
  final hashedPassword = register_user.hashPassword(password);
  if (concernedUser['password'] == hashedPassword) {
    isCorrect = true;
  }

  return isCorrect;
}

bool logIn(String userName, String password) {
  if (inDatabase(userName) == true && isCorrectPassword(password) == true) {
    login_user_db.logInUser(concernedUser);
    return true;
  } else {
    concernedUser = {};
    return false;
  }
}
