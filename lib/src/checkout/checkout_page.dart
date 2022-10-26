import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_bill_manger/src/checkout/enums/payment_method.dart';
import 'package:hand_bill_manger/src/checkout/widgets/small_checkout_widgets.dart';

class CheckOutPage extends StatefulWidget {
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border ;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool check = false;
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black26,
          width: 1.0),
      borderRadius: BorderRadius.circular(20.0),
    );
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        centerTitle: true,
        title: Text(
          "PAYMENT CONFIRMATION",
          style: TextStyle(color: Colors.black26),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Image.asset(
              "assets/images/hb_logo.jpeg",
              width: 14,
              height: 10,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: controller,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              vertical: 20.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 30.h),
                  child: RichText(
                    text: new TextSpan(
                        text: 'MEET AHMED   ',
                        style:TextStyle(color: Colors.black26),
                        children: [
                          new TextSpan(
                            text: '05043423',
                            style: TextStyle(color: Colors.black26),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () => print('Tap Here onTap'),
                          )
                        ]),
                  ),
                ),

                /// Card details of payment
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 8,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 300.w,
                          height: 300.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.black26),
                            image: DecorationImage(
                                image: AssetImage("assets/images/hb_logo.jpeg"),
                                fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(width: 35.w,),
                        Container(
                          height: 300.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.payment,),
                                  Text(
                                    "CYCLE WITH MOZA",
                                    style: TextStyle(color: Colors.black38),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              SmallCheckOutWidgets.smallItem(
                                  title: "TODAY,FROM 7.00PM",
                                  iconData: Icons.directions_bus),
                              SmallCheckOutWidgets.smallItem(
                                  title: "Bussiness Bay,Dubai,UAE",
                                  iconData: Icons.location_on_sharp),
                              SmallCheckOutWidgets.smallItem(
                                  title: "TODAY,FROM 7.00PM",
                                  iconData: Icons.notifications_active),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50.h,),

                /// Payment Method container
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Method:",
                          style: TextStyle(color: Colors.black38),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        SmallCheckOutWidgets.paymentMethod(
                            PaymentEnums.CASH, context, "Cash"),
                        SizedBox(
                          height: 15.h,
                        ),
                        SmallCheckOutWidgets.paymentMethod(
                            PaymentEnums.CREDIT, context, "Credit/Debit Card"),
                        SizedBox(
                          height: 15.h,
                        ),
                        SmallCheckOutWidgets.paymentMethod(
                            PaymentEnums.APPLE_PAY, context, "Apple Pay"),
                        SizedBox(
                          height: 15.h,
                        ),
                        SmallCheckOutWidgets.paymentMethod(
                            PaymentEnums.GOOGLE_PAY, context, "Google Pay"),
                      ],
                    )),

                /// Card Information container
                if(PaymentEnums.CREDIT==PaymentEnums.CREDIT)...[
                  SmallCheckOutWidgets.titleCheckOutText("Card Information:"),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:Colors.black38,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 8,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Container(
                      // margin: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Text("Card Number: "),
                          CreditCardForm(
                            obscureCvv: true,
                            // obscureNumber: true,
                            cardNumber: cardNumber,
                            cvvCode: cvvCode,
                            isHolderNameVisible: true,
                            isCardNumberVisible: true,
                            isExpiryDateVisible: true,
                            cardHolderName: cardHolderName,
                            expiryDate: expiryDate,
                            themeColor: Colors.blue,
                            textColor: Colors.black54,
                            cardNumberDecoration: InputDecoration(
                              labelText: 'Card Number',
                              hintText: 'XXXX XXXX XXXX XXXX',
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 0.0,
                                  horizontal: 10),
                              hintStyle:  TextStyle(color: Colors.black26),
                              labelStyle: TextStyle(color: Colors.black26),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              hoverColor: Colors.white,
                              focusedBorder:border,
                              enabledBorder: border,
                            ),
                            expiryDateDecoration: InputDecoration(
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 0.0,
                                  horizontal: 10),
                              hintStyle:  TextStyle(color: Colors.black26),
                              labelStyle: TextStyle(color: Colors.black26),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              hoverColor: Colors.white,
                              focusedBorder:border,
                              enabledBorder: border,
                              labelText: 'Expired Date',
                              hintText: 'XX/XX',
                            ),
                            cvvCodeDecoration: InputDecoration(
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 0.0,
                                  horizontal: 10),
                              hintStyle:  TextStyle(color: Colors.black26),
                              labelStyle: TextStyle(color: Colors.black26),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              hoverColor: Colors.white,
                              focusedBorder:border,
                              enabledBorder: border,
                              labelText: 'CVV',
                              hintText: 'XXX',
                            ),
                            cardHolderDecoration: InputDecoration(
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 0.0,
                                  horizontal: 10),
                              hintStyle: TextStyle(color: Colors.black26),
                              labelStyle: TextStyle(color: Colors.black26),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              hoverColor: Colors.white,
                              focusedBorder:border,
                              enabledBorder: border,
                              labelText: 'Card Holder',
                            ),
                            onCreditCardModelChange: onCreditCardModelChange,
                            formKey: formKey,
                            cursorColor: Colors.black26,
                          ),
                          SizedBox(height: 500.h,),
                        ],
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: (){
                print("n:$cardNumber");
              },
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                width: 510.w,
                height: 110.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "CONFIRM PAYMENT-50 AED",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ),
        ],
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
