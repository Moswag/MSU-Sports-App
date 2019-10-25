import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:msu_chat_app/constants/db_constants.dart';
import 'package:msu_chat_app/constants/myconstants.dart';
import 'package:msu_chat_app/models/Notice.dart';
import 'package:msu_chat_app/models/chat.dart';
import 'package:msu_chat_app/models/post.dart';

class CoachRepo {
  static Future<bool> addPost(Post post) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_POSTS + "/${post.id}")
          .setData(post.toJson());
      print("Post added");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addNotice(Notice notice) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_NOTICES + "/${notice.id}")
          .setData(notice.toJson());
      print("Notice added");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Chat>> getChats(String userId) async {
    Chat chat;
    List<Chat> lchats = [];

    Firestore.instance
        .collection(DBConstants.TABLE_CHAT_ROOM)
        .where('chatType', isEqualTo: SportsConstants.CHAT_PERSONAL)
        .orderBy("time", descending: false)
        .snapshots()
        .listen((data) {
      data.documents.forEach((doc) async {
        chat = new Chat();
        chat.chatType = doc["chatType"];
        chat.userName = doc["userName"];
        chat.from = doc["from"];
        chat.to = doc["to"];
        chat.message = doc["message"];
        chat.time = doc["time"];

        if (chat.to == userId) {
          if (!(lchats.toString().contains(chat.from))) {
            lchats.add(chat);
          } else {
            //agara aripo
          }
        } else {
          //not dzako
        }
      });
    });

    print('Chats successfuly pulled');

    return lchats;
  }

  static Future<List<Chat>> getPersonalChats(
      String userId, String fromId) async {
    Chat chat;
    List<Chat> lchats = [];

    Firestore.instance
        .collection(DBConstants.TABLE_CHAT_ROOM)
        .where('chatType', isEqualTo: SportsConstants.CHAT_PERSONAL)
        //.orderBy("time", descending: true)
        .snapshots()
        .listen((data) {
      data.documents.forEach((doc) async {
        chat = new Chat();
        chat.chatType = doc["chatType"];
        chat.userName = doc["userName"];
        chat.from = doc["from"];
        chat.to = doc["to"];
        chat.message = doc["message"];
        chat.time = doc["time"];

        if ((chat.to == userId && chat.from == fromId) ||
            (chat.to == fromId && chat.from == userId)) {
          lchats.add(chat);
        } else {
          //agara aripo
        }
      });
    });

    print('Chats successfuly pulled');

    return lchats;
  }
}
