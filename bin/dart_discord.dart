import 'dart:io';
import 'package:dart_discord/direct_message.dart' as direct_message;
import 'package:dart_discord/register_user.dart' as register_user;
import 'package:dart_discord/login_user.dart' as login_user;
import 'package:dart_discord/utilities.dart' as utilities;
import 'package:dart_discord/server_channel.dart' as server_channel;
import 'package:dart_discord/moderator.dart' as moderator;

void main(List<String> args) {
  if (args.isEmpty) {
    print('Please provide a command');
  } else {
    final command = args[0];

    if (command == 'register') {
      if (args.length != 3) {
        print("Usage: discord register <username> <password>");
        return;
      }
      final username = args[1];
      final password = args[2];

      register_user.saveUser(username, password);
    } else if (command == 'login') {
      if (args.length != 3) {
        print('Usage: discord login <username> <password>');
        return;
      }

      final username = args[1];
      final password = args[2];

      final loggedIn = login_user.logIn(username, password);
      print(loggedIn ? 'Login successful' : 'Login failed');

      if (loggedIn) {
        final unreadMessages = utilities.totalUnreadMessages();
        if (unreadMessages != 0) {
          print("You currently have $unreadMessages unread messages\n"
              "Write 'discord received messsages' to see received messages");
        }
      }
    } else if (command == 'send') {
      if (args.length != 2) {
        print("Usage: discord send <receiver's username>");
        return;
      }
      stdout.write("Enter message contents: ");
      final messageString = stdin.readLineSync();
      final receiverUsername = args[1];

      direct_message.sendMessage(receiverUsername, messageString!);
    } else if (command == 'logout') {
      if (args.length != 1) {
        print("Usage: discord logout");
        return;
      }
      login_user.logOut();
    } else if (command == 'print') {
      if (args.length != 2) {
        print("Usage: discord print received and discord print sent");
        return;
      } else {
        if (args[1] == "received") {
          direct_message.printReceivedMessages();
        } else if (args[1] == "sent") {
          direct_message.printSentMessages();
        }
      }
    } else if (command == "showserver") {
      if (args.length != 2) {
        print("Usage: discord showserver <server name>");
        return;
      }
      final serverName = args[1];
      server_channel.printServer(serverName);
    } else if (command == "createserver") {
      if (args.length != 2) {
        print("Usage: discord createserver <server name>");
      }
      final serverName = args[1];
      server_channel.createServer(serverName);
    } else if (command == "joinserver") {
      if (args.length != 2) {
        print("Usage: discord joinserver <server name>");
        return;
      }
      final serverName = args[1];
      server_channel.joinServer(serverName);
    } else if (command == "addmod") {
      if (args.length != 3) {
        print("Usage: discord addmod <moderator username> <server name>");
        return;
      }

      final moderatorName = args[1];
      final serverName = args[2];
      moderator.addMod(moderatorName, serverName);
    } else if (command == "message") {
      if (args.length != 4) {
        print(
            "Usage: discord message <channel name> <category name> <server name>");
        return;
      }
      final channelName = args[1];
      final categoryName = args[2];
      final serverName = args[3];

      stdout.write("Enter message contents: ");
      final messageString = stdin.readLineSync();

      server_channel.sendMessageOnChannel(
          channelName, messageString!, serverName, categoryName);
    } else if (command == "commands") {
      register_user.showCommands();
    } else {
      print("Incorrect command, watchOut for documentation!");
    }
  }
}
