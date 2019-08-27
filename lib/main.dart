import 'package:dream_diary/pages/home.dart';
import 'package:dream_diary/pages/timeline.dart';
import 'package:dream_diary/pages/you.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          primaryColor: Colors.pink[800],
          canvasColor: Colors.white,
          brightness: Brightness.light),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: menu(context),
          body: TabBarView(
            children: [Home(), Timeline(), You()],
          ),
        ),
      ),
    );
  }

  Widget menu(BuildContext context) {
    return Container(
      color: Colors.pink,
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.white,
        tabs: [
          Tab(
            text: "Home",
          ),
          Tab(
            text: "Timeline",
          ),
          Tab(
            text: "You",
          ),
        ],
      ),
    );
  }
}
