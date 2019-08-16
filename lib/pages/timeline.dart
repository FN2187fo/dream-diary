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

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        this.setState(() => fileContent = jsonDecode(jsonFile.readAsStringSync()));
      }
    });
  }

  void readFile() {
    this.setState(() => fileContent = jsonDecode(jsonFile.readAsStringSync()));
    print(fileContent);
  }

  void deleteContent(index) {
    Map<String, dynamic> jsonFileContent = jsonDecode(jsonFile.readAsStringSync());
    print("Json decoded");
    jsonFileContent.remove(index);
    print("Removed from fileContent");
    jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
    print("Written to jsonFile");
    setState(() {
      fileContent = jsonDecode(jsonFile.readAsStringSync());
    });
  }

   @override
   Widget build(BuildContext context) {
     return new Scaffold(
       appBar: AppBar(
         centerTitle: true,
         title: Text("Timeline"),
       ),
       body: ListView.builder(
         itemCount: fileContent.values.length,
         itemBuilder: (context, index) {
          int _index = fileContent.length.toInt() - index.toInt() - 1;
          return Dismissible(
            key: Key(fileContent.keys.elementAt(_index)),
            onDismissed: (direction) {
              Map<String, dynamic> jsonFileContent = jsonDecode(jsonFile.readAsStringSync());
              jsonFileContent.remove(fileContent.keys.elementAt(_index));
              jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
              setState(() {
                fileContent = jsonDecode(jsonFile.readAsStringSync());
              });
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Deleted entry"),));
            },
            child: Card(
              child: ListTile(
                title: Text(fileContent.values.elementAt(_index)), 
                subtitle: Text(fileContent.keys.elementAt(_index).split(" ").elementAt(0)),
              ),
            ),
          );
         },
       ),

     );
   }
}