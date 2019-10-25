import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromJson(jsonData);
}

String userToJson(User data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class User {
  String userId;
  String name;
  String phonenumber;
  String email;
  String role;
  bool hasSport;
  String sportName;
  String sportId;

  User(
      {this.userId,
      this.name,
      this.phonenumber,
      this.email,
      this.role,
      this.hasSport,
      this.sportName,
      this.sportId});

  factory User.fromJson(Map<String, dynamic> json) => new User(
        userId: json["userId"],
        name: json["name"],
        phonenumber: json["phonenumber"],
        email: json["email"],
        role: json["role"],
        hasSport: json["hasSport"],
        sportName: json["sportName"],
        sportId: json["sportId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "phonenumber": phonenumber,
        "email": email,
        "role": role,
        "hasSport": hasSport,
        "sportName": sportName,
        "sportId": sportId,
      };

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}
