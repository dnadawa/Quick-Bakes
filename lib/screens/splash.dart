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
    Timer(Duration(milliseconds: 1000), () {
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
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOutCirc,
            onEnd: () {
              Timer(Duration(milliseconds: 500), () {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(builder: (context) => MyApp()),
                );
              });
            },
            child: SizedBox(
                width: ScreenUtil().setWidth(400),
                height: ScreenUtil().setHeight(400),
                child: Image.asset('images/splash.png')),
          ),
        ),
      ),
    );
  }
}
