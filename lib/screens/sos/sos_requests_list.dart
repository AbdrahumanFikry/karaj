import 'package:flutter/material.dart';
import 'package:karaj/bindings/widgets.dart';
import 'package:get/get.dart';
import 'package:karaj/models/sos.dart';
import 'package:karaj/screens/sos/card_sos_informaion.dart';
import 'package:karaj/services/database.dart';
import 'package:karaj/ui_widgets/animations/fade_animation.dart';


class SosRequests extends StatefulWidget {
  @override
  State<SosRequests> createState() => _SosRequestsState();
}

class _SosRequestsState extends State<SosRequests> {
  bool _onLoading = true;
  SosModel _sosData;
  @override
  void initState() {
    _onLoading = true;
    checkOrders();
    super.initState();
  }

  Future<void> checkOrders() async {
    dynamic check = await Database().getUserSos();
    if(check != null) {
      _sosData = check;
    }
    setState(() {
      _onLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'sosRequests'.tr),
      body: _onLoading == true ? LoadingScreen(true) : _sosData != null ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: SosRequestCard(mayday: _sosData),
      ) : SingleChildScrollView(
        child: StreamBuilder(
          stream: Database().getSosRequests(),
          builder: (BuildContext context, AsyncSnapshot<List<SosModel>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Container(height: Get.height * 0.9, child: LoadingScreen(true));
            } else {
              if(snapshot.hasData && snapshot.data.length > 0) {
                List<SosModel> requests = snapshot.data;
                return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: true,
                    itemCount: requests.length,
                    itemBuilder: (BuildContext context, index) {
                      SosModel mayday = requests[index];
                      return FadeAnimation(
                        delay: index * 0.03,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SosRequestCard(mayday: mayday),
                        ),
                      );
                    }
                );
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



