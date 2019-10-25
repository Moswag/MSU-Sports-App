import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:msu_chat_app/constants/routes_constants.dart';
import 'package:msu_chat_app/models/Sport.dart';
import 'package:msu_chat_app/models/join_sport.dart';
import 'package:msu_chat_app/models/state.dart';
import 'package:msu_chat_app/models/user.dart';
import 'package:msu_chat_app/repository/student_repo.dart';
import 'package:msu_chat_app/ui/screens/chat/GroupChat.dart';
import 'package:msu_chat_app/ui/screens/chat/SingleChat.dart';
import 'package:msu_chat_app/ui/screens/sign_in.dart';
import 'package:msu_chat_app/util/alert_dialog.dart';
import 'package:msu_chat_app/util/state_widget.dart';

class SportDetailScreen extends StatefulWidget {
  SportDetailScreen({this.sport});
  final Sport sport;

  @override
  _SportDetailScreenState createState() => _SportDetailScreenState();
}

class _SportDetailScreenState extends State<SportDetailScreen> {
  var myUser;
  var joinedSport;
  bool joined = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StateModel appState;
    appState = StateWidget.of(context).state;
    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null)) {
      return SignInScreen();
    } else {
      final email = appState?.firebaseUserAuth?.email ?? '';
      final name = appState?.user?.name ?? '';
      final userId = appState?.firebaseUserAuth?.uid ?? '';

      StudentRepo.didStudentJoin(userId, widget.sport.id)
          .then((QuerySnapshot snapshot) {
        if (snapshot.documents.isNotEmpty) {
          joinedSport = snapshot.documents[0].data;
          if (joinedSport["userId"] != null) {
            joined = true;
            print('data collected ' + joinedSport["userId"]);
          }
        }
      });

      print('$joined hahaha');

      return Scaffold(
        appBar: AppBar(
          title: Text(widget.sport.name),
        ),
        body: SafeArea(
            top: false,
            bottom: false,
            child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 200.0,
                      floating: false,
                      pinned: true,
                      elevation: 0.0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(
                          widget.sport.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ];
                },
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 50.0,
                        alignment: WrapAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              widget.sport.name,
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: !joined,
                              child: RaisedButton.icon(
                                textColor: Colors.white,
                                label: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Join'),
                                ),
                                shape: StadiumBorder(),
                                color: Colors.blue,
                                icon: Icon(Icons.rate_review,
                                    color: Colors.white),
                                onPressed: () {
                                  JoinSport mySport = new JoinSport();
                                  var id = utf8.encode(widget.sport.id +
                                      userId); // data being hashed
                                  mySport.id = sha1.convert(id).toString();
                                  mySport.sportId = widget.sport.id;
                                  mySport.userId = userId;

                                  StudentRepo.joinSport(mySport)
                                      .then((onValue) {
                                    if (onValue) {
                                      AlertDiag.showAlertDialog(
                                          context,
                                          'Status',
                                          'You Successfully joined ${widget.sport.name}',
                                          MyRoutes.VIEW_HOME);
                                    } else {
                                      AlertDiag.showAlertDialog(
                                          context,
                                          'Status',
                                          'Failed to join sport, please contact admin',
                                          MyRoutes.VIEW_HOME);
                                    }
                                  });
                                },
                              )),
                          Visibility(
                              maintainSize: false,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: joined,
                              child: RaisedButton.icon(
                                textColor: Colors.white,
                                label: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Group Chat'),
                                ),
                                shape: StadiumBorder(),
                                color: Colors.green,
                                icon: Icon(Icons.chat, color: Colors.white),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              GroupChat(
                                                userId: userId,
                                                userName: name,
                                                sportId: widget.sport.id,
                                                chatRoomName: widget.sport.name,
                                              )));
                                },
                              )),
                          Visibility(
                              maintainSize: false,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: joined,
                              child: RaisedButton.icon(
                                onPressed: () {
                                  StudentRepo.getCoach(widget.sport.id)
                                      .then((QuerySnapshot snapshot) {
                                    if (snapshot.documents.isNotEmpty) {
                                      myUser = snapshot.documents[0].data;
                                      print(myUser);
                                      User user = new User();
                                      user.name = myUser["name"];
                                      user.userId = myUser["userId"];
                                      print(user.toString() + " is the coach");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ChatWithCoach(
                                                    userId: userId,
                                                    userName: name,
                                                    sportId: user.userId,
                                                    chatName: user.name,
                                                  )));
                                    } else {
                                      Scaffold.of(context).showSnackBar(
                                          new SnackBar(
                                              content: new Text(
                                                  'There is no coach for this sport')));
                                    }
                                  });
                                },
                                textColor: Colors.white,
                                label: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Chat With Coach'),
                                ),
                                shape: StadiumBorder(),
                                color: Colors.green,
                                icon: Icon(Icons.chat_bubble,
                                    color: Colors.white),
                              ))
                        ],
                      ),
                      Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 1.0, right: 1.0),
                          ),
                          Text(
                            widget.sport.name,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          Text(
                            widget.sport.dateCreated,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                      Text(widget.sport.description),
                      Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                    ],
                  ),
                ))),
      );
    }
  }
}
