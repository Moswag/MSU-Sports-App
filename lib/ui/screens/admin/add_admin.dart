import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:msu_chat_app/constants/myconstants.dart';
import 'package:msu_chat_app/constants/routes_constants.dart';
import 'package:msu_chat_app/models/user.dart';
import 'package:msu_chat_app/ui/widgets/loading.dart';
import 'package:msu_chat_app/util/alert_dialog.dart';
import 'package:msu_chat_app/util/auth.dart';
import 'package:msu_chat_app/util/validator.dart';

class AddAdmin extends StatefulWidget {
  AddAdmin({this.email});
  final String email;

  @override
  State createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  bool _autoValidate = false;
  bool _loadingVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fullnameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phonenumberController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Future _addData({User user, String password}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        await Auth.signUp(user.email, password).then((uID) {
          user.userId = uID;
          Auth.addUserSettingsDB(user);
        });
        AlertDiag.showAlertDialog(context, 'Status', 'Admin Successfully Added',
            MyRoutes.VIEW_ADMINS);
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
            'Admin',
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontFamily: 'Roboto'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Application Admin',
              style: TextStyle(fontSize: 20, color: Colors.blueGrey),
            ),
          ),
          Icon(
            Icons.person_add,
            color: Colors.blueGrey,
            size: 30,
          )
        ],
      ),
    );

    final fullNameField = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: fullnameController,
      //validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Full Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final emailField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: emailController,
      validator: Validator.validateEmail,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.email,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final phonenumberField = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      controller: phonenumberController,
      //validator: Validator.validateNumber,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.phone,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Phonenumber',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      validator: Validator.validatePassword,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Password',
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
              User user = new User();
              user.name = fullnameController.text;
              user.email = emailController.text;
              user.phonenumber = phonenumberController.text;
              user.role = SportsConstants.ROLE_ADMIN;

              _addData(user: user, password: passwordController.text);
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
                  fullNameField,
                  SizedBox(height: 24.0),
                  emailField,
                  SizedBox(height: 24.0),
                  phonenumberField,
                  SizedBox(height: 24.0),
                  passwordField,
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
            title: Text('Add Admin'),
          ),
          body: LoadingScreen(child: form, inAsyncCall: _loadingVisible),
        ));
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
