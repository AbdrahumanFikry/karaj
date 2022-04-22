import 'package:hyperpay/hyperpay.dart';

class TestConfig implements HyperpayConfig {
  @override
  String creditcardEntityID = '8ac7a4c97bdf4034017bdf501db60042';
  @override
  String madaEntityID = '8ac7a4c97bdf4034017bdf51a47f0048';
  @override
  Uri checkoutEndpoint = _checkoutEndpoint;
  @override
  Uri statusEndpoint = _statusEndpoint;
  @override
  PaymentMode paymentMode = PaymentMode.test;
}

class LiveConfig implements HyperpayConfig {
  @override
  String creditcardEntityID = '8ac7a4c97bdf4034017bdf501db60042';
  @override
  String madaEntityID = '8ac7a4c97bdf4034017bdf51a47f0048';
  @override
  Uri checkoutEndpoint = _checkoutEndpoint;
  @override
  Uri statusEndpoint = _statusEndpoint;
  @override
  PaymentMode paymentMode = PaymentMode.live;
}

// Setup using your own endpoints.
// https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk/integration/server.

//Test Host
String _host = 'test.oppwa.com';

//Live Host
// String _host = 'oppwa.com';
// String _host = 'pay-karaj.info';

Uri _checkoutEndpoint = Uri(
  scheme: 'https',
  host: _host,
  path: '/v1/checkouts',
);

Uri _statusEndpoint = Uri(
  scheme: 'https',
  host: _host,
  path: '/v1/checkouts',
);
