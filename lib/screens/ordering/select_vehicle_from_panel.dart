import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karaj/bindings/widgets.dart';
import 'package:karaj/controllers/orderingController.dart';
import 'package:karaj/screens/ordering/helpers.dart';
import 'package:karaj/models/Floor.dart';
import 'package:karaj/models/order.dart';
import 'package:karaj/screens/ordering/confirm_order.dart';
import 'package:karaj/screens/ordering/pick_up_information.dart';
import 'package:karaj/services/categories_data.dart';


class SelectVehicleTypePanel extends StatefulWidget {
  @override
  _SelectVehicleTypePanelState createState() => _SelectVehicleTypePanelState();
}

class _SelectVehicleTypePanelState extends State<SelectVehicleTypePanel> {

  int numberOfPieces = 1, numberOfWorkers = 1, fromFloor, toFloor, floorFromId, floorToId;
  String fromFloorString, toFloorString;
  OrderingController controller;

  @override
  void initState() {
    controller = Get.find();
    fromFloorString = fromFloorString ?? '';
    toFloorString = toFloorString ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OrderModel _o = controller.order;
    return Scaffold(
      appBar: AppBar(
        title: Text("selectVan".tr, style: TextStyle(color: Get.theme.primaryColor)),
        centerTitle: true,
        leading: Container(),
      ),
      backgroundColor: Get.theme.backgroundColor,
      body: GetBuilder<OrderingController>(
        builder: (ctrl) =>  SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: Get.height * 0.03),
              InkWell(
                onTap: () {
                  ctrl.setStep = 3;
                  _o.vehicleType = 1;
                  _o.vehicleName = 'فان';
                  _o.vehicleImage = 'assets/images/vehcile-van.jpg';
                  _o.vehiclePrice = 50;
                  ctrl.setOrder = _o;
                },
                child: VehicleCard(
                  image: 'assets/images/vehcile-van.jpg',
                  name: 'van'.tr,
                  description: 'vanDescription'.tr,
                  price: '50',
                  selected: _o.vehicleType == 1,
                ),
              ),
              InkWell(
                onTap: () {
                  ctrl.setStep = 3;
                  _o.vehicleType = 2;
                  _o.vehicleName = 'بيك اب';
                  _o.vehicleImage = 'assets/images/vehcile-pickup.jpg';
                  _o.vehiclePrice = 200;
                  ctrl.setOrder = _o;
                },
                child: VehicleCard(
                  image: 'assets/images/vehcile-pickup.jpg',
                  name: 'pickup'.tr,
                  description: 'pickupDescription'.tr,
                  price: '200',
                  selected: _o.vehicleType == 2,
                ),
              ),


              _o.orderType == 2 ? Container(
                decoration: BoxDecoration(
                  color: Get.theme.backgroundColor,
                ),
                padding: EdgeInsets.all(15.0),
                margin: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('numberOfPieces'.tr),
                          Text(numberOfPieces.toString())
                        ]
                    ),
                    Slider(
                      value: numberOfPieces.toDouble(),
                      min: 1.0,
                      max: 50.0,
                      //divisions: 19,
                      activeColor: Theme.of(context).primaryColor,
                      inactiveColor: Colors.grey[200],
                      label: numberOfPieces.toString(),
                      onChanged: (double val) {
                        setState(() {
                          numberOfPieces = val.toInt();
                        });
                      },
                      semanticFormatterCallback: (double val) {
                        return val.toString();
                      },
                    ),
                    /*   SizedBox(height: 25.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('numberOfWorkers'.tr),
                        Text(numberOfWorkers.toString())
                      ]
                  ),
                  Slider(
                    value: numberOfWorkers.toDouble(),
                    min: 1.0,
                    max: 19.0,
                    //divisions: 19,
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Colors.grey[200],
                    label: numberOfWorkers.toString(),
                    onChanged: (double val) {
                      setState(() {
                        numberOfWorkers = val.toInt();
                      });
                    },
                    semanticFormatterCallback: (double val) {
                      return val.toString();
                    },
                  ),*/

                    SizedBox(height: 25.0),
                    Text('fromFloor'.tr),
                    SizedBox(height: 15.0),
                    Container(height: 35.0, child: _buildFloorsList()),
                    SizedBox(height: 25.0),
                    Text('toFloor'.tr),
                    SizedBox(height: 15.0),
                    Container(height: 35.0, child: _buildFloorsList(isFrom: false)),
                    SizedBox(height: 35.0),
                  ],
                ),
              ) : SizedBox.shrink(),

              AnimatedOpacity(
                opacity: ctrl.step >= 3 ? 1 : 0,
                duration: Duration(milliseconds: 777),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  width: Get.width,
                  child: normalFlatButtonWidget(
                      context: context,
                      callFunction: () => nextStep(),
                      text: "btnContinue".tr,
                      padding: const EdgeInsets.all(15.0),
                      radius: 5
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void nextStep() {
    if(controller.order.orderType == 2) {
      if(floorToId == null || floorFromId == null) {
        GetxWidgetHelpers.mSnackBar('معلومات ناقصة', 'يرجى اختيار الطوابق / الادوار.');
        return;
      }
      OrderModel _o = controller.order;
      _o.numberOfPieces = numberOfPieces;
      _o.numberOfWorkers = numberOfWorkers;
      _o.fromFloor = floorFromId;
      _o.toFloor = floorToId;
      _o.fromFloorString = fromFloorString;
      _o.toFloorString = toFloorString;
      controller.setOrder = _o;
    }
    Get.to(ConfirmOrder());
  }

  Widget _buildFloorsList({bool isFrom = true}) {


    return GetBuilder<OrderingController>(
      builder: (controller) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.floors.length,
          itemBuilder: (BuildContext context, index) {
            FloorModel floor = controller.floors[index];
            bool selected = false;
            if(isFrom && fromFloor == index) {
              selected = true;
            } else if(!isFrom && toFloor == index){
              selected = true;
            }
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                  color: selected ? Get.theme.colorScheme.primaryVariant : Color(0xfff4f6f8),
                  borderRadius: BorderRadius.circular(5)
              ),
              child: InkWell(onTap: () { setState(() {
                if(isFrom) {
                  fromFloor = index;
                  fromFloorString = floor.name ?? '';
                  floorFromId = floor.id;
                } else {
                  toFloor = index;
                  toFloorString = floor.name ?? '';
                  floorToId = floor.id;
                }
              }); }, child: Center(child: Text(floor.name ?? '', style: TextStyle(color: selected ? Get.theme.colorScheme.secondaryVariant : Color(0xff949ec7))))),
            );
          }),
    );
  }
}



class VehicleCard extends StatelessWidget {
  final String image, name, description, price;
  final bool selected;
  const VehicleCard({Key key, this.image, this.name, this.description, this.price, this.selected = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(color: selected ? Get.theme.primaryColor : Get.theme.scaffoldBackgroundColor, borderRadius: BorderRadius.circular(15.0)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(left: 12.0),
            decoration: BoxDecoration(
              border: Border(
                left:  BorderSide(width: 1.0, color: selected ? Get.theme.backgroundColor : Colors.grey),
              ),
            ),
            child: Image(
              image: AssetImage('$image'),
            ),
          ),
          title: Text(
            "$name",
            style: TextStyle(fontWeight: FontWeight.bold, color: selected ? Get.theme.backgroundColor : null),
          ),

          subtitle: Text("$description", style: TextStyle(color: selected ? Get.theme.backgroundColor : null)),
          trailing: Text('$price رس', style: TextStyle(color: selected ? Get.theme.backgroundColor : null)),
        )
    );
  }
}
