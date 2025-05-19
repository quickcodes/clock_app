import 'package:clock_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double dynamicHeight = 0.0;
double dynamicWidth = 0.0;
bool isPortrait = false;
Duration animationDuration = Duration(milliseconds: 700);
Curve animationCurve = Curves.easeInOut;
int selectedClockShadeIndex = 1;
double timerDurationInSeconds = 60.0;
bool darkMode = true;
bool showOtherOptions = false;
bool showClockBg = false;
bool showAmPmSec = false;
double universalScale = 1;
FontWeight userSelectedFontWeight = FontWeight.w100;
TextStyle defaultTextStyle = TextStyle(); //GoogleFonts.quicksand();

final sb = isPortrait
    ? SizedBox(height: sizeByHeight(0.02))
    : SizedBox(width: sizeByHeight(0.02));

List<List<Color>> clockColorShades = [
  // Green
  [
    Color(0xff2E8B57), // Dark
    Color(0xff28a745), // Medium
    Color(0xff90EE90), // Light
    Color(0xff28a745), // Medium
    Color(0xff2E8B57), // Dark
  ],

  // Blue
  [
    Color(0xff1E3A8A),
    Color(0xff3B82F6),
    Color(0xff60A5FA),
    Color(0xff3B82F6),
    Color(0xff1E3A8A),
  ],

  // White
  [
    Color(0xffDCDCDC),
    Color(0xffF5F5F5),
    Color(0xffFFFFFF),
    Color(0xffF5F5F5),
    Color(0xffDCDCDC),
  ],

  // Purple
  [
    Color(0xff4B0082),
    Color(0xff8A2BE2),
    Color(0xffBA55D3),
    Color(0xff8A2BE2),
    Color(0xff4B0082),
  ],

  // Orange
  [
    Color(0xffFF8C00),
    Color(0xffFFA500),
    Color(0xffFFB347),
    Color(0xffFFA500),
    Color(0xffFF8C00),
  ],

  // Red
  [
    Color(0xff8B0000),
    Color(0xffFF4500),
    Color(0xffFF6F61),
    Color(0xffFF4500),
    Color(0xff8B0000),
  ],

  // Yellow
  [
    Color(0xffB8860B),
    Color(0xffFFD700),
    Color(0xffFFFACD),
    Color(0xffFFD700),
    Color(0xffB8860B),
  ],

  // Pink
  [
    Color(0xffC71585),
    Color(0xffFF69B4),
    Color(0xffFFB6C1),
    Color(0xffFF69B4),
    Color(0xffC71585),
  ],

  // Teal
  [
    Color(0xff006666),
    Color(0xff20B2AA),
    Color(0xffAFEEEE),
    Color(0xff20B2AA),
    Color(0xff006666),
  ],
];


List<List<double>> clockColorShadesStops = [
  // Green
  [0.25, 0.35, 0.5, 0.35, 0.25],

  // Blue
  [0.25, 0.35, 0.5, 0.35, 0.25],

  // White
  [0.25, 0.35, 0.5, 0.35, 0.25],

  // Purple
  [0.25, 0.35, 0.5, 0.35, 0.25],

  // Orange
  [0.25, 0.35, 0.5, 0.35, 0.25],

  // Red
  [0.25, 0.35, 0.5, 0.35, 0.25],

  // Yellow
  [0.25, 0.35, 0.5, 0.35, 0.25],

  // Pink
  [0.25, 0.35, 0.5, 0.35, 0.25],

  // Teal
  [0.25, 0.35, 0.5, 0.35, 0.25],
];
