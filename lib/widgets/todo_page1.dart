import 'package:flutter/foundation.dart'; // kIsWeb 사용
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'
    as path_provider; // flutter pub add path_provider
import 'package:path/path.dart' as path; // flutter pub add path
import 'package:portpolio/sixtick.dart';
import 'package:shared_preferences/shared_preferences.dart';// flutter pub add shared_preferences

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  Bloc<List<Todo>> note = Bloc([]);
  // Obtain shared preferences.
  // late SharedPreferences prefs;
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  @override
  void initState()  {
    super.initState();
    // openDatabase().then((onValue){debugPrint('db.path : ${db!.path}');});
    // db = await openDatabase(); // future build 씀
  }

  Future<List<Todo>> openDatabase() async {
    // prefs = await SharedPreferences.getInstance();
    
    debugPrint('openDatabase db : $prefs');

    List<String>? list = await prefs.getStringList('todo');
    debugPrint('list : $list');
    if (list != null && list.isNotEmpty){
      debugPrint('list exist');
      List<Todo> ret = [];
      for (var element in list) {
        ret.add(Todo(creation: int.parse(element.split(',')[0]), content: element.split(',')[1], finish: bool.parse(element.split(',')[2]) ));
      }
      return ret;
    }
    debugPrint('list not exist');
    return [];
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
                                  debugPrint('delete button index : $index');
                                  
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
              if (ret.isNotEmpty){

                List<Todo> temp = note.state;  // 기존 상태에 추가한다
                temp.add(Todo(creation: DateTime.now().millisecond, content: ret)); // 신규 추가
                await prefs.setStringList('todo', Todo.toStringList(temp)); // db 업데이트
                note.state = temp; // 스테이트 업데이트
              }
              
            }),
          );
        });
  }
}

class Todo{
  late String content;
  late int creation;
  late bool finish;
  Todo({required this.creation, required this.content, this.finish = false});

  @override
  String toString() {
        return '$creation,$content,$finish';
  }

  static List<String> toStringList(List<Todo> list){
    if (list.isNotEmpty){
      List<String> ret = [];
      for (var element in list) {
        ret.add(element.toString());
      }
    }
    return [];
  }
}




