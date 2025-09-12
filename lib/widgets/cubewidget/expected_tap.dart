import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/function/datas.dart';

class ExpectedTap extends StatefulWidget {
  const ExpectedTap({super.key});

  @override
  State<ExpectedTap> createState() => _ExpectedTapState();
}

class _ExpectedTapState extends State<ExpectedTap> {
  final onecubecontroller = TextEditingController();
  final twocubecontroller = TextEditingController();
  final thrcubecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 440.h,
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
                  mainAxisAlignment: MainAxisAlignment.center, // 가로축 가운데
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    chooseOption('레전드리'),
                    SizedBox(width: 10.w),
                    chooseOption('방어구'),
                  ],
                ),
                SizedBox(height: 10.h),

                inputOption('보스 공격시 데미지', onecubecontroller),
                SizedBox(height: 10.h),
                inputOption('보스 공격시 데미지', twocubecontroller),
                SizedBox(height: 10.h),
                inputOption('보스 공격시 데미지', thrcubecontroller),
                SizedBox(height: 10.h),
                Container(
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
                    border: Border.all(color: Typicalcolor.border, width: 2.w),
                  ),
                  child: twoText('계산하기', 20),
                ),

                SizedBox(height: 60.h),
                expectedList(
                  '명장의 큐브',
                  'assets/images/items/commandercube.png',
                  '24 개',
                ),
                SizedBox(height: 10.h),
                expectedList(
                  '블랙 큐브',
                  'assets/images/items/blackcube.png',
                  '24 개',
                ),
                SizedBox(height: 10.h),
                expectedList('메소 재설정', 'assets/images/icons/coin1.png', '24 개'),
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
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(img, width: 20.w, height: 20.h),

              SizedBox(width: 10.w),
              twoText(title, 20),
              SizedBox(width: 10.w),
              twoText(value, 20),
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
}
