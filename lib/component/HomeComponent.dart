import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'dart:ui';

import 'package:ferplay/component/ComponentsInterfaces.dart';
import 'package:ferplay/component/DashboardComponent.dart';
import 'package:ferplay/component/EventoAnimatedList.dart';
import 'package:ferplay/config/Strings.dart';
import 'package:ferplay/component/EventoComponent.dart';
import 'package:ferplay/component/LogInFacebookComponent.dart';
import 'package:ferplay/model/Injector.dart';
import 'package:ferplay/model/User.dart';
import 'package:ferplay/presenter/Presenters.dart';
import 'package:ferplay/presenter/PresentersImpl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.green,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.green,
  accentColor: Colors.orangeAccent[400],
);

final _drawerList = new DrawerList();
HomePresenter _homePresenter;

class HomeComponent extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: Strings.projectTitle,
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new HomeScreen(title: Strings.projectTitle),
      routes: <String, WidgetBuilder>{
        '/dashboard': (BuildContext context) => new DashBoardComponent(drawerList: _drawerList,),
        //'/screen2' : (BuildContext context) => new Screen2()
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeView{
  bool _IsSignInSilently=false;

  _HomeScreenState() {
    _homePresenter = new HomePresenterImpl(this);
  }

  @override
  void initState() {
    super.initState();

    _IsSignInSilently = true;
    _homePresenter.onInitLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    List<BottomNavigationBarItem> items = new List();
    BottomNavigationBarItem home =
      new BottomNavigationBarItem(icon: const Icon(Icons.home, color: Colors.black), title: const Text(""));
    BottomNavigationBarItem favorite =
    new BottomNavigationBarItem(icon: const Icon(Icons.favorite, color: Colors.black), title: const Text(""));
    BottomNavigationBarItem add =
    new BottomNavigationBarItem(icon: const Icon(Icons.add_circle, color: Colors.black), title: const Text(""));
    BottomNavigationBarItem messenger =
    new BottomNavigationBarItem(icon: const Icon(Icons.message, color: Colors.black), title: const Text(""));
    BottomNavigationBarItem account =
    new BottomNavigationBarItem(icon: const Icon(Icons.account_circle, color: Colors.black), title: const Text(""));

    items.add(home);
    items.add(favorite);
    items.add(add);
    items.add(messenger);
    items.add(account);

    BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
      items: items,
      type: BottomNavigationBarType.shifting,
      currentIndex: 2,
      onTap: (int index){
        switch(index){
          case 0:
            break;
          case 1:
            break;
          case 2:
          case 3:
          case 4:
            print(index);
        }
      },
    );

    if(_IsSignInSilently) {
      widget = new Scaffold(
          appBar: new AppBar(
            title: new Text(Strings.projectTitle),
            elevation:
            Theme
                .of(context)
                .platform == TargetPlatform.iOS ? 0.0 : 4.0,
          ),
          body: new Center(
            child: new Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: new CircularProgressIndicator()
            )
        ),
      );
    }else {
      widget = new Scaffold(
          appBar: new AppBar(
            title: new Text(Strings.projectTitle),
            elevation:
            Theme
                .of(context)
                .platform == TargetPlatform.iOS ? 0.0 : 4.0,
          ),
          drawer: _drawerList, //new DrawerDemo(),
          bottomNavigationBar: bottomNavigationBar,
          body: new FirebaseAnimatedList(
            query: _homePresenter.getHomeListQuery(),
            padding: new EdgeInsets.all(8.0),
            reverse: false,

            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              return new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new ListTile(
                    leading: const Icon(Icons.event),
                    title: new Text(snapshot.value["hobby"])
                  ),
                  new IconCardButton(snapshot.key,snapshot.value["hobby"],
                  snapshot.value["name"],snapshot.value["fromDate"],snapshot.value["toDate"])
                ],
              );
            },
          ),
      );
    }

    return widget;
  }

  @override
  onInitLoggedInComplete() {
    setState(() {
      _IsSignInSilently = false;
    });
  }
}

class IconCardButton extends StatefulWidget{
  String eventoId;
  String hobby;
  String name;
  String fromDate;
  String toDate;
  IconCardButton(this.eventoId,this.hobby,this.name,this.fromDate,this.toDate);

  @override
  _IconCardButton createState() => new _IconCardButton(this.eventoId,this.hobby,this.name,this.fromDate,this.toDate);
}

class _IconCardButton extends State<IconCardButton>{

  String eventoId;
  String hobby;
  String name;
  String fromDate;
  String toDate;
  Icon _favoriteIcon;

  _IconCardButton(this.eventoId,this.hobby,this.name,this.fromDate,this.toDate);

  @override
  Widget build(BuildContext context) {
    if(Injector.currentUser!=null&&Injector.currentUser.isEventoFavorite(eventoId))
      _favoriteIcon = const Icon(Icons.favorite);
    else
      _favoriteIcon = const Icon(Icons.favorite_border);

    return new Container(
      alignment: Alignment.bottomRight,
      child: new IconButton(icon: _favoriteIcon,
          onPressed: (){
        if(Injector.currentUser==null)
          _homePresenter.ensureLoggedIn();

        if(Injector.currentUser!=null) {
          setState(() {
            if (_favoriteIcon.icon == Icons.favorite_border)
              _homePresenter.addFavoriteEvento(
                  this.eventoId, this.hobby, this.name, this.fromDate,
                  this.toDate);
            else
              _homePresenter.removeFavoriteEvento(
                  this.eventoId, this.hobby, this.name, this.fromDate,
                  this.toDate);
          });
        }
      }),
    );
  }
}

class DrawerList extends StatefulWidget {
  @override
  _DrawerList createState() => new _DrawerList();
}

class _DrawerList extends State<DrawerList> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(
      children: <Widget>[
        new _DrawerHeader(),
        new ListTile(
          title: new Text(Strings.firstMenu),
          onTap: () {},
        ),
        /*
            new ListTile(
              title: new Text('Second Menu Item'),
              onTap: () {},
            ),*/
        new Divider(),
        new ListTile(
          title: new Text(Strings.about),
          onTap: () {},
        ),
      ],
    ));
  }
}

class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (_homePresenter.getCurrentUser() != null) {
      return new DrawerHeader(

        child: new GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/dashboard');
          },
          child: new Column(children: <Widget>[
            new CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: new NetworkImage(_homePresenter.getCurrentUser().photoUrl)),
            new Text(_homePresenter.getCurrentUser().fullname),
            new FlatButton(onPressed: (){_homePresenter.signOut();},
                child: new Text("Salir"))
          ]),
        )
      );
    /*
          child: new GestureDetector(
            onTap: () async {
              Navigator.of(context).pushNamed('/dashboard');
            },
            child:         new UserAccountsDrawerHeader(
              decoration: new BoxDecoration(
                color: Colors.white
              ),
              accountName: new Text(googleSignIn.currentUser.displayName),
              accountEmail: new Text(googleSignIn.currentUser.email),
              currentAccountPicture: new CircleAvatar(
                  //backgroundColor: Colors.black,
                  backgroundImage:
                  new NetworkImage(googleSignIn.currentUser.photoUrl)),
              onDetailsPressed: (){

          },
            ),
          )
      );
      */
    } else {
      return new DrawerHeader(
          child: new Column(children: <Widget>[
        new IconButton(
            icon: new Icon(Icons.account_circle),
            onPressed: () async {
              await _homePresenter.ensureLoggedIn();
              if (_homePresenter.getCurrentUser() != null)
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/dashboard');
            }),
        new Text("Registrarse")
      ]));
    }
  }
}

//-----------------------------------------------------------//
/*
@override
class ChatMessage extends StatelessWidget {
  ChatMessage({this.snapshot, this.animation});
  final DataSnapshot snapshot;
  final Animation animation;

  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                  backgroundImage:
                      new NetworkImage(snapshot.value['senderPhotoUrl'])),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(snapshot.value['senderName'],
                      style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: snapshot.value['imageUrl'] != null
                        ? new Image.network(
                            snapshot.value['imageUrl'],
                            width: 250.0,
                          )
                        : new Text(snapshot.value['text']),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Friendlychat"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: new Column(children: <Widget>[
          new Flexible(
            child: new FirebaseAnimatedList(
              query: eventoBD,
              sort: (a, b) => b.key.compareTo(a.key),
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder:
                  (_, DataSnapshot snapshot, Animation<double> animation) {
                return new ChatMessage(
                    snapshot: snapshot, animation: animation);
              },
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ]));
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(children: <Widget>[
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.photo_camera),
                  onPressed: () async {
                    await _ensureLoggedIn();
                    File imageFile = await ImagePicker.pickImage();
                    int random = new Random().nextInt(100000);
                    StorageReference ref = FirebaseStorage.instance
                        .ref()
                        .child("image_$random.jpg");
                    StorageUploadTask uploadTask = ref.put(imageFile);
                    Uri downloadUrl = (await uploadTask.future).downloadUrl;
                    _sendMessage(imageUrl: downloadUrl.toString());
                  }),
            ),
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? new CupertinoButton(
                        child: new Text("Send"),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )
                    : new IconButton(
                        icon: new Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )),
          ]),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border:
                      new Border(top: new BorderSide(color: Colors.grey[200])))
              : null),
    );
  }

  Future<Null> _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    await _ensureLoggedIn();
    _sendMessage(text: text);
  }

  void _sendMessage({String text, String imageUrl}) {
    eventoBD.push().set({
      'text': text,
      'imageUrl': imageUrl,
      'senderName': googleSignIn.currentUser.displayName,
      'senderPhotoUrl': googleSignIn.currentUser.photoUrl,
    });
    analytics.logEvent(name: 'send_message');
  }
}
*/
