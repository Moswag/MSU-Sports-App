import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:msu_chat_app/constants/myconstants.dart';
import 'package:msu_chat_app/constants/routes_constants.dart';
import 'package:msu_chat_app/models/user.dart';
import 'package:msu_chat_app/ui/widgets/loading.dart';
import 'package:msu_chat_app/util/auth.dart';
import 'package:msu_chat_app/util/validator.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _phonenumber = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _confirmPassword = new TextEditingController();

  bool _autoValidate = false;
  bool _loadingVisible = false;
  @override
  void initState() {
    super.initState();
    //ControllerService.LoadDataToLocal();
  }

  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: Image(
        image: AssetImage(SportsConstants.APP_LOGO),
        width: 255,
        height: 130,
      ),
    );

    final name = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _name,
      validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final phonenumber = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      controller: _phonenumber,
      validator: Validator.validateNumber,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.phone,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Phonenumber',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _email,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.confirmation_number,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Reg Number',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: _password,
      validator: Validator.validatePassword,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final confirmPassword = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: _confirmPassword,
      validator: Validator.validatePassword,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Confirm Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          User user = new User();
          user.name = _name.text;
          user.email = _email.text + '@students.msu.ac.zw';
          user.phonenumber = _phonenumber.text;
          user.role = SportsConstants.ROLE_STUDENT;

          _registerStudent(
              user: user, password: _password.text, context: context);
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child: Text('SIGN UP', style: TextStyle(color: Colors.white)),
      ),
    );

    final backToLoginLabel = FlatButton(
      child: Text(
        'Back To Login',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(MyRoutes.SIGNIN);
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingScreen(
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      logo,
                      SizedBox(height: 48.0),
                      name,
                      SizedBox(height: 24.0),
                      phonenumber,
                      SizedBox(height: 24.0),
                      email,
                      SizedBox(height: 24.0),
                      password,
                      SizedBox(height: 24.0),
                      confirmPassword,
                      SizedBox(height: 12.0),
                      loginButton,
                      // forgotLabel,
                      backToLoginLabel
                    ],
                  ),
                ),
              ),
            ),
          ),
          inAsyncCall: _loadingVisible),
    );
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  void _registerStudent(
      {User user, String password, BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();
        //need await so it has chance to go through error if found.
        await Auth.signUp(user.email, password).then((uID) {
          user.userId = uID;
          Auth.addStudentSettingsDB(user);
          Navigator.of(context).pushNamed(MyRoutes.SIGNIN);
        });
        //navigate to the right dashboard
        // UserManagement().authoriseAccess(context);
        // await Navigator.pushNamed(context, '/');
      } catch (e) {
        _changeLoadingVisible();
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
}
