import 'dart:io';
import 'package:flutter/material.dart';
import 'package:karaj/bindings/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class WebViewContent extends StatefulWidget {
  @override
  _WebViewContentState createState() => _WebViewContentState();
}

class _WebViewContentState extends State<WebViewContent> {

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "rules".tr),
      body: WebView(
        initialUrl: 'https://garage-app.co/privacy',
      ),
    );
  }
}
