import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/data/model/finance/finance_mode.dart';
import 'package:hand_bill_manger/src/repositories/finance_repositry_change_later.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/component/finance/elements.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FinanceScreen extends StatefulWidget {
  static const routeName = "/UsersJobsScreen";
  @override
  _FinanceScreenScreenState createState() => _FinanceScreenScreenState();
}

class _FinanceScreenScreenState extends State<FinanceScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double iconSize = 24;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xfff5f5f5),
        appBar: RegularAppBar(
            label: "Finance",
            widget: InkWell(
                onTap: () async{
                 final result = await FinanceUtils.showFilterBottomSheet(context);
                 if(result == true)setState(() {});
                },
                child: Icon(Icons.add))),
        body: FutureBuilder(
          future: FinanceRepository.getAllFinance(),
          builder: (context,AsyncSnapshot<List<FinanceModel>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting)
              return const Center(child: CircularProgressIndicator(),);
            if(snapshot.hasData && snapshot.data!.length != 0){
              return RefreshIndicator(
                  child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return FinanceUtils.smallCard(context: context,
                        financeModel: snapshot.data![index]);
                  },
                  separatorBuilder:(context, index) => SizedBox(height: 40.w,),
                  itemCount: snapshot.data!.length),
                  onRefresh: ()async{setState(() {});});
            }
            return const SizedBox();
          },
        ),

    );
  }
}

