import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'resume_page.dart';

// notifier, provider, consumer
// 아 동적으로 위젯을 늘릴려면 클래스를 갖고 있어야 하네 ㅋ. 어떤 책?? 을 만드는 프로그램일경우 해당 페이지를 이루는 위젯을 만들어놓고 동적으로 늘리는 방법을 찾아야겠구나.

final pageIndexProvider = StateProvider<String>((ref) => 'resume',);

final Map<String, Widget> pageMap = {
  "resume" : ResumePage(),
  "test" : const Text("test")
};

class MainPage extends ConsumerWidget {
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageIndexProvider);   // 변경되면 다시 그림

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Portpolio", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26,),),
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
              title: Text(toElement, textAlign: TextAlign.end,),
              onTap: (){
                Navigator.pop(context);
                ref.read(pageIndexProvider.notifier).state = toElement;
              },
            )),
          ] 
    
            
        ),
      ),
      body: Center(
        child: pageMap[pageIndex],
      ),
    );
  }         
}
