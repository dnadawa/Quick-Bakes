import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:quickbakes/widgets/button.dart';
import 'package:quickbakes/widgets/custom-text.dart';

class BakeryOrders extends StatelessWidget {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
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
                                  child: CustomText(text: '#232322',size: ScreenUtil().setSp(40),)),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: '\$10000',
                              color: Theme.of(context).primaryColor,
                              size: ScreenUtil().setSp(40),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding:  EdgeInsets.all(ScreenUtil().setWidth(25)),
                        child: CustomText(
                          text: "Hello this is lorem ipsum and tharuhirar mijustiti on the functional matter of the sacrifise yourself to the materialable fasion          Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining",
                          color: Theme.of(context).primaryColor,
                          align: TextAlign.justify,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20),),
                      Button(
                        text: 'Mark as Completed',
                        onTap: (){},
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
