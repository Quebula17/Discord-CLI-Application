import 'dart:io';
import 'package:dart_discord/direct_message.dart' as direct_message;
import 'package:dart_discord/register_user.dart' as register_user;
import 'package:dart_discord/login_user.dart' as login_user;
import 'package:dart_discord/utilities.dart' as utilities;
import 'package:dart_discord/server_channel.dart' as server_channel;
import 'package:dart_discord/moderator.dart' as moderator;
import 'package:dart_discord/channels.dart' as channels;
import 'package:dart_discord/server_utilities.dart' as server_utilities;

void main(List<String> args) {
  if (args.isEmpty) {
    print('Please provide a command!');
  } else {
    final command = args[0];

    if (command == 'register') {
      if (args.length != 2) {
        print("Usage: dartcord register <username>");
        return;
      }
      final username = args[1];
      final password = utilities.promptForPassword("Enter Password: ");
      final confirmPassword = utilities.promptForPassword("Confirm Password: ");

      if (password == confirmPassword) {
        register_user.saveUser(username, password!);
      } else {
        print("Passwords do not match");
      }
    } else if (command == 'login') {
      if (args.length != 2) {
        print('Usage: dartcord login <username>');
        return;
      }

      final username = args[1];
      final password = utilities.promptForPassword("Enter Password: ");

      final loggedIn = login_user.logIn(username, password!);
      print(loggedIn ? 'Login successful' : 'Login failed');

      if (loggedIn) {
        final unreadMessages = utilities.totalUnreadMessages();
        if (unreadMessages != 0) {
          print("You currently have $unreadMessages unread messages\n"
              "Write 'dartcord print received' to see received messages");
        }
      }
    } else if (command == 'send') {
      if (args.length != 2) {
        print("Usage: dartcord send <receiver's username>");
        return;
      }
      stdout.write("Enter message contents: ");
      final messageString = stdin.readLineSync();
      final receiverUsername = args[1];

      direct_message.sendMessage(receiverUsername, messageString!);
    } else if (command == 'logout') {
      if (args.length != 1) {
        print("Usage: dartcord logout");
        return;
      }
      login_user.logOut();
    } else if (command == 'print') {
      if (args.length != 2) {
        print("Usage: dartcord print received\ndartcord print sent");
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
        print("Usage: dartcord showserver <server name>");
        return;
      }
      final serverName = args[1];
      server_channel.printServer(serverName);
    } else if (command == "createserver") {
      if (args.length != 2) {
        print("Usage: dartcord createserver <server name>");
      }
      final serverName = args[1];
      server_channel.createServer(serverName);
    } else if (command == "joinserver") {
      if (args.length != 2) {
        print("Usage: dartcord joinserver <server name>");
        return;
      }
      final serverName = args[1];
      server_channel.joinServer(serverName);
    } else if (command == "addmod") {
      if (args.length != 3) {
        print("Usage: dartcord addmod <moderator username> <server name>");
        return;
      }

      final moderatorName = args[1];
      final serverName = args[2];
      moderator.addMod(moderatorName, serverName);
    } else if (command == "message") {
      if (args.length != 4) {
        print(
            "Usage: dartcord message <channel name> <category name> <server name>");
        return;
      }
      final channelName = args[1];
      final categoryName = args[2];
      final serverName = args[3];

      stdout.write("Enter message contents: ");
      final messageString = stdin.readLineSync();

      channels.sendMessageOnChannel(
          channelName, messageString!, serverName, categoryName);
    } else if (command == "commands") {
      utilities.showCommands();
    } else if (command == "createchannel") {
      if (args.length != 4) {
        print(
            "Usage: dartcord createchannel <channel name> <category name> <server name> ");
        return;
      }
      stdout.write("Enter ChannelType: ");
      final channelType = stdin.readLineSync();

      if (channelType == "text" ||
          channelType == "announcement" ||
          channelType == "stage" ||
          channelType == "voice" ||
          channelType == "rules") {
        final channelName = args[1];
        final categoryName = args[2];
        final serverName = args[3];

        channels.addChannel(serverName, channelName, categoryName, channelType);
      } else {
        print("Enter a valid channel type");
      }
    } else if (command == "servermessage") {
      if (args.length != 3) {
        print("Usage: dartcord servermessage <server name> <channel name>");
        return;
      }
      final serverName = args[1];
      final channelName = args[2];

      server_channel.printMessages(serverName, channelName);
    } else if (command == "exit") {
      if (args.length != 2) {
        print("Usage: dartcord exit <server name>");
        return;
      }

      final serverName = args[1];
      server_utilities.exitServer(serverName);
    } else if (command == "terminate") {
      if (args.length != 1) {
        print("Usage: dartcord terminate");
        return;
      }

      utilities.deleteUserAccount();
    } else {
      print("Incorrect command, watchOut for documentation!");
    }
  }
}
