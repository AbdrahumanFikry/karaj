import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.8,
      child: Center(
        child: Text('onWithdraw'.tr),
      ),
    );
  }
}
