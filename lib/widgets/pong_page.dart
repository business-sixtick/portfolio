import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CustomTickerProvider extends TickerProvider{//
//   @override
//   Ticker createTicker(TickerCallback onTick) {
//     return Ticker(onTick);
//   }
// }
enum Direction { up, down, left, right }

double speed = 5;

class StateNotifierBegin extends StateNotifier<double> {
  StateNotifierBegin() : super(0); // 초기값
  void increment() => state = state + speed;
  void decrement() => state = state - speed;
  void setState(value) => state = value;
}

class StateNotifierEnd extends StateNotifier<double> {
  StateNotifierEnd() : super(0); // 초기값
  void increment() => state = state + speed;
  void decrement() => state = state - speed;
  void setState(value) => state = value;
}

class PongStateful extends ConsumerStatefulWidget {
  const PongStateful({super.key});

  @override
  ConsumerState<PongStateful> createState() {
    return _PongState();
  }
}

class _PongState extends ConsumerState<PongStateful>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  // late TickerProvider tickerProvider;
  late double posX = 0;
  late double posY = 0;
  late double width;
  late double height;
  late double batPosition;

  Direction vDir = Direction.down;
  Direction hDir = Direction.right;

  final stateProviderBegin = StateNotifierProvider<StateNotifierBegin, double>(
      (ref) => StateNotifierBegin());
  final stateProviderEnd = StateNotifierProvider<StateNotifierEnd, double>(
      (ref) => StateNotifierEnd());
  final stateProviderVDir = StateProvider<Direction>((ref) => Direction.down);
  final stateProviderHDir = StateProvider<Direction>((ref) => Direction.right);
  final stateProviderBatPosition = StateProvider<double>((ref) => 100);

  void checkBorders() {
    if (posX <= 0 && hDir == Direction.left) {
      ref.read(stateProviderHDir.notifier).state = Direction.right;
    }

    if (posX >= width - 50 && hDir == Direction.right) {
      ref.read(stateProviderHDir.notifier).state = Direction.left;
    }

    if (posY >= height - 50 - 25 && vDir == Direction.down) {
      // 막대기 체크
      if (posX >= (batPosition - 50 + 25) && posX <= (batPosition + 100 - 25)) {
        ref.read(stateProviderVDir.notifier).state = Direction.up;
      } else {
        controller.stop();
        // controller.dispose();
        showDialog(
          context: context,
          // barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('YOU LOSE'),
              content: const Text('다시 시작할까요?'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      posY = 100;
                      
                        ref.read(stateProviderEnd.notifier).setState(100.0);
                      

                      // ref.read(stateProviderBegin.notifier).setState(100);
                      Navigator.pop(context);
                      // controller.reset();
                      controller.repeat();
                    },
                    child: const Text('네')),
              ],
            );
          },
        );
      }

      // vDir = Direction.up;
    }

    if (posY <= 0 && vDir == Direction.up) {
      ref.read(stateProviderVDir.notifier).state = Direction.down;
      // vDir = Direction.down;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      try {
      hDir == Direction.right
          ? ref.read(stateProviderBegin.notifier).increment()
          : ref.read(stateProviderBegin.notifier).decrement();
      vDir == Direction.down
          ? ref.read(stateProviderEnd.notifier).increment()
          : ref.read(stateProviderEnd.notifier).decrement();
      
        checkBorders();
      } catch (e) {
        debugPrint('animation.addListener : $e');
        dispose();
      }
    });
    controller.forward();
  }

  void moveBat(DragUpdateDetails update) {
    // if (batPosition <= 0 || batPosition >= width) return;
    ref.read(stateProviderBatPosition.notifier).state =
        batPosition + update.delta.dx;
  }

  @override
  Widget build(BuildContext context) {
    posX = ref.watch(stateProviderBegin);
    posY = ref.watch(stateProviderEnd);
    vDir = ref.watch(stateProviderVDir);
    hDir = ref.watch(stateProviderHDir);
    batPosition = ref.watch(stateProviderBatPosition);

    return LayoutBuilder(
      builder: (context, constraints) {
        width = constraints.maxWidth;
        height = constraints.maxHeight;
        return Stack(
          children: [
            Positioned(
              top: posY,
              left: posX,
              child: const Ball(),
            ),
            Positioned(
              bottom: 0,
              left: batPosition,
              child: GestureDetector(
                onHorizontalDragUpdate: (update) {
                  moveBat(update);
                },
                child: const Bat(100, 25),
              ),
            ),
            Positioned(
              top: 0,
              child: Text('posX : $posX'),
            ),
            Positioned(
              top: 0,
              left: 100,
              child: Text('posY : $posY'),
            ),
            Positioned(
              top: 0,
              left: 200,
              child: Text('width : $width'),
            ),
            Positioned(
              top: 0,
              left: 300,
              child: Text('height : $height'),
            ),
            Positioned(
              top: 20,
              left: 0,
              child: Text('vDir : $vDir'),
            ),
            Positioned(
              top: 20,
              left: 150,
              child: Text('hDir : $hDir'),
            ),
          ],
        );
      },
    );
  }
}

// class Pong extends ConsumerWidget{  // ref 를 빌드 밖에서 쓸수 없음.
//   late Animation<double> animation;
//   late AnimationController controller;
//   late TickerProvider tickerProvider;

//   final stateProviderBegin = StateNotifierProvider<StateNotifierBegin, double>((ref) => StateNotifierBegin());
//   final stateProviderEnd = StateNotifierProvider<StateNotifierEnd, double>((ref) => StateNotifierEnd());

//   Pong({super.key}){
//     tickerProvider = CustomTickerProvider();//
//     controller = AnimationController(
//       vsync: tickerProvider,
//     );
//     animation = Tween<double>(begin: 0, end: 100).animate(controller);
//     animation.addListener((){

//     });
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return LayoutBuilder(
//       builder: (context, constraints){
//         return Stack(
//           children: [
//             Positioned(
//               child: Ball(),
//               top: 0,
//             ),
//             Positioned(
//               child: Bat(100,25),
//               bottom: 0,
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

class Bat extends StatelessWidget {
  final double width;
  final double height;
  const Bat(this.width, this.height, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(color: Colors.blue),
    );
  }
}

class Ball extends StatelessWidget {
  const Ball({super.key});

  @override
  Widget build(BuildContext context) {
    const double diam = 50;
    return Container(
      width: diam,
      height: diam,
      decoration: const BoxDecoration(
        color: Colors.amber,
        shape: BoxShape.circle,
      ),
    );
  }
}
