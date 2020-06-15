import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quickbakes/screens/who-are-you.dart';
import 'package:quickbakes/widgets/custom-text.dart';
import 'package:quickbakes/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostARequest extends StatefulWidget {
  @override
  _PostARequestState createState() => _PostARequestState();
}

class _PostARequestState extends State<PostARequest> {
  TextEditingController description = TextEditingController();
  TextEditingController budget = TextEditingController();
  DateTime picked;
  String date = 'Delivery Date';

  checkAvailiability() async {
    Random rnd = Random();
    var r = 1000000 + rnd.nextInt(9999999 - 1000000);
    var x = await Firestore.instance.collection('request').where('id', isEqualTo: r.toString()).getDocuments();
    var availiable = x.documents;

    if(availiable.isEmpty){
      sendToFirestore(r.toString());
    }
    else{
      checkAvailiability();
    }
  }

  sendToFirestore(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    try{
      Firestore.instance.collection('request').document(code).setData({
        'id': code,
        'delivery': date,
        'description': description.text,
        'email': email,
        'budget': budget.text,
        'status': 'Active'
      });
      ToastBar(text: 'Order Placed!',color: Colors.green).show();
      description.clear();
      budget.clear();
    }
    catch(e){
      ToastBar(text: 'Something Went Wrong While Uploading Data!',color: Colors.red).show();
    }
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
        title: CustomText(text: 'Post a Request',),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app),onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('email', null);
            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context){
              return WhoAreYou();}));
          },),
        ],
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomText(text: 'Description',size: ScreenUtil().setSp(45),),
                            GestureDetector(
                              onTap: () async {
                                picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020, 1),
                                    lastDate: DateTime(2101));
                                setState(() {
                                  date = DateFormat('yyyy.MM.dd').format(picked);
                                });
                              },
                              child: Container(
                                height: ScreenUtil().setHeight(70),
                                width: ScreenUtil().setWidth(200),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white
                                ),
                                child: Center(child: CustomText(text: date,color: Colors.black,)),
                              ),
                            ),
                          ],
                        ),
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
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
                              child: Row(
                                children: <Widget>[
                                  CustomText(text: 'Budget',size: ScreenUtil().setSp(30),),
                                  SizedBox(width: ScreenUtil().setWidth(30),),
                                  Expanded(
                                    child: Container(
                                      height: ScreenUtil().setHeight(80),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.horizontal(right: Radius.circular(10))
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
                    if(date!='Delivery Date'){
                        checkAvailiability();
                    }else{
                      ToastBar(text: 'Please Select the delivery date',color: Colors.red).show();
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
