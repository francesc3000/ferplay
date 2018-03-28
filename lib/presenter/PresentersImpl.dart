import 'dart:async';

import 'package:ferplay/component/ComponentsInterfaces.dart';
import 'package:ferplay/dao/EventoDao.dart';
import 'package:ferplay/dao/UserDao.dart';
import 'package:ferplay/model/Evento.dart';
import 'package:ferplay/model/Injector.dart';
import 'package:ferplay/model/Mapper.dart';
import 'package:ferplay/model/User.dart';
import 'package:ferplay/presenter/Presenters.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePresenterImpl implements HomePresenter {

  final HomeView _view;
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = new GoogleSignIn();
  final _analytics = new FirebaseAnalytics();
  final UserDao _userDao = new UserDao();
  final EventoDao _eventoDao = new EventoDao();

  HomePresenterImpl(this._view);

  @override
  void addFavoriteEvento(String eventoId) {
    _addFavoriteEvento(eventoId);
  }

  @override
  void removeFavoriteEvento(String eventoId) {
    _removeFavoriteEvento(eventoId);
  }

  Future<User> _getUserFromBD(GoogleSignInAccount user) async {
    if(user!=null)
      return await _userDao.getUser(user);

    return null;
  }

  @override
  Query getHomeListQuery() {
    return _eventoDao.getDB();
  }

  @override
  Future<Null> onInitLoggedIn() async {
    print("Dentro de init loggin");
    GoogleSignInAccount user = _googleSignIn.currentUser;
    if (user == null) user = await _googleSignIn.signInSilently();

    Injector.currentUser = await _getUserFromBD(user);

    _view.onInitLoggedInComplete();
  }

  @override
  Future<Null> ensureLoggedIn() async {
    print("Dentro de ensure loggin");

    GoogleSignInAccount user = await _googleSignIn.signIn();
    _analytics.logLogin();
    if (await _auth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
      await _googleSignIn.currentUser.authentication;

      await _auth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
    }
    if(user!=null)
      Injector.currentUser = await _getUserFromBD(user);
  }

  @override
  User getCurrentUser() {
    return Injector.currentUser;
  }

  @override
  void signOut() {
    _googleSignIn.signOut();
  }

}

class EventoPresenterImpl implements EventoPresenter{

  final EventoView eventoView;
  final EventoDao _eventoDao = new EventoDao();

  EventoPresenterImpl(this.eventoView);

  @override
  void save(String hobby, String name, String description, DateTime _fromDate, TimeOfDay _fromTime) {
    Evento _evento = new Evento(null,Injector.currentUser.key, hobby,name,description);

    _evento.fromDate = _fromDate;
    _evento.fromTime = _fromTime;

    _saveEvento(_evento);
  }

  @override
  void addFavoriteEvento(String eventoId) {
    _addFavoriteEvento(eventoId);
  }

  @override
  void removeFavoriteEvento(String eventoId) {
    _removeFavoriteEvento(eventoId);
  }

  bool _saveEvento(Evento evento){
    if(evento.key == null)
      _eventoDao.getDB().push().set(evento.toJson());
    else
      _eventoDao.getDB().child(evento.key).set(evento.toJson());

    return true;
  }
}

class DashboardPresenterImpl implements DashboardPresenter{
  final DashboardView dashboardView;
  final EventoDao _eventoDao = new EventoDao();

  DashboardPresenterImpl(this.dashboardView);

  @override
  void addFavoriteEvento(String eventoId) {
    _addFavoriteEvento(eventoId);
  }

  @override
  void removeFavoriteEvento(String eventoId) {
    _removeFavoriteEvento(eventoId);
  }

  @override
  Future<Null> getFavoriteEventos()async {
    await Injector.favoriteRepository
        .child(Injector.currentUser.key)
        .onValue
        .forEach((Event event)async {
      Map<String,bool> favorites = event.snapshot.value[UserDao.favoritesEventos];

      for(MapEntry<String,bool> favorite in favorites.entries){
        if(favorite.value){
          await Injector.eventoRepository.child(favorite.key)
              .onValue.first.then((Event event){
            String eventoId = event.snapshot.key;
            String name = event.snapshot.value[EventoDao.name];
            String description = event.snapshot.value[EventoDao.description];

            this.dashboardView.addEvento2List(eventoId, name, description, true);
          });
        }
      }
    });
  }
}

void _addFavoriteEvento(String eventoId) {
  var favoritesEventos = Injector.currentUser.favoritesEventos;
  if(!favoritesEventos.putIfAbsent(eventoId, ()=>true))
    favoritesEventos.update(eventoId, (bool)=>true);

  Injector.favoriteRepository.child(Injector.currentUser.key)
      .child(UserDao.favoritesEventos).set(favoritesEventos);
}

void _removeFavoriteEvento(String eventoId) {
  var favoritesEventos = Injector.currentUser.favoritesEventos;
  if(!favoritesEventos.putIfAbsent(eventoId, ()=>true))
    favoritesEventos.update(eventoId, (bool)=>true);

  Injector.favoriteRepository.child(Injector.currentUser.key)
      .child(UserDao.favoritesEventos).set(favoritesEventos);
}

