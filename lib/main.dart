import 'package:flutter/material.dart';
import 'features/home_page/screens/home_page.dart';
export 'core/constants.dart';


void main() => runApp(FlipClockApp());

class FlipClockApp extends StatelessWidget {
  const FlipClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

