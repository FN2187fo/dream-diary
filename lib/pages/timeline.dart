import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  File jsonFile;
  Directory dir;
  String fileName = "dreamDiary.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        this.setState(
            () => fileContent = jsonDecode(jsonFile.readAsStringSync()));
      }
    });
  }

  void readFile() {
    this.setState(() => fileContent = jsonDecode(jsonFile.readAsStringSync()));
  }

  void deleteContent(index) {
    Map<String, dynamic> jsonFileContent =
        jsonDecode(jsonFile.readAsStringSync());
    jsonFileContent.remove(index);
    jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
    setState(() {
      fileContent = jsonDecode(jsonFile.readAsStringSync());
    });
  }

  void writeToFile(String key, dynamic value) {
    Map<String, dynamic> content = {key: value};
    Map<String, dynamic> jsonFileContent =
        jsonDecode(jsonFile.readAsStringSync());
    jsonFileContent.addAll(content);
    jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));

    this.setState(() => fileContent = jsonDecode(jsonFile.readAsStringSync()));
  }

  _getContent() async {
    if (fileContent.isNotEmpty) {
      return ListView.builder(
          itemCount: fileContent.values.length,
          itemBuilder: (context, index) {
            return _getListItem(index);
          });
    }
  }

  _deleteListItem(index) {
    Map<String, dynamic> jsonFileContent =
        jsonDecode(jsonFile.readAsStringSync());
    jsonFileContent.remove(fileContent.keys.elementAt(index));
    jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
    setState(() {
      fileContent = jsonDecode(jsonFile.readAsStringSync());
    });
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Deleted entry"),
    ));
  }

  _getListItem(index) {
    int _index = fileContent.length.toInt() - index.toInt() - 1;
    String date = fileContent.keys.elementAt(_index).split(" ").elementAt(0);
    String formatedDate = date.split("-").elementAt(2) +
        "." +
        date.split("-").elementAt(1) +
        "." +
        date.split("-").elementAt(0);
    _controller =
        TextEditingController(text: fileContent.values.elementAt(_index));
    return Dismissible(
        key: Key(fileContent.keys.elementAt(_index)),
        onDismissed: (direction) {
          _deleteListItem(_index);
        },
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ButtonBar(
                        children: <Widget>[
                          ButtonTheme(
                            minWidth: 20,
                            child: FlatButton(
                              child: Icon(Icons.edit),
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          ButtonBar(
                                            children: <Widget>[
                                              FlatButton(
                                                child: Icon(Icons.check),
                                                onPressed: () {
                                                  writeToFile(
                                                      fileContent.keys
                                                          .elementAt(_index),
                                                      _controller.text);
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ),
                                          ListTile(
                                            title: TextFormField(
                                              decoration: InputDecoration(
                                                hintText:
                                                    "What did you dream about?",
                                              ),
                                              controller: _controller,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              textInputAction:
                                                  TextInputAction.go,
                                              minLines: 10,
                                              maxLines: 50,
                                              onEditingComplete: () {
                                                writeToFile(
                                                    fileContent.keys
                                                        .elementAt(_index),
                                                    _controller.text);
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          )
                                        ],
                                      );
                                    });
                              },
                            ),
                          ),
                          ButtonTheme(
                            minWidth: 20,
                            child: FlatButton(
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _deleteListItem(_index);
                                Navigator.of(context).pop();
                              },
                              splashColor: Colors.red[200],
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        title: Text(
                          fileContent.values.elementAt(_index),
                        ),
                        subtitle: Text(formatedDate),
                      )
                    ],
                  );
                });
          },
          child: Card(
            child: ListTile(
              title: Text(fileContent.values.elementAt(_index)),
              subtitle: Text(formatedDate),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Timeline"),
        ),
        body: Container(
          child: FutureBuilder(
              future: _getContent(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) return snapshot.data;

                return Center(
                    child: Image.asset("assets/undraw_no_data_qbuo.png"));
              }),
        ));
  }
}