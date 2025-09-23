import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/api/model/basic.dart';
import 'package:mic/function/currentuser.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/function/expdata/exp_contents.dart';
import 'package:mic/widgets/pillwidget/exprate_bar.dart';
import 'package:flutter/services.dart'
    show
        FilteringTextInputFormatter,
        LengthLimitingTextInputFormatter,
        rootBundle;

class CalculTap extends StatefulWidget {
  const CalculTap({super.key, required this.b});

  final Basic b;

  @override
  State<CalculTap> createState() => _CalcultapState();
}

class _CalcultapState extends State<CalculTap> {
  final goalcontroller = TextEditingController();
  final _goalFocus = FocusNode();

  double arcaneindex = eventrate.indexOf(eventtitle["아케인리버"]!).toDouble();
  double grandisindex = eventrate.indexOf(eventtitle["그란디스"]!).toDouble();
  double monsterindex = eventrate.indexOf(eventtitle["몬스터파크"]!).toDouble();
  double azmothindex = azmothpoint.indexOf(eventtitle["아즈모스 협곡"]!).toDouble();
  double epicindex = epicrate.indexOf(eventtitle["에픽던전"]!).toDouble();

  bool istyped = false;

  // 아케인 일간 경험치
  int arcaneExp = 0;
  double arcanecentExp = 0.0;

  // 그란디스 일간 경험치
  int grandisExp = 0;
  double grandiscentExp = 0.0;

  // 몬스터파크 일간 경험치
  int parkExp = 0;
  double parkcentExp = 0.0;

  // 아케인 주간 경험치
  int arcaneweekExp = 0;
  double arcaneweekcentExp = 0.0;

  // 익스트림 몬파 경험치
  int extremeExp = 0;
  double extremecentExp = 0.0;

  //아즈모스 경험치
  int azmothExp = 0;
  double azmothcentExp = 0.0;

  // 에픽던전 경험치
  int epicExp = 0;
  double epiccentExp = 0.0;

  // 종합 경험치
  int sumExp = 0;
  double sumcentExp = 0.0;

  // 목표 주간
  int goalWeek = 0;
  int goalRemainExp = 0;

  //목표레벨 검증 현재레벨+1 ~ 300까지
  void _validateGoal() {
    final minLevel = widget.b.characterlevel + 1;
    const maxLevel = 300;

    final v = int.tryParse(goalcontroller.text);
    if (v == null) return; // 비어있거나 숫자 아님 → 그대로 둠

    int clamped = v.clamp(minLevel, maxLevel);
    if (clamped != v) {
      goalcontroller.text = clamped.toString();
      goalcontroller.selection = TextSelection.fromPosition(
        TextPosition(offset: goalcontroller.text.length),
      );
    }
  }

  //주간 경험치 총합
  void _loadsum() {
    setState(() {
      sumExp =
          arcaneExp * 7 +
          grandisExp * 7 +
          parkExp * 7 +
          arcaneweekExp +
          extremeExp +
          azmothExp +
          epicExp;
      sumcentExp = double.parse(
        (arcanecentExp * 7 +
                grandiscentExp * 7 +
                parkcentExp * 7 +
                arcaneweekcentExp +
                extremecentExp +
                azmothcentExp +
                epiccentExp)
            .toStringAsFixed(2),
      );
    });
  }

  //목표 주간 구하기
  Future<void> _loadWeek() async {
    if (goalcontroller.text.trim().isEmpty) return;

    final goals = int.tryParse(goalcontroller.text.trim());
    if (goals == null) return;

    final result = await calculateWeeksToGoal(
      currentLevel: widget.b.characterlevel,
      currentExp: widget.b.characterexp,
      goalLevel: goals,
      weeklyExp: sumExp,
    );

    setState(() {
      goalWeek = result["weeks"]; // 필요한 주차
      goalRemainExp = result["requiredExp"]; // 남은 경험치 (새 변수 추가 가능)
    });
  }

  //아케인 일일퀘스트
  Future<Map<String, dynamic>> calculateArcaneExp(
    Map<String, bool> dayquest,
    int level,
  ) async {
    // 아케인리버 일퀘 데이터 로드
    final contentsStr = await rootBundle.loadString(
      'assets/datas/maple_exp_contents.json',
    );
    final contentsData = jsonDecode(contentsStr);
    final arcaneExpTable = Map<String, dynamic>.from(contentsData["아케인리버_일간"]);

    // 경험치 테이블 로드
    final expStr = await rootBundle.loadString(
      'assets/datas/maplestory_exp.json',
    );
    final expData = List<Map<String, dynamic>>.from(jsonDecode(expStr));

    // 해당 레벨 필요 경험치 찾기
    final levelData = expData.firstWhere(
      (e) => e["level"] == level,
      orElse: () => throw ArgumentError("레벨 $level 데이터 없음"),
    );
    final expToNext = levelData["exp_to_next"] as int;

    // 선택된 퀘스트 경험치 합산
    int sum = 0;
    dayquest.forEach((key, value) {
      if (value && arcaneExpTable.containsKey(key)) {
        sum += arcaneExpTable[key] as int;
      }
    });

    // 퍼센트 계산
    double percent = (sum / expToNext) * 100;

    return {"totalExp": sum, "percent": percent};
  }

  Future<void> _loadArcane() async {
    final sumdis = await calculateArcaneExp(
      dayquest,
      widget.b.characterlevel,
    ); // int
    setState(() {
      arcaneExp = (sumdis['totalExp'] * (1 + eventtitle["아케인리버"]! / 100))
          .toInt();
      arcanecentExp = double.parse(
        (sumdis['percent'] * (1 + eventtitle["아케인리버"]! / 100)).toStringAsFixed(
          2,
        ),
      );
      _loadsum();
      _loadWeek();
    });
  }

  //그란디스 일일퀘스트
  Future<Map<String, dynamic>> calculateGrandisExp(
    Map<String, bool> dayquest,
    int level,
  ) async {
    // 그란디스 일퀘 경험치 로드
    final contentsStr = await rootBundle.loadString(
      'assets/datas/maple_exp_contents.json',
    );
    final contentsData = jsonDecode(contentsStr);
    final grandisExpTable = Map<String, dynamic>.from(contentsData["그란디스_일간"]);

    // 레벨 경험치 테이블 로드
    final expStr = await rootBundle.loadString(
      'assets/datas/maplestory_exp.json',
    );
    final expData = List<Map<String, dynamic>>.from(jsonDecode(expStr));

    // 해당 레벨 필요 경험치 찾기
    final levelData = expData.firstWhere(
      (e) => e["level"] == level,
      orElse: () => throw ArgumentError("레벨 $level 데이터 없음"),
    );
    final expToNext = levelData["exp_to_next"] as int;

    // 선택된 퀘스트 경험치 합산
    int sum = 0;
    dayquest.forEach((key, value) {
      if (value && grandisExpTable.containsKey(key)) {
        sum += grandisExpTable[key] as int;
      }
    });

    // 퍼센트 계산
    double percent = (sum / expToNext) * 100;

    return {"totalExp": sum, "percent": percent};
  }

  Future<void> _loadGrandis() async {
    final sumdis = await calculateGrandisExp(
      dayquest,
      widget.b.characterlevel,
    ); // int
    setState(() {
      grandisExp = (sumdis['totalExp'] * (1 + eventtitle["그란디스"]! / 100))
          .toInt();
      grandiscentExp = double.parse(
        (sumdis['percent'] * (1 + eventtitle["그란디스"]! / 100)).toStringAsFixed(
          2,
        ),
      );
      _loadsum();
      _loadWeek();
    });
  }

  //일일 몬스터파크
  Future<Map<String, dynamic>> getMonsterParkExp(
    Map<String, dynamic> monsterpark,
    int level,
  ) async {
    // JSON 불러오기
    final jsonStr = await rootBundle.loadString(
      'assets/datas/maple_exp_contents.json',
    );
    final data = jsonDecode(jsonStr);

    final monsterParkTable = Map<String, dynamic>.from(data["몬스터파크_일간"]);

    int sum = 0;

    // 입장여부 확인
    if (monsterpark["입장여부"] == true) {
      final region = monsterpark["지역"];
      if (monsterParkTable.containsKey(region)) {
        sum = monsterParkTable[region] as int;
      }
    }

    // 레벨 경험치 테이블 로드
    final expStr = await rootBundle.loadString(
      'assets/datas/maplestory_exp.json',
    );
    final expData = List<Map<String, dynamic>>.from(jsonDecode(expStr));

    // 해당 레벨 필요 경험치 찾기
    final levelData = expData.firstWhere(
      (e) => e["level"] == level,
      orElse: () => throw ArgumentError("레벨 $level 데이터 없음"),
    );
    final expToNext = levelData["exp_to_next"] as int;

    // 퍼센트 계산
    double percent = (sum / expToNext) * 100;

    return {"totalExp": sum, "percent": percent};
  }

  Future<void> _loadPark() async {
    final sumdis = await getMonsterParkExp(
      monsterpark,
      widget.b.characterlevel,
    ); // int
    setState(() {
      parkExp = (sumdis['totalExp'] * (1 + eventtitle["몬스터파크"]! / 100)).toInt();
      parkcentExp = double.parse(
        (sumdis['percent'] * (1 + eventtitle["몬스터파크"]! / 100)).toStringAsFixed(
          2,
        ),
      );
      _loadsum();
      _loadWeek();
    });
  }

  //아케인 주간컨텐츠
  Future<Map<String, dynamic>> weeklyArcaneSum(
    Map<String, bool> weekquest,
    int level,
  ) async {
    // 주간퀘 JSON 로드
    final jsonStr = await rootBundle.loadString(
      'assets/datas/maple_exp_contents.json',
    );
    final data = jsonDecode(jsonStr);

    final weeklyTable = Map<String, dynamic>.from(data['아케인리버_주간']);

    int sum = 0;
    weekquest.forEach((name, picked) {
      if (!picked) return;
      if (name == '익스트림 몬스터파크') return; // 제외
      if (weeklyTable.containsKey(name)) {
        sum += weeklyTable[name] as int;
      }
    });

    // 레벨 경험치 JSON 로드
    final expStr = await rootBundle.loadString(
      'assets/datas/maplestory_exp.json',
    );
    final expData = List<Map<String, dynamic>>.from(jsonDecode(expStr));

    // 해당 레벨 필요 경험치 찾기
    final levelData = expData.firstWhere(
      (e) => e["level"] == level,
      orElse: () => throw ArgumentError("레벨 $level 데이터 없음"),
    );
    final expToNext = levelData["exp_to_next"] as int;

    // 퍼센트 계산
    double percent = (sum / expToNext) * 100;

    return {"totalExp": sum, "percent": percent};
  }

  Future<void> _loadweekArcane() async {
    final sumdis = await weeklyArcaneSum(
      weekquest,
      widget.b.characterlevel,
    ); // int
    setState(() {
      arcaneweekExp = sumdis['totalExp'];
      arcaneweekcentExp = double.parse(sumdis['percent'].toStringAsFixed(2));
      _loadsum();
      _loadWeek();
    });
  }

  //익스트림 몬스터파크
  Future<Map<String, dynamic>> weeklyExtremeMonsterSum(
    Map<String, bool> weekquest,
    int level,
  ) async {
    if (weekquest['익스트림 몬스터파크'] != true) {
      return {"percent": 0.0, "totalExp": 0};
    }

    // 1) 레벨별 퍼센트 로드
    final extremeStr = await rootBundle.loadString(
      'assets/datas/extreme_monster.json',
    );
    final Map<String, dynamic> extreme = jsonDecode(extremeStr);

    // 2) 레벨별 필요 경험치 로드
    final expStr = await rootBundle.loadString(
      'assets/datas/maplestory_exp.json',
    );
    final List<dynamic> expList = jsonDecode(expStr);

    // 퍼센트 찾기 (없으면 0)
    final String lvKey = level.toString();
    final double percent = (extreme[lvKey] is num)
        ? (extreme[lvKey] as num).toDouble()
        : 0.0;

    // exp_to_next 찾기 (없으면 0)
    final match = expList.cast<Map<String, dynamic>>().firstWhere(
      (e) => e['level'] == level,
      orElse: () => const {'exp_to_next': null},
    );
    final int expToNext = (match['exp_to_next'] is int)
        ? match['exp_to_next'] as int
        : 0;

    // 실제 EXP = exp_to_next * (percent / 100)
    final int totalExp = (expToNext * (percent / 100.0)).floor();

    return {
      "percent": percent, // 퍼센트 (예: 15.31)
      "totalExp": totalExp, // 실제 경험치 양
    };
  }

  Future<void> _loadExtreme() async {
    final sumdis = await weeklyExtremeMonsterSum(
      weekquest,
      widget.b.characterlevel,
    ); // int
    setState(() {
      extremeExp = (sumdis['totalExp'] * (1 + eventtitle["몬스터파크"]! / 100))
          .toInt();
      extremecentExp = double.parse(
        (sumdis['percent'] * (1 + eventtitle["몬스터파크"]! / 100)).toStringAsFixed(
          2,
        ),
      );
      _loadsum();
      _loadWeek();
    });
  }

  //에픽던전
  Future<Map<String, dynamic>> loadEpicDungeonExp(
    Map<String, bool> epicweek,
    int level,
  ) async {
    // 1) 에픽던전 % 데이터 로드
    final epicStr = await rootBundle.loadString(
      'assets/datas/epic_dungeon_exp.json',
    );
    final Map<String, dynamic> epic = jsonDecode(epicStr);

    // 2) 레벨별 필요 경험치 로드
    final expStr = await rootBundle.loadString(
      'assets/datas/maplestory_exp.json',
    );
    final List<dynamic> expList = jsonDecode(expStr);

    final match = expList.cast<Map<String, dynamic>>().firstWhere(
      (e) => e['level'] == level,
      orElse: () => const {'exp_to_next': null},
    );
    final int expToNext = (match['exp_to_next'] is int)
        ? match['exp_to_next'] as int
        : 0;

    // 3) 선택된 던전들의 퍼센트 합산 (아즈모스 협곡 제외)
    double totalPercent = 0.0;

    for (final entry in epicweek.entries) {
      if (entry.value != true) continue;
      if (entry.key == "아즈모스 협곡") continue; // 제외 조건 유지

      final dungeon = entry.key;
      final table = epic[dungeon];
      if (table is Map<String, dynamic>) {
        final num p = (table[level.toString()] ?? 0) as num;
        totalPercent += p.toDouble();
      }
    }

    // 4) 실제 경험치 계산
    final int totalExp = (expToNext * (totalPercent / 100.0)).floor();

    return {
      "percent": totalPercent, // 예: 7.12 (퍼센트 값)
      "totalExp": totalExp, // 실제 경험치 합계
    };
  }

  Future<void> _loadEpic() async {
    final sumdis = await loadEpicDungeonExp(
      epicweek,
      widget.b.characterlevel,
    ); // int
    setState(() {
      epicExp = (sumdis['totalExp'] * eventtitle["에픽던전"]!);
      epiccentExp = double.parse(
        (sumdis['percent'] * eventtitle["에픽던전"]!).toStringAsFixed(2),
      );
      _loadsum();
      _loadWeek();
    });
  }

  //목표레벨 달성 주 계산
  Future<Map<String, dynamic>> calculateWeeksToGoal({
    required int currentLevel,
    required int currentExp,
    required int goalLevel,
    required int weeklyExp,
  }) async {
    // 레벨 경험치 데이터 로드
    final jsonStr = await rootBundle.loadString(
      'assets/datas/maplestory_exp.json',
    );
    final expData = List<Map<String, dynamic>>.from(jsonDecode(jsonStr));

    // 누적 필요 경험치
    int requiredExp = 0;

    for (int lv = currentLevel; lv < goalLevel; lv++) {
      final levelData = expData.firstWhere((e) => e["level"] == lv);
      int expToNext = levelData["exp_to_next"] as int;

      if (lv == currentLevel) {
        requiredExp += expToNext - currentExp; // 현재 레벨은 남은 부분만
      } else {
        requiredExp += expToNext;
      }
    }

    // 필요한 주차 계산 (올림)
    int weeks = (requiredExp / weeklyExp).ceil();

    return {
      "requiredExp": requiredExp, // 총 필요 경험치
      "weeks": weeks, // 총 필요 주차
    };
  }

  @override
  void initState() {
    super.initState();
    _loadArcane();
    _loadGrandis();
    _loadPark();
    _loadweekArcane();
    _loadExtreme();
    _loadEpic();
    _loadsum();
    _loadWeek();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500.h,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            expSetting(),

            SizedBox(height: 4.h),

            slideEvent(),
            SizedBox(height: 4.h),
            printExp(),
          ],
        ),
      ),
    );
  }

  // 현재 캐릭터의 레벨 경험치 세팅 및 목표 설정
  Container expSetting() {
    return Container(
      width: double.infinity,
      height: 200.h,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Typicalcolor.subborder, Typicalcolor.border],
        ),
        border: Border.all(color: Typicalcolor.font),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Typicalcolor.bg, Typicalcolor.subbg],
          ),
          border: Border.all(color: Typicalcolor.font),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 30.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Typicalcolor.title, Typicalcolor.border],
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: twoTitle('경험치 계산기', 18),
                ),
                Positioned(
                  bottom: 5.h,
                  right: 55.w,
                  child: Row(
                    children: [
                      Transform.rotate(
                        angle: -0.2,
                        child: Image.asset(
                          'assets/images/icons/book.png',
                          width: 50.w,
                          height: 50.h,
                        ),
                      ),
                      SizedBox(width: 80.w),
                      Transform.rotate(
                        angle: 0.4,
                        child: Image.asset(
                          'assets/images/icons/exppotion.png',
                          width: 50.w,
                          height: 50.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  twoText('현재 레벨:', 18),
                  Container(
                    width: 80.w,
                    height: 30.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFFfbe9c2),
                      border: Border.all(
                        color: Typicalcolor.subfont,
                        width: 2.w,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      widget.b.characterlevel.toString(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Typicalcolor.font,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  twoText('목표 레벨:', 18),
                  Container(
                    width: 80.w,
                    height: 30.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFfbe9c2),
                      border: Border.all(
                        color: Typicalcolor.subfont,
                        width: 2.w,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: TextFormField(
                      controller: goalcontroller,
                      focusNode: _goalFocus,
                      maxLength: 3,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // 숫자만
                        LengthLimitingTextInputFormatter(3), // 최대 3자리
                      ],
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        hintText: '목표 레벨',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF7f622a),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MaplestoryOTFBOLD',
                        ),
                      ),
                      style: TextStyle(fontSize: 18.sp),

                      // 3자리가 되었을 때만 보정 (그 전엔 타이핑 방해 X)
                      onChanged: (value) async {
                        // 1) 비었거나 3자리 미만이면 초기화 후 종료
                        if (value.isEmpty || value.length < 3) {
                          if (!mounted) return;
                          setState(
                            () => goalWeek = 0,
                          ); // 필요 시 goalRemainExp도 0으로
                          return;
                        }

                        // 2) 숫자 변환 실패 → 종료
                        final goal = int.tryParse(value.trim());
                        if (goal == null) return;

                        // 3) 범위 체크: (현재레벨+1) ~ 300
                        final min = widget.b.characterlevel + 1;
                        const max = 300;
                        if (goal < min || goal > max) return;

                        // 4) 주간 총합이 0이면 계산 불가
                        if (sumExp <= 0) return;

                        // 5) 계산 실행 (Map 반환 버전)
                        final result = await calculateWeeksToGoal(
                          currentLevel: widget.b.characterlevel,
                          currentExp: widget.b.characterexp,
                          goalLevel: goal,
                          weeklyExp: sumExp,
                        );

                        if (!mounted) return;
                        setState(() {
                          goalWeek = (result["weeks"] as int);
                          // 선택: 남은 경험치 표시도 쓰려면 아래 변수 선언해 두세요.
                          // goalRemainExp = (result["requiredExp"] as int);
                        });
                      },

                      // 엔터 누르거나 완료 액션 시 보정
                      onFieldSubmitted: (_) => _validateGoal(),

                      // 포커스가 빠질 때 보정 (바깥 터치 등)
                      onEditingComplete: _validateGoal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [twoText('현재 경험치:', 18)],
              ),
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ExprateBar(
                value: double.parse(widget.b.characterexprate) / 100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 각 경험치 배율 설정
  Container slideEvent() {
    return Container(
      width: double.infinity,
      height: 265.h,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Typicalcolor.subborder, Typicalcolor.border],
        ),
        border: Border.all(color: Typicalcolor.font),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Typicalcolor.bg, Typicalcolor.subbg],
          ),
          border: Border.all(color: Typicalcolor.font),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 30.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Typicalcolor.title, Typicalcolor.border],
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              child: twoTitle('이벤트 및 더보기', 18),
            ),
            SizedBox(height: 4.h),
            eventtype('아케인리버', arcaneindex, (v) async {
              setState(() {
                arcaneindex = v;
                eventtitle["아케인리버"] = eventrate[v.toInt()];
                _loadArcane();
              });
            }, eventrate),

            SizedBox(height: 4.h),
            eventtype('그란디스', grandisindex, (v) async {
              setState(() {
                grandisindex = v;
                eventtitle["그란디스"] = eventrate[v.toInt()];
                _loadGrandis();
              });
            }, eventrate),

            SizedBox(height: 4.h),
            eventtype('몬스터파크', monsterindex, (v) async {
              setState(() {
                monsterindex = v;
                eventtitle["몬스터파크"] = eventrate[v.toInt()];
                _loadPark();
                _loadExtreme();
              });
            }, eventrate),
            SizedBox(height: 4.h),
            eventtype('아즈모스 협곡', azmothindex, (v) {
              setState(() {
                azmothindex = v;
                eventtitle["아즈모스 협곡"] = azmothpoint[v.toInt()];
              });
            }, azmothpoint),
            SizedBox(height: 4.h),
            eventtype('에픽던전', epicindex, (v) {
              setState(() {
                epicindex = v;
                eventtitle["에픽던전"] = epicrate[v.toInt()];
                _loadEpic();
              });
            }, epicrate),
          ],
        ),
      ),
    );
  }

  // 비율 OR 수치 여부
  Widget eventtype(
    String title,
    double index,
    ValueChanged<double>? onChanged,
    List<int> rate,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        width: double.infinity,
        height: 40.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Typicalcolor.title, // 왼쪽 밝은 파랑
              Typicalcolor.subtitle, // 오른쪽
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Color(0xFFfbe9c2), width: 3.w),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            SizedBox(width: 70.w, child: twoText(title, 11)),
            SizedBox(width: 4.w),

            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.blueGrey,
                  trackHeight: 2,
                  thumbColor: Typicalcolor.font,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                  overlayShape: SliderComponentShape.noOverlay,
                  // 🔵 값 말풍선 배경색
                  valueIndicatorColor: Typicalcolor.bg,

                  // 🔵 값 말풍선 텍스트 스타일
                  valueIndicatorTextStyle: TextStyle(
                    color: Typicalcolor.font,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Slider(
                  value: index,
                  min: 0,
                  max: (rate.length - 1).toDouble(),
                  divisions: rate.length - 1,
                  label: "${rate[index.toInt()]}", // 선택된 값 보여주기
                  onChanged: onChanged,
                ),
              ),
            ),
            SizedBox(width: 15.w),

            SizedBox(
              width: 40.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  twoText(
                    (title == '에픽던전')
                        ? '${eventtitle[title].toString()}배'
                        : (title == '아즈모스 협곡')
                        ? '${eventtitle[title].toString()}점'
                        : '${eventtitle[title].toString()}%',
                    10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 경험치 표시 구간
  Container printExp() {
    return Container(
      width: double.infinity,
      height: 220.h,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Typicalcolor.subborder, Typicalcolor.border],
        ),
        border: Border.all(color: Typicalcolor.font),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Typicalcolor.bg, Typicalcolor.subbg],
          ),
          border: Border.all(color: Typicalcolor.font),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 30.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Typicalcolor.title, Typicalcolor.border],
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  twoTitle('컨텐츠별 최종 경험치', 18),
                  Row(
                    children: [
                      twoText("비율", 12),
                      SizedBox(width: 4.w),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            istyped = !istyped;
                          });
                        },
                        child: Container(
                          width: 45,
                          height: 18,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            color: Typicalcolor.bg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Typicalcolor.subborder),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 0.5,
                                color: Color(0xFF08202E),
                              ),
                            ],
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 200),
                            alignment: istyped
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Typicalcolor.font,
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 0.5,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      twoText("수치", 12),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 180.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 4.h,
                      ),
                      width: double.infinity,
                      height: 100.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Typicalcolor.title, // 왼쪽 밝은 파랑
                            Typicalcolor.subtitle, // 오른쪽
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: Color(0xFFfbe9c2),
                          width: 3.w,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          twoText("일일 경험치", 14),
                          SizedBox(height: 2.h),
                          expRows(
                            "아케인리버 경험치",
                            (istyped) ? formatPower(arcaneExp) : arcanecentExp,
                          ),
                          expRows(
                            "그란디스 경험치",
                            (istyped)
                                ? formatPower(grandisExp)
                                : grandiscentExp,
                          ),
                          expRows(
                            "몬스터파크 경험치",
                            (istyped) ? formatPower(parkExp) : parkcentExp,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 4.h,
                      ),
                      width: double.infinity,
                      height: 120.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Typicalcolor.title, // 왼쪽 밝은 파랑
                            Typicalcolor.subtitle, // 오른쪽
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: Color(0xFFfbe9c2),
                          width: 3.w,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          twoText("주간 경험치", 14),
                          SizedBox(height: 2.h),
                          expRows(
                            "아케인리버 주간 경험치",
                            (istyped)
                                ? formatPower(arcaneweekExp)
                                : arcaneweekcentExp,
                          ),
                          expRows(
                            "익스트림 경험치",
                            (istyped)
                                ? formatPower(extremeExp)
                                : extremecentExp,
                          ),
                          expRows(
                            "아즈모스 경험치",
                            (istyped) ? formatPower(azmothExp) : azmothcentExp,
                          ),
                          expRows(
                            "에픽던전 경험치",
                            (istyped) ? formatPower(epicExp) : epiccentExp,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 4.h,
                      ),
                      width: double.infinity,
                      height: 60.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Typicalcolor.title, // 왼쪽 밝은 파랑
                            Typicalcolor.subtitle, // 오른쪽
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: Color(0xFFfbe9c2),
                          width: 3.w,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          twoText("종합 경험치", 14),
                          SizedBox(height: 2.h),
                          (goalcontroller.text.isEmpty)
                              ? expRows(
                                  "주간 총 획득 경험치",
                                  (istyped) ? formatPower(sumExp) : sumcentExp,
                                )
                              : expRows("목표 레벨까지 필요한 주차", "$goalWeek주"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 텍스트 설정 구간
  Padding expRows(String title, exp) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          twoText(title, 12),
          twoText(
            (istyped)
                ? exp.toString()
                : (title.contains("목표"))
                ? "$exp"
                : "$exp%",
            12,
          ),
        ],
      ),
    );
  }
}
