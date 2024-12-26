# portfolio
sixtick portfolio 

## 환경설정
- 깃허브에서 프로젝트 생성성
- git clone : https://github.com/business-sixtick/portfolio.git
- 플러터 프로잭트 추가 : flutter create .
- 플러터 의존성 라이브러리 추가 : flutter pub get
- 테스트 실행 : flutter run

## 웹 배포
- 웹 테스트 flutter run -d chrome
- flutter build web --base-href="/portfolio/" -o docs   // 아웃풋 경로를 build/web 가 아닌 docs로 변경함. 
- https://business-sixtick.github.io/portfolio/

## 플러터 맛보기
- http://codelabs.developers.google.com/codelabs/flutter-codelab-first?hl=ko

## 프로젝트 구조
- /lib/main.dart   : 진입점
- /lib/widgets/    : 위젯 (페이지, 컴포넌트)

## 디팬던시 dependencies
- flutter pub add flutter_riverpod  : 상태관리, 프로바이더 상위버전
- flutter pub add window_size   : 데스크탑 앱 화면 크기 설정
- flutter pub add url_launcher  : 외부페이지를 실행 시킬수 있음. 
- flutter pub add http  : 웹 통신
- flutter pub add html  : html 파서
- flutter pub add cp949_codec  : cp949 디코더 (로또 홈페이지가 cp949 로 인코딩 되어있음. )


## 로또  api 
- ssh -i C:\Users\sixtick3\.ssh\ssh-key-2024-12-21.key ubuntu@144.24.78.242
- https://lottoapi.duckdns.org/lotto


