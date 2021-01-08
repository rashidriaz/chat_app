import 'dart:io';

import 'package:chat_app/widgets/pickers/image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String username, String password,
      File image, bool isLogIn, BuildContext context) _submitAuthForm;
  bool _isLoading;

  AuthForm(this._submitAuthForm, this._isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  File _image;
  final _formKey = GlobalKey<FormState>();
  bool _isLogIn = true;
  String email = "";
  String username = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogIn) UserImagePicker(setImage),
                TextFormField(
                  key: ValueKey("email"),
                  validator: (value) {
                    if (value.isEmpty || !_isEmail(value)) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email Address"),
                  onSaved: (value) {
                    email = value;
                  },
                ),
                if (!_isLogIn)
                  TextFormField(
                    key: ValueKey("username"),
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return "username too short, please enter at least 4 characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Username"),
                    onSaved: (value) {
                      username = value;
                    },
                  ),
                TextFormField(
                  key: ValueKey("password"),
                  validator: (value) {
                    return _validatePassword(value);
                  },
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  onSaved: (value) {
                    password = value;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                if (widget._isLoading) CircularProgressIndicator(),
                if (!widget._isLoading)
                  RaisedButton(
                    onPressed: _trySubmittingForm,
                    child: _isLogIn ? Text("LogIn") : Text("SignUp"),
                  ),
                if (!widget._isLoading)
                  FlatButton(
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        _isLogIn = !_isLogIn;
                      });
                    },
                    child: _isLogIn
                        ? Text("Create new account")
                        : Text("I already have an account"),
                    textColor: Theme.of(context).primaryColor,
                  ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  void _trySubmittingForm() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_image == null && !_isLogIn) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please Pick an Image"),
        backgroundColor: Theme.of(context).errorColor,

      ),);
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      widget._submitAuthForm(
          email.trim(), username, password, _image, _isLogIn, context);
    }
  }

  bool _isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  String _validatePassword(String value) {
    if (value.isEmpty || value.length < 7) {
      return "Password must be at least 7 characters long";
    }
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return "Password mut contain at least 1 alphabet, 1 number and a special character";
    }
    return null;
  }

  void setImage(File image) {
    _image = image;
  }
}
