import 'dart:collection';

import 'package:ferplay/config/Strings.dart';
import 'package:ferplay/dao/EventoDao.dart';
import 'package:ferplay/model/EventoThumb.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Evento extends EventoThumb{

  Evento(String key, String hobby, String name, String description) : super(key, hobby, name){
    this._description = description;
  }

  String _description;

  //Getter and Setters
  String get description => _description;

  set description(String value) {
    _description = value;
  }

  @override
  toJson(){
    return {
      EventoDao.hobby: this.hobby,
      EventoDao.name: this.name,
      EventoDao.description: this.description,
      EventoDao.fromDate: this.fromDate.millisecondsSinceEpoch.toString(), //timestamp
      EventoDao.toDate: this.toDate.millisecondsSinceEpoch.toString()
    };
  }
}