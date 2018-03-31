import 'dart:async';

import 'package:ferplay/component/ComponentsInterfaces.dart';
import 'package:ferplay/config/Strings.dart';
import 'package:ferplay/component/HomeComponent.dart';
import 'package:ferplay/presenter/Presenters.dart';
import 'package:ferplay/presenter/PresentersImpl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

EventoPresenter _eventoPresenter;

class EventoComponent extends StatefulWidget implements EventoView{
  EventoComponent(){
    _eventoPresenter = new EventoPresenterImpl(this);
  }

  @override
  _EventoComponent createState() => new _EventoComponent();

}

class _EventoComponent extends State<EventoComponent> {
  final TextEditingController _controllerName = new TextEditingController();
  final TextEditingController _controllerDescription = new TextEditingController();
  String _hobby;
  DateTime _fromDate = new DateTime.now();
  TimeOfDay _fromTime = new TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text(Strings.EventoTitle),
            actions: [
              new FlatButton(
                  onPressed: () {
                    _eventoPresenter.save(_hobby,_controllerName.text,_controllerDescription.text,
                    _fromDate,_fromTime);

                    Navigator.of(context).pop();
                  },
                  child: new Text('GUARDAR',
                      style: Theme
                          .of(context)
                          .textTheme
                          .subhead
                          .copyWith(color: Colors.white))),
            ],
          ),
          body: new ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return new Form(
                  child: new Column(children: <Widget>[
                    new DropdownButton<String>(
                      value: _hobby,
                      hint: const Text("FerPlay"),
                      onChanged: (String newValue) {
                        setState(() {
                          _hobby = newValue;
                        });
                      },
                      items:
                      <String>['Padel', 'Futbol', 'Basquet', 'Tenis'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    new TextField(
                        controller: _controllerName,
                        decoration: new InputDecoration(
                          hintText: 'Nombre del evento',
                        )),
                    new TextField(
                      controller: _controllerDescription,
                      decoration: new InputDecoration(
                        hintText: 'Descripción',
                      ),
                      maxLines: 6,
                    ),
                    new _DateTimePicker(
                      labelText: "Fecha",
                      selectedDate: _fromDate,
                      selectedTime: _fromTime,
                      selectDate: (DateTime date) {
                        setState(() {
                          _fromDate = date;
                        });
                      },
                      selectTime: (TimeOfDay time) {
                        setState(() {
                          _fromTime = time;
                        });
                      },
                    ),getMap(context),
                  ]));
            },
          )
      ),
    );
  }

  Widget getMap(BuildContext context) {
    return new FlutterMap(
      options: new MapOptions(
        center: new LatLng(51.5, -0.09),
        zoom: 13.0,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': 'pk.eyJ1IjoiZnJhbmNlc2MzMDAwIiwiYSI6ImNqZmNtMHFtZDFsb2QzM29mcWlvd2pnM3AifQ.CM-fMJyuDzlSITFi9LqTSQ',
            'id': 'mapbox.streets',
          },
        ),
        new MarkerLayerOptions(
          markers: [
            new Marker(
              width: 80.0,
              height: 80.0,
              point: new LatLng(51.5, -0.09),
              builder: (ctx) =>
              new Container(
                child: new FlutterLogo(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(2015, 8),
        lastDate: new DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            labelText: labelText,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        new Expanded(
          flex: 3,
          child: new _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
