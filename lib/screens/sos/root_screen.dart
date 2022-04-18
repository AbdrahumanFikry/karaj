import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:karaj/bindings/widgets.dart';
import 'package:get/get.dart';
import 'package:karaj/controllers/sosController.dart';
import 'package:karaj/models/sos.dart';
import 'package:karaj/screens/sos/card_sos_informaion.dart';
import 'package:karaj/screens/sos/step1_screen.dart';
import 'package:karaj/screens/sos/step2_screen.dart';
import 'package:karaj/screens/sos/step3_informations.dart';
import 'package:karaj/services/database.dart';

class RootSosScreen extends StatefulWidget {

  @override
  State<RootSosScreen> createState() => _RootSosScreenState();
}

class _RootSosScreenState extends State<RootSosScreen> {

  SosController _sosCtrl;
  bool _onLoading = true;
  SosModel _sosData;
  @override
  void initState() {
    _sosCtrl = Get.put(SosController());
    _onLoading = true;
    checkOrders();
    super.initState();
  }

  Future<void> checkOrders() async {
    dynamic check = await Database().getUserSos();
    if(check != null) {
      _sosData = check;
    }
    setState(() {
      _onLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope (
      onWillPop: () async {
        return _sosCtrl.moveBack(doBack: _sosData != null ? true : false);
      },
      child: Scaffold(
        appBar: appBar(title: 'sos'.tr),
        body: _onLoading == true ? LoadingScreen(true) : _sosData != null ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: SosRequestCard(mayday: _sosData),
        ) : GetBuilder(
          init: SosController(),
          builder: (SosController controller) {
            return AnimatedSwitcher(
              duration: Duration(),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: _sosCtrl.requestSent.value == true ? SosSent() : _sosCtrl.onLoading.value == false ? PageView(
                controller: controller.pageViewCtrl,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SosStepOneScreen(),
                  SosStepTwoScreen(),
                  InformationScreen(),


                ],
              ) : LoadingScreen(true),
            );
          },
        ),
      ),
    );
  }
}

class SosSent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              height: Get.height * 0.3,
              child: FlareActor(
                "assets/flr/SuccessCheck.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "Untitled",
              ),
            ),
            Text('importantTips'.tr, style: TextStyle(color: Colors.red),),
            Container(child: Text('tips'.tr)),
          ],
        ),
      ),
    );
  }
}

