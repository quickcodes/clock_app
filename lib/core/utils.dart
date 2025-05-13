import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'constants.dart';

double sizeByHeight(double val) => dynamicHeight * val;
double sizeByWidth(double val) => dynamicWidth * val;

class AppUtils {
  static disableScreenFromBeingLock() {
    WakelockPlus.enable();
  }

  static hideSystemNotificationAndNavigationBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      // SystemUiOverlay.bottom, // Keep Bottom Navigation Bar
      // SystemUiOverlay.top,    // Keep Notification Panel
    ]);
  }
}
