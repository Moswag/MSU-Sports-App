import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:msu_chat_app/constants/db_constants.dart';
import 'package:msu_chat_app/models/Sport.dart';

class AdminRepo {
  static Future<bool> addSport(Sport sport) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_SPORTS + "/${sport.id}")
          .setData(sport.toJson());
      print("Sport added");
      return true;
    } catch (e) {
      return false;
    }
  }
}
