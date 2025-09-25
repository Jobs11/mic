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

// ========================
// 2줄(순서 무관) 성공 판정/시뮬 추가
// ========================

/// payload의 각 줄(첫/둘/셋)에서 특정 옵션 opt가 나올 확률 튜플 반환
/// (l1, l2, l3)
({double l1, double l2, double l3}) _lineProbsFor(
  Map<String, dynamic> payload,
  String opt,
) {
  double parseProb(dynamic v) {
    if (v is num) return v.toDouble() / 100.0;
    final s = v.toString().trim();
    final t = s.endsWith('%') ? s.substring(0, s.length - 1) : s;
    final d = double.tryParse(t) ?? 0.0;
    return d / 100.0;
  }

  double lineOptionProb(List<dynamic> line, String o) {
    for (final e in line) {
      if ((e['옵션']?.toString() ?? '') == o) {
        return parseProb(e['확률']);
      }
    }
    return 0.0;
  }

  final l1 = (payload['첫번째'] as List?) ?? const [];
  final l2 = (payload['두번째'] as List?) ?? const [];
  final l3 = (payload['세번째'] as List?) ?? const [];

  return (
    l1: lineOptionProb(l1, opt),
    l2: lineOptionProb(l2, opt),
    l3: lineOptionProb(l3, opt),
  );
}

/// 1회에 2줄 만족(순서 무관)할 확률을 '분석적으로' 계산
/// - a != b : P(적어도 한 줄이 a) ∩ P(적어도 한 줄이 b)
///   => 1 - ∏(1-p_i(a)) - ∏(1-p_i(b)) + ∏(1 - p_i(a) - p_i(b))
/// - a == b : 3줄 중 최소 2줄이 a
double twoLineSuccessProbAnyOrder(
  Map<String, dynamic> payload,
  String a,
  String b,
) {
  final pa = _lineProbsFor(payload, a);
  final pb = _lineProbsFor(payload, b);

  if (a != b) {
    final noA = (1 - pa.l1) * (1 - pa.l2) * (1 - pa.l3);
    final noB = (1 - pb.l1) * (1 - pb.l2) * (1 - pb.l3);
    // 각 줄에서 a/b가 동시에 나올 수 없으므로 (단일 선택) 줄 단위로 1 - pa - pb가 'a도 b도 아님'
    final noAandNoB =
        (1 - pa.l1 - pb.l1).clamp(0.0, 1.0) *
        (1 - pa.l2 - pb.l2).clamp(0.0, 1.0) *
        (1 - pa.l3 - pb.l3).clamp(0.0, 1.0);
    final p = 1 - noA - noB + noAandNoB;
    return p.clamp(0.0, 1.0);
  } else {
    // 최소 2줄이 a : C(3,2)*(p_i p_j (1 - p_k)) + p1 p2 p3
    final p1 = pa.l1, p2 = pa.l2, p3 = pa.l3;
    final atLeast2 =
        (p1 * p2 * (1 - p3)) +
        (p1 * p3 * (1 - p2)) +
        (p2 * p3 * (1 - p1)) +
        (p1 * p2 * p3); // 3줄 모두 포함
    return atLeast2.clamp(0.0, 1.0);
  }
}

/// 한 번 성공 나올 때까지 큐브를 굴려서 '걸린 큐브 개수' 반환 (불가능이면 -1)
int simulateUntilTwoOnce({
  required Map<String, dynamic> selectedPayload,
  required String firstOpt, // 원하는 옵션1
  required String secondOpt, // 원하는 옵션2
}) {
  // 1) 구조적으로 불가능 체크
  final p = twoLineSuccessProbAnyOrder(selectedPayload, firstOpt, secondOpt);
  if (p <= 0) return -1;

  // 2) 샘플링 함수
  double parseProb(dynamic v) {
    if (v is num) return v.toDouble() / 100.0;
    final s = v.toString().trim();
    final t = s.endsWith('%') ? s.substring(0, s.length - 1) : s;
    final d = double.tryParse(t) ?? 0.0;
    return d / 100.0;
  }

  String? sampleOne(Random rng, List<dynamic> line) {
    final r = rng.nextDouble();
    double acc = 0.0;
    for (final e in line) {
      acc += parseProb(e['확률']);
      if (r < acc) return e['옵션']?.toString();
    }
    return null; // 꼬리 확률(합<1)로 아무 것도 안 뽑히는 케이스
  }

  bool trial(Random rng) {
    final l1 = (selectedPayload['첫번째'] as List?) ?? const [];
    final l2 = (selectedPayload['두번째'] as List?) ?? const [];
    final l3 = (selectedPayload['세번째'] as List?) ?? const [];

    final o1 = sampleOne(rng, l1);
    final o2 = sampleOne(rng, l2);
    final o3 = sampleOne(rng, l3);
    if (o1 == null || o2 == null || o3 == null) return false;

    final a = firstOpt;
    final b = secondOpt;

    if (a != b) {
      // 서로 다른 두 옵션이 "각각 최소 한 줄"에 포함되면 성공
      final hasA = (o1 == a) || (o2 == a) || (o3 == a);
      final hasB = (o1 == b) || (o2 == b) || (o3 == b);
      return hasA && hasB;
    } else {
      // 동일 옵션이 2줄 이상 포함되면 성공
      final countA = [o1, o2, o3].where((o) => o == a).length;
      return countA >= 2;
    }
  }

  // 3) 성공할 때까지 루프
  final rng = Random();
  int tries = 0;
  while (true) {
    tries++;
    if (trial(rng)) return tries;
  }
}

/// 동기 평균(테스트/콘솔용) — runs번 시뮬 후 평균 올림, 불가능이면 -1
int cubeAverageCountCeilTwoSync({
  required Map<String, dynamic> selectedPayload,
  required String firstOpt,
  required String secondOpt,
  int runs = 10000,
}) {
  final first = simulateUntilTwoOnce(
    selectedPayload: selectedPayload,
    firstOpt: firstOpt,
    secondOpt: secondOpt,
  );
  if (first == -1) return -1;

  int total = first;
  for (int i = 1; i < runs; i++) {
    total += simulateUntilTwoOnce(
      selectedPayload: selectedPayload,
      firstOpt: firstOpt,
      secondOpt: secondOpt,
    );
  }
  return (total / runs).ceil();
}

/// 비동기 평균(권장) — compute()로 백그라운드 실행, 불가능이면 -1
Future<int> cubeAverageCountCeilTwo({
  required Map<String, dynamic> selectedPayload,
  required String firstOpt,
  required String secondOpt,
  int runs = 10000,
}) async {
  final avg = await compute(_cubeAverageTwoWorker, <String, dynamic>{
    'payload': selectedPayload,
    'a': firstOpt,
    'b': secondOpt,
    'runs': runs,
  });

  if (avg.isInfinite) return -1;
  return avg.ceil();
}

/// compute() 워커(2줄 버전)
double _cubeAverageTwoWorker(Map<String, dynamic> args) {
  final payload = args['payload'] as Map<String, dynamic>;
  final a = args['a'] as String;
  final b = args['b'] as String;
  final runs = args['runs'] as int;

  final first = simulateUntilTwoOnce(
    selectedPayload: payload,
    firstOpt: a,
    secondOpt: b,
  );
  if (first == -1) {
    return double.infinity;
  }

  int total = first;
  for (int i = 1; i < runs; i++) {
    total += simulateUntilTwoOnce(
      selectedPayload: payload,
      firstOpt: a,
      secondOpt: b,
    );
  }
  return total / runs;
}

// ========================
// 1줄(순서 무관) 성공 판정/시뮬 추가
// ========================

/// 내부 헬퍼: payload의 각 줄에서 특정 옵션 opt가 나올 확률 튜플(l1,l2,l3) 계산
({double l1, double l2, double l3}) _lineProbsForOne(
  Map<String, dynamic> payload,
  String opt,
) {
  double parseProb(dynamic v) {
    if (v is num) return v.toDouble() / 100.0;
    final s = v.toString().trim();
    final t = s.endsWith('%') ? s.substring(0, s.length - 1) : s;
    final d = double.tryParse(t) ?? 0.0;
    return d / 100.0;
  }

  double lineOptionProb(List<dynamic> line, String o) {
    for (final e in line) {
      if ((e['옵션']?.toString() ?? '') == o) {
        return parseProb(e['확률']);
      }
    }
    return 0.0;
  }

  final l1 = (payload['첫번째'] as List?) ?? const [];
  final l2 = (payload['두번째'] as List?) ?? const [];
  final l3 = (payload['세번째'] as List?) ?? const [];

  return (
    l1: lineOptionProb(l1, opt),
    l2: lineOptionProb(l2, opt),
    l3: lineOptionProb(l3, opt),
  );
}

/// 1회에 '해당 옵션이 최소 한 줄'에서 뜰 확률
/// P = 1 - ∏(1 - p_i)
double oneLineSuccessProbAnyOrder(Map<String, dynamic> payload, String opt) {
  final p = _lineProbsForOne(payload, opt);
  final no = (1 - p.l1) * (1 - p.l2) * (1 - p.l3);
  return (1 - no).clamp(0.0, 1.0);
}

/// 한 번 성공 나올 때까지 큐브를 굴려서 '걸린 큐브 개수' 반환 (불가능이면 -1)
int simulateUntilOneOnce({
  required Map<String, dynamic> selectedPayload,
  required String opt, // 원하는 옵션 1개
}) {
  // 1) 구조적으로 불가능 체크
  final p = oneLineSuccessProbAnyOrder(selectedPayload, opt);
  if (p <= 0) return -1;

  // 2) 샘플러
  double parseProb(dynamic v) {
    if (v is num) return v.toDouble() / 100.0;
    final s = v.toString().trim();
    final t = s.endsWith('%') ? s.substring(0, s.length - 1) : s;
    final d = double.tryParse(t) ?? 0.0;
    return d / 100.0;
  }

  String? sampleOne(Random rng, List<dynamic> line) {
    final r = rng.nextDouble();
    double acc = 0.0;
    for (final e in line) {
      acc += parseProb(e['확률']);
      if (r < acc) return e['옵션']?.toString();
    }
    return null; // (합<1)인 꼬리 확률 처리
  }

  bool trial(Random rng) {
    final l1 = (selectedPayload['첫번째'] as List?) ?? const [];
    final l2 = (selectedPayload['두번째'] as List?) ?? const [];
    final l3 = (selectedPayload['세번째'] as List?) ?? const [];

    final o1 = sampleOne(rng, l1);
    final o2 = sampleOne(rng, l2);
    final o3 = sampleOne(rng, l3);
    if (o1 == null || o2 == null || o3 == null) return false;

    return o1 == opt || o2 == opt || o3 == opt;
  }

  // 3) 성공할 때까지 루프
  final rng = Random();
  int tries = 0;
  while (true) {
    tries++;
    if (trial(rng)) return tries;
  }
}

/// 동기 평균(테스트/콘솔용) — runs번 시뮬 후 평균 올림, 불가능이면 -1
int cubeAverageCountCeilOneSync({
  required Map<String, dynamic> selectedPayload,
  required String opt,
  int runs = 10000,
}) {
  final first = simulateUntilOneOnce(
    selectedPayload: selectedPayload,
    opt: opt,
  );
  if (first == -1) return -1;

  int total = first;
  for (int i = 1; i < runs; i++) {
    total += simulateUntilOneOnce(selectedPayload: selectedPayload, opt: opt);
  }
  return (total / runs).ceil();
}

/// 비동기 평균(권장) — compute()로 백그라운드 실행, 불가능이면 -1
Future<int> cubeAverageCountCeilOne({
  required Map<String, dynamic> selectedPayload,
  required String opt,
  int runs = 10000,
}) async {
  final avg = await compute(_cubeAverageOneWorker, <String, dynamic>{
    'payload': selectedPayload,
    'opt': opt,
    'runs': runs,
  });

  if (avg.isInfinite) return -1;
  return avg.ceil();
}

/// compute() 워커(1줄 버전)
double _cubeAverageOneWorker(Map<String, dynamic> args) {
  final payload = args['payload'] as Map<String, dynamic>;
  final opt = args['opt'] as String;
  final runs = args['runs'] as int;

  final first = simulateUntilOneOnce(selectedPayload: payload, opt: opt);
  if (first == -1) return double.infinity;

  int total = first;
  for (int i = 1; i < runs; i++) {
    total += simulateUntilOneOnce(selectedPayload: payload, opt: opt);
  }
  return total / runs;
}
