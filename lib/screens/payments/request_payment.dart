import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karaj/bindings/warp_widget.dart';
import 'package:karaj/bindings/widgets.dart';
import 'package:karaj/controllers/paymentController.dart';
import 'package:karaj/controllers/userController.dart';
import 'package:karaj/controllers/withdraw_money_controller.dart';
import 'package:karaj/screens/ordering/helpers.dart';
import 'package:karaj/models/user.dart';
import 'package:karaj/screens/payments/payment_card.dart';
import 'package:karaj/screens/payments/request_payment_information.dart';
import 'package:karaj/ui_widgets/animations/fade_animation.dart';

class RequestPaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WrapTextOptions(
      child: Scaffold(
        appBar: appBar(title: 'btnRequestPayment'.tr),
        body: SingleChildScrollView(
          child: GetBuilder<WithdrawMoneyController>(
              init: WithdrawMoneyController(),
              builder: (WithdrawMoneyController controller) {
                UserModel user = Get.find<UserController>().user;
                double userBalance = user.balance;
                return (user.onWithdraw == true ||
                        controller.submitted.value == true)
                    ? PaymentCard()
                    : Form(
                        key: controller.formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Container(
                            child: controller.step.value == 1
                                ? RequestPaymentInformation()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: Get.height * 0.1),
                                      Text('yourBalance'.tr),
                                      Container(
                                          margin: EdgeInsets.only(
                                              bottom: Get.height * 0.03),
                                          child: Text(
                                            "$userBalance ${"sar".tr}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25.0),
                                          )),
                                      FadeAnimation(
                                        delay: 1.6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Get.theme.backgroundColor),
                                          padding: const EdgeInsets.all(25.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "enterYourAmount".tr,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "withdrawWarning".tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.grey),
                                              ),
                                              SizedBox(height: 25.0),
                                              Container(
                                                width: Get.width * 0.5,
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  controller: controller.amount,
                                                  validator: (value) =>
                                                      controller.checkAmount(
                                                          value,
                                                          balance: userBalance),
                                                  decoration: inputDecorationUi(
                                                      context, 'amount'.tr,
                                                      color: Get.theme
                                                          .scaffoldBackgroundColor,
                                                      suffixText: 'sar'.tr),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  maxLength: 7,
                                                ),
                                              ),
                                              SizedBox(height: 25.0),
                                              Container(
                                                width: Get.width,
                                                child: normalFlatButtonWidget(
                                                  onLoading: controller
                                                      .onLoading.value,
                                                  context: context,
                                                  text: 'btnContinue'.tr,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 18.0,
                                                      vertical: 15.0),
                                                  radius: 5.0,
                                                  callFunction: () async {
                                                    if (controller
                                                        .formKey.currentState
                                                        .validate()) {
                                                      controller.next();
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
                          ),
                        ),
                      );
              }),
        ),
      ),
    );
  }
}
