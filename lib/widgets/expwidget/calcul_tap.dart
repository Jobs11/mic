import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/api/model/basic.dart';
import 'package:mic/function/currentuser.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/function/expdata/exp_contents.dart';
import 'package:mic/widgets/pillwidget/exprate_bar.dart';
import 'package:flutter/services.dart' show rootBundle;

class CalculTap extends StatefulWidget {
  const CalculTap({super.key, required this.b});

  final Basic b;

  @override
  State<CalculTap> createState() => _CalcultapState();
}

class _CalcultapState extends State<CalculTap> {
  final goalcontroller = TextEditingController();

  double arcaneindex = eventrate.indexOf(eventtitle["아케인리버"]!).toDouble();
  double grandisindex = eventrate.indexOf(eventtitle["그란디스"]!).toDouble();
  double monsterindex = eventrate.indexOf(eventtitle["몬스터파크"]!).toDouble();
  double azmothindex = azmothpoint.indexOf(eventtitle["아즈모스 협곡"]!).toDouble();
  double epicindex = epicrate.indexOf(eventtitle["에픽던전"]!).toDouble();

  int arcaneExp = 0;
  int grandisExp = 0;
  int parkExp = 0;
  int arcaneweekExp = 0;
  int extremeExp = 0;
  int azmothExp = 0;
  int epicExp = 0;

  //아케인 일일퀘스트
  Future<int> calculateArcaneExp(Map<String, bool> dayquest) async {
    final jsonStr = await rootBundle.loadString(
      'assets/datas/maple_exp_contents.json',
    );
    final data = jsonDecode(jsonStr);

    final arcaneExpTable = Map<String, dynamic>.from(data["아케인리버_일간"]);

    int sum = 0;
    dayquest.forEach((key, value) {
      if (value && arcaneExpTable.containsKey(key)) {
        sum += arcaneExpTable[key] as int;
      }
    });

    return sum;
  }

  Future<void> _loadArcane() async {
    final sumdis = await calculateArcaneExp(dayquest); // int
    setState(() {
      arcaneExp = (sumdis * (1 + eventtitle["아케인리버"]! / 100)).toInt();
    });
  }

  //그란디스 일일퀘스트
  Future<int> calculateGrandisExp(Map<String, bool> dayquest) async {
    final jsonStr = await rootBundle.loadString(
      'assets/datas/maple_exp_contents.json',
    );
    final data = jsonDecode(jsonStr);

    final grandisExpTable = Map<String, dynamic>.from(data["그란디스_일간"]);

    int sum = 0;
    dayquest.forEach((key, value) {
      if (value && grandisExpTable.containsKey(key)) {
        sum += grandisExpTable[key] as int;
      }
    });

    return sum;
  }

  Future<void> _loadGrandis() async {
    final sumdis = await calculateGrandisExp(dayquest); // int
    setState(() {
      grandisExp = (sumdis * (1 + eventtitle["그란디스"]! / 100)).toInt();
    });
  }

  //일일 몬스터파크
  Future<int> getMonsterParkExp(Map<String, dynamic> monsterpark) async {
    // JSON 불러오기
    final jsonStr = await rootBundle.loadString(
      'assets/datas/maple_exp_contents.json',
    );
    final data = jsonDecode(jsonStr);

    final monsterParkTable = Map<String, dynamic>.from(data["몬스터파크_일간"]);

    // 입장여부 확인
    if (monsterpark["입장여부"] == true) {
      final region = monsterpark["지역"];
      if (monsterParkTable.containsKey(region)) {
        return monsterParkTable[region] as int;
      }
    }
    return 0; // 입장 안 했거나 해당 지역 없음
  }

  Future<void> _loadPark() async {
    final sumdis = await getMonsterParkExp(monsterpark); // int
    setState(() {
      parkExp = (sumdis * (1 + eventtitle["몬스터파크"]! / 100)).toInt();
    });
  }

  //아케인 주간컨텐츠
  Future<int> weeklyArcaneSum(Map<String, bool> weekquest) async {
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
    return sum;
  }

  Future<void> _loadweekArcane() async {
    final sumdis = await weeklyArcaneSum(weekquest); // int
    setState(() {
      arcaneweekExp = sumdis;
    });
  }

  //익스트림 몬스터파크
  Future<int> weeklyExtremeMonsterSum(
    Map<String, bool> weekquest,
    int level,
  ) async {
    if (weekquest['익스트림 몬스터파크'] != true) return 0;

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
    final double result = expToNext * (percent / 100.0);
    return result.floor(); // 소수점 버림 (원하면 round/toInt로 변경)
  }

  Future<void> _loadExtreme() async {
    final sumdis = await weeklyExtremeMonsterSum(
      weekquest,
      widget.b.characterlevel,
    ); // int
    setState(() {
      extremeExp = (sumdis * (1 + eventtitle["몬스터파크"]! / 100)).toInt();
    });
  }

  //에픽던전
  Future<int> loadEpicDungeonExp(Map<String, bool> epicweek, int level) async {
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

    // 3) 선택된 던전 찾기 (아즈모스 협곡 제외)
    for (final entry in epicweek.entries) {
      if (entry.value != true) continue;
      if (entry.key == "아즈모스 협곡") continue;

      final dungeon = entry.key;
      final table = epic[dungeon];
      if (table is Map<String, dynamic>) {
        final percent = (table[level.toString()] ?? 0) as num;
        return (expToNext * (percent / 100)).floor();
      }
    }

    return 0; // 아무것도 선택 안 했을 때
  }

  Future<void> _loadEpic() async {
    final sumdis = await loadEpicDungeonExp(
      epicweek,
      widget.b.characterlevel,
    ); // int
    setState(() {
      epicExp = (sumdis * eventtitle["에픽던전"]!);
    });
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
                      color: Color(0xFFfbe9c2),
                      border: Border.all(
                        color: Typicalcolor.subfont,
                        width: 2.w,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: TextFormField(
                      controller: goalcontroller,
                      maxLength: 3,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none, // 테두리 제거 (BoxDecoration에서 그림)
                        hintText: '목표 레벨', // 플레이스홀더
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xFF7f622a),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MaplestoryOTFBOLD',
                        ),
                      ),

                      style: TextStyle(fontSize: 18.sp),
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Typicalcolor.title, Typicalcolor.border],
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              child: twoTitle('컨텐츠별 최종 경험치', 18),
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
                          expRows("아케인리버 경험치", arcaneExp),
                          expRows("그란디스 경험치", grandisExp),
                          expRows("몬스터파크 경험치", parkExp),
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
                          expRows("아케인리버 주간 경험치", arcaneweekExp),
                          expRows("익스트림 경험치", extremeExp),
                          expRows("아즈모스 경험치", azmothExp),
                          expRows("에픽던전 경험치", epicExp),
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

  Padding expRows(String title, int exp) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [twoText(title, 12), twoText(formatPower(exp), 12)],
      ),
    );
  }
}
