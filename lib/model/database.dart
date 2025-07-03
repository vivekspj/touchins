import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final userTable = 'User';

  static final columnFullName = 'FullName';
  static final columnEmail = 'Email';
  static final columnDob = 'DOB';
  static final columnPassword = 'Password';
  static final columnCountry = 'Country';
  static final columnCounty = 'County';
  static final columnCity = 'City';
  static final columnStreet = 'Street';
  static final columnCredit = 'Credit';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $userTable ($columnFullName TEXT NOT NULL,"
        "$columnEmail TEXT PRIMARY KEY,$columnDob TEXT NOT NULL,$columnPassword TEXT NOT NULL,"
        "$columnCountry TEXT NOT NULL,$columnCounty TEXT NOT NULL,"
        "$columnCity TEXT NOT NULL,$columnStreet TEXT NOT NULL,$columnCredit TEXT NOT NULL)"
    );
  }
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(userTable, row);
  }
  String whereString = '${DatabaseHelper.columnEmail} = ?';
  Future<List<Map<String, dynamic>>> queryAllRows(String email) async {
    Database db = await instance.database;
    return await db.query(userTable,where: '${DatabaseHelper.columnEmail} = ?',whereArgs: [email] );
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row,String email) async {
    Database db = await instance.database;
    return await db.update(userTable, row, where: '$columnEmail = ?', whereArgs: [email]);
  }

  Future<void> delete(String email) async {
    Database db = await instance.database;
    return await db.delete(userTable, where: '$columnEmail = ?', whereArgs: [email]);
  }
}