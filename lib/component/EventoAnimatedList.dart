/*
import 'package:ferplay/dao/EventoDao.dart';
import 'package:ferplay/model/Injector.dart';
import 'package:ferplay/presenter/Presenters.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class EventoAnimatedList extends StatelessWidget{

  final Query query;
  final EventoAnimatedListPresenter presenter;

  EventoAnimatedList({Key key,@required this.query, @required this.presenter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
  return new Column(children: <Widget>[
    new Flexible(
      child: new FirebaseAnimatedList(
      query: this.query,
      sort: (a, b) => b.key.compareTo(a.key),
      padding: new EdgeInsets.all(8.0),
      //reverse: true,
      itemBuilder:
      (_, DataSnapshot snapshot, Animation<double> animation) {
        return new EventoRow(snapshot, animation, presenter);
      },
      ),
    ) /*,
              new Divider(height: 1.0),
              new Container(
                decoration:
                new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),*/
      ]);
  }
}

class EventoRow extends StatefulWidget {
  EventoRow(DataSnapshot snapshot, Animation<double> animation, EventoAnimatedListPresenter presenter){
    this._snapshot = snapshot;
    this._animation = animation;
    this._presenter = presenter;
  }
  DataSnapshot _snapshot;
  Animation<double> _animation;
  EventoAnimatedListPresenter _presenter;

  @override
  _EventoRow createState() => new _EventoRow(_snapshot, _animation, _presenter);

}

class _EventoRow extends State<EventoRow>{
  _EventoRow(DataSnapshot snapshot, Animation<double> animation, EventoAnimatedListPresenter presenter){
    this._snapshot = snapshot;
    this._animation = animation;
    this._favoriteIcon = init_favorite(_snapshot.value[EventoDao.favoriteUsers]);
    this._presenter = presenter;

  }
  DataSnapshot _snapshot;
  Animation _animation;
  var _favoriteIcon = null;
  EventoAnimatedListPresenter _presenter;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: new Card(
        child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: const Icon(Icons.device_hub),
                title: new Text(_snapshot.value[EventoDao.name]),
                subtitle: new Text(_snapshot.value[EventoDao.description]),
              ),
              new Container(
                  alignment: Alignment.bottomRight,
                  child:
                  new IconButton(icon: _favoriteIcon , onPressed: (){
                    setState((){
                      if(_favoriteIcon.icon==Icons.favorite_border) {
                        _favoriteIcon = new Icon(Icons.favorite);
                        _presenter.addFavoriteEvento(_snapshot.key);
                      }
                      else {
                        _favoriteIcon = new Icon(Icons.favorite_border);
                        _presenter.removeFavoriteEvento(_snapshot.key);
                      }
                    });
                  })
              )
              /*
              new ButtonTheme.bar( // make buttons use the appropriate styles for cards
                child: new ButtonBar(
                  children: <Widget>[
                    new FlatButton(
                      child: const Text('BUY TICKETS'),
                      onPressed: () { /* ... */ },
                    ),
                    new FlatButton(
                      child: const Text('LISTEN'),
                      onPressed: () { /* ... */ },
                    ),
                  ],
                ),
              ),*/
            ]
        ),
      ),
      onTap: (){},
    );
  }

  Widget init_favorite(Map<String,bool> favoritesUsers){
    Widget icon=null;
    bool isFavorite=false;

    if(Injector.currentUser!=null)
      if(favoritesUsers!=null)
        for(var entry in favoritesUsers.entries)
          if(entry.key == Injector.currentUser.key&&entry.value == true)
            isFavorite = true;

    if(isFavorite)
      icon = new Icon(Icons.favorite);
    else
      icon = new Icon(Icons.favorite_border);

    return icon;
  }
}
*/

import 'package:ferplay/component/ComponentsInterfaces.dart';
import 'package:ferplay/presenter/Presenters.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class EventoAnimatedList extends StatefulWidget {
  final EventoAnimatedListPresenter presenter;

  EventoAnimatedList({Key key, @required this.presenter})
      : super(key: key);

  @override
  _EventoAnimatedList createState() => new _EventoAnimatedList(presenter);
}

class _EventoAnimatedList extends State<EventoAnimatedList>
    implements EventoAnimatedListView {
  final EventoAnimatedListPresenter presenter;

  _EventoAnimatedList(@required this.presenter);

  final GlobalKey<_EventoAnimatedList> _listKey =
      new GlobalKey<_EventoAnimatedList>();
  List<Widget> _eventoList;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    if(_eventoList[index]==null)
      return new Container();

    return _eventoList[index];
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedList(
      key: _listKey,
      initialItemCount: 0,
      itemBuilder: _buildItem,
    );
  }

  @override
  addEvento2List(String eventoId, String name, String description, bool isFavorite) {
    Widget cardItem = new CardItem(eventoId, name, description, isFavorite, null, presenter);
    this._eventoList.add(cardItem);
  }

  @override
  removeEventoFromList(String eventoId) {
    // TODO: implement removeEventoFromList
  }
}

class CardItem extends StatefulWidget {
  CardItem(@required String uId, @required String name, @required String description,
           @required isFavorite,
      Animation<double> animation, EventoAnimatedListPresenter presenter){
    this._uId = uId;
    this._name = name;
    this._description = description;
    this._isFavorite = isFavorite;
    this._animation = animation;
    this._presenter = presenter;
  }
  String _uId;
  String _name;
  String _description;
  bool _isFavorite;
  Animation<double> _animation;
  EventoAnimatedListPresenter _presenter;

  @override
  _CardItem createState() => new _CardItem(_uId, _name, _description, _isFavorite,
      _animation, _presenter);

}

class _CardItem extends State<CardItem>{
  _CardItem(String uId, String name, String description, bool isFavorite,
      Animation<double> animation, EventoAnimatedListPresenter presenter){
    this._uId = uId;
    this._name = name;
    this._description = description;
    this._isFavorite = isFavorite;
    this._animation = animation;
    this._favoriteIcon = init_favorite(_isFavorite);
    this._presenter = presenter;

  }
  String _uId;
  String _name;
  String _description;
  bool _isFavorite;
  Animation _animation;
  var _favoriteIcon = null;
  EventoAnimatedListPresenter _presenter;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: new Card(
        child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: const Icon(Icons.device_hub),
                title: new Text(_name),
                subtitle: new Text(_description),
              ),
              new Container(
                  alignment: Alignment.bottomRight,
                  child:
                  new IconButton(icon: _favoriteIcon , onPressed: (){
                    setState((){
                      if(_favoriteIcon.icon==Icons.favorite_border) {
                        _favoriteIcon = new Icon(Icons.favorite);
                        _presenter.addFavoriteEvento(_uId);
                      }
                      else {
                        _favoriteIcon = new Icon(Icons.favorite_border);
                        _presenter.removeFavoriteEvento(_uId);
                      }
                    });
                  })
              )
            ]
        ),
      ),
      onTap: (){},
    );
  }

  Widget init_favorite(bool isFavorite){
    Widget icon=null;

    if(isFavorite)
      icon = new Icon(Icons.favorite);
    else
      icon = new Icon(Icons.favorite_border);

    return icon;
  }
}
