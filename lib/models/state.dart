import 'package:firebase_auth/firebase_auth.dart';
import 'package:msu_chat_app/models/settings.dart';
import 'package:msu_chat_app/models/user.dart';

class StateModel {
  bool isLoading;
  FirebaseUser firebaseUserAuth;
  User user;
  Settings settings;

  StateModel({
    this.isLoading = false,
    this.firebaseUserAuth,
    this.user,
    this.settings,
  });
}
