import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

const List<Map<String, dynamic>> bossData = [
  {
    "이름": "검은마법사",
    "이미지": "assets/images/bosses/blackmage.png",
    "메소": [1000000000, 9200000000],
    "난이도": ["하드", "익스트림"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "발드릭스",
    "이미지": "assets/images/bosses/baldrix.png",
    "메소": [1200000000, 2160000000],
    "난이도": ["노말", "하드"],
    "인원수": [1, 2, 3],
  },
  {
    "이름": "림보",
    "이미지": "assets/images/bosses/limbo.png",
    "메소": [900000000, 1930000000],
    "난이도": ["노말", "하드"],
    "인원수": [1, 2, 3],
  },
  {
    "이름": "카링",
    "이미지": "assets/images/bosses/kaling.png",
    "메소": [381000000, 595000000, 1310000000, 3150000000],
    "난이도": ["이지", "노말", "하드", "익스트림"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "대적자",
    "이미지": "assets/images/bosses/adversary.png",
    "메소": [361000000, 530000000, 1260000000, 2920000000],
    "난이도": ["이지", "노말", "하드", "익스트림"],
    "인원수": [1, 2, 3],
  },
  {
    "이름": "칼로스",
    "이미지": "assets/images/bosses/kallos.png",
    "메소": [345000000, 510000000, 1120000000, 2700000000],
    "난이도": ["이지", "노말", "하드", "익스트림"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "세렌",
    "이미지": "assets/images/bosses/seren.png",
    "메소": [295000000, 440000000, 2420000000],
    "난이도": ["노말", "하드", "익스트림"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "스우",
    "이미지": "assets/images/bosses/lotus.png",
    "메소": [22000000, 77400000, 549000000],
    "난이도": ["노말", "하드", "익스트림"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "진힐라",
    "이미지": "assets/images/bosses/jinhilla.png",
    "메소": [107000000, 160000000],
    "난이도": ["노말", "하드"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "듄켈",
    "이미지": "assets/images/bosses/dunkel.png",
    "메소": [62500000, 142000000],
    "난이도": ["노말", "하드"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "가디언엔젤슬라임",
    "이미지": "assets/images/bosses/guardian.png",
    "메소": [33500000, 113000000],
    "난이도": ["노말", "하드"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "더스크",
    "이미지": "assets/images/bosses/dusk.png",
    "메소": [57900000, 105000000],
    "난이도": ["노말", "카오스"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "윌",
    "이미지": "assets/images/bosses/will.png",
    "메소": [42500000, 54100000, 116000000],
    "난이도": ["이지", "노말", "하드"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "루시드",
    "이미지": "assets/images/bosses/lucid.png",
    "메소": [39200000, 46900000, 94500000],
    "난이도": ["이지", "노말", "하드"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "데미안",
    "이미지": "assets/images/bosses/damien.png",
    "메소": [23000000, 73500000],
    "난이도": ["노말", "하드"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "파풀라투스",
    "이미지": "assets/images/bosses/papulatus.png",
    "메소": [390000, 1520000, 17300000],
    "난이도": ["이지", "노말", "카오스"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "벨룸",
    "이미지": "assets/images/bosses/vellum.png",
    "메소": [551000, 9280000],
    "난이도": ["노말", "카오스"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "블러드퀸",
    "이미지": "assets/images/bosses/queen.png",
    "메소": [551000, 8140000],
    "난이도": ["노말", "카오스"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "피에르",
    "이미지": "assets/images/bosses/pierre.png",
    "메소": [551000, 8170000],
    "난이도": ["노말", "카오스"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "반반",
    "이미지": "assets/images/bosses/vonbon.png",
    "메소": [551000, 8150000],
    "난이도": ["노말", "카오스"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "매그너스",
    "이미지": "assets/images/bosses/magnus.png",
    "메소": [411000, 1480000, 8560000],
    "난이도": ["이지", "노말", "카오스"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "시그너스",
    "이미지": "assets/images/bosses/cygnus.png",
    "메소": [4550000, 7500000],
    "난이도": ["이지", "노말"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "핑크빈",
    "이미지": "assets/images/bosses/pinkbean.png",
    "메소": [799000, 6580000],
    "난이도": ["노말", "카오스"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "힐라",
    "이미지": "assets/images/bosses/hilla.png",
    "메소": [455000, 5750000],
    "난이도": ["노말", "하드"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "자쿰",
    "이미지": "assets/images/bosses/zakum.png",
    "메소": [114000, 349000, 8080000],
    "난이도": ["이지", "노말", "카오스"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "아카이럼",
    "이미지": "assets/images/bosses/arkarium.png",
    "메소": [656000, 1430000],
    "난이도": ["이지", "노말"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "반레온",
    "이미지": "assets/images/bosses/vonleon.png",
    "메소": [602000, 830000, 1390000],
    "난이도": ["이지", "노말", "하드"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
  {
    "이름": "혼테일",
    "이미지": "assets/images/bosses/horntail.png",
    "메소": [502000, 576000, 770000],
    "난이도": ["이지", "노말", "카오스"],
    "인원수": [1, 2, 3, 4, 5, 6],
  },
];

const Map<String, String> equipImages = {
  "모자": "assets/images/items/hat.png",
  "상의": "assets/images/items/top.png",
  "하의": "assets/images/items/bottom.png",
  "신발": "assets/images/items/shoes.png",
  "장갑": "assets/images/items/gloves.png",
  "견장": "assets/images/items/shoulder.png",
  "망토": "assets/images/items/cape.png",
  "귀고리": "assets/images/items/earrings.png",
  "얼굴장식": "assets/images/items/face.png",
  "눈장식": "assets/images/items/eye.png",
  "반지": "assets/images/items/ring.png",
  "펜던트": "assets/images/items/pendant.png",
  "하트": "assets/images/items/heart.png",
  "벨트": "assets/images/items/belt.png",
  "무기": "assets/images/items/weapon.png",
  "보조무기": "assets/images/items/sub.png",
  "엠블렘": "assets/images/items/emblem.png",
};

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
  "펜던트",
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
  "펜던트",
  "하트",
  "벨트",
  "무기",
];

const List<int> equiplevel = [140, 150, 160, 200, 250];

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
  static Color subfont = Color(0xFF3d2b36);

  static Color border = Color(0xFFcf690d);
  static Color subborder = Color(0xFFf59064);

  static Color textborder = Color(0xFFDDDDDD);
}

Stack twoText(String title, double size) {
  // return Stack(
  //   children: [
  //     // 테두리
  //     Text(
  //       title,
  //       style: TextStyle(
  //         fontSize: size.sp,
  //         fontWeight: FontWeight.bold,
  //         foreground: Paint()
  //           ..style = PaintingStyle.stroke
  //           ..strokeWidth = 3
  //           ..color = Typicalcolor.subfont,
  //       ),
  //       textAlign: TextAlign.center,
  //     ),
  //     // 안쪽 채우기
  //     Text(
  //       title,
  //       style: TextStyle(
  //         fontSize: size.sp,
  //         fontWeight: FontWeight.bold,
  //         color: Color(0xFFFFFFFF),
  //       ),
  //       textAlign: TextAlign.center,
  //     ),
  //   ],
  // );
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
            ..color = Typicalcolor.textborder,
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
          color: Typicalcolor.bg,
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

final Map<int, int> levelmeso = {200: 45000000, 250: 50000000};

//할인비용: 강화비용 × { 1.0 - (MVP+PC방) }
//썬데이: 강화비용 × { 1.0 - (MVP+PC방) } × 0.7
//썬데이: enchantMeso * { 1.0 - (mvpTime+pcTime) } * payTime * destroyTime

class RangeInputFormatter extends TextInputFormatter {
  final int max;

  RangeInputFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final int? value = int.tryParse(newValue.text);
    if (value == null) return oldValue;

    // 1 이상 max 이하만 허용
    if (value < 1 || value > max) {
      return oldValue;
    }

    return newValue;
  }
}
