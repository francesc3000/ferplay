import 'package:ferplay/config/Strings.dart';
import 'package:ferplay/model/User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Flavor {
  DEV,
  PRO
}

/// Simple DI
class Injector {
  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;
  static User _currentUser;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  static DatabaseReference get _rootRepository{
    switch(_flavor) {
      case Flavor.DEV:
        return FirebaseDatabase.instance.reference();//.child("DEV").reference();
      default: // Flavor.PRO:
        return FirebaseDatabase.instance.reference();//.child("PRO").reference();
    }
  }

  static DatabaseReference get eventoRepository {
    return _rootRepository.child(Strings.eventosBD);
  }

  static DatabaseReference get userRepository {
    return _rootRepository.child(Strings.usersBD);
  }

  static DatabaseReference get eventoWhiteListRepository {
    return _rootRepository.child(Strings.eventosWhiteListBD).reference();
  }

  static DatabaseReference get eventoThumb {
    return _rootRepository.child(Strings.eventosThumbBD).reference();
  }

  static DatabaseReference get favoriteRepository {
    return _rootRepository.child(Strings.eventosFavoritesBD).reference();
  }

  static User get currentUser => _currentUser;

  static set currentUser(User value) {
    _currentUser = value;
  }
}