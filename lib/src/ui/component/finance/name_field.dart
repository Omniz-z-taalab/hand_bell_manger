import 'package:flutter/material.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/ui/component/finance/elements.dart';

class NameField extends StatefulWidget {
  const NameField({Key? key}) : super(key: key);

  @override
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
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
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          const SizedBox(
            width: 30,
            height: 30,
            child: const Icon(
              Icons.title,
              color: mainColorLite,
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
                  return 'please enter finance title';
                return null;
              },
              onSaved: (String? value) {
                if(value!.isNotEmpty){
                  setState(() {
                    FinanceUtils.title = value.trim();
                  });
                }
              },
              onChanged: (value){
                if(value.isNotEmpty){
                  setState(() {
                    FinanceUtils.title = value.trim();
                  });
                }
              },
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintStyle: const TextStyle(
                  fontSize: 12,
                ),
                hintText: 'Finance Title',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
