import 'package:flutter/foundation.dart'; // kIsWeb 사용
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'
    as path_provider; // flutter pub add path_provider
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart'; // flutter pub add sembast
import 'package:path/path.dart' as path; // flutter pub add path
import 'package:portpolio/sixtick.dart';
import 'package:sembast_web/sembast_web.dart';

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  Bloc<List<Todo>> note = Bloc([]);
  Database? db;
  var store = intMapStoreFactory.store('todo');

  @override
  void initState()  {
    super.initState();
    // openDatabase().then((onValue){debugPrint('db.path : ${db!.path}');});
    // db = await openDatabase(); // future build 씀씀
  }

  Future<List<Todo>> openDatabase() async {
    // get the application documents directory
    final dir = await path_provider.getApplicationDocumentsDirectory();
    // make sure it exists
    await dir.create(recursive: true);
    debugPrint('dir.path : ${dir.path}');
    // build the database path
    final dbPath = path.join(dir.path, 'todo.db');
    // open the database
    if(kIsWeb){
      db = await databaseFactoryWeb.openDatabase('todo.db'); // 웹일때 
    } else {
      db = await databaseFactoryIo.openDatabase(dbPath);
    }
    debugPrint('openDatabase db : $db');
    var results = await store.find(db as DatabaseClient, finder: Finder(filter: Filter.matches('content', '.*')));
    return results.map<Todo>((value){
      return Todo(id: value.key, content: value.value['content'] as String);
    }).toList();
  }

  @override
  void dispose() {
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
        future: openDatabase(),
        builder: (context, snapshot) {
          // db = snapshot.data;
          // debugPrint('db.path : ${db!.path}');
          note.state = snapshot.data ?? [];

          return Scaffold(
            appBar: AppBar(
              title: const Text('TODO LIST'),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            body: StreamBuilder<List<Todo>>(
                stream: note.stateStream,
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlueAccent, width: 1.0), // 테두리 설정
                          borderRadius: BorderRadius.circular(8.0), // 둥근 모서리
                        ),
                        child: ListTile(
                          title: Text(snapshot.data?[index].content ?? ''),
                          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                          
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.lightBlue), // 수정 아이콘
                                onPressed: () {
                                  // 할 일 수정
                                  // _editTodo(index);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.deepOrangeAccent), // 삭제 아이콘
                                onPressed: () async {
                                  // 삭제 확인 다이얼로그
                                  // _confirmDelete(index);
                                  
                                  int id = note.state.elementAt(index).id;
                                  int key = await store.delete(db as DatabaseClient, finder: Finder(filter: Filter.byKey(id)));
                                  debugPrint('index : $index, id : $id, key : $key'); // 이 key 가 하나 지웠다는 거라서 1만 찍히나?
                                  // if(id == key){
                                  //   debugPrint('index : $index, id : $id, key : $key');
                                  //   note.state.removeAt(index);
                                  //   note.state = note.state;
                                  // }
                                  // 리스트 갱신 
                                  var results = await store.find(db as DatabaseClient, finder: Finder(filter: Filter.matches('content', '.*')));
                                  note.state = results.map<Todo>((value){
                                    return Todo(id: value.key, content: value.value['content'] as String);
                                  }).toList();
                                  
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },);
                  },
                ),
              
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
              String ret = await showDialogText(context, 'TODO');  // 입력 다이얼로그 
              debugPrint('showDialogText ret : $ret');
              // ret 가 빈문자열이면 등록하지 않는다. 
              int index = 0;
              if (ret.isNotEmpty){
                
                // var store = StoreRef.main();
                // var store = StoreRef<String, String>.main();
                
                debugPrint('add button $db');
                // await db!.transaction((action) async {
                //   index = await store.add(action, {'content' : ret});   // 데이터베이스에 추가한다. 
                //   debugPrint('store.add index : $index');
                //   // You can specify a key
                //   // await store.record(10).put(txn, {'name': 'dog'});
                // });
                
                var result = await store.find(db as DatabaseClient, finder: Finder(filter: Filter.matches('content', '.*')));
                // var result2 = await store.record(9).getSnapshot(db as DatabaseClient);
                debugPrint(result.toString());
                // debugPrint(result.first.value.toString());
                // debugPrint(result.first.value['content'] as String?);
                // debugPrint(result2?.value['content'] as String?);
                // debugPrint(result2?.key.toString());

                List<Todo> temp = note.state;  // 기존 상태에 추가한다
                temp.add(Todo(id: index, content: ret));
                note.state = temp;
              }
              
            }),
          );
        });
  }
}

class Todo{
  late int id;
  late String content;
  late int creation;
  late bool finish;
  Todo({required this.id, required this.content, this.finish = false}){
    creation = DateTime.now().millisecond;
  }

  @override
  String toString() {
        return '$id $content $creation $finish';
  }
}

// flutter pub add sembast_web
// flutter pub add sembast_sqflite



// Use regular sembast io (but on the web).
  // var factory = kIsWeb
  //     ? databaseFactoryWeb
  //     : createDatabaseFactoryIo(
  //         rootPath: (Platform.isAndroid
  //             ? (await getApplicationDocumentsDirectory()).path
  //             : p.join(
  //                 '.dart_tool', 'tekartik_notepad_sembast_app', 'databases')));
  // noteProvider = DbNoteProvider(factory);
  // await noteProvider.ready;









