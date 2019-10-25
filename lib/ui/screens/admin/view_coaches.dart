import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:msu_chat_app/constants/myconstants.dart';

import 'add_coach.dart';
import 'admin_drawer.dart';

class ViewCoaches extends StatefulWidget {
  ViewCoaches({this.user});

  final FirebaseUser user;

  @override
  State createState() => _ViewCoachesState();
}

class _ViewCoachesState extends State<ViewCoaches> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AdminDrawer(),
        appBar: new AppBar(
          title: new Text('Coaches'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext contex) => AddCoach()));
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
                    .collection('users')
                    .where('role', isEqualTo: SportsConstants.ROLE_COACH)
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
          String name = document[positon].data['name'].toString();
          String email = document[positon].data['email'].toString();
          String role = document[positon].data['role'].toString();
          String phonenumber = document[positon].data['phonenumber'].toString();

          return Card(
              color: Colors.white,
              elevation: 2.0,
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Colors.white, child: Icon(Icons.person)),
                  title: Text('Name: ' + name,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Email: ' +
                          email +
                          '\nPhonenumber: ' +
                          phonenumber +
                          '\nRole: ' +
                          role,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
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
