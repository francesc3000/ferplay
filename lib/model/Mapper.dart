import 'package:ferplay/dao/EventoDao.dart';
import 'package:ferplay/model/Evento.dart';
import 'package:firebase_database/firebase_database.dart';

class Mapper{
  static Evento snapshot2Evento(DataSnapshot snapshot){
    Evento evento = new Evento(snapshot.key,snapshot.value["ownerId"],snapshot.value["hobby"],
                              snapshot.value["name"],snapshot.value["description"]);

    evento.favoriteUsers = snapshot.value[EventoDao.favoriteUsers];
    return evento;
  }
}