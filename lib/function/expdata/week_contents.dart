const List<String> weekimg = [
  "assets/images/areas/journey.png", // 소멸의여로
  "assets/images/areas/chuchu.png", // 츄츄아일랜드
  "assets/images/areas/lachelein.png", // 레헬른
  "assets/images/areas/arcana.png", // 아르카나
  "assets/images/areas/morass.png", // 모라스
  "assets/images/areas/esfera.png", // 에스페라
  'assets/images/weeks/monster.png', // 익스트림
  'assets/images/weeks/azmoth.png', // 아즈모스
  'assets/images/weeks/high.png', // 하이마운틴
  'assets/images/weeks/company.png', // 앵글러컴퍼니
  'assets/images/weeks/night.png', // 악몽선경
];

const Map<String, int> weeklevellimit = {
  "에르다 스펙트럼": 200,
  "배고픈 무토": 210,
  "미드나잇 체이서": 220,
  "스피릿 세이비어": 225,
  "엔하임 디펜스": 230,
  "프로텍트 에스페라": 235,

  "익스트림 몬스터파크": 260,
  "아즈모스 협곡": 260,
  "하이 마운틴": 260,
  "앵글러 컴퍼니": 270,
  "악몽선경": 280,
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
  "하이 마운틴": false,
  "앵글러 컴퍼니": false,
  "악몽선경": false,
};
