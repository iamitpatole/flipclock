import 'package:flutter/foundation.dart';

import '../services/clock_service.dart';

class ClockProvider extends ChangeNotifier {
  ClockProvider(this._clockService) {
    _clockService.start(_handleTick);
  }

  final ClockService _clockService;
  DateTime _now = DateTime.now();

  DateTime get now => _now;

  void _handleTick(DateTime now) {
    _now = now;
    notifyListeners();
  }

  @override
  void dispose() {
    _clockService.stop();
    super.dispose();
  }
}
