import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:quickbakes/screens/bakery/bakery-completed-orders.dart';
import 'package:quickbakes/screens/bakery/bakery-custom-offers.dart';
import 'package:quickbakes/screens/bakery/bakery-orders.dart';
import 'package:quickbakes/screens/post-a-request.dart';

class BakeryHome extends StatefulWidget {
  @override
  _BakeryHomeState createState() => _BakeryHomeState();
}

class _BakeryHomeState extends State<BakeryHome> with SingleTickerProviderStateMixin{
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520, allowFontScaling: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff9d547),
      bottomNavigationBar: Material(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        child: TabBar(
          controller: tabController,
          indicatorColor: Theme.of(context).accentColor,
          labelStyle: TextStyle(fontSize: ScreenUtil().setSp(25),fontWeight: FontWeight.bold),
          labelColor: Theme.of(context).accentColor,
          unselectedLabelColor: Colors.white,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.mail),text: 'Custom Offers',),
            Tab(icon: Icon(Icons.assignment),text: 'Orders',),
            Tab(icon: Icon(Icons.verified_user),text: 'Completed Orders',),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          BakeryCustomOffers(),
          BakeryOrders(),
          BakeryCompletedOrders()
        ],
      ),
    );
  }
}
