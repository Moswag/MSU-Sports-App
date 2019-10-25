import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Student userFromJson(String str) {
  final jsonData = json.decode(str);
  return Student.fromJson(jsonData);
}

String userToJson(Student data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Student {
  String userId;
  String name;
  String phonenumber;
  String regNumber;
  String email;
  String role;

  Student({
    this.userId,
    this.name,
    this.phonenumber,
    this.regNumber,
    this.email,
    this.role,
  });

  factory Student.fromJson(Map<String, dynamic> json) => new Student(
        userId: json["userId"],
        name: json["name"],
        phonenumber: json["phonenumber"],
        regNumber: json["regNumber"],
        email: json["email"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "phonenumber": phonenumber,
        "regNumber": regNumber,
        "email": email,
        "role": role,
      };

  factory Student.fromDocument(DocumentSnapshot doc) {
    return Student.fromJson(doc.data);
  }
}
