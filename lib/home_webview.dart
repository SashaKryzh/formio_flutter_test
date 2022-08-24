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

  final _height = 500.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form.io WebView'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              height: _height,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: WebViewPlus(
                initialUrl: 'assets/form_page/form.html',
                onWebViewCreated: (controller) {
                  _controller ??= controller;
                },
                debuggingEnabled: true,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (_) {
                  initForm();
                },
                javascriptChannels: {
                  JavascriptChannel(
                    name: 'formUpdated',
                    onMessageReceived: onFormUpdated,
                  ),
                },
              ),
            ),
            TextButton(
              onPressed: checkValidity,
              child: const Text('Validate'),
            ),
          ],
        ),
      ),
    );
  }

  void initForm() async {
    final form =
        await rootBundle.loadString('assets/forms/text_field_test.json');
    _controller?.webViewController.runJavascript('createForm($form)');
  }

  void onFormUpdated(JavascriptMessage message) async {
    print('Form data: ${message.message}');

    return;

    final newJsonData = jsonDecode(message.message);
    if (curJsonData.toString() == newJsonData.toString()) {
      return;
    }

    curJsonData = newJsonData;

    if (newJsonData['select'] == 'second') {
      final form = await rootBundle.loadString('assets/forms/example_2.json');
      updateForm(form, jsonEncode(newJsonData));
    } else {
      final form = await rootBundle.loadString('assets/forms/example_1.json');
      updateForm(form, jsonEncode(newJsonData));
    }
  }

  void updateForm(String form, [String? data]) {
    _controller?.webViewController.runJavascript('updateForm($form, $data)');
  }

  void checkValidity() async {
    // _controller?.webViewController.runJavascript('checkValidity()');
    final result = await _controller?.webViewController
        .runJavascriptReturningResult('checkValidity()');
    print(result);
  }
}
