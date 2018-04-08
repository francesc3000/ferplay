import 'dart:async';
import 'dart:collection';

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

    /*
    try {
      await Injector.userRepository.orderByChild(UserDao.email)
          .equalTo(user.email)
          .reference()
          .once()
          .then(
          (DataSnapshot snapshot) {
        DataSnapshot userSnapshot = snapshot;
        if (userSnapshot == null || userSnapshot.value == null) {
          userRet = new User(user.email, user.displayName, user.photoUrl);
          _setUser(userRet);
        } else {
          String email = userSnapshot.value[UserDao.email];
          String fullname = userSnapshot.value[UserDao.fullname];
          String photoUrl = userSnapshot.value[UserDao.photoUrl];
          userRet = new User(email, fullname, photoUrl);
          _loadFavorites(userRet.key);
        }
      }, onError: (Object o) {
        print(o.toString());
      });
    } catch (e) {
      print(e.toString());
    }
    */

    try {
      Injector.userRepository.orderByChild(UserDao.email)
          .equalTo(user.email)
          .onChildAdded
          .listen((Event event){
            DataSnapshot userSnapshot = event.snapshot;
            String email = userSnapshot.value[UserDao.email];
            String fullname = userSnapshot.value[UserDao.fullname];
            String photoUrl = userSnapshot.value[UserDao.photoUrl];
            userRet = new User(userSnapshot.key,email, fullname, photoUrl);
            //_loadFavorites(userRet.key);
          }, onError: (Object o) {
        print(o.toString());
      });
    } catch (e) {
      print(e.toString());
    }

    if (userRet == null) {
      userRet = new User(null,user.email, user.displayName, user.photoUrl);
      _setUser(userRet);
    }

    return userRet;
  }

  void _setUser(User user){
    Injector.userRepository.push().set(user.toJson());
  }

  _loadFavorites(String userId) {
    Map<String, bool> favoritesIdList = new HashMap();
    Injector.favoriteRepository.child(userId).onValue.first.then((Event event) {
      favoritesIdList.addAll(event.snapshot.value[UserDao.favoritesEventos]);
    });

    Injector.currentUser.favoritesEventos = favoritesIdList;
  }
}
