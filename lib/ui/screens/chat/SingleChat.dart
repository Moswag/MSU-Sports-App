import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msu_chat_app/constants/db_constants.dart';
import 'package:msu_chat_app/constants/myconstants.dart';
import 'package:msu_chat_app/models/chat.dart';
import 'package:msu_chat_app/repository/coach_repo.dart';

class ChatWithCoach extends StatefulWidget {
  ChatWithCoach({this.userName, this.userId, this.sportId, this.chatName});

  final String userName;
  final String userId;
  final String sportId;
  final String chatName;

  @override
  State createState() => new _ChatWithCoachState();
}

class _ChatWithCoachState extends State<ChatWithCoach> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.chatName),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: FutureBuilder(
                  future:
                      CoachRepo.getPersonalChats(widget.userId, widget.sportId),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) return Container();
                    return new ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) {
                        bool isOwnMessage = false;
                        if (snapshot.data[index].userName == widget.userName) {
                          isOwnMessage = true;
                        }
                        return isOwnMessage
                            ? _ownMessage(snapshot.data[index].message, 'You')
                            : _message(snapshot.data[index].message,
                                snapshot.data[index].userName);
                      },
                      itemCount: snapshot.data.length,
                    );
                  },
                ),
              ),
              new Divider(height: 1.0),
              Container(
                margin: EdgeInsets.only(bottom: 20.0, right: 10.0, left: 10.0),
                child: Row(
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                        controller: _controller,
                        // onSubmitted: _handleSubmit(new Chat()),
                        decoration: new InputDecoration.collapsed(
                            hintText: "send message"),
                      ),
                    ),
                    new Container(
                      child: new IconButton(
                          icon: new Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            Chat chat = new Chat();
                            chat.userName = widget.userName;
                            chat.to = widget.sportId;
                            chat.from = widget.userId;
                            chat.chatType = SportsConstants.CHAT_PERSONAL;
                            chat.message = _controller.text;
                            chat.time = DateTime.now().toString();

                            _handleSubmit(chat);
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _ownMessage(String message, String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(userName),
            Text(message),
          ],
        ),
        Icon(Icons.person),
      ],
    );
  }

  Widget _message(String message, String userName) {
    return Row(
      children: <Widget>[
        Icon(Icons.person),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(userName),
            Text(message),
          ],
        )
      ],
    );
  }

  _handleSubmit(Chat chat) {
    _controller.text = "";
    var db = Firestore.instance;
    db.collection(DBConstants.TABLE_CHAT_ROOM).add(chat.toJson()).then((val) {
      print("sucess");
    }).catchError((err) {
      print(err);
    });
  }
}
