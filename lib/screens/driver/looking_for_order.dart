import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karaj/bindings/widgets.dart';
import 'package:karaj/models/order.dart';
import 'package:karaj/screens/orders/list_order_widget.dart';
import 'package:karaj/services/database.dart';






class DriverLookingForOrderScreen extends StatefulWidget {
  @override
  _DriverLookingForOrderScreenState createState() => _DriverLookingForOrderScreenState();
}

class _DriverLookingForOrderScreenState extends State<DriverLookingForOrderScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'availableOrders'.tr),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: Database().getWaitingOrdersForDrivers(),
          builder: (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
            print(snapshot);
            print("snapshot.connectionState : ${snapshot.connectionState}");
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Container(height: Get.height * 0.9, child: LoadingScreen(true));
            } else {
              if(snapshot.hasData && snapshot.data.length > 0) {
                return ListOrderWidget(orders: snapshot.data);
              } else {
                return EmptyScreen();
              }
            }
          },
        ),
      ),
    );
  }
}
