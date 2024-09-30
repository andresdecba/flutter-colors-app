import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  late Color bgColor;
  late Color textColor;
  late AnimationController animationController;
  bool enableTimer = false;
  Timer? timer;
  final curve = Curves.easeInOut;
  final transitionDuration = const Duration(milliseconds: 500);
  final scaleDuration = const Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: scaleDuration,
      value: 1,
      lowerBound: 1.0,
      upperBound: 1.2,
    );
    changeColor();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GestureDetector(
          onTap: () => changeColor(),
          child: Stack(
            children: [
              AnimatedContainer(
                curve: curve,
                duration: transitionDuration,
                color: bgColor,
              ),
              Align(
                alignment: Alignment.center,
                child: ScaleTransition(
                  scale: animationController,
                  child: AnimatedDefaultTextStyle(
                    curve: curve,
                    duration: transitionDuration,
                    style: TextStyle(
                      fontSize: 40,
                      color: textColor,
                    ),
                    child: const Text('Hello there'),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SwitchListTile(
                    title: const Text('Enable timer'),
                    value: enableTimer,
                    onChanged: setTimer,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void setTimer(bool value) {
    setState(() {
      enableTimer = value;
      if (enableTimer) {
        timer = Timer.periodic(
          transitionDuration,
          (Timer t) => changeColor(),
        );
      } else {
        timer?.cancel();
      }
    });
  }

  void animateText() {
    animationController
        .forward()
        .then((value) => animationController.reverse());
  }

  void changeColor() {
    final random = math.Random();
    final color = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
    setState(() {
      bgColor = color;
      final brightness =
          color.red * 0.299 + color.green * 0.587 + color.blue * 0.114;
      textColor = brightness < 128 ? Colors.white : Colors.black;
      animateText();
    });
  }
}
