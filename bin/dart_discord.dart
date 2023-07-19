import 'package:dart_discord/register_user.dart' as register_user;
import 'package:dart_discord/login_user.dart' as login_user;

void main(List<String> args) {
  if (args.isEmpty) {
    print('Please provide a command: "register" or "login".');
  } else {
    final command = args[0];

    if (command == 'register') {
      if (args.length != 3) {
        print('Usage: discord register <username> <password>');
        return;
      }
      final username = args[1];
      final password = args[2];

      register_user.User user =
          register_user.User(username, register_user.hashPassword(password));
      register_user.saveUser(user);
    } else if (command == 'login') {
      if (args.length != 3) {
        print('Usage: discord login <username> <password>');
        return;
      }

      final username = args[1];
      final password = args[2];

      final loggedIn = login_user.logIn(username, password);
      print(loggedIn ? 'Login successful.' : 'Login failed.');
    }
  }
}
