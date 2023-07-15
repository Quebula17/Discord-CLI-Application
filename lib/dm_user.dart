import 'dart:io';
import 'package:dart_discord/register_user.dart' as register_user;
import 'dart:convert';

class Message{
  int? timestamp;
  String? message;
  register_user.User? sender;
  register_user.User? receiver;

  Message(this.message, this.sender, this.receiver){
    this.timestamp = DateTime.now().millisecondsSinceEpoch;
  }

  void save_dm(register_user.User sender, register_user.User receiver, String message){
    Message msg = Message(message, sender, receiver);
    final file = File('users.json');
    List<dynamic> users = [];
    List<dynamic> list_sent = sender.sent;
    List<dynamic> list_received = receiver.received;

    if (file.existsSync()) {
      final jsonString = file.readAsStringSync();
      users = jsonDecode(jsonString) as List<dynamic>;
    }
    list_sent.add(msg);
    list_received.add(msg);
    users.forEach((element) {
      if(element.username == sender.username) element.sent = list_sent;
      else if(element.username == receiver.username) element.received = list_received;
    });
    
    final jsonString = jsonEncode(users);
    file.writeAsStringSync(jsonString);
  }

  void display_dm(register_user.User current_login, int? total){
    if(total == null) total = 10;
    final file = File('users.json');
    if (file.existsSync()){
      List<dynamic> list_received = current_login.received;
      int count = 0;
      for(int i=list_received.length; i>=0; i--){
        print(list_received[i].message);
        count++;
        if(count >= total) break;
      }
    }
  }
}

