import 'package:dream_diary/pages/timeline.dart';
import 'package:flutter/material.dart';
import 'add.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  _getItemCount(){
    if(fileContent.values.length > 5) {
      return 6;
    } else {
      return fileContent.values.length + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 154,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _getItemCount(),
              itemBuilder: (context, index) {
                if(index == 5 || index == _getItemCount() - 1 || fileContent.keys.length == 0) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Timeline()));
                    },
                    child: Container(
                      width: 150,
                      child: Card(
                        color: Theme.of(context).accentColor,
                        child: Center(
                          child: Text("Show all", style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    width: 200,
                    child: Card(
                      child: ListTile(
                        title: Text(fileContent.values.elementAt(fileContent.length - index - 1)), 
                        subtitle: Text(fileContent.keys.elementAt(fileContent.length - index - 1).split(" ").elementAt(0)),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Add()));
        },
          child: Icon(Icons.add),
       ),
     );
   }
}