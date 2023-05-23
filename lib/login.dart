import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rive/rive.dart';

import 'animatedEnum.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Artboard? _artboard;
  late RiveAnimationController idle;
  late RiveAnimationController handsDown;
  late RiveAnimationController handsUp;
  late RiveAnimationController success;
  late RiveAnimationController fail;
  late RiveAnimationController lookDownLeft;
  late RiveAnimationController lookDownRight;

  bool lookLeft = false;
  bool lookRight = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idle = SimpleAnimation(Animated.idle.name);
    handsDown = SimpleAnimation(Animated.hands_down.name);
    handsUp = SimpleAnimation(Animated.Hands_up.name);
    success = SimpleAnimation(Animated.success.name);
    fail = SimpleAnimation(Animated.fail.name);
    lookDownLeft = SimpleAnimation(Animated.Look_down_left.name);
    lookDownRight = SimpleAnimation(Animated.Look_down_right.name);
    rootBundle.load("assets/loginBear.riv").then((value) {
      final file = RiveFile.import(value);
      final artBoard = file.mainArtboard;
      artBoard.addController(idle);
      setState(() {
        _artboard = artBoard;
      });
    });

    password.addListener(onFocusChange);
  }

  void onFocusChange() {
    if (password.hasFocus) {
      print("handup");

      addPasswordController();
    } else {
      addHandDownController();
    }
  }

  void removeAllController() {
    _artboard!.artboard.removeController(idle);
    _artboard!.artboard.removeController(handsDown);
    _artboard!.artboard.removeController(handsUp);
    _artboard!.artboard.removeController(success);
    _artboard!.artboard.removeController(fail);
    _artboard!.artboard.removeController(lookDownLeft);
    _artboard!.artboard.removeController(lookDownRight);
    lookLeft = false;
    lookRight = false;
  }

  void addIdleController() {
    removeAllController();
    _artboard!.artboard.addController(idle);
  }

  void addSuccessController() {
    removeAllController();
    _artboard!.artboard.addController(success);
  }

  void addHandDownController() {
    removeAllController();
    _artboard!.artboard.addController(handsDown);
  }

  void addLookLeftController() {
    removeAllController();
    lookLeft = true;
    lookRight = false;
    _artboard!.artboard.addController(lookDownLeft);
  }

  void addLookRightController() {
    removeAllController();
    lookLeft = false;
    lookRight = true;
    _artboard!.artboard.addController(lookDownRight);
  }

  void addPasswordController() {
    removeAllController();

    _artboard!.artboard.addController(handsUp);
  }

  FocusNode password = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
              height: 200,
              child: _artboard == null
                  ? SizedBox()
                  : Rive(
                      artboard: _artboard!,
                      fit: BoxFit.fill,
                    )),
          SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    hintText: 'Email',
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty && value.length < 16 && !lookLeft) {
                      addLookLeftController();
                    } else if (value.isNotEmpty &&
                        value.length > 16 &&
                        !lookRight) {
                      addLookRightController();
                    } else if (value.length == 0) {
                      print("idle");
                      addIdleController();
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  focusNode: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    hintText: 'Password',
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          addSuccessController();
                        },
                        child: Text("Login")))
              ],
            ),
          )
        ],
      ),
    );
  }
}
