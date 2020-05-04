import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttery_dart2/gestures.dart';

class DialTurnGestureDetector extends StatefulWidget {
  final currentTime;
  final maxTime;
  final Widget child;
  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;

  DialTurnGestureDetector({
    this.child,
    this.currentTime,
    this.maxTime,
    this.onTimeSelected,
    this.onDialStopTurning,
  });

  @override
  _DialTurnGestureDetectorState createState() =>
      _DialTurnGestureDetectorState();
}

class _DialTurnGestureDetectorState extends State<DialTurnGestureDetector> {
  PolarCoord startDragCoord;
  Duration startDragTime;
  Duration selectedTime;

  _onRadialDragStart(PolarCoord coord) {
    startDragCoord = coord;
    startDragTime = widget.currentTime;
  }

  _onRadialDragUpdate(PolarCoord coord) {
    if (startDragCoord != null) {
      var angleDiff = coord.angle - startDragCoord.angle;

      angleDiff = angleDiff >= 0 ? angleDiff : angleDiff + (2 * pi);
      final anglePercent = angleDiff / (2 * pi);
      final timeDiffInSeconds =
          (anglePercent * widget.maxTime.inSeconds).round();
      selectedTime =
          new Duration(seconds: startDragTime.inSeconds + timeDiffInSeconds);

      print('The time at this point ${selectedTime.inMinutes}');

      widget.onTimeSelected(selectedTime);
    }
  }

  _onRadialDragEnd() {
    widget.onDialStopTurning(selectedTime);

    selectedTime = null;
    startDragTime = null;
    startDragCoord = null;
  }

  @override
  Widget build(BuildContext context) {
    return RadialDragGestureDetector(
      onRadialDragStart: _onRadialDragStart,
      onRadialDragUpdate: _onRadialDragUpdate,
      onRadialDragEnd: _onRadialDragEnd,
      child: widget.child,
    );
  }
}
