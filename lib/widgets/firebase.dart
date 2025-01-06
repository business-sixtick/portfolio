// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // flutter pub add cloud_firestore
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart'; //flutter pub add firebase_auth

// 파이어 베이스의 기능들 firebase (서버측 기능들을 담고있다. https://console.firebase.google.com) 내부적으로 구글클라우드 프로젝트를 생성함
// spark 요금제 (무료료)
// 인증 authentication
// 저장소 storage
// 데이터베이스 databases (firestore )
// 알림 notifications
// 호스팅 hosting

// 플러터 앱에 firebase 추가 하기
// https://firebase.tools/bin/win/instant/latest  // 윈도우용 firebase cli 실행 // firebase login  // firebase projects:list
// 또는 npm install -g firebase-tools  (글로벌로 설치하는게 낫겠네)
// flutter pub add firebase_core
// dart pub global activate flutterfire_cli  // flutterfire cli 설치 C:\Users\sixtick3\AppData\Local\Pub\Cache\bin
// flutterfire configure --project=portfolio-v1-5e59d  // 이렇게 하면 플랫폼별 앱이 Firebase에 자동으로 등록되고 lib/firebase_options.dart 구성 파일이 Flutter 프로젝트에 추가됩니다.
// C:\Users\sixtick3\AppData\Local\Pub\Cache\bin\flutterfire configure --project=portfolio-v1-5e59d

// 플러그인에 대한정보
// https://firebase.google.com/docs/flutter/setup?hl=ko&authuser=1&_gl=1*7cfwb5*_ga*MTE5OTYxNTE4Mi4xNzMxNTQ0NDE5*_ga_CW55HF8NVT*MTczNTc3NjQyMi4xNy4xLjE3MzU3Nzg4MjYuNjAuMC4w&platform=ios#available-plugins

// 플러터 앱에 authentication 인증 추가하기
// 프로젝트 개요에서 authentication 클릭 , 시작하기

class Firebase extends ConsumerWidget {
  final provierList = StateProvider<List<EventDetail>>((ref) => []);
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<EventDetail> stateList = ref.watch(provierList);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('firebase'),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: TextFormField(
                      controller: controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Enter your Email',
                        hintText: 'name@gmail.com',
                        icon: Icon(Icons.mail),
                      ),
                      validator: (text) => text == null || text.isEmpty
                          ? 'Email is required'
                          : null,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: TextFormField(
                      controller: controllerPassword,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true, // 글자 감춤
                      decoration: InputDecoration(
                        labelText: 'Enter your Password',
                        hintText: '6자리 이상',
                        icon: Icon(Icons.enhanced_encryption),
                      ),
                      validator: (text) =>
                          text == null || text.isEmpty || text.length < 6
                              ? 'Password is required'
                              : null,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // 검증
                          // signIn(controllerEmail.text, controllerPassword.text)
                          //     .then((onValue) => showMessage(context,
                          //         onValue.keys.first, onValue.values.first));
                          debugPrint('signIn onPressed');
                        } else {
                          debugPrint('signIn onPressed else');
                          return;
                        }
                      },
                      child: const Text('signIn'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // 검증
                          // signUp(controllerEmail.text, controllerPassword.text)
                          //     .then((onValue) => showMessage(context,
                          //         onValue.keys.first, onValue.values.first));
                          debugPrint('signUp onPressed');
                        } else {
                          debugPrint('signUp onPressed else');
                          return;
                        }
                      },
                      child: const Text('signUp'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: ElevatedButton(
                      onPressed: () {
                        // logout();
                      },
                      child: const Text('logout'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: ElevatedButton(
                      onPressed: () {
                        // isLogin();
                      },
                      child: const Text('check'),
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(child: Text('hi')),

            Expanded(
              child: ListView(
                children: stateList.map((value) {
                  return ListTile(
                    title: Text(value.description),
                    subtitle: Text('date : ${value.date}'),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
          onPressed: () {
            // testData();
            // getEventDetails().then(
            //     (onValue) => ref.read(provierList.notifier).state = onValue);
            debugPrint('getEventDetails onPressed');
          },
          child: const Text('ok')),
    ));
  }
}

// void isLogin() {
//   debugPrint(FirebaseAuth.instance.currentUser == null
//       ? ''
//       : FirebaseAuth.instance.currentUser!.email.toString());
// }

// Future<void> logout() async {
//   try {
//     await FirebaseAuth.instance.signOut();
//     debugPrint('logOut');
//   } catch (e) {
//     debugPrint('logOut catch $e');
//   }
// }

// Future<Map<String, String>> signIn(String emailAddress, String password) async {
//   try {
//     // setState(() => _loading = true); // 로딩 시작
//     UserCredential userCredential =
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: emailAddress,
//       password: password,
//     );

//     final user = userCredential.user;

//     return {'ok': '${user!.email} 환영합니다.'};
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'user-not-found') {
//       return {'error': '사용자가 존재하지 않습니다.'};
//     } else if (e.code == 'wrong-password') {
//       return {'error': '비밀번호가 잘못되었습니다.'};
//     } else {
//       return {'error': '${e.message}'};
//     }
//   } catch (e) {
//     return {'error': e.toString()};
//   }
// }

// Future<Map<String, String>> signUp(String emailAddress, String password) async {
//   try {
//     final credential =
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: emailAddress,
//       password: password,
//     );
//     debugPrint('signUp credential : ${credential.toString()}');
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'weak-password') {
//       return {'error': 'The password provided is too weak.'};
//     } else if (e.code == 'email-already-in-use') {
//       return {'error': 'The account already exists for that email.'};
//     }
//   } catch (e) {
//     debugPrint('catch : ${e.toString()}');
//     return {'error': e.toString()};
//   }
//   return {'ok': 'create account'};
// }

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

class User {
  bool _isLogin = true;
  late String _userId;
  late String _password;
  late String _email;
  String _message = '';
}

class EventDetail {
  late String id;
  late String _description;
  late String _date;
  late String _startTime;
  late String _endTime;
  late String _speaker;
  late bool _isFavorite;
  EventDetail(this.id, this._description, this._date, this._startTime,
      this._endTime, this._speaker, this._isFavorite);
  String get description => _description;
  String get date => _date;
  String get startTime => _startTime;
  String get endTime => _endTime;
  String get speaker => _speaker;
  bool get isFavorite => _isFavorite;

  EventDetail.fromMap(dynamic obj) {
    //QueryDocumentSnapshot<Map<String, dynamic>>
    // id = (obj as QueryDocumentSnapshot).id; // obj['id']; id는 이형식으로 가져올 수 없음
    _description = obj['description'];
    _date = obj['date'];
    _startTime = obj['start_time'];
    _endTime = obj['end_time'];
    _speaker = obj['speaker'];
    _isFavorite = obj['is_favorite'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['description'] = _description;
    map['date'] = _date;
    map['start_time'] = _startTime;
    map['end_time'] = _endTime;
    map['speaker'] = _speaker;
    map['is_favorite'] = _isFavorite;

    return map;
  }
}

// Future<List<EventDetail>> getEventDetails() async {
//   var list = <EventDetail>[];
//   // FirebaseFirestore db = FirebaseFirestore.instance;
//   var data = await db.collection('event_details').get();
//   var details = data.docs.toList();
//   // details.forEach((action){
//   //   list.add(EventDetail.fromMap(action));
//   // }); // 익명함수를 쓸거면 for문이 빠름름

//   for (var value in details) {
//     debugPrint('getEventDetails value : ${value.data().toString()}');
//     list.add(EventDetail.fromMap(value));
//   }
//   return list;
// }

// Future testData() async {
//   debugPrint('testData');
//   FirebaseFirestore db = FirebaseFirestore.instance;
//   var data = await db.collection('event_details').get();
//   var details = data.docs.toList();
//   details.forEach((action) {
//     debugPrint(action.id);
//   });
// }
