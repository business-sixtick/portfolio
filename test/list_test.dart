import 'dart:math';
// import '../lib/sixtick.dart';
import 'package:portpolio/sixtick.dart';

void main(){
  logInit();
  var list = [1,1,1,1,2,2,3,3,4,4,5,5];
  log.info(list.popShuffle());
  log.info(list);

  list = List.generate(45, (i) => i + 1);
  log.info(drawLotto(list));
}




// 기본적으로 