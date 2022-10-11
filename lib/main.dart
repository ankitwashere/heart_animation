import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

void main() {
  runApp(const MyApp());
}

extension Log on Object {
  void log() => devtools.log(toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // Data for animation
  final circleD = 160.0;
  final iconSize = 60.0;
  final color = const Color.fromARGB(255, 239, 13, 137);

  // animation controller
  late AnimationController _controller, _outerBoxController;
  late Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _outerBoxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 0.1,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: const ElasticOutCurve(0.7),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _outerBoxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animation.value.toString().log();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => _controller.status == AnimationStatus.dismissed ? _controller.forward() : _controller.reverse(),
          onTapDown: (details) => _outerBoxController.forward(),
          onTapUp: (details) => _outerBoxController.reverse(),
          child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                _animation.value.toString().log();
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: 1 - _outerBoxController.value,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color,
                            width: 7,
                          ),
                        ),
                        width: circleD,
                        height: circleD,
                      ),
                    ),
                    _controller.status == AnimationStatus.dismissed
                        ? Icon(
                            Icons.favorite,
                            size: iconSize,
                            color: color,
                          )
                        :
                        // another element
                        Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color,
                                ),
                                width: (circleD - 40) * _animation.value,
                                height: (circleD - 40) * _animation.value,
                              ),
                              Icon(
                                Icons.favorite,
                                size: iconSize * _animation.value,
                                color: Colors.white,
                              )
                            ],
                          ),
                  ],
                );
                // return Container(
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     border: Border.all(
                //       color: color,
                //       width: 7,
                //     ),
                //   ),
                //   width: _outerBoxAnimation.value + 180,
                //   height: _outerBoxAnimation.value + 180,
                //   child:
                // );
              }),
        ),
      ),
    );
  }
}
