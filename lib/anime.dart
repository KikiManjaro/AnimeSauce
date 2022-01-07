import 'package:flutter/cupertino.dart';

class Anime {
  int id;
  String img;
  String name;

  Anime(this.img, this.name);

  Map<String, dynamic> toMap() {
    return {'img': img, 'name': name};
  }
}
