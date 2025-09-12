import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const List<String> backgroundsimg = [
  "assets/images/themes/spring.png",
  "assets/images/themes/summer.png",
  "assets/images/themes/fall.png",
  "assets/images/themes/winter.png",
];

class Backgroundnum {
  static int bn = 0;
}

const List<String> bossimg = [
  "assets/images/bosses/blackmage.png", // 검은마법사
  "assets/images/bosses/baldrix.png", // 발드릭스
  "assets/images/bosses/limbo.png", // 림보
  "assets/images/bosses/kaling.png", // 카링
  "assets/images/bosses/adversary.png", // 대적자
  "assets/images/bosses/kallos.png", // 칼로스
  "assets/images/bosses/seren.png", // 세렌
  "assets/images/bosses/lotus.png", // 스우
  "assets/images/bosses/jinhilla.png", // 진힐라
  "assets/images/bosses/dunkel.png", // 듄켈
  "assets/images/bosses/guardian.png", // 가엔슬
  "assets/images/bosses/dusk.png", // 더스크
  "assets/images/bosses/will.png", // 윌
  "assets/images/bosses/lucid.png", // 루시드
  "assets/images/bosses/damien.png", // 데미안
  "assets/images/bosses/papulatus.png", // 파풀라투스
  "assets/images/bosses/vellum.png", // 벨룸
  "assets/images/bosses/queen.png", // 블러드퀸
  "assets/images/bosses/pierre.png", // 피에르
  "assets/images/bosses/vonbon.png", // 반반
  "assets/images/bosses/magnus.png", // 매그너스
  "assets/images/bosses/cygnus.png", // 시그너스
  "assets/images/bosses/pinkbean.png", // 핑크빈
  "assets/images/bosses/hilla.png", // 힐라
  "assets/images/bosses/zakum.png", // 자쿰
  "assets/images/bosses/arkarium.png", // 아카이럼
  "assets/images/bosses/vonleon.png", // 반 레온
  "assets/images/bosses/horntail.png", // 혼테일
];

const List<String> equipimg = [
  "assets/images/items/hat.png", // 모자
  "assets/images/items/top.png", // 상의
  "assets/images/items/bottom.png", // 하의
  "assets/images/items/shoes.png", // 신발
  "assets/images/items/gloves.png", // 장갑
  "assets/images/items/shoulder.png", // 견장
  "assets/images/items/cape.png", // 망토
  "assets/images/items/earrings.png", // 귀고리
  "assets/images/items/face.png", // 얼장
  "assets/images/items/eye.png", // 눈장
  "assets/images/items/ring.png", // 반지
  "assets/images/items/pendant.png", // 팬던트
  "assets/images/items/heart.png", // 하트
  "assets/images/items/belt.png", // 벨트
  "assets/images/items/weapon.png", // 무기
  "assets/images/items/sub.png", // 보조무기
  "assets/images/items/emblem.png", // 엠블렘
];

const List<String> equiptype = [
  "모자",
  "상의",
  "하의",
  "신발",
  "장갑",
  "견장",
  "망토",
  "귀고리",
  "얼굴장식",
  "눈장식",
  "반지",
  "팬던트",
  "하트",
  "벨트",
  "무기",
  "보조무기",
  "엠블렘",
];

const List<String> forcetype = [
  "모자",
  "상의",
  "하의",
  "신발",
  "장갑",
  "견장",
  "망토",
  "귀고리",
  "얼굴장식",
  "눈장식",
  "반지",
  "팬던트",
  "하트",
  "벨트",
  "무기",
];

const List<String> equiplevel = ["250", "200", "160", "150", "140"];

final Map<String, Color> gradeColor = {
  '레어': Color(0xFF2EABC6),
  '에픽': Color(0xFF775AD9),
  '유니크': Color(0xFFf8a039),
  '레전드리': Color(0xFF7dbc00),
};

final List<List<dynamic>> rows = [
  ['1', '55.6', 1580452],
  ['2', '11', 1826],
  ['3', '11', 40000],
  ['3', '16', 36998],
  ['4', '55.6', 81698],
  ['5', '41.0', 41000],
  ['6', '36.9', 12400],
  ['7', '41.0', 41050],
  ['8', '—', '—'],
];

class Typicalcolor {
  static Color title = Color(0xFFff9d01);
  static Color subtitle = Color(0xFFf6d53c);

  static Color bg = Color(0xFFffefd6);
  static Color subbg = Color(0xFFffdcca);

  static Color font = Color(0xFF67462a);
  static Color subfont = Color(0xFF77644c);

  static Color border = Color(0xFFcf690d);
  static Color subborder = Color(0xFFf59064);
}

Stack twoText(String title, double size) {
  return Stack(
    children: [
      // 테두리
      Text(
        title,
        style: TextStyle(
          fontSize: size.sp,
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..color = Color(0xFFFFFFFF),
        ),
        textAlign: TextAlign.center,
      ),
      // 안쪽 채우기
      Text(
        title,
        style: TextStyle(
          fontSize: size.sp,
          fontWeight: FontWeight.bold,
          color: Typicalcolor.subfont,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Stack twoTitle(String title, double size) {
  return Stack(
    children: [
      // 테두리
      Text(
        title,
        style: TextStyle(
          fontSize: size.sp,
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..color = Typicalcolor.subfont,
        ),
        textAlign: TextAlign.center,
      ),
      // 안쪽 채우기
      Text(
        title,
        style: TextStyle(
          fontSize: size.sp,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Container expTitle(String title) {
  return Container(
    width: double.infinity,
    height: 40.h,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Typicalcolor.title, Typicalcolor.subbg],
      ),
      border: Border.all(color: Typicalcolor.border, width: 3.w),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 2.h,
              decoration: BoxDecoration(color: Typicalcolor.border),
            ),
            SizedBox(height: 15.h),
            Container(
              width: 10.w,
              height: 2.h,
              decoration: BoxDecoration(color: Typicalcolor.border),
            ),
          ],
        ),

        twoTitle(title, 15),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 8.h),
            Container(
              width: 20.w,
              height: 2.h,
              decoration: BoxDecoration(color: Typicalcolor.border),
            ),
            SizedBox(height: 15.h),
            Container(
              width: 10.w,
              height: 2.h,
              decoration: BoxDecoration(color: Typicalcolor.border),
            ),
          ],
        ),
      ],
    ),
  );
}
