import 'dart:math';

import 'package:flutter/material.dart';

import 'package:timer_clock/egg_timer.dart';
import 'package:timer_clock/egg_timer_control.dart';
import 'package:timer_clock/egg_timer_dial.dart';
import 'package:timer_clock/egg_timer_display.dart';

Color GRADIENT_TOP = Colors.red;
Color GRADIENT_BOTTOM = Colors.green;
// final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
// final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  AnimationController selectionTimeSlideController;
  TextEditingController _controllerTime = TextEditingController();
  int durationTime = 5;

  final Random _random = Random();

  Color _color = GRADIENT_BOTTOM;
  Color _color2 = GRADIENT_TOP;

  void changeColor() {
    setState(() {
      GRADIENT_TOP = Color.fromARGB(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
      );
      GRADIENT_BOTTOM = Color.fromARGB(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    selectionTimeSlideController = new AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 150,
      ),
    )..addListener(() {
        setState(() {});
      });

    selectionTimeSlideController.value = 400;
  }

  @override
  void dispose() {
    selectionTimeSlideController.dispose();
    super.dispose();
  }

  EggTimer eggTimer;
  _onItemSelected(Duration newTime) {
    setState(() => eggTimer.currentTime = newTime);
  }

  _onDialStopTurning(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
      eggTimer.resume();
    });
  }

  _onTimerUpdate() {
    setState(() {});
  }

  _MyAppState() {
    eggTimer = EggTimer(
      // ! Use this to control the numbers of minutes on the timer (DYNAMCIALLY)
      maxTime: Duration(minutes: durationTime),
      onTimerUpdate: _onTimerUpdate,
    );
  }
  @override
  Widget build(BuildContext context) {
    if (eggTimer.state == EggTimerState.ready) {
      selectionTimeSlideController.reverse();
    } else {
      selectionTimeSlideController.forward();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timer App',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SafeArea(
                      child: EggTimerTimeDisplay(
                        selectionTime: eggTimer.lastStartTime,
                        countDownTime: eggTimer.currentTime,
                        eggTimerState: eggTimer.state,
                      ),
                    ),
                    EggTimerDial(
                      eggTimerState: eggTimer.state,
                      currentTime: eggTimer.currentTime,
                      maxTime: Duration(minutes: durationTime),
                      tickPerSection: 5,
                      onTimeSelected: _onItemSelected,
                      onDialStopTurning: _onDialStopTurning,
                    ),
                    EggTimerControl(
                      eggTimerState: eggTimer.state,
                      onPause: () {
                        setState(() => eggTimer.pause());
                      },
                      onResume: () {
                        setState(() => eggTimer.resume());
                      },
                      onReset: () {
                        setState(() => eggTimer.reset());
                      },
                      onRestart: () {
                        setState(() => eggTimer.restart());
                      },
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          0.0, 400 * selectionTimeSlideController.value, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _controllerTime,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              onFieldSubmitted: (value) {
                                setState(() {
                                  durationTime = int.parse(value);
                                  print(durationTime);
                                });
                              },
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                labelText: 'Change Clock minutes',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 2,
                            color: Colors.black,
                            height: 40,
                          ),
                          FlatButton(
                            onPressed: changeColor,
                            splashColor: _color,
                            child: Container(
                              color: _color == _color
                                  ? Colors.transparent
                                  : _color,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Text(
                                  'Change theme'.toUpperCase(),
                                  style: TextStyle(
                                    color: _color2 == _color
                                        ? Colors.black
                                        : Colors.black,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
