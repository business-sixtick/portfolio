import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// notifier, provider, consumer

class DropdownButtonTest extends ConsumerWidget{
  static List<String> itemList = ['items1','items2','items3','items4','items5','items6','items7','items8','items9','items10'];
  final stateProvider = StateProvider((ref) => 0); 
  final items = itemList.map((value){
          return DropdownMenuItem<String>(
            value: value, // 이거 빼먹었다고 오류난다고??
            child: Text(value),
            );
        }).toList();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int stateItem = ref.watch(stateProvider); // get
    return Center(
      child: DropdownButton(
        value: itemList[stateItem], // 기본값
        // hint: const Text('눌러서 선택하세요.'),
        focusColor: Theme.of(context).colorScheme.primaryContainer,
        items: items,  // 랜더링 버벅대는건 똑같네. 주사율때문에 그런가?? 
        onChanged: (value){
          ref.read(stateProvider.notifier).state = itemList.indexOf(value!); // set
        }),     
    );
  }
}