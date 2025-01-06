import 'package:flutter/material.dart';
import 'package:portpolio/sixtick.dart';

// BLoC 훨 씬 깔끔하네

class BlocTestPage extends StatefulWidget{    // StatefulWidget 를 써야됨

  @override
  State<BlocTestPage> createState() => _BlocTestPageState();
}

class _BlocTestPageState extends State<BlocTestPage> {
  Bloc<int> countBloc = Bloc<int>(0);
  Bloc<int> countBloc2 = Bloc<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('StreamController + StatefulWidget + StreamBuilder'),
          StreamBuilder( // bloc 는 기본적으로 스트림을 쓴다. 자동으로 리빌드한다
            stream: countBloc.stateStream, 
            initialData: countBloc.state,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
              return  Center(child: Text(snapshot.data.toString(), style: TextStyle(fontSize: 32),));
            }
          ),
          StreamBuilder( // bloc 는 기본적으로 스트림을 쓴다. 자동으로 리빌드한다
            stream: countBloc2.stateStream, 
            initialData: countBloc2.state,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
              return  Center(child: Text(snapshot.data.toString(), style: TextStyle(fontSize: 32),));
            }
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: (){debugPrint('countBloc : ${countBloc.state.toString()}'); countBloc.state = countBloc.state + 1;}, 
            
            child: const Icon(Icons.add)),
          SizedBox(height: 10,),
          FloatingActionButton(
            onPressed: (){debugPrint('countBloc2 : ${countBloc2.state.toString()}'); countBloc2.state = countBloc2.state + 1;}, 
            
            child: const Icon(Icons.add)),
        ],
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    countBloc = Bloc<int>(0);
  }

  @override
  void dispose() {
    countBloc.dispose();
    super.dispose();
  }
}


