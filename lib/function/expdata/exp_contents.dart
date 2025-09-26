import 'package:mic/function/expdata/day_contents.dart';

Map<String, int> eventtitle = {
  "아케인리버": 0,
  "그란디스": 0,
  "몬스터파크": 0,
  "아즈모스 협곡": 500,
  "에픽던전": 1,
};

List<int> epicrate = [1, 4, 8];

List<int> eventrate = [0, 5, 10, 20, 30, 40, 50];
List<int> azmothpoint = [
  500,
  1000,
  1500,
  2000,
  2500,
  3000,
  3500,
  4000,
  4500,
  5000,
  5500,
  6000,
  6500,
  7000,
  7500,
  8000,
  8500,
  9000,
  9500,
  10000,
];

Map<String, bool> dayquest = {
  //아케인리버
  "소멸의 여로": false,
  "츄츄 아일랜드": false,
  "꿈의 도시 레헬른": false,
  "신비의 숲 아르카나": false,
  "기억의 늪 모라스": false,
  "태초의 바다 에스페라": false,
  "문브릿지": false,
  "고통의미궁": false,
  "리멘": false,

  //세르니움
  "세르니움": false,
  "호텔아르크스": false,
  "오디움": false,
  "도원경": false,
  "아르테리아": false,
  "카르시온": false,
  "탈라하트": false,
};

Map<String, dynamic> monsterpark = {
  "지역": "소멸의 여로",
  "입장여부": false,
  "이미지": areaImages["소멸의 여로"],
};

Map<String, bool> weekquest = {
  "에르다 스펙트럼": false,
  "배고픈 무토": false,
  "미드나잇 체이서": false,
  "스피릿 세이비어": false,
  "엔하임 디펜스": false,
  "프로텍트 에스페라": false,

  "익스트림 몬스터파크": false,
};

Map<String, bool> epicweek = {
  "아즈모스 협곡": false,
  "하이마운틴": false,
  "앵글러 컴퍼니": false,
  "악몽선경": false,
};

Map<String, int> usecoupon = {
  "EXP": 0,
  "상급 EXP": 0,
  "궁극의 유니온 성장의 비약": 0,
  "극한 성장의 비약": 0,
  "초월 성장의 비약": 0,
};

Map<String, double> timecoupon = {"펀치킹": 0.0, "VIP 사우나": 0.0};
