import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/data/model/plan_model.dart';
import 'package:hand_bill_manger/src/ui/component/plan_details.dart';

class CustomDialogs{
  static planDetailsDialog(BuildContext context,PlanModel planModel,String expDate) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: PlanDetails(planModel: planModel,expDate: expDate,));
        });
  }


}