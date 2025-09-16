import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/currentuser.dart';
import 'package:mic/function/datas.dart';

class SimulatorTap extends StatefulWidget {
  const SimulatorTap({super.key});

  @override
  State<SimulatorTap> createState() => _SimulatorTapState();
}

class _SimulatorTapState extends State<SimulatorTap> {
  int equipindex = 0;
  String equipvalues = equiptype.first;
  String firstOption = '';
  String secondOption = '';
  String thirdOption = '';
  int counting = 0;
  int summeso = 0;
  final random = Random();

  Map<String, dynamic> equipcube = {}; // = data['무기']
  String selectedLevel = '200'; // "200" | "250"
  Map<String, dynamic>? selectedPayload; // = weapon[selectedLevel]

  @override
  void initState() {
    super.initState();
    loadData(equipvalues);
  }

  Future<void> loadData(String equip) async {
    final jsonStr = await rootBundle.loadString(
      'assets/datas/cube_probabilities.json',
    );
    final data = jsonDecode(jsonStr);
    equipcube = Map<String, dynamic>.from(data[equip]);
    final levels = equipcube.keys.toList()..sort(); // ["200","250",...]
    selectedLevel = levels.first;
    selectedPayload = Map<String, dynamic>.from(equipcube[selectedLevel]!);
    changeOption();
    setState(() {});
  }

  void changeOption() {
    firstOption = pickRandomOption('첫번째');
    secondOption = pickRandomOption('두번째');
    thirdOption = pickRandomOption('세번째');
  }

  String pickRandomOption(String step) {
    List<Map<String, dynamic>> options = List<Map<String, dynamic>>.from(
      selectedPayload![step],
    );

    double total = options.fold(
      0,
      (sum, e) => sum + (e['확률'] as num).toDouble(),
    );
    double r = Random().nextDouble() * total;

    double cumulative = 0;
    for (var opt in options) {
      cumulative += (opt['확률'] as num).toDouble();
      if (r <= cumulative) return opt['옵션'];
    }
    return options.last['옵션']; // fallback
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 470.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Typicalcolor.border, Typicalcolor.subborder],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Typicalcolor.subfont),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Typicalcolor.bg, Typicalcolor.subbg],
              ),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: Typicalcolor.subfont),
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
                  child: twoTitle('잠재능력 옵션', 18),
                ),
                SizedBox(height: 10.h),
                optionSet(),
                SizedBox(height: 10.h),
                resetingbtn(),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      countingCube(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            summeso =
                                counting * levelmeso[int.parse(selectedLevel)]!;
                          });
                        },
                        child: btnChoice('계산하기'),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            summeso = 0;
                            counting = 0;
                          });
                        },
                        child: btnChoice('초기화'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                sumMeso(),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget optionSet() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Container(
        width: double.infinity,
        height: 200.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Typicalcolor.bg, Typicalcolor.subbg],
          ),
          border: Border.all(color: Typicalcolor.subborder, width: 2.w),
          borderRadius: BorderRadius.circular(17.r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dropsCube('아이템 설정', equipvalues, equiptype, (value) {
                  setState(() {
                    equipindex = equiptype.indexOf(value!);
                    equipvalues = value;
                    loadData(equipvalues);
                  });
                }),
                dropsCube('레벨 설정', selectedLevel, equipcube.keys.toList(), (
                  lv,
                ) {
                  setState(() {
                    selectedLevel = lv!;
                    selectedPayload = Map<String, dynamic>.from(
                      equipcube[lv]!,
                    ); // ← 여기서 확률/옵션 접근 가능
                    changeOption();
                  });
                }),
              ],
            ),
            Image.asset(
              equipimg[equipindex],
              width: 70.w,
              height: 70.h,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Container(
                decoration: BoxDecoration(color: Typicalcolor.subborder),
                width: double.infinity,
                height: 2.w,
              ),
            ),
            SizedBox(height: 5.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cubeOption('레전드리', gradeColor['레전드리']!, 13),
                cubeOption(firstOption, gradeColor['레전드리']!, 12),
                cubeOption(secondOption, gradeColor['레전드리']!, 12),
                cubeOption(thirdOption, gradeColor['레전드리']!, 12),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding dropsCube(
    String title,
    String value,
    List<String> values,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
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
          child: Padding(
            padding: EdgeInsets.only(left: 8.w), // ← 전체 아이템에 적용
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                title,
                style: TextStyle(color: Typicalcolor.subfont, fontSize: 12.sp),
              ),
              isExpanded: true,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Typicalcolor.font, // ✅ 검정 → 폰트색
              ),
              items: values
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }

  Widget resetingbtn() {
    return GestureDetector(
      onTap: () {
        setState(() {
          changeOption();
          counting += 1;
        });
      },
      child: Container(
        width: 92.w,
        height: 92.h,
        padding: EdgeInsets.all(3), // border 두께
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Typicalcolor.border, Typicalcolor.subborder],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Typicalcolor.subfont),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Typicalcolor.title, Typicalcolor.subtitle],
            ),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: Typicalcolor.subfont),
          ),
          child: Column(
            children: [
              Image.asset(
                'assets/images/items/blackcube.png',
                width: 50.w,
                height: 50.h,
              ),
              SizedBox(height: 10.h),
              twoText('재설정', 14),
            ],
          ),
        ),
      ),
    );
  }

  Container countingCube() {
    return Container(
      width: 100.w,
      height: 40.h,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Typicalcolor.border, Typicalcolor.subborder],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Typicalcolor.subfont),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Typicalcolor.title, Typicalcolor.subtitle],
          ),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: Typicalcolor.subfont),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/items/blackcube.png',
              width: 20.w,
              height: 20.h,
            ),
            SizedBox(width: 5.w),
            twoText('+ $counting개', 14),
          ],
        ),
      ),
    );
  }

  Container btnChoice(String title) {
    return Container(
      width: 80.w,
      height: 40.h,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Typicalcolor.border, Typicalcolor.subborder],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Typicalcolor.subfont),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Typicalcolor.title, Typicalcolor.subtitle],
          ),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: Typicalcolor.subfont),
        ),
        child: twoText(title, 16),
      ),
    );
  }

  Widget sumMeso() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Container(
        width: double.infinity,
        height: 40.h,
        padding: EdgeInsets.all(3), // border 두께
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Typicalcolor.border, Typicalcolor.subborder],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Typicalcolor.subfont),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Typicalcolor.title, Typicalcolor.subtitle],
            ),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: Typicalcolor.subfont),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/icons/coin.png',
                width: 36.w,
                height: 36.w,
              ),
              SizedBox(width: 50.w),
              twoText('${formatPower(summeso)} 메소', 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget cubeOption(String title, Color colors, double size) {
    return SizedBox(
      width: 230.w,
      child: Stack(
        children: [
          // 테두리
          Text(
            title,
            style: TextStyle(
              fontSize: size.sp,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
                ..color = colors,
            ),
            textAlign: TextAlign.center,
          ),
          // 안쪽 채우기
          Text(
            title,
            style: TextStyle(
              fontSize: size.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
