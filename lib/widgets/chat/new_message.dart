import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: "Type a message"),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          )),
          if(_enteredMessage.trim().isNotEmpty)
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send, color: Theme.of(context).primaryColor,),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() async{
    String message = _enteredMessage;
    setState(() {
      FocusScope.of(context).unfocus();
      _controller.clear();
      _enteredMessage = "";
    });
    final user = await FirebaseAuth.instance.currentUser();
    final userData = await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chat').add(
      {
        'text': message,
        'createdAt': Timestamp.now(),
        'userId':user.uid,
        'username': userData['username'],
        'dp': userData['dp'],
      },
    );
  }
}
