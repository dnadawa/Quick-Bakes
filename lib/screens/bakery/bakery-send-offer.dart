import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:quickbakes/widgets/custom-text.dart';
import 'package:quickbakes/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BakerySendOffer extends StatelessWidget {
  final String orderID;
  final String userEmail;
  BakerySendOffer({Key key, this.orderID, this.userEmail}) : super(key: key);
  
  TextEditingController description = TextEditingController();
  TextEditingController budget = TextEditingController();

  sendMail(String email) async {
    String username = 'quickbakes0@gmail.com';
    String password = 'Admin@quick';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'QuickBakes')
      ..recipients.add(email)
      ..subject = 'You have received an offer!'
      ..text = 'You have received an offer from a bakery!';
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520, allowFontScaling: false);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: CustomText(text: 'Send Offer',),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('images/back.png'),fit: BoxFit.fill)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
                child: Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(900),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.all(ScreenUtil().setHeight(40)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomText(text: 'Send Your Proposal',size: ScreenUtil().setSp(45),),
                        SizedBox(height: ScreenUtil().setHeight(45),),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                              child: TextField(
                                maxLines: null,
                                controller: description,
                                style: TextStyle(fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold,color: Colors.black),
                                cursorColor: Theme.of(context).accentColor               ,
                                decoration: InputDecoration(
                                  hintText: 'Type Your Explanation',
                                  hintStyle: TextStyle(fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold,color: Colors.black),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(40),),
                        Center(
                          child: Container(
                            height: ScreenUtil().setHeight(100),
                            width: ScreenUtil().setWidth(350),
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                              child: Row(
                                children: <Widget>[
                                  CustomText(text: 'Budget',size: ScreenUtil().setSp(30),),
                                  SizedBox(width: ScreenUtil().setWidth(30),),
                                  Expanded(
                                    child: Container(
                                      height: ScreenUtil().setHeight(80),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.horizontal(right: Radius.circular(20))
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          controller: budget,
                                          style: TextStyle(fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold,color: Colors.black),
                                          cursorColor: Theme.of(context).accentColor               ,
                                          decoration: InputDecoration(
                                            hintText: '0',
                                            hintStyle: TextStyle(fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold,color: Colors.black),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () async {
                    if(budget.text!='' && description.text!=''){
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String bakeryEmail = prefs.getString('bakeryEmail');
                      String bakeryName = prefs.getString('bakeryName');
                      double lat = prefs.getDouble('lat');
                      double long = prefs.getDouble('long');
                      try{
                        Firestore.instance.collection('request').document(orderID).collection('offers').document(bakeryEmail).setData({
                          'bakeryEmail': bakeryEmail,
                          'bakeryName': bakeryName,
                          'description': description.text,
                          'price': budget.text,
                          'lat': lat,
                          'long': long,
                        });
                        ToastBar(text: 'Offer Sent!',color: Colors.green).show();
                        sendMail(userEmail);
                        description.clear();
                        budget.clear();
                      }
                      catch(e){
                        ToastBar(text: 'Something Went Wrong While Uploading Data!',color: Colors.red).show();
                      }
                    }
                    else{
                      ToastBar(color: Colors.red,text: 'Please Fill all the Fields!').show();
                    }
                  },
                  child: Material(
                    elevation: 7,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(40)),
                    child: Container(
                      width: ScreenUtil().setWidth(300),
                      height: ScreenUtil().setHeight(100),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(40)),
                      ),
                      child: Center(
                          child: CustomText(text: 'Submit',color: Colors.black,size: ScreenUtil().setSp(40),)
                      ),
                    ),
                  ),
                ),
              ),


            ],
          ),
        )
    );
  }
}
