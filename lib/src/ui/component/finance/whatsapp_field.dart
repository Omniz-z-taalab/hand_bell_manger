import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_bill_manger/src/ui/component/finance/elements.dart';

class WhatsappField extends StatefulWidget {
  const WhatsappField({Key? key}) : super(key: key);

  @override
  State<WhatsappField> createState() => _WhatsappFieldState();
}

class _WhatsappFieldState extends State<WhatsappField> {
  final TextEditingController controller = TextEditingController();
  final RegExp whatsAppReg = RegExp(
      r'https?\:\/\/(www\.)?chat(\.)?whatsapp(\.com)?\/.*(\?v=|\/v\/)?[a-zA-Z0-9_\-]+$');
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
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Row(
              children: [
                Image.asset("assets/icons/whatsappp.png",
                fit: BoxFit.cover,width: 70.w,height: 100.h,)
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
                if (value!.isNotEmpty && !whatsAppReg.hasMatch(value))
                  return 'Invalid WhatsApp link';
                return null;
              },
              onSaved: (String? value) {
                if (value!.isEmpty) value = null;
                setState(() {
                  FinanceUtils.whatsApp = value!.trim();
                });
              },
              onChanged: (String? value){
                if (value!.isEmpty) value = null;
                setState(() {
                  FinanceUtils.whatsApp = value!.trim();
                });
              },
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                hintStyle: const TextStyle(
                  fontSize: 11,
                ),
                hintText: 'https://wa.me/1XXXXXXXXXX',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
