import 'package:ferplay/Strings.dart';
import 'package:ferplay/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final evento = FirebaseDatabase.instance.reference().child(Strings.eventoBD);

class Evento extends StatelessWidget {
  final TextEditingController _controller = new TextEditingController();

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
          body: new Form(child:
            new Column(children: <Widget>[
            new TextField(
            controller: _controller,
              decoration: new InputDecoration(
                hintText: 'Nombre del evento',
              ),
            ),
            new TextField(
              controller: _controller,
              decoration: new InputDecoration(
                hintText: 'Lugar del evento',
              ),
            ),
              new RaisedButton(
                child: new Text("Guardar"),
                  onPressed: () {

                  },
              )
          ])
          )
      ),
    );
  }
}
