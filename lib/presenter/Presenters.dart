import 'dart:async';

import 'package:ferplay/model/User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

abstract class EventoAnimatedListPresenter{
  void addFavoriteEvento(String eventoId,String hobby,String name,String fromDate,String toDate);
  void removeFavoriteEvento(String eventoId,String hobby,String name,String fromDate,String toDate);
}

abstract class HomePresenter implements EventoAnimatedListPresenter{
  Query getHomeListQuery();
  User getCurrentUser();
  Future<Null> onInitLoggedIn();
  Future<Null> ensureLoggedIn();
  void signOut();
}

abstract class EventoPresenter implements EventoAnimatedListPresenter{
  void save(String hobby, String name, String description, DateTime _fromDate, TimeOfDay _fromTime);
}

abstract class DashboardPresenter implements EventoAnimatedListPresenter{
  Future<Null> getFavoriteEventos();

}