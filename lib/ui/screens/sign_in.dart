import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:msu_chat_app/constants/myconstants.dart';
import 'package:msu_chat_app/ui/screens/forgot_password.dart';
import 'package:msu_chat_app/ui/screens/sign_up.dart';
import 'package:msu_chat_app/ui/widgets/loading.dart';
import 'package:msu_chat_app/util/auth.dart';
import 'package:msu_chat_app/util/state_widget.dart';
import 'package:msu_chat_app/util/user_management.dart';
import 'package:msu_chat_app/util/validator.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

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
        hintText: 'Reg Number or Email',
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

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          String email = _email.text;
          if (email.endsWith('.com') || email.endsWith('.zw')) {
            email = _email.text;
          } else {
            email = _email.text + '@students.msu.ac.zw';
          }
          _emailLogin(email: email, password: _password.text, context: context);
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child: Text('SIGN IN', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ForgotPasswordScreen()));
      },
    );

    final signUpLabel = FlatButton(
      child: Text(
        'Create an Account',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => SignUpScreen()));
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
                      email,
                      SizedBox(height: 24.0),
                      password,
                      SizedBox(height: 12.0),
                      loginButton,
                      forgotLabel,
                      signUpLabel
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

  void _emailLogin(
      {String email, String password, BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();
        //need await so it has chance to go through error if found.
        await StateWidget.of(context).logInUser(email, password);
        //navigate to the right dashboard
        UserManagement().authoriseAccess(context);
        // await Navigator.pushNamed(context, '/');
      } catch (e) {
        _changeLoadingVisible();
        print("Sign In Error: $e");
        String exception = Auth.getExceptionText(e);
        Flushbar(
                title: "Sign In Error",
                message: exception,
                duration: Duration(seconds: 5))
            .show(context);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
