import 'dart:convert';
import 'dart:io';

import 'package:anime_sauce/database.dart';
import 'package:anime_sauce/menudrawer.dart';
import 'package:anime_sauce/resultpage.dart';
import 'package:anime_sauce/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'anime.dart';

class Historique extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Historique();
  }
}

class _Historique extends State<Historique> {
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff222831),
      body: SliderMenuContainer(
        key: _key,
        appBarColor: Color(0xff222831),
        appBarPadding: const EdgeInsets.only(top: 40),
        appBarHeight: 100,
        drawerIconColor: Color(0xffeeeeee),
        drawerIconSize: 36,
        isShadow: true,
        shadowColor: Color(0xff222831),
        title: Text(
          "Anime Sauce",
          style: TextStyle(
              color: Color(0xffeeeeee),
              fontSize: 22,
              fontWeight: FontWeight.w700),
        ),
        sliderMenu: MenuDrawer(_key),
        sliderMenuOpenSize: 150,
        sliderMain: Container(
          color: Color(0xff393e46),
          child: ListView(
            shrinkWrap: true,
            children: [
              FutureBuilder<List<Anime>>(
                future: DBProvider.db.getHistory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: getHistoItemList(snapshot));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<MemoryImage> b64ToMemoryImg(String b64) async {
    final decodedBytes = base64Decode(b64);
    return MemoryImage(decodedBytes);
  }

  Future<File> animeToImgFile(Anime anime) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    var directory = Directory(appDocDirectory.path + '/' + 'temp');
    if (!await directory.exists()) {
      directory = await directory.create();
    }
    return File(directory.path + "/" + anime.id.toString() + anime.hashCode.toString()).writeAsBytes(base64Decode(anime.img));
  }

  List<Widget> getHistoItemList(AsyncSnapshot snapshot) {
    List<Widget> list = [];
    for (Anime anime in snapshot.data) {
      list.add(
        Center(
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
              color: Color(0xff222831),
              height: 80,
              child: Center(
                child: ListTile(
                  leading: FutureBuilder(
                    future: b64ToMemoryImg(anime.img),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image(
                            image: ResizeImage(snapshot.data, width: 100));
                      } else {
                        return Image(
                            image: ResizeImage(
                                AssetImage('assets/placeholder.jpg'),
                                width: 100));
                      }
                    },
                  ),
                  title: Container(
                    child: Text(
                      anime.name,
                      softWrap: true,
                      style: TextStyle(
                          color: Color(0xffeeeeee),
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () =>
                    {DBProvider.db.removeAnimeById(anime.id), setState(() {})},
              )
            ],
            secondaryActions: [
              IconSlideAction(
                caption: 'Search',
                color: Colors.green,
                icon: Icons.search,
                onTap: () => pushSearchPageWithImg(anime),
              ),
            ],
          ),
        ),
      );
      list.add(SizedBox(height: 4));
    }
    return list;
  }

  Future<void> pushSearchPageWithImg(Anime anime) async {
    var img = await animeToImgFile(anime);
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return new SearchPage(image: img);
      },
    ));
  }

  Future<bool> search(String b64) async {
    http.Response response = await sendRequest(b64);
    if (response.statusCode < 400) {
      print(jsonDecode(response.body));
      Navigator.push(
          this.context,
          MaterialPageRoute(
              builder: (context) => ResultPage(
                  jsonDecode(response.body), null)));
      return true;
    } else {
      return false;
    }
  }

  Future<http.Response> sendRequest(String b64img) {
    return http.post(
      'https://trace.moe/api/search',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'image': b64img,
      }),
    );
  }
}
