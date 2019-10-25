import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:msu_chat_app/constants/myconstants.dart';
import 'package:msu_chat_app/constants/routes_constants.dart';
import 'package:msu_chat_app/util/no_rights.dart';
import 'package:msu_chat_app/util/state_widget.dart';

class UserManagement {
  authoriseAccess(BuildContext context) async {
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.document("users/${user.uid}").get().then((doc) {
        if (doc.exists) {
          if (doc.data['role'] == SportsConstants.ROLE_STUDENT) {
            Navigator.of(context).pushNamed(MyRoutes.VIEW_HOME);
          } else if (doc.data['role'] == SportsConstants.ROLE_COACH) {
            Navigator.of(context).pushNamed(MyRoutes.VIEW_POSTS);
          } else if (doc.data['role'] == SportsConstants.ROLE_ADMIN) {
            Navigator.of(context).pushNamed(MyRoutes.VIEW_ADMINS);
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => new NoRightsPage()));
          }
        }
      });
    });
  }

  signOut(BuildContext context) {
    StateWidget.of(context).logOutUser();
  }
}
