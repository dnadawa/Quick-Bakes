import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:quickbakes/screens/register.dart';
import 'package:quickbakes/widgets/custom-text.dart';
import 'package:quickbakes/widgets/input-field.dart';
import 'package:quickbakes/widgets/main-button.dart';

import 'bakery/bakery-log-in.dart';
import 'login.dart';

class WhoAreYou extends StatelessWidget {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520,allowFontScaling: false);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('images/mainback.png'),fit: BoxFit.fill),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(100),),
              Center(child: CustomText(text: 'Who Are You ?',size: ScreenUtil().setSp(70),)),
              SizedBox(height: ScreenUtil().setHeight(450),),
              MainButton(text: 'Customer',onPressed: (){
                Navigator.push(context, CupertinoPageRoute(builder: (context){
                  return LogIn();}));
              },),
              SizedBox(height: ScreenUtil().setHeight(40),),
              MainButton(text: 'Baker',onPressed: (){
                Navigator.push(context, CupertinoPageRoute(builder: (context){
                  return BakeryLogIn();}));
              },),
              SizedBox(height: ScreenUtil().setHeight(40),),
              MainButton(text: 'Admin',onPressed: (){},),

            ],
          ),

        ),
      ),
    );
  }
}
