import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/ui/component/finance/elements.dart';

class PriceField extends StatefulWidget {
  const PriceField({Key? key}) : super(key: key);

  @override
  State<PriceField> createState() => _PriceFieldState();
}

class _PriceFieldState extends State<PriceField> {
  final TextEditingController controller = TextEditingController();
  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 5),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Row(
              children: [
                const Icon(
                  Icons.money,
                  size: 20,
                  color: mainColorLite,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              maxLines: 1,
              minLines: 1,
              autocorrect: true,
              validator: (String? value) {
                if (value == null || value.isEmpty)
                  return 'Must add event cost';
                int? parsedValue = int.tryParse(value);
                if (parsedValue == null)
                  return 'Please enter a valid integer cost';
                return null;
              },
              onSaved: (String? value) {
                if(value!.isNotEmpty){
                  setState(() {
                    FinanceUtils.cost = value.trim();
                  });
                }
              },
              onChanged: (String? value) {
                if(value!.isNotEmpty){
                  setState(() {
                    FinanceUtils.cost = value.trim();
                  });
                }
              },
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintStyle: const TextStyle(
                  fontSize: 11,
                ),
                hintText: 'Cost - 1000 \$',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
