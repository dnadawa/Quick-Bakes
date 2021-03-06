import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:quickbakes/screens/home.dart';
import 'package:quickbakes/widgets/button.dart';
import 'package:quickbakes/widgets/custom-text.dart';
import 'package:quickbakes/widgets/toast.dart';
import 'package:stripe_payment/stripe_payment.dart';

class Checkout extends StatefulWidget {
  final String orderID;
  final int price;
  final String bakeryName;
  final String bakeryEmail;
  final String userEmail;
  const Checkout({Key key, this.orderID, this.price, this.bakeryName, this.bakeryEmail, this.userEmail}) : super(key: key);
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String cardNumber ='';
  String expiryDate='';
  String cardHolderName='';
  String cvvCode = '';
  bool isCvvFocused = false;

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  sendMail(String email) async {
    String username = 'quickbakes0@gmail.com';
    String password = 'Admin@quick';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'QuickBakes')
      ..recipients.add(email)
      ..subject = 'You have received an order!'
      ..text = 'You have received an new order from a client! Check it now!';
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: "pk_live_LfxuYv1bfMeGVABtGZjmZCqO00EW7ikXGf",
        androidPayMode: 'live',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520,allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'Checkout',),
        centerTitle: true,
        elevation: 0,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('images/back.png'),fit: BoxFit.fill)
        ),

        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              cardBgColor: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: CreditCardForm(
                  textColor: Colors.white,
                  themeColor: Colors.white,
                  cardHolderName: cardHolderName,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  onCreditCardModelChange: onCreditCardModelChange,
                ),
              ),
            ),
//            Expanded(child: Container()),
            Align(
                alignment: Alignment.bottomCenter,
                child: Button(text: 'Pay',onTap: (){
                  ToastBar(text: 'Please wait',color: Colors.orange).show();
                  print(widget.price);
                  try{
                    final CreditCard testCard = CreditCard(
                      number: cardNumber,
                      expMonth: int.parse(expiryDate[0]+expiryDate[1]),
                      expYear: int.parse(expiryDate[3]+expiryDate[4]),
                      cvc: cvvCode,
                    );

                    //print(int.parse(expiryDate[3]+expiryDate[4]));
                    StripePayment.createTokenWithCard(
                      testCard,
                    ).then((token) async {
                      try{
                        var response = await http.post('https://api.stripe.com/v1/charges',
                          body: {'amount': '${(widget.price*100).toString()}','currency': 'usd',"source": token.tokenId},
                          headers: {'Authorization': "Bearer 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"},
                        );
                        print('Response status: ${response.statusCode}');
                        print('Response body: ${response.body}');

                        if(response.statusCode == 200){
                          await ToastBar(text: 'Payment Completed!',color: Colors.green).show();
                          Firestore.instance.collection('request').document(widget.orderID).updateData({
                            'status': 'Processing',
                            'activeBaker': widget.bakeryEmail
                          });
                          Firestore.instance.collection('request').document(widget.orderID).collection('offers').document(widget.bakeryEmail).updateData({
                            'isActive': true
                          });
                          Firestore.instance.collection('orders').document(widget.orderID).setData({
                            'id': widget.orderID,
                            'bakeryName': widget.bakeryName,
                            'bakeryEmail': widget.bakeryEmail,
                            'price': widget.price,
                            'userEmail': widget.userEmail,
                            'status': 'Processing',
                            'withdrawn': false
                          });
                          sendMail(widget.bakeryEmail);
                          ToastBar(text: 'Data Uploaded!',color: Colors.green).show();
                          Navigator.push(context, CupertinoPageRoute(builder: (context){
                            return Home();}));
                        }
                        else{
                          ToastBar(text: 'Something went Wrong While Processing the Payment',color: Colors.red).show();
                        }
                      }
                      catch(e){
                        ToastBar(text: 'Something went Wrong While Processing the Payment',color: Colors.red).show();
                      }
                    });
                  }
                  catch(e){
                    ToastBar(text: 'Something went Wrong While Processing the Payment',color: Colors.red).show();
                  }
                },)),
          ],
        ),

      ),

    );
  }
}
