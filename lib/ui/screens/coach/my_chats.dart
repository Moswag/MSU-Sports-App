import 'package:flutter/material.dart';
import 'package:msu_chat_app/constants/myconstants.dart';
import 'package:msu_chat_app/models/chat.dart';
import 'package:msu_chat_app/models/state.dart';
import 'package:msu_chat_app/repository/coach_repo.dart';
import 'package:msu_chat_app/ui/screens/chat/SingleChat.dart';
import 'package:msu_chat_app/util/state_widget.dart';

import '../sign_in.dart';
import 'coach_drawer.dart';

class MyChats extends StatefulWidget {
  final String title = 'Controllers';

  @override
  State createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  StateModel appState;
  bool _autoValidate = false;
  bool _loadingVisible = false;

  @override
  void initState() {
    super.initState();
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
      final sportName = appState?.user?.sportName ?? '';
      final sportId = appState?.user?.sportId ?? '';

      ListTile makeListTile(Chat chat) => ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.white, child: Icon(Icons.store)),
            title: Text(
              chat.userName,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

            subtitle: Row(
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Container(
                      // tag: 'hero',

                      child: Text(chat.message + '\n ' + chat.time,
                          style: TextStyle(color: Colors.white)),
                    )),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 25.0,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ChatWithCoach(
                            userName: name,
                            userId: userId,
                            chatName: chat.userName,
                            sportId: chat.from,
                          )));
            },
          );

      Card makeCard(Chat chat) => Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
              child: makeListTile(chat),
            ),
          );

      final header = Container(
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(SportsConstants.BACKGROUND_IMAGE),
                fit: BoxFit.contain),
            boxShadow: [new BoxShadow(color: Colors.black, blurRadius: 8.0)],
            color: Colors.white),
      );

      final makeBody = Padding(
          padding: EdgeInsets.only(top: 100),
          child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
              child: FutureBuilder(
                  future: CoachRepo.getChats(userId),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: Center(
                          child: Text('Loading'),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return makeCard(new Chat(
                            userName: snapshot.data[index].userName,
                            to: snapshot.data[index].to,
                            from: snapshot.data[index].from,
                            message: snapshot.data[index].message,
                            chatType: snapshot.data[index].chatType,
                            time: snapshot.data[index].time,
                          ));
                        },
                      );
                    }
                  })));

      final topAppBar = AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text(widget.title),
        centerTitle: true,
      );

      return Scaffold(
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          appBar: topAppBar,
          drawer: CoachDrawer(),
          body: Stack(children: <Widget>[makeBody, header]));
    }
  }
}
