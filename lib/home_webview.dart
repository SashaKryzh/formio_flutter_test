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
  dynamic curJsonData;

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
          child: WebViewPlus(
            initialUrl: 'assets/form.html',
            onWebViewCreated: (controller) {
              _controller ??= controller;
            },
            debuggingEnabled: true,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (_) => initForm(),
            javascriptChannels: {
              JavascriptChannel(
                name: 'formUpdated',
                onMessageReceived: onFormUpdated,
              ),
            },
          ),
        ),
      ),
    );
  }

  void initForm() async {
    final form = await rootBundle.loadString('assets/example_1.json');
    _controller?.webViewController.runJavascript('createForm($form)');
  }

  void onFormUpdated(JavascriptMessage message) async {
    print('Form data: ${message.message}');

    final newJsonData = jsonDecode(message.message);
    if (curJsonData.toString() == newJsonData.toString()) {
      return;
    }

    curJsonData = newJsonData;

    if (newJsonData['select'] == 'second') {
      final form = await rootBundle.loadString('assets/example_2.json');
      updateForm(form, jsonEncode(newJsonData));
    } else {
      final form = await rootBundle.loadString('assets/example_1.json');
      updateForm(form, jsonEncode(newJsonData));
    }
  }

  void updateForm(String form, [String? data]) {
    _controller?.webViewController.runJavascript('updateForm($form, $data)');
  }
}
