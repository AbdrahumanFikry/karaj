import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karaj/bindings/widgets.dart';
import 'package:karaj/controllers/sosController.dart';
import 'package:karaj/ui_widgets/animations/fade_animation.dart';

class SosStepOneScreen extends StatelessWidget {

  final SosController _sosCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Get.height * 0.1),
          FadeAnimation(delay: 0.1,child: Center(child: Text('sos'.tr, style: TextStyle(fontWeight: FontWeight.bold),))),
          FadeAnimation(delay: 0.2,child: Text('sosTypeText'.tr, textAlign: TextAlign.center, style: TextStyle(fontSize: 13.0, color: Colors.grey),)),
          SizedBox(height: Get.height * 0.03),
          cardContainer(icon: Icons.person_search_outlined, text: 'missingPerson'.tr, index: 0),
          cardContainer(icon: Icons.car_repair, text: 'stuckVehicle'.tr, index: 1),
          cardContainer(icon: Icons.supervised_user_circle_outlined, text: 'stuckPeople'.tr, index: 2),
        ],
      ),
    );
  }

  Widget cardContainer({IconData icon, String text, int index}) {
    bool active = _sosCtrl.information['typeIndex'] == index;

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
            _sosCtrl.information['typeIndex'] = index;
            _sosCtrl.information['subTypeIndex'] = null;
            _sosCtrl.information['type'] = text;
            _sosCtrl.updateData(_sosCtrl.information);
            _sosCtrl.animToPage(index: 1);
          },
          leading: Icon(icon, color: !active ? Colors.black : Colors.white),
          title: Text(text ?? '', style: TextStyle(color: !active ? Colors.black : Colors.white),),
        ),
      ),
    );
  }
}



