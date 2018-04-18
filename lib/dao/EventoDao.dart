import 'package:ferplay/model/Evento.dart';
import 'package:ferplay/model/EventoThumb.dart';
import 'package:ferplay/model/Injector.dart';
import 'package:firebase_database/firebase_database.dart';

class EventoDao{
  static const hobby = "hobby";
  static const name = "name";
  static const description = "description";
  static const fromDate = "fromDate";
  static const toDate = "toDate";
  static const favoriteUsers = "favoriteUsers";

  DatabaseReference _getEventoDB() {
    return Injector.eventoRepository;
  }

  DatabaseReference _getEventoWhiteList(){
    return Injector.eventoWhiteListRepository;
  }

  DatabaseReference _getEventoThumb(){
    return Injector.eventoThumb;
  }

  bool saveEvento(Evento evento) {
    try {
      if(evento.key == null)
        _getEventoDB().push().set(evento.toJson());
      else
        _getEventoDB().child(evento.key).set(evento.toJson());

      //Se propagan los cambios a sus dependecias
      Injector.eventoRepository
          .onChildAdded
          .listen((Event event){
        DataSnapshot eventoSnapshot = event.snapshot;

        String key = eventoSnapshot.key;
        EventoThumb eventoThumb =
          new EventoThumb(key,
                          eventoSnapshot.value[EventoDao.hobby],
                          eventoSnapshot.value[EventoDao.name]);

        eventoThumb.fromDate = new DateTime
            .fromMillisecondsSinceEpoch(int.parse(eventoSnapshot.value[EventoDao.fromDate]));
        eventoThumb.toDate = new DateTime
            .fromMillisecondsSinceEpoch(int.parse(eventoSnapshot.value[EventoDao.toDate]));

        _getEventoWhiteList().child(key).set({
          Injector.currentUser.key: "true"
        });

        _getEventoThumb().child(key).set(
          eventoThumb.toJson()
        );

      }, onError: (Object o) {
        print(o.toString());
        return false;
      });
    } catch (e) {
      print(e.toString());
      return false;
    }

    return true;
  }

  Query getHomeList() {
    return _getEventoThumb();
  }
}