import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:quickbakes/screens/admin/admin-completed-pre.dart';
import 'package:quickbakes/screens/admin/admin-pending.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> with SingleTickerProviderStateMixin{
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
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
            Tab(icon: Icon(Icons.hourglass_empty),text: 'Pending to Withdraw',),
            Tab(icon: Icon(Icons.verified_user),text: 'Completed',),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          AdminPending(),
          AdminCompletedPre()
        ],
      ),
    );
  }
}
