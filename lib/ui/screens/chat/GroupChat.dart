import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msu_chat_app/constants/db_constants.dart';
import 'package:msu_chat_app/constants/myconstants.dart';
import 'package:msu_chat_app/models/chat.dart';

class GroupChat extends StatefulWidget {
  GroupChat({this.userName, this.userId, this.sportId, this.chatRoomName});

  final String userName;
  final String userId;
  final String sportId;
  final String chatRoomName;

  @override
  _GroupChatState createState() => new _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.chatRoomName),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("chat_room")
                      .where('to', isEqualTo: widget.sportId)
                      .orderBy("time", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return new ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) {
                        DocumentSnapshot document =
                            snapshot.data.documents[index];

                        bool isOwnMessage = false;
                        if (document['userName'] == widget.userName) {
                          isOwnMessage = true;
                        }
                        return isOwnMessage
                            ? _ownMessage(document['message'], 'You')
                            : _message(
                                document['message'], document['userName']);
                      },
                      itemCount: snapshot.data.documents.length,
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
                            chat.chatType = SportsConstants.CHAT_GROUP;
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
