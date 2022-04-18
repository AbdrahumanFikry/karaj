import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karaj/bindings/widgets.dart';
import 'package:get/get.dart';
import 'package:karaj/screens/ordering/helpers.dart';
import 'package:karaj/models/sos.dart';
import 'package:karaj/models/user.dart';
import 'package:karaj/services/PushNotificationService.dart';
import 'package:karaj/services/database.dart';


class SosRequestCard extends StatelessWidget {

  final SosModel mayday;


  const SosRequestCard({Key key, this.mayday}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
            color: Get.theme.backgroundColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  offset: Offset(0, 3),
                  blurRadius: 3
              )
            ]
        ),

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(Icons.location_on, color: Color(0xff228cff)),
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(color: Get.theme.primaryColor, style: BorderStyle.solid),

                              )
                          ),
                        ),
                        Icon(Icons.location_history, color: Color(0xffff5267)),

                        SizedBox(height: 75.0),
                        mayday.phone == null ? SizedBox.shrink() : InkWell(
                          onTap: () => Helpers.makeCallPhone(mayday.phone),
                          child: Icon(Icons.phone, color: Color(0xffff5267)),
                        ),

                      ],
                    ),
                  ),

                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('location'.tr, style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              mayday.batteryBalance == null ? SizedBox.shrink() : Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 11.0),
                                decoration: BoxDecoration(
                                  color: mayday.batteryBalance <= 15 ? Colors.red : Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text("البطارية ${mayday.batteryBalance}%", style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                          Text(mayday.address ?? '', style: TextStyle(color: Colors.grey)),
                          Text(mayday.latlng ?? '', style: TextStyle(color: Colors.grey, fontSize: 11.0)),
                          mayday.needTo == null ? SizedBox.shrink() : Text(mayday.phone ?? '', style: TextStyle(color: Colors.grey, fontSize: 11.0)),
                          SizedBox(height: 15.0),
                          Text('sosInformation'.tr, style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('beneficiary'.tr, style: TextStyle(fontSize: 13.0, color: Colors.grey)),
                                    Text(mayday.beneficiary == 0 ? 'personnel'.tr : 'family'.tr, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('injuries'.tr, style: TextStyle(fontSize: 13.0, color: Colors.grey)),
                                    Text('yesOrNo${mayday.injuries ?? ''}'.tr, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('vehicleDamaged'.tr, style: TextStyle(fontSize: 13.0, color: Colors.grey)),
                                    Text('yesOrNo${mayday.vehicleDamaged ?? ''}'.tr, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Text('weakWifi'.tr +" : " + 'yesOrNo${mayday.weekWifi ?? ''}'.tr, style: TextStyle(fontSize: 13.0, color: Colors.grey)),
                          Text('suffers'.tr +" : " + 'yesOrNo${mayday.suffers ?? ''}'.tr, style: TextStyle(fontSize: 13.0, color: Colors.grey)),
                          SizedBox(height: 5.0),
                          Text('sosNeeds'.tr +" : " + 'yesOrNo${mayday.sosNeeds ?? ''}'.tr, style: TextStyle(fontSize: 13.0, color: Colors.grey)),
                          mayday.sosNeeds == 1 && mayday.needTo != null ? Text("${'bringWithU'.tr} ${mayday.needTo ?? ''}") : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  )


                ],
              ),
            ),
            Container(
              width: Get.width,
              child: normalFlatButtonWidget(
                context: context,
                text: 'openAddressMap'.tr,
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                radius: 5.0,
                callFunction: () async{
                  await Helpers.launchMap(lat: mayday.lat, lng: mayday.lng);
                },
              ),
            ),
            SizedBox(height: 15.0),

            FirebaseAuth.instance.currentUser.uid == mayday.userId ? Container(
              width: Get.width,
              child: normalFlatButtonWidget(
                context: context,
                colour: Colors.redAccent,
                text: 'cancelSos'.tr,
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                radius: 5.0,
                callFunction: () async{
                  await Database().updateDocument(data: {"status": "canceled"}, docID: mayday.id, docName: 'sos');
                  Get.back();
                  GetxWidgetHelpers.mSnackBar('cancel'.tr, 'canceled'.tr);
                },
              ),
            ) : FirebaseAuth.instance.currentUser.uid == mayday.helperId ? Container(
              width: Get.width,
              child: normalFlatButtonWidget(
                context: context,
                colour: Colors.blueGrey,
                text: 'تم الانقاد'.tr,
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                radius: 5.0,
                callFunction: () async{
                  await Database().updateDocument(data: {"status": "done"}, docID: mayday.id, docName: 'sos');
                  Get.back();
                },
              ),
            ) : Container(
              width: Get.width,
              child: normalFlatButtonWidget(
                context: context,
                colour: Colors.green,
                text: 'قبول الطلب'.tr,
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                radius: 5.0,
                callFunction: () async{
                  await Database().updateDocument(data: {"status": "accepted", "helperId": FirebaseAuth.instance.currentUser.uid}, docID: mayday.id, docName: 'sos');
                  Get.back();
                  UserModel _userId = await Database().getUser(mayday.userId);
                  PushNotificationService().sendNotification(
                      type: 'sosAccepted',
                      orderID: mayday.id,
                      title: 'تم قبول طلب استغاتتك',
                      body: 'يرجى الحفاظ على الهدوء والبقاء في مكانك حتى يصل المنقدون.',
                      token: _userId.token ?? ''
                  );
                },
              ),
            ),


            SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
}