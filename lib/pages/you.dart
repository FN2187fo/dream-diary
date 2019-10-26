import 'package:flutter/material.dart';
import 'notifications.dart';

class You extends StatefulWidget {
  @override
  _YouState createState() => _YouState();
}

class _YouState extends State<You> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("You"),
      ),
      body: ListView(
        children: <Widget>[
          Divider(),
          ListTile(title: Text("Notifications", textAlign: TextAlign.center,), onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));}),
          Divider(),
        ],
      )
    );
  }
}