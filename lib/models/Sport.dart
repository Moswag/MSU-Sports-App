import 'package:cloud_firestore/cloud_firestore.dart';

class Sport {
  String id;
  String name;
  String imageUrl;
  String description;
  String dateCreated;

  Sport(
      {this.id, this.name, this.imageUrl, this.description, this.dateCreated});

  factory Sport.fromJson(Map<String, dynamic> json) => new Sport(
      id: json["id"],
      name: json["name"],
      imageUrl: json["imageUrl"],
      description: json["description"],
      dateCreated: json["dateCreated"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "description": description,
        "dateCreated": dateCreated
      };

  factory Sport.fromDocument(DocumentSnapshot doc) {
    return Sport.fromJson(doc.data);
  }
}
