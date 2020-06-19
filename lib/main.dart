import 'package:flutter/material.dart';
import 'package:quickbakes/screens/bakery/bakery-home.dart';
import 'package:quickbakes/screens/home.dart';
import 'package:quickbakes/screens/splash.dart';
import 'package:quickbakes/screens/who-are-you.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Color(0xff424043),
            fontFamily: 'GoogleSans'
        ),
        home: Splash(),
      ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String email;
  String bakeryEmail;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
      bakeryEmail = prefs.getString('bakeryEmail');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

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
      home: email!=null?Home():bakeryEmail!=null?BakeryHome():WhoAreYou(),
    );
  }
}
