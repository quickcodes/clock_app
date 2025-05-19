

import 'package:clock_app/core/constants.dart';
import 'package:clock_app/core/utils.dart';
import 'package:flutter/material.dart';

Widget dayNightButtonWidget ({required VoidCallback onTap}) => GestureDetector(
      onTap: onTap, 
      child: Padding(
        padding: EdgeInsets.all(sizeByHeight(0.03)),
        child: AnimatedSwitcher(
          duration: animationDuration,
          switchInCurve: animationCurve,
          switchOutCurve: animationCurve,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return RotationTransition(
              turns: animation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Icon(
            darkMode ? Icons.nightlight_round_sharp : Icons.sunny,
            key: ValueKey<bool>(darkMode),
            color: Colors.white.withValues(alpha: darkMode ? 0.8 : 1),
            size: dynamicHeight * 0.05,
          ),
        ),
      ),
    );