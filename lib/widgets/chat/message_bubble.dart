import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String _username;
  final String _message;
  final String _image;
  final bool _isMe;
  final Key key;

  MessageBubble(this._message, this._username, this._image, this._isMe, {this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          _isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: _isMe ? Theme.of(context).accentColor : Colors.grey[800],
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              topRight: _isMe ? Radius.circular(0) : Radius.circular(16),
              topLeft: !_isMe ? Radius.circular(0) : Radius.circular(16),
            ),
          ),
          width: 200,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment: _isMe? CrossAxisAlignment.end: CrossAxisAlignment.start,
            children: [
              Text(
                _username,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                _message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
