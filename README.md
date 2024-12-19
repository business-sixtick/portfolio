# portpolio
sixtick portpolio 

## 환경설정
- 깃허브에서 프로젝트 생성성
- git clone : https://github.com/business-sixtick/portpolio.git
- 플러터 프로잭트 추가 : flutter create .
- 플러터 의존성 라이브러리 추가 : flutter pub get
- 테스트 실행 : flutter run

## 웹 배포
- 웹 테스트 flutter run -d chrome
- flutter build web --base-href="/portpolio/" -o docs   // 아웃풋 경로를 build/web 가 아닌 docs로 변경함. 

## 플러터 맛보기
- http://codelabs.developers.google.com/codelabs/flutter-codelab-first?hl=ko

## 프로젝트 구조
- /lib/main.dart   : 진입점
- /lib/widgets/    : 위젯 (페이지, 컴포넌트)

## 디팬던시 dependencies
- flutter pub add flutter_riverpod  : 상태관리, 프로바이더 상위버전
- flutter pub add window_size   : 데스크탑 앱 화면 크기 설정
- flutter pub add url_launcher  : 외부페이지를 실행 시킬수 있음. 