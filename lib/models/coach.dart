import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Coach userFromJson(String str) {
  final jsonData = json.decode(str);
  return Coach.fromJson(jsonData);
}

String userToJson(Coach data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Coach {
  String userId;
  String name;
  String phonenumber;
  String email;
  String sportId;
  String sportName;
  String role;

  Coach({
    this.userId,
    this.name,
    this.phonenumber,
    this.sportId,
    this.sportName,
    this.email,
    this.role,
  });

  factory Coach.fromJson(Map<String, dynamic> json) => new Coach(
        userId: json["userId"],
        name: json["name"],
        phonenumber: json["phonenumber"],
        sportId: json["sportId"],
        sportName: json["sportName"],
        email: json["email"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "phonenumber": phonenumber,
        "sportId": sportId,
        "sportName": sportName,
        "email": email,
        "role": role,
      };

  factory Coach.fromDocument(DocumentSnapshot doc) {
    return Coach.fromJson(doc.data);
  }
}
