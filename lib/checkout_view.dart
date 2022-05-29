import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyperpay/hyperpay.dart';
import 'package:karaj/screens/ordering/constants.dart';
import 'package:karaj/screens/ordering/formatters.dart';

class CheckoutView extends StatefulWidget {
  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  TextEditingController holderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

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
    hyperpay = await HyperpayPlugin.setup(config: TestConfig());
  }

  /// Initialize HyperPay session
  Future<void> initPaymentSession(
    BrandType brandType,
    double amount,
  ) async {
    CheckoutSettings _checkoutSettings = CheckoutSettings(
      brand: brandType,
      amount: 1.0,
      headers: {
        'Authorization':
            'Bearer OGFjOWE0Y2M4MGQ2NDE1MDAxODBlZmM0ZTA4MzBjOWV8WjVwNGZXbVQ3Sw==',
        'merchantTransactionId': "1234567890",
      },
      additionalParams: {
        'currency': 'SAR',
        'paymentType': 'DB',
        'merchantTransactionId': "1234567890",
        'customer.email': 'op.op0102569@gmail.com',
        'billing.street1': 'Elsalam ST',
        'billing.city': 'Jeddah',
        'billing.state': 'Jeddah',
        'billing.country': 'SA',
        'billing.postcode': '13511',
        'customer.givenName': 'Said',
        'customer.surname': 'Mohamed'
      },
    );

    hyperpay.initSession(checkoutSetting: _checkoutSettings);
    sessionCheckoutID = await hyperpay.getCheckoutID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            autovalidateMode: autovalidateMode,
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    // Holder
                    TextFormField(
                      controller: holderNameController,
                      decoration: _inputDecoration(
                        label: "Card Holder",
                        hint: "Jane Jones",
                        icon: Icons.account_circle_rounded,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Number
                    TextFormField(
                      controller: cardNumberController,
                      decoration: _inputDecoration(
                        label: "Card Number",
                        hint: "0000 0000 0000 0000",
                        icon: brandType == BrandType.none
                            ? Icons.credit_card
                            : 'assets/images/${brandType.asString}.png',
                      ),
                      onChanged: (value) {
                        setState(() {
                          brandType = value.detectBrand;
                        });
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(brandType.maxLength),
                        CardNumberInputFormatter()
                      ],
                      validator: (String number) =>
                          brandType.validateNumber(number ?? ""),
                    ),
                    const SizedBox(height: 10),
                    // Expiry date
                    TextFormField(
                      controller: expiryController,
                      decoration: _inputDecoration(
                        label: "Expiry Date",
                        hint: "MM/YY",
                        icon: Icons.date_range_rounded,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        CardMonthInputFormatter(),
                      ],
                      validator: (String date) =>
                          CardInfo.validateDate(date ?? ""),
                    ),
                    const SizedBox(height: 10),
                    // CVV
                    TextFormField(
                      controller: cvvController,
                      decoration: _inputDecoration(
                        label: "CVV",
                        hint: "000",
                        icon: Icons.confirmation_number_rounded,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: (String cvv) =>
                          CardInfo.validateCVV(cvv ?? ""),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                final bool valid =
                                    Form.of(context)?.validate() ?? false;
                                if (valid) {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  // Make a CardInfo from the controllers
                                  CardInfo card = CardInfo(
                                    holder: holderNameController.text,
                                    cardNumber: cardNumberController.text
                                        .replaceAll(' ', ''),
                                    cvv: cvvController.text,
                                    expiryMonth:
                                        expiryController.text.split('/')[0],
                                    expiryYear: '20' +
                                        expiryController.text.split('/')[1],
                                  );

                                  try {
                                    // Start transaction
                                    if (sessionCheckoutID.isEmpty) {
                                      // Only get a new checkoutID if there is no previous session pending now
                                      await initPaymentSession(brandType, 1);
                                    }

                                    final result = await hyperpay.pay(card);
                                    print('Result ::::: $result');
                                    switch (result) {
                                      case PaymentStatus.init:
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Payment session is still in progress'),
                                            backgroundColor: Colors.amber,
                                          ),
                                        );
                                        break;
                                      // For the sake of the example, the 2 cases are shown explicitly
                                      // but in real world it's better to merge pending with successful
                                      // and delegate the job from there to the server, using webhooks
                                      // to get notified about the final status and do some action.
                                      case PaymentStatus.pending:
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Payment pending ⏳'),
                                            backgroundColor: Colors.amber,
                                          ),
                                        );
                                        break;
                                      case PaymentStatus.successful:
                                        sessionCheckoutID = '';
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Payment approved 🎉'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        break;

                                      default:
                                    }
                                  } on HyperpayException catch (exception) {
                                    print("Hyper :: " + exception.toString());
                                    sessionCheckoutID = '';
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(exception.details ??
                                            exception.message),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } catch (exception) {
                                    print("Flutter :: " + exception.toString());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('$exception'),
                                      ),
                                    );
                                  }

                                  setState(() {
                                    isLoading = false;
                                  });
                                } else {
                                  setState(() {
                                    autovalidateMode =
                                        AutovalidateMode.onUserInteraction;
                                  });
                                }
                              },
                        child: Text(
                          isLoading
                              ? 'Processing your request, please wait...'
                              : 'PAY',
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String label, String hint, dynamic icon}) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      prefixIcon: icon is IconData
          ? Icon(icon)
          : Container(
              padding: const EdgeInsets.all(6),
              width: 10,
              child: Image.asset(icon),
            ),
    );
  }
}
