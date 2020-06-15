import 'package:flutter/material.dart';
import 'package:quickbakes/screens/who-are-you.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff424242),
        accentColor: Colors.amber,
        fontFamily: 'GoogleSans',
        indicatorColor: Color(0xff424242)
      ),
      home: WhoAreYou(),
    );
  }
}
