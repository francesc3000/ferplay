import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'dart:ui';

import 'package:ferplay/component/DashboardComponent.dart';
import 'package:ferplay/config/Strings.dart';
import 'package:ferplay/component/EventoComponent.dart';
import 'package:ferplay/component/LogInFacebookComponent.dart';
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

final googleSignIn = new GoogleSignIn();
final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;
final eventoBD = FirebaseDatabase.instance.reference().child(Strings.eventoBD);
final _drawerList = new DrawerList();

Future<Null> _ensureLoggedIn() async {
  print("Dentro de ensure loggin");

  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null) user = await googleSignIn.signInSilently();
  if (user == null) {
    user = await googleSignIn.signIn();
    analytics.logLogin();
  }
  if (await auth.currentUser() == null) {
    GoogleSignInAuthentication credentials =
        await googleSignIn.currentUser.authentication;

    await auth.signInWithGoogle(
      idToken: credentials.idToken,
      accessToken: credentials.accessToken,
    );
  }
}

class HomeComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: Strings.projectTitle,
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new HomeScreen(title: Strings.projectTitle),
      routes: <String, WidgetBuilder>{
        '/evento': (BuildContext context) => new EventoComponent(),
        '/login': (BuildContext context) => new LogInFacebookComponent(),
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

class _HomeScreenState extends State<HomeScreen> {
  List widgets = [];
  /*
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 100; i++) {
      widgets.add(getRow(i));
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(Strings.projectTitle),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        drawer: _drawerList, //new DrawerDemo(),
        body: new Column(children: <Widget>[
          new Flexible(
            child: new FirebaseAnimatedList(
              query: eventoBD,
              sort: (a, b) => b.key.compareTo(a.key),
              padding: new EdgeInsets.all(8.0),
              //reverse: true,
              itemBuilder:
                  (_, DataSnapshot snapshot, Animation<double> animation) {
                return new EventoRow(snapshot: snapshot, animation: animation);
              },
            ),
          ) /*,
          new Divider(height: 1.0),
          new Container(
            decoration:
            new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),*/
        ]));
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
    if (googleSignIn.currentUser != null) {
      return new DrawerHeader(

        child: new GestureDetector(
          onTap: () async {
              Navigator.of(context).pushNamed('/dashboard');
          },
          child: new Column(children: <Widget>[
            new CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: new NetworkImage(googleSignIn.currentUser.photoUrl)),
            new Text(googleSignIn.currentUser.displayName)
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
              await _ensureLoggedIn();
              if (googleSignIn.currentUser != null)
                Navigator.of(context).pushNamed('/dashboard');
            }),
        new Text("Registrarse")
      ]));
    }
  }
}

class EventoRow extends StatelessWidget {
  EventoRow({this.snapshot, this.animation});
  final DataSnapshot snapshot;
  final Animation animation;

  @override
  Widget build(BuildContext context) {
    return new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            //margin: const EdgeInsets.only(right: 16.0),
            child: new Text(snapshot.value['name']),
          ),
        ]);
  }
}

//-----------------------------------------------------------//
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
