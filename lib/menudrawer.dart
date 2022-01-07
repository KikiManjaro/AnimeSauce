import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class MenuDrawer extends StatefulWidget {
  GlobalKey globalKey;

  @override
  State<StatefulWidget> createState() {
    return _MenuDrawer(globalKey);
  }

  MenuDrawer(this.globalKey);
}

class _MenuDrawer extends State<MenuDrawer> {
  String currentRouteName;
  GlobalKey<SliderMenuContainerState> globalKey;

  _MenuDrawer(this.globalKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff222831),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            TextButton(
              onPressed: () => {
                if (isSameRouteAs("/search"))
                  {globalKey.currentState.closeDrawer()}
                else
                  {Navigator.pushReplacementNamed(context, '/search')}
              },
              child: Row(
                children: [
                  Icon(Icons.search, color: Color(0xffeeeeee)),
                  SizedBox(width: 5),
                  Text("Search",
                      style: TextStyle(
                          color: Color(0xffeeeeee),
                          fontSize: 22,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            SizedBox(height: 30),
            TextButton(
              onPressed: () => {
                if (isSameRouteAs("/history"))
                  {globalKey.currentState.closeDrawer()}
                else
                  {Navigator.pushReplacementNamed(context, '/history')}
              },
              child: Row(
                children: [
                  Icon(Icons.history, color: Color(0xffeeeeee)),
                  SizedBox(width: 5),
                  Text("History",
                      style: TextStyle(
                          color: Color(0xffeeeeee),
                          fontSize: 22,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            SizedBox(height: 30),
            TextButton(
              onPressed: () => {
                if (isSameRouteAs("/credit"))
                  {globalKey.currentState.closeDrawer()}
                else
                  {Navigator.pushReplacementNamed(context, '/credit')}
              },
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xffeeeeee)),
                  SizedBox(width: 5),
                  Text("Credits",
                      style: TextStyle(
                          color: Color(0xffeeeeee),
                          fontSize: 22,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool isSameRouteAs(String name) {
    var route = ModalRoute.of(context);
    currentRouteName = route.settings.name;
    if (currentRouteName != null && currentRouteName == name) {
      return true;
    } else {
      return false;
    }
  }
}
