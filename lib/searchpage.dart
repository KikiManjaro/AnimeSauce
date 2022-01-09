import 'dart:async';
import 'dart:convert';
import 'dart:io' as IO;

import 'package:anime_sauce/database.dart';
import 'package:anime_sauce/errorpage.dart';
import 'package:anime_sauce/menudrawer.dart';
import 'package:anime_sauce/resultpage.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:validators/validators.dart';

import 'anime.dart';

class SearchPage extends StatefulWidget {
  IO.File image;

  SearchPage({Key key, IO.File image})
      : image = image,
        super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState(image);
}

class _SearchPageState extends State<SearchPage> {
  InterstitialAd interstitial;

  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  Image placeholder = Image.asset('assets/placeholder.jpg');
  IO.File _image;
  final picker = ImagePicker();
  AnimationController searchController;
  var textEditingController = TextEditingController();
  IO.Directory systemTempDir = IO.Directory.systemTemp;
  Icon linkIcon = Icon(Icons.search, color: Color(0xff00adb5), size: 40);
  var searching = false;

  _SearchPageState(IO.File image) : _image = image;

  @override
  Widget build(BuildContext context) {
    initAds();
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
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
          sliderMain: Scaffold(
            backgroundColor: Color(0xff393e46),
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image(
                      image: ResizeImage(getImageOrPlaceHolder(), height: 400),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 300,
                          child: TextField(
                            autofocus: false,
                            onChanged: (value) {
                              linkIcon = Icon(Icons.search,
                                  color: Color(0xff00adb5), size: 40);
                              _image = null;
                            },
                            style: TextStyle(
                                color: Color(0xffeeeeee), fontSize: 16),
                            cursorColor: Color(0xff00adb5),
                            decoration: InputDecoration(
                              labelText: 'URL',
                              labelStyle: TextStyle(
                                color: Color(0xffeeeeee),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: Color(0xff00adb5)),
                                gapPadding: 1.0,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(11.0)),
                                borderSide:
                                    BorderSide(color: Color(0xff222831)),
                                gapPadding: 1.0,
                              ),
                            ),
                            controller: textEditingController,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              searchLinkImg(textEditingController.text),
                          child: linkIcon,
                        )
                      ],
                    ),
                    FlatButton(
                      child: Text("Import picture",
                          style: TextStyle(
                              color: Color(0xffeeeeee),
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                      onPressed: importPicture,
                      color: Color(0xff222831),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Color(0xff222831))),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: ProgressButton(
                        child: Text("Search",
                            style: TextStyle(
                                color: Color(0xffeeeeee),
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                        onPressed: (AnimationController controller) {
                          if (_image != null && !searching) {
                            searching = true;
                            searchController = controller;
                            controller.forward();
                            search();
                          }
                        },
                        color: Color(0xff00adb5),
                        borderRadius: BorderRadius.circular(36.0),
                        progressIndicatorColor: Color(0xffeeeeee),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider getImageOrPlaceHolder() {
    if (_image == null) {
      return AssetImage('assets/placeholder.jpg');
    } else {
      return FileImage(_image);
    }
  }

  Future takePicture() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = IO.File(pickedFile.path);
      }
    });
  }

  Future importPicture() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = IO.File(pickedFile.path);
      }
    });
  }

  Future<bool> search() async {
    Response response = await sendRequest();
    if (response.statusCode < 400) {
      print(jsonDecode(response.body));
      setState(() {
        searchController.reverse();
      });
      String b64img = await imgToB64img(_image);
      DBProvider.db.insertAnime(Anime(
          b64img,
          jsonDecode(response.body)["result"][0]["anilist"]['title']['romaji']
              .toString()));
      showAds();
      Navigator.push(
          this.context,
          MaterialPageRoute(
              builder: (context) =>
                  ResultPage(jsonDecode(response.body), _image)));
      searching = false;
      return true;
    } else {
      setState(() {
        searchController.reverse();
      });
      setState(() {});
      Navigator.push(
          this.context, MaterialPageRoute(builder: (context) => ErrorPage()));
      searching = false;
      return false;
    }
  }

  Future<Response> sendRequest() async {
    var request = MultipartRequest("POST",
        Uri.parse('https://api.trace.moe/search?cutBorders&anilistInfo'));
    var pic = await MultipartFile.fromPath("image", _image.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();
    return await Response.fromStream(response);
  }

  Future<String> imgToB64img(IO.File img) async {
    List<int> imageBytes = img.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  Future<String> compressFileTob64(IO.File file) async {
    List<int> result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1280,
      minHeight: 720,
      quality: 90,
    );
    print(file.lengthSync());
    print(result.length);
    return base64Encode(result);
  }

  searchLinkImg(String url) async {
    if (isURL(url)) {
      var response = await get(url);
      if (response != null &&
          response.bodyBytes != null &&
          response.statusCode < 400) {
        String path = systemTempDir.path + "/images";
        String fileName = path +
            "/" +
            DateTime.now().millisecondsSinceEpoch.toString() +
            ".tmp";
        await IO.Directory(path).create(recursive: true);
        IO.File file2 = new IO.File(fileName);
        file2.writeAsBytesSync(response.bodyBytes);
        setState(() {
          linkIcon = Icon(Icons.check, color: Color(0xff00adb5), size: 40);
          _image = file2;
        });
      } else {
        setState(() {
          linkIcon = Icon(Icons.warning_amber_rounded,
              color: Color(0xff00adb5), size: 40);
          _image = null;
        });
      }
    } else {
      setState(() {
        linkIcon = Icon(Icons.warning_amber_rounded,
            color: Color(0xff00adb5), size: 40);
        _image = null;
      });
    }
  }

  void initAds() {
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['anime', 'weeb', 'game'],
      childDirected: false,
      testDevices: <String>[],
    );

    interstitial = InterstitialAd(
      adUnitId: "ca-app-pub-3940256099942544/8691691433", //debug
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
    interstitial..load();
  }

  void showAds() {
    interstitial
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
        horizontalCenterOffset: 0.0,
      );
  }
}
