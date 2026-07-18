import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ScreenService {
  Future<void> apply({
    required bool keepScreenAwake,
    required bool fullscreen,
  }) async {
    await WakelockPlus.toggle(enable: keepScreenAwake);
    if (fullscreen) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }
}
