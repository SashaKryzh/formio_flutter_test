import 'package:flutter/material.dart';
import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_test/home_formio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormioWidgetProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeFormio(),
        // home: const Home(),
      ),
    );
  }
}
