import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SelectAccountTypeController extends GetxController {
  RxDouble _offset = RxDouble(-1000.0);
  RxDouble _page = RxDouble(0.0);

  double get offset => _offset.value;
  double get page => _page.value;

  SelectAccountTypeController(PageController pageController) {
    _offset.value = pageController.offset;
    pageController.addListener(() {
      _offset.value = pageController.offset;
      _page.value = pageController.page;
    });
  }
}



class SelectAccountTypeScreen extends StatefulWidget {

  @override
  State<SelectAccountTypeScreen> createState() => _SelectAccountTypeScreenState();
}

class _SelectAccountTypeScreenState extends State<SelectAccountTypeScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectAccountTypeController>(
      init: SelectAccountTypeController(_pageController),
      builder: (GetxController controller) {
        return Scaffold(
          body: PageView(
            controller: _pageController,
            physics: ClampingScrollPhysics(),
            children: [
              DriverPage(),
              Container(color: Colors.greenAccent[100],),
            ],
          ),
        );
      },
    );
  }
}



class DriverPage extends GetWidget<SelectAccountTypeController> {
  final SelectAccountTypeController ctrl = Get.find<SelectAccountTypeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Container(
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset((Get.width * 0.2) + ctrl.offset, 0),
                  child: Image.asset('assets/images/truck.png', width: Get.width * 0.8),
                ),
              ],
            ),
        );
      }
    );
  }
}
