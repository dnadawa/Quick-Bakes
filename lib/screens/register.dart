import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:quickbakes/widgets/custom-text.dart';
import 'package:quickbakes/widgets/input-field.dart';
import 'package:quickbakes/widgets/toast.dart';

class SignUp extends StatelessWidget {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();


  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference collectionReference = Firestore.instance.collection('users');

  signUp() async {
    if(email.text!='' && password.text!='' && name.text!=''&& address.text!=''){
      try{
        AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email.text, password: password.text);
        FirebaseUser user = result.user;
        print(user.uid);

        await collectionReference.document(email.text).setData({
          'name': name.text,
          'email': email.text,
          'address': address.text,
          'phone': phone.text,
        });

        name.clear();
        address.clear();
        email.clear();
        phone.clear();
        password.clear();
        ToastBar(color: Colors.green,text: 'Signed Up Successfully!').show();
      }
      catch(E){
        ToastBar(color: Colors.red,text: 'Something Went Wrong!').show();
        print(E);
      }
    }else{
      ToastBar(color: Colors.red,text: 'Please Fill all the Fields!').show();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520,allowFontScaling: false);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('images/back.png'),fit: BoxFit.fill),
            ),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: (){
                            Navigator.pop(context);
                        },
                        child: Container(
                          height: ScreenUtil().setHeight(150),
                          width: ScreenUtil().setWidth(250),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))
                          ),
                          child: Center(
                              child: CustomText(text: 'SIGN IN',size: ScreenUtil().setSp(40),)),
                        ),
                      ),
                    ),
//                    Align(
//                      alignment: Alignment.topRight,
//                      child: Container(
//                          width: ScreenUtil().setWidth(350),
//                          height: ScreenUtil().setHeight(350),
//                          child: Image.asset('images/logo.png')),
//                    ),
                  ],
                ),


                Padding(
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(200), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35)),
                  child: CustomText(text: 'Sign Up',size: ScreenUtil().setSp(70)),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), 0),
                          child: InputField(hint: 'Full Name',controller: name,),
                        ),

                        Padding(
                          padding:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), 0),
                          child: InputField(hint: 'Address',controller: address),
                        ),

                        Padding(
                          padding:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), 0),
                          child: InputField(hint: 'Phone Number',controller: phone,type: TextInputType.phone,),
                        ),

                        Padding(
                          padding:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), 0),
                          child: InputField(hint: 'Email',type: TextInputType.emailAddress,controller: email,),
                        ),

                        Padding(
                          padding:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), 0),
                          child: InputField(hint: 'Password',isPassword: true,controller: password,),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(70)),
                          child: GestureDetector(
                            onTap: ()=>signUp(),
                            child: Container(
                              height: ScreenUtil().setHeight(120),
                              width: ScreenUtil().setWidth(320),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      CustomText(text: "Submit",size: ScreenUtil().setSp(40),),
                                      SizedBox(width: ScreenUtil().setWidth(20),),
                                      Icon(Icons.assignment_turned_in,color: Colors.white,size: 27,),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
