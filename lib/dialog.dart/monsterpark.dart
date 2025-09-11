import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/datas.dart';
import 'package:mic/function/day_contents.dart';

Future<String?> monsterParkPick(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: _MosterParkDialog(),
    ),
  );
}

class _MosterParkDialog extends StatefulWidget {
  const _MosterParkDialog();

  @override
  State<_MosterParkDialog> createState() => __MosterParkDialogState();
}

class __MosterParkDialogState extends State<_MosterParkDialog> {
  @override
  Widget build(BuildContext context) {
    const cardBg = Color(0xFFFFF8E7);

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFf3d090),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더 타이틀
            Text(
              '몬스터 파크 지역',
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                color: Color(0xFF4b3f32),
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 16.h),

            // 본문 카드
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: Typicalcolor.font),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 12.h),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
                    child: SizedBox(
                      height: 300.h,
                      child: SingleChildScrollView(
                        child: SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  arcaneProifle(0),
                                  SizedBox(width: 20.w),

                                  arcaneProifle(1),
                                ],
                              ),
                              SizedBox(height: 20.h),

                              Row(
                                children: [
                                  arcaneProifle(2),
                                  SizedBox(width: 20.w),

                                  arcaneProifle(3),
                                ],
                              ),
                              SizedBox(height: 20.h),

                              Row(
                                children: [
                                  arcaneProifle(4),
                                  SizedBox(width: 20.w),

                                  arcaneProifle(5),
                                ],
                              ),
                              SizedBox(height: 20.h),

                              Row(
                                children: [
                                  arcaneProifle(6),
                                  SizedBox(width: 20.w),

                                  arcaneProifle(7),
                                ],
                              ),
                              SizedBox(height: 20.h),

                              Row(
                                children: [
                                  arcaneProifle(8),
                                  SizedBox(width: 20.w),
                                  grandisProifle(0),
                                ],
                              ),
                              SizedBox(height: 20.h),

                              Row(
                                children: [
                                  grandisProifle(1),
                                  SizedBox(width: 20.w),
                                  grandisProifle(2),
                                ],
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 오른쪽 상단 타이머 칩(고정 텍스트)
              ],
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector arcaneProifle(int index) {
    return GestureDetector(
      onTap: () {
        monsterpark['지역'] = arcane[index];
        monsterpark['이미지'] = arcaneimg[index];
        Navigator.pop(context, arcane[index]);
      },
      child: Image.asset(arcaneimg[index], width: 100.w, height: 100.h),
    );
  }

  GestureDetector grandisProifle(int index) {
    return GestureDetector(
      onTap: () {
        monsterpark['지역'] = grandis[index];
        monsterpark['이미지'] = grandisimg[index];
        Navigator.pop(context, grandis[index]);
      },
      child: Image.asset(grandisimg[index], width: 100.w, height: 100.h),
    );
  }
}
