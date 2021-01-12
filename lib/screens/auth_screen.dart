import 'dart:io';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }

  Future<void> _submitAuthForm(String email, String username, String password,
      File _image, bool isLogIn, BuildContext context) async {
    AuthResult _authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogIn) {
        _authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final reference = FirebaseStorage.instance
            .ref()
            .child("chat_app")
            .child(_authResult.user.uid.toString())
            .child("_display_photo")
            .child('dp.jpg');
        await reference.putFile(_image).onComplete;
        final url = await reference.getDownloadURL();
        await Firestore.instance
            .collection('users')
            .document(_authResult.user.uid)
            .setData({'username': username, 'email': email, 'dp': url});
      }
    } on PlatformException catch (err) {
      var message = "An Error Occurred, please enter valid credentials";
      if (err.message != null) {
        message = err.message;
      }
      print(message);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
