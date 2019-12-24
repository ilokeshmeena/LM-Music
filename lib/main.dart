import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lmmusic/Home.dart';

void main(){
  // debugDefaultTargetPlatformOverride=TargetPlatform.fuchsia;
  runApp(MyApp()); 
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      
        primaryColor: Colors.white,
      ),
      home:Home(),
    );
  }
}