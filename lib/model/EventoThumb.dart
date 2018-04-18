import 'dart:collection';

import 'package:ferplay/dao/EventoDao.dart';
import 'package:flutter/material.dart';

class EventoThumb{
  EventoThumb(String key,String hobby, String name){
    this._key = key;
    this._hobby = hobby;
    this._name = name;
  }

  String _key;
  String _hobby;
  String _name;
  DateTime _fromDate = new DateTime.now();
  DateTime _toDate = new DateTime.now();

  //Getter and Setters
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

  toJson(){
    return {
      EventoDao.hobby: this.hobby,
      EventoDao.name: this.name,
      EventoDao.fromDate: this._fromDate.millisecondsSinceEpoch.toString(), //timestamp
      EventoDao.toDate: this._toDate.millisecondsSinceEpoch.toString()
    };
  }
}