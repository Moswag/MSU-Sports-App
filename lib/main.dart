import 'package:flutter/material.dart';
import 'package:msu_chat_app/constants/routes_constants.dart';
import 'package:msu_chat_app/ui/screens/coach/view_notices.dart';
import 'package:msu_chat_app/ui/screens/forgot_password.dart';
import 'package:msu_chat_app/ui/screens/sign_in.dart';
import 'package:msu_chat_app/ui/screens/sign_up.dart';
import 'package:msu_chat_app/ui/theme.dart';
import 'package:msu_chat_app/util/state_widget.dart';

import 'root_page.dart';
import 'ui/screens/admin/view_admins.dart';
import 'ui/screens/admin/view_coaches.dart';
import 'ui/screens/admin/view_sports.dart';
import 'ui/screens/admin/view_students.dart';
import 'ui/screens/coach/view_events.dart';
import 'ui/screens/coach/view_posts.dart';
import 'ui/screens/student/ViewSports.dart';
import 'util/auth.dart';

void main() {
  StateWidget stateWidget = new StateWidget(
    child: new MyApp(),
  );

  runApp(stateWidget);
}

class MyApp extends StatelessWidget {
  MyApp() {
    //Navigation.initPaths();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MSU Sports App',
      theme: buildTheme(),
      //onGenerateRoute: Navigation.router.generator,
      debugShowCheckedModeBanner: false,
      home: RootPage(
        auth: Auth(),
      ),
      routes: <String, WidgetBuilder>{
        //all
        MyRoutes.SIGNIN: (context) => SignInScreen(),
        MyRoutes.SIGNUP: (context) => SignUpScreen(),
        MyRoutes.FORGOT_PASSWORD: (context) => ForgotPasswordScreen(),

        //admin

        MyRoutes.VIEW_ADMINS: (context) => ViewAdmins(),
        MyRoutes.VIEW_SPORTS: (context) => AdminViewSports(),
        MyRoutes.VIEW_STUDENTS: (context) => ViewStudents(),
        MyRoutes.VIEW_COACHES: (context) => ViewCoaches(),

        //student
        MyRoutes.VIEW_HOME: (context) => ViewSports(),

        //coaches
        MyRoutes.VIEW_POSTS: (context) => ViewPosts(),
        MyRoutes.VIEW_NOTICES: (context) => ViewNotices(),
        MyRoutes.VIEW_EVENTS: (context) => ViewEvents(),
      },
    );
  }
}
