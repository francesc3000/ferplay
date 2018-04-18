import 'dart:collection';

import 'package:ferplay/dao/UserDao.dart';
import 'package:ferplay/model/EventoThumb.dart';

class User{

  User(String key, String email, String fullname, String photoUrl){
    this._key = key;
    this._email = email;
    this._fullname = fullname;
    this._photoUrl = photoUrl;
    this._favoritesEventos = new List<String>();
  }

  String _key;
  String _email;
  String _fullname;
  String _photoUrl;
  List _favoritesEventos;

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


  List<String> get favoritesEventos => _favoritesEventos;

  set favoritesEventos(List<String> value) {
    _favoritesEventos.addAll(value);
  }

  toJson(){
    return {
      UserDao.email: this.email,
      UserDao.fullname: this.fullname,
      UserDao.photoUrl: this.photoUrl
    };
  }

  bool isEventoFavorite(String eventoId) {
    return favoritesEventos.contains(eventoId);
  }
}