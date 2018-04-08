import 'dart:collection';

import 'package:ferplay/dao/UserDao.dart';

class User{

  User(String key, String email, String fullname, String photoUrl){
    this._key = key;
    this._email = email;
    this._fullname = fullname;
    this._photoUrl = photoUrl;
    this._favoritesEventos = new HashMap();
  }

  String _key;
  String _email;
  String _fullname;
  String _photoUrl;
  Map<String,bool> _favoritesEventos;

  String get key => _key;

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get fullname => _fullname;

  set fullname(String value) {
    _fullname = value;
  }


  String get photoUrl => _photoUrl;

  set photoUrl(String value) {
    _photoUrl = value;
  }


  Map<String, bool> get favoritesEventos => _favoritesEventos;

  set favoritesEventos(Map<String, bool> value) {
    _favoritesEventos.addAll(value);
  }

  toJson(){
    return {
      UserDao.email: this.email,
      UserDao.fullname: this.fullname,
      UserDao.photoUrl: this.photoUrl
    };
  }
}