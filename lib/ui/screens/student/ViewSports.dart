import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msu_chat_app/constants/db_constants.dart';
import 'package:msu_chat_app/models/Sport.dart';

import 'DetailedSport.dart';
import 'UserDrawer.dart';

class ViewSports extends StatefulWidget {
  @override
  _ViewSportsState createState() => new _ViewSportsState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.1; //for the card size

class _ViewSportsState extends State<ViewSports> {
  var userId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentDrawer(),
      appBar: new AppBar(
        title: new Text('Sports'),
        centerTitle: true,
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      //bottomNavigationBar: makeBottom,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection(DBConstants.TABLE_SPORTS)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return new Container(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
                return new TaskList(
                  document: snapshot.data.documents,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardScrollWidget extends StatelessWidget {
  final Sport sport;
  var padding = 20.0;
  var verticalInset = 20.0;

  CardScrollWidget(this.sport);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        var delta = 0;
        bool isOnRight = delta > 0;

        var start = padding +
            max(
                primaryCardLeft -
                    horizontalInset * -delta * (isOnRight ? 15 : 1),
                0.0);

        var cardItem = Positioned.directional(
          top: padding + verticalInset * max(-delta, 0.0),
          bottom: padding + verticalInset * max(-delta, 0.0),
          start: start,
          textDirection: TextDirection.rtl,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(3.0, 6.0),
                    blurRadius: 10.0)
              ]),
              child: AspectRatio(
                aspectRatio: cardAspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.network(sport.imageUrl, fit: BoxFit.cover),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text(sport.description,
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 25.0,
                                    fontFamily: "SF-Pro-Text-Regular")),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, bottom: 12.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 22.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                SportDetailScreen(
                                                  sport: sport,
                                                )));
                                  },
                                  child: Text("View Page",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        cardList.add(cardItem);

        return Stack(
          children: cardList,
        );
      }),
    );
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});

  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    ListView getNoteListView() {
      return ListView.builder(
        itemCount: document.length,
        itemBuilder: (BuildContext context, int positon) {
          Sport sport = new Sport();
          sport.id = document[positon].data['id'].toString();
          sport.name = document[positon].data['name'].toString();
          sport.description = document[positon].data['description'].toString();
          sport.imageUrl = document[positon].data['imageUrl'].toString();
          sport.dateCreated = document[positon].data['dateCreated'].toString();

          return Wrap(children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(sport.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 46.0,
                        fontFamily: "Calibre-Semibold",
                        letterSpacing: 1.0,
                      )),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 12.0,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) =>
                                  SportDetailScreen(sport: sport)));
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFff6e6e),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 22.0, vertical: 6.0),
                        child:
                            Text("Hot", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text("25+ Posts", style: TextStyle(color: Colors.blueAccent))
                ],
              ),
            ),
            Stack(
              children: <Widget>[
                CardScrollWidget(sport),
              ],
            ),
          ]);
        },
      );
    }

    return getNoteListView();
  }
}
