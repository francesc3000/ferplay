import 'package:ferplay/presenter/Presenters.dart';

abstract class HomeView{
  onInitLoggedInComplete();
}

abstract class EventoView{
}

abstract class DashboardView implements EventoAnimatedListView{

}

abstract class EventoAnimatedListView{
  addEvento2List(String eventoId, String name, String description, bool isFavorite);
  removeEventoFromList(String eventoId);
}