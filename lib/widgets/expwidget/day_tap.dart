import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/dialog.dart/monsterpark.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/function/expdata/day_contents.dart';
import 'package:mic/api/model/basic.dart';
import 'package:mic/function/expdata/exp_contents.dart';
import 'package:mic/widgets/pillwidget/day_pill_two.dart';

class DayTap extends StatefulWidget {
  const DayTap({super.key, required this.b});

  final Basic b;

  @override
  State<DayTap> createState() => _DaytapState();
}

class _DaytapState extends State<DayTap> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        expTitle('일일 컨텐츠 [아케인/그란디스]'),

        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          height: 260.h,
          decoration: BoxDecoration(
            color: Typicalcolor.bg,
            border: Border.all(color: Typicalcolor.border, width: 3.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              DayPillTwo(
                value: isChecked ? SimTab.arcane : SimTab.grandis,
                onChanged: (v) =>
                    setState(() => isChecked = (v == SimTab.grandis)),
                height: 38, // 상단 여백/비율에 맞춰 조절
              ),

              SizedBox(height: 10.h),
              isChecked
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: grandis.length,
                        itemBuilder: (context, index) {
                          String key = grandis[index];
                          return areaday(key);
                        },
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: arcane
                            .where((e) => e != "셀라스, 별이 잠긴 곳")
                            .length,
                        itemBuilder: (context, index) {
                          String key = arcane
                              .where((e) => e != "셀라스, 별이 잠긴 곳")
                              .toList()[index];
                          return areaday(key);
                        },
                      ),
                    ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        mosterpark(),
      ],
    );
  }

  // 아케인/그란디스 일일 퀘스트 설정 구간
  Widget areaday(String area) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        children: [
          Image.asset(areaImages[area]!, width: 30.w, height: 30.h),

          SizedBox(width: 10.w),

          Expanded(child: twoText('$area (Lv: ${daylevellimit[area]})', 14)),
          SizedBox(width: 10.w),
          (widget.b.characterlevel >= daylevellimit[area]!)
              ? Checkbox(
                  value: dayquest[area],
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
                  onChanged: (v) {
                    setState(() {
                      dayquest[area] = v ?? false;
                    });
                  },
                )
              : Container(
                  width: 48.w,
                  height: 48.h,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.disabled_by_default,
                    color: Typicalcolor.title,
                    size: 20.sp,
                  ),
                ),
        ],
      ),
    );
  }

  // 몬스터 파크 설정 구간
  Container mosterpark() {
    return Container(
      width: double.infinity,
      height: 130.h,
      decoration: BoxDecoration(
        color: Typicalcolor.bg,
        border: Border.all(color: Typicalcolor.border, width: 3.w),
        borderRadius: BorderRadius.circular(12.r),
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
            child: twoTitle('몬스터 파크', 15),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
            child: Row(
              children: [
                Expanded(child: twoText('몬스터파크 지역을 선택하세요 >>', 12)),

                SizedBox(width: 5.w),
                GestureDetector(
                  onTap: () async {
                    final result = await monsterParkPick(context);
                    if (result != null) {
                      setState(() {
                        // result로 상태 갱신
                        // 예: 선택한 지역 저장 등
                      });
                    }
                  },
                  child: Container(
                    width: 42.w,
                    height: 25.h,
                    alignment: Alignment.center,
                    child: Image.asset(
                      monsterpark['이미지'],
                      width: 18.w,
                      height: 18.h,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
            child: Row(
              children: [
                Expanded(child: twoText('몬스터파크 [${monsterpark['지역']}]', 12)),

                Checkbox(
                  value: monsterpark['입장여부'],
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
                  onChanged: (v) {
                    setState(() {
                      monsterpark['입장여부'] = v ?? false;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
