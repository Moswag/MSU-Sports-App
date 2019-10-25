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
import 'package:msu_chat_app/models/Sport.dart';
import 'package:msu_chat_app/repository/admin_repo.dart';
import 'package:msu_chat_app/ui/widgets/loading.dart';
import 'package:msu_chat_app/util/alert_dialog.dart';
import 'package:msu_chat_app/util/auth.dart';
import 'package:path/path.dart' as Path;

class AddSport extends StatefulWidget {
  AddSport({this.email});
  final String email;

  @override
  State createState() => _AddSportState();
}

class _AddSportState extends State<AddSport> {
  bool _autoValidate = false;
  bool _loadingVisible = false;
  File _image;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  Future _addSport({Sport sport}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child(
                SportsConstants.PATH_SPORTS + '${Path.basename(_image.path)}}');
        StorageUploadTask uploadTask = storageReference.putFile(_image);
        //String up=uploadTask.
        await uploadTask.onComplete;
        print('File Uploaded');
        storageReference.getDownloadURL().then((fileURL) {
          setState(() {
            sport.imageUrl = fileURL;
            sport.dateCreated = DateTime.now().toString();
            var id = utf8.encode(sport.description +
                sport.name +
                sport.dateCreated); // data being hashed
            sport.id = sha1.convert(id).toString();

            AdminRepo.addSport(sport).then((onValue) {
              if (onValue) {
                AlertDiag.showAlertDialog(context, 'Status',
                    'Sport Successfully Added', MyRoutes.VIEW_ADMINS);
              } else {
                AlertDiag.showAlertDialog(
                    context,
                    'Status',
                    'Failed to add sport, please contact admin',
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
      controller: nameController,
      //validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Sport Name',
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
        hintText: 'Description',
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
              Sport sport = new Sport();
              sport.name = nameController.text;
              sport.description = descriptionController.text;
              _addSport(sport: sport);
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
            title: Text('Add Sport'),
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

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }
}
