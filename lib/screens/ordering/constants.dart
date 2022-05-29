import 'package:hyperpay/hyperpay.dart';

class TestConfig implements HyperpayConfig {
  @override
  String creditcardEntityID = '8ac9a4cc80d641500180efc56a450cab';
  @override
  String madaEntityID = '8ac9a4cc80d641500180efc6b9160cbb';
  @override
  Uri checkoutEndpoint = _checkoutEndpoint;
  @override
  Uri statusEndpoint = _statusEndpoint;
  @override
  PaymentMode paymentMode = PaymentMode.test;
}

class LiveConfig implements HyperpayConfig {
  @override
  String creditcardEntityID = '8ac9a4cc80d641500180efc56a450cab';
  @override
  String madaEntityID = '8ac9a4cc80d641500180efc6b9160cbb';
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
// String _host = 'test.oppwa.com';

//Live Host
String _host = 'eu-prod.oppwa.com';

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
