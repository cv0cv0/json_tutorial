import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Home(),
      );
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final keyInputController = TextEditingController();
  final valueInputController = TextEditingController();

  String keyErrorText;
  String valueErrorText;

  File jsonFile;
  Map<String, dynamic> fileContent;
  static const fileName = 'tutorial.json';

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      jsonFile = File('${directory.path}/$fileName');
      if (jsonFile.existsSync()) {
        fileContent = json.decode(jsonFile.readAsStringSync());
      } else {
        fileContent = Map();
        jsonFile.createSync();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('JSON Tutorial'),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0),
          child: Column(
            children: <Widget>[
              Text(
                'File content: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.only(top: 8.0),
                child: Text(fileContent.toString()),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 50.0),
                child: Text('Add to JSON file: '),
              ),
              TextField(
                controller: keyInputController,
                decoration: InputDecoration(errorText: keyErrorText),
                onChanged: (String text) {
                  if (keyErrorText != null) {
                    setState(() {
                      keyErrorText = null;
                    });
                  }
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 6.0),
                child: TextField(
                  controller: valueInputController,
                  decoration: InputDecoration(errorText: valueErrorText),
                  onChanged: (String text) {
                    if (valueErrorText != null) {
                      setState(() {
                        valueErrorText = null;
                      });
                    }
                  },
                ),
              ),
              Container(
                width: 750.0,
                height: 46.0,
                margin: EdgeInsets.only(top: 40.0),
                child: RaisedButton(
                  onPressed: () {
                    var key = keyInputController.text;
                    var value = valueInputController.text;

                    if (key == null || key.isEmpty) {
                      keyErrorText = 'key is empty';
                    }
                    if (value == null || value.isEmpty) {
                      valueErrorText = 'value is empty';
                    }

                    if (keyErrorText == null && valueErrorText == null) {
                      fileContent[key] = value;
                      jsonFile.writeAsStringSync(json.encode(fileContent));

                      keyInputController.clear();
                      valueInputController.clear();
                    }

                    setState(() {});
                  },
                  color: Theme.of(context).accentColor,
                  child: Text(
                    'Add key, value pair',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    keyInputController.dispose();
    valueInputController.dispose();
    super.dispose();
  }
}
