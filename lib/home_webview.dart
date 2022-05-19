import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebViewPlusController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form.io WebView'),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          width: 500,
          child: WebViewPlus(
            initialUrl: 'assets/form.html',
            onWebViewCreated: (controller) {
              _controller ??= controller;
            },
            debuggingEnabled: true,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (_) => passFormToWebView(),
            javascriptChannels: {
              JavascriptChannel(
                name: 'formUpdated',
                onMessageReceived: onUpdateForm,
              ),
            },
          ),
        ),
      ),
    );
  }

  void passFormToWebView() async {
    final json = await rootBundle.loadString('assets/simple_form.json');
    _controller?.webViewController.runJavascript('createForm($json, {})');
  }

  void onUpdateForm(JavascriptMessage msg) async {
    print(msg.message);

    final data = jsonDecode(msg.message);
    if (data['select'] == 'second') {
      final json = await rootBundle.loadString('assets/simple_form_2.json');
      _controller?.webViewController.runJavascript(
        'createForm($json, ${jsonEncode(data)})',
      );
    }
  }
}
