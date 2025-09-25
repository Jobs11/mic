const Map<String, String> couponimg = {
  "EXP": "assets/images/consumes/exp.png", // Exp 쿠폰
  "상급 EXP": "assets/images/consumes/highexp.png", // 상급 Exp 쿠폰
  "궁극의 유니온 성장의 비약": "assets/images/consumes/union.png", // 궁성비
  "극한 성장의 비약": "assets/images/consumes/limit.png", // 극성비
  "초월 성장의 비약": "assets/images/consumes/transcend.png", // 초성비
  "VIP 리조트": "assets/images/consumes/vipsauna.png", // VIP 리조트 [잠수맵]
  "펀치킹": 'assets/images/consumes/punch.png', // 펀치킹
};

const Map<String, String> useitemLevel = {
  "EXP": " (Lv: 200~259)", // Exp 쿠폰
  "상급 EXP": " (Lv: 260)", // 상급 Exp 쿠폰
  "궁극의 유니온 성장의 비약": "", // 궁성비
  "극한 성장의 비약": " (Lv: 250)", // 극성비
  "초월 성장의 비약": " (Lv: 270)", // 초성비
};

class FieldRule {
  final int min;
  final int max;
  final bool evenOnly; // 짝수만 허용 등 특수 조건이 필요하면 사용
  const FieldRule({
    required this.min,
    required this.max,
    this.evenOnly = false,
  });
}

final Map<String, FieldRule> useRules = {
  "EXP": FieldRule(min: 0, max: 9999),
  "상급 EXP": FieldRule(min: 0, max: 9999),
  "궁극의 유니온 성장의 비약": FieldRule(min: 0, max: 99), // 0~1개만
  "극한 성장의 비약": FieldRule(min: 0, max: 99), // 0~99개
  "초월 성장의 비약": FieldRule(min: 0, max: 99),
};
