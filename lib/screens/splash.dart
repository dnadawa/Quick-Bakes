import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import '../main.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  double _opacity = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 5000), () {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context){
        return MyApp();}));
      setState(() {
        _opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520, allowFontScaling: false);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).primaryColor,
        //color: Colors.white,
        child: Center(
          child: SizedBox(
              width: ScreenUtil().setWidth(600),
              height: ScreenUtil().setHeight(600),
              child: Image.asset('images/splash.gif')),
        ),
      ),
    );
  }
}
