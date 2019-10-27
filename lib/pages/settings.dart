import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings"),
      ),
      body: Center(
        child: FlatButton(
          onPressed: () {
            DynamicTheme.of(context).setBrightness(
              Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
              
            );
          },
          child: Text("Change Theme"),
        ),
      ),
    );
  }
}