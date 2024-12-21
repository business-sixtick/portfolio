
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';


import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:cp949_codec/cp949_codec.dart' as cp949;
import 'dart:io' as io;
// notifier , provider, consumer

final lottoProvider = StateProvider((ref) => drawWin());
final nowTurnProvider = StateProvider<int?>((ref) => null);
final lottoListProvider = StateProvider<List<List<int>>>((ref) => []);

class LottoPage extends ConsumerWidget {
  const LottoPage({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final size = MediaQuery.of(context).size;
    List<int> wins = ref.watch(lottoProvider);
    int? nowTurn = ref.watch(nowTurnProvider);
    List<List<int>> lottoList = ref.watch(lottoListProvider);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'LOTTO',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
            Divider(
              height: 20,
              thickness: 10,
              indent: 50,
              endIndent: 50,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            const SizedBox(height: 20,),
            const Text(
              '추천 번호',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(flex: 1, child: Container()),
                  ...wins.map((win) {
                  return Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(5, 5), // 그림자의 위치
                              ),
                            ],
                            color: ballColor(win),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Center(
                                  child: Text(win.toString(),
                                      style: TextStyle(
                                          fontSize: constraints.maxWidth * 0.7,
                                          fontWeight: FontWeight.bold)));
                            },
                          )));
                }),
                Expanded(flex: 1, child: Container()),
                ]
              ),
            ),
            Divider(
              height: 20,
              thickness: 10,
              indent: 50,
              endIndent: 50,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  const Text(
                    '당첨 리스트',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 450,
                    child: FutureBuilder(
                      future: lottoList.length >= 10 ? Future.value(lottoList) :getWinsTen(nowTurn),
                      // future: getWinsTen(nowTurn),
                      builder: (context, snapshot) {
                        // 화면에 넘치면 스탑
                        // 우선 10개만
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                              // 안전한 데이터 처리
                              debugPrint('${snapshot.data!}');
                          lottoList = snapshot.data!;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // 위젯 트리가 빌드된 후 상태를 안전하게 업데이트
                            ref.read(lottoListProvider.notifier).state = snapshot.data!;
                          });
                          // ref.read(lottoListProvider.notifier).state = snapshot.data!;
                          // ref.read(nowTurnProvider.notifier).state = lottoList.isNotEmpty ? lottoList.last[0] : null;
                            }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator()); // 로딩 인디케이터
                        } else if (snapshot.hasError) {
                          return Center(child: Text('FutureBuilder Error: ${snapshot.error}')); // 에러 처리
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No Data Found')); // 데이터 없음 처리
                        }
                        
                        
                        // 데이터를 성공적으로 가져왔을 때 ListView 표시
                        return ListView.builder(
                          itemCount: lottoList.length,
                          itemBuilder: (context, index) {
                            debugPrint('itemBuilder index : $index');
                            DateTime day = DateTime.fromMillisecondsSinceEpoch(lottoList[index][1]);
                            return Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.primaryContainer), borderRadius: BorderRadius.all(Radius.elliptical(20, 20))),
                              child: ListTile(
                                title: Text('${lottoList[index][0]}회  추첨일 : ${day.year}년 ${day.month}월 ${day.day}일', textAlign: TextAlign.center,),
                                subtitle: Text('${lottoList[index][2]} ${lottoList[index][3]} ${lottoList[index][4]} ${lottoList[index][5]} ${lottoList[index][6]} ${lottoList[index][7]} + ${lottoList[index][8]}',
                                  style: TextStyle(fontSize: 26), textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(right: 50, bottom: 100),
          child: ElevatedButton(
              style: ButtonStyle(
                elevation: WidgetStateProperty.all(10),
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.inversePrimary),
              ),
              onPressed: () {
                ref.read(lottoProvider.notifier).state = drawWin();

                debugPrint('getFromHomepageWins : ${getFromHomepageWins(null).then((onValue)=>debugPrint('getFromHomepageWins then $onValue'))}');
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  var iconSize = constraints.maxWidth * 0.15;
                  return Icon(Icons.add, size: iconSize);
                }
              )),
        ),
        
      ),
    );
  }
}

Future<List<List<int>>> getWinsTen(int? turnNum) async {
  List<List<int>> list = [];
  List<int> wins = [];
  for (int i = 0; i < 10; i++){
    wins = await getFromHomepageWins(turnNum);
    list.add(wins);
    turnNum = wins[0] - 1;
  }
  return list;
}

/// 모바일 페이지에서 크롤링 하기
  Future<List<int>> _getWinsForAndroid(int? turnNum) async {
    // turnNum = 1144;
    var address = 'm.dhlottery.co.kr';
    var url = Uri.https(address, 'gameResult.do',{'method': 'byWin'});
    var response = await http.post(
        url,
        body: {'drwNo': '$turnNum', 'hdrwComb': '1', 'dwrNoList' : '$turnNum'}
    );
    debugPrint('response.statusCode : ${response.statusCode}');
    // debugPrint('${response.body}');
    var regex = RegExp(r'\d+');
    var document = html.parse(cp949.cp949.decode(response.bodyBytes));
    // debugPrint(document.outerHtml);
    // var date = document.querySelector('#dwrNoList :first-child')?.text.trim();
    var date = document.querySelector('#dwrNoList [selected]')?.text.trim();
    debugPrint(date.toString());

    var date1 = date?.split(' ').map((e) =>  regex.allMatches(e).map((m) => m.group(0))).toList();
    debugPrint(date1.toString());
    var date2 = date1?.toList();
    debugPrint(date2?[0].toString());

    debugPrint(date2?[0].toList()[0].toString());
    debugPrint(date2?[0].toList()[1].toString());
    debugPrint(date2?[1].toList()[0].toString());
    debugPrint(date2?[2].toList()[0].toString());

    int turn = int.parse(date2?[0].toList()[0] ?? '');
    int year = int.parse(date2?[0].toList()[1] ?? '');
    int month = int.parse(date2?[1].toList()[0] ?? '');
    int  day= int.parse(date2?[2].toList()[0] ?? '');

    List<int> win = document.querySelectorAll('span.ball').map((element)=> int.parse(element.text)).toList();

    return <int>[turn, DateTime(year, month, day).millisecondsSinceEpoch] + win;
  }

Future<List<int>> getFromHomepageWins(int? turnNum) async {
  if(kIsWeb){
    
  }else{ // 웹환경이 아닐때
    if (io.Platform.isAndroid){
      return _getWinsForAndroid(turnNum);
    }
  }
    
    var address = 'dhlottery.co.kr';
    // debugPrint('io.Platform.operatingSystem : ${io.Platform.operatingSystem.toString()}');
    debugPrint("getFromHomepageWins");
    var url = Uri.https(address, 'gameResult.do',{'method': 'byWin'});
    debugPrint("getFromHomepageWins 1");
    var response = await http.post( // XMLHttpRequest error // 브라우저 에서 크롤링이 안되네 ㅠㅠ TODO api 서버를 만들어서 운영해야겠음.
      url, 
      body: {'drwNo': '$turnNum', 'hdrwComb': '1', 'dwrNoList' : '$turnNum'}
      );
    debugPrint("getFromHomepageWins 2");
    debugPrint('response.statusCode : ${response.statusCode}');
    // debugPrint('${response.body}');
    var regex = RegExp(r'\d+');
    var document = html.parse(cp949.cp949.decode(response.bodyBytes));
    // debugPrint(document.outerHtml);
    var date = document.querySelector('p.desc')?.text;
    debugPrint(date.toString());
    var date1 = date?.split(' ').map((e) =>  regex.allMatches(e).map((m) => m.group(0))).toList();
    debugPrint(date1.toString());
    int year = int.parse(date1?[0].toList().join() ?? '');
    int month = int.parse(date1?[1].toList().join() ?? '');
    int  day= int.parse(date1?[2].toList().join() ?? '');
    
    String turn = regex.allMatches(document.querySelector('h4')?.text ?? '').map((e) => e.group(0)).toList().join();
    
    List<int> win = document.querySelectorAll('span.ball_645').map((element)=> int.parse(element.text)).toList();
    
    return <int>[int.parse(turn), DateTime(year, month, day).millisecondsSinceEpoch] + win;
  } // end getFromHomepageWins

/// 추천 번호 리스트를 반환한다.
List<int> drawWin() {
  Set<int> win = {};
  // var numList = List.generate(45, (index) => index + 1);
  while (win.length < 6) {
    int num = math.Random().nextInt(45) + 1;
    win.add(num);
  }
  List<int> wins = win.toList();
  wins.sort();
  debugPrint('drawWin : $wins');
  return wins;
}

/// 번호에 따라 색깔을 반환한다
Color ballColor(int num) {
  Color? color = Colors.grey;
  if (num < 11) {
    color = Colors.orange[300];
  } else if (num < 21) {
    color = Colors.lightBlue[300];
  } else if (num < 31) {
    color = Colors.red[300];
  } else if (num < 41) {
    color = Colors.grey[400];
  } else {
    color = Colors.green[300];
  }
  return color ?? Colors.grey;
}
