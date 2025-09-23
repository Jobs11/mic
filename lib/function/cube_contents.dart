import 'dart:math' as math;

// ===== 공통 유틸 =====
double _toProb01(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) {
    final d = v.toDouble();
    return (d > 1.0) ? (d / 100.0) : d;
  }
  var s = v.toString().trim();
  s = s.replaceAll(' %', '%');
  final isPercent = s.endsWith('%');
  if (isPercent) s = s.substring(0, s.length - 1).trim();
  final hasDot = s.contains('.');
  final hasComma = s.contains(',');
  final normalized = (hasComma && !hasDot)
      ? s.replaceAll(',', '.')
      : (hasComma && hasDot)
      ? s.replaceAll(',', '')
      : s;
  final val = double.tryParse(normalized) ?? 0.0;
  return isPercent ? (val / 100.0) : (val > 1.0 ? val / 100.0 : val);
}

double _probOne(List<dynamic> line, String name) {
  for (final e in line) {
    final m = Map<String, dynamic>.from(e as Map);
    if ((m['옵션'] ?? '') == name) return _toProb01(m['확률']);
  }
  return 0.0;
}

// ===== “멀티셋(같은 옵션 묶기)” 만들기: 옵션 3개 받아서 자동 그룹 =====
Map<String, int> _multisetFromThree(String? a, String? b, String? c) {
  final list = [
    a,
    b,
    c,
  ].where((s) => s != null && s!.trim().isNotEmpty).map((s) => s!.trim());
  final map = <String, int>{};
  for (final name in list) {
    map[name] = (map[name] ?? 0) + 1;
  }
  return map; // 예: {'STR +12%': 2, 'STR +9%': 1}
}

// ===== 줄 순서 무관: 멀티셋을 1/2/3줄에 배치하는 모든 경우 확률 합 =====
// ⚠️ 일부 줄을 제한하지 않으면(옵션을 1~2개만 고르면) 남은 줄은 "상관없음"으로 보고 확률 1.0 처리
double probExactMultiset(
  Map<String, dynamic> payload,
  Map<String, int> needCounts,
) {
  final lines = [
    (payload['첫번째'] as List).cast<dynamic>(),
    (payload['두번째'] as List).cast<dynamic>(),
    (payload['세번째'] as List).cast<dynamic>(),
  ];

  bool _allZero(Map<String, int> m) => m.values.every((c) => c == 0);

  double dfs(int idx, Map<String, int> need) {
    if (idx == lines.length) {
      // 모든 줄 배치 끝. 요구 멀티셋을 정확히 소진했으면 성공
      return _allZero(need) ? 1.0 : 0.0;
    }
    if (_allZero(need)) {
      // 더 요구하는 게 없으면 나머지 줄은 아무거나 허용 → 확률 1.0
      return 1.0;
    }

    final line = lines[idx];
    double sum = 0.0;
    // 이번 줄에 어떤 목표옵션을 둘지 모두 시도
    need.forEach((opt, cnt) {
      if (cnt > 0) {
        final p = _probOne(line, opt);
        if (p > 0) {
          final next = Map<String, int>.from(need)..[opt] = cnt - 1;
          sum += p * dfs(idx + 1, next);
        }
      }
    });
    return sum;
  }

  return dfs(0, Map<String, int>.from(needCounts));
}

// ===== 결과 패키징 =====
class CubeStats {
  final double p; // 한 번에 성공 확률(0~1)
  final double? expected; // 기대 큐브수 1/p
  final int? k95; // 95% 달성 필요 큐브
  final int? k99; // 99% 달성 필요 큐브
  final double? expectedMeso;
  final int? meso95;
  final int? meso99;
  CubeStats({
    required this.p,
    this.expected,
    this.k95,
    this.k99,
    this.expectedMeso,
    this.meso95,
    this.meso99,
  });
}

CubeStats cubesForThreeOptions(
  Map<String, dynamic> payload, {
  required String? first, // null/"" 가능(상관없음)
  required String? second, // null/"" 가능
  required String? third, // null/"" 가능
  required int mesoPerRoll,
}) {
  final need = _multisetFromThree(first, second, third);
  final p = probExactMultiset(payload, need);
  if (p <= 0) {
    return CubeStats(p: 0);
  }
  double exp = 1.0 / p;
  int kFor(double q) {
    final n = math.log(1 - q) / math.log(1 - p);
    return (n.isNaN || n.isInfinite) ? (1 << 30) : n.ceil();
  }

  final k95 = kFor(0.95);
  final k99 = kFor(0.99);
  return CubeStats(
    p: p,
    expected: exp,
    k95: k95,
    k99: k99,
    expectedMeso: exp * mesoPerRoll,
    meso95: k95 * mesoPerRoll,
    meso99: k99 * mesoPerRoll,
  );
}
