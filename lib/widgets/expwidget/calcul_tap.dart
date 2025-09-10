import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mic/api/model/basic.dart';
import 'package:mic/widgets/pillwidget/exprate_bar.dart';

class CalculTap extends StatefulWidget {
  const CalculTap({super.key, required this.b});

  final Basic b;

  @override
  State<CalculTap> createState() => _CalcultapState();
}

class _CalcultapState extends State<CalculTap> {
  final goalcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            color: Color(0xFF1a8cbd),
            border: Border.all(color: Color(0xFF0e2e51), width: 3.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF0e6ca2),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Stack(
                      children: [
                        // 테두리
                        Text(
                          '경험치 계산기',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = Color(0xFF102441),
                          ),
                        ),
                        // 안쪽 채우기
                        Text(
                          '경험치 계산기',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFfdac28),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 5.h,
                    right: 55.w,
                    child: Row(
                      children: [
                        Transform.rotate(
                          angle: -0.2,
                          child: Image.asset(
                            'assets/images/icons/book.png',
                            width: 50.w,
                            height: 50.h,
                          ),
                        ),
                        SizedBox(width: 80.w),
                        Transform.rotate(
                          angle: 0.4,
                          child: Image.asset(
                            'assets/images/icons/exppotion.png',
                            width: 50.w,
                            height: 50.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Stack(
                      children: [
                        // 테두리
                        Text(
                          '현재 레벨:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = Color(0xFF102441),
                          ),
                        ),
                        // 안쪽 채우기
                        Text(
                          '현재 레벨:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFfbe9c2),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 80.w,
                      height: 30.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFFfbe9c2),
                        border: Border.all(
                          color: Color(0xFF0e2e51),
                          width: 2.w,
                        ),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        widget.b.characterlevel.toString(),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0e2e51),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        // 테두리
                        Text(
                          '목표 레벨:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = Color(0xFF102441),
                          ),
                        ),
                        // 안쪽 채우기
                        Text(
                          '목표 레벨:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFfbe9c2),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 80.w,
                      height: 30.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFFfbe9c2),
                        border: Border.all(
                          color: Color(0xFF0e2e51),
                          width: 2.w,
                        ),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: TextFormField(
                        controller: goalcontroller,
                        maxLength: 3,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          counterText: '',
                          border:
                              InputBorder.none, // 테두리 제거 (BoxDecoration에서 그림)
                          hintText: '목표 레벨', // 플레이스홀더
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF7f622a),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MaplestoryOTFBOLD',
                          ),
                        ),

                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        // 테두리
                        Text(
                          '현재 경험치:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = Color(0xFF102441),
                          ),
                        ),
                        // 안쪽 채우기
                        Text(
                          '현재 경험치:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFfbe9c2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: ExprateBar(
                  value: double.parse(widget.b.characterexprate) / 100,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
