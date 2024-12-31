import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portpolio/widgets/dropdownbutton_test.dart';
import 'package:portpolio/widgets/llm_page.dart';
import 'package:portpolio/widgets/movie_page.dart';
import 'package:portpolio/widgets/pong_page.dart';
import 'package:portpolio/widgets/riverpod_test.dart';

// 페이지들
import 'resume_page.dart';
import 'lotto_page.dart';

// notifier, provider, consumer
// 아 동적으로 위젯을 늘릴려면 클래스를 갖고 있어야 하네 ㅋ. 어떤 책?? 을 만드는 프로그램일경우 해당 페이지를 이루는 위젯을 만들어놓고 동적으로 늘리는 방법을 찾아야겠구나.

final pageIndexProvider = StateProvider<String>((ref) => 'RESUME',);

// 페이지 구성 데이터 
final Map<String, Widget> pageMap = {
  "RESUME" : const ResumePage(),
  "LOTTO" : LottoPage(),
  "LLM" : LLMPage(),
  "PONG GAME" : PongStateful(),
  "MOVIE" : MoviePage(),
  "riverpod TEST" : RiverpodTest1(),
  "dropdownbutton TEST" : DropdownButtonTest(), 
};

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageIndexProvider);   // 변경되면 다시 그림

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Portfolio", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26,),),
      ),
      drawer: Drawer(
        
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              padding: const EdgeInsets.only(left: 26, right: 26, top: 100, bottom: 26),
              child: const Text('목록', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, ), textAlign: TextAlign.end,),
            ),
            ...pageMap.keys.map((toElement) => ListTile(
              title: Text(toElement, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),),
              onTap: (){
                Navigator.pop(context);
                ref.read(pageIndexProvider.notifier).state = toElement;
              },
            )),
          ] 
    
            
        ),
      ),
      body: SafeArea(
        child: Center(
          child: pageMap[pageIndex],
        ),
      ),
    );
  }         
}
