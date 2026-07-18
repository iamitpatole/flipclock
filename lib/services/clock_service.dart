import 'dart:async';

class ClockService {
  Timer? _timer;

  void start(void Function(DateTime now) onTick) {
    stop();
    void scheduleNext() {
      final now = DateTime.now();
      onTick(now);
      final nextSecond = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
        now.second + 1,
      );
      _timer = Timer(nextSecond.difference(now), scheduleNext);
    }

    scheduleNext();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
