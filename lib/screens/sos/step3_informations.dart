import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karaj/bindings/widgets.dart';
import 'package:karaj/controllers/sosController.dart';
import 'package:karaj/screens/map/select_location_new.dart';
import 'package:karaj/ui_widgets/animations/fade_animation.dart';

class InformationScreen extends GetWidget<SosController> {

  final Map<int, Widget> yesNo = <int, Widget> {
    0: Padding(padding: EdgeInsets.only(top: 5.0, bottom: 7.0), child: Text('no'.tr)),
    1: Padding(padding: EdgeInsets.only(top: 5.0, bottom: 7.0), child: Text('yes'.tr)),
  };

  final Map<int, Widget> beneficiaryWidget = <int, Widget> {
    0: Padding(padding: EdgeInsets.only(top: 5.0, bottom: 7.0), child: Text('personnel'.tr)),
    1: Padding(padding: EdgeInsets.only(top: 5.0, bottom: 7.0), child: Text('family'.tr)),
  };

  @override
  Widget build(BuildContext context) {

    return Obx(
      () => Scaffold(
        backgroundColor: Get.theme.backgroundColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: Get.height * 0.01),
              FadeAnimation(delay: 0.1,child: Center(child: Text('sosInformation'.tr, style: TextStyle(fontWeight: FontWeight.bold),))),
              SizedBox(height: Get.height * 0.01),
              segmentContainer(name: 'beneficiary', children: beneficiaryWidget),
              segmentContainer(name: 'suffers'),
              segmentContainer(name: 'sosNeeds'),
              controller.information['sosNeeds'] == 1 ?
                FadeAnimation(
                  delay: 0.1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                    child: TextFormField(
                      controller: controller.needTo,
                      onSaved: (value) {
                        controller.needTo.text = value;
                      },

                      decoration: inputDecorationUi(context, 'needToText'.tr, color: Colors.grey[200]),
                      keyboardType: TextInputType.text,
                      minLines: 3,
                      maxLines: 5,
                    ),
                  ),
                ) : SizedBox.shrink(),
              segmentContainer(name: 'injuries'),
              segmentContainer(name: 'vehicleDamaged'),
              segmentContainer(name: 'weakWifi'),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('batteryBalance', style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                child: FadeAnimation(
                  delay: 0.1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                    child: Slider(
                      min: 0,
                      max: 100,
                      value: double.tryParse(controller.information['batteryBalance'].toString() ?? "0") ?? 15,
                      label: "${controller.information['batteryBalance'].toString()}%",
                      divisions: 100,
                      onChanged: (value) {
                        controller.information['batteryBalance'] = value.toInt();
                        controller.updateData(controller.information, doUpdate: false);
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),
              Center(
                child: TextFormField(
                  controller: controller.phone,
                  onSaved: (value) {
                    controller.phone.text = value;
                  },
                  decoration: inputDecorationUi(context, 'phone'.tr, color: Get.theme.scaffoldBackgroundColor),
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                ),
              ),
              SizedBox(height: 15),
              FadeAnimation(
                delay: 0.2,
                child: Container(
                  width: Get.width,
                  child: normalFlatButtonWidget(
                    context: context,
                    colour: Colors.grey[200],
                    textColor: Colors.black,
                    text: controller.information['latlng'] != null ? controller.information['latlng'] : 'selectLocation'.tr,
                    padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                    radius: 5.0,
                    callFunction: () async{
                      Map<String, dynamic> result = await Get.to(SelectLocation());
                      if(result != null) {
                        controller.information['address'] = result['address'] ?? null;
                        controller.information['lat'] = result['lat'] ?? '';
                        controller.information['lng'] = result['lng'] ?? '';
                        controller.information['latlng'] = result['latlng'] ?? null;
                        controller.information['addressData'] = result;

                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.03),

              controller.information['latlng'] != null ?Container(
                width: Get.width,
                child: normalFlatButtonWidget(
                  context: context,
                  colour: Colors.redAccent,
                  text: 'mayDay'.tr,
                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                  radius: 5.0,
                  callFunction: () async{
                    await controller.sendMayday();
                  },
                ),
              ) : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }


  Widget segmentContainer({String name, Map<int, Widget> children}) {
    children = children ?? yesNo;
    return  FadeAnimation(
      delay: 0.1,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(name.tr, style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 15.0, top: 3),
            child: CupertinoSegmentedControl(
              children: children,
              borderColor: Get.theme.primaryColor,
              pressedColor: Get.theme.primaryColor,
              selectedColor: Get.theme.primaryColor,
              onValueChanged: (var val) {
                print(val);
                controller.information[name] = val;
                controller.updateData(controller.information, doUpdate: false);
              },
              groupValue: controller.information[name],
            ),
          ),
        ],
      ),
    );
  }
}
