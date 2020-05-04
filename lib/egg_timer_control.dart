import 'package:flutter/material.dart';
import 'package:timer_clock/egg_timer.dart';
import 'package:timer_clock/egg_timer_control_widget.dart';

class EggTimerControl extends StatefulWidget {
  final eggTimerState;
  final Function onPause;
  final Function onRestart;
  final Function onReset;
  final Function onResume;

  EggTimerControl({
    this.eggTimerState,
    this.onPause,
    this.onReset,
    this.onRestart,
    this.onResume,
  });

  @override
  _EggTimerControlState createState() => _EggTimerControlState();
}

class _EggTimerControlState extends State<EggTimerControl>
    with TickerProviderStateMixin {
  AnimationController pauseResumeSlideController;
  AnimationController restartResetFadeController;

  @override
  void initState() {
    super.initState();
    pauseResumeSlideController = new AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 150,
      ),
    )..addListener(() {
        setState(() {});
      });
    pauseResumeSlideController.value = 1.0;

    restartResetFadeController = new AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 150,
      ),
    )..addListener(() {
        setState(() {});
      });

    restartResetFadeController.value = 1.0;
  }

  @override
  void dispose() {
    pauseResumeSlideController.dispose();
    restartResetFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.eggTimerState) {
      case EggTimerState.ready:
        pauseResumeSlideController.forward();
        restartResetFadeController.forward();
        break;
      case EggTimerState.running:
        pauseResumeSlideController.reverse();
        restartResetFadeController.forward();
        break;

      case EggTimerState.paused:
        pauseResumeSlideController.reverse();
        restartResetFadeController.reverse();
        break;
    }
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 7),
      child: Column(
        children: <Widget>[
          Opacity(
            opacity: 1.0 - restartResetFadeController.value,
            child: Row(
              children: <Widget>[
                ControlButton(
                  icon: Icons.refresh,
                  buttonName: 'RESTART',
                  onPress: widget.onRestart,
                ),
                Expanded(
                  child: Container(),
                ),
                ControlButton(
                  icon: Icons.arrow_back,
                  buttonName: 'RESET',
                  onPress: widget.onReset,
                ),
              ],
            ),
          ),
          Transform(
            transform: Matrix4.translationValues(
              0.0,
              400 * pauseResumeSlideController.value,
              0.0,
            ),
            child: ControlButton(
              icon: widget.eggTimerState == EggTimerState.running
                  ? Icons.pause
                  : Icons.play_arrow,
              buttonName: widget.eggTimerState == EggTimerState.running
                  ? 'PAUSE'
                  : 'RESUME',
              onPress: widget.eggTimerState == EggTimerState.running
                  ? widget.onPause
                  : widget.onResume,
            ),
          ),
        ],
      ),
    );
  }
}
