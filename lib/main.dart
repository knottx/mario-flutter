import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double marioDx = 0;
  double marioDy = 1;

  double time = 0;
  double height = 0;
  double initialHeight = 0;

  bool isJumping = false;

  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  color: Colors.blue,
                  child: Container(
                    alignment: Alignment(
                      marioDx,
                      marioDy,
                    ),
                    child: isJumping
                        ? Image.asset(
                            'assets/images/mario_jumping.png',
                            height: 80,
                          )
                        : Image.asset(
                            'assets/images/mario.png',
                            height: 80,
                          ),
                  ),
                ),
              ),
              Container(
                height: 10,
                color: Colors.green,
              ),
              Container(
                color: Colors.brown,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 48,
                ),
                child: SafeArea(
                  top: false,
                  child: KeyboardListener(
                    autofocus: true,
                    focusNode: _focusNode,
                    onKeyEvent: (event) {
                      if (event is KeyDownEvent) {
                        switch (event.logicalKey.debugName) {
                          case 'Space':
                          case 'Arrow Up':
                            _jump();
                            break;

                          case 'Arrow Left':
                            _moveLeft();
                            break;

                          case 'Arrow Right':
                            _moveRight();
                            break;

                          default:
                            break;
                        }
                      }
                    },
                    child: Row(
                      children: [
                        // Row(
                        //   children: [
                        //     IconButton.filledTonal(
                        //       onPressed: _moveLeft,
                        //       icon: const Icon(
                        //         Icons.arrow_back,
                        //         size: 64,
                        //       ),
                        //     ),
                        //     const SizedBox(width: 48),
                        //     IconButton.filledTonal(
                        //       onPressed: _moveRight,
                        //       icon: const Icon(
                        //         Icons.arrow_forward,
                        //         size: 64,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const Spacer(),
                        IconButton.filledTonal(
                          onPressed: _jump,
                          icon: const Icon(
                            Icons.arrow_upward,
                            size: 64,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _info(title: 'Mario', value: '0'),
                _info(title: 'World', value: '1-1'),
                _info(title: 'Time', value: '9999'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _info({
    required String title,
    required String value,
  }) {
    const style = TextStyle(
      fontFamily: 'PressStart2P',
      color: Colors.white,
      fontSize: 14,
    );
    return Column(
      children: [
        Text(
          title,
          style: style,
        ),
        Text(
          value,
          style: style,
        ),
      ],
    );
  }

  void _jump() {
    if (isJumping) return;
    // _preJump();
    isJumping = true;
    Timer.periodic(
      const Duration(milliseconds: 50),
      (timer) {
        // a quadratic equation that models a physical jump

        time += 0.025;
        height = -15 * time * time + (5 * time);

        // this prevents mario from going lower tham the ground
        final double value = (initialHeight - height).clamp(-1, 1);
        if (value == 1) {
          setState(() {
            marioDy = 1;
          });
          isJumping = false;
          height = 0;
          time = 0;
          timer.cancel();
        } else {
          setState(() {
            marioDy = value;
          });
        }
      },
    );
  }

  void _moveLeft() {
    //
  }

  void _moveRight() {
    //
  }
}
