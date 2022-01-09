import 'dart:io';

import 'package:anime_sauce/errorpage.dart';
import 'package:anime_sauce/saucenao.dart';
import 'package:anime_sauce/saucenaoresultpage.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

Map jsonRes;

class ResultPage extends StatefulWidget {
  File img;

  ResultPage(Map json, File img) {
    jsonRes = json["result"][0];
    this.img = img;
  }

  @override
  State<StatefulWidget> createState() {
    return _ResultPage(img);
  }
}

class _ResultPage extends State<ResultPage> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  File img;

  bool searching = false;

  AnimationController searchController;

  _ResultPage(File img) {
    this.img = img;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff393e46),
      appBar: AppBar(
          backgroundColor: Color(0xff222831),
          centerTitle: true,
          title: Text("Anime Sauce")),
      body: Container(
        color: Color(0xff393e46),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 120),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      _controller.play();
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Text("Name : " + jsonRes['anilist']['title']['native'].toString(),
                    style: TextStyle(color: Color(0xffeeeeee))),
                if (jsonRes['anilist']['title']['romaji']!= null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flag('JP', height: 20, width: 20),
                      Text("  " + jsonRes['anilist']['title']['romaji'].toString(),
                          style: TextStyle(color: Color(0xffeeeeee))),
                    ],
                  ),
                if (jsonRes['anilist']['title']['english'] != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flag('GB', height: 20, width: 20),
                      Text("  " + jsonRes['anilist']['title']['english'].toString(),
                          style: TextStyle(color: Color(0xffeeeeee))),
                    ],
                  ),
                if (jsonRes["season"].toString() == "Movie")
                  Text("Movie", style: TextStyle(color: Color(0xffeeeeee)))
                else if (jsonRes["Season"] != null && jsonRes["Season"] != "null" && jsonRes["season"].toString() != "Other" &&
                    jsonRes["season"].toString() != "Others")
                  Text("Season: " + jsonRes["season"].toString(),
                      style: TextStyle(color: Color(0xffeeeeee))),
                if (jsonRes["episode"] != null && jsonRes["episode"] != "null" && jsonRes["episode"].toString() != "")
                  Text("Episode: " + jsonRes["episode"].toString(),
                      style: TextStyle(color: Color(0xffeeeeee))),
                Text(
                    "Time : " +
                        (jsonRes["from"] / 60).truncate().toString() +
                        "m" +
                        (jsonRes["from"] % 60).toStringAsFixed(0) +
                        "s",
                    style: TextStyle(color: Color(0xffeeeeee))),
                FlatButton(
                  onPressed: () => launchUrl(jsonRes["anilist"]['id'].toString()),
                  child: Text("More infos on AniLink",
                      style: TextStyle(color: Color(0xffeeeeee))),
                  color: Color(0xff222831),
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Color(0xff222831))),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  child: ProgressButton(
                    child: Text("Not the right anime ?",
                        style: TextStyle(
                            color: Color(0xffeeeeee),
                            fontWeight: FontWeight.w700)),
                    onPressed: (AnimationController controller) {
                      searchController = controller;
                      if (!searching) {
                        controller.forward();
                        searchSauceNao();
                      }
                    },
                    color: Color(0xff222831),
                    borderRadius: BorderRadius.circular(36.0),
                    progressIndicatorColor: Color(0xffeeeeee),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getPreviewLink() {
    return jsonRes['video']+ "&mute";
  }

  Future<void> launchUrl(String aniListId) async {
    String url = "https://anilist.co/anime/" + aniListId;
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  void initState() {
    _controller = VideoPlayerController.network(getPreviewLink());
    _controller.setLooping(true);
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  Future<void> searchSauceNao() async {
    searching = true;
    var search = await Saucenao().search(this.img);
    searchController.reverse();
    Navigator.push(this.context, MaterialPageRoute(builder: (context) {
      searching = false;
      if (search != null) {
        return SaucenaoResultPage(search);
      } else {
        return ErrorPage();
      }
    }));
  }
}
