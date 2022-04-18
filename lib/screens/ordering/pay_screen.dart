import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hyperpay/hyperpay.dart';
import 'package:karaj/bindings/widgets.dart';
import 'package:karaj/controllers/orderingController.dart';
import 'package:karaj/controllers/paymentController.dart';
import 'package:karaj/controllers/shopOnModifiedOrder.dart';
import 'package:karaj/screens/ordering/helpers.dart';
import 'package:karaj/models/order.dart';
import 'package:karaj/models/spares.dart';
import 'package:karaj/screens/orders/order_details.dart';
import 'package:karaj/screens/spares/details/spares_order_details.dart';
import 'package:karaj/services/database.dart';
import 'package:karaj/ui_widgets/input_mask.dart';
import 'package:intl/intl.dart' as intl;
import 'package:webview_flutter/webview_flutter.dart';

import 'constants.dart';
import 'formatters.dart';

class PayOrderScreen extends StatefulWidget {
  final String paymentMethod;
  final String comingFrom;
  final String totalPrice;

  const PayOrderScreen(
      {Key key,
      this.paymentMethod,
      this.comingFrom = 'ordering',
      this.totalPrice})
      : super(key: key);

  @override
  _PayOrderScreenState createState() => _PayOrderScreenState();
}

class _PayOrderScreenState extends State<PayOrderScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool onLoading = false;
  String _cardType = "";
  TextEditingController _cardNumber = TextEditingController();
  TextEditingController _cardHolder = TextEditingController();
  TextEditingController _expiryDate = TextEditingController();
  TextEditingController _cardCvv = TextEditingController();
  String expiryMonth = "";
  String expiryYear = "";
  DateTime selectedDate = DateTime.now();

  BrandType brandType = BrandType.none;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool isLoading = false;
  String sessionCheckoutID = '';

  HyperpayPlugin hyperpay;

  @override
  void initState() {
    super.initState();
    setup();
  }

  setup() async {
    hyperpay = await HyperpayPlugin.setup(config: LiveConfig());
  }

  /// Initialize HyperPay session
  Future<void> initPaymentSession(
      BrandType brandType, double amount, Map<String, dynamic> data) async {
    CheckoutSettings _checkoutSettings = CheckoutSettings(
      brand: brandType,
      amount: 1.0,
      headers: {
        'Authorization':
            'Bearer OGFjN2E0Yzk3YmRmNDAzNDAxN2JkZjRmMGQ2YjAwM2V8WjR6aFlqRlhmZQ=='
      },
      additionalParams: data ?? {},
    );

    hyperpay.initSession(checkoutSetting: _checkoutSettings);
    sessionCheckoutID = await hyperpay.getCheckoutID;
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime.now(),
  //       lastDate: DateTime(2101),
  //       cancelText: 'btnCancel'.tr,
  //       confirmText: 'confirm'.tr,
  //       initialDatePickerMode: DatePickerMode.year);
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //       _expiryDate.text = intl.DateFormat.yMd('en_US').format(picked);
  //       expiryMonth = intl.DateFormat.M('en_US').format(picked);
  //       expiryYear = intl.DateFormat.y('en_US').format(picked);
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'pay'.tr),
      body: onLoading
          ? LoadingScreen(true, statusText: 'loadingText1'.tr)
          : widget.paymentMethod == "CASH"
              ? payingCash()
              : SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image(
                            image: AssetImage('assets/images/creidtcard.png'),
                            width: Get.width * 0.6,
                          ),
                        ),
                        Container(
                          width: Get.width,
                          margin: EdgeInsets.symmetric(vertical: 25.0),
                          decoration: BoxDecoration(
                            color: Get.theme.backgroundColor,
                          ),
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('enterCardDetails'.tr,
                                  style: Get.theme.textTheme.headline5
                                      .copyWith(color: Color(0xFF6B7CAA))),
                              SizedBox(height: 25.0),
                              TextFormField(
                                controller: _cardNumber,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(
                                      brandType.maxLength),
                                  CardNumberInputFormatter()
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    brandType = value.detectBrand;
                                  });
                                },
                                validator: (String number) =>
                                    brandType.validateNumber(number ?? ""),
                                decoration: inputDecorationUi(
                                  context,
                                  'cardNumber'.tr,
                                  color: Get.theme.scaffoldBackgroundColor,
                                  suffixText: _cardType,
                                  prefixIcon: brandType == BrandType.none
                                      ? Icons.credit_card
                                      : 'assets/images/${brandType.asString}.png',
                                ),
                                textDirection: TextDirection.ltr,
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                controller: _cardHolder,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'enterCardHolder'.tr;
                                  }
                                  return null;
                                },
                                decoration: inputDecorationUi(
                                  context,
                                  'cardHolder'.tr,
                                  color: Get.theme.scaffoldBackgroundColor,
                                  prefixIcon: Icons.account_circle_rounded,
                                ),
                                textDirection: TextDirection.ltr,
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                width: Get.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _expiryDate,
                                        showCursor: true,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(4),
                                          CardMonthInputFormatter(),
                                        ],
                                        validator: (String date) =>
                                            CardInfo.validateDate(date ?? ""),
                                        decoration: inputDecorationUi(
                                          context,
                                          'expiryDate'.tr,
                                          color:
                                              Get.theme.scaffoldBackgroundColor,
                                          prefixIcon: Icons.date_range_rounded,
                                        ),
                                        keyboardType: TextInputType.datetime,
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ),
                                    SizedBox(width: 11),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _cardCvv,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(4),
                                        ],
                                        validator: (String cvv) =>
                                            CardInfo.validateCVV(cvv ?? ""),
                                        decoration: inputDecorationUi(
                                          context,
                                          'CVV',
                                          color:
                                              Get.theme.scaffoldBackgroundColor,
                                          prefixIcon:
                                              Icons.confirmation_number_rounded,
                                        ),
                                        textDirection: TextDirection.ltr,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 35.0),
                              Container(
                                width: Get.width,
                                child: flatButtonWidget(
                                  text: 'btnPayNow'.tr,
                                  callFunction: () => _paySubmit(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget payingCash() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: Get.height * 0.5,
              child: FlareActor(
                "assets/flr/SuccessCheck.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "Untitled",
              ),
            ),
            Center(
                child: Text(
              "خطوة واحدة تفصلك على انشاء طلبك.\nبالنقر فوق \"إرسال البيانات\" ، فإنك توافق على شروط وسياسة استخدام لهذا التطبيق.",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
            SizedBox(height: 38.5),
            Center(
              child: flatButtonWidget(
                text: 'إرسال البيانات'.tr,
                callFunction: () => _paySubmit(cash: true),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _paySubmit({bool cash = false}) async {
    setState(() {
      onLoading = true;
    });
    if (widget.comingFrom == 'ordering') {
      Get.find<OrderingController>().order.payCash = cash;

      if (!cash) {
        if (!_formKey.currentState.validate()) {
          return;
        } else {
          OrderModel lOrder = Get.find<OrderingController>().order;
          // String payVia = lOrder.payVia;
          // String cardNumber = _cardNumber.text.replaceAll("-", "");
          // expiryMonth =
          //     expiryMonth.startsWith("0") ? expiryMonth : "0$expiryMonth";
          print('Month :::::::::::: ${_expiryDate.text.split('/')[0]}');
          print('Year ::::::::::: 20${_expiryDate.text.split('/')[1]}');
          CardInfo card = CardInfo(
            holder: _cardHolder.text,
            cardNumber: _cardNumber.text.replaceAll(' ', ''),
            cvv: _cardCvv.text,
            expiryMonth: _expiryDate.text.split('/')[0],
            expiryYear: '20' + _expiryDate.text.split('/')[1],
          );
          try {
            if (sessionCheckoutID.isEmpty) {
              final data = {
                'currency': 'SAR',
                'paymentType': 'DB',
              };
              print(data.toString());
              await initPaymentSession(brandType, lOrder.totalPrice, data);
            }
            final result = await hyperpay.pay(
              card,
            );
            print('Payment result ::::: $result');
            switch (result) {
              case PaymentStatus.successful:
                sessionCheckoutID = '';
                Get.find<OrderingController>().order.payed = 1;
                String id = await Database().generateId();
                Get.find<OrderingController>().order.id = id;
                await PaymentController.createOrderPayment(
                  forId: FirebaseAuth.instance.currentUser?.uid,
                  order: Get.find<OrderingController>().order,
                  paymentID: Get.find<OrderingController>().order.paymentId,
                  payVia: _cardType,
                  typeX: "added",
                  title: 'payedForOrder',
                );
                OrderModel o =
                    await Get.find<OrderingController>().submitOrder(id: id);
                if (o != null) {
                  Get.offAll(OrderDetails(order: o, navToHome: true));
                }
                break;
              case PaymentStatus.pending:
                Get.back();
                GetxWidgetHelpers.mSnackBar(
                    "جارى التنفيذ", ' ⏳ العمليه قيد التنفيذ');
                break;
              case PaymentStatus.init:
                Get.back();
                GetxWidgetHelpers.mSnackBar("خطاء", 'عمليه مازالت قيد التنفيذ');
                break;
              case PaymentStatus.rejected:
                Get.back();
                GetxWidgetHelpers.mSnackBar("خطاء", 'عمليه فاشله');
                break;
            }
          } on HyperpayException catch (exception) {
            print("Hyper :: " + exception.toString());
            sessionCheckoutID = '';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(exception.details ?? exception.message),
                backgroundColor: Colors.red,
              ),
            );
          } catch (exception) {
            Get.back();
            GetxWidgetHelpers.mSnackBar("خطاء", 'عمليه فاشله');
          }

          // Map<String, dynamic> resultPaying =
          //     await PaymentController.sendAnInitialPayment(data: {
          //   'entityId': "",
          //   'amount': lOrder.totalPrice.toString(),
          //   'currency': 'SAR',
          //   'paymentBrand': _cardType,
          //   'paymentType': 'DB',
          //   'card.number': cardNumber,
          //   'card.holder': _cardHolder.text,
          //   'card.expiryMonth': expiryMonth,
          //   'card.expiryYear': expiryYear,
          //   'card.cvv': _cardCvv.text,
          //   "shopperResultUrl": "http://karaj-payment.cc/shopper/redirect/"
          // }, payVia: payVia, orderType: 'ordering');

          // String status = "";
          // if (resultPaying["status"] == "pending") {
          //   var redirectFrom = await Get.to(SafeArea(
          //     child: Scaffold(
          //       body: WebView(
          //           initialUrl: resultPaying["url"],
          //           javascriptMode: JavascriptMode.unrestricted,
          //           onPageFinished: (String url) {},
          //           navigationDelegate: (NavigationRequest request) {
          //             if (request.url.startsWith(
          //                 'http://karaj-payment.cc/shopper/redirect')) {
          //               Get.back(result: request.url);
          //             }
          //             return NavigationDecision.navigate;
          //           }),
          //     ),
          //   ));
          //   print("=================== $redirectFrom");
          //   if (redirectFrom
          //       .startsWith('http://karaj-payment.cc/shopper/redirect')) {
          //     Map<String, dynamic> checkStatus =
          //         await PaymentController.checkPaymentStatus(
          //             payVia: payVia,
          //             paymentId:
          //                 Get.find<OrderingController>().order.paymentId);
          //
          //     if (checkStatus["status"] == "payed") {
          //       Get.find<OrderingController>().order.payed = 1;
          //       String id = await Database().generateId();
          //       Get.find<OrderingController>().order.id = id;
          //       await PaymentController.createOrderPayment(
          //           forId: FirebaseAuth.instance.currentUser?.uid,
          //           order: Get.find<OrderingController>().order,
          //           paymentID: Get.find<OrderingController>().order.paymentId,
          //           payVia: _cardType,
          //           typeX: "added",
          //           title: 'payedForOrder');
          //       //   await PaymentController.createOrderPayment(forId: FirebaseAuth.instance.currentUser?.uid, order: Get.find<OrderingController>().order, paymentID: "123", payVia: _cardType, typeX: "discount");
          //       OrderModel o =
          //           await Get.find<OrderingController>().submitOrder(id: id);
          //       if (o != null) {
          //         Get.offAll(OrderDetails(order: o, navToHome: true));
          //       }
          //     } else {
          //       GetxWidgetHelpers.mSnackBar("خطاء", resultPaying["message"]);
          //       return;
          //     }
          //   }
          // }
          // return null;
        }
      } else {
        OrderModel o = await Get.find<OrderingController>().submitOrder();
        if (o != null) {
          Get.offAll(OrderDetails(order: o, navToHome: true));
        }
      }
    } else if (widget.comingFrom == 'spares') {
      if (!_formKey.currentState.validate()) {
        return;
      } else {
        SparesModel lOrder = Get.find<ModifiedOrderController>().order.value;

        CardInfo card = CardInfo(
          holder: _cardHolder.text,
          cardNumber: _cardNumber.text.replaceAll(' ', ''),
          cvv: _cardCvv.text,
          expiryMonth: _expiryDate.text.split('/')[0],
          expiryYear: '20' + _expiryDate.text.split('/')[1],
        );
        try {
          if (sessionCheckoutID.isEmpty) {
            final data = {
              'currency': 'SAR',
              'paymentType': 'DB',
            };
            print(data.toString());
            await initPaymentSession(brandType, lOrder.totalPrice, data);
          }
          final result = await hyperpay.pay(
            card,
          );
          print('Payment result ::::: $result');
          switch (result) {
            case PaymentStatus.successful:
              sessionCheckoutID = '';
              Future.delayed(
                  Duration.zero,
                  () => Get.dialog(Center(child: CircularProgressIndicator()),
                      barrierDismissible: false));
              await PaymentController.createSparePayment(
                  forId: FirebaseAuth.instance.currentUser?.uid,
                  order: lOrder,
                  paymentID: "123",
                  payVia: _cardType,
                  typeX: "added",
                  title: 'payedForSpares');
              await PaymentController.createSparePayment(
                  forId: FirebaseAuth.instance.currentUser?.uid,
                  order: lOrder,
                  paymentID: "123",
                  payVia: _cardType,
                  typeX: "discount",
                  title: 'cutForSpares');
              double newTotalPrice = lOrder.totalPrice;
              if (lOrder.deliveryPrice != null && lOrder.deliveryPrice > 0) {
                newTotalPrice =
                    (lOrder.totalPrice ?? 0) - (lOrder.deliveryPrice ?? 0);
                if (lOrder.deliveryPrice > lOrder.totalPrice) {
                  newTotalPrice = lOrder.deliveryPrice - lOrder.totalPrice;
                }
              }
              lOrder.totalPrice = newTotalPrice;
              String paymentID =
                  Get.find<ModifiedOrderController>().order.value.paymentID;
              await PaymentController.createSparePayment(
                  forId: lOrder.shopId,
                  order: lOrder,
                  paymentID: paymentID,
                  payVia: _cardType,
                  typeX: "added",
                  cut: true,
                  title: "ownedBySellingSpares");
              lOrder.totalPrice = newTotalPrice + (lOrder.deliveryPrice ?? 0);
              lOrder.payed = true;
              lOrder.paymentID = paymentID;
              lOrder.paymentUDC = paymentID;
              lOrder.paymentUrl = paymentID;
              lOrder.status = 6;
              Get.find<ModifiedOrderController>().order.value = lOrder;
              OrderModel xO = await Get.find<OrderingController>()
                  .submitOrder(id: "${lOrder.id}");
              SparesModel o =
                  await Get.find<ModifiedOrderController>().submitOrder();
              Get.back();
              if (o != null) {
                Get.find<ModifiedOrderController>().setOrder = o;
                Get.offAll(SparesOrderDetails(navToHome: true));
              } else {
                GetxWidgetHelpers.mSnackBar("حدث مشكلة.",
                    "حدث مشكلة اتناء عملية انشاء طلب لذلك يرجى مراسلة الدعم في حالة تم تحويل الملبغ.");
              }
              break;
            case PaymentStatus.pending:
              Get.back();
              GetxWidgetHelpers.mSnackBar(
                  "جارى التنفيذ", ' ⏳ العمليه قيد التنفيذ');
              break;
            case PaymentStatus.init:
              Get.back();
              GetxWidgetHelpers.mSnackBar("خطاء", 'عمليه مازالت قيد التنفيذ');
              break;
            case PaymentStatus.rejected:
              Get.back();
              GetxWidgetHelpers.mSnackBar("خطاء", 'عمليه فاشله');
              break;
          }
        } on HyperpayException catch (exception) {
          print("Hyper :: " + exception.toString());
          sessionCheckoutID = '';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(exception.details ?? exception.message),
              backgroundColor: Colors.red,
            ),
          );
        } catch (exception) {
          Get.back();
          GetxWidgetHelpers.mSnackBar("خطاء", 'عمليه فاشله');
        }
        // String payVia = widget.paymentMethod;
        // String cardNumber = _cardNumber.text.replaceAll("-", "");
        // expiryMonth =
        // expiryMonth.startsWith("0") ? expiryMonth : "0$expiryMonth";
        //
        // Map<String, dynamic> resultPaying =
        // await PaymentController.sendAnInitialPayment(data: {
        //   'entityId': "",
        //   'amount': lOrder.totalPrice.toString(),
        //   'currency': 'SAR',
        //   'paymentBrand': _cardType,
        //   'paymentType': 'DB',
        //   'card.number': _cardNumber.text.replaceAll(' ', 'replace'),
        //   'card.holder': _cardHolder.text,
        //   'card.expiryMonth': expiryMonth,
        //   'card.expiryYear': expiryYear,
        //   'card.cvv': _cardCvv.text,
        // }, payVia: payVia, orderType: 'spares');
        //
        // String status = "";
        // if (resultPaying["status"] == "pending") {
        //   var redirectFrom = await Get.to(SafeArea(
        //     child: Scaffold(
        //       body: WebView(
        //           initialUrl: resultPaying["url"],
        //           javascriptMode: JavascriptMode.unrestricted,
        //           onPageFinished: (String url) {},
        //           navigationDelegate: (NavigationRequest request) {
        //             if (request.url.startsWith(
        //                 'http://karaj-payment.cc/shopper/redirect')) {
        //               Get.back(result: request.url);
        //             }
        //             return NavigationDecision.navigate;
        //           }),
        //     ),
        //   ),);

        // if (redirectFrom
        //     .startsWith('http://karaj-payment.cc/shopper/redirect')) {
        //   Map<String, dynamic> checkStatus =
        //       await PaymentController.checkPaymentStatus(
        //           payVia: payVia,
        //           paymentId: Get.find<ModifiedOrderController>()
        //               .order
        //               .value
        //               .paymentID);

        // if (checkStatus["status"] == "payed") {
        //   Future.delayed(
        //       Duration.zero,
        //       () => Get.dialog(Center(child: CircularProgressIndicator()),
        //           barrierDismissible: false));
        //   await PaymentController.createSparePayment(
        //       forId: FirebaseAuth.instance.currentUser?.uid,
        //       order: lOrder,
        //       paymentID: "123",
        //       payVia: _cardType,
        //       typeX: "added",
        //       title: 'payedForSpares');
        //   await PaymentController.createSparePayment(
        //       forId: FirebaseAuth.instance.currentUser?.uid,
        //       order: lOrder,
        //       paymentID: "123",
        //       payVia: _cardType,
        //       typeX: "discount",
        //       title: 'cutForSpares');
        //   double newTotalPrice = lOrder.totalPrice;
        //   if (lOrder.deliveryPrice != null && lOrder.deliveryPrice > 0) {
        //     newTotalPrice =
        //         (lOrder.totalPrice ?? 0) - (lOrder.deliveryPrice ?? 0);
        //     if (lOrder.deliveryPrice > lOrder.totalPrice) {
        //       newTotalPrice = lOrder.deliveryPrice - lOrder.totalPrice;
        //     }
        //   }
        //   lOrder.totalPrice = newTotalPrice;
        //   String paymentID =
        //       Get.find<ModifiedOrderController>().order.value.paymentID;
        //   await PaymentController.createSparePayment(
        //       forId: lOrder.shopId,
        //       order: lOrder,
        //       paymentID: paymentID,
        //       payVia: _cardType,
        //       typeX: "added",
        //       cut: true,
        //       title: "ownedBySellingSpares");
        //   lOrder.totalPrice = newTotalPrice + (lOrder.deliveryPrice ?? 0);
        //   lOrder.payed = true;
        //   lOrder.paymentID = paymentID;
        //   lOrder.paymentUDC = paymentID;
        //   lOrder.paymentUrl = paymentID;
        //   lOrder.status = 6;
        //   Get.find<ModifiedOrderController>().order.value = lOrder;
        //   OrderModel xO = await Get.find<OrderingController>()
        //       .submitOrder(id: "${lOrder.id}");
        //   SparesModel o =
        //       await Get.find<ModifiedOrderController>().submitOrder();
        //   Get.back();
        //   if (o != null) {
        //     Get.find<ModifiedOrderController>().setOrder = o;
        //     Get.offAll(SparesOrderDetails(navToHome: true));
        //   } else {
        //     GetxWidgetHelpers.mSnackBar("حدث مشكلة.",
        //         "حدث مشكلة اتناء عملية انشاء طلب لذلك يرجى مراسلة الدعم في حالة تم تحويل الملبغ.");
        //   }
        // } else {
        //   GetxWidgetHelpers.mSnackBar("خطاء", resultPaying["message"]);
        //   return;
        // }
      }
    }
    setState(() {
      onLoading = true;
    });
    return null;
  }
}

// if (result == PaymentStatus.successful) {
// sessionCheckoutID = '';
// Get
//     .find<OrderingController>()
//     .order
//     .payed = 1;
// String id = await Database().generateId();
// Get
//     .find<OrderingController>()
//     .order
//     .id = id;
// await PaymentController.createOrderPayment(
// forId: FirebaseAuth.instance.currentUser?.uid,
// order: Get
//     .find<OrderingController>()
//     .order,
// paymentID: Get
//     .find<OrderingController>()
//     .order
//     .paymentId,
// payVia: _cardType,
// typeX: "added",
// title: 'payedForOrder',
// );
// OrderModel o =
// await Get.find<OrderingController>().submitOrder(id: id);
// if (o != null) {
// Get.offAll(OrderDetails(order: o, navToHome: true));
// }
// } else {
// Get.back();
// GetxWidgetHelpers.mSnackBar("خطاء", 'عمليه فاشله');
// }
