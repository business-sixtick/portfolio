import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

final user32 = DynamicLibrary.open('user32.dll');

// Windows API 함수 정의
typedef SendMessageC = IntPtr Function(IntPtr hWnd, Uint32 Msg, IntPtr wParam, IntPtr lParam);
typedef SendMessageDart = int Function(int hWnd, int Msg, int wParam, int lParam);

// 상수 정의
const WM_SYSCOMMAND = 0x0112;
const SC_MONITORPOWER = 0xF170;

void turnOffMonitor() {
  final sendMessage = user32
      .lookupFunction<SendMessageC, SendMessageDart>('SendMessageW');

  // HWND_BROADCAST: 모든 창에 메시지를 보냄
  const HWND_BROADCAST = 0xFFFF;

  // 화면 끄기 (lParam 2)
  sendMessage(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, 2);
}

void main() {
  // Windows 환경 확인
  if (!Platform.isWindows) {
    print('이 스크립트는 Windows에서만 실행 가능합니다.');
    return;
  }

  // 화면 끄기 실행
  turnOffMonitor();
  print('화면을 끄는 명령을 보냈습니다.');
}
