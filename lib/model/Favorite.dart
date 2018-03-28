import 'dart:collection';

import 'package:ferplay/dao/EventoDao.dart';
import 'package:ferplay/dao/UserDao.dart';
import 'package:meta/meta.dart';

class favorite{
  String _userId;
  Map<String,bool> _eventoIdList = new HashMap();

  favorite(@required this._userId);

  void enable(String eventoId){
    this._eventoIdList.putIfAbsent(eventoId, ()=>true);
  }

  toJson(){
    return {
      "userId": this._userId,
      "eventoIdList": this._eventoIdList
    };
  }
}