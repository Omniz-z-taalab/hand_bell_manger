
import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/ui/component/finance/elements.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatesField extends StatefulWidget {
  const DatesField({Key? key}) : super(key: key);

  @override
  State<DatesField> createState() => _DatesFieldState();
}

class _DatesFieldState extends State<DatesField> {
  PickerDateRange? initalRange;
  bool isInitialized = false;

  String selectedDate = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today_sharp,
                color: mainColorLite,
              ),
              const SizedBox(width: 10),
              Text(
                'Date:',
                style: TextStyle(color: Colors.black45),
              ),
            ],
          ),
          Container(
            width: double.maxFinite,
            //   height: 150,
            margin: const EdgeInsets.only(
              top: 8,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  blurRadius: 2,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () async {
                  await selectDateDialog(context);
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.black26,
                    ),
                  ),
                  child: Text(
                    'Select start and end dates',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text(
                       "$selectedDate",
                        style: TextStyle(color: Colors.black),
                      ),
                  ],
                ),

                SizedBox(height: 8),
              ],
            ),
          )
        ],
      ),
    );
  }

  selectDateDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Container(
              constraints: BoxConstraints(
                minWidth: 200,
                maxWidth: 400,
                minHeight: 320,
                maxHeight: 420,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Done',
                                  style: TextStyle(),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'Select Dates',
                          textAlign: TextAlign.center,
                          style: TextStyle(),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 300,
                          child: SfDateRangePicker(
                            onSelectionChanged:
                                (DateRangePickerSelectionChangedArgs args) {
                                  setState(() {
                                    selectedDate = args.value.toString().split(" ").first;
                                    FinanceUtils.date = selectedDate.trim();
                                  });
                               Navigator.of(context).pop();
                            },
                            initialSelectedRange: initalRange,
                            selectionMode: DateRangePickerSelectionMode.single,
                            initialSelectedDate: DateTime.now(),
                            rangeSelectionColor:
                                Colors.black26,
                            startRangeSelectionColor:  Colors.black26,
                            endRangeSelectionColor: Colors.black26,
                            enablePastDates: false,
                            minDate: DateTime.now(),
                            monthViewSettings: DateRangePickerMonthViewSettings(
                              enableSwipeSelection: true,
                            ),
                            headerStyle: DateRangePickerHeaderStyle(
                              textAlign: TextAlign.center,
                              textStyle: TextStyle(),
                            ),
                            navigationDirection:
                                DateRangePickerNavigationDirection.horizontal,
                            showNavigationArrow: true,
                            view: DateRangePickerView.month,
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
