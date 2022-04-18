import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:karaj/controllers/userController.dart';
import 'package:karaj/screens/ordering/helpers.dart';
import 'package:karaj/models/user.dart';
import 'package:intl/intl.dart' as intl;
import 'package:karaj/screens/home_screen.dart';
import 'package:karaj/services/database.dart';

class WithdrawMoneyController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static UserModel _user = Get.find<UserController>().user;
  TextEditingController amount = TextEditingController();
  TextEditingController bankName =
      TextEditingController(text: _user.bankName ?? '');
  TextEditingController accountRip =
      TextEditingController(text: _user.accountRip ?? '');
  TextEditingController nameOwner =
      TextEditingController(text: _user.nameOwner ?? '');

  RxBool onLoading = false.obs;
  RxBool submitted = false.obs;
  RxInt step = 0.obs;

  dynamic checkAmount(String value, {double balance = 0}) {
    if (value == null || value.trim().isEmpty) {
      return 'amountRequired'.tr;
    } else if (double.tryParse(value) == null) {
      return 'amountNumeric'.tr;
    } else if (double.tryParse(value) < 10) {
      return 'lessAmount'.tr;
    } else if (double.tryParse(value) > balance) {
      return 'noEnough'.tr;
    }
    return null;
  }

  dynamic checkValue(String value, {double balance = 0}) {
    if (value == null || value.trim().isEmpty) {
      return 'enterCorrectName'.tr;
    }
    return null;
  }

  void next() {
    step.value = 1;
    update();
  }

  Future<bool> submit() async {
    UserModel user = Get.find<UserController>().user;
    if (user.onWithdraw) {
      GetxWidgetHelpers.mSnackBar('btnRequestPayment', 'onWithdraw'.tr);
      return false;
    }
    dynamic cAmount = checkAmount(amount.text, balance: user.balance);
    if (cAmount != null) {
      GetxWidgetHelpers.mSnackBar('wrongInfo', cAmount);
      return false;
    }
    if (checkValue(bankName.text) != null ||
        checkValue(accountRip.text) != null ||
        checkValue(nameOwner.text) != null) {
      GetxWidgetHelpers.mSnackBar('wrongInfo', "fillAllFields".tr);
      return false;
    }
    onLoading.value = true;
    update();

    DateTime now = DateTime.now();

    Map<String, dynamic> data = {};
    data["userId"] = user.id;
    data["userName"] = "${user.firstName} ${user.firstName}";
    data["userPhone"] = user.phone;
    data["date"] = intl.DateFormat.yMMMMd('ar_SA').format(now);
    data["type"] = 'withdraw';
    data["forId"] = null;
    data["timestamp"] = now.microsecondsSinceEpoch;
    data["totalAmount"] = amount.text;
    data["bankName"] = bankName.text;
    data["accountRip"] = accountRip.text;
    data["nameOwner"] = nameOwner.text;
    data["paymentId"] = null;
    data["paymentType"] = null;
    data["payed"] = false;

    await Database().updateDocument(
        docName: 'requestPayment',
        docID: now.microsecondsSinceEpoch.toString(),
        data: data,
        donTShowLoading: true);
    user.onWithdraw = true;
    user.bankName = bankName.text;
    user.accountRip = accountRip.text;
    user.nameOwner = nameOwner.text;
    Get.find<UserController>().setUser = user;
    Get.to(HomeScreen());
    onLoading.value = false;
    submitted.value = true;
    update();
    GetxWidgetHelpers.mSnackBar('تم ارسال طلب',
        'تم ارسال طلبك لسحب الاموال بنجاح سيتم مراجعته في اقل من 48 ساعة.');
    return true;
  }
}
