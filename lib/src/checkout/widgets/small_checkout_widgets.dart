import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_bill_manger/src/checkout/enums/payment_method.dart';

class SmallCheckOutWidgets{

  static Widget titleCheckOutText(String title){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
      color: Colors.white,
      child: Text(
        "$title",
        style: TextStyle(color: Colors.black38),
      ),
    );
  }
  static Widget smallItem({required String title,required IconData iconData}){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData,color:Colors.black38,
            size: 17,),
          Text("$title",style:TextStyle(),)
        ],
      ),
    );
  }


  static Widget paymentMethod(PaymentEnums paymentEnums,BuildContext context,
      String title){
    bool check = false;
    // if(paymentEnums.index==checkOutProvider.paymentEnums!.index){
    //   check=true;
    // }
    return GestureDetector(
      onTap: (){
        // checkOutProvider.setPaymentEnums = paymentEnums;
      },
      child: Container(
        decoration: BoxDecoration(
          color:Colors.black26,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 9,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              activeColor: Colors.black,
              value: check,
              shape: CircleBorder(),
              onChanged: (bool? value) {
                check=value!;
              },
            ),
            Icon(Icons.money),
            SizedBox(width: 20.w,),
            Text("$title",),
          ],
        ),
      ),
    );
  }

}