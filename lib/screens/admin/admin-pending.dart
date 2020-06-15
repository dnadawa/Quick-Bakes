import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:quickbakes/screens/admin/admin-order-info.dart';
import 'package:quickbakes/widgets/custom-text.dart';

class AdminPending extends StatefulWidget {
  @override
  _AdminPendingState createState() => _AdminPendingState();
}

class _AdminPendingState extends State<AdminPending> {
  var requestList;
  getData(){
    Firestore.instance.collection('orders').where('status', isEqualTo: 'Completed').where('withdrawn',isEqualTo: false).snapshots().listen((datasnapshot){
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
              String userEmail = requestList[i]['userEmail'];
              String bakeryEmail = requestList[i]['bakeryEmail'];
              String bakeryName = requestList[i]['bakeryName'];
              int price = requestList[i]['price'];
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (context){
                      return AdminOrderInfo(id: orderID,userEmail: userEmail,bakeryEmail: bakeryEmail,bakeryName: bakeryName,price: price,);}));
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
