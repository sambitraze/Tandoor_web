import 'package:custom_splash/custom_splash.dart';
import 'package:flutter/material.dart';
import 'package:tandoor_hut/homepage.dart';
import 'package:tandoor_hut/login.dart';
import 'package:tandoor_hut/orders.dart';
import 'package:tandoor_hut/staffpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tandoor Hut',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CustomSplash(
        backGroundColor: Colors.black,
        imagePath: 'assets/logo.png',
        animationEffect: 'zoom-in',
        logoSize: 150,
        duration: 2500,
        type: CustomSplashType.StaticDuration,
        // home: LoginPage(),
        home: Staffpage(),
      ),      
    );
  }
}