import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formio_flutter/formio_flutter.dart';

class HomeFormio extends StatefulWidget {
  const HomeFormio({Key? key}) : super(key: key);

  @override
  State<HomeFormio> createState() => _HomeFormioState();
}

class _HomeFormioState extends State<HomeFormio> implements ClickListener {
  late final FormioWidgetProvider widgetProvider;
  Future<List<Widget>>? widgets;

  @override
  void didChangeDependencies() {
    widgets ??= _buildWidgets(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    widgetProvider = FormioWidgetProvider.of(context)!;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: FutureBuilder<List<Widget>>(
          future: widgets,
          builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                print('snapshot data ${snapshot.hasData}');
                print('snapshot error ${snapshot.hasError}');
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error in Form\n${snapshot.error}'),
                  );
                }
                return (snapshot.hasData)
                    ? ListView.builder(
                        itemCount: snapshot.data!.length,
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => snapshot.data![index],
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              case ConnectionState.waiting:
                print('waiting');
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.none:
                print('none');
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                print('default');
                return Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }

  Future<List<Widget>> _buildWidgets(BuildContext context) async {
    String _json = await rootBundle.loadString('assets/form.json');
    var formCollection = FormCollection.fromJson(json.decode(_json));
    List<Map<String, dynamic>> defaultMapper = [
      {'textField': 'Default value'},
    ];
    formCollection = await parseFormCollectionDefaultValueListMap(
      formCollection,
      defaultMapper,
    );
    print(
        'formCollection.components ${formCollection.components!.last.action}');

    return WidgetParserBuilder.buildWidgets(
      formCollection,
      context,
      this,
      widgetProvider,
    );
  }

  @override
  void onClicked(String event) async {
    print("button clicked");
    Future<Map<String, dynamic>> formData =
        parseWidgets(WidgetParserBuilder.widgets);

    formData.then((Map<String, dynamic> formDataValue) async {
      if (await checkFields(WidgetParserBuilder.widgets)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill all the fields'),
          ),
        );
      } else {
        formDataValue.entries
            .forEach((MapEntry<String?, dynamic> formEntryMap) {
          print('value ${formEntryMap.value.toString()}');
        });
        // showAlert(
        //   'keys: ${formDataValue.keys}\nvalues: ${formDataValue.values}',
        // );
      }

      // if (formDataValue.isNotEmpty) {
      //   print('formDataValue.isNotEmpty');
      // } else {
      //   print('formDataValue.isEmpty');
      // }

      // try {
      //   if (formDataValue.entries.last.value as bool == false) {
      //     print('Agreement not done');
      //   } else {
      //     print('Agreement done');
      //   }
      // } catch (e) {
      //   print(e);
      // }

      // for (int i = 0; i < formDataValue.values.length; i++) {
      //   formDataValue.values.any.call();
      //   if (formDataValue.values.toList()[i] == null) {
      //     print('Incomplete form');
      //   } else {
      //     showAlert(
      //       'keys: ${formDataValue.keys}\nvalues: ${formDataValue.values}',
      //     );
      //   }
      // }

      // for (int i = 0; i < formDataValue.keys.length; i++) {
      //   print(
      //     '${formDataValue.keys.toList()[i]} : ${formDataValue.values.toList()[i]}',
      //   );
      // }
    });
  }
}
