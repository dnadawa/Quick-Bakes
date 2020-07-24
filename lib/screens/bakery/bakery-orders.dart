import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:quickbakes/widgets/button.dart';
import 'package:quickbakes/widgets/custom-text.dart';
import 'package:quickbakes/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BakeryOrders extends StatefulWidget {
  @override
  _BakeryOrdersState createState() => _BakeryOrdersState();
}

class _BakeryOrdersState extends State<BakeryOrders> {
  var requestList;
  String bakeryName;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bakeryEmail = prefs.getString('bakeryEmail');
    bakeryName = prefs.getString('bakeryName');
    Firestore.instance.collection('request').where('status', isEqualTo: 'Processing').where('activeBaker', isEqualTo: bakeryEmail).snapshots().listen((datasnapshot){
      setState(() {
        requestList = datasnapshot.documents;
      });

    });
  }

  sendMail(String email, String id) async {
    String username = 'quickbakes0@gmail.com';
    String password = 'Admin@quick';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'QuickBakes')
      ..recipients.add(email)
      ..subject = 'Your order is Completed!'
      ..text = 'You order $id is Marked as completed by the $bakeryName.';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520, allowFontScaling: false);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: CustomText(text: 'Orders',),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('images/back.png'),fit: BoxFit.fill)
          ),
          child: requestList!=null?ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: requestList.length,
            itemBuilder: (context,i){
              String price = requestList[i]['budget'];
              String id = requestList[i]['id'];
              String description = requestList[i]['description'];
              String date = requestList[i]['delivery'];
              String email = requestList[i]['email'];
              return Padding(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(25),ScreenUtil().setWidth(40),ScreenUtil().setWidth(25),0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      border: Border.all(color: Theme.of(context).primaryColor,width: 4)
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: ScreenUtil().setHeight(80),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  color: Theme.of(context).primaryColor
                              ),
                              child: Center(
                                  child: CustomText(text: '#$id',size: ScreenUtil().setSp(40),)),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: '\$$price',
                              color: Theme.of(context).primaryColor,
                              size: ScreenUtil().setSp(40),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding:  EdgeInsets.all(ScreenUtil().setWidth(20)),
                        child: Container(
                          height: ScreenUtil().setHeight(80),
                          width: ScreenUtil().setWidth(600),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).primaryColor
                          ),
                          child: Center(
                              child: CustomText(text: 'Expected Delivery - $date',size: ScreenUtil().setSp(35),color: Theme.of(context).accentColor,)),
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.all(ScreenUtil().setWidth(25)),
                        child: CustomText(
                          text: description,
                          color: Theme.of(context).primaryColor,
                          align: TextAlign.justify,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20),),
                      Button(
                        text: 'Mark as Completed!',
                        onTap: (){
                          Firestore.instance.collection('request').document(id).updateData({
                            'status': 'Completed'
                          });
                          Firestore.instance.collection('orders').document(id).updateData({
                            'status': 'Completed'
                          });
                          sendMail(email, id);
                          ToastBar(text: 'Order Marked as Completed!',color: Colors.green).show();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ):Center(
            child: CircularProgressIndicator(),
          ),
        )
    );
  }
}
