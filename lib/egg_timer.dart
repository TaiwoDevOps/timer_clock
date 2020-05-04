import 'dart:async';

class EggTimer {
  final Duration maxTime;
  final Function
      onTimerUpdate; //! use this to notify any other class listening for the changes in the properties of this class
  Stopwatch stopwatch = new Stopwatch();
  Duration _currentTime = const Duration(seconds: 0);
  Duration lastStartTime = const Duration(seconds: 0);
  EggTimerState state = EggTimerState.ready;

  EggTimer({
    this.maxTime,
    this.onTimerUpdate,
  });

  get currentTime {
    return _currentTime;
  }

  set currentTime(newTime) {
    if (state == EggTimerState.ready) {
      _currentTime = newTime;
      lastStartTime = currentTime;
    }
  }

  resume() {
    if (state != EggTimerState.running) {
      if (state == EggTimerState.ready) {
        _currentTime = _roundToNearestMinute(_currentTime);
        lastStartTime = currentTime;
      }
      state = EggTimerState.running;

      stopwatch.start();

      _tick();
    }
  }

  _roundToNearestMinute(duration) {
    return Duration(minutes: (duration.inSeconds / 60).round());
  }

  pause() {
    if (state == EggTimerState.running) {
      state = EggTimerState.paused;
      stopwatch.stop();

      if (null != onTimerUpdate) {
        onTimerUpdate();
      }
    }
  }

  reset() {
    if (state == EggTimerState.paused) {
      state = EggTimerState.ready;
      _currentTime = const Duration(seconds: 0);
      lastStartTime = _currentTime;

      stopwatch.reset();

      if (null != onTimerUpdate) {
        onTimerUpdate();
      }
    }
  }

  restart() {
    if (state == EggTimerState.paused) {
      state = EggTimerState.running;
      _currentTime = lastStartTime;
      stopwatch.reset();
      stopwatch.start();

      _tick();
    }
  }

  _tick() {
    _currentTime = lastStartTime - stopwatch.elapsed;

    if (_currentTime.inSeconds > 0) {
      new Timer(const Duration(seconds: 1),
          _tick); // this will call back itself as long as the condition is true
    } else {
      state = EggTimerState.ready;
    }

    if (null != onTimerUpdate) {
      onTimerUpdate();
    }
  }
}

enum EggTimerState {
  ready,
  running,
  paused,
}
