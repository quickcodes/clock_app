import 'package:clock_app/main.dart';
import 'package:clock_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'dart:async'; // To use Timer

class BatteryStatusWidget extends StatefulWidget {
  const BatteryStatusWidget({super.key});

  @override
  State<BatteryStatusWidget> createState() => _BatteryStatusWidgetState();
}

class _BatteryStatusWidgetState extends State<BatteryStatusWidget> {
  final Battery _battery = Battery();
  int _batteryPercentage = 0; // To store the battery percentage
  String _batteryStatus =
      'Unknown'; // To store the battery status (Low, Medium, High)
  String _chargingStatus = 'Not Charging'; // To store charging state
  Color _statusColor = Colors.grey;
  bool isBatteryAvailable = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initBatteryStatus();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop the periodic battery check when widget is disposed
    super.dispose();
  }

  // Fetch the battery percentage and status from the device
  void _initBatteryStatus() async {
    if (!isBatteryAvailable) return;
    try {
      int batteryLevel = await _battery.batteryLevel;
      if (!mounted) return;
      setState(() {
        _batteryPercentage = batteryLevel;
        _batteryStatus = _getBatteryStatus(batteryLevel);
        _statusColor = _getStatusColor(_batteryStatus);
      });
      _startPeriodicUpdates();
      _listenToBatteryStateChanges();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isBatteryAvailable = false;
      });
    }
  }

  // Update battery percentage periodically every 5 seconds
  void _startPeriodicUpdates() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (!isBatteryAvailable) return;
      if (!(context.mounted && mounted)) return;
      int batteryLevel = await _battery.batteryLevel;
      _listenToBatteryStateChanges();
      if (context.mounted && mounted) {
        setState(() {
          _batteryPercentage = batteryLevel;
          _batteryStatus = _getBatteryStatus(batteryLevel);
          _statusColor = _getStatusColor(_batteryStatus);
        });
      }
    });
  }

  // Listen to battery state changes (Charging, Full, Discharging)
  void _listenToBatteryStateChanges() async {
    // if (context.mounted && mounted) {
    if (!isBatteryAvailable) return;
    BatteryState state = await _battery.batteryState;
    if (!mounted) return;
    setState(() {
      switch (state) {
        case BatteryState.charging:
          _chargingStatus = 'Charging';
          break;
        case BatteryState.discharging:
          _chargingStatus = 'Discharging';
          break;
        case BatteryState.full:
          _chargingStatus = 'Full';
          break;
        default:
          _chargingStatus = 'Unknown';
          break;
      }
    });

    // }
  }

  // Get battery status text (Low, Medium, High)
  String _getBatteryStatus(int percentage) {
    if (percentage <= 20) {
      return 'Low';
    } else if (percentage > 20 && percentage <= 80) {
      return 'Medium';
    } else {
      return 'High';
    }
  }

  // Get the color based on battery status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Low':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Get battery state emoji (⚡ for charging, 🔋 for low, 🟢 for full)
  String _getBatteryEmoji() {
    if (_chargingStatus == 'Charging') {
      return '⚡'; // Charging emoji
    } else if (_chargingStatus == 'Full') {
      return '🟢'; // Full battery emoji
    } else {
      return '🔋'; // Low or medium battery emoji
    }
  }

  @override
  Widget build(BuildContext context) {
    double dynamicHeight = MediaQuery.of(context).size.height;

    return !isBatteryAvailable
        ? SizedBox.shrink()
        : Padding(
            padding:
                EdgeInsets.only(bottom: isPortrait ? 0 : sizeByHeight(0.02)),
            child: AnimatedContainer(
              duration: animationDuration,
              curve: animationCurve,
              padding: EdgeInsets.symmetric(
                  vertical: dynamicHeight * 0.02,
                  horizontal: dynamicHeight * 0.02),
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(dynamicHeight * 0.015),
                  // border: Border.all(
                  //     color: _statusColor.withValues(alpha: darkMode ? 0.5 : 1),
                  //     width: 0.5),
                  ),
              child: TweenAnimationBuilder<double>(
                  duration: animationDuration,
                  curve: animationCurve,
                  tween: Tween(
                    begin: darkMode ? 1 : 0.5,
                    end: darkMode ? 0.5 : 1,
                  ),
                  builder: (context, animationAlpha, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Custom Battery Icon
                        _buildBatteryIcon(),
                        SizedBox(width: dynamicHeight * 0.03),
                        Text(
                          '$_batteryPercentage%',
                          style: TextStyle(
                            fontSize:
                                dynamicHeight * 0.055, // Dynamic text size
                            fontWeight: FontWeight.w400,
                            color:
                                _statusColor.withValues(alpha: animationAlpha),
                          ),
                        ),
                        SizedBox(width: dynamicHeight * 0.01),
                        Text(
                          _getBatteryEmoji(),
                          style: TextStyle(
                            fontSize: dynamicHeight * 0.05, // Emoji size
                            color:
                                _statusColor.withValues(alpha: animationAlpha),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          );
  }

  // Custom Battery Icon to represent battery level
  Widget _buildBatteryIcon() {
    double batteryWidth = dynamicHeight * 0.09;
    double batteryHeight = dynamicHeight * 0.035;
    double fillWidth = (batteryWidth * _batteryPercentage) / 100;

    return AnimatedContainer(
      duration: animationDuration,
      curve: animationCurve,
      width: batteryWidth,
      height: batteryHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        border: Border.all(
            color: _statusColor.withValues(alpha: darkMode ? 0.5 : 1),
            width: 1),
      ),
      child: Stack(
        children: [
          // Battery background (empty)
          AnimatedContainer(
            duration: animationDuration,
            curve: animationCurve,
            width: batteryWidth,
            height: batteryHeight,
            color: darkMode
                ? Colors.transparent
                : Colors.grey[700]?.withValues(
                    alpha: 0.0), // Background color (empty battery)
          ),
          // Battery fill (proportional to the battery percentage)
          AnimatedContainer(
            duration: animationDuration,
            curve: animationCurve,
            width: fillWidth,
            height: batteryHeight,
            color: _statusColor.withValues(
                alpha: darkMode ? 0.3 : 1), // Color based on battery status
          ),
        ],
      ),
    );
  }
}
