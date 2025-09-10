import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/week_contents.dart';
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
        Container(
          width: double.infinity,
          height: 40.h,
          decoration: BoxDecoration(
            color: Color(0xFFf3d090),
            border: Border.all(color: Color(0xFF6a4423), width: 3.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20.w,
                    height: 2.h,
                    decoration: BoxDecoration(color: Color(0xFF6a4423)),
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    width: 10.w,
                    height: 2.h,
                    decoration: BoxDecoration(color: Color(0xFF6a4423)),
                  ),
                ],
              ),

              Text(
                '주간 컨텐츠',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4b3f32),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 8.h),
                  Container(
                    width: 20.w,
                    height: 2.h,
                    decoration: BoxDecoration(color: Color(0xFF6a4423)),
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    width: 10.w,
                    height: 2.h,
                    decoration: BoxDecoration(color: Color(0xFF6a4423)),
                  ),
                ],
              ),
            ],
          ),
        ),
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
        color: Color(0xFFfdecbe),
        border: Border.all(color: Color(0xFF6a4423), width: 3.w),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 30.h,
            decoration: BoxDecoration(
              color: Color(0xFFfdecbe),
              border: Border.all(color: Color(0xFF6a4423), width: 3.w),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '아케인 리버&몬스터 파크',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
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

          Expanded(
            child: Text(
              '$week (Lv: ${weeklevellimit[week]})',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10.w),

          (widget.b.characterlevel >= weeklevellimit[week]!)
              ? Checkbox(
                  value: weekquest[week],
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
                    color: Color(0xFF6750a4),
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
        color: Color(0xFFfdecbe),
        border: Border.all(color: Color(0xFF6a4423), width: 3.w),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 30.h,
            decoration: BoxDecoration(
              color: Color(0xFFfdecbe),
              border: Border.all(color: Color(0xFF6a4423), width: 3.w),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '에픽 던전',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
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

          Expanded(
            child: Text(
              '$epic (Lv: ${weeklevellimit[epic]})',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10.w),

          (widget.b.characterlevel >= weeklevellimit[epic]!)
              ? buildEpicTile(epic)
              : Container(
                  width: 42.w,
                  height: 42.h,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.disabled_by_default,
                    color: Color(0xFF6750a4),
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
          color: const Color(0xFF6750a4),
          size: 22.sp,
        ),
      );
    }
  }
}
