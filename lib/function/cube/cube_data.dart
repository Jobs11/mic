// cube_data.dart
import 'dart:math';
import 'package:flutter/foundation.dart'; // compute 사용

/// ------------------------------
/// 기본 1회 시뮬: 성공할 때까지 굴려서 "걸린 큐브 개수" 반환
/// - 불가능 조합(p=0)이면 -1 반환 (∞ 의미)
/// - 가능한 조합(p>0)이면 반드시 양의 정수 반환
/// ------------------------------
int simulateUntilAllThreeOnce({
  required Map<String, dynamic> selectedPayload,
  required String firstOpt,
  required String secondOpt,
  required String thirdOpt,
}) {
  // --- helpers ---
  double parseProb(dynamic v) {
    if (v is num) return v.toDouble() / 100.0;
    final s = v.toString().trim();
    final t = s.endsWith('%') ? s.substring(0, s.length - 1) : s;
    final d = double.tryParse(t) ?? 0.0;
    return d / 100.0;
  }

  double lineOptionProb(List<dynamic> line, String opt) {
    for (final e in line) {
      if ((e['옵션']?.toString() ?? '') == opt) {
        return parseProb(e['확률']);
      }
    }
    return 0.0;
  }

  double tripleAllAnyOrderProb(
    Map<String, dynamic> payload,
    String a,
    String b,
    String c,
  ) {
    final l1 = (payload['첫번째'] as List?) ?? const [];
    final l2 = (payload['두번째'] as List?) ?? const [];
    final l3 = (payload['세번째'] as List?) ?? const [];

    final p1a = lineOptionProb(l1, a),
        p1b = lineOptionProb(l1, b),
        p1c = lineOptionProb(l1, c);
    final p2a = lineOptionProb(l2, a),
        p2b = lineOptionProb(l2, b),
        p2c = lineOptionProb(l2, c);
    final p3a = lineOptionProb(l3, a),
        p3b = lineOptionProb(l3, b),
        p3c = lineOptionProb(l3, c);

    final s =
        p1a * p2b * p3c +
        p1a * p2c * p3b +
        p1b * p2a * p3c +
        p1b * p2c * p3a +
        p1c * p2a * p3b +
        p1c * p2b * p3a;

    return (s < 0) ? 0.0 : (s > 1 ? 1.0 : s);
  }

  String? sampleOne(Random rng, List<dynamic> line) {
    // 누적합 방식 샘플링 (합이 1 미만이면 남는 꼬리는 null)
    final r = rng.nextDouble();
    double acc = 0.0;
    for (final e in line) {
      acc += parseProb(e['확률']);
      if (r < acc) return e['옵션']?.toString();
    }
    return null;
  }

  bool trial(
    Random rng,
    Map<String, dynamic> payload,
    String a,
    String b,
    String c,
  ) {
    final l1 = (payload['첫번째'] as List?) ?? const [];
    final l2 = (payload['두번째'] as List?) ?? const [];
    final l3 = (payload['세번째'] as List?) ?? const [];

    final o1 = sampleOne(rng, l1);
    final o2 = sampleOne(rng, l2);
    final o3 = sampleOne(rng, l3);
    if (o1 == null || o2 == null || o3 == null) return false;

    final got = [o1, o2, o3]..sort();
    final want = [a, b, c]..sort();
    return got[0] == want[0] && got[1] == want[1] && got[2] == want[2];
  }
  // --- /helpers ---

  // 1) 구조적으로 불가능이면 즉시 -1 (∞ 의미)
  final p = tripleAllAnyOrderProb(
    selectedPayload,
    firstOpt,
    secondOpt,
    thirdOpt,
  );
  if (p <= 0) return -1;

  // 2) 가능한 경우: 성공할 때까지 무한히 굴림 (절대 -1 안 나옴)
  final rng = Random();
  int tries = 0;
  while (true) {
    tries++;
    if (trial(rng, selectedPayload, firstOpt, secondOpt, thirdOpt)) {
      return tries;
    }
  }
}

/// ------------------------------
/// (동기) 만 번 반복 평균 → 올림(ceil) int
/// ⚠️ 메인 isolate에서 10k 루프라 UI가 멈출 수 있음. 테스트/콘솔용으로만.
/// ------------------------------
int cubeAverageCountCeilSync({
  required Map<String, dynamic> selectedPayload,
  required String firstOpt,
  required String secondOpt,
  required String thirdOpt,
  int runs = 10000,
}) {
  // 불가능 조합은 바로 -1
  final first = simulateUntilAllThreeOnce(
    selectedPayload: selectedPayload,
    firstOpt: firstOpt,
    secondOpt: secondOpt,
    thirdOpt: thirdOpt,
  );
  if (first == -1) return -1;

  int total = first;
  for (int i = 1; i < runs; i++) {
    total += simulateUntilAllThreeOnce(
      selectedPayload: selectedPayload,
      firstOpt: firstOpt,
      secondOpt: secondOpt,
      thirdOpt: thirdOpt,
    );
  }
  final avg = total / runs;
  return avg.ceil();
}

/// ------------------------------
/// (비동기, 권장) 만 번 반복 평균 → 올림(ceil) int
/// - compute()로 백그라운드에서 루프 실행 → UI 프리징 방지
/// - 불가능 조합이면 -1 반환
/// ------------------------------
Future<int> cubeAverageCountCeil({
  required Map<String, dynamic> selectedPayload,
  required String firstOpt,
  required String secondOpt,
  required String thirdOpt,
  int runs = 10000,
}) async {
  final avg = await compute(_cubeAverageWorker, <String, dynamic>{
    'payload': selectedPayload,
    'a': firstOpt,
    'b': secondOpt,
    'c': thirdOpt,
    'runs': runs,
  });

  if (avg.isInfinite) return -1; // ∞ → -1로 통일
  return avg.ceil();
}

/// compute()에서 호출될 top-level 함수 (필수: 최상위여야 함)
double _cubeAverageWorker(Map<String, dynamic> args) {
  final payload = args['payload'] as Map<String, dynamic>;
  final a = args['a'] as String;
  final b = args['b'] as String;
  final c = args['c'] as String;
  final runs = args['runs'] as int;

  // 불가능 조합인지 먼저 확인
  final first = simulateUntilAllThreeOnce(
    selectedPayload: payload,
    firstOpt: a,
    secondOpt: b,
    thirdOpt: c,
  );
  if (first == -1) {
    return double.infinity; // 호출부에서 -1로 변환
  }

  int total = first;
  for (int i = 1; i < runs; i++) {
    total += simulateUntilAllThreeOnce(
      selectedPayload: payload,
      firstOpt: a,
      secondOpt: b,
      thirdOpt: c,
    );
  }
  return total / runs;
}
