import 'package:dart_discord/register_user.dart' as register_user;
import 'package:dart_discord/login_user.dart' as login_user;
import 'dart:io';

void main() {
  print("Welcome to our CLI Applicatiion!\nWhat would you like to do?");
  stdout.write("Login  Register (L/R): ");
  String? initialCommand = stdin.readLineSync();

  if (initialCommand == "R") {
    stdout.write("Enter Username: ");
    String? userName = stdin.readLineSync();

    stdout.write("Enter Password: ");
    String? password = stdin.readLineSync();
    stdout.write("Confirm Password: ");
    String? confirmPassword = stdin.readLineSync();

    if (password == confirmPassword) {
      String? passwordHash = register_user.hashPassword(password);

      register_user.User user = register_user.User(userName!, passwordHash);
      register_user.saveUser(user);
    } else {
      print("Sorry, the passwords do not match");
    }
  } else if (initialCommand == "L") {
    stdout.write("Enter Username: ");
    String? userName = stdin.readLineSync();

    if (login_user.inDatabase(userName)) {
      stdout.write("Enter Password: ");
      String? password = stdin.readLineSync();

      if (login_user.isCorrectPassword(password)) {
        print("Congratulatioons! Now you are logged in");
      } else {
        print("Incorrect Password");
      }
    } else {
      print("Sorry, the user does not exist");
    }
  }
}
