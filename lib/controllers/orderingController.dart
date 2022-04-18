import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karaj/controllers/userController.dart';
import 'package:karaj/screens/ordering/helpers.dart';
import 'package:karaj/models/Distance.dart';
import 'package:karaj/models/Floor.dart';
import 'package:karaj/models/order.dart';
import 'package:karaj/services/database.dart';
import 'package:intl/intl.dart' as intl;

class OrderingController extends GetxController {

  Rx<bool> _onLoading = false.obs;
  bool onCreatingOrder = false;
  set setLoading(bool x) => this._onLoading.value = x;
  bool get onLoading => _onLoading.value;

  Rx<int> _orderStep = 0.obs;
  set setStep(int x) => this._orderStep.value = x;
  int get step => _orderStep.value;

  Rx<OrderModel> _order = OrderModel(
    fromFullAddress: '',
    toFullAddress: '',
    status: 0,
  ).obs;

  OrderModel get order => _order.value;

  set setOrder(OrderModel _o) {
    this._order.value = _o;
    print(_o.vehicleType);

    update();
  }




  Rx<List<FloorModel>> floorsList = Rx<List<FloorModel>>([]);

  List<FloorModel> get floors {
    floorsList.value.sort((a, b) => a.id.compareTo(b.id));
    return floorsList.value;
  }



  Future<void> fetchFloors() async {
    floorsList.value = await Database().fetchFloors();
    update();
  }


  Future<void> orderSetUpInformation() async {
    double distanceX = 0;
    double priceForKm = 0;
    double distanceStartPriceX = 0;
    double distancePriceX = 0;
    if(order.fromLat != null && order.fromLng != null && order.toLat != null && order.toLng != null) {

      distanceX = Helpers.calculateDistance(order.fromLat, order.fromLng, order.toLat, order.toLng);
      if(distanceX != null && distanceX > 0) {
        distanceX = double.parse(distanceX.toStringAsFixed(2));
      }

      List<DistanceModel> distances = await Database().fetchDistances();

      distances.sort((a, b) => b.to.compareTo(a.to));
      DistanceModel _distance;

      for (DistanceModel d in distances) {
        if(distanceX <= d.to) {
          _distance = d;
          distanceStartPriceX = d.startEnginePrice;
          priceForKm = d.pricePerKm;

        }
      }

      if(_distance == null) {
        priceForKm = 1;
        distanceStartPriceX = 0;
      }


      distancePriceX = priceForKm * distanceX;

      if(order.orderType == 2) {
        if(floors == null || floors.length <= 0) {
          floorsList.value = await Database().fetchFloors();
        }

        for (FloorModel f in floors) {
          if(order.fromFloor == f.id) {
            order.fromFloorPrice = f.price ?? 0;
          }
          if(order.toFloor == f.id) {
            order.toFloorPrice = f.price ?? 0;
          }
        }
      }

      _order.value.distance = distanceX;
      _order.value.distanceStartPrice =  double.parse(distanceStartPriceX.toStringAsFixed(2));
      _order.value.distancePrice =  double.parse(distancePriceX.toStringAsFixed(2));
      _order.value.distanceTotalPrice =  double.parse(distancePriceX.toStringAsFixed(2));


      _order.value.totalPrice = double.parse((distanceStartPriceX + distancePriceX + order.vehiclePrice).toStringAsFixed(2));

      if(order.orderType == 2) {
        _order.value.totalPrice += double.parse(((order.toFloorPrice ?? 0) + (order.fromFloorPrice ?? 0)).toStringAsFixed(2));
      }
      update();
    }
  }

  Future<OrderModel> submitOrder({String id}) async {
    if(!onCreatingOrder && FirebaseAuth.instance.currentUser != null && _order.value?.totalPrice != null) {
      try {
        onCreatingOrder = true;
        Future.delayed(Duration.zero, () => Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false));
        OrderModel o = _order.value;
        o.userId = FirebaseAuth.instance.currentUser.uid;
        o.userName = FirebaseAuth.instance.currentUser.displayName;
        o.userPhone = FirebaseAuth.instance.currentUser.phoneNumber;
        o.canBeReRequest = true;
        DateTime now = DateTime.now();
        String day = intl.DateFormat('d').format(now);
        String month = intl.DateFormat('M').format(now);
        String year = intl.DateFormat('y').format(now);
        String monthName = intl.DateFormat('MMM').format(now);
        String md = intl.DateFormat('Md').format(now);
        if(id != null && id.isNotEmpty) {
          o.id = id;
        } else {
          o.id = await Database().generateId();
        }
        o.status = 1;
        Map<String, dynamic> data = o.toMap();
        data['day'] = day;
        data['month'] = month;
        data['year'] = year;
        data['monthName'] = monthName;
        data['md'] = md;
        data['end_at'] = now.add(new Duration(hours: 2)).millisecondsSinceEpoch;
        data['timestamp'] = DateTime.now().microsecondsSinceEpoch.toString();
        await Database().createOrder(o.id, data);
        UserController().submitOrder(o);
        onCreatingOrder = false;
        Get.back();
        return o;
      } catch (e) {
        print("================== submitOrder catch error says : $e");
        return null;
      }
    } else {
      return null;
    }
  }


  clear() {
    _orderStep.value = 0;
    _order.value = OrderModel(
      fromFullAddress: '',
      toFullAddress: '',
      status: 0,
    );
  }

}