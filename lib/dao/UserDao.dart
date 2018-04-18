import 'dart:async';
import 'dart:collection';

import 'package:ferplay/model/EventoThumb.dart';
import 'package:ferplay/model/Injector.dart';
import 'package:ferplay/model/User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserDao {
  static const String email = "email";
  static const String fullname = "fullname";
  static const String photoUrl = "photoUrl";
  static const String favoritesEventos = "favoritesEventos";

  Future<User> getUser(GoogleSignInAccount user) async {
    User userRet = null;

    try{
      Injector.userRepository.orderByChild(UserDao.email)
          .equalTo(user.email)
          .once()
          .then((snapshot) {
            if (snapshot == null || snapshot.value == null) {
              userRet = new User(null,user.email, user.displayName, user.photoUrl);
              _setUser(userRet);
            } else{
              /*
              Map<String, Map> second = snapshot.value;
              for(MapEntry<String,Map> secondEntry in second.entries) {
                String key = secondEntry.key;
                String email;
                String fullname;
                String photoUrl;
                Map<String,Map> third = secondEntry.value;
                for(MapEntry<String,Map> thirdEntry in third.entries){
                  switch(thirdEntry.key){
                    case UserDao.email:
                      email = thirdEntry.value.toString();
                      break;
                    case UserDao.fullname:
                      fullname = thirdEntry.value.toString();
                      break;
                    case UserDao.photoUrl:
                      photoUrl = thirdEntry.value.toString();
                      break;
                  }
                }
                userRet = new User(key, email, fullname, photoUrl);
                userRet.favoritesEventos.addAll(_loadFavorites(userRet.key));
                Injector.currentUser = userRet;
              }
              */
              //DataSnapshot second = snapshot.value;
              String uid;
              String email;
              String fullname;
              String photoUrl;
              Map<dynamic,dynamic> second = snapshot.value;
              second.forEach((key,value){
                uid = key;
                Map<dynamic,dynamic> third = value;
                third.forEach((key,value){
                  switch(key){
                    case UserDao.email:
                      email = value.toString();
                      break;
                    case UserDao.fullname:
                      fullname = value.toString();
                      break;
                    case UserDao.photoUrl:
                      photoUrl = value.toString();
                      break;
                  }
                });
              });
              userRet = new User(uid, email, fullname, photoUrl);
              Injector.currentUser = userRet;
              _loadFavorites(userRet.key);
            }
      }, onError: (Object o) {
        print(o.toString());
      });
    } catch (e) {
      print(e.toString());
    }

    return userRet;
  }

  void _setUser(User user){
    Injector.userRepository.push().set(user.toJson());
    Injector.currentUser = user;
  }

  Future<void> _loadFavorites(String userId) async {
    List<String> favoritesList = new List<String>();
    try {
      Injector.favoriteRepository
          .child(userId)
          .onValue
          .listen((Event event) {
        if (event.snapshot != null && event.snapshot.value != null) {
          /*
          Map<String, Map> second = event.snapshot.value;
          for(MapEntry<String,Map> secondEntry in second.entries)
            favoritesList.add(secondEntry.key);
            */
          Map<dynamic, dynamic> second = event.snapshot.value;
          second.forEach((key, value) {
            favoritesList.add(key);
          });

          Injector.currentUser.favoritesEventos.addAll(favoritesList);
        }
      }, onError: (Object o) {
        print(o.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
