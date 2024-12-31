import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class MoviePage extends ConsumerWidget {
  final TextEditingController _textController = TextEditingController();
  final loadingProvider = StateProvider((ref) => false);
  final moviesProvider = StateProvider<List<Movie>>((ref) => []);
  
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // double height = MediaQuery.of(context).size.height;
    bool isLoading = ref.watch(loadingProvider);
    List<Movie> movies = ref.watch(moviesProvider);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 800,  
          ),
          child: Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      SizedBox(width: 20,),
                      Expanded(
                        child: TextField(
                          onSubmitted: (value){
                            context.findAncestorWidgetOfExactType<ElevatedButton>()?.onPressed!();
                          },
                          controller: _textController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '제목 또는 배우이름을 입력하세요.'
                          ),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: 20,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: (){
                            ref.read(loadingProvider.notifier).state = true;
                            debugPrint(_textController.text);
                            search(_textController.text).then((onValue){
                              ref.read(loadingProvider.notifier).state = false;
                              ref.read(moviesProvider.notifier).state = onValue;
                              });
                          }, 
                          child: isLoading ? const CircularProgressIndicator() : const Text('검색')),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),
                ),
                Expanded(
                  // height: 600,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: movies.map((toElement)=> Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: ListTile(
                          minVerticalPadding: 20,
                          shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Theme.of(context).colorScheme.primaryContainer, width: 1.0), // 테두리 색상과 두께
                                      borderRadius: BorderRadius.circular(32.0), // 둥근 모서리
                                    ),
                          leading: CircleAvatar(backgroundImage: NetworkImage('https://image.tmdb.org/t/p/w300_and_h450_bestv2${toElement.posterPath}'),),
                          title: Text(toElement.title),
                          onTap: (){
                            MaterialPageRoute route = MaterialPageRoute(builder: (builder){
                              return Scaffold(
                                appBar: AppBar(title: Text(toElement.title),), // 이걸 넣어야지 뒤로가기 버튼이 자동으로 생기네네
                                body: Center(
                                  child: Image.network('https://image.tmdb.org/t/p/w300_and_h450_bestv2${toElement.posterPath}'),
                                ),
                              );
                            });
                            Navigator.push(context, route);
                          },
                        ),
                      )).toList(),
                    ),
                  ),
                ),
                

              ],
          ),
        ),
      ),
    );
  }
}

Future<List<Movie>> search(String multi) async {
  String address = 'api.themoviedb.org'; //  /3/search/multi?query=$multi&include_adult=true&language=ko-KR&page=1';
  var url = Uri.https(address, '/3/search/multi', {'query': multi, 'include_adult': 'true', 'language': 'ko-KR', 'page': '1'});
  
  var headers = {
    "accept": "application/json",
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3Mjc5ZDVjNjk5Yzc3MDE0ZjkwNDVjNzQ5YTFiYWRjMCIsIm5iZiI6MTczNTUzODQyNS4zNDksInN1YiI6IjY3NzIzNmY5NjNmOTBmOGY2NjkyNmY0ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.HM8nLNszGVUqmRzMzXQhwggs_HWt0qdZxR8IcEeRT6A"
  };
  http.Response response; 
  try{
    response = await http.get(url, headers: headers);  // 시간제한이 가끔 걸리네
  }catch (e){
    debugPrint(e.toString());
    return [];
  }
  
  dynamic resMap = jsonDecode(response.body);
  // resMap['results'].forEach((value)=> debugPrint(value.toString()));
  // List<Movie> movies = resMap['results'].where((value) => value.containsKey('title')).map((value) => Movie.fromJson(value)).toList();
  debugPrint(response.body);
  // debugPrint(resMap['results'][0]['title']);
  // debugPrint(movies.toString());
  if(resMap['total_results'] == 0) return [];
  dynamic results = resMap['results'];
  
  List<Movie> movies = [];
  if (results is List) {
    if (results[0].containsKey('known_for')){
      var subResults = results[0]['known_for'];
      
      debugPrint("subResults");
      debugPrint(subResults.toString());
      // movies = subResults
      //   .where((value) => value is Map<String, dynamic> && value.containsKey('title'))
      //   .map((value) => Movie.fromJson(value as Map<String, dynamic>))
      //   .toList() as List<Movie>;
      subResults.forEach((v) => movies.add(Movie.fromJson(v)));
    }else{
      movies = results
        .where((value) => value is Map<String, dynamic> && value.containsKey('title'))
        .map((value){ debugPrint(value.toString()); return Movie.fromJson(value as Map<String, dynamic>);})
        .toList();
    }
    
    

    debugPrint(movies.length.toString()); // 디버깅용 출력
  }


  return movies;
  // var address = 'lottoapi.duckdns.org';   // 144.24.78.242
  // var url = Uri.https(address, 'lotto');
  // var response = await http.get(url);
  // // debugPrint('response.statusCode : ${response.body}');
  // List<dynamic> jsonList = jsonDecode(response.body);
  // debugPrint('jsonList ${jsonList[0].keys}');
}


class Movie {
  final int id;
  final String title;
  final String posterPath;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
  });

  // JSON → 객체 변환
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json.containsKey('name') ? json['name'] as String : json['title'] as String,
      posterPath: json['poster_path'] == null || json['poster_path'] == 'null' ? '' : json['poster_path'] as String,
    );
  }

  // 객체 → JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
    };
  }
}




// https://developer.themoviedb.org/reference/search-multi
// https://www.themoviedb.org/settings/api

// https://media.themoviedb.org/t/p/w300_and_h450_bestv2//3XJY7nQp8YbB00OMrgw84OhkSSy.jpg

// import requests

// url = "https://api.themoviedb.org/3/search/multi?query=%EC%8B%A4%EB%AF%B8%EB%8F%84&include_adult=true&language=ko-KR&page=1"

// headers = {
//     "accept": "application/json",
//     "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3Mjc5ZDVjNjk5Yzc3MDE0ZjkwNDVjNzQ5YTFiYWRjMCIsIm5iZiI6MTczNTUzODQyNS4zNDksInN1YiI6IjY3NzIzNmY5NjNmOTBmOGY2NjkyNmY0ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.HM8nLNszGVUqmRzMzXQhwggs_HWt0qdZxR8IcEeRT6A"
// }

// response = requests.get(url, headers=headers)

// print(response.text)


// eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3Mjc5ZDVjNjk5Yzc3MDE0ZjkwNDVjNzQ5YTFiYWRjMCIsIm5iZiI6MTczNTUzODQyNS4zNDksInN1YiI6IjY3NzIzNmY5NjNmOTBmOGY2NjkyNmY0ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.HM8nLNszGVUqmRzMzXQhwggs_HWt0qdZxR8IcEeRT6A



// {
//   "page": 1,
//   "results": [
//     {
//       "id": 17120,
//       "name": "정우성",
//       "original_name": "정우성",
//       "media_type": "person",
//       "adult": false,
//       "popularity": 17.535,
//       "gender": 2,
//       "known_for_department": "Acting",
//       "profile_path": "/tI0ANQSwcOBfQUeHgfcwn7VmHRO.jpg",
//       "known_for": [
//         {
//           "backdrop_path": "/aH4ZCM94FeWO0GSBLPYxnjkIuUP.jpg",
//           "id": 204553,
//           "title": "감시자들",
//           "original_title": "감시자들",
//           "overview": "범죄 대상에 대한 감시만을 전문적으로 담당하는 경찰 내 특수조직 감시반. 동물적인 직감과 본능으로 범죄를 쫓는 감시 전문가 황반장이 이끄는 감시반에 탁월한 기억력과 관찰력을 지닌 신참 하윤주가 합류한다. 그리고 얼마 후 감시반의 철저한 포위망마저 무용지물로 만든 범죄가 벌어진다. 단 3분만에 한 치의 실수도 없이 벌어진 무장강도사건. 얼굴도, 단서도 남기지 않은 그들의 존재에 모든 시선이 꽂힌다. 철저하게 짜여진 계획 하에 움직이며 1초의 오차도 용납하지 않는 범죄 조직의 리더 제임스. 자신의 존재를 절대 드러내지 않는 그는 감시반의 추적이 조여올수록 더욱 치밀하게 범죄를 이어간다. 더 이상의 범죄를 막기 위해 반드시 놈의 실체를 알아내야만 하는 감시반. 황반장과 하윤주는 모든 기억과 단서를 동원해 놈을 쫓기 시작하는데…",
//           "poster_path": "/2iZbCv0XJGaPwZTTF7atEosAxRR.jpg",
//           "media_type": "movie",
//           "adult": false,
//           "original_language": "ko",
//           "genre_ids": [
//             80,
//             28,
//             53
//           ],
//           "popularity": 21.085,
//           "release_date": "2013-07-03",
//           "video": false,
//           "vote_average": 7.5,
//           "vote_count": 346
//         },
//         {
//           "backdrop_path": "/uRkIlvBtvwOWBBY3GtpCJGJsGug.jpg",
//           "id": 15859,
//           "title": "내 머리 속의 지우개",
//           "original_title": "내 머리 속의 지우개",
//           "overview": "수진은 유달리 건망증이 심하다. 편의점에 가면 산 물건과 지갑까지 놓고 나오기 일쑤다. 그 날도 어김없이 산 콜라와 지갑을 놓고 온 것을 깨닫고 다시 편의점에 들어선 순간 맞닥뜨린 남자. 그의 손엔 콜라가 들려있고, 콜라가 있어야 할 편의점 카운터는 비어있다. 덥수룩한 수염에 남루한 옷차림, 영락없는 부랑자다. 그가 자신의 콜라를 훔쳤다고 생각한 수진, 그의 손에 들린 콜라를 뺏어 단숨에 들이킨다. 게다가 트림까지. 보란 듯이 빈 캔을 돌려주고, 수진은 버스정류장으로 향한다. 하지만 버스에 탄 순간 또 지갑을 챙겨오지 않은 걸 깨닫는다. 다시 돌아간 편의점에서 직원은 수진을 보더니 지갑과 콜라를 내놓는다. 그제서야 자신의 실수를 깨닫는 수진. 그를 찾아보지만 이미 그는 없다.",
//           "poster_path": "/jYnWHteL9i4OFMaKjujGV3D4F3g.jpg",
//           "media_type": "movie",
//           "adult": false,
//           "original_language": "ko",
//           "genre_ids": [
//             18,
//             10749
//           ],
//           "popularity": 12.977,
//           "release_date": "2004-11-05",
//           "video": false,
//           "vote_average": 7.8,
//           "vote_count": 317
//         },
//         {
//           "backdrop_path": "/gec3e76TRGUBx1Ut0c6yuSahVDp.jpg",
//           "id": 15067,
//           "title": "좋은 놈, 나쁜 놈, 이상한 놈",
//           "original_title": "좋은 놈, 나쁜 놈, 이상한 놈",
//           "overview": "1930년대, 다양한 인종이 뒤엉키고 총칼이 난무하는 무법천지 만주에서 각자 다른 방식으로 격동기를 살아가는 조선의 풍운아, 세 명의 남자가 운명처럼 맞닥뜨린다. 돈 되는 건 뭐든 사냥하는 현상금 사냥꾼 박도원, 최고가 아니면 참을 수 없는 마적단 두목 박창이, 잡초 같은 생명력의 독고다이 열차털이범 윤태구. 이들은 서로의 정체를 모르는 채 태구가 열차를 털다 발견한 지도를 차지하기 위해 대륙을 누비는 추격전을 펼친다. 정체 불명의 지도 한 장을 둘러 싼 엇갈리는 추측 속에 일본군, 마적단까지 이들의 레이스에 가담하게 되는데...",
//           "poster_path": "/inPPsMpQBKfDORKqemLZn8kQDTp.jpg",
//           "media_type": "movie",
//           "adult": false,
//           "original_language": "ko",
//           "genre_ids": [
//             28,
//             12,
//             35,
//             37
//           ],
//           "popularity": 19.575,
//           "release_date": "2008-07-16",
//           "video": false,
//           "vote_average": 7.168,
//           "vote_count": 724
//         }
//       ]
//     },
//     {
//       "id": 2128953,
//       "name": "Olltii",
//       "original_name": "Olltii",
//       "media_type": "person",
//       "adult": false,
//       "popularity": 0.001,
//       "gender": 2,
//       "known_for_department": "Acting",
//       "profile_path": "/4yv29QE0N1xnOZneY1DaXhQ2dAL.jpg",
//       "known_for": [
//         {
//           "backdrop_path": "/asUw28uXw6GtGxQE0Bwfbu1GvCb.jpg",
//           "id": 742741,
//           "title": "라임크라임",
//           "original_title": "라임크라임",
//           "overview": "어느 고등학교의 음악 실기 시험 시간이다. 칠판에는 가요와 랩은 안 된다고 엄연히 공표되어 있지만 송주는 아랑곳없이 랩 실력을 뽐내고 있다. 선생님은 그에게 조용히 F를 준다. 하지만 교실의 한쪽에서 주연은 송주를 보며 즐거운 표정을 짓고 있다. 주연도 송주 만큼이나 힙합을 좋아한다. 송주는 문제 학생에 가까우며 다소 저 개발된 다세대 주택에 살고, 주연은 모범생이며 부촌의 아파트에 산다. 둘은 성적도 환경도 성격도 다르지만, 의기투합하여 2인조 힙합 그룹 ‘라임크라임’을 결성한다.",
//           "poster_path": "/uiHeLtUqp9tvjnkH6quL6i8KsuF.jpg",
//           "media_type": "movie",
//           "adult": false,
//           "original_language": "ko",
//           "genre_ids": [
//             10402,
//             18
//           ],
//           "popularity": 0.955,
//           "release_date": "2021-11-25",
//           "video": false,
//           "vote_average": 4,
//           "vote_count": 1
//         },
//         {
//           "backdrop_path": "/8jsvRzKyB1s7YU9e40prhBJyIez.jpg",
//           "id": 68884,
//           "name": "Show Me The Money",
//           "original_name": "Show Me The Money",
//           "overview": "실력 있는 래퍼들을 발굴하고 이들을 대중들에게 알리는 등용문이 될 수 있도록 기획된 프로그램",
//           "poster_path": "/zyzD9DGJWyA3VDMrS6ZzmW61SAd.jpg",
//           "media_type": "tv",
//           "adult": false,
//           "original_language": "ko",
//           "genre_ids": [
//             10764
//           ],
//           "popularity": 60.633,
//           "first_air_date": "2012-06-22",
//           "vote_average": 7.7,
//           "vote_count": 3,
//           "origin_country": [
//             "KR"
//           ]
//         }
//       ]
//     }
//   ],
//   "total_pages": 1,
//   "total_results": 2
// }