import 'package:crypto_prices/data/models/asset.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DatabaseController {
  late Database _db;
  bool initialized = false;
  static const String databaseName = 'cc.db';
  static const int version = 1;

  Future<Database> get db async {
    if (initialized) {
      return _db;
    }
    _db = await initDB();
    initialized = true;
    return _db;
  }

  initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, databaseName);
    var db = await openDatabase(
      path,
      version: version,
      onCreate: _onCreate,
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE FavoriteItem (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        currencyName TEXT NOT NULL,
        currencySymbol TEXT NOT NULL,
        userID INTEGER NOT NULL
        )''');
    await db.execute('''CREATE TABLE NotificationSetting (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        currencyName TEXT NOT NULL,
        currencySymbol TEXT NOT NULL,
        criteria TEXT NOT NULL,
        criteriaPercent DECIMAL(10,2) NOT NULL,
        userID INTEGER NOT NULL,
        screenID INTEGER NOT NULL,
        FOREIGN KEY(screenID) REFERENCES FavoriteItem(id) ON DELETE SET NULL
        )''');
  }

  void deleteDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, databaseName);
    await deleteDatabase(path);
  }

  Future<int> addNotificationSetting(
    String name,
    String symbol,
    String criteria,
    double criteriaPercent,
    int userID,
    int screenID,
  ) async {
    var dbClient = await db;
    var response = await dbClient.rawInsert(
      'INSERT INTO NotificationSetting(currencyName, currencySymbol, criteria, criteriaPercent, userID, screenID) VALUES(?, ?, ?, ?, ?, ?);',
      [name, symbol, criteria, criteriaPercent, userID, screenID],
    );
    return response;
  }

  Future<List<Map<String, dynamic>>> getNotificationSettings(
      int userID, int screenID) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      'SELECT * FROM NotificationSetting WHERE NotificationSetting.userID = ? AND NotificationSetting.screenID = ?;',
      [userID, screenID],
    );
    return response;
  }

  Future<int> addFavoriteItem(Asset asset, int userID) async {
    var dbClient = await db;
    var response = await dbClient.rawInsert(
      'INSERT INTO FavoriteItem(currencyName, currencySymbol, userID) VALUES(?, ?, ?);',
      [asset.name, asset.symbol, userID],
    );
    return response;
  }

  Future<int> addFavoriteItemSymbol(
      String name, String symbol, int userID) async {
    var dbClient = await db;
    var response = await dbClient.rawInsert(
      'INSERT INTO FavoriteItem(currencyName, currencySymbol, userID) VALUES(?, ?, ?);',
      [name, symbol, userID],
    );
    return response;
  }

  Future<List<Map<String, dynamic>>> getFavoriteItems(int userID) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      'SELECT * FROM FavoriteItem WHERE FavoriteItem.userID = ?;',
      [userID],
    );
    return response;
  }

  Future<int> removeFavoriteItem(Asset asset, int userID) async {
    var dbClient = await db;
    var response = await dbClient.rawDelete(
      'DELETE FROM FavoriteItem WHERE FavoriteItem.currencySymbol = ? AND FavoriteItem.userID = ?;',
      [asset.symbol, userID],
    );
    return response;
  }

  Future<int> removeFavoriteItemSymbol(String symbol, int userID) async {
    var dbClient = await db;
    var response = await dbClient.rawDelete(
      'DELETE FROM FavoriteItem WHERE FavoriteItem.currencySymbol = ? AND FavoriteItem.userID = ?;',
      [symbol, userID],
    );
    return response;
  }

  Future<bool> checkForFavoriteItem(Asset asset) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      'SELECT * FROM FavoriteItem WHERE FavoriteItem.currencySymbol = ?;',
      [asset.symbol],
    );

    if (response.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkForFavoriteItemSymbol(String symbol) async {
    var dbClient = await db;
    var response = await dbClient.rawQuery(
      'SELECT * FROM FavoriteItem WHERE FavoriteItem.currencySymbol = ?;',
      [symbol],
    );

    if (response.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<int> deleteNotificationSettings(String symbol) async {
    var dbClient = await db;
    var delete = await dbClient.rawDelete(
      "DELETE FROM NotificationSetting WHERE currencySymbol = ?;",
      [symbol],
    );
    return delete;
  }

  Future<int> deleteNotificationSettingByID(int id) async {
    var dbClient = await db;
    var delete = await dbClient.rawDelete(
      "DELETE FROM NotificationSetting WHERE id = ?;",
      [id],
    );
    return delete;
  }
}
