
import 'package:ferplay/component/ComponentsInterfaces.dart';
import 'package:ferplay/component/EventoAnimatedList.dart';
import 'package:ferplay/component/EventoComponent.dart';
import 'package:ferplay/component/LogInFacebookComponent.dart';
import 'package:ferplay/config/Strings.dart';
import 'package:ferplay/component/HomeComponent.dart';
import 'package:ferplay/presenter/Presenters.dart';
import 'package:ferplay/presenter/PresentersImpl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

DashboardPresenter _dashboardPresenter;

class DashBoardComponent extends StatefulWidget{
  DashBoardComponent({Key key, this.drawerList}) : super(key: key);

  final Widget drawerList;

  @override
  _DashBoardComponent createState() => new _DashBoardComponent(drawerList);

}

class _DashBoardComponent extends State<DashBoardComponent>
    with SingleTickerProviderStateMixin
    implements DashboardView{

  _DashBoardComponent(this.drawerList);

  final Widget drawerList;
  TabBarView tabBarView;

  TabController _tabController = null;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: choices.length);
    _tabController.addListener(_handleTabSelection);
    _dashboardPresenter = new DashboardPresenterImpl(this);
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
    tabBarView = new TabBarView(
      controller: _tabController,
      children: choices.map((_Choice choice) {
        return new Padding(
          padding: const EdgeInsets.all(16.0),
          child: new ChoiceCard(choice: choice, tabController: _tabController),
        );
      }).toList(),
    );
    return new MaterialApp(
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      routes: <String, WidgetBuilder>{
        //'/evento': (BuildContext context) => new EventoComponent(),
        '/login': (BuildContext context) => new LogInFacebookComponent(),
      },
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
          body: tabBarView,
          floatingActionButton: new FloatingButton(_tabController),
        ),
      ),
    );
  }

  @override
  addEvento2List(String eventoId, String name, String description, bool isFavorite) {
    this.tabBarView.children[_tabController.index];
  }

  @override
  removeEventoFromList(String eventoId) {
    // TODO: implement removeEventoFromList
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
              //Navigator.of(context).pushNamed('/evento');
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return new EventoComponent();
                  },
                  fullscreenDialog: true
              ));
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
  new _Choice(title: Strings.myFavorites, icon: Icons.favorite),
  new _Choice(title: Strings.myGroups, icon: Icons.group),
  new _Choice(title: Strings.friends, icon: Icons.contacts),
];

class ChoiceCard extends StatelessWidget {
  ChoiceCard({ Key key, this.choice, this.tabController }) : super(key: key);

  final _Choice choice;
  final TabController tabController;
  var _background;

  @override
  Widget build(BuildContext context) {
    _background = _determineBackground(context, tabController);
    return new Card(
      color: Colors.white,
      child: new Center(
        child: _background,
      ),
    );
  }

  Widget _determineBackground(BuildContext context, TabController tabController) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;

    switch(tabController.index) {
      case 2:
        return new EventoAnimatedList(presenter: _dashboardPresenter);
        break;

      default:
        return new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(choice.icon, size: 128.0, color: textStyle.color),
            new Text(choice.title, style: textStyle),
          ],
        );
    }
  }

}