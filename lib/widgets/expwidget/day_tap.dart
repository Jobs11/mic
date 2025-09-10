import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/dialog.dart/monsterpark.dart';
import 'package:mic/function/day_contents.dart';
import 'package:mic/api/model/basic.dart';
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
                '일일 컨텐츠 [아케인/그란디스]',
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
        Container(
          width: double.infinity,
          height: 300.h,
          decoration: BoxDecoration(
            color: Color(0xFFfdecbe),
            border: Border.all(color: Color(0xFF6a4423), width: 3.w),
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
                          return grandisday(index, key);
                        },
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: arcane.length,
                        itemBuilder: (context, index) {
                          String key = arcane[index];
                          return arcaneday(index, key);
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

  Container mosterpark() {
    return Container(
      width: double.infinity,
      height: 120.h,
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
              '몬스터 파크',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '몬스터파크 지역을 선택하세요 >>',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

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
                Expanded(
                  child: Text(
                    '몬스터파크 [${monsterpark['지역']}]',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Checkbox(
                  value: monsterpark['입장여부'],
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

  Widget arcaneday(int index, String arcane) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        children: [
          Image.asset(arcaneimg[index], width: 30.w, height: 30.h),

          SizedBox(width: 10.w),

          Expanded(
            child: Text(
              '$arcane (Lv: ${daylevellimit[arcane]})',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10.w),
          (widget.b.characterlevel >= daylevellimit[arcane]!)
              ? Checkbox(
                  value: dayquest[arcane],
                  onChanged: (v) {
                    setState(() {
                      dayquest[arcane] = v ?? false;
                    });
                  },
                )
              : Container(
                  width: 48.w,
                  height: 48.h,
                  alignment: Alignment.center,
                  child: Icon(Icons.disabled_by_default, size: 20.sp),
                ),
        ],
      ),
    );
  }

  Widget grandisday(int index, String grandis) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        children: [
          Image.asset(grandisimg[index], width: 30.w, height: 30.h),

          SizedBox(width: 10.w),

          Expanded(
            child: Text(
              '$grandis (Lv: ${daylevellimit[grandis]})',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10.w),

          (widget.b.characterlevel >= daylevellimit[grandis]!)
              ? Checkbox(
                  value: dayquest[grandis],
                  onChanged: (v) {
                    setState(() {
                      dayquest[grandis] = v ?? false;
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
}
