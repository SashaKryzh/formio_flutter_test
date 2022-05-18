import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WebViewPlusController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form.io test'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: WebViewPlus(
          initialUrl: 'about:blank',
          onWebViewCreated: (controller) {
            _controller = controller;
            _loadForm();
          },
          debuggingEnabled: true,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }

  void _loadForm() async {
    _controller.loadUrl('assets/form.html');
    // _controller.loadUrl(
    //     'https://decode.agency/article/form-io-in-native-android-application/');
  }
}
