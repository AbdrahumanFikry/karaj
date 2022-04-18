import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SubmitDotAnimationController extends GetxController with SingleGetTickerProviderMixin {
  // Animations
  AnimationController controller;
  Animation<BorderRadius> bordersAnimation;
  Animation<double> submitWithAnimation;


  double get width => submitWithAnimation?.value ?? 0.0;

  @override
  void onInit() {
    super.onInit();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    bordersAnimation = BorderRadiusTween( //create BorderRadiusTween
      begin: BorderRadius.circular(0.0),
      end: BorderRadius.circular(50.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.0, 0.07), //specify interval from 0 to 7%
    ));
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

}