import 'dart:math';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Bloc<T> {
  Bloc(T initialState) {
    _state = initialState; // 초기 상태 설정
    _stateController = StreamController<T>.broadcast(); // 상태 스트림  broadcast 는 리스너를 여러개 등록할수 있다.
    _stateController.stream.listen((onData) => _state = onData);
  }

  late T _state; // 현재 상태
  late final StreamController<T> _stateController; // 상태 관리 스트림

  // 상태를 외부에서 구독할 수 있는 Stream
  Stream<T> get stateStream => _stateController.stream;

  // 현재 상태를 가져오는 getter
  T get state => _state;

  // 상태를 업데이트하는 메서드
  set state(T newState) {
    // _state = newState; // 상태 업데이트
    _stateController.sink.add(newState); // 새로운 상태를 스트림에 전송
  }

  // 메모리 누수를 방지하기 위해 스트림 닫기
  void dispose() {
    _stateController.close();
  }
}

void showMessage(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK')),
        ],
      );
    }
  );
}

Future<String> showDialogText(BuildContext context, String title) async {
  String text = '';
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          autofocus: true,
          onChanged: (value){ text = value;},
          decoration: const InputDecoration(hintText: '할 일을 입력하세요.'),
          onSubmitted: (value){ // 엔터 쳤을 경우 저장하고 창 닫음. 
            text = value;
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: (){text = ''; Navigator.of(context).pop();},
            child: const Text('CANCEL')
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK')
          ),
        ],
      );
    }
  );

  return text;
}

// Logger

final log = Logger('MyLogger');
void logInit(){
  const bool isProduction = bool.fromEnvironment('dart.vm.product'); // 배포 모드 감지
  print('Logger isProduction : $isProduction');
  if (isProduction) {
    Logger.root.level = Level.OFF; // 모든 로그 비활성화
  } else {
    Logger.root.level = Level.ALL; // 개발 모드에서는 모든 로그 활성화
  }
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

Future<void> linkUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    log.warning('Could not launch $url');
  }
}


// Lotto
List<int> drawLotto(List<int> sample, {int count = 6, bool sort = true}){
  Set ret = {};
  // log.info('drawLotto sample : $sample');
  while (ret.length < count) {
    int pick = sample.popShuffle();
    // log.info('drawLotto pick : $pick');
    ret.add(pick);
  }
  if (sort){
    return ret.toList().cast<int>()..sort();
  }
  return ret.toList().cast();
}


// extension

extension ListkExtension<T> on List<T> {
  T popRandom(){ 
    return removeAt(Random().nextInt(length));
  }

  /// - 리스트를 섞어서 한개를 뽑는다. 
  /// - duplicate : false 면 뽑은 대상이 리스트에 존재하면 삭제한다. 
  T popShuffle({bool duplicate = false}){ 
    // log.info('popShuffle before : $this');
    shuffle(Random());
    // log.info('popShuffle shuffle after : $this');
    T pick = popRandom();
    if(!duplicate){
      remove(pick);
    }
    return pick;
  }
}

