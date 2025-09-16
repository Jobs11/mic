import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/currentuser.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/widgets/animation/x_strike.dart';

class EnhanceTap extends StatefulWidget {
  const EnhanceTap({super.key});

  @override
  State<EnhanceTap> createState() => _EnhanceTapState();
}

class _EnhanceTapState extends State<EnhanceTap> {
  final xKey = GlobalKey<XStrikeState>();
  int equipindex = 0;
  String equipvalues = forcetype.first;

  Map<String, dynamic> starforceLevels = {};
  List<int> levels = [];

  int selectedlevel = 140;

  // 체크박스 확인 변수
  bool isChance = false;
  bool isPay = false;
  bool isMvp = false;
  bool isPc = false;
  bool isDestroy = false;
  bool isCatch = false;

  // 할인 메소 적용 변수
  double payTime = 1.0;
  double mvpTime = 0.0;
  double pcTime = 0.0;
  double destroyTime = 1.0;

  // 텍스트 출력 변수
  int startLevel = 0;
  int destroyfew = 0;
  int sumMeso = 0;
  int enchantMeso = 0;
  double successRate = 0.0;
  double destroyRate = 0.0;

  @override
  void initState() {
    super.initState();
    loadLevels(equipvalues);
    loadmeso(selectedlevel, startLevel);
    loadstagerate(startLevel, isChance, isCatch);
  }

  void resetEnhance() {
    isChance = false;
    isPay = false;
    isMvp = false;
    isPc = false;
    isDestroy = false;
    isCatch = false;
    payTime = 1.0;
    mvpTime = 0.0;
    pcTime = 0.0;
    destroyTime = 1.0;
    startLevel = 0;
    sumMeso = 0;
    destroyfew = 0;
  }

  Future<void> loadLevels(String equip) async {
    final jsonStr = await rootBundle.loadString(
      'assets/datas/starforce_levels.json',
    );
    final data = jsonDecode(jsonStr);
    setState(() {
      starforceLevels = Map<String, dynamic>.from(data);
      levels = List<int>.from(starforceLevels[equip]);
    });
  }

  Future<void> loadmeso(int level, int stage) async {
    final jsonStr = await rootBundle.loadString(
      'assets/datas/starforce_meso.json',
    );
    final data = jsonDecode(jsonStr);

    if (data == null) {
      throw StateError("먼저 load()를 호출해서 JSON을 로드해야 합니다.");
    }

    final list = data![level.toString()];
    if (list == null) {
      throw ArgumentError("레벨 $level 데이터가 없습니다.");
    }

    final attempt = (list as List).firstWhere(
      (e) => e["from"] == stage,
      orElse: () => throw ArgumentError("레벨 $level 에 from=$stage 데이터가 없습니다."),
    );

    setState(() {
      enchantMeso = attempt["base_meso"] as int;
    });
  }

  Future<void> loadstagerate(int level, bool isChance, bool isCatch) async {
    final jsonStr = await rootBundle.loadString(
      'assets/datas/starforce_probabilities.json',
    );
    final data = jsonDecode(jsonStr);

    if (data == null) {
      throw StateError("먼저 load()를 호출해서 JSON을 로드해야 합니다.");
    }

    final list = data[level.toString()];
    if (list == null) {
      throw ArgumentError("$level성 데이터가 없습니다.");
    }

    // 기본 확률 세팅
    double success = double.parse(list['성공']);
    double keep = isChance
        ? double.parse(list['유지30'])
        : double.parse(list['유지']);
    double destroy = isChance
        ? double.parse(list['파괴30'])
        : double.parse(list['파괴']);

    // 스타캐치 적용
    if (isCatch) {
      success *= 1.05; // 성공률 1.05배
      double total = success + keep + destroy;
      // 유지/파괴 비율을 다시 분배해서 합이 100이 되게 보정
      keep = keep * (100 - success) / (total - success);
      destroy = double.parse(
        (destroy * (100 - success) / (total - success)).toStringAsFixed(2),
      );
    }

    setState(() {
      successRate = success;
      destroyRate = destroy;
    });
  }

  Future<int> simulateStarforce(
    int startLevel,
    bool isChance, // 파괴30% 감소 이벤트 여부
    bool isCatch, // 스타캐치 여부
    bool isDestroy,
  ) async {
    // JSON 불러오기
    final jsonStr = await rootBundle.loadString(
      'assets/datas/starforce_probabilities.json',
    );
    final data = jsonDecode(jsonStr);

    // 현재 레벨 확률 가져오기
    final Map<String, dynamic> probs = Map<String, dynamic>.from(
      data["$startLevel"],
    );

    double successRate = double.parse(probs["성공"]);
    double keepRate;
    double destroyRate;

    if (isChance) {
      keepRate = double.parse(probs["유지30"]);
      destroyRate = double.parse(probs["파괴30"]);
    } else {
      keepRate = double.parse(probs["유지"]);
      destroyRate = double.parse(probs["파괴"]);
    }

    // 스타캐치 적용 (성공률 1.05배, 실패/파괴 비율 유지)
    if (isCatch) {
      successRate *= 1.05;
      double total = successRate + keepRate + destroyRate;
      // 비율 맞춰서 normalize
      keepRate = keepRate * (100 - successRate) / (total - successRate);
      destroyRate = destroyRate * (100 - successRate) / (total - successRate);
    }

    // 난수 생성 (0 ~ 100)
    double roll = Random().nextDouble() * 100;

    if (roll < successRate) {
      // 성공
      return startLevel + 1;
    } else if (roll < successRate + keepRate) {
      // 실패 (유지)
      return startLevel;
    } else {
      if (isDestroy) {
        // 파괴 방지
        return startLevel;
      } else {
        // 파괴
        xKey.currentState?.play();
        destroyfew += 1;
        return 12;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 520.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Typicalcolor.subborder, // 위쪽: 어두운 차콜z
                Typicalcolor.border, // 아래쪽: 연한 금색
              ],
            ),
            border: Border.all(color: Typicalcolor.font),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Typicalcolor.bg, // 위쪽: 어두운 차콜
                  Typicalcolor.subbg, // 아래쪽: 연한 금색
                ],
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
                  child: twoTitle('스타포스 강화 시뮬레이터', 18),
                ),

                subtitleList(),

                SizedBox(height: 10.h),
                contentList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //타이틀 아래 속성들
  Padding subtitleList() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: twoText('$destroyfew펑', 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              listData<int>('레벨 설정', selectedlevel, levels, (value) {
                setState(() {
                  selectedlevel = value!;
                  resetEnhance();
                  loadmeso(selectedlevel, startLevel);
                });
              }),
              SizedBox(width: 5.w),
              listData<String>('아이템 설정', equipvalues, forcetype, (value) {
                setState(() {
                  equipindex = forcetype.indexOf(value!);
                  equipvalues = value;
                  loadLevels(equipvalues);
                  selectedlevel = levels.first;
                  resetEnhance();
                  loadmeso(selectedlevel, startLevel);
                });
              }),
            ],
          ),
        ],
      ),
    );
  }

  // 드롭다운 리스트 [ 레벨, 장비 ]
  Container listData<T>(
    String title,
    T value,
    List<T> values,
    ValueChanged<T?> onChanged,
  ) {
    return Container(
      width: 80.w,
      height: 24.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Typicalcolor.bg, // ✅ 흰색 → 배경색
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Typicalcolor.subborder),
        boxShadow: [
          BoxShadow(
            color: Typicalcolor.subfont.withValues(alpha: 0.2), // ✅ 부드러운 그림자
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: Center(
          // 1) 드롭다운 버튼 자체를 부모 안에서 중앙 배치
          child: SizedBox(
            width: 160.w, // 원하는 너비로 세팅 (없으면 꽉 참)
            child: DropdownButton<T>(
              value: value,
              isExpanded: true, // 가로로 꽉 채우기
              alignment: Alignment.center, // 2) 버튼 안의 선택 텍스트 중앙 정렬
              hint: Center(
                // 힌트도 중앙 정렬
                child: Text(title, textAlign: TextAlign.center),
              ),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Typicalcolor.subfont,
              ),
              items: values.map((d) {
                return DropdownMenuItem<T>(
                  value: d,
                  alignment: Alignment.center, // 3) 메뉴 아이템 중앙 정렬
                  child: Center(
                    child: Text(d.toString(), textAlign: TextAlign.center),
                  ),
                );
              }).toList(),

              // 선택된 아이템이 버튼에 표시될 때도 확실히 중앙 정렬시키고 싶다면:
              selectedItemBuilder: (context) => values.map((d) {
                return Center(
                  child: Text(d.toString(), textAlign: TextAlign.center),
                );
              }).toList(),

              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }

  // 이벤트 선택지 모음
  Widget checkEvent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          pieceEvent(
            '스타캐치 여부',
            isCatch,
            (v) => setState(() {
              // 콜백으로 부모 상태 업데이트
              isCatch = v ?? false;
              loadstagerate(startLevel, isChance, isCatch);
            }),
          ),

          pieceEvent(
            '파괴확률 감소',
            isChance,
            (v) => setState(() {
              // 콜백으로 부모 상태 업데이트
              isChance = v ?? false;
              loadstagerate(startLevel, isChance, isCatch);
            }),
          ),

          pieceEvent(
            '샤타포스 할인',
            isPay,
            (v) => setState(() {
              // 콜백으로 부모 상태 업데이트
              isPay = v ?? false;
              isPay ? payTime = 0.7 : payTime = 1.0;
            }),
          ),

          pieceEvent(
            'PC방용 할인',
            isPc,
            (v) => setState(() {
              // 콜백으로 부모 상태 업데이트
              isPc = v ?? false;
              isPc ? pcTime = 0.05 : pcTime = 0.0;
            }),
          ),

          pieceEvent(
            'MVP용 할인',
            isMvp,
            (v) => setState(() {
              // 콜백으로 부모 상태 업데이트
              isMvp = v ?? false;
              isMvp ? mvpTime = 0.1 : mvpTime = 0.0;
            }),
          ),

          pieceEvent(
            '강화파괴 방지',
            isDestroy,
            (v) => setState(() {
              // 콜백으로 부모 상태 업데이트
              isDestroy = v ?? false;
              isDestroy ? destroyTime = 2.0 : destroyTime = 1.0;
            }),
          ),
        ],
      ),
    );
  }

  // 이벤트 버튼
  Widget pieceEvent(String title, bool value, ValueChanged<bool?> onChanged) {
    return Container(
      width: 35.w,
      alignment: Alignment.center,
      child: Column(
        children: [
          twoText(title, 9),

          (title.contains('강화파괴'))
              ? (startLevel == 15 || startLevel == 16 || startLevel == 17)
                    ? Checkbox(
                        value: value,
                        onChanged: onChanged,
                        shape: RoundedRectangleBorder(
                          // 모양 변경
                          borderRadius: BorderRadius.circular(18),
                        ),

                        checkColor: Colors.white, // 체크 표시 색
                        // 선택/비활성 등 상태별 채움색
                        fillColor: WidgetStateProperty.resolveWith<Color?>((
                          states,
                        ) {
                          if (states.contains(WidgetState.disabled)) {
                            return Typicalcolor.bg;
                          }
                          if (states.contains(WidgetState.selected)) {
                            return Typicalcolor.title; // 선택 시
                          }
                          return Typicalcolor.bg; // 평소
                        }),
                        side: BorderSide(
                          // 테두리 색
                          color: Typicalcolor.subborder,
                          width: 2,
                        ),
                      )
                    : Container(
                        width: 40.w,
                        height: 40.h,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.disabled_by_default,
                          color: Typicalcolor.title,
                          size: 20.sp,
                        ),
                      )
              : Checkbox(
                  value: value,
                  onChanged: onChanged,
                  shape: RoundedRectangleBorder(
                    // 모양 변경
                    borderRadius: BorderRadius.circular(18),
                  ),

                  checkColor: Colors.white, // 체크 표시 색
                  // 선택/비활성 등 상태별 채움색
                  fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
                    if (states.contains(WidgetState.disabled)) {
                      return Typicalcolor.bg;
                    }
                    if (states.contains(WidgetState.selected)) {
                      return Typicalcolor.title; // 선택 시
                    }
                    return Typicalcolor.bg; // 평소
                  }),
                  side: BorderSide(
                    // 테두리 색
                    color: Typicalcolor.subborder,
                    width: 2,
                  ),
                ),
        ],
      ),
    );
  }

  // 내용 리스트
  Expanded contentList() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/icons/starforce.png',
                width: 150.w,
                height: 150.h,
              ),

              Image.asset(
                equipimg[equipindex],
                width: 70.w,
                height: 70.h,
                fit: BoxFit.fill,
              ),
              XStrike(key: xKey, size: 180),
            ],
          ),
          SizedBox(height: 10.h),
          checkEvent(),

          isimgText(
            '현재 단계:',
            'assets/images/icons/starstage.png',
            '$startLevel성',
          ),
          onlyText('성공 확률:', '$successRate%'),
          onlyText('파괴 확률:', '$destroyRate%'),
          isimgText(
            '강화 비용:',
            'assets/images/icons/coin.png',
            '${formatPower((enchantMeso * (1.0 - (mvpTime + pcTime)) * payTime * destroyTime).round())} 메소',
          ),
          isimgText(
            '총 비용:',
            'assets/images/icons/coin.png',
            '${formatPower(sumMeso)} 메소',
          ),
          SizedBox(height: 20.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  final result = await simulateStarforce(
                    startLevel,
                    isChance,
                    isCatch,
                    isDestroy,
                  );
                  setState(() {
                    startLevel = result;
                    if (result == 18 || result == 0) {
                      isDestroy = false;
                    }
                    loadstagerate(startLevel, isChance, isCatch);
                    loadmeso(selectedlevel, startLevel);
                    sumMeso =
                        sumMeso +
                        ((enchantMeso *
                                (1.0 - (mvpTime + pcTime)) *
                                payTime *
                                destroyTime)
                            .round());
                  });
                },
                child: btntype(
                  '강화',
                  Color(0xFF000000),
                  Color(0xFF153d59),
                  Typicalcolor.subtitle,
                  Typicalcolor.bg,
                ),
              ),
              SizedBox(width: 15.w),
              GestureDetector(
                onTap: () {
                  setState(() {
                    resetEnhance();
                    loadmeso(selectedlevel, startLevel);
                    loadstagerate(startLevel, isChance, isCatch);
                  });
                },
                child: btntype(
                  '초기화',
                  Color(0xFF000000),
                  Color(0xFF16354f),
                  Typicalcolor.subborder,
                  Typicalcolor.bg,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 내용 문구 [ 이미지 포함 ]
  Widget isimgText(String title, String img, String data) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          twoText(title, 16),

          Row(
            children: [
              Image.asset(img, width: 25.w, height: 25.h),

              twoText(data, 16),
            ],
          ),
        ],
      ),
    );
  }

  // 내용 문구 [ 오직 텍스트만 ]
  Widget onlyText(String title, String data) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [twoText(title, 16), twoText(data, 16)],
      ),
    );
  }

  // 버튼 프론트
  Widget btntype(
    String title,
    Color border1,
    Color border2,
    Color back1,
    Color back2,
  ) {
    return Container(
      width: 120.w,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        color: back1,
        border: Border.all(color: border1, width: 2.w),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: back2,
          border: Border.all(color: border2, width: 2.w),
          borderRadius: BorderRadius.circular(9),
        ),
        child: twoText(title, 20),
      ),
    );
  }
}
