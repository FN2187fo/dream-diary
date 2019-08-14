import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
   @override
   Widget build(BuildContext context) {
     return new Scaffold(
       appBar: AppBar(
         centerTitle: true,
         title: Text("Home"),
       ),
       floatingActionButton: FloatingActionButton(
         onPressed: () {
           
         },
         child: Icon(Icons.add),
       ),
     );
   }
}