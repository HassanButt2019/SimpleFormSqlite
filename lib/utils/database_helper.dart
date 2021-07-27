import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite_crud/models/contact.dart';


class DatabaseHelper{
  static const _dbName = 'ContactData.db';
  static const _dbVersion = 1;


  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();


  Database _database;

  Future<Database> get database async{
    if(_database != null)
    return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async{
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path , _dbName);
    return await openDatabase(dbPath , version:_dbVersion , onCreate: _onCreateDb);

  }

  _onCreateDb(Database db , int version){
    db.execute(''' 
    CREATE TABLE ${Contact.tableName}(
      ${Contact.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${Contact.nameColumn} TEXT NOT NULL,
      ${Contact.numberColumn} TEXT NOT NULL
    )
    ''');
  }



  Future<int> insertContact(Contact contact) async{
      Database db = await database;
      return await db.insert(Contact.tableName, contact.toMap());

  }

  Future<int> updateContact(Contact contact) async{
      Database db = await database;
      return await db.update(Contact.tableName, contact.toMap() , where: '${Contact.idColumn}=?' , whereArgs: [contact.id]);
  }

  
  Future<int> deleteContact(int id) async{
      Database db = await database;
      return await db.delete(Contact.tableName , where: '${Contact.idColumn}=?' , whereArgs: [id]);
  }

  Future<List<Contact>> fetchContacts() async{
    Database db = await database;


    List<Map> contact = await db.query(Contact.tableName);
   
    return contact.length == 0 ? [] : contact.map((map) => Contact.fromMap(map)).toList();

  }





}