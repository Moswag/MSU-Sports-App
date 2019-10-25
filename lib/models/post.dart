import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String userId;
  String sportId;
  String title;
  String description;
  String imageUrl;
  String dateCreated;

  Post(
      {this.id,
      this.userId,
      this.sportId,
      this.title,
      this.imageUrl,
      this.description,
      this.dateCreated});

  factory Post.fromJson(Map<String, dynamic> json) => new Post(
      id: json["id"],
      userId: json["userId"],
      sportId: json["sportId"],
      title: json["title"],
      imageUrl: json["imageUrl"],
      description: json["description"],
      dateCreated: json["dateCreated"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "sportId": sportId,
        "title": title,
        "imageUrl": imageUrl,
        "description": description,
        "dateCreated": dateCreated
      };

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post.fromJson(doc.data);
  }
}
