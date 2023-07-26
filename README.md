# DartCord

This is a CLI tool which emulates and functions like discord developed as an assignment submission on Dart by [Information Management Group](https://github.com/IMGIITRoorkee).

## About

DartCord helps you to socialise and interact with the comfort of your terminal!\
Users can register, login and send personal messages to other users or can go ahead and make servers and channels. DartCord was made in and also gets its name from Dart.

## Quick Start Guide

To use this project, you need to have Dart SDK installed on your system. If you haven't installed Dart, you can download it from the official website: [Dart SDK](https://dart.dev/get-dart).

Once you have Dart installed, you can follow these steps to run the project:

1. Clone the repository to your local machine:
   ```bash
   $ git clone (SSH Key)

2. Run the command:
    ```bash
    $ dart pub global activate --source path .

3. Run the following command to get all the required dependencies:
    ``` bash
    $ dart pub get
    ```

4. Now you can use the 'dartcord' command in your terminal and interact with the CLI.

## Commands

DartCord has various of features and can be accessed from a list of commands used in the Terminal. Here is a list of commands with a brief description of its usage:

* This will prompt the user to enter and confirm a password after user enters a username of their choice, success upon which the user will be registered on the CLI application.

```bash
$ dartcord register <username>
```

* This will prompt the user to enter his password, and if the password is correct, the user would login into the application.

```bash
$ dartcord login <username>
```

* This will prompt you to enter message contents which will be sent to the person whose username is provided.

```bash
$ dartcord send <receiver username>
```

* This will print the messages sent or received by the user respectively.

```bash
$ dartcord print sent
```

```bash
$ dartcord print received
```


* This will create a server with no channels initially and the user will be the owner of the server.

```bash
$ dartcord createserver <server name>
```


* This will make the user currently logged in join the server with the given servername.

```bash
$ dartcord joinserver <receiver username>
``` 


* This will add a moderator to the server. A moderator is a role with a special status, and has permission to send message on every channel in the server.
Only the owner of the server could promote a user in the server to a moderator.

```bash
$ dartcord addmod <moderator username> <server name>
```


* This will demote the user from the role of moderator to that of a base user and could only be used by the owner of the server.

```bash
$ dartcord removemod <moderator username> <server name>
```

* This will print the list of the moderators in the given server.

```bash
$ dartcord printmod <server name>
```

* This will print all the users' usernmes currently in the server onto the Terminal.

```bash
$ dartcord showserver <server name>
```

* This will create a channel in th server with the given access to users along with the channel category and channel type. Message can only be sent without any permission in Text and Announcement Channels. Other channels require mod access to send a message (Channel type could be any of them: Text, Voice, Stage, Rules, Announcement).

```bash
$ dartcord createchannel <channel name> <category name> <server name>
```

* This would prompt user to enter message contents which will subsequently be sent to the corresponding channel in the server.
```bash
$ dartcord message <channel name> <category name> <server name>
```

* This will print all the messages sent by the users in the corresponding channel of the server.

```bash
$ dartcord servermessage <server name> <channel name>
```

* This will exit the user currently logged in from the given server unless the user is the owner of the server.

```bash
$ dartcord exit <server name>
```

* In case you chose to terminate you account in the application, running this command will delete your userdata and exit you from every server. If you are the owner of the server and there are people besides you, any random person will be made the owner of the channel, otherwise the channel woulf be deleted. (This cannot be undone!)

```bash
$ dartcord terminate
```

## Authors

[Saurabh Rana](https://github.com/Quebula17)

## Mentors

[Aryan Ranjan](https://github.com/just-ary27)

## License

Licensed under the [MIT License](https://github.com/Quebula17/dart_discord/blob/main/LICENSE)

