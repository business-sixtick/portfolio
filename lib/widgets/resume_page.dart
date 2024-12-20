import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    debugPrint('Could not launch $url');
  }
}


class ResumePage extends StatelessWidget{
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.amber[100] ?? Colors.amber, width: 0.5)
        ),
        child: ListView(
          children: [
            const ListTile(
              title: Text('이력서', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28), textAlign: TextAlign.center,),
              
            ),
            const Divider(
              color: Colors.grey,
              thickness: 2,
              indent: 120,
              endIndent: 120,
            ),
            const ListTile(
              leading: Icon(Icons.circle, size: 8,),
              title: Text('이름 : 조영훈', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ), 
            const ListTile(
              leading: Icon(Icons.circle, size: 8,),
              title: Text('생년월일 : 820125 (43세)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ), 
            const ListTile(
              leading: Icon(Icons.circle, size: 8,),
              title: Text('사는곳 : 경기도 포천시 신읍동 (미혼, 독거중)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            ListTile(
              leading: const  Icon(Icons.link, size: 18,),
              title: const  Text('연락처 : 텔레그램@sixtick', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              onTap: () => _launchUrl('https://t.me/sixtick'),
            ), 
            ListTile(
              leading: const  Icon(Icons.link, size: 18,),
              title: const  Text('깃허브 : business-sixtick/portpolio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              onTap: () => _launchUrl('https://github.com/business-sixtick/portpolio'),
            ), 
            const ListTile(
              leading: Icon(Icons.circle, size: 8,),
              title: Text('이메일 : hungh4@naver.com', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
              indent: 30,
              endIndent: 30,
            ),
            const ListTile(
              leading: Icon(Icons.circle, size: 8,),
              title: Text('경력 : 1년 \r\n1) 케이엠비엔에스 (웹개발) 201409 ~ 201506'
              '\r\n2) 네스텍 (자동화프로그램 CS) 201205 ~ 201305', 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
              indent: 30,
              endIndent: 30,
            ),
            const ListTile(
              leading: Icon(Icons.circle, size: 8,),
              title: Text('학력 : 고졸(인문계, 포천고등학교)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ), 
            const ListTile(
              leading: Icon(Icons.circle, size: 8,),
              title: Text('병역 : 육군 병장제대', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const ListTile(
              leading: Icon(Icons.circle, size: 8,),
              title: Text('자동차 운전면허 : 1종 보통', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ), 
            const ListTile(
              leading: Icon(Icons.circle, size: 8,),
              title: Text('프로그래밍 언어 : c, c++, c#, java, javascript, python, dart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ), 
            const ListTile(
              leading: Icon(Icons.circle, size: 8,),
              title: Text('프로그래밍 관련 교육 수료 : \r\n1) AIoT를 이용한 빅데이터 분석 산업솔루션 개발 취업연계 부트캠프(파이썬) 20240708 ~ 20250127'
                '\r\n2) 클라우드시스템개발B(자바,웹) 20140218 ~ 20140811'
                '\r\n3) 네스텍 기업연계과정(C#,닷넷) 20120529 ~ 20120917'
                '\r\n4) 내장형하드웨어(C,C++,펌웨어) 20110411 ~ 20120131'
              , 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ), 
          ],

        ),
      ),
      );
  }
}