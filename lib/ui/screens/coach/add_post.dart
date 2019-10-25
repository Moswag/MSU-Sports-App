import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:msu_chat_app/constants/myconstants.dart';
import 'package:msu_chat_app/constants/routes_constants.dart';
import 'package:msu_chat_app/models/post.dart';
import 'package:msu_chat_app/models/state.dart';
import 'package:msu_chat_app/repository/coach_repo.dart';
import 'package:msu_chat_app/ui/widgets/loading.dart';
import 'package:msu_chat_app/util/alert_dialog.dart';
import 'package:msu_chat_app/util/auth.dart';
import 'package:msu_chat_app/util/state_widget.dart';
import 'package:path/path.dart' as Path;

import '../sign_in.dart';

class AddPost extends StatefulWidget {
  AddPost({this.email});
  final String email;

  @override
  State createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool _autoValidate = false;
  bool _loadingVisible = false;
  File _image;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  Future _addSport({Post post}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child(
                SportsConstants.PATH_POSTS + '${Path.basename(_image.path)}}');
        StorageUploadTask uploadTask = storageReference.putFile(_image);
        //String up=uploadTask.
        await uploadTask.onComplete;
        print('File Uploaded');
        storageReference.getDownloadURL().then((fileURL) {
          setState(() {
            post.imageUrl = fileURL;
            post.dateCreated = DateTime.now().toString();
            var id = utf8.encode(post.description +
                post.title +
                post.dateCreated); // data being hashed
            post.id = sha1.convert(id).toString();

            CoachRepo.addPost(post).then((onValue) {
              if (onValue) {
                AlertDiag.showAlertDialog(context, 'Status',
                    'Post Successfully Added', MyRoutes.VIEW_POSTS);
              } else {
                AlertDiag.showAlertDialog(
                    context,
                    'Status',
                    'Failed to add post, please contact admin',
                    MyRoutes.VIEW_ADMINS);
              }
            });
          });
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
      final email = appState?.firebaseUserAuth?.email ?? '';
      final name = appState?.user?.name ?? '';
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
      );

      final nameField = TextFormField(
        autofocus: false,
        textCapitalization: TextCapitalization.words,
        controller: titleController,
        //validator: Validator.validateName,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Icon(
              Icons.title,
              color: Colors.black,
            ), // icon is 48px widget.
          ), // icon is 48px widget.
          hintText: 'Title',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      );

      final descriptionField = TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: descriptionController,
        maxLines: 3,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Icon(
              Icons.description,
              color: Colors.black,
            ), // icon is 48px widget.
          ), // icon is 48px widget.
          hintText: 'Full Post Description',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      );

      final docField = Column(
        children: <Widget>[
          Text('Selected Image'),
          _image != null
              ? Image.asset(
                  _image.path,
                  height: 150,
                )
              : Container(height: 150),
          _image == null
              ? RaisedButton(
                  child: Text('Choose File'),
                  onPressed: chooseFile,
                  color: Colors.cyan,
                )
              : Container(),
        ],
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
                Post post = new Post();
                post.title = titleController.text;
                post.description = descriptionController.text;
                post.userId = userId;
                post.sportId = sportId;
                _addSport(post: post);
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
                    nameField,
                    SizedBox(height: 24.0),
                    descriptionField,
                    SizedBox(height: 24.0),
                    docField,
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
              title: Text('Add Post'),
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

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }
}
