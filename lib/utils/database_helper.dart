import 'dart:io';

import 'package:flutter_not_defteri/model/category.dart';
import 'package:flutter_not_defteri/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper.internal();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper.internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    Database _db;
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "notlar.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "notlar.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    _db = await openDatabase(path, readOnly: false);
    return _db;
  }

  // ---------   Category tablosu sorguları ------------------------------------

  Future<List<Map<String, dynamic>>> getCategories() async {
    var db = await _getDatabase();
    var sonuc = await db.query("category");
    return sonuc;
  }

  Future<int> addCategory(Category category) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("category", category.toMap());
    return sonuc;
  }

  Future<int> updateCategory(Category category) async {
    var db = await _getDatabase();
    var sonuc = await db.update("category", category.toMap(),
        where: 'categoryID = ?', whereArgs: [category.categoryID]);
    return sonuc;
  }

  Future<int> deleteCategory(int categoryID) async {
    var db = await _getDatabase();
    var sonuc = await db.delete("category", where: 'categoryID = ?', whereArgs: [categoryID]);
    return sonuc;
  }

  // ---------------- Note tablosu sorguları ----------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> getNotes() async {
    var db = await _getDatabase();
//    var sonuc = await db.query("note", orderBy: 'noteID DESC');
    var sonuc = await db.rawQuery("select * from note inner join category on category.categoryID = note.categoryID order by noteID DESC");
    return sonuc;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNotes();
    var noteList = List<Note>();
    for (Map map in noteMapList) {
      noteList.add(Note.fromMap(map));
    }
    return noteList;
  }

  Future<int> addNote(Note note) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("note", note.toMap());
    return sonuc;
  }

  Future<int> updateNote(Note note) async {
    var db = await _getDatabase();
    var sonuc = await db.update("note", note.toMap(),
        where: 'noteID = ?', whereArgs: [note.categoryID]);
    return sonuc;
  }

  Future<int> deleteNote(int noteID) async {
    var db = await _getDatabase();
    var sonuc =
        await db.delete("note", where: 'noteID = ?', whereArgs: [noteID]);
    return sonuc;
  }

  String dateFormat(DateTime dt) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneweek = new Duration(days: 7);

    String mounth;
    switch (dt.month) {
      case 1:
        mounth = "Ocak";
        break;
      case 2:
        mounth = "Şubat";
        break;
      case 3:
        mounth = "mart";
        break;
      case 4:
        mounth = "Nisan";
        break;
      case 5:
        mounth = "Mayıs";
        break;
      case 6:
        mounth = "Haziran";
        break;
      case 7:
        mounth = "Temmuz";
        break;
      case 8:
        mounth = "Ağustos";
        break;
      case 9:
        mounth = "Eylül";
        break;
      case 10:
        mounth = "Ekim";
        break;
      case 11:
        mounth = "Kasım";
        break;
      case 12:
        mounth = "Aralık";
        break;
    }

    Duration difference = today.difference(dt);
    if (difference.compareTo(oneDay) < 1) {
      return "Bugün";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Dün";
    } else if (difference.compareTo(oneweek) < 1) {
      switch (dt.weekday) {
        case 1:
          return "Pazartesi";
          break;
        case 2:
          return "Salı";
          break;
        case 3:
          return "Çarşamba";
          break;
        case 4:
          return "Perşembe";
          break;
        case 5:
          return "Cuma";
          break;
        case 6:
          return "Cumartesi";
          break;
        case 7:
          return "Pazar";
          break;
      }
    } else if (dt.year == today.year) {
      return '${dt.day} $mounth';
    } else {
      return '${dt.day} $mounth ${dt.year}';
    }
    return "";
  }
}
