import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/ui/component/finance/elements.dart';

class DescriptionField extends StatefulWidget {
  const DescriptionField({Key? key}) : super(key: key);

  @override
  State<DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<DescriptionField> {
  final TextEditingController controller = TextEditingController();
  bool initializedName = false;

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
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Finance description',
              style: TextStyle(color: Colors.black26),
            ),
          ),
          TextFormField(
            controller: controller,
            // textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            maxLength: 600,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              /*  border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  borderSide: const BorderSide(color: Colors.teal)),*/
              hintStyle: const TextStyle(
                fontSize: 12,
              ),
              hintText: "Explain your finance",
            ),
            validator: (String? value) {
              return null;
            },
            onSaved: (String? value) {
              if(value!.isNotEmpty){
                setState(() {
                  FinanceUtils.desc = value.trim();
                });
              }
            },
            onChanged:(String? value) {
              if(value!.isNotEmpty){
                setState(() {
                  FinanceUtils.desc = value.trim();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
