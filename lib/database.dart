import 'package:anime_sauce/anime.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    await createTableAnime();
    return _database;
  }

  Future<Database> initDb() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'anime_sauce_history.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE anime (img TEXT, name TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> createTableAnime() async {
    final Database db = await database;
    await db
        .execute("CREATE TABLE IF NOT EXISTS anime (String img, name TEXT)");
  }

  Future<void> insertAnime(Anime anime) async {
    final Database db = await database;
    await db.insert(
      'anime',
      anime.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Anime>> getHistory() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery("select rowid, img, name from anime");

    return List.generate(maps.length, (i) {
      Anime anime = Anime(
        maps[i]['img'],
        maps[i]['name'],
      );
      anime.id = maps[i]["rowid"];
      return anime;
    });
  }

  Future<void> removeAnimeById(int id) async {
    final Database db = await database;
    await db.delete(
      'anime',
      where: "rowid = " + id.toString(),
    );
  }
}
