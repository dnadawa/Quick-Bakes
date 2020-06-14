import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:quickbakes/screens/bakery/bakery-home.dart';
import 'package:quickbakes/screens/bakery/bakery-register.dart';
import 'package:quickbakes/widgets/custom-text.dart';
import 'package:quickbakes/widgets/input-field.dart';
import 'package:quickbakes/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BakeryLogIn extends StatelessWidget {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  CollectionReference collectionReference = Firestore.instance.collection('bakers');

  bakerSignIn(BuildContext context) async {
    var sub = await collectionReference.where('email', isEqualTo: email.text).getDocuments();
    var user = sub.documents;
    if (user.isNotEmpty) {
      if (user[0].data['password'] == password.text) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('bakeryEmail', email.text);
        prefs.setString('bakeryName', user[0]['name']);
        prefs.setDouble('lat', user[0]['lat']);
        prefs.setDouble('long', user[0]['long']);
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context){
          return BakeryHome();}));
      } else {
        ToastBar(text: 'Email or password is incorrect!', color: Colors.red)
            .show();
      }
    } else {
      ToastBar(text: 'Admin Doesn\'t exists!', color: Colors.red).show();
    }
  }

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
            image: DecorationImage(image: AssetImage('images/back.png'),fit: BoxFit.fill),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, CupertinoPageRoute(builder: (context){
                          return BakerySignUp();}));
                      },
                      child: Container(
                        height: ScreenUtil().setHeight(150),
                        width: ScreenUtil().setWidth(250),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))
                        ),
                        child: Center(
                            child: CustomText(text: 'SIGN UP',size: ScreenUtil().setSp(40),)),
                      ),
                    ),
                  ),
//                    Align(
//                      alignment: Alignment.topRight,
//                      child: Container(
//                          width: ScreenUtil().setWidth(350),
//                          height: ScreenUtil().setHeight(350),
//                          child: Image.asset('images/logo.png')),
//                    ),
                ],
              ),


              Padding(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(200), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35)),
                child: CustomText(text: 'Log In',size: ScreenUtil().setSp(70)),
              ),


              Padding(
                padding:  EdgeInsets.all(ScreenUtil().setWidth(35)),
                child: InputField(hint: 'Email',type: TextInputType.emailAddress,controller: email,),
              ),

              Padding(
                padding:  EdgeInsets.all(ScreenUtil().setWidth(35)),
                child: InputField(hint: 'Password',isPassword: true,controller: password,),
              ),


              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(90)),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: ()=>bakerSignIn(context),
                    child: Container(
                      height: ScreenUtil().setHeight(120),
                      width: ScreenUtil().setWidth(350),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(10))
                      ),
                      child: Center(
                          child: CustomText(text: "Let's Start",size: ScreenUtil().setSp(40),)
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}
