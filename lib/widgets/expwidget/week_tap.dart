import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/function/expdata/week_contents.dart';
import 'package:mic/api/model/basic.dart';

class WeekTap extends StatefulWidget {
  const WeekTap({super.key, required this.b});

  final Basic b;

  @override
  State<WeekTap> createState() => _WeektapState();
}

class _WeektapState extends State<WeekTap> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        expTitle('주간 컨텐츠'),
        SizedBox(height: 10.h),
        Column(
          children: [
            weekquests(),
            SizedBox(height: 10.h),
            epicdungeon(),
          ],
        ),
      ],
    );
  }

  Container weekquests() {
    return Container(
      width: double.infinity,
      height: 200.h,
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
            child: twoTitle('아케인 리버&몬스터 파크', 15),
          ),

          SizedBox(height: 10.h),

          Expanded(
            child: ListView.builder(
              itemCount: weekquest.length,
              itemBuilder: (context, index) {
                String week = weekquest.keys.elementAt(index);
                return weekwidget(index, week);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget weekwidget(int index, String week) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        children: [
          Image.asset(weekimg[index], width: 30.w, height: 30.h),

          SizedBox(width: 10.w),

          Expanded(child: twoText('$week (Lv: ${weeklevellimit[week]})', 14)),
          SizedBox(width: 10.w),

          (widget.b.characterlevel >= weeklevellimit[week]!)
              ? Checkbox(
                  value: weekquest[week],
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
                      weekquest[week] = v ?? false;
                    });
                  },
                )
              : Container(
                  width: 42.w,
                  height: 42.h,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.disabled_by_default,
                    color: Typicalcolor.title,
                    size: 22.sp,
                  ),
                ),
        ],
      ),
    );
  }

  Container epicdungeon() {
    return Container(
      width: double.infinity,
      height: 200.h,
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
            child: twoTitle('에픽 던전', 15),
          ),
          SizedBox(height: 5.h),

          Expanded(
            child: ListView.builder(
              itemCount: epicweek.length,
              itemBuilder: (context, index) {
                String week = epicweek.keys.elementAt(index);
                return epicwidget(index + 7, week);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget epicwidget(int index, String epic) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        children: [
          Image.asset(weekimg[index], width: 30.w, height: 30.h),

          SizedBox(width: 10.w),

          Expanded(child: twoText('$epic (Lv: ${weeklevellimit[epic]})', 14)),
          SizedBox(width: 10.w),

          (widget.b.characterlevel >= weeklevellimit[epic]!)
              ? buildEpicTile(epic)
              : Container(
                  width: 42.w,
                  height: 42.h,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.disabled_by_default,
                    color: Typicalcolor.title,
                    size: 22.sp,
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildEpicTile(String epic) {
    const String kAz = "아즈모스 협곡";
    // 항상 체크박스 유지 대상
    if (epic == kAz) {
      final v = epicweek[epic] ?? false;
      return Checkbox(
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
        value: v,
        onChanged: (nv) {
          setState(() {
            epicweek[epic] = nv ?? false;
          });
        },
      );
    }

    // 나머지 3개 중 누가 선택되어 있는지 계산
    final others = epicweek.keys.where((k) => k != kAz);
    final selectedKey = others.firstWhere(
      (k) => (epicweek[k] ?? false),
      orElse: () => "",
    );
    final someoneSelected = selectedKey.isNotEmpty;

    final isMe = epic;
    final isSelectedMe = epicweek[isMe] ?? false;

    // 규칙:
    // - 아무도 선택 안 됨 → 모두 체크박스
    // - 누군가 선택 됨 → 그 사람만 체크박스, 나머지는 X
    if (!someoneSelected || isSelectedMe) {
      // 체크가 가능(보이는)한 경우
      return Checkbox(
        value: isSelectedMe,
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
        onChanged: (nv) {
          setState(() {
            if (nv == true) {
              // 자기만 true, 나머지는 false
              for (final k in others) {
                epicweek[k] = (k == isMe);
              }
            } else {
              // 해제하면 아무도 선택 안 된 상태로 복귀
              epicweek[isMe] = false;
            }
          });
        },
      );
    } else {
      // 다른 누군가가 선택되어 있으면 X 아이콘(비활성)
      return Container(
        width: 42.w,
        height: 42.h,
        alignment: Alignment.center,
        child: Icon(
          Icons.disabled_by_default,
          color: Typicalcolor.title,
          size: 22.sp,
        ),
      );
    }
  }
}
