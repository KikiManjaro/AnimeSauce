import 'package:anime_sauce/menudrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_particles/particles.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:lottie/lottie.dart';

class Credit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Credit();
  }
}

class _Credit extends State<Credit> {
  int easterCount = 0;
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff393e46),
      body: SliderMenuContainer(
        key: _key,
        appBarColor: Color(0xff222831),
        appBarPadding: const EdgeInsets.only(top: 40),
        appBarHeight: 100,
        drawerIconColor: Color(0xffeeeeee),
        drawerIconSize: 36,p
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
          width: double.infinity,
          child: Stack(
            children: [
              if (easterCount > 10) LottieBuilder.asset('assets/Fun.json'),
               Particles(22, Color(0xffeeeeee)),
              Center(
                child: GestureDetector(
                  onTap: () => {easterCount += 1, setState(() {})},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Author:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff00adb5)),
                          ),
                          Text(
                            "KikiManjaro",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffeeeeee)),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Column(
                        children: [
                          Text(
                            "Application made using:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff00adb5)),
                          ),
                          Text(
                            "Flutter",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffeeeeee)),
                          ),
                          Text(
                            "trace.moe",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffeeeeee)),
                          ),
                          Text(
                            "saucenao.moe",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffeeeeee)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
