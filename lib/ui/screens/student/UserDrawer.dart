import 'package:flutter/material.dart';
import 'package:msu_chat_app/constants/myconstants.dart';
import 'package:msu_chat_app/constants/routes_constants.dart';
import 'package:msu_chat_app/models/state.dart';
import 'package:msu_chat_app/ui/screens/sign_in.dart';
import 'package:msu_chat_app/util/auth.dart';
import 'package:msu_chat_app/util/state_widget.dart';

class StudentDrawer extends StatelessWidget {
  StudentDrawer({this.auth, this.onSignedOut});

  final Auth auth;
  final VoidCallback onSignedOut;

  StateModel appState;
  bool _loadingVisible = false;

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null)) {
      return SignInScreen();
    } else {
      final email = appState?.firebaseUserAuth?.email ?? '';
      final name = appState?.user?.name ?? '';

      void _signOut() async {
        try {
          await Auth.signOut();
          Navigator.of(context).pop();
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new SignInScreen()));
        } catch (e) {
          print(e);
        }
      }

      void showAlertDialog() {
        AlertDialog alertDialog = AlertDialog(
            title: Text('Status'),
            content:
                Text('Are you sure you want to logout from MSU Sports App'),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      new FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Ok',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          _signOut(); //signout
                        },
                      ),
                      Container(
                        width: 5.0,
                      ),
                      new FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Cancel',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ))
            ]);

        showDialog(context: context, builder: (_) => alertDialog);
      }

      return new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(email),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new AssetImage(SportsConstants.APP_LOGO),
              ),
            ),
            new ListTile(
              leading: Icon(Icons.person_pin_circle),
              title: new Text('All Sports'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(MyRoutes.VIEW_HOME);
              },
            ),
            new ListTile(
              leading: Icon(Icons.face),
              title: new Text('My Sports'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(MyRoutes.VIEW_SPORTS);
              },
            ),
            new ListTile(
              leading: Icon(Icons.person),
              title: new Text('Events'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(MyRoutes.VIEW_STUDENTS);
              },
            ),
            new ListTile(
              leading: Icon(Icons.person),
              title: new Text('Noties'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(MyRoutes.VIEW_COACHES);
              },
            ),
            new ListTile(
              leading: Icon(Icons.developer_mode),
              title: new Text('About Developer'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: Icon(Icons.all_out),
              title: new Text('Logout'),
              onTap: () {
                //Navigator.pop(context);
                showAlertDialog(); // _signOut();
              },
            )
          ],
        ),
      );
    }
  }
}
