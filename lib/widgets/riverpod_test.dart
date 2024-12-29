import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stateProvider1 = StateProvider<int>((ref) => 1);
final stateProvider2 = StateProvider<int>((ref) => 2);

class RiverpodTest1 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Piece0(),
          const Piece1(),
          Piece2(),
          piece3(),
          piece3(),
          const Text('onTap 되면 상태가 바뀌면서 리랜더링 된다. '),
          const Text('랜더링 될때 보더에 에니메이션이 작동되게 하였다. '),
          const Text('프로바이더를 공유하면 리랜더링도 같이 된다.'),
          const Text('watch 는 build에 독립적으로 있어야 랜더링에 부하가 덜 할것같다.'),
          const Text('프로바이더를 공유하면 리랜더링도 같이 된다.'),
        ],
      ),
    );
  }
}

class Piece0 extends ConsumerWidget{

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int consumer1 = ref.watch(stateProvider1);
    int consumer2 = ref.watch(stateProvider2);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: Text(consumer1.toString(), textAlign: TextAlign.center,),
            subtitle: AnimationTextbox(text: 'Piece0 sub1 stateProvider1', id: 1,),
            onTap: () {
              ref.read(stateProvider1.notifier).state = consumer1 + 1;
            },
          ),
          ListTile(
            title: Text(consumer2.toString(), textAlign: TextAlign.center,),
            subtitle: AnimationTextbox(text: 'Piece0 sub2 stateProvider2', id: 2),
            onTap: () {
              ref.read(stateProvider2.notifier).state = consumer2 + 1;
            },
          ),
        ],
      ),
    );
  }
}

class AnimationTextbox extends ConsumerWidget{
  AnimationTextbox({required this.text, required this.id, super.key});
  late int id;
  late String text;
  final stateProvider = StateProvider.family<int, int>((ref, name) => 1);
  List<double> tweenList = [0, 1];
  List<Color> colorList = [Colors.purple[100] ?? Colors.purple, Colors.purple[400] ?? Colors.purple];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int state = ref.watch(stateProvider(id));
    debugPrint('id : $id, state : ${state.toString()}');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TweenAnimationBuilder(
        tween: Tween(begin: tweenList[0], end: tweenList[state]),  // 상위 위젯에서 다시 그려질때 1로 다시 초기화됨
        duration: const Duration(milliseconds: 50), 
        builder: (context, value, child){
          return AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            decoration: BoxDecoration(
              // border: Border.all(color: state == 0 ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.primary, width: value),
              border: Border.all(color: colorList[value.toInt()], width: 4),// value 를 꼭 써야 에니메이션이 발동하네
            ),
            child: Text(text, textAlign: TextAlign.center,),
            onEnd: (){debugPrint('onEnd : $state id : $id'); ref.read(stateProvider(id).notifier).state = 0;},
          );
        }),
    );
  }
}



class Piece1 extends ConsumerWidget{
  const Piece1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int consumer1 = ref.watch(stateProvider1);
    return ListTile(
            title: Text(consumer1.toString(), textAlign: TextAlign.center,),
            subtitle: AnimationTextbox(text: 'Piece1 stateProvider1', id: 3),
            onTap: () {
              ref.read(stateProvider1.notifier).state = consumer1 + 1;
            },
          );
  }
}

class Piece2 extends ConsumerWidget{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int consumer2 = ref.watch(stateProvider2);
    return ListTile(
            title: Text(consumer2.toString(), textAlign: TextAlign.center,),
            subtitle: AnimationTextbox(text: 'Piece2 stateProvider2', id: 4),
            onTap: () {
              ref.read(stateProvider2.notifier).state = consumer2 + 1;
            },
          );
  }
}

class piece3 extends ConsumerWidget{
  final stateProvider = StateProvider((ref) => 0);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int consumer = ref.watch(stateProvider);
    return ListTile(
            title: Text(consumer.toString(), textAlign: TextAlign.center,),
            subtitle: AnimationTextbox(text: 'Piece3 stateProvider', id: 5),
            onTap: () {
              ref.read(stateProvider.notifier).state = consumer + 1;
            },
          );
  }
}