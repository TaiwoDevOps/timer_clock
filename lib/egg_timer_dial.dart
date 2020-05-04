import 'package:flutter/material.dart';
import 'package:timer_clock/dial_gesture_detector.dart';
import 'package:timer_clock/egg_timer.dart';
import 'package:timer_clock/egg_timer_knob.dart';
import 'package:timer_clock/main.dart';
import 'package:timer_clock/utilities/custom_painter_utils.dart';

class EggTimerDial extends StatefulWidget {
  final EggTimerState eggTimerState;
  final Duration currentTime;
  final Duration maxTime;
  final int tickPerSection;
  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;

  EggTimerDial({
    Key key,
    this.eggTimerState,
    this.currentTime = const Duration(minutes: 0),
    this.maxTime = const Duration(minutes: 35),
    this.tickPerSection = 5,
    this.onTimeSelected,
    this.onDialStopTurning,
  }) : super(key: key);

  @override
  _EggTimerDialState createState() => _EggTimerDialState();
}

class _EggTimerDialState extends State<EggTimerDial>
    with TickerProviderStateMixin {
  static const RESET_SPEED_PER_SECONDS = 4.0;
  EggTimerState prevEggTimerState;
  double prevRotationPercent = 0.0;
  AnimationController resetToZeroController;
  Animation ressetingAnimation;

  @override
  initState() {
    resetToZeroController = new AnimationController(vsync: this);
    super.initState();
  }

  @override
  dispose() {
    resetToZeroController.dispose();
    super.dispose();
  }

  _rotationPercent() {
    return widget.currentTime.inSeconds / widget.maxTime.inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentTime.inSeconds == 0 &&
        prevEggTimerState != EggTimerState.ready) {
      ressetingAnimation = new Tween(begin: prevRotationPercent, end: 0.0)
          .animate(resetToZeroController)
            ..addListener(() => setState(() {}))
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                setState(() => ressetingAnimation = null);
              }
            });

      resetToZeroController.duration = new Duration(
        milliseconds:
            ((prevRotationPercent / RESET_SPEED_PER_SECONDS) * 1000).round(),
      );
      resetToZeroController.forward(from: 0.0);
    }

    prevEggTimerState = widget.eggTimerState;
    prevRotationPercent = _rotationPercent();
    return DialTurnGestureDetector(
      currentTime: widget.currentTime,
      maxTime: widget.maxTime,
      onTimeSelected: widget.onTimeSelected,
      onDialStopTurning: widget.onDialStopTurning,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            left: 45.5,
            right: 45.5,
          ),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1.0,
                      blurRadius: 2.0,
                      offset: Offset(0.0, 1.0),
                    )
                  ]),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(55.5),
                    child: CustomPaint(
                      painter: TickPainter(
                        tickCount: widget.maxTime.inMinutes,
                        tickPerSection: widget.tickPerSection,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(65.0),
                    child: EggTimerDialKnob(
                      rotationPercent: ressetingAnimation == null
                          ? _rotationPercent()
                          : ressetingAnimation.value,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
