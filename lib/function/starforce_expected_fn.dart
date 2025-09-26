import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

/// ====== 확률 테이블 ======

double _toDouble(dynamic v) {
  if (v is num) return v.toDouble();
  return double.parse(v.toString().trim());
}

class StarRates {
  final double success; // 성공
  final double failStay; // 실패(유지)
  final double failDown; // 실패(하락) — KMS 파일에는 없으니 0으로 두고 규칙으로 처리
  final double destroy; // 파괴
  const StarRates({
    required this.success,
    required this.failStay,
    required this.failDown,
    required this.destroy,
  });

  StarRates toUnitScale() {
    bool isPct(double v) => v > 1.0;
    if (isPct(success) ||
        isPct(failStay) ||
        isPct(failDown) ||
        isPct(destroy)) {
      return StarRates(
        success: success / 100.0,
        failStay: failStay / 100.0,
        failDown: failDown / 100.0,
        destroy: destroy / 100.0,
      );
    }
    return this;
  }

  StarRates normalize() {
    final s = success + failStay + failDown + destroy;
    if (s == 0) return this;
    return StarRates(
      success: success / s,
      failStay: failStay / s,
      failDown: failDown / s,
      destroy: destroy / s,
    );
  }
}

class StarforceProbTable {
  /// 기존 코드 호환을 위해 유지 (레벨 → 별 → 확률)
  final Map<int, Map<int, StarRates>> _tbl = {};

  Future<void> load(String assetPath) async {
    final jsonStr = await rootBundle.loadString(assetPath);
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    _tbl.clear();

    // 스키마 감지: 값에 "성공" 키가 있으면 KMS 1단계 스키마
    final firstVal = data.values.first;
    final isKmsOneDepth = firstVal is Map && firstVal.containsKey("성공");

    if (isKmsOneDepth) {
      // ✅ KMS 1단계 스키마: "0":{"성공":"95.00","유지":"5.00","파괴":"0.00",...}
      // 레벨 구분이 없으니, 모든 장비레벨에서 동일 확률을 쓰도록 “가상 레벨” 키를 하나 만들거나,
      // 실제로 사용할 장비레벨에 그대로 복제해도 됩니다.
      final perStar = <int, StarRates>{};
      for (final e in data.entries) {
        final star = int.parse(e.key); // "0","1",...
        final row = Map<String, dynamic>.from(e.value as Map);
        final succ = _toDouble(row["성공"]);
        final stay = _toDouble(row["유지"]);
        final destr = _toDouble(row["파괴"]);
        // 주어진 파일에는 failDown 개별 필드가 없으므로 0으로 두고,
        // 하락/유지 분기는 시뮬 단계에서 "별 기준 규칙"으로 나눠주세요.
        final rates = StarRates(
          success: succ,
          failStay: stay,
          failDown: 0,
          destroy: destr,
        ).toUnitScale().normalize();
        perStar[star] = rates;
      }
      // 모든 레벨에서 공동 사용하도록 대표 키를 하나로 넣는다. (예: 0 = 공통)
      _tbl[0] = perStar;
    } else {
      // ✅ 기존 2단계 스키마: "140": { "0": {"success":..,"fail_stay":..} ... }
      for (final e in data.entries) {
        final equipLevel = int.parse(e.key);
        final perStar = <int, StarRates>{};

        final m = Map<String, dynamic>.from(e.value);
        for (final s in m.entries) {
          final star = int.parse(s.key);
          final v = Map<String, dynamic>.from(s.value);
          final rates = StarRates(
            success: _toDouble(v['success']),
            failStay: _toDouble(v['fail_stay'] ?? v['failStay'] ?? 0),
            failDown: _toDouble(v['fail_down'] ?? v['failDown'] ?? 0),
            destroy: _toDouble(v['destroy'] ?? 0),
          ).toUnitScale().normalize();
          perStar[star] = rates;
        }
        _tbl[equipLevel] = perStar;
      }
    }
  }

  /// KMS 1단계 파일을 쓴 경우, equipLevel은 0으로 넣어서 읽거나
  /// 내부에서 fallback 하도록 구현
  StarRates rates(int equipLevel, int star) {
    Map<int, StarRates>? lvMap = _tbl[equipLevel];
    lvMap ??= _tbl[0]; // KMS 1단계 스키마 fallback
    if (lvMap == null) {
      throw ArgumentError('장비 레벨 $equipLevel 확률 데이터가 없습니다.');
    }
    final r = lvMap[star];
    if (r == null) {
      throw ArgumentError('$equipLevel 레벨의 $star성 확률 데이터가 없습니다.');
    }
    return r;
  }
}

/// ====== 메소(강화비용) 테이블 ======
/// starforce_meso.json 구조(예시):
/// {
///   "140": [ {"from":0, "base_meso": 1000}, {"from":1, "base_meso": 2000}, ... ],
///   "150": [ ... ]
/// }
class StarforceMesoTable {
  final Map<int, Map<int, int>> _baseCost =
      {}; // [equipLevel][fromStar] = base_meso

  Future<void> load(String assetPath) async {
    final jsonStr = await rootBundle.loadString(
      assetPath,
    ); // assets/datas/starforce_meso.json
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    _baseCost.clear();

    for (final e in data.entries) {
      final equipLevel = int.parse(e.key);
      final list = (e.value as List)
          .map((x) => Map<String, dynamic>.from(x))
          .toList();
      final map = <int, int>{};
      for (final row in list) {
        final from = (row['from'] as num).toInt();
        final base = (row['base_meso'] as num).toInt();
        map[from] = base;
      }
      _baseCost[equipLevel] = map;
    }
  }

  int baseCost(int equipLevel, int fromStar) {
    final lv = _baseCost[equipLevel];
    if (lv == null) throw ArgumentError('장비 레벨 $equipLevel 메소 데이터 없음');
    final c = lv[fromStar];
    if (c == null) throw ArgumentError('$equipLevel레벨 $fromStar→ 강화비용 데이터 없음');
    return c;
  }
}

/// ====== 이벤트/토글 설정 ======

class EventConfig {
  /// 전체 이벤트 스위치 (true일 때 아래 옵션/할인들을 “적용”한다고 가정)
  final bool eventOn;

  /// 스타캐치 적용 (성공확률 가중 1.05배 후 정규화)
  final bool starCatch;

  /// 파괴 30% 감소 이벤트
  final bool reduceDestroy30;

  /// 세이프가드 (12~16성 파괴 → 하락 처리, 비용 2배)
  final bool safeguard;

  /// MVP/PC방 할인률 (0.10 = 10%)
  final double mvpDiscount;
  final double pcDiscount;

  /// 스타포스 할인률 (공식이 0.7배이므로 30% 할인 = 0.30)
  /// 질문에서 “강화비용 × {1.0 - (MVP+PC방)} × 0.7” 이라면 starforceDiscount=0.30 으로 두고,
  /// eventOn일 때만 적용되게 하면 됨.
  final double starforceDiscount;

  const EventConfig({
    required this.eventOn,
    this.starCatch = false,
    this.reduceDestroy30 = false,
    this.safeguard = false,
    this.mvpDiscount = 0.0,
    this.pcDiscount = 0.0,
    this.starforceDiscount = 0.0,
  });
}

/// ====== 확률/비용 적용 유틸 ======

StarRates applyProbOptions(StarRates base, int star, EventConfig cfg) {
  var r = base;

  if (cfg.eventOn && cfg.reduceDestroy30) {
    r = StarRates(
      success: r.success,
      failStay: r.failStay,
      failDown: r.failDown,
      destroy: r.destroy * 0.7, // 단순 0.7배 후 재정규화
    ).normalize();
  }

  if (cfg.eventOn && cfg.starCatch) {
    r = StarRates(
      success: r.success * 1.05,
      failStay: r.failStay,
      failDown: r.failDown,
      destroy: r.destroy,
    ).normalize();
  }

  // 세이프가드는 "확률"은 바꾸지 않고 결과 처리 단계에서 파괴->하락으로 해석해도 되지만,
  // 여기서는 destroy를 failDown에 흡수한 버전도 가능.
  // 실제 결과 처리에서 분기할 거라면 여기선 그대로 두고, 아래 simulate 내부 분기로 처리해도 OK.
  return r;
}

/// 이벤트 메소 공식 적용:
/// cost = base × {1.0 - (MVP + PC방)} × (eventOn && starforceDiscount>0 ? (1.0 - starforceDiscount) : 1.0)
/// 세이프가드: 12~16성 구간에서 비용 2배
int applyMesoFormula({
  required int base,
  required int fromStar,
  required EventConfig cfg,
}) {
  double cost = base.toDouble();

  final percent = (cfg.mvpDiscount + cfg.pcDiscount).clamp(
    0.0,
    0.95,
  ); // 과도한 음수 방지용 클램프
  cost *= (1.0 - percent);

  if (cfg.eventOn && cfg.starforceDiscount > 0) {
    cost *= (1.0 - cfg.starforceDiscount); // 예: 0.30 -> 70% 지불
  }

  if (cfg.eventOn && cfg.safeguard && fromStar >= 12 && fromStar <= 16) {
    cost *= 3.0; // 세이프가드 비용 2배
  }

  // 반올림 (게임은 정수 메소)
  return cost.round();
}

/// ====== 시뮬레이터 ======

class PerStarStat {
  final int star; // from = star (k -> k+1 시도)
  int attempts = 0; // 총 시도 수
  int success = 0; // 성공 횟수
  int stay = 0; // 유지 횟수
  int down = 0; // 하락 횟수
  int destroy = 0; // 파괴 횟수
  int mesoSpent = 0; // 이 성에서 쓴 총 메소

  PerStarStat(this.star);

  Map<String, dynamic> toJson() => {
    "성": star,
    "시도": attempts,
    "성공": success,
    "유지": stay,
    "하락": down,
    "파괴": destroy,
    "메소": mesoSpent,
  };
}

class SimResult {
  final int tries;
  final int totalMeso;
  final int successCount;
  final int stayCount;
  final int downCount;
  final int destroyCount;

  // ▼ 추가: 성별 집계(옵션), 타임라인 로그(옵션)
  final Map<int, PerStarStat>? perStar; // key = fromStar
  final List<int>? starTimeline; // 각 시도 "전"의 fromStar 스냅샷

  const SimResult({
    required this.tries,
    required this.totalMeso,
    required this.successCount,
    required this.stayCount,
    required this.downCount,
    required this.destroyCount,
    this.perStar,
    this.starTimeline,
  });
}

class StarforceSimulator {
  final StarforceProbTable probTable;
  final StarforceMesoTable mesoTable;

  const StarforceSimulator(this.probTable, this.mesoTable);

  /// 단일 시뮬레이션
  Future<SimResult> simulateOnce({
    required int equipLevel,
    required int start,
    required int target,
    required EventConfig cfg,
    int destroyRollbackTo = 12,
    Random? random,
    bool safeguardAsFailDown = true,

    // 상세 집계/로그 수집 여부
    bool collectDetail = true,
  }) async {
    final rng = random ?? Random();
    int cur = start;
    int tries = 0;
    int totalMeso = 0;

    int cS = 0, cSt = 0, cDn = 0, cX = 0;

    // 성별 집계 & 타임라인
    final Map<int, PerStarStat> perStar = {};
    final List<int> timeline = [];

    while (cur < target) {
      if (collectDetail) timeline.add(cur);

      // 1) 비용
      final base = mesoTable.baseCost(equipLevel, cur);
      final cost = applyMesoFormula(base: base, fromStar: cur, cfg: cfg);
      totalMeso += cost;

      // 2) 확률
      final baseRates = probTable.rates(equipLevel, cur);
      final r = applyProbOptions(baseRates, cur, cfg);

      // 3) 현재 성 집계 객체 (nullable)
      PerStarStat? stat;
      if (collectDetail) {
        stat = perStar.putIfAbsent(cur, () => PerStarStat(cur));
        stat.attempts += 1;
        stat.mesoSpent += cost;
      }

      // 4) 롤
      final roll = rng.nextDouble();
      tries++;

      final pS = r.success;
      final pSt = r.failStay;
      final pDn = r.failDown;

      if (roll < pS) {
        cS++;
        if (collectDetail) stat?.success += 1;
        cur += 1;
      } else if (roll < pS + pSt) {
        cSt++;
        if (collectDetail) stat?.stay += 1;
        // stay
      } else if (roll < pS + pSt + pDn) {
        cDn++;
        if (collectDetail) stat?.down += 1;
        cur -= 1;
        if (cur < 0) cur = 0;
      } else {
        // destroy or safeguard-as-down
        final safeguardActive =
            (cfg.eventOn &&
            cfg.safeguard &&
            cur >= 12 &&
            cur <= 16 &&
            safeguardAsFailDown);

        if (safeguardActive) {
          // 파괴를 하락으로 간주 (destroy 카운트 X)
          cDn++;
          if (collectDetail) stat?.down += 1;
          cur -= 1;
          if (cur < 0) cur = 0;
        } else {
          // 실제 파괴
          cX++;
          if (collectDetail) stat?.destroy += 1;
          cur = destroyRollbackTo;
        }
      }
    }

    return SimResult(
      tries: tries,
      totalMeso: totalMeso,
      successCount: cS,
      stayCount: cSt,
      downCount: cDn,
      destroyCount: cX,
      perStar: collectDetail ? perStar : null,
      starTimeline: collectDetail ? timeline : null,
    );
  }

  /// 다회 시뮬로 평균/분위수도 뽑기
  Future<Map<String, dynamic>> simulateMany({
    required int equipLevel,
    required int start,
    required int target,
    required EventConfig cfg,
    required int runs,
    int destroyRollbackTo = 12,
  }) async {
    final rng = Random();
    final triesList = <int>[];
    final mesoList = <int>[];
    final destroyList = <int>[]; // 🔵 파괴 횟수 모음

    for (int i = 0; i < runs; i++) {
      final r = await simulateOnce(
        equipLevel: equipLevel,
        start: start,
        target: target,
        cfg: cfg,
        destroyRollbackTo: destroyRollbackTo,
        random: rng,
      );
      triesList.add(r.tries);
      mesoList.add(r.totalMeso);
      destroyList.add(r.destroyCount); // 🔵 파괴횟수 기록
    }

    triesList.sort();
    mesoList.sort();
    destroyList.sort();

    double avg(List<int> a) => a.reduce((x, y) => x + y) / a.length;
    double std(List<int> a) {
      final m = avg(a);
      var v = 0.0;
      for (final x in a) {
        v += (x - m) * (x - m);
      }
      return (v / a.length).sqrt();
    }

    int p(List<int> a, int q) =>
        a[(a.length * q / 100).floor().clamp(0, a.length - 1)];

    return {
      'runs': runs,
      'tries': {
        'avg': avg(triesList),
        'std': std(triesList),
        'min': triesList.first,
        'p50': p(triesList, 50),
        'p90': p(triesList, 90),
        'p95': p(triesList, 95),
        'p99': p(triesList, 99),
        'max': triesList.last,
      },
      'meso': {
        'avg': avg(mesoList),
        'std': std(mesoList),
        'min': mesoList.first,
        'p50': p(mesoList, 50),
        'p90': p(mesoList, 90),
        'p95': p(mesoList, 95),
        'p99': p(mesoList, 99),
        'max': mesoList.last,
      },
      'destroy': {
        // 🔵 파괴 관련 통계 추가
        'avg': avg(destroyList),
        'std': std(destroyList),
        'min': destroyList.first,
        'p50': p(destroyList, 50),
        'p90': p(destroyList, 90),
        'p95': p(destroyList, 95),
        'p99': p(destroyList, 99),
        'max': destroyList.last,
      },
    };
  }
}

extension on num {
  double sqrt() => mathSqrt(toDouble());
}

double mathSqrt(double x) =>
    x <= 0 ? 0 : (x).toDouble().sqrt(); // dummy to satisfy analyzer
