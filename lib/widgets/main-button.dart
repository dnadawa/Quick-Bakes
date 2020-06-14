import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'custom-text.dart';

class MainButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const MainButton({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Material(
        elevation: 7,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: ScreenUtil().setWidth(450),
          height: ScreenUtil().setHeight(100),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
              child: CustomText(text: text,color: Colors.black,size: ScreenUtil().setSp(40),)
          ),
        ),
      ),
    );
  }
}
