import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

//
// !!! NOT IMPLEMENTED !!!
//

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form.io test'),
      ),
      body: WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (controller) {
          _controller = controller;
          _loadForm();
        },
        debuggingEnabled: true,
      ),
    );
  }

  void _loadForm() async {
    final html = await rootBundle.loadString('assets/form.html');
    _controller.loadHtmlString(html);
    // _controller.loadUrl(
    //     'https://decode.agency/article/form-io-in-native-android-application/');
  }
}
