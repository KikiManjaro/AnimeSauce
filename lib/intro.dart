import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_admob/firebase_admob.dart';

class Intro extends StatefulWidget {
  Intro({Key key}) : super(key: key);

  @override
  _Intro createState() => _Intro();
}

class _Intro extends State<Intro> {
  final pages = [
    PageViewModel(
      pageColor: const Color(0xff393e46),
      bubbleBackgroundColor: Color(0xff222831),
      bubble: Icon(Icons.search, color: Color(0xffeeeeee)),
      body: Text(
        'Search for any Anime with a simple picture',
      ),
      title: Text('Search'),
      mainImage: LottieBuilder.asset('assets/Loupe.json'),
      titleTextStyle:
          TextStyle(color: Color(0xffeeeeee), fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(color: Color(0xffeeeeee)),
    ),
    PageViewModel(
      pageColor: const Color(0xff393e46),
      bubbleBackgroundColor: Color(0xff222831),
      bubble: Icon(Icons.history, color: Color(0xffeeeeee)),
      body: Text(
        'Keep an eye on all your past research',
      ),
      title: Text('History'),
      mainImage: LottieBuilder.asset('assets/History.json'),
      titleTextStyle:
          TextStyle(color: Color(0xffeeeeee), fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(color: Color(0xffeeeeee)),
    ),
    PageViewModel(
      pageColor: const Color(0xff393e46),
      bubbleBackgroundColor: Color(0xff222831),
      bubble: Icon(FontAwesomeIcons.heart, color: Color(0xffeeeeee)),
      body: Text(
        'Have Fun !',
      ),
      title: Text('Fun'),
      mainImage: LottieBuilder.asset('assets/Fun.json'),
      titleTextStyle:
          TextStyle(color: Color(0xffeeeeee), fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(color: Color(0xffeeeeee)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-3586860634843248~9588951924");
    return FutureBuilder(
        future: hasBeenOpened(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (!snapshot.data) {
              return IntroViewsFlutter(
                pages,
                onTapDoneButton: () {
                  markAsOpen();
                  Navigator.pushReplacementNamed(context, '/search');
                },
                onTapSkipButton: () {
                  markAsOpen();
                  Navigator.pushReplacementNamed(context, '/search');
                },
                showSkipButton: true,
                fullTransition: 200,
                pageButtonTextStyles: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              );
            } else {
              Future.delayed(Duration.zero, () {
                Navigator.pushReplacementNamed(context, '/search');
              });
              return Center(
                  child:
                      CircularProgressIndicator());
            }
          } else {
            return Center(
                child:
                    CircularProgressIndicator());
          }
        });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void markAsOpen() async {
    final path = await _localPath;
    var file = File('$path/open.txt');
    file.writeAsString("true");
  }

  Future<bool> hasBeenOpened() async {
    final path = await _localPath;
    var file = File('$path/open.txt');
    if (file.existsSync()) {
      return file.readAsStringSync() == "true";
    } else {
      return false;
    }
  }
}
