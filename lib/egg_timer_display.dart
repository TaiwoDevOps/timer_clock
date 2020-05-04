import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intll;
import 'package:timer_clock/egg_timer.dart';

class EggTimerTimeDisplay extends StatefulWidget {
  final eggTimerState;
  final selectionTime;
  final countDownTime;
  EggTimerTimeDisplay({
    this.eggTimerState,
    this.selectionTime = const Duration(
      seconds: 0,
    ),
    this.countDownTime = const Duration(
      seconds: 0,
    ),
    Key key,
  }) : super(key: key);

  @override
  _EggTimerTimeDisplayState createState() => _EggTimerTimeDisplayState();
}

class _EggTimerTimeDisplayState extends State<EggTimerTimeDisplay>
    with TickerProviderStateMixin {
  final intll.DateFormat selectionTimeFormat = new intll.DateFormat('mm');
  final intll.DateFormat countDownTimeFormat = new intll.DateFormat('mm:ss');
  AnimationController selectionTimeSlideController;
  AnimationController countDownTimeSlideController;

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

    countDownTimeSlideController = new AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 150,
      ),
    )..addListener(() {
        setState(() {});
      });

    countDownTimeSlideController.value = 1.0;
  }

  @override
  void dispose() {
    selectionTimeSlideController.dispose();
    countDownTimeSlideController.dispose();
    super.dispose();
  }

  get formattedSelectionTime {
    DateTime dateTime = new DateTime(
        new DateTime.now().year, 0, 0, 0, 0, widget.selectionTime.inSeconds);
    return selectionTimeFormat.format(dateTime);
  }

  get formattedCountDownTime {
    DateTime dateTime = new DateTime(
        new DateTime.now().year, 0, 0, 0, 0, widget.countDownTime.inSeconds);
    return countDownTimeFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.eggTimerState == EggTimerState.ready) {
      selectionTimeSlideController.reverse();
      countDownTimeSlideController.forward();
    } else {
      selectionTimeSlideController.forward();
      countDownTimeSlideController.reverse();
    }
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
              0.0, -400 * selectionTimeSlideController.value, 0.0),
          child: Text(
            formattedSelectionTime,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 140.0,
              letterSpacing: 4.0,
              fontWeight: FontWeight.bold,
              // height: 0.5,
            ),
          ),
        ),
        Opacity(
          opacity: 1.0 - countDownTimeSlideController.value,
          child: Text(
            formattedCountDownTime,
            textAlign: TextAlign.center,
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.black,
              fontSize: 140.0,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
