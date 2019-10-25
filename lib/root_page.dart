import 'package:flutter/material.dart';
import 'package:msu_chat_app/constants/myconstants.dart';
import 'package:msu_chat_app/models/state.dart';
import 'package:msu_chat_app/ui/screens/sign_in.dart';
import 'package:msu_chat_app/util/auth.dart';
import 'package:msu_chat_app/util/state_widget.dart';

import 'ui/screens/admin/view_students.dart';
import 'ui/screens/coach/view_posts.dart';
import 'ui/screens/student/ViewSports.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  State createState() => _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  StateModel appState;
  bool _loadingVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null)) {
      return SignInScreen();
    } else {
      if (appState.isLoading) {
        _loadingVisible = true;
      } else {
        _loadingVisible = false;
      }

      final userId = appState?.firebaseUserAuth?.uid ?? '';
      final email = appState?.firebaseUserAuth?.email ?? '';
      final name = appState?.user?.name ?? '';
      final role = appState?.user?.role ?? '';

      switch (authStatus) {
        case AuthStatus.notSignedIn:
          return new SignInScreen(
            auth: widget.auth,
            onSignedIn: _signedIn,
          );

        case AuthStatus.signedIn:
          if (role == SportsConstants.ROLE_ADMIN) {
            return ViewStudents();
          } else if (role == SportsConstants.ROLE_COACH) {
            return ViewPosts();
          } else if (role == SportsConstants.ROLE_STUDENT) {
            return ViewSports();
          } else {
            return CircularProgressIndicator();
          }
      }
    }
  }
}
