import 'dart:async';

import 'package:ferplay/config/Strings.dart';
import 'package:ferplay/component/HomeComponent.dart';
import 'package:ferplay/model/Evento.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';


class EventoComponent extends StatefulWidget {
  @override
  _EventoComponent createState() => new _EventoComponent();
}

class _EventoComponent extends State<EventoComponent> {
  final TextEditingController _controllerName = new TextEditingController();
  final TextEditingController _controllerDescription = new TextEditingController();
  Evento _evento = new Evento();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text(Strings.EventoTitle),
          ),
          body: new Form(
              child: new Column(children: <Widget>[
            new DropdownButton<String>(
                value: _evento.hobby,
                hint: const Text("FerPlay"),
                onChanged: (String newValue) {
                  setState(() {
                    _evento.hobby = newValue;
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
              selectedDate: _evento.fromDate,
              selectedTime: _evento.fromTime,
              selectDate: (DateTime date) {
                setState(() {
                  _evento.fromDate = date;
                });
              },
              selectTime: (TimeOfDay time) {
                setState(() {
                  _evento.fromTime = time;
                });
              },
            ),
            new RaisedButton(
              child: new Text("Guardar"),
              onPressed: () {
                _evento.name = _controllerName.text;
                _evento.description = _controllerDescription.text;

                _evento.save();
              },
            )
          ]))),
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
