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
          return Card(
            child: ListTile(
              title: Text(fileContent.values.elementAt(index)), 
              subtitle: Text(fileContent.keys.elementAt(index).split(" ").elementAt(0)),
            ),
          );
         },
       ),

     );
   }
}