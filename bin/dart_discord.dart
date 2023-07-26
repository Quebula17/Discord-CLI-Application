import 'dart:io';
import 'package:dart_discord/direct_message.dart' as direct_message;
import 'package:dart_discord/register_user.dart' as register_user;
import 'package:dart_discord/login_user.dart' as login_user;
import 'package:dart_discord/utilities.dart' as utilities;
import 'package:dart_discord/server_channel.dart' as server_channel;
import 'package:dart_discord/moderator.dart' as moderator;
import 'package:dart_discord/channels.dart' as channels;
import 'package:dart_discord/server_utilities.dart' as server_utilities;

final red = '\u001b[31m';
final green = '\u001b[32m';
final reset = '\u001b[0m';
final blue = '\u001b[34m';
final yellow = '\u001b[33m';

void main(List<String> args) {
  if (args.isEmpty) {
    print('${red}Please provide a command $reset');
  } else {
    final command = args[0];

    if (command == 'register') {
      if (args.length != 2) {
        print("${blue}Usage: dartcord register <username>$reset");
        return;
      }
      final username = args[1];
      final password = utilities.promptForPassword("Enter Password: ");
      final confirmPassword = utilities.promptForPassword("Confirm Password: ");

      if (password == confirmPassword) {
        register_user.saveUser(username, password!);
      } else {
        print("${red}Passwords do not match$reset");
      }
    } else if (command == 'login') {
      if (args.length != 2) {
        print('${blue}Usage: dartcord login <username>$reset');
        return;
      }

      final username = args[1];
      final password = utilities.promptForPassword("Enter Password: ");

      final loggedIn = login_user.logIn(username, password!);
      print(loggedIn
          ? '${green}Login successful$reset'
          : '${red}Login failed$reset');

      if (loggedIn) {
        final unreadMessages = utilities.totalUnreadMessages();
        if (unreadMessages != 0) {
          print("${yellow}You currently have $unreadMessages unread messages\n"
              "Write 'dartcord print received' to see received messages$reset");
        }
      }
    } else if (command == 'send') {
      if (args.length != 2) {
        print("${blue}Usage: dartcord send <receiver's username>$reset");
        return;
      }
      stdout.write("${blue}Enter message contents: $reset");
      final messageString = stdin.readLineSync();
      final receiverUsername = args[1];

      direct_message.sendMessage(receiverUsername, messageString!);
    } else if (command == 'logout') {
      if (args.length != 1) {
        print("${blue}sage: dartcord logout$reset");
        return;
      }
      login_user.logOut();
    } else if (command == 'print') {
      if (args.length != 2) {
        print(
            "${blue}Usage: dartcord print received\ndartcord print sent$reset");
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
        print("${blue}Usage: dartcord showserver <server name>$reset");
        return;
      }
      final serverName = args[1];
      server_channel.printServer(serverName);
    } else if (command == "createserver") {
      if (args.length != 2) {
        print("${blue}Usage: dartcord createserver <server name>$reset");
      }
      final serverName = args[1];
      server_channel.createServer(serverName);
    } else if (command == "joinserver") {
      if (args.length != 2) {
        print("${blue}Usage: dartcord joinserver <server name>$reset");
        return;
      }
      final serverName = args[1];
      server_channel.joinServer(serverName);
    } else if (command == "addmod") {
      if (args.length != 3) {
        print(
            "${blue}Usage: dartcord addmod <moderator username> <server name>$reset");
        return;
      }

      final moderatorName = args[1];
      final serverName = args[2];
      moderator.addMod(moderatorName, serverName);
    } else if (command == "message") {
      if (args.length != 4) {
        print(
            "${blue}Usage: dartcord message <channel name> <category name> <server name>$reset");
        return;
      }
      final channelName = args[1];
      final categoryName = args[2];
      final serverName = args[3];

      stdout.write("${blue}Enter message contents: $reset");
      final messageString = stdin.readLineSync();

      channels.sendMessageOnChannel(
          channelName, messageString!, serverName, categoryName);
    } else if (command == "createchannel") {
      if (args.length != 4) {
        print(
            "${blue}Usage: dartcord createchannel <channel name> <category name> <server name>$reset");
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
        print("${red}Enter a valid channel type$reset");
      }
    } else if (command == "servermessage") {
      if (args.length != 3) {
        print(
            "${blue}Usage: dartcord servermessage <server name> <channel name>$reset");
        return;
      }
      final serverName = args[1];
      final channelName = args[2];

      server_channel.printMessages(serverName, channelName);
    } else if (command == "exit") {
      if (args.length != 2) {
        print("${blue}Usage: dartcord exit <server name>$reset");
        return;
      }

      final serverName = args[1];
      server_utilities.exitServer(serverName);
    } else if (command == "terminate") {
      if (args.length != 1) {
        print("${blue}Usage: dartcord terminate$reset");
        return;
      }

      utilities.deleteUserAccount();
    } else if (command == "printmod") {
      if (args.length != 2) {
        print("${blue}Usage: dartcord printmod <server name>$reset");
        return;
      }
      final serverName = args[1];
      moderator.printModerators(serverName);
    } else if (command == "removemod") {
      if (args.length != 3) {
        print(
            "${blue}Usage: dartcord removemod <moderator name> <server name>$reset");
        return;
      }
      final moderatorName = args[1];
      final serverName = args[2];

      moderator.removeMod(moderatorName, serverName);
    } else {
      print(
          "${red}Incorrect command, refer README.md on 'https://github.com/Quebula17/dart_discord'$reset");
    }
  }
}
