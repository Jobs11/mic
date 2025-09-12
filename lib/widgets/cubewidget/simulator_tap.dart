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
                      btnChoice('계산하기'),
                      btnChoice('초기화'),
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

  Container optionSet() {
    return Container(
      width: 200.w,
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
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              width: 100.w,
              height: 24.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Typicalcolor.bg, // ✅ 흰색 → 배경색
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Typicalcolor.subborder),
                boxShadow: [
                  BoxShadow(
                    color: Typicalcolor.subfont.withOpacity(0.2), // ✅ 부드러운 그림자
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
                    hint: Text(
                      '아이템 설정',
                      style: TextStyle(
                        color: Typicalcolor.subfont,
                        fontSize: 14.sp,
                      ),
                    ),
                    isExpanded: true,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Typicalcolor.font, // ✅ 검정 → 폰트색
                    ),
                    items: equiptype
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
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
          Image.asset(
            equipimg[equipindex],
            width: 70.w,
            height: 70.h,
            fit: BoxFit.fill,
          ),
          SizedBox(height: 5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
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
              cubeOption('레전드리', gradeColor['레전드리']!),
              cubeOption('보스 공격시 데미지 40%', gradeColor['레전드리']!),
              cubeOption('공격력 9%', gradeColor['유니크']!),
              cubeOption('공격력 12%', gradeColor['레전드리']!),
            ],
          ),
        ],
      ),
    );
  }

  Container resetingbtn() {
    return Container(
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
          children: [
            Image.asset(
              'assets/images/items/blackcube.png',
              width: 20.w,
              height: 20.h,
            ),
            SizedBox(width: 5.w),
            twoText('+ 1024개', 14),
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
            children: [
              Image.asset(
                'assets/images/icons/coin.png',
                width: 36.w,
                height: 36.w,
              ),
              SizedBox(width: 50.w),
              twoText('4,000,000,000 메소', 16),
            ],
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
