import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/cube_contents.dart';
import 'package:mic/function/currentuser.dart';
import 'package:mic/function/datas.dart';

class ExpectedTap extends StatefulWidget {
  const ExpectedTap({super.key});

  @override
  State<ExpectedTap> createState() => _ExpectedTapState();
}

class _ExpectedTapState extends State<ExpectedTap> {
  int equipindex = 0;
  String equipvalues = equiptype.first;

  Map<String, dynamic> equipcube = {}; // = data['무기']
  String selectedLevel = '200'; // "200" | "250"
  Map<String, dynamic>? selectedPayload; // = weapon[selectedLevel]
  List<String> firstOptions = [];
  List<String> secondOptions = [];
  List<String> thirdOptions = [];

  String? selectFirst;
  String? selectSecond;
  String? selectThird;

  double firstchance = 0.0;
  double secondchance = 0.0;
  double thirdchance = 0.0;

  int summeso = 0;
  int sumcube = 0;

  Future<void> loadData(String equip) async {
    final jsonStr = await rootBundle.loadString(
      'assets/datas/cube_probabilities.json',
    );
    final data = jsonDecode(jsonStr);
    equipcube = Map<String, dynamic>.from(data[equip]);
    final levels = equipcube.keys.toList()..sort(); // ["200","250",...]
    selectedLevel = levels.first;
    selectedPayload = Map<String, dynamic>.from(equipcube[selectedLevel]!);

    firstOptions = (selectedPayload?['첫번째'] as List<dynamic>)
        .map((e) => e['옵션'] as String)
        .toList();

    secondOptions = (selectedPayload?['두번째'] as List<dynamic>)
        .map((e) => e['옵션'] as String)
        .toList();
    thirdOptions = (selectedPayload?['세번째'] as List<dynamic>)
        .map((e) => e['옵션'] as String)
        .toList();

    setState(() {});
  }

  void changeAll() {
    firstchance = 0.0;
    secondchance = 0.0;
    thirdchance = 0.0;
    selectFirst = null;
    selectSecond = null;
    selectThird = null;
  }

  double _chanceData(String title, String value) {
    final options = selectedPayload?[title] as List<dynamic>;
    final index = options.indexWhere((e) => e['옵션'] == value);

    return options[index]['확률'];
  }

  @override
  void initState() {
    super.initState();
    loadData(equipvalues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 450.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Typicalcolor.border, Typicalcolor.subborder],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Typicalcolor.bg, Typicalcolor.subbg],
              ),
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
                  child: twoTitle('잠재능력 옵션 입력칸', 18),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    dropsCube('아이템 설정', equipvalues, equiptype, (value) {
                      setState(() {
                        equipindex = equiptype.indexOf(value!);
                        equipvalues = value;
                        loadData(equipvalues);
                        changeAll();
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

                        changeAll();

                        firstOptions =
                            (selectedPayload?['첫번째'] as List<dynamic>)
                                .map((e) => e['옵션'] as String)
                                .toList();

                        secondOptions =
                            (selectedPayload?['두번째'] as List<dynamic>)
                                .map((e) => e['옵션'] as String)
                                .toList();
                        thirdOptions =
                            (selectedPayload?['세번째'] as List<dynamic>)
                                .map((e) => e['옵션'] as String)
                                .toList();
                      });
                    }),
                  ],
                ),
                SizedBox(height: 10.h),

                optionCube(selectFirst, '첫번째 옵션', firstOptions, (v) {
                  setState(() {
                    selectFirst = v;
                    firstchance = _chanceData('첫번째', selectFirst!);
                  });
                }),
                SizedBox(height: 10.h),
                optionCube(selectSecond, '두번째 옵션', secondOptions, (v) {
                  setState(() {
                    selectSecond = v;
                    secondchance = _chanceData('두번째', selectSecond!);
                  });
                }),
                SizedBox(height: 10.h),
                optionCube(selectThird, '세번째 옵션', thirdOptions, (v) {
                  setState(() {
                    selectThird = v;

                    thirdchance = _chanceData('세번째', selectThird!);
                  });
                }),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      sumcube = cubesForTriple99(
                        selectedPayload!,
                        first: selectFirst!,
                        second: selectSecond!,
                        third: selectThird!,
                      );
                      summeso = mesoForTriple99(
                        selectedPayload!,
                        first: selectFirst!,
                        second: selectSecond!,
                        third: selectThird!,
                        mesoPerRoll: levelmeso[int.parse(selectedLevel)]!,
                      );
                    });
                  },
                  child: Container(
                    width: 150.w,
                    height: 32.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Typicalcolor.title, Typicalcolor.subtitle],
                      ),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: Typicalcolor.border,
                        width: 2.w,
                      ),
                    ),
                    child: twoText('계산하기', 20),
                  ),
                ),

                SizedBox(height: 60.h),
                expectedList(
                  '명장의 큐브',
                  'assets/images/items/commandercube.png',
                  '-미정-',
                ),
                SizedBox(height: 10.h),
                expectedList(
                  '블랙 큐브',
                  'assets/images/items/blackcube.png',
                  '$sumcube 개',
                ),
                SizedBox(height: 10.h),
                expectedList(
                  '메소 재설정',
                  'assets/images/icons/coin1.png',
                  '${formatPower(summeso)} 메소',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget expectedList(String title, String img, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Container(
        width: double.infinity,
        height: 40.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Typicalcolor.title, Typicalcolor.subtitle],
          ),
          border: Border.all(color: Typicalcolor.border, width: 2.w),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.asset(img, width: 20.w, height: 20.h),

                  SizedBox(width: 10.w),
                  twoText(title, 13),
                ],
              ),
              twoText(value, 13),
            ],
          ),
        ),
      ),
    );
  }

  Container chooseOption(String title) {
    return Container(
      width: 90.w,
      height: 28.h,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Typicalcolor.border, Typicalcolor.subborder],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Typicalcolor.bg,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFF000000),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8.w),
            Image.asset(
              'assets/images/icons/down.png',
              width: 10.h,
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }

  Row inputOption(String title, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // 가로축 가운데
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 180.w,
          height: 28.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Typicalcolor.border, Typicalcolor.subborder],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Typicalcolor.bg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFF000000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Container(
          width: 30.w,
          height: 20.h,

          decoration: BoxDecoration(
            color: Color(0xFFf9f4ed),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: TextFormField(
            controller: controller,
            maxLength: 2,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none, // 테두리 제거 (BoxDecoration에서 그림)
              hintText: '수치', // 플레이스홀더
              hintStyle: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFF7f622a),
                fontWeight: FontWeight.bold,
                fontFamily: 'MaplestoryOTFBOLD',
              ),
            ),

            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      ],
    );
  }

  Container optionCube(
    String? value,
    String title,
    List<String> values,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      width: 250.w,
      height: 28.h,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Typicalcolor.border, Typicalcolor.subborder],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Typicalcolor.bg,
          borderRadius: BorderRadius.circular(9),
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
}
