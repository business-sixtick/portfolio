import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

// notifier , provider, consumer

final lottoProvider = StateProvider((ref) => drawWin());

class LottoPage extends ConsumerWidget {
  const LottoPage({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final size = MediaQuery.of(context).size;
    List<int> wins = ref.watch(lottoProvider);
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
              child: Text('당첨 리스트'),
            ),
          ],
        ),
        floatingActionButton: ElevatedButton(
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(10),
              backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.inversePrimary),
            ),
            onPressed: () {
              ref.read(lottoProvider.notifier).state = drawWin();
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                var iconSize = constraints.maxWidth * 0.15;
                return Icon(Icons.add, size: iconSize);
              }
            )),
      ),
    );
  }
}

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
