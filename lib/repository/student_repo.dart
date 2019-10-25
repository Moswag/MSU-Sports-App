import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:msu_chat_app/constants/db_constants.dart';
import 'package:msu_chat_app/constants/myconstants.dart';
import 'package:msu_chat_app/models/join_sport.dart';

class StudentRepo {
  static Future<bool> joinSport(JoinSport sport) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_JOIN_SPORT + "/${sport.id}")
          .setData(sport.toJson());
      print("Successfully joined ${sport.sportId}");
      return true;
    } catch (e) {
      return false;
    }
  }

  static getCoach(String sportId) {
    print("Get coach function called");
    return Firestore.instance
        .collection(DBConstants.TABLE_USERS)
        .where('role', isEqualTo: SportsConstants.ROLE_COACH)
        .where('sportId', isEqualTo: sportId)
        .getDocuments();
  }

  static didStudentJoin(String userId, String sportId) {
    print("Get coach function called");
    return Firestore.instance
        .collection(DBConstants.TABLE_JOIN_SPORT)
        .where('userId', isEqualTo: userId)
        .where('sportId', isEqualTo: sportId)
        .getDocuments();
  }
}
