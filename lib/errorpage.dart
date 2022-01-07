import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Map jsonRes;

class ErrorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ErrorPage();
  }
}

class _ErrorPage extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xff222831),
            centerTitle: true,
            title: Text("Anime Sauce")),
        backgroundColor: Color(0xff393e46),
        body: Center(
          child: LottieBuilder.asset('assets/404.json'),
        ));
  }
}
