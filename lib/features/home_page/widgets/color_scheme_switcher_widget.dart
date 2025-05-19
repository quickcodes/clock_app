import 'package:clock_app/core/constants.dart';
import 'package:clock_app/core/utils.dart';
import 'package:flutter/material.dart';

Widget colorSchemeSwitcherButtonWidget({required VoidCallback onTap}) => GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(sizeByHeight(0.03)),
        child: AnimatedContainer(
          duration: animationDuration,
          curve: animationCurve,
          height: sizeByHeight(0.04),
          width: sizeByHeight(0.04),
          decoration: BoxDecoration(
            color: clockColorShades[selectedClockShadeIndex]
                .first
                .withValues(alpha: darkMode ? 0.5 : 1.0),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
