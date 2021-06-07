import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khata_app/Services/CheckRootUserLoggedIn.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    _animation = Tween<double>(
      begin: 100,
      end: 200,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
    _controller.forward();
    Timer(Duration(seconds: 3),()=>Navigator.push(context, CupertinoPageRoute(builder: (context)=>RootUserLoggedIn())));
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
                animation: _animation, builder: (BuildContext context,Widget child){
                  return Container(
                    width: 2*_animation.value,
                    height: _animation.value,
                    child: Image(
                      image: AssetImage('assets/images/SplashIcon.png'),
                      fit: BoxFit.fill,
                    ),
                  );
            }),
          ],
        ),
      ),
    );
  }
}
