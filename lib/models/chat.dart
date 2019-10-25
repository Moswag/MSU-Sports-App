import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Chat userFromJson(String str) {
  final jsonData = json.decode(str);
  return Chat.fromJson(jsonData);
}

String userToJson(Chat data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Chat {
  String chatType;
  String userName;
  String to;
  String from;
  String time;
  String message;

  Chat(
      {this.chatType,
      this.userName,
      this.to,
      this.from,
      this.time,
      this.message});

  factory Chat.fromJson(Map<String, dynamic> json) => new Chat(
      chatType: json["chatType"],
      userName: json["userName"],
      to: json["to"],
      from: json["from"],
      time: json["time"],
      message: json["message"]);

  Map<String, dynamic> toJson() => {
        "chatType": chatType,
        "userName": userName,
        "to": to,
        "from": from,
        "time": time,
        "message": message
      };

  factory Chat.fromDocument(DocumentSnapshot doc) {
    return Chat.fromJson(doc.data);
  }
}
