import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:quickbakes/widgets/custom-text.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminCompleted extends StatefulWidget {
  final String id;
  final String bakeryEmail;
  final String bakeryName;
  final String userEmail;
  final int price;

  const AdminCompleted({Key key, this.id, this.bakeryEmail, this.bakeryName, this.userEmail, this.price}) : super(key: key);

  @override
  _AdminCompletedState createState() => _AdminCompletedState();
}

class _AdminCompletedState extends State<AdminCompleted> {
  String phone = '';
  String address = '';
  double lat,long;

  getData() async {
    var sub = await Firestore.instance.collection('bakers').where('email', isEqualTo: widget.bakeryEmail).getDocuments();
    var user = sub.documents;
    setState(() {
      phone = user[0]['phone'];
      address = user[0]['address'];
      lat = user[0]['lat'];
      long = user[0]['long'];
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
    ScreenUtil.init(context, width: 720, height: 1520, allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(text: 'Order Info',),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_on,color: Theme.of(context).accentColor,),
        onPressed: () async {
          String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
          if (await canLaunch(googleUrl)) {
            await launch(googleUrl);
          } else {
            throw 'Could not open the map.';
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('images/back.png'),fit: BoxFit.fill)
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(50)),
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(900),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).primaryColor,width: 4)
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(120),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      child: Center(child: CustomText(text: widget.bakeryName,color: Theme.of(context).primaryColor,size: ScreenUtil().setSp(50),)),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: ScreenUtil().setHeight(80),
                        width: ScreenUtil().setWidth(300),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                            ),
                            color: Theme.of(context).primaryColor
                        ),
                        child: Center(
                            child: CustomText(text: '\$${widget.price}',size: ScreenUtil().setSp(40),)),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.all(ScreenUtil().setWidth(40)),
                      child: CustomText(text: 'Contact Information',color: Colors.black,size: ScreenUtil().setSp(45),isUnderline: true,),
                    ),
                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                      child: CustomText(text: 'Contact No. - 1234567890',color: Colors.black,size: ScreenUtil().setSp(35),),
                    ),
                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                      child: CustomText(text: 'Email - ${widget.bakeryEmail}',color: Colors.black,size: ScreenUtil().setSp(35),),
                    ),
                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                      child: CustomText(text: 'Address - address',color: Colors.black,size: ScreenUtil().setSp(35),),
                    ),
                    Padding(
                      padding:  EdgeInsets.all(ScreenUtil().setWidth(40)),
                      child: CustomText(text: 'Customer',color: Colors.black,size: ScreenUtil().setSp(45),isUnderline: true,),
                    ),
                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                      child: CustomText(text: widget.userEmail,color: Colors.black,size: ScreenUtil().setSp(35),),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

