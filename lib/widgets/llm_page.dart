import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';  // JSON 처리 라이브러리
// notifier , provider, consumer

class LLMPage extends ConsumerWidget{

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _controller = TextEditingController();
    final TextEditingController _controller_answer = TextEditingController();
    final TextEditingController _controller_query = TextEditingController();
    _controller.text = '사용자가 입력한 숫자 중에 제일 큰 숫자를 말해보세요.';
    _controller_query.text = '10, 20, 30, 40, 100, 60, 70, 80';

    return Scaffold(
      body: Column(
        children: [
          const Text(
              'LLM chatbot',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
            Divider(
              height: 20,
              thickness: 10,
              indent: 50,
              endIndent: 50,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'role : 사용자 맞춤 역할을 지정할 수 있습니다.'
              ),
              maxLines: 4,
              
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: TextField(
              controller: _controller_answer,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'answer : '
              ),
              maxLines: 20,
              minLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: TextField(
              controller: _controller_query,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'query : 대화를 시작하세요.'
              ),
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: (){}, child: Text('전송')),
          ),
        ],
      ),
    );
  }
}



Future<String> query(String role, String query) async{
  String res = '';
  // var url = Uri.https(address, 'llm');
  var url = Uri.https('sixtick.duckdns.org:19821', 
    'llm',
    {
      'role' : role,
      'query' : query
    });
  var response = await http.get(url);
  // debugPrint('response.statusCode : ${response.body}');
  // List<dynamic> jsonList = jsonDecode(response.body);
  // debugPrint('jsonList ${jsonList[10]['turn']}');
  
  try {
      // GET 요청 보내기
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // 요청 성공 시
        
      } else {
        // 요청 실패 시
        
      }
    } catch (e) {
      // 네트워크 오류 처리
      
    }
  return '';
}

//http://sixtick.duckdns.org:19821/llm?role=%EC%82%AC%EC%9A%A9%EC%9E%90%EA%B0%80%20%EC%A0%9C%EC%8B%9C%ED%95%9C%20%EC%88%AB%EC%9E%90%EB%93%A4%20%EC%A4%91%EC%97%90%20%EC%A0%9C%EC%9D%BC%20%ED%81%B0%20%EC%88%AB%EC%9E%90%EB%A5%BC%20%EB%A7%90%ED%95%B4%EC%A4%98&query=1,2,3,4,10,6,7,8,9