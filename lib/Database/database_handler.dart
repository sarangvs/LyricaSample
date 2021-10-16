import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db.dart';

class DatabaseHandler {

  Future<Database> initializeDB() async {
    String dbpath = await getDatabasesPath();
    return openDatabase(join(dbpath, "favSongDB.db"),
      version: 1,
      onCreate: (database, version,) async {
        print("Creating favourite SONG");
        await database.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL,num INTEGER NOT NULL,location TEXT NOT NULL)",);
      },);
  }

  Future <int> insertUser(List<User>users) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var user in users) {
      result = await db.insert('users', user.toMap());
    }
    return result;
  }

  Future <List<User>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List <Map<String, Object?>>queryResult = await db.query('users');
    debugPrint("UNAISEr: $queryResult");
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  Future<void> deleteUser(int id) async {
    final db = await initializeDB();
    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
