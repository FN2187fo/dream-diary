import 'package:dream_diary/pages/home.dart';
import 'package:dream_diary/pages/timeline.dart';
import 'package:dream_diary/pages/you.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink[800]
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<Widget> _pages = [
    Home(),
    Timeline(),
    You()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index; 
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart),
            title: Text("Home")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timelapse),
            title: Text("Timeline")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text("You")
          )
        ],
      ),
    );
  }
}