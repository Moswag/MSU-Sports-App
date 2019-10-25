import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

JoinSport userFromJson(String str) {
  final jsonData = json.decode(str);
  return JoinSport.fromJson(jsonData);
}

String userToJson(JoinSport data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class JoinSport {
  String id;
  String userId;
  String sportId;

  JoinSport({this.id, this.userId, this.sportId});

  factory JoinSport.fromJson(Map<String, dynamic> json) => new JoinSport(
        id: json["id"],
        userId: json["userId"],
        sportId: json["sportId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "sportId": sportId,
      };

  factory JoinSport.fromDocument(DocumentSnapshot doc) {
    return JoinSport.fromJson(doc.data);
  }
}
