import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'add.dart';
import 'package:dream_diary/local_notifications_helper.dart';

class You extends StatefulWidget {
  @override
  _YouState createState() => _YouState();
}

class _YouState extends State<You> {
  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    final settingsAndroid = new AndroidInitializationSettings('bed');
    final settingsIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: (id, title, body, payload) => onSelectNotification(payload));
    notifications.initialize(InitializationSettings(settingsAndroid, settingsIOS,), onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async => await Navigator.push(context, MaterialPageRoute(builder: (context) => Add()));

  static var androidPlatformChannelSpecifics = AndroidNotificationDetails('Add entry', 'your channel name', 'your channel description', importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  static var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("You"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Send notification"),
          onPressed: () {
            notifications.show(0, "Add entry", "It is time to add a new entry", platformChannelSpecifics);
          },
        ),
      )
    );
  }
}