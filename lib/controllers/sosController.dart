import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karaj/models/user.dart';
import 'package:karaj/services/PushNotificationService.dart';
import 'package:karaj/services/database.dart';

class SosController extends GetxController {

  PageController pageViewCtrl = PageController(initialPage: 0);

  RxMap<String, dynamic> _information = RxMap<String, dynamic>({});
  Map<String, dynamic> get information => _information;

  TextEditingController needTo = TextEditingController();
  TextEditingController phone = TextEditingController(text: FirebaseAuth.instance.currentUser.phoneNumber ?? '');

  void animToPage({int index}) {
    pageViewCtrl.animateToPage(index, duration: Duration(milliseconds: 370), curve: Curves.easeInOut);
  }

  Future<bool> moveBack({bool doBack = false}) async{
    if(doBack) {
      return true;
    }
    if(requestSent.value) {
      return true;
    }
    double currentIndex = pageViewCtrl.page;
    if(currentIndex <= 0) {
      return true;
    } else {
      animToPage(index: (currentIndex - 1).toInt());
    }
    return false;
  }

  void updateData(Map<String, dynamic >data, {bool doUpdate = true}) {
    _information = data;
    if(doUpdate) {
      update();
    }
  }



  List<List<String>> subTypes = [
    [
      "land".tr,
      "sea".tr,
      "hills".tr,
      "inCity".tr,
    ],
    [
      "desert".tr,
      "narrowArea".tr,
      "hills".tr,
    ],
    [
      "heightHills".tr,
      "hole".tr,
    ],
  ];




  RxBool onLoading = false.obs;
  RxBool requestSent = false.obs;



  Future<void> sendMayday() async {
    onLoading.value = true;
    update();
    DateTime now = DateTime.now();
    String id = now.microsecondsSinceEpoch.toString();
    _information['status'] = "searching";
    _information['needTo'] = needTo.text;
    _information['needTo'] = needTo.text;
    _information['phone'] = phone.text;
    _information['userId'] = FirebaseAuth.instance.currentUser.uid;
    await Database().updateDocument(
      docName: 'sos',
      docID: id,
      donTShowLoading: true,
      data: information
    );
    await sendNotification(id);

    requestSent.value = true;
    onLoading.value = false;
    update();

  }

  Future<void> sendNotification(String id) async {
    List<UserModel> sosUsers = await Database().getSosUsers();
    sosUsers.forEach((element) {
      PushNotificationService().sendNotification(
          type: 'mayday',
          orderID: id,
          title: 'نداء استغاثة',
          body: 'هناك نداء استغاثة جديد ، من فضلك اذهب وافعل شيئًا من أجله. شكرا جزيلا!',
          token: element.token ?? ''
      );
    });
  }

}