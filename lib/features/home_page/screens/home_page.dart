import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flip_board/flip_widget.dart';
import 'package:clock_app/core/utils.dart';
import 'package:clock_app/main.dart';
import 'package:clock_app/features/home_page/widgets/progress_indicator_widgets.dart';
import 'package:clock_app/features/home_page/widgets/color_scheme_switcher_widget.dart';
import 'package:clock_app/features/home_page/widgets/day_night_mode_switch_widget.dart';
import '../widgets/battery_status_widget.dart';
import '../widgets/network_info_widget.dart';

part 'home_page_ext.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Time-based streams
  late Stream<int> _secondStream;
  late Stream<int> _minuteStream;
  late Stream<int> _hourStream;
  late Stream<String> _amPMStream;
  late Stream<String> _dateStream;

  // Animation controller
  late AnimationController _controller;

  final Duration updateDuration = Duration(milliseconds: 100);

  @override
  void initState() {
    super.initState();
    AppUtils.disableScreenFromBeingLock();

    // Initialize time streams
    _hourStream = Stream.periodic(updateDuration, (_) {
      AppUtils.hideSystemNotificationAndNavigationBar();
      return int.tryParse(DateFormat('hh').format(DateTime.now())) ?? 12;
    }).asBroadcastStream();

    _amPMStream = Stream.periodic(
            updateDuration, (_) => DateFormat('a').format(DateTime.now()))
        .asBroadcastStream();
    _minuteStream =
        Stream.periodic(updateDuration, (_) => DateTime.now().minute)
            .asBroadcastStream();
    _secondStream =
        Stream.periodic(updateDuration, (_) => DateTime.now().second)
            .asBroadcastStream();
    _dateStream = Stream.periodic(
        updateDuration,
        (_) => DateFormat('EEE dd MMM yyyy')
            .format(DateTime.now())
            .toUpperCase()).asBroadcastStream();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: timerDurationInSeconds.toInt()),
      value: DateTime.now().second / timerDurationInSeconds,
    )
      ..addListener(() {
        if (mounted) setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _controller.repeat();
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool showMenu = false;

  @override
  Widget build(BuildContext context) {
    // Determine screen orientation
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    dynamicHeight = isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;
    dynamicWidth = isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;

    final dayNightButton = dayNightButtonWidget(onTap: () {
      if (mounted) {
        setState(() => darkMode = !darkMode);
      }
    });

    final colorSwitcherButton = colorSchemeSwitcherButtonWidget(onTap: () {
      if (mounted) {
        setState(() {
          selectedClockShadeIndex =
              (selectedClockShadeIndex + 1) % clockColorShades.length;
        });
      }
    });

    final children = <Widget>[
      // Clock with background and time display
      Stack(
        alignment: Alignment.center,
        children: [
          if (showClockBg) _clockWaveBackground(_secondStream),
          _hourMinuiteRow(),
        ],
      ),

      // Show additional widgets if enabled
      if (isPortrait && showOtherOptions)
        Column(
          children: [
            dayNightButton,
            DeviceInfoWidget(),
            BatteryStatusWidget(),
            if (showClockBg) colorSwitcherButton,
          ],
        ),

      if (!isPortrait && showOtherOptions) sb,

      if (!isPortrait && showOtherOptions)
        Column(
          children: [
            dayNightButton,
            BatteryStatusWidget(),
            DeviceInfoWidget(),
            if (showClockBg) colorSwitcherButton,
          ],
        ),
    ];

    // Main scaffold and UI layout
    return Stack(
      children: [
        AnimatedContainer(
          duration: animationDuration,
          curve: animationCurve,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/sky.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: AnimatedContainer(
            duration: animationDuration,
            curve: animationCurve,
            color: darkMode ? Colors.black : Colors.transparent,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: AnimatedScale(
                duration: animationDuration,
                curve: animationCurve,
                scale: universalScale,
                filterQuality: FilterQuality.high,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    if (!mounted) return;
                    setState(() {
                      if (universalScale >= 2.2) {
                        universalScale = 1;
                      } else {
                        universalScale = universalScale + 0.2;
                      }
                    });
                  },
                  onLongPress: () {
                    if (!mounted) return;
                    setState(() {
                      showMenu = true;
                    });
                  },
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: isPortrait
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: children,
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: children,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showMenu)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Container(
                      //   width: 40,
                      //   height: 4,
                      //   margin: EdgeInsets.only(bottom: sizeByHeight(0.01)),
                      //   decoration: BoxDecoration(
                      //     color: Colors.grey,
                      //     borderRadius: BorderRadius.circular(2),
                      //   ),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text("Settings",
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: sizeByHeight(0.025),
                                )),
                          ),
                          SizedBox(
                            width: sizeByHeight(0.055),
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: sizeByHeight(0.025),
                              ),
                              onPressed: () {
                                if (!mounted) return;
                                setState(() => showMenu = false);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Dark Mode",
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: sizeByHeight(0.025),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sizeByHeight(0.055),
                            child: CustomSwitch(
                              value: darkMode,
                              onChanged: (value) {
                                setState(() {
                                  darkMode = value;
                                });
                              },
                              size: sizeByHeight(0.025),
                              activeColor: Colors.blue,
                              inactiveColor: Colors.grey,
                              thumbColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Other Options",
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: sizeByHeight(0.025),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sizeByHeight(0.055),
                            child: CustomSwitch(
                              value: showOtherOptions,
                              onChanged: (value) =>
                                  setState(() => showOtherOptions = value),
                              size: sizeByHeight(0.025),
                              activeColor: Colors.blue,
                              inactiveColor: Colors.grey,
                              thumbColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Clock Background",
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: sizeByHeight(0.025),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sizeByHeight(0.055),
                            child: CustomSwitch(
                              value: showClockBg,
                              onChanged: (value) =>
                                  setState(() => showClockBg = value),
                              size: sizeByHeight(0.025),
                              activeColor: Colors.blue,
                              inactiveColor: Colors.grey,
                              thumbColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "AM/PM + Seconds",
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: sizeByHeight(0.025),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sizeByHeight(0.055),
                            child: CustomSwitch(
                              value: showAmPmSec,
                              onChanged: (value) =>
                                  setState(() => showAmPmSec = value),
                              size: sizeByHeight(0.025),
                              activeColor: Colors.blue,
                              inactiveColor: Colors.grey,
                              thumbColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Font Weight",
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: sizeByHeight(0.025),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: sizeByHeight(0.025),
                            child: DropdownButton<FontWeight>(
                              value: userSelectedFontWeight,
                              underline: SizedBox(),
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.grey),
                              dropdownColor: Colors.grey,
                              style: TextStyle(
                                fontSize: sizeByHeight(0.02),
                                color: Colors.white,
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: FontWeight.w100,
                                  child: Text(
                                    'Thin',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w100),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: FontWeight.w300,
                                  child: Text(
                                    'Light',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: FontWeight.normal,
                                  child: Text(
                                    'Normal',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: FontWeight.w500,
                                  child: Text(
                                    'Medium',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: FontWeight.bold,
                                  child: Text(
                                    'Bold',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: FontWeight.w900,
                                  child: Text(
                                    'Extra Bold',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ],
                              onChanged: (FontWeight? newValue) {
                                setState(() {
                                  userSelectedFontWeight = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 40.0,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.thumbColor = Colors.white,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late double _thumbSize;

  @override
  void initState() {
    super.initState();
    _thumbSize = widget.size - 10;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: widget.size * 2,
        height: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.size / 2),
          color: widget.value ? widget.activeColor : widget.inactiveColor,
        ),
        padding: EdgeInsets.all(5),
        child: Align(
          alignment:
              widget.value ? Alignment.centerRight : Alignment.centerLeft,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: _thumbSize,
            height: _thumbSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.thumbColor,
            ),
          ),
        ),
      ),
    );
  }
}
