import 'dart:math' as math;

/// 확률 문자열("11.1111%")/숫자 -> 0~1 확률
double _toProb01(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) {
    // 이미 0~1 범위 확률이 숫자로 들어온 경우
    final d = v.toDouble();
    // 혹시 퍼센트(>1)로 들어오면 100으로 나눠서 보정
    return (d > 1.0) ? (d / 100.0) : d;
  }

  var s = v.toString().trim();
  s = s.replaceAll(' %', '%'); // "11.1 %" 같은 케이스
  final isPercent = s.endsWith('%');
  if (isPercent) s = s.substring(0, s.length - 1).trim();

  // 천단위/소수 구분 자동 처리
  final hasDot = s.contains('.');
  final hasComma = s.contains(',');

  String normalized;
  if (hasComma && hasDot) {
    // 둘 다 있으면 콤마는 천단위로 보고 제거
    normalized = s.replaceAll(',', '');
  } else if (hasComma && !hasDot) {
    // 콤마만 있으면 콤마를 소수점으로 본다
    normalized = s.replaceAll(',', '.');
  } else {
    normalized = s;
  }

  final val = double.tryParse(normalized) ?? 0.0;
  if (isPercent) {
    return val / 100.0; // 퍼센트 → 확률
  }
  // 퍼센트 기호가 없는데 1보다 크면 퍼센트로 들어온 숫자라고 보고 보정
  return (val > 1.0) ? (val / 100.0) : val;
}

/// 한 줄(List<Map>)에서 옵션명으로 확률(0~1) 찾기
double _probOf(List<dynamic> line, String optionName) {
  for (final e in line) {
    final m = Map<String, dynamic>.from(e as Map);
    if (m['옵션'] == optionName) return _toProb01(m['확률']);
  }
  return 0.0; // 없으면 0
}

/// selectedPayload: equipcube[selectedLevel]! 에서 만든 맵
/// first/second/third: 각 줄에서 노린 옵션명
/// return: 한 번 돌릴 때 목표 조합 성공확률 p (0~1)
double _successProbPerRoll(
  Map<String, dynamic> selectedPayload, {
  required String first,
  required String second,
  required String third,
}) {
  final p1 = _probOf((selectedPayload['첫번째'] as List).cast<dynamic>(), first);
  final p2 = _probOf((selectedPayload['두번째'] as List).cast<dynamic>(), second);
  final p3 = _probOf((selectedPayload['세번째'] as List).cast<dynamic>(), third);
  return p1 * p2 * p3;
}

/// ✅ 최소 보장 큐브 개수(정수): ceil(1/p)
int minCubesForTriple(
  Map<String, dynamic> selectedPayload, {
  required String first,
  required String second,
  required String third,
}) {
  final p = _successProbPerRoll(
    selectedPayload,
    first: first,
    second: second,
    third: third,
  );
  if (p <= 0) return 1 << 30; // 사실상 불가능 표시
  return (1.0 / p).ceil();
}

/// ✅ 최소 보장 메소(정수): minCubes × mesoPerRoll
int minMesoForTriple(
  Map<String, dynamic> selectedPayload, {
  required String first,
  required String second,
  required String third,
  required int mesoPerRoll, // int로 받아서 그냥 곱함
}) {
  final n = minCubesForTriple(
    selectedPayload,
    first: first,
    second: second,
    third: third,
  );
  if (n >= (1 << 30)) return 9223372036854775807; // 사실상 ∞ 표기용
  return n * mesoPerRoll;
}

/// 🎯 99% 확률 달성을 위한 큐브 개수
int cubesForTriple99(
  Map<String, dynamic> selectedPayload, {
  required String first,
  required String second,
  required String third,
}) {
  final p = _successProbPerRoll(
    selectedPayload,
    first: first,
    second: second,
    third: third,
  );
  if (p <= 0) return 1 << 30; // 사실상 불가능
  final n = math.log(1 - 0.99) / math.log(1 - p);
  return n.isNaN || n.isInfinite ? 1 << 30 : n.ceil();
}

/// 🎯 99% 확률 달성을 위한 메소
int mesoForTriple99(
  Map<String, dynamic> selectedPayload, {
  required String first,
  required String second,
  required String third,
  required int mesoPerRoll,
}) {
  final n = cubesForTriple99(
    selectedPayload,
    first: first,
    second: second,
    third: third,
  );
  if (n >= (1 << 30)) return 9223372036854775807; // ∞
  return n * mesoPerRoll;
}
