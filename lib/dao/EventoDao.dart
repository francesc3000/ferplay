import 'package:ferplay/model/Injector.dart';
import 'package:firebase_database/firebase_database.dart';

class EventoDao{
  static const ownerId = "ownerId";
  static const hobby = "hobby";
  static const name = "name";
  static const description = "description";
  static const fromDate = "fromDate";
  static const toDate = "toDate";
  static const favoriteUsers = "favoriteUsers";

  DatabaseReference getDB() {
    return Injector.eventoRepository;
  }
}