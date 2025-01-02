import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // flutter pub add path_provider
// import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';  // flutter pub add sembast
import 'package:path/path.dart'; // flutter pub add path




















class TodoDb {
  TodoDb._internal();
  static final TodoDb _singleton = TodoDb._internal();
  factory TodoDb(){ // 싱글톤, 계속 생성해도 같은 객체임
    return _singleton;
  }
  DatabaseFactory dbFactory = databaseFactoryIo;
  final store = intMapStoreFactory.store('todos');

  Database? _database;
  Future<Database> get database async {
    if(_database == null){
      await _openDb().then((db){
        _database = db;
      });
    }
    return _database!;
  }

  Future _openDb() async {
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, 'todos.db');
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }
}


class Todo{
  late int id;
  late String name;
  late String description;
  late String completeBy;
  late int priority; // 우선 순위, 프라이오러티, 프라이오리

  Todo(this.name, this.description, this.completeBy, this.priority);

  Map<String, dynamic> toMap(){
    return{
      'name' : name,
      'description' : description,
      'completeBy' : completeBy,
      'priority' : priority,
    };
  }

  static Todo fromMap(Map<String, dynamic> map){
    return Todo(map['name'], map['description'], map['completeBy'], map['priority']);
  }
}