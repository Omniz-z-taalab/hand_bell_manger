import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/finance/finance_mode.dart';
import 'package:hand_bill_manger/src/helper/snackbars_builder.dart';
import 'package:hand_bill_manger/src/repositories/finance_repositry_change_later.dart';
import 'package:hand_bill_manger/src/ui/component/finance/whatsapp_field.dart';
import 'package:hand_bill_manger/src/ui/component/finance/name_field.dart';
import 'package:hand_bill_manger/src/ui/component/finance/price_field.dart';
import 'package:hand_bill_manger/src/ui/component/finance/description_field.dart';
import 'package:hand_bill_manger/src/ui/component/finance/dates_Field.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class FinanceUtils{
  static String? title,desc,date,type,whatsApp,cost;
  static showFilterBottomSheet(BuildContext context) async {
    return showBarModalBottomSheet(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: Colors.black),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(14),
          topLeft: Radius.circular(14),
        ),
      ),
      duration: Duration(milliseconds: 600),
      barrierColor: Colors.transparent.withOpacity(0.5),
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const AddFinance();
      },
    );
  }

  static smallCard({required BuildContext context,
  required FinanceModel financeModel}){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black38,width: 2),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${financeModel.title}",
                style: const TextStyle(color: mainColor),),
              Text("date:${financeModel.date}",
                style: const TextStyle(color: Colors.black45),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text("${financeModel.type}",
                    style: const TextStyle(color: Colors.black38),),
                  SizedBox(width: 20.w,),
                  Text("${financeModel.cost}",
                    style: const TextStyle(color: mainColorLite),),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 20.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: ()async{
                            showDialog(context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(onPressed: (){
                                          Navigator.of(context).pop();
                                        }, icon: Icon(Icons.close,color: Colors.red,)),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    content: Text("${financeModel.description}",softWrap: true,maxLines: 5,overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black38,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2.0),),
                                  );
                                },);
                          },
                          child: Icon(Icons.description,color: Colors.black38,)
                      ),
                      SizedBox(width: 20.w,),
                      GestureDetector(
                        onTap: ()async{
                          await canLaunch("${financeModel.whatsApp}")?
                          launch("${financeModel.whatsApp}"):
                          SnackBarsBuilder.showFeedBackMessage(context, "Can not ${financeModel.whatsApp}"
                              , Colors.red);
                        },
                        child: Image.asset("assets/icons/whatsappp.png",
                          height: 70.h,width: 80.w,
                          fit: BoxFit.contain,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class AddFinance extends StatefulWidget {
  const AddFinance({Key? key}) : super(key: key);
  @override
  _AddFinanceState createState() => _AddFinanceState();
}

class _AddFinanceState extends State<AddFinance> {
  bool loading = false;
  @override
  void initState() {
    _dropDownMenuItemsDept = _getDropDownMenuItemsDept();
    FinanceUtils.type = _selectedDept;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Need a FINANCE !',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                const Divider(thickness: 2),
                const SizedBox(height: 5),
                const NameField(),
                const SizedBox(height: 10),
                const WhatsappField(),
                const SizedBox(height: 10),
                SizedBox(height: 100.h,child: const PriceField(),),
                const SizedBox(height: 20),
                const DatesField(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Need A Finance As",style: TextStyle(color: Colors.black38,
                        fontSize: 30.h),),
                    SizedBox(width: 30.w,),
                    DropdownButton(
                      items:_dropDownMenuItemsDept,
                      style: TextStyle(color: Colors.black),
                      onChanged: _changeDrownDept,
                      value: _selectedDept,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const DescriptionField(),
                const SizedBox(height: 30),
                MaterialButton(
                  onPressed: () async {
                   await addFinance();
                  },
                  minWidth: 120,
                  color: mainColor,
                  disabledColor: Colors.grey.shade400,
                  disabledTextColor: Colors.white,
                  textColor: Colors.white,
                  height: 45,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: loading==true?
                  CircularProgressIndicator(color: Colors.white,):
                  Text("ADD YOUR REQUEST"),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        )
    );
  }

  String _selectedDept = "Company Need Finance";
  void _changeDrownDept(String? selectedItem) {
    setState(() {
      _selectedDept = selectedItem!;
      FinanceUtils.type = _selectedDept;
      print(_selectedDept);
    });
  }

  List<DropdownMenuItem<String>>? _dropDownMenuItemsDept;
  // String? _statusCity;
  List<DropdownMenuItem<String>> _getDropDownMenuItemsDept() {
    List<DropdownMenuItem<String>>? itemsItemsDept = [];
    itemsItemsDept.add(new DropdownMenuItem(
      child: new Text('Company Need Finance'),
      value: 'Company Need Finance',
    ));
    itemsItemsDept.add(new DropdownMenuItem(
      child: new Text('Company Provide Finance'),
      value: 'Company Provide Finance',
    ));
    itemsItemsDept.add(new DropdownMenuItem(
      child: new Text('Company search for aquisation'),
      value: 'Company search for aquisation',
    ));
    itemsItemsDept.add(new DropdownMenuItem(
      child: new Text('Company ask for Joint Venture'),
      value: 'Company ask for Joint Venture',
    ));
    return itemsItemsDept;
  }
  final RegExp whatsAppReg = RegExp(
      r'https?\:\/\/(www\.)?chat(\.)?whatsapp(\.com)?\/.*(\?v=|\/v\/)?[a-zA-Z0-9_\-]+$');
  Future addFinance()async{
    if(FinanceUtils.title==null) return SnackBarsBuilder.showFeedBackMessage(context, "please add title", Colors.green);
    if(FinanceUtils.whatsApp==null) return SnackBarsBuilder.showFeedBackMessage(context, "please add whatsApp", Colors.green);
    if(whatsAppReg.hasMatch(FinanceUtils.whatsApp.toString())) return SnackBarsBuilder.showFeedBackMessage(context, "Invalid WhatsApp link", Colors.green);
    if(FinanceUtils.cost==null) return SnackBarsBuilder.showFeedBackMessage(context, "please add cost", Colors.green);
    if(FinanceUtils.date==null) return SnackBarsBuilder.showFeedBackMessage(context, "please add date", Colors.green);
    if(FinanceUtils.desc==null) return SnackBarsBuilder.showFeedBackMessage(context, "please add description", Colors.green);
    setState(()=> loading=true);
    try{

      await FinanceRepository.addFinance(
        title: "${FinanceUtils.title!.trim()}",
        date: "${FinanceUtils.date!.trim()}",
        desc: "${FinanceUtils.desc!.trim()}",
        whatsApp: "${FinanceUtils.whatsApp!.trim()}",
        type: "${FinanceUtils.type!.trim()}",
        cost: "${FinanceUtils.cost!.trim()}",
      ).then((value) {
        if(value==true){
          SnackBarsBuilder.showFeedBackMessage(context,
              "Your Finance Request Added Successfully", Colors.green);
          Navigator.pop(context,true);
        }else{
          Navigator.pop(context,false);
        }
        setState(()=> loading=false);

      });
    }catch(e){
      setState(()=> loading=false);
      print("${e.toString()}");
    }
  }
}



