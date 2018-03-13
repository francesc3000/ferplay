
import 'package:ferplay/config/Strings.dart';
import 'package:ferplay/component/HomeComponent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class DashBoardComponent extends StatefulWidget {
  DashBoardComponent({Key key, this.drawerList}) : super(key: key);

  final Widget drawerList;

  @override
  _DashBoardComponent createState() => new _DashBoardComponent(drawerList);

}

class _DashBoardComponent extends State<DashBoardComponent> with SingleTickerProviderStateMixin{

  _DashBoardComponent(this.drawerList);

  final Widget drawerList;

  TabController _tabController = null;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: choices.length);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      //Hacemos aparecer el botón flotante
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
              controller: _tabController,
              isScrollable: true,
              tabs: choices.map((_Choice choice) {
                return new Tab(
                  text: choice.title,
                  icon: new Icon(choice.icon),
                );
              }).toList(),
            ),
          ),
          drawer: drawerList,
          body: new TabBarView(
            controller: _tabController,
            children: choices.map((_Choice choice) {
              return new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new ChoiceCard(choice: choice),
              );
            }).toList(),
          ),
          floatingActionButton: new FloatingButton(_tabController),
        ),
      ),
    );
  }
}

class FloatingButton extends StatelessWidget{
  FloatingButton(this.tabController);

  TabController tabController;

  @override
  Widget build(BuildContext context) {
    if(tabController.index==1||tabController.index==3) {
      return new FloatingActionButton(
        tooltip: Strings.add, // used by assistive technologies
        child: new Icon(Icons.add),
        onPressed: () {
          switch(tabController.index){
            case 1:
              Navigator.of(context).pushNamed('/evento');
              break;
            case 3:
              Navigator.of(context).pushNamed('/group');
              break;
          }
        },
      );
    }else
      return new Container();
  }
}

class _Choice {
  const _Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

List<_Choice> choices = <_Choice>[
  new _Choice(title: Strings.myEnrolls, icon: Icons.group_work),
  new _Choice(title: Strings.myDrafts, icon: Icons.event),
  new _Choice(title: Strings.myFavorites, icon: Icons.star),
  new _Choice(title: Strings.myGroups, icon: Icons.group),
  new _Choice(title: Strings.friends, icon: Icons.contacts),
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