import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xffB6C3EF),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Color(0xff15338D),
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

class HomePage extends StatefulWidget {
  const HomePage(this.model);

  final ClockModel model;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();

      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final second = DateFormat('ss').format(_dateTime);
    final fontSize = 75.0;

    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'Crystal',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(2, 0),
        ),
      ],
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              color: colors[_Element.background],
            ),
          ),
          Positioned(
            top: 20,
            left: 50,
            child: SizedBox(
              width: 100,
              height: 100,
              child: FlareActor(
                "assets/weather_icons_fork.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: colors == _lightTheme
                    ? 'light_${widget.model.weatherString}'
                    : 'dark_${widget.model.weatherString}',
              ),
            ),
          ),
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/clock_back.svg',
            ),
          ),
          Positioned(
            top: 30,
            right: 15,
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/sticky_note.svg',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 40.0, bottom: 50.0, right: 40.0, left: 30.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '${widget.model.location}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'IndieFlower',
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          Text(
                            '${widget.model.temperatureString}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'IndieFlower',
                                fontSize: 35,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 5,
            right: MediaQuery.of(context).size.width / 4,
            bottom: 70,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 4),
                      color: Colors.black45,
                      blurRadius: 4.0),
                ],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: colors[_Element.background],
                  border: Border.all(width: 10, color: Color(0xffDADADA)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DefaultTextStyle(
                  style: defaultStyle,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        hour + ' : ' + minute,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(second, style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
