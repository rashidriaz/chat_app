import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(buttonColor: Colors.pink,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20
                )
            )),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.pink,
        accentColorBrightness: Brightness.light,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        primaryColorLight: Colors.pink,
        primaryColorDark: Colors.white,
        buttonTheme: ButtonTheme.of(context).copyWith(buttonColor: Colors.pink,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20
                )
            )),
      ),
      home: StreamBuilder(stream: FirebaseAuth.instance.onAuthStateChanged,
        builder:(context, userSnapShot) {
        if(userSnapShot.connectionState == ConnectionState.waiting) SplashScreen();
        if(userSnapShot.hasData){
         return ChatScreen();
        }else{
         return AuthScreen();
        }
        },),
    );
  }
}
