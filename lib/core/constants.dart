import 'package:clock_app/core/utils.dart';
import 'package:flutter/material.dart';

double dynamicHeight = 0.0;
double dynamicWidth = 0.0;
bool isPortrait = false;
Duration animationDuration = Duration(milliseconds: 700);
Curve animationCurve = Curves.easeInOut;
int selectedClockShadeIndex = 1;
double timerDurationInSeconds = 60.0;
bool darkMode = false;
bool showOtherOptions = true;
bool showClockBg = true;
bool showAmPmSec = true;
double universalScale = 1;
FontWeight userSelectedFontWeight = FontWeight.bold;

final sb = isPortrait
    ? SizedBox(height: sizeByHeight(0.02))
    : SizedBox(width: sizeByHeight(0.02));

List<List<Color>> clockColorShades = [
  // Green
  [
    Color(0xff2E8B57), // Sea Green (dark green)
    Color(0xff28a745), // Green shade (medium green)
    Color(0xff90EE90), // Light Green (light green)
  ],

  // Blue
  [
    Color(0xff1E3A8A), // Dark Blue (similar to Navy Blue)
    Color(0xff3B82F6), // Medium Blue (like a soft royal blue)
    Color(0xff60A5FA), // Vibrant Sky Blue (better than very light)
  ],

  // White
  [
    Color(0xffDCDCDC), // Gainsboro (soft gray-white)
    Color(0xffF5F5F5), // White Smoke (neutral light)
    Color(0xffFFFFFF), // Pure White
  ],

  // Purple
  [
    Color(0xff4B0082), // Indigo (dark purple)
    Color(0xff8A2BE2), // Blue Violet
    Color(0xffBA55D3), // Medium Orchid (more color, less pale)
  ],

  // Orange
  [
    Color(0xffFF8C00), // Dark Orange
    Color(0xffFFA500), // Standard Orange
    Color(0xffFFB347), // Lively orange tone (not washed out)
  ],

  // Red
  [
    Color(0xff8B0000), // Dark Red
    Color(0xffFF4500), // Orange Red
    Color(0xffFF6F61), // Coral Red (better than pale pink)
  ],

  // Yellow
  [
    Color(0xffB8860B), // Dark Goldenrod (deep yellow)
    Color(0xffFFD700), // Gold
    Color(0xffFFFACD), // Lemon Chiffon (light yellow)
  ],

  // Pink
  [
    Color(0xffC71585), // Medium Violet Red (deep pink)
    Color(0xffFF69B4), // Hot Pink
    Color(0xffFFB6C1), // Light Pink
  ],

  // Teal
  [
    Color(0xff006666), // Deep Teal
    Color(0xff20B2AA), // Light Sea Green
    Color(0xffAFEEEE), // Pale Turquoise
  ]
];

List<List<double>> clockColorShadesStops = [
  // Green
  [0.25, 0.35, 0.5],

  // Blue
  [0.25, 0.35, 0.5],
  
  // White
  [0.25, 0.35, 0.5],

  // Purple
  [0.25, 0.35, 0.5],

  // Orange
  [0.25, 0.35, 0.5],

  // Red
  [0.25, 0.35, 0.5],

  // Yellow
  [0.25, 0.35, 0.5],

  // Pink
  [0.25, 0.35, 0.5],

  // Teal
  [0.25, 0.35, 0.5],
];
