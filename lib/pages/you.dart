import 'package:flutter/material.dart';

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
     );
   }
}