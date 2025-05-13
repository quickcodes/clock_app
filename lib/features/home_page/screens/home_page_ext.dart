part of 'home_page.dart';

extension _HomePageWidgetFunExt on _HomePageState {
  Widget _hourMinuiteRow() {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hour
              _buildFlipWidget(_secondStream, _hourStream, true),
              SizedBox(width: sizeByHeight(0.01)),
              _buildSeparator(),
              SizedBox(width: sizeByHeight(0.01)),
              // Minute
              _buildFlipWidget(_secondStream, _minuteStream, true),
              // Column(
              //   children: [
              //     _buildFlipWidget(_secondStream, false, true),
              //     _buildFlipWidget(_amPMStream, false, true),
              //   ],
              // ),
              // _buildSeparator(),
              // Second
            ],
          ),
        ),
        if (showAmPmSec)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildFlipWidget(_secondStream, _secondStream, false),
              _buildFlipWidget(_secondStream, _amPMStream, false),
            ],
          ),
        _buildFlipWidget(
          _secondStream,
          _dateStream,
          false,
          isDate: true,
        )
      ],
    );
  }

  Widget _buildSeparator() {
    final separatorTextHeightBasedSize = sizeByHeight(0.08);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: AnimatedDefaultTextStyle(
        curve: Curves.linear,
        duration: Duration(milliseconds: 300), //animationDuration,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: max(separatorTextHeightBasedSize, dynamicWidth * 0.25),
          fontWeight: userSelectedFontWeight,
          color: Colors.white,
          height: 1,
        ),
        child: Text(
          ":",
          // style: TextStyle(
          //   fontSize: max(separatorTextHeightBasedSize, dynamicWidth * 0.25),
          //   color: Colors.white,
          //   fontWeight: FontWeight.bold,
          // ),
        ),
      ),
    );
  }

  Widget _clockWaveBackground(Stream<int> stream) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) => AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return TweenAnimationBuilder<double>(
            duration: animationDuration,
            curve: animationCurve,
            tween: Tween(
              begin: darkMode ? sizeByHeight(0.43) : sizeByHeight(0.45),
              end: darkMode ? sizeByHeight(0.45) : sizeByHeight(0.43),
            ),
            builder: (context, animationSize, child) {
              return ProgressIndicatorWidget(
                value: _controller.value * timerDurationInSeconds,
                minValue: 1,
                maxValue: timerDurationInSeconds,
                backgroundGradientColors:
                    clockColorShades[selectedClockShadeIndex],
                stops: clockColorShadesStops[selectedClockShadeIndex],
                size: animationSize,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFlipWidget(
    Stream stream,
    Stream mainStream,
    bool bigText, {
    bool isDate = false,
  }) {
    return AnimatedScale(
      duration: animationDuration,
      curve: animationCurve,
      scale: darkMode ? 1 : 0.95,
      filterQuality: FilterQuality.high,
      alignment: Alignment.center,
      child: RepaintBoundary(
        child: FlipWidget(
          initialValue: DateTime.now().second,
          flipType: FlipType.spinFlip,
          itemStream: mainStream,
          itemBuilder: (_, value) {
            return StreamBuilder(
              // this stream is only there to update the UI at real-time when changing screen size.
              stream: stream,
              builder: (context, snapshot) {
                return _flipContainer(
                  value.toString().padLeft(2, '0'),
                  bigText,
                  isDate,
                );
              },
            );
          },
          flipDirection: AxisDirection.down,
          flipDuration: Duration(milliseconds: 1200),
        ),
      ),
    );
  }

  Widget _flipContainer(String text, bool bigText, bool isDate) {
    final bigTextHeightBasedSize = sizeByHeight(showClockBg ? 0.15 : 0.30);
    final isDateHeightBaseSize = sizeByHeight(showClockBg ? 0.02 : 0.04);
    final smallTextHeightBasedSize = sizeByHeight(showClockBg ? 0.03 : 0.06);
    return AnimatedContainer(
      duration: animationDuration,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: (bigText || isDate)
            ? null
            : Border.all(color: Colors.white, width: 0.5),
        // borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      margin: EdgeInsets.only(
        // bottom: bigText ? sizeByHeight(0.02) : 0,
        left: !bigText ? sizeByHeight(0.01) : 0,
        top: isDate ? sizeByHeight(0.02) : 0,
      ),
      // width: bigText ? sizeByHeight(0.12) : sizeByHeight(0.06),
      // height: bigText ? sizeByHeight(0.17) : sizeByHeight(0.07),
      child: AnimatedDefaultTextStyle(
        curve: Curves.linear,
        duration: Duration(milliseconds: 300), //animationDuration,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isDate
              ? min(isDateHeightBaseSize, dynamicWidth * 0.1)
              : bigText
                  ? min(bigTextHeightBasedSize, dynamicWidth * 0.3)
                  : min(smallTextHeightBasedSize, dynamicWidth * 0.2),
          fontWeight: userSelectedFontWeight,
          color: Colors.white,
          height: 1,
        ),
        child: Text(
          text,
        ),
      ),
    );
  }
}
