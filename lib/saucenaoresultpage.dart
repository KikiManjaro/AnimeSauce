import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Map jsonRes;
String thumbURL;
String similarity;

class SaucenaoResultPage extends StatefulWidget {
  SaucenaoResultPage(Map json) {
    jsonRes = json["results"][0]["data"];
    thumbURL = json["results"][0]["header"]["thumbnail"];
    similarity = json["results"][0]["header"]["similarity"];
  }

  @override
  State<StatefulWidget> createState() {
    return _SaucenaoResultPage();
  }
}

class _SaucenaoResultPage extends State<SaucenaoResultPage> {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: getMainList(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getMainList() {
    List<Widget> widgetList = [];
    widgetList.add(
      Center(
        child: Text("We also found this :",
            style: TextStyle(
                color: Color(0xffeeeeee),
                fontSize: 26,
                fontWeight: FontWeight.bold)),
      ),
    );
    widgetList.add(
      Center(
        child: Image(
          image: ResizeImage(NetworkImage(thumbURL), height: 400),
        ),
      ),
    );
    widgetList.add(
      Center(
        child: Text("similarity : " + similarity,
            style: TextStyle(color: Color(0xffeeeeee))),
      ),
    );
    for (var key in jsonRes.keys) {
      if (key != null && jsonRes[key] != null) {
        if (key == "ext_urls") {
          for (String url in jsonRes[key]) {
            widgetList.add(
              Center(
                child: FlatButton(
                  onPressed: () {
                    return launchUrl(url);
                  },
                  child: Text(url, style: TextStyle(color: Color(0xffeeeeee))),
                  color: Color(0xff222831),
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Color(0xff222831))),
                ),
              ),
            );
          }
        } else {
          widgetList.add(
            Center(
              child: Text(key + " : " + jsonRes[key].toString(),
                  style: TextStyle(color: Color(0xffeeeeee))),
            ),
          );
        }
      }
    }
    return widgetList;
  }

  Future<void> launchUrl(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw "Could not launch $url";
    }
  }
}
