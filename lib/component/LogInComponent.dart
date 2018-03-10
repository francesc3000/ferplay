import 'package:ferplay/component/HomeComponent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LogInComponent extends StatefulWidget {
  @override
  _LogInComponent createState() => new _LogInComponent();
}

class _LogInComponent extends State<LogInComponent> {
  FacebookConnect _connect;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOSTheme
            : kDefaultTheme,
        home: new Scaffold(
        appBar: new AppBar(
        title: new Text(Strings.EventoTitle),
    ),
    body:
    ),);
  }

}