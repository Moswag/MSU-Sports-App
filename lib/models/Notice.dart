import 'package:cloud_firestore/cloud_firestore.dart';

class Notice {
  String id;
  String userId;
  String sportId;
  String head;
  String body;
  String dateCreated;

  Notice(
      {this.id,
      this.userId,
      this.sportId,
      this.head,
      this.body,
      this.dateCreated});

  factory Notice.fromJson(Map<String, dynamic> json) => new Notice(
      id: json["id"],
      userId: json["userId"],
      sportId: json["sportId"],
      head: json["head"],
      body: json["body"],
      dateCreated: json["dateCreated"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "sportId": sportId,
        "head": head,
        "body": body,
        "dateCreated": dateCreated
      };

  factory Notice.fromDocument(DocumentSnapshot doc) {
    return Notice.fromJson(doc.data);
  }
}
