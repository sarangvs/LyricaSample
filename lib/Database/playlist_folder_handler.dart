import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

import './playlist_db.dart';

class PlaylistDatabaseHandler {
  Future<Database> initializeDB() async {
    String dbpath = await getDatabasesPath();
    return openDatabase(
      join(dbpath, "playlistDB.db"),
      version: 1,
      onCreate: (
          database,
          version,
          ) async {
        print("Create playlist");
        await database.execute(
          "CREATE TABLE playlist(id INTEGER PRIMARY KEY AUTOINCREMENT,playListName TEXT NOT NULL)",
        );
      },
    );
  }
  Future<int> insertPlaylist(List<PlaylistFolder> playlist) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var element in playlist) {
      result = await db.insert('playlist', element.toMapForDB());
      print('Playlist result:$result');
    }
    return result;
  }

  Future<List<PlaylistFolder>> retrievePlaylist() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('playlist');
    debugPrint("Query result: $queryResult");
    return queryResult.map((e) => PlaylistFolder.fromMap(e)).toList();
  }


  Future<void> deletePlaylist(int id) async {
    final db = await initializeDB();
    await db.delete(
      'playlist',
      where: "id = ?",
      whereArgs: [id],
    );
    debugPrint("PLAYLIST DELETED");
  }


}
