import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:msu_chat_app/constants/db_constants.dart';
import 'package:msu_chat_app/constants/myconstants.dart';
import 'package:msu_chat_app/models/state.dart';
import 'package:msu_chat_app/util/state_widget.dart';

import '../sign_in.dart';
import 'add_notice.dart';
import 'coach_drawer.dart';

class ViewNotices extends StatefulWidget {
  ViewNotices({this.user});

  final FirebaseUser user;

  @override
  State createState() => _ViewNoticesState();
}

class _ViewNoticesState extends State<ViewNotices> {
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
      final sportId = appState?.user?.sportId ?? '';
      final userId = appState?.firebaseUserAuth?.uid ?? '';
      return Scaffold(
          drawer: CoachDrawer(),
          appBar: new AppBar(
            title: new Text('Notices'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext contex) => AddNotice()));
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ),
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          //bottomNavigationBar: makeBottom,
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 160),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection(DBConstants.TABLE_NOTICES)
                      .where('sportId', isEqualTo: sportId)
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
              Container(
                height: 150.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(SportsConstants.APP_LOGO),
                        fit: BoxFit.contain),
                    boxShadow: [
                      new BoxShadow(color: Colors.black, blurRadius: 8.0)
                    ],
                    color: Colors.white),
              ),
            ],
          ));
    }
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});
  final List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context) {
    ListView getNoteListView() {
      TextStyle titleStyle = Theme.of(context).textTheme.subhead;
      return ListView.builder(
        itemCount: document.length,
        itemBuilder: (BuildContext context, int positon) {
          String head = document[positon].data['head'].toString();
          String body = document[positon].data['body'].toString();
          String dateCreated = document[positon].data['dateCreated'].toString();

          return Card(
              color: Colors.white,
              elevation: 2.0,
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.notifications_active)),
                  title: Text(head,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(body + '\n' + dateCreated,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal)),
                  trailing: GestureDetector(
                    //to make the icon clickable and respond
                    child: Icon(Icons.delete, color: Colors.white, size: 25.0),
                    onTap: () {
                      Firestore.instance.runTransaction((transaction) async {
                        DocumentSnapshot snapshot =
                            await transaction.get(document[positon].reference);
                        await transaction.delete(snapshot.reference);
                      });

                      Scaffold.of(context).showSnackBar(
                          new SnackBar(content: new Text('Price Deleted')));
                    },
                  ),
                  onTap: () {
                    debugPrint("ListTile Tapped");
//                    Navigator.of(context).push(MaterialPageRoute(
//                        builder: (BuildContext context)=>new EditController(
//                          name:  name,
//                          email: email,
//                          nationalId: nationalId ,
//                          phonenumber: phonenumber,
//                          index: document[positon].reference,
//                        )));
                  },
                ),
              ));
        },
      );
    }

    return getNoteListView();
  }
}
