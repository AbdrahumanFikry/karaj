import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karaj/bindings/warp_widget.dart';
import 'package:karaj/bindings/widgets.dart';
import 'package:karaj/controllers/paymentController.dart';
import 'package:karaj/controllers/userController.dart';
import 'package:karaj/controllers/withdraw_money_controller.dart';
import 'package:karaj/screens/ordering/helpers.dart';
import 'package:karaj/ui_widgets/animations/fade_animation.dart';

class RequestPaymentInformation extends GetWidget<WithdrawMoneyController> {
  @override
  Widget build(BuildContext context) {
    return WrapTextOptions(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: Get.height * 0.03),

          Text('amount'.tr),
          Container(
              margin: EdgeInsets.only(bottom: Get.height * 0.03),
                child: Text("${Helpers.fixPrice(controller.amount.text)} ${"sar".tr}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
          ),


          FadeAnimation(
            delay: 1.6,
            child: Container(
              decoration: BoxDecoration(
                  color: Get.theme.backgroundColor
              ),
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Text("bankAccount".tr, style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("bankAccountText".tr, textAlign: TextAlign.center, style: TextStyle(fontSize: 13.0, color: Colors.grey),),
                  SizedBox(height: 25.0),
                  TextFormField(
                    controller: controller.bankName,
                    validator: (value) => controller.checkValue(value),
                    decoration: inputDecorationUi(context, 'bankName'.tr, color: Get.theme.scaffoldBackgroundColor),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    controller: controller.accountRip,
                    validator: (value) => controller.checkValue(value),
                    decoration: inputDecorationUi(context, 'accountRip'.tr, color: Get.theme.scaffoldBackgroundColor),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    controller: controller.nameOwner,
                    validator: (value) => controller.checkValue(value),
                    decoration: inputDecorationUi(context, 'nameOwner'.tr, color: Get.theme.scaffoldBackgroundColor),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 25.0),
                  Container(
                    width: Get.width,
                    child: normalFlatButtonWidget(
                      onLoading: controller.onLoading.value,
                      context: context,
                      text: 'btnContinue'.tr,
                      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
                      radius: 5.0,
                      callFunction: () async {
                        if(controller.formKey.currentState.validate()) { // requestPayment
                          controller.submit();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
