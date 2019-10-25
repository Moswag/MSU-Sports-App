import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:msu_chat_app/constants/myconstants.dart';
import 'package:msu_chat_app/constants/routes_constants.dart';
import 'package:msu_chat_app/models/Notice.dart';
import 'package:msu_chat_app/models/state.dart';
import 'package:msu_chat_app/repository/coach_repo.dart';
import 'package:msu_chat_app/ui/widgets/loading.dart';
import 'package:msu_chat_app/util/alert_dialog.dart';
import 'package:msu_chat_app/util/auth.dart';
import 'package:msu_chat_app/util/state_widget.dart';

import '../sign_in.dart';

class AddNotice extends StatefulWidget {
  AddNotice({this.email});
  final String email;

  @override
  State createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  bool _autoValidate = false;
  bool _loadingVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController headController = new TextEditingController();
  TextEditingController bodyController = new TextEditingController();

  Future _addData(Notice notice) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        CoachRepo.addNotice(notice).then((onValue) {
          if (onValue) {
            AlertDiag.showAlertDialog(context, 'Status',
                'Notice Successfully Added', MyRoutes.VIEW_NOTICES);
          } else {
            AlertDiag.showAlertDialog(
                context,
                'Status',
                'Failed to add notice, please contact admin',
                MyRoutes.VIEW_ADMINS);
          }
        });
      } catch (e) {
        print("Sign Up Error: $e");
        String exception = Auth.getExceptionText(e);
        Flushbar(
                title: "Sign Up Error",
                message: exception,
                duration: Duration(seconds: 5))
            .show(context);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

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
      final sportId = appState?.user?.sportId ?? '';
      final userId = appState?.firebaseUserAuth?.uid ?? '';

      //define form fields
      final backButton = IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          moveToLastScreen();
        },
      );
      final header = Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(SportsConstants.APP_LOGO), fit: BoxFit.contain),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //backButton,
            Text(
              'Notice',
              style: TextStyle(
                  color: Colors.white, fontSize: 12, fontFamily: 'Roboto'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Add Notice',
                style: TextStyle(fontSize: 20, color: Colors.blueGrey),
              ),
            ),
            Icon(
              Icons.notifications_active,
              color: Colors.blueGrey,
              size: 30,
            )
          ],
        ),
      );

      final headField = TextFormField(
        autofocus: false,
        textCapitalization: TextCapitalization.words,
        controller: headController,
        //validator: Validator.validateName,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Icon(
              Icons.title,
              color: Colors.black,
            ), // icon is 48px widget.
          ), // icon is 48px widget.
          hintText: 'Head',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      );

      final bodyField = TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: bodyController,
        maxLines: 3,
        //validator: Validator.validateEmail,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Icon(
              Icons.description,
              color: Colors.black,
            ), // icon is 48px widget.
          ), // icon is 48px widget.
          hintText: 'Body',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      );

      final submitButton = Expanded(
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).primaryColorLight,
            child: Text(
              'Save',
              textScaleFactor: 1.5,
            ),
            onPressed: () {
              setState(() {
                debugPrint("Save clicked");
                Notice notice = new Notice();
                notice.head = headController.text;
                notice.body = bodyController.text;
                notice.userId = userId;
                notice.sportId = sportId;
                notice.dateCreated = DateTime.now().toString();

                var id = utf8.encode(notice.body +
                    notice.head +
                    notice.dateCreated); // data being hashed
                notice.id = sha1.convert(id).toString();

                _addData(notice);
              });
            }),
      );

      final cancelButton = Expanded(
        child: RaisedButton(
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
              setState(() {
                debugPrint("Cancel button clicked");
                Navigator.pop(context);
              });
            }),
      );

      Form form = new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    header,
                    SizedBox(height: 48.0),
                    headField,
                    SizedBox(height: 24.0),
                    bodyField,
                    SizedBox(height: 24.0),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          submitButton,
                          Container(
                            width: 5.0,
                          ), //for adding space between buttons
                          cancelButton
                        ],
                      ),
                    ),
                  ],
                ),
              )));

      return WillPopScope(
          onWillPop: () {
            moveToLastScreen();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: new AppBar(
              elevation: 0.1,
              backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
              title: Text('Add Notice'),
            ),
            body: LoadingScreen(child: form, inAsyncCall: _loadingVisible),
          ));
    }
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
