import 'dart:math';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';




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

