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
  String binKey;
  String binValue;
  TextEditingController _controller;
  TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Timeline');

  @override
  void initState() {
    super.initState();
    //_filter.addListener(_searching());
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: fileContent.length.toInt(),
        // ignore: missing_return
        itemBuilder: (context, index) {
          int _index = fileContent.length - index.toInt() - 1;
          if (_index >= 0) {
            String date =
                fileContent.keys.elementAt(_index).split(" ").elementAt(0);
            String formatedDate = date.split("-").elementAt(2) +
                "." +
                date.split("-").elementAt(1) +
                "." +
                date.split("-").elementAt(0);
            _controller = TextEditingController(
                text: fileContent.values.elementAt(_index));
            if (fileContent.values.elementAt(_index).contains(_searchText)) {
              return Dismissible(
                  key: Key(fileContent.keys.elementAt(_index)),
                  onDismissed: (direction) {
                    binKey = fileContent.keys.elementAt(_index);
                    binValue = fileContent.values.elementAt(_index);
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
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    ButtonBar(
                                                      children: <Widget>[
                                                        FlatButton(
                                                          child:
                                                              Icon(Icons.check),
                                                          onPressed: () {
                                                            writeToFile(
                                                                fileContent.keys
                                                                    .elementAt(
                                                                        _index),
                                                                _controller
                                                                    .text);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                    ListTile(
                                                      title: TextFormField(
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "What did you dream about?",
                                                        ),
                                                        controller: _controller,
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        textInputAction:
                                                            TextInputAction.go,
                                                        minLines: 10,
                                                        maxLines: 50,
                                                        onEditingComplete: () {
                                                          writeToFile(
                                                              fileContent.keys
                                                                  .elementAt(
                                                                      _index),
                                                              _controller.text);
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();
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
          }
        },
      ),
    );
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
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            writeToFile(binKey, binValue);
          }),
    ));
  }

  _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = TextField(
          controller: _filter,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: "Search..."),
          onChanged: (value) {
            setState(() {
              _searchText = value;
              _getContent();
            });
          },
        );
      } else {
        this._searchIcon = Icon(Icons.search);
        this._appBarTitle = Text("Timeline");
        _searchText = "";
        _filter.clear();
      }
    });
  }

  _buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: IconButton(
          icon: _searchIcon,
          onPressed: () {
            _searchPressed();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: _buildBar(context),
        body: Container(
          child: FutureBuilder(
              future: _getContent(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data;
                } else {
                  return Center(
                      child: Image.asset("assets/undraw_no_data_qbuo.png"));
                }
              }),
        ));
  }
}
