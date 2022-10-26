import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/plan_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlanDetails extends StatelessWidget {
  final PlanModel? planModel;
  final String? expDate;
  const PlanDetails({Key? key,this.planModel,this.expDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(this.planModel!.createdAt.toString()).toLocal();
    return Padding(
        padding:EdgeInsets.all(5),
        child: Container(
          alignment: Alignment.center,
          height: 510.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    focusColor: Colors.red,
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close,color: Colors.red,),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${this.planModel!.name} Plan Detail\`s", style: TextStyle(color: mainColor,
                          fontSize: 17),),
                      SizedBox(height: 5,),
                      Text("Exp-Date: ${this.expDate}",style: TextStyle(color: Colors.black,
                      fontSize: 12,fontWeight: FontWeight.bold),)
                    ],
                  ),),
                ],
              ),
              Divider(thickness: 5,),
              SizedBox(height: 10,),
              Text(" Start Date: ${dateTime.year}-${dateTime.month}-${dateTime.day}"
                  "\n Price: ${this.planModel!.price} \$"
                  "\n No.Images: ${this.planModel!.numImages}"
                  "\n No.Videos: ${this.planModel!.numVideos}"
                  "\n No.Assets: ${this.planModel!.numAssets}"
                  "\n No.Products: ${this.planModel!.numProducts}"
                  "\n No.Jobs: ${this.planModel!.numJobs}"
                  "\n No.Offers: ${this.planModel!.numOffers}",
              style: TextStyle(color: Colors.black87),)
            ],
          ),
        )
    );
  }
}
