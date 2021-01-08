import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
        stream: Firestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, chatSnapShot) {
          if (chatSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocuments = chatSnapShot.data.documents;
          return ListView.builder(
                itemCount: chatDocuments.length,
                reverse: true,
                itemBuilder: (context, index) => MessageBubble(
                    chatDocuments[index]['text'],
                    chatDocuments[index]['username'],
                    chatDocuments[index]['dp'],
                    chatDocuments[index]['userId'] == futureSnapshot.data.uid,),
              );
            },
          );
        });
  }
}
