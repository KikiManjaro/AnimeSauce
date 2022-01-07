import 'package:anime_sauce/credit.dart';
import 'package:anime_sauce/history.dart';
import 'package:anime_sauce/intro.dart';
import 'package:anime_sauce/searchpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Sauce',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/intro',
      routes: {
        '/intro': (context) => Intro(),
        '/search': (context) => SearchPage(),
        '/history': (context) => Historique(),
        '/credit': (context) => Credit()
      },
    );
  }
} 
