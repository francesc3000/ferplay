import 'dart:async';

import 'package:ferplay/component/HomeComponent.dart';
import 'package:ferplay/config/Strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LogInFacebookComponent extends StatefulWidget {
  @override
  _LogInFacebookComponent createState() => new _LogInFacebookComponent();
}

class _LogInFacebookComponent extends State<LogInFacebookComponent> {
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  static final auth = FirebaseAuth.instance;

  String _message = 'Log in/out by pressing the buttons below.';

  Future<Null> _login() async {
    //facebookSignIn.loginBehavior = FacebookLoginBehavior.nativeOnly;
    final FacebookLoginResult result =
        await facebookSignIn.logInWithReadPermissions(['email','public_profile','user_friends']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        _showMessage('''
         Logged in!
         
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');

        final FirebaseUser facebookUser=
          await auth.signInWithFacebook(accessToken: accessToken.token);
        print(facebookUser.photoUrl);

        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  Future<Null> _logOut() async {
    await facebookSignIn.logOut();
    _showMessage('Logged out.');
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(Strings.LogInScreen),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(_message),
              new RaisedButton(
                onPressed: _login,
                child: new Text('Log in'),
              ),
              new RaisedButton(
                onPressed: _logOut,
                child: new Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
