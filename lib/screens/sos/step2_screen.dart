import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karaj/bindings/widgets.dart';
import 'package:karaj/controllers/sosController.dart';
import 'package:karaj/ui_widgets/animations/fade_animation.dart';

class SosStepTwoScreen extends StatelessWidget {

  final SosController _sosCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    int typeIndex = _sosCtrl.information['typeIndex'] ?? 0;
    int index = 0;
    return SingleChildScrollView(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Get.height * 0.1),
          FadeAnimation(delay: 0.2,child: Text(_sosCtrl.information['type'] ?? '', textAlign: TextAlign.center, style: TextStyle(fontSize: 14.0, color: Colors.grey),)),
          SizedBox(height: Get.height * 0.03),
          for(String text in _sosCtrl.subTypes[typeIndex])
            cardContainer(icon: Icons.person_search_outlined, text: text, index: index++),

        ],
      ),
    );
  }

  Widget cardContainer({IconData icon, String text, int index}) {
    bool active = _sosCtrl.information['subTypeIndex'] == index;

    return FadeAnimation(
      delay: (index * 0.3) + 0.3,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 350),
        margin: EdgeInsets.only(bottom: 15.0),
        decoration: BoxDecoration(
            color: active ? Colors.black : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 1,
                  offset: Offset(0,0)
              )
            ]
        ),
        child: ListTile(
          onTap: () {
            _sosCtrl.information['subTypeIndex'] = index;
            _sosCtrl.information['subType'] = text;
            _sosCtrl.updateData(_sosCtrl.information);
            _sosCtrl.animToPage(index: 2);
          },
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(text ?? '', style: TextStyle(color: !active ? Colors.black : Colors.white),),
          ),
        ),
      ),
    );
  }
}



