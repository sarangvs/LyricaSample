import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db.dart';

class DatabaseHandler {

  Future<Database> initializeDB() async {
    String dbpath = await getDatabasesPath();
    return openDatabase(join(dbpath, "favourite.db"),
      version: 1,
      onCreate: (database, version,) async {
        await database.execute(
          "CREATE TABLE songs(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL,num INTEGER NOT NULL,location TEXT NOT NULL)",);
      },);
  }

  Future <int> insertSong(List<Song>songs) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var song in songs) {
      result = await db.insert('songs', song.toMap());
    }
    return result;
  }

  Future <List<Song>> retrieveSongs() async {
    final Database db = await initializeDB();
    final List <Map<String, Object?>>queryResult = await db.query('songs');
    debugPrint("Query result: $queryResult");
    return queryResult.map((e) => Song.fromMap(e)).toList();
  }

  Future<void> deleteSongs(int id) async {
    final db = await initializeDB();
    await db.delete(
      'songs',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
