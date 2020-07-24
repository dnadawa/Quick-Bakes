import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickbakes/screens/checkout.dart';
import 'package:quickbakes/widgets/button.dart';
import 'package:quickbakes/widgets/custom-text.dart';

class CustomOffers extends StatefulWidget {
  final String id;
  final String userEmail;
  const CustomOffers({Key key, this.id, this.userEmail}) : super(key: key);

  @override
  _CustomOffersState createState() => _CustomOffersState();
}

class _CustomOffersState extends State<CustomOffers> {
  var requestList;
  //double lat,long;
  double lat  = 0;
  double long = 0;
  var subscripton;
  getData(){
    subscripton = Firestore.instance.collection('request').document(widget.id).collection('offers').snapshots().listen((datasnapshot){
      setState(() {
        requestList = datasnapshot.documents;
      });
    });
  }

  getLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }

   calculateDistance({double sLat,double sLong,double eLat,double eLong}) async {
    double distance = await Geolocator().distanceBetween(sLat, sLong, eLat, eLong);
    return distance;
  }

  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    getData();
    //getLocation();
  }

  @override
  void dispose() {
    super.dispose();
    subscripton?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520, allowFontScaling: false);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: CustomText(text: 'Custom Offers',),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('images/back.png'),fit: BoxFit.fill)
          ),
          child: requestList!=null?
          requestList.isNotEmpty?ListView.builder(
            itemCount: requestList.length,
            itemBuilder: (context,i) {
              String bakeryName = requestList[i]['bakeryName'];
              String bakeryEmail = requestList[i]['bakeryEmail'];
              String price = requestList[i]['price'];
              String description = requestList[i]['description'];
              double bLat = requestList[i]['lat'];
              double bLong = requestList[i]['long'];

              return FutureBuilder(
                future:calculateDistance(sLat: lat,sLong: long,eLat: bLat,eLong: bLong),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    double d = roundDouble(snapshot.data/1000, 2);
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
                                        child: CustomText(text: bakeryName,size: ScreenUtil().setSp(40),)),
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
                                    child: CustomText(text: 'Distance - $d KM',size: ScreenUtil().setSp(35),color: Theme.of(context).accentColor,)),
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
                              text: 'Order Now',
                              onTap: (){
                                Navigator.push(context, CupertinoPageRoute(builder: (context){
                                  return Checkout(orderID: widget.id,price: int.parse(price),bakeryName: bakeryName,userEmail: widget.userEmail,bakeryEmail: bakeryEmail,);}));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }else{
                    return SizedBox.shrink();
                  }
                },
              );
            },
          ):Center(
            child: CustomText(text: 'No Requests found!',size: ScreenUtil().setSp(50),),
          ):Center(child: CircularProgressIndicator(),),
        )
    );
  }
}
