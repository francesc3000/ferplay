import 'package:ferplay/Evento.dart';
import 'package:ferplay/Strings.dart';
import 'package:ferplay/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class DashBoard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text(Strings.dashBoardTitle),
            bottom: new TabBar(
              isScrollable: true,
              tabs: choices.map((_Choice choice) {
                return new Tab(
                  text: choice.title,
                  icon: new Icon(choice.icon),
                );
              }).toList(),
            ),
          ),
          body: new TabBarView(
                children: choices.map((_Choice choice) {
                  return new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new ChoiceCard(choice: choice),
                  );
                }).toList(),
              ),
          floatingActionButton: new FloatingActionButton(
            tooltip: Strings.add, // used by assistive technologies
            child: new Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) => new Evento()));
            },
          ),
        ),
      ),
    );
  }
}

class _Choice {
  const _Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

List<_Choice> choices = <_Choice>[
  new _Choice(title: Strings.myEnrolls, icon: Icons.group_work),
  new _Choice(title: Strings.myEventos, icon: Icons.event),
  new _Choice(title: Strings.myFavorites, icon: Icons.star),
  new _Choice(title: Strings.myGroups, icon: Icons.group),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({ Key key, this.choice }) : super(key: key);

  final _Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return new Card(
      color: Colors.white,
      child: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(choice.icon, size: 128.0, color: textStyle.color),
            new Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}