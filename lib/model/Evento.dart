import 'dart:collection';

import 'package:ferplay/config/Strings.dart';
import 'package:ferplay/dao/EventoDao.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Evento{

  Evento(String key,String ownerId ,String hobby, String name, String description){
    this._key = key;
    this._ownerId = ownerId;
    this._hobby = hobby;
    this._name = name;
    this._description = description;
  }

  String _key;
  String _ownerId;
  String _hobby;
  String _name;
  String _description;
  Map<String,bool> _favoriteUsers = new HashMap();
  DateTime _fromDate = new DateTime.now();
  DateTime _toDate = new DateTime.now();

  //Getter and Setters
  String get ownerId => _ownerId;

  String get key => _key;

  TimeOfDay get toTime => new TimeOfDay(hour:_toDate.hour,minute:_toDate.minute);

  set toTime(TimeOfDay value) {
    _toDate = new DateTime(_toDate.year,_toDate.month,_toDate.day,
                              value.hour,value.minute,0,0,0);
  }

  DateTime get toDate => _toDate;

  set toDate(DateTime value) {
    _toDate = value;
  }

  TimeOfDay get fromTime => new TimeOfDay(hour:_fromDate.hour,minute:_fromDate.minute);

  set fromTime(TimeOfDay value) {
    _fromDate = new DateTime(_fromDate.year,_fromDate.month,_fromDate.day,
        value.hour,value.minute,0,0,0);
  }

  DateTime get fromDate => _fromDate;

  set fromDate(DateTime value) {
    _fromDate = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get hobby => _hobby;

  set hobby(String value) {
    _hobby = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }


  Map<String, bool> get favoriteUsers => _favoriteUsers;

  set favoriteUsers(Map<String, bool> value) {
    if(value!=null)
      _favoriteUsers.addAll(value);
  }

  void addUserAsFavorite(String key) {
    if(!this._favoriteUsers.putIfAbsent(key,()=>true))
      this._favoriteUsers.update(key, (bool)=>true);
  }

  void removeUserAsFavorite(String key) {
    this._favoriteUsers.update(key, (bool)=>false);
  }

  toJson(){
    return {
      EventoDao.ownerId: this.ownerId,
      EventoDao.hobby: this.hobby,
      EventoDao.name: this.name,
      EventoDao.description: this.description,
      EventoDao.fromDate: this._fromDate.millisecondsSinceEpoch, //timestamp
      EventoDao.toDate: this._toDate.millisecondsSinceEpoch,
      EventoDao.favoriteUsers: this.favoriteUsers
    };
  }
}