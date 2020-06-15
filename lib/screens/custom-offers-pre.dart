import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:quickbakes/screens/custom-offers.dart';
import 'package:quickbakes/screens/order-processing.dart';
import 'package:quickbakes/screens/who-are-you.dart';
import 'package:quickbakes/widgets/button.dart';
import 'package:quickbakes/widgets/custom-text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomOffersPre extends StatefulWidget {
  @override
  _CustomOffersPreState createState() => _CustomOffersPreState();
}

class _CustomOffersPreState extends State<CustomOffersPre> {
  var requestList;
  getData(){
    Firestore.instance.collection('request').snapshots().listen((datasnapshot){
      setState(() {
        requestList = datasnapshot.documents;
      });
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: CustomText(text: 'Custom Offers',),
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
          child: requestList!=null?ListView.builder(
            itemCount: requestList.length,
            itemBuilder: (context,i){
               String orderID = requestList[i]['id'];
               String status = requestList[i]['status'];
               String email = requestList[i]['email'];
              return GestureDetector(
                onTap: (){
                  if(status=='Active'){
                    Navigator.push(context, CupertinoPageRoute(builder: (context){
                      return CustomOffers(id: orderID,userEmail: email,);}));
                  }
                  else{
                    Navigator.push(context, CupertinoPageRoute(builder: (context){
                      return OrderProcessing(id: orderID,status: status,);}));
                  }

                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(25),ScreenUtil().setWidth(40),ScreenUtil().setWidth(25),0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Theme.of(context).primaryColor,width: 4)
                    ),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: ScreenUtil().setHeight(60),
                            width: ScreenUtil().setWidth(240),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(10),
                                ),
                                color: Theme.of(context).primaryColor
                            ),
                            child: Center(
                                child: CustomText(text: status,size: ScreenUtil().setSp(30),color: status=='Active'?Colors.green:status=='Processing'?Colors.yellow:Colors.red,)),
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.all(ScreenUtil().setWidth(25)),
                          child: CustomText(
                            text: '#$orderID',
                            color: Theme.of(context).primaryColor,
                            size: ScreenUtil().setSp(60),
                          ),
                        ),
                      ],
                    ),
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
