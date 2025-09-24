import 'dart:math' as math;

import 'package:flutter/material.dart';

// 공통
double _toProb01(dynamic v) {
  if (v == null) return 0.0;

  if (v is num) {
    // 0~1이면 그대로, 1~100은 %로 보고 나눔
    final x = v.toDouble();
    if (x <= 0) return 0.0;
    if (x <= 1) return x;
    if (x <= 100) return x / 100.0;
    // 100 초과면 소수로 들어온 게 아니므로 0 취급(데이터 이상)
    return 0.0;
  }

  if (v is String) {
    var s = v.trim();
    if (s.isEmpty) return 0.0;

    // 콤마/여러 공백/널 스페이스 제거
    s = s
        .replaceAll('\u00A0', ' ')
        .replaceAll('\u202F', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(',', '');

    final hasPercent = s.contains('%');

    // % 제거
    s = s.replaceAll('%', '');

    final x = double.tryParse(s);
    if (x == null || x <= 0) return 0.0;

    // "11.11%" 같은 형식 → 0.1111
    // "0.1111" 같은 형식 → 0.1111
    // "11.11" (퍼센트 기호 없지만 0~1 초과) → %로 간주해 0.1111
    if (hasPercent || x > 1.0) return x / 100.0;
    return x; // 0~1 사이면 이미 확률
  }

  // 그 외 타입은 0
  return 0.0;
}

double _probOne(List<dynamic> line, String name) {
  for (final e in line) {
    final m = Map<String, dynamic>.from(e as Map);
    if ((m['옵션'] ?? '') == name) return _toProb01(m['확률']);
  }
  debugPrint('[probOne] 옵션 미일치: "$name"');
  return 0.0;
}

bool _hasOption(List<dynamic> line, String name) {
  for (final e in line) {
    final m = Map<String, dynamic>.from(e as Map);
    if ((m['옵션'] ?? '') == name) return true;
  }
  return false;
}

// ===== 1) 확률 → 큐브 값어치(기대/95%/99%) =====
double cubeWorth(double p) => (p <= 0) ? double.infinity : 1.0 / p;
int cubeWorthForQ(double p, double q) {
  if (p <= 0 || q <= 0 || q >= 1) return 1 << 30;
  final n = math.log(1 - q) / math.log(1 - p);
  return n.isNaN || n.isInfinite ? (1 << 30) : n.ceil();
}

int cubeWorth95(double p) => cubeWorthForQ(p, 0.95);
int cubeWorth99(double p) => cubeWorthForQ(p, 0.99);

// 메소 환산
double mesoWorthExpected(double p, int mesoPerRoll) {
  final w = cubeWorth(p);
  return w.isInfinite ? double.infinity : w * mesoPerRoll;
}

int mesoWorth95(double p, int mesoPerRoll) {
  final k = cubeWorth95(p);
  return (k >= (1 << 30)) ? 1 << 30 : k * mesoPerRoll;
}

int mesoWorth99(double p, int mesoPerRoll) {
  final k = cubeWorth99(p);
  return (k >= (1 << 30)) ? 1 << 30 : k * mesoPerRoll;
}

// ===== 2) 한 라인에서 단일 옵션의 '큐브 값어치' =====
class Worth {
  final double p; // 확률(0~1)
  final double expected; // 기대 큐브 값어치
  final int k95, k99; // 95/99% 보수적 값어치
  final double expectedMeso;
  final int meso95, meso99;
  const Worth(
    this.p,
    this.expected,
    this.k95,
    this.k99,
    this.expectedMeso,
    this.meso95,
    this.meso99,
  );
}

Worth worthForSingleOption(
  Map<String, dynamic> payload, {
  required String lineKey, // '첫번째' | '두번째' | '세번째'
  required String optionName,
  required int mesoPerRoll,
}) {
  final line = (payload[lineKey] as List).cast<dynamic>();
  final p = _probOne(line, optionName);
  final expected = cubeWorth(p);
  final k95 = cubeWorth95(p);
  final k99 = cubeWorth99(p);
  final eM = mesoWorthExpected(p, mesoPerRoll);
  final m95 = mesoWorth95(p, mesoPerRoll);
  final m99 = mesoWorth99(p, mesoPerRoll);
  return Worth(p, expected, k95, k99, eM, m95, m99);
}

// ===== 3) 한 라인에서 OR 집합의 '큐브 값어치' (예: {STR+12, 올스탯+9}면 합확률) =====
Worth worthForAnyOf(
  Map<String, dynamic> payload, {
  required String lineKey,
  required Set<String> optionNames,
  required int mesoPerRoll,
}) {
  final line = (payload[lineKey] as List).cast<dynamic>();
  double p = 0.0;
  for (final name in optionNames) {
    p += _probOne(line, name);
  }
  p = p.clamp(0.0, 1.0);
  final expected = cubeWorth(p);
  final k95 = cubeWorth95(p);
  final k99 = cubeWorth99(p);
  final eM = mesoWorthExpected(p, mesoPerRoll);
  final m95 = mesoWorth95(p, mesoPerRoll);
  final m99 = mesoWorth99(p, mesoPerRoll);
  return Worth(p, expected, k95, k99, eM, m95, m99);
}

// ===== 4) 3줄 조합(순서 무관) '큐브 값어치' =====
List<List<String>> _uniquePermutations3(List<String> arr) {
  final a = [...arr]..sort();
  final used = List<bool>.filled(a.length, false);
  final res = <List<String>>[];
  void bt(List<String> cur) {
    if (cur.length == a.length) {
      res.add(List.of(cur));
      return;
    }
    String? prev;
    for (int i = 0; i < a.length; i++) {
      if (used[i]) continue;
      if (prev != null && a[i] == prev) continue;
      used[i] = true;
      cur.add(a[i]);
      bt(cur);
      cur.removeLast();
      used[i] = false;
      prev = a[i];
    }
  }

  bt([]);
  return res;
}

Worth worthForTripleIgnoringOrder(
  Map<String, dynamic> payload, {
  required String first,
  required String second,
  required String third,
  required int mesoPerRoll,
}) {
  final l1 = (payload['첫번째'] as List).cast<dynamic>();
  final l2 = (payload['두번째'] as List).cast<dynamic>();
  final l3 = (payload['세번째'] as List).cast<dynamic>();

  // 1) 1줄 전용/불가 옵션 판별
  final firstOnly1 =
      _hasOption(l1, first) && !_hasOption(l2, first) && !_hasOption(l3, first);
  final secondOnly1 =
      _hasOption(l1, second) &&
      !_hasOption(l2, second) &&
      !_hasOption(l3, second);
  final thirdOnly1 =
      _hasOption(l1, third) && !_hasOption(l2, third) && !_hasOption(l3, third);

  double p = 0.0;

  // 2) 유효한 배치만 계산
  // 케이스 A: 1줄이 사실상 고정(첫줄 전용 옵션이 하나라도 있으면)
  if (firstOnly1 || secondOnly1 || thirdOnly1) {
    // 1줄 고정 → 나머지 2줄만 스왑
    // final opts = [first, second, third];
    // 1줄에 들어갈 애를 고정으로 찾아 배치
    String a1, b1, c1;
    if (firstOnly1) {
      a1 = first;
      b1 = second;
      c1 = third;
    } else if (secondOnly1) {
      a1 = second;
      b1 = first;
      c1 = third;
    } else {
      a1 = third;
      b1 = first;
      c1 = second;
    }

    // (1,2,3) = (고정, b1, c1)
    if (_hasOption(l1, a1) && _hasOption(l2, b1) && _hasOption(l3, c1)) {
      p += _probOne(l1, a1) * _probOne(l2, b1) * _probOne(l3, c1);
    }
    // (1,3,2) = (고정, c1, b1)
    if (_hasOption(l1, a1) && _hasOption(l2, c1) && _hasOption(l3, b1)) {
      p += _probOne(l1, a1) * _probOne(l2, c1) * _probOne(l3, b1);
    }
  } else {
    // 케이스 B: 1줄 고정 아님 → 6개 순열 중 "모든 줄에서 허용되는" 배치만 합산
    final perms = _uniquePermutations3([first, second, third]);
    for (final a in perms) {
      if (!_hasOption(l1, a[0]) ||
          !_hasOption(l2, a[1]) ||
          !_hasOption(l3, a[2])) {
        continue;
      }
      final p1 = _probOne(l1, a[0]);
      final p2 = _probOne(l2, a[1]);
      final p3 = _probOne(l3, a[2]);
      if (p1 > 0 && p2 > 0 && p3 > 0) p += p1 * p2 * p3;
    }
  }

  final expected = cubeWorth(p);
  final k95 = cubeWorth95(p);
  final k99 = cubeWorth99(p);
  final eM = mesoWorthExpected(p, mesoPerRoll);
  final m95 = mesoWorth95(p, mesoPerRoll);
  final m99 = mesoWorth99(p, mesoPerRoll);
  return Worth(p, expected, k95, k99, eM, m95, m99);
}
