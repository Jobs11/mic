import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/datas.dart';

class SimulatorTap extends StatefulWidget {
  const SimulatorTap({super.key});

  @override
  State<SimulatorTap> createState() => _SimulatorTapState();
}

class _SimulatorTapState extends State<SimulatorTap> {
  int equipindex = 0;
  String equipvalues = equiptype.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200.w,
          height: 240.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, // 시작점 (위쪽)
              end: Alignment.bottomCenter, // 끝점 (아래쪽)
              colors: [Color(0xFF141415), Color(0xFF999998)],
            ),
            border: Border.all(color: Color(0xFF999998), width: 2.w),
            borderRadius: BorderRadius.circular(17.r),
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
                    colors: [
                      Color(0xFF94590a), // 위쪽: 어두운 차콜
                      Color(0xFFe7b822), // 아래쪽: 연한 금색
                    ],
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  '잠재능력 옵션',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  width: 100.w,
                  height: 24.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w), // ← 전체 아이템에 적용
                      child: DropdownButton<String>(
                        value: equipvalues,
                        hint: const Text('아이템 설정'),
                        isExpanded: true,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        items: equiptype
                            .map(
                              (d) => DropdownMenuItem(value: d, child: Text(d)),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            equipindex = equiptype.indexOf(value!);
                            equipvalues = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Image.asset(equipimg[equipindex], width: 70.w, height: 70.h),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  decoration: BoxDecoration(color: Color(0xFF000000)),
                  width: double.infinity,
                  height: 2.w,
                ),
              ),
              SizedBox(height: 5.h),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cubeOption('레전드리', gradeColor['레전드리']!),
                  cubeOption('보스 공격시 데미지 40%', gradeColor['레전드리']!),
                  cubeOption('공격력 9%', gradeColor['유니크']!),
                  cubeOption('공격력 12%', gradeColor['레전드리']!),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        Container(
          width: 92.w,
          height: 92.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFF232323), // 위쪽: 어두운 차콜
                Color(0xFFFFE082), // 아래쪽: 연한 금색
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF232323), // 위쪽: 어두운 차콜
                  Color(0xFFFFE082), // 아래쪽: 연한 금색
                ],
              ),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/items/blackcube.png',
                  width: 50.w,
                  height: 50.h,
                ),
                SizedBox(height: 10.h),
                Text(
                  '재설정',
                  style: TextStyle(
                    color: Color(0xFF232323),
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Color(0x80FFFFFF),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          width: 110.w,
          height: 40.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF232323), // 위쪽: 어두운 차콜
                Color(0xFFFFE082), // 아래쪽: 연한 금색
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3B3B3B), // 위쪽: 어두운 차콜
                  Color(0xFF000000), // 아래쪽: 연한 금색
                ],
              ),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/items/blackcube.png',
                  width: 25.w,
                  height: 25.h,
                ),
                SizedBox(width: 10.w),
                Text(
                  '+1024 개',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Color(0x80FFFFFF),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          height: 40.h,
          padding: EdgeInsets.all(3), // border 두께
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF232323), // 위쪽: 어두운 차콜
                Color(0xFFFFE082), // 아래쪽: 연한 금색
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3B3B3B), // 위쪽: 어두운 차콜
                  Color(0xFF000000), // 아래쪽: 연한 금색
                ],
              ),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icons/coin.png',
                  width: 36.w,
                  height: 36.w,
                ),

                SizedBox(width: 50.w),
                Text(
                  '4,000,000,000 메소',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(children: [btnChoice('계산하기'), btnChoice('초기화')]),
      ],
    );
  }

  Container btnChoice(String title) {
    return Container(
      width: 110.w,
      height: 40.h,
      padding: EdgeInsets.all(3), // border 두께
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF232323), // 위쪽: 어두운 차콜
            Color(0xFFFFE082), // 아래쪽: 연한 금색
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3B3B3B), // 위쪽: 어두운 차콜
              Color(0xFF000000), // 아래쪽: 연한 금색
            ],
          ),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 24.sp,
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Text cubeOption(String title, Color colors) {
    return Text(
      title,
      style: TextStyle(color: colors, fontWeight: FontWeight.bold),
    );
  }
}
