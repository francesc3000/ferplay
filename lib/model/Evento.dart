import 'package:ferplay/config/Strings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Evento{

  String _hobby;
  String _name;
  String _description;
  DateTime _fromDate = new DateTime.now();
  TimeOfDay _fromTime = new TimeOfDay.now();
  DateTime _toDate = new DateTime.now();
  TimeOfDay _toTime = new TimeOfDay.now();

  final eventoBD = FirebaseDatabase.instance.reference().child(Strings.eventoBD);


  //Getter and Setters
  TimeOfDay get toTime => _toTime;

  set toTime(TimeOfDay value) {
    _toTime = value;
  }

  DateTime get toDate => _toDate;

  set toDate(DateTime value) {
    _toDate = value;
  }

  TimeOfDay get fromTime => _fromTime;

  set fromTime(TimeOfDay value) {
    _fromTime = value;
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

  bool save(){
    eventoBD.push().set({
      'hobby': this.hobby,
      'name': this.name,
      'description': this.description,
    });
    return true;
  }


}