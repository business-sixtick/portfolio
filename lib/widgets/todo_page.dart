import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'
    as path_provider; // flutter pub add path_provider
// import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart'; // flutter pub add sembast
// import 'package:sembast_web/sembast_web.dart';
import 'package:path/path.dart' as path; // flutter pub add path
// import 'package:flutter/foundation.dart';
import 'package:portpolio/sixtick.dart';

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  Bloc<List<Map<String, String>>> note = Bloc([]);
  Database? db;

  @override
  void initState() {
    super.initState();
    // openDatabase().then((onValue){debugPrint('db.path : ${db!.path}');});
  }

  Future<Database> openDatabase() async {
    // get the application documents directory
    final dir = await path_provider.getApplicationDocumentsDirectory();
    // make sure it exists
    await dir.create(recursive: true);
    // debugPrint('dir.path : ${dir.path}');
    // build the database path
    final dbPath = path.join(dir.path, 'note.db');
    // open the database
    return await databaseFactoryIo.openDatabase(dbPath);
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
          db = snapshot.data;
          // debugPrint('db.path : ${db!.path}');
          return Scaffold(
            appBar: AppBar(
              title: const Text('Note'),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            body: StreamBuilder<List<Map<String, String>>>(
                stream: note.stateStream,
                builder: (context, snapshot) {
                  return ListView(
                    children: [],
                  );
                }),
            floatingActionButton: FloatingActionButton(onPressed: (){
              // TODO 등록페이지 
            }),
          );
        });
  }
}


// TODO 등록 페이지


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









